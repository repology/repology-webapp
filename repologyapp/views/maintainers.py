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
from dataclasses import dataclass

import flask

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.feed_helpers import unicalize_feed_timestamps
from repologyapp.globals import repometadata
from repologyapp.view_registry import Response, ViewRegistrar
from repologyapp.views.problems import problems_generic


@ViewRegistrar('/maintainers/')
@ViewRegistrar('/maintainers/<bound>/')
def maintainers(bound: str | None = None) -> Response:
    reverse = False
    if bound and bound.startswith('..'):
        bound = bound[2:]
        reverse = True
    elif bound and bound.endswith('..'):
        bound = bound[:-2]

    search = flask.request.args.to_dict().get('search')
    search = None if search is None else search.strip().lower()

    minmaintainer, maxmaintainer = get_db().get_maintainers_range()

    maintainers = get_db().query_maintainers(bound, reverse, search, config['MAINTAINERS_PER_PAGE'])

    for maintainer in maintainers:
        bestrepo = max(
            (
                maintainer['num_projects_newest_per_repo'][repo],
                -maintainer['num_projects_outdated_per_repo'][repo],
                repometadata[repo]['num_metapackages_newest'],
                repo
            )
            for repo in maintainer['num_projects_newest_per_repo'].keys()
        )[-1]

        maintainer['bestrepo'] = bestrepo
        maintainer['bestrepo_num_projects'] = maintainer['num_projects_per_repo'][bestrepo]
        maintainer['bestrepo_num_projects_newest'] = maintainer['num_projects_newest_per_repo'][bestrepo]
        maintainer['bestrepo_num_projects_outdated'] = maintainer['num_projects_outdated_per_repo'][bestrepo]
        maintainer['bestrepo_num_projects_problematic'] = maintainer['num_projects_problematic_per_repo'][bestrepo]
        maintainer['bestrepo_num_projects_vulnerable'] = maintainer['num_projects_vulnerable_per_repo'][bestrepo]

    firstpage, lastpage = False, False
    for maintainer in maintainers:
        if maintainer['maintainer'] == minmaintainer:
            firstpage = True
        if maintainer['maintainer'] == maxmaintainer:
            lastpage = True

    return flask.render_template(
        'maintainers/index.html',
        search=search,
        minmaintainer=minmaintainer,
        maxmaintainer=maxmaintainer,
        firstpage=firstpage,
        lastpage=lastpage,
        maintainers=maintainers
    )


@ViewRegistrar('/maintainer/<maintainer>')
def maintainer(maintainer: str) -> Response:
    maintainer = maintainer.lower()

    maintainer_info = get_db().get_maintainer_information(maintainer)

    if not maintainer_info:
        return (flask.render_template('maintainer/404.html', maintainer=maintainer, maintainer_info=maintainer_info), 404)
    elif maintainer_info['num_packages'] == 0:
        # HTTP code is intentionally 404
        return (flask.render_template('maintainer/410.html', maintainer=maintainer, maintainer_info=maintainer_info), 404)

    metapackages = get_db().get_maintainer_metapackages(maintainer, 500)
    similar_maintainers = get_db().get_maintainer_similar_maintainers(maintainer, 50)

    @dataclass
    class RepositoryInfo:
        repo: str
        num_packages: int
        num_projects: int
        num_projects_newest: int
        num_projects_outdated: int
        num_projects_problematic: int
        num_projects_vulnerable: int

    per_repo_info = [
        RepositoryInfo(
            repo=repo,
            num_packages=maintainer_info['num_packages_per_repo'][repo],
            num_projects=maintainer_info['num_projects_per_repo'][repo],
            num_projects_newest=maintainer_info['num_projects_newest_per_repo'][repo],
            num_projects_outdated=maintainer_info['num_projects_outdated_per_repo'][repo],
            num_projects_problematic=maintainer_info['num_projects_problematic_per_repo'][repo],
            num_projects_vulnerable=maintainer_info['num_projects_vulnerable_per_repo'][repo],
        )
        for repo in maintainer_info['num_projects_per_repo'].keys()
    ]

    per_repo_info = sorted(per_repo_info, key=lambda repoinfo: (repoinfo.num_projects_newest, -repoinfo.num_projects_outdated), reverse=True)

    if maintainer_info['num_projects_per_category']:
        maintainer_info['num_projects_per_category'] = [
            (num, name)
            for name, num in maintainer_info['num_projects_per_category'].items()
        ]

    return flask.render_template(
        'maintainer.html',
        maintainer=maintainer,
        maintainer_info=maintainer_info,
        per_repo_info=per_repo_info,
        metapackages=metapackages,
        similar_maintainers=similar_maintainers
    )


@ViewRegistrar('/maintainer/<maintainer>/problems-for-repo/<repo>')
def maintainer_problems(maintainer: str, repo: str) -> Response:
    return problems_generic(
        repo=repo,
        maintainer=maintainer.lower(),
        start=flask.request.args.to_dict().get('start'),
        end=flask.request.args.to_dict().get('end')
    )


@ViewRegistrar('/maintainer/<maintainer>/feed-for-repo/<repo>')
def maintainer_repo_feed(maintainer: str, repo: str) -> Response:
    autorefresh = flask.request.args.to_dict().get('autorefresh')

    return flask.render_template(
        'maintainer/repo-feed.html',
        maintainer=maintainer,
        repo=repo,
        history=unicalize_feed_timestamps(
            get_db().get_maintainer_feed(
                maintainer=maintainer,
                repo=repo,
                limit=config['HTML_FEED_MAX_ENTRIES']
            )
        ),
        autorefresh=autorefresh
    )


@ViewRegistrar('/maintainer/<maintainer>/feed-for-repo/<repo>/atom')
def maintainer_repo_feed_atom(maintainer: str, repo: str) -> Response:
    return (
        flask.render_template(
            'atom-feeds/maintainer/repo-feed.xml',
            maintainer=maintainer,
            repo=repo,
            history=unicalize_feed_timestamps(
                get_db().get_maintainer_feed(
                    maintainer=maintainer,
                    repo=repo,
                    limit=config['ATOM_FEED_MAX_ENTRIES'],
                    max_age=datetime.timedelta(days=config['ATOM_FEED_MAX_AGE_DAYS']),
                    min_count=config['ATOM_FEED_MIN_ENTRIES']
                )
            )
        ),
        {'Content-type': 'application/atom+xml'}
    )
