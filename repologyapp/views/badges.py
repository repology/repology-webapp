# Copyright (C) 2016-2019 Dmitry Marakasov <amdmi3@amdmi3.ru>
#
# This file is part of repology
#
# repology is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# repology is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with repology.  If not, see <http://www.gnu.org/licenses/>.

import datetime
import re
from collections import defaultdict
from functools import cmp_to_key
from itertools import zip_longest
from typing import Any

import flask

from libversion import version_compare

from repologyapp.badges import BadgeCell, badge_color, render_generic_badge
from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.package import PackageDataMinimal, PackageStatus
from repologyapp.packageproc import packageset_to_best, packageset_to_best_by_repo
from repologyapp.view_registry import Response, ViewRegistrar


class RepositoryFilter:
    _exclude_sources: set[str]
    _exclude_unsupported: bool

    def __init__(self, args: dict[str, Any]) -> None:
        self._exclude_sources = set(args.get('exclude_sources', '').split(','))
        self._exclude_unsupported = bool(args.get('exclude_unsupported', False))

    def check(self, reponame: str) -> bool:
        if repometadata[reponame]['type'] in self._exclude_sources:
            return False

        if (valid_till := repometadata[reponame].get('valid_till')) is not None and self._exclude_unsupported:
            if datetime.date.today() > datetime.date(*map(int, valid_till.split('-'))):
                return False

        return True


@ViewRegistrar('/badge/vertical-allrepos/<name>.svg')
def badge_vertical_allrepos(name: str) -> Response:
    args = flask.request.args.to_dict()

    best_pkg_by_repo = packageset_to_best_by_repo(
        (
            PackageDataMinimal(**item)
            for item in get_db().get_metapackage_packages(name, minimal=True)
        ),
        allow_ignored=args.get('allow_ignored', False)
    )

    header = args.get('header')
    minversion = args.get('minversion')
    try:
        minwidth = max(60, int(args.get('minwidth')))
    except:
        minwidth = 60

    repo_filter = RepositoryFilter(args)

    cells = []

    for reponame in repometadata.active_names():
        if not repo_filter.check(reponame):
            continue

        if reponame in best_pkg_by_repo:
            version = best_pkg_by_repo[reponame].version
            versionclass = best_pkg_by_repo[reponame].versionclass
            unsatisfying = minversion and version_compare(version, minversion) < 0

            color = badge_color(versionclass, unsatisfying)

            cells.append([
                BadgeCell(repometadata[reponame]['desc'], align='r'),
                BadgeCell(version, color=color, truncate=13, minwidth=minwidth)
            ])

    try:
        columns = min(
            int(args.get('columns', '1')),
            len(cells)
        )
    except:
        columns = 1

    if columns > 1:
        chunks = []
        columnsize = (len(cells) + columns - 1) // columns
        for column in range(columns):
            chunks.append(cells[column * columnsize:column * columnsize + columnsize])

        empty_filler = [BadgeCell(''), BadgeCell('')]

        cells = [sum(cells, []) for cells in zip_longest(*chunks, fillvalue=empty_filler)]

    if header is None:
        header = 'Packaging status' if cells else 'No known packages'

    return render_generic_badge(cells, header=header)


@ViewRegistrar('/badge/tiny-repos/<name>.svg')
def badge_tiny_repos(name: str) -> Response:
    return render_generic_badge([[
        BadgeCell(flask.request.args.to_dict().get('header', 'in repositories'), collapsible=True),
        BadgeCell(str(get_db().get_metapackage_families_count(name)), '#007ec6'),
    ]])


@ViewRegistrar('/badge/version-for-repo/<repo>/<name>.svg')
def badge_version_for_repo(repo: str, name: str) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    args = flask.request.args.to_dict()

    best_package = packageset_to_best(
        (
            PackageDataMinimal(**item)
            for item in get_db().get_metapackage_packages(name, repo=repo, minimal=True)
        ),
        allow_ignored=args.get('allow_ignored', False)
    )

    left_cell = BadgeCell(flask.request.args.to_dict().get('header', repometadata[repo]['singular']), collapsible=True)

    if best_package is None:
        # Note: it would be more correct to return 404 with content here,
        # but some browsers (e.g. Firefox) won't display the image in that case
        right_cell = BadgeCell('-')
    else:
        minversion = flask.request.args.to_dict().get('minversion')
        unsatisfying = minversion and version_compare(best_package.version, minversion) < 0

        right_cell = BadgeCell(best_package.version, badge_color(best_package.versionclass, unsatisfying), truncate=20)

    return render_generic_badge([[left_cell, right_cell]])


@ViewRegistrar('/badge/latest-versions/<name>.svg')
def badge_latest_versions(name: str) -> Response:
    versions = sorted(set((
        package['version']
        for package in get_db().get_metapackage_packages(name, fields=['version', 'versionclass'])
        if package['versionclass'] in (PackageStatus.NEWEST, PackageStatus.DEVEL, PackageStatus.UNIQUE)
    )), key=cmp_to_key(version_compare), reverse=True)

    default_caption = 'latest packaged version'

    if len(versions) > 1:
        default_caption += 's'
        text = ', '.join(versions)
    elif versions:
        text = versions[0]
    else:
        text = '-'

    caption = flask.request.args.to_dict().get('header', default_caption)

    return render_generic_badge([[
        BadgeCell(caption, collapsible=True),
        BadgeCell(text, '#007ec6'),
    ]])


@ViewRegistrar('/badge/versions-matrix.svg')
def badge_versions_matrix() -> Response:
    args = flask.request.args.to_dict()

    header = args.get('header')

    # parse requirements
    required_projects: dict[str, tuple[str, str] | None] = {}

    for project in args.get('projects', '').split(','):
        match = re.fullmatch('(.*?)(>=?|<=?)(.*?)', project)
        if match is not None:
            required_projects[match.group(1)] = (match.group(2), match.group(3))
        else:
            required_projects[project] = None

    required_repos = set(args.get('repos').split(',')) if 'repos' in args else None

    require_all = args.get('require_all', False)

    repo_filter = RepositoryFilter(args)

    # get and process packages
    packages = [
        PackageDataMinimal(**item)
        for item in get_db().get_metapackages_packages(
            list(required_projects.keys()),
            minimal=True
        )
    ]

    packages_by_project: dict[str, list[PackageDataMinimal]] = defaultdict(list)
    repos = set()
    for package in packages:
        packages_by_project[package.effname].append(package)
        repos.add(package.repo)

    best_packages_by_project = {effname: packageset_to_best_by_repo(packages) for effname, packages in packages_by_project.items()}

    if required_repos is not None:
        repos = repos & required_repos

    # construct table
    cells = [[BadgeCell()]]

    for name in required_projects.keys():
        cells[0].append(BadgeCell(name))

    for reponame in repometadata.sorted_active_names(repos):
        if not repo_filter.check(reponame):
            continue

        row = [BadgeCell(repometadata[reponame]['desc'], align='r')]

        for effname, restriction in required_projects.items():
            if effname not in best_packages_by_project or reponame not in best_packages_by_project[effname]:
                # project not found in repo
                row.append(BadgeCell('-'))

                if require_all:
                    break
                else:
                    continue

            package = best_packages_by_project[effname][reponame]
            unsatisfying = False

            if restriction is not None:
                if restriction[0] == '>':
                    unsatisfying = version_compare(package.version, restriction[1]) <= 0
                elif restriction[0] == '>=':
                    unsatisfying = version_compare(package.version, restriction[1]) < 0
                elif restriction[0] == '<':
                    unsatisfying = version_compare(package.version, restriction[1]) >= 0
                elif restriction[0] == '<=':
                    unsatisfying = version_compare(package.version, restriction[1]) > 0

            color = badge_color(package.versionclass, unsatisfying)

            row.append(BadgeCell(package.version, color=color, truncate=13, minwidth=60))
        else:
            cells.append(row)

    return render_generic_badge(cells, header=header)


@ViewRegistrar('/badge/repository-big/<repo>.svg')
def badge_repository_big(repo: str) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    args = flask.request.args.to_dict()
    header = args.get('header')

    if header is None:
        header = 'Repository status'

    data = get_db().get_repository_information(repo)

    total = data['num_metapackages']
    comparable = data['num_metapackages_comparable']

    if total == 0:
        cells = [
            [
                BadgeCell('Projects total', align='r'),
                BadgeCell(total),
            ]
        ]
    else:
        cells = [
            [
                BadgeCell('Projects total', align='r'),
                BadgeCell(total),
                BadgeCell(),
            ],
            [
                BadgeCell('Up to date', align='r'),
                BadgeCell(data['num_metapackages_newest'], color=badge_color(PackageStatus.NEWEST)),
                BadgeCell('{:.2f}%'.format(100.0 * data['num_metapackages_newest'] / comparable) if comparable else '-', color=badge_color(PackageStatus.NEWEST)),
            ],
            [
                BadgeCell('Outdated', align='r'),
                BadgeCell(data['num_metapackages_outdated'], color=badge_color(PackageStatus.OUTDATED)),
                BadgeCell('{:.2f}%'.format(100.0 * data['num_metapackages_outdated'] / comparable) if comparable else '-', color=badge_color(PackageStatus.OUTDATED)),
            ],
            [
                BadgeCell('Vulnerable', align='r'),
                BadgeCell(data['num_metapackages_vulnerable'], color='#e00000'),
                BadgeCell('{:.2f}%'.format(100.0 * data['num_metapackages_vulnerable'] / total), color='#e00000'),
            ],
            [
                BadgeCell('Bad versions', align='r'),
                BadgeCell(data['num_metapackages_problematic'], color='#9f9f9f'),
                BadgeCell('{:.2f}%'.format(100.0 * data['num_metapackages_problematic'] / total), color='#9f9f9f'),
            ],
        ]

        if data['num_maintainers']:
            cells.append([
                BadgeCell('Maintainers', align='r'),
                BadgeCell(data['num_maintainers']),
                BadgeCell(),
            ])

    return render_generic_badge(cells, header=header)
