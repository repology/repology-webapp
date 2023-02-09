# Copyright (C) 2016-2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from typing import Collection

import flask

from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.view_registry import Response, ViewRegistrar


def _get_filtered_args(wanted_args: Collection[str]) -> dict[str, str]:
    return {
        key: val
        for key, val in flask.request.args.to_dict().items()
        if key in wanted_args
    }


def _get_projects_args() -> dict[str, str]:
    return _get_filtered_args({
        'category',
        'families',
        'families_newest',
        'has_related',
        'inrepo',
        'maintainer',
        'newest',
        'notinrepo',
        'outdated',
        'problematic',
        'repos',
        'repos_newest',
        'search',
    })


@ViewRegistrar('/metapackages/all/')
@ViewRegistrar('/metapackages/all/<bound>/')
def metapackages_all(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/unique/')
@ViewRegistrar('/metapackages/unique/<bound>/')
def metapackages_unique(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, families=1, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/widespread/')
@ViewRegistrar('/metapackages/widespread/<bound>/')
def metapackages_widespread(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, families='10-', search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/in-repo/<repo>/')
@ViewRegistrar('/metapackages/in-repo/<repo>/<bound>/')
def metapackages_in_repo(repo: str, bound: str | None = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    return flask.redirect(flask.url_for('projects', bound=bound, inrepo=repo, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/outdated-in-repo/<repo>/')
@ViewRegistrar('/metapackages/outdated-in-repo/<repo>/<bound>/')
def metapackages_outdated_in_repo(repo: str, bound: str | None = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    return flask.redirect(flask.url_for('projects', bound=bound, inrepo=repo, outdated=1, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/not-in-repo/<repo>/')
@ViewRegistrar('/metapackages/not-in-repo/<repo>/<bound>/')
def metapackages_not_in_repo(repo: str, bound: str | None = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    return flask.redirect(flask.url_for('projects', bound=bound, notinrepo=repo, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/candidates-for-repo/<repo>/')
@ViewRegistrar('/metapackages/candidates-for-repo/<repo>/<bound>/')
def metapackages_candidates_for_repo(repo: str, bound: str | None = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    return flask.redirect(flask.url_for('projects', bound=bound, inrepo=repo, families='5-', search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/unique-in-repo/<repo>/')
@ViewRegistrar('/metapackages/unique-in-repo/<repo>/<bound>/')
def metapackages_unique_in_repo(repo: str, bound: str | None = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    return flask.redirect(flask.url_for('projects', bound=bound, inrepo=repo, families=1, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/by-maintainer/<maintainer>/')
@ViewRegistrar('/metapackages/by-maintainer/<maintainer>/<bound>/')
def metapackages_by_maintainer(maintainer: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, maintainer=maintainer, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/metapackages/outdated-by-maintainer/<maintainer>/')
@ViewRegistrar('/metapackages/outdated-by-maintainer/<maintainer>/<bound>/')
def metapackages_outdated_by_maintainer(maintainer: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, maintainer=maintainer, outdated=1, search=flask.request.args.to_dict().get('search')), 301)


@ViewRegistrar('/repositories/')
def legacy_repositories() -> Response:
    return flask.redirect(flask.url_for('repositories_statistics'), 301)


@ViewRegistrar('/statistics')
@ViewRegistrar('/statistics/<sorting>')
def legacy_statistics(sorting: str | None = None) -> Response:
    return flask.redirect(flask.url_for('repositories_statistics', sorting=sorting), 301)


@ViewRegistrar('/metapackage/<name>')
def metapackage(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


@ViewRegistrar('/project/<name>')
@ViewRegistrar('/project/<name>/')
def project(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


@ViewRegistrar('/metapackages/')
@ViewRegistrar('/metapackages/<bound>/')
def metapackages(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('projects', bound=bound, **_get_projects_args()), 301)


@ViewRegistrar('/metapackage/<name>/versions')
def metapackage_versions(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


@ViewRegistrar('/metapackage/<name>/packages')
def metapackage_packages(name: str) -> Response:
    return flask.redirect(flask.url_for('project_packages', name=name), 301)


@ViewRegistrar('/metapackage/<name>/information')
def metapackage_information(name: str) -> Response:
    return flask.redirect(flask.url_for('project_information', name=name), 301)


@ViewRegistrar('/metapackage/<name>/history')
def metapackage_history(name: str) -> Response:
    return flask.redirect(flask.url_for('project_history', name=name), 301)


@ViewRegistrar('/metapackage/<name>/related')
def metapackage_related(name: str) -> Response:
    return flask.redirect(flask.url_for('project_related', name=name), 301)


@ViewRegistrar('/metapackage/<name>/badges')
def metapackage_badges(name: str) -> Response:
    return flask.redirect(flask.url_for('project_badges', name=name), 301)


@ViewRegistrar('/metapackage/<name>/report', methods=['GET', 'POST'])
def metapackage_report(name: str) -> Response:
    return flask.redirect(flask.url_for('project_report', name=name), 301)


@ViewRegistrar('/api/v1/metapackages/')
@ViewRegistrar('/api/v1/metapackages/<bound>/')
def api_v1_metapackages(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, **_get_projects_args()), 301)


@ViewRegistrar('/api/v1/metapackage/<name>')
def api_v1_metapackage(name: str) -> Response:
    return flask.redirect(flask.url_for('api_v1_project', name=name), 301)


@ViewRegistrar('/api/v1/metapackages/all/')
@ViewRegistrar('/api/v1/metapackages/all/<bound>/')
def api_v1_metapackages_all(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound), 301)


@ViewRegistrar('/api/v1/metapackages/unique/')
@ViewRegistrar('/api/v1/metapackages/unique/<bound>/')
def api_v1_metapackages_unique(bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, families=1), 301)


@ViewRegistrar('/api/v1/metapackages/in-repo/<repo>/')
@ViewRegistrar('/api/v1/metapackages/in-repo/<repo>/<bound>/')
def api_v1_metapackages_in_repo(repo: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, inrepo=repo), 301)


@ViewRegistrar('/api/v1/metapackages/outdated-in-repo/<repo>/')
@ViewRegistrar('/api/v1/metapackages/outdated-in-repo/<repo>/<bound>/')
def api_v1_metapackages_outdated_in_repo(repo: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, inrepo=repo, outdated=1), 301)


@ViewRegistrar('/api/v1/metapackages/not-in-repo/<repo>/')
@ViewRegistrar('/api/v1/metapackages/not-in-repo/<repo>/<bound>/')
def api_v1_metapackages_not_in_repo(repo: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, notinrepo=repo), 301)


@ViewRegistrar('/api/v1/metapackages/candidates-in-repo/<repo>/')
@ViewRegistrar('/api/v1/metapackages/candidates-in-repo/<repo>/<bound>/')
def api_v1_metapackages_candidates_in_repo(repo: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, inrepo=repo, families='5-'), 301)


@ViewRegistrar('/api/v1/metapackages/unique-in-repo/<repo>/')
@ViewRegistrar('/api/v1/metapackages/unique-in-repo/<repo>/<bound>/')
def api_v1_metapackages_unique_in_repo(repo: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, inrepo=repo, families=1), 301)


@ViewRegistrar('/api/v1/metapackages/by-maintainer/<maintainer>/')
@ViewRegistrar('/api/v1/metapackages/by-maintainer/<maintainer>/<bound>/')
def api_v1_metapackages_by_maintainer(maintainer: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, maintainer=maintainer), 301)


@ViewRegistrar('/api/v1/metapackages/outdated-by-maintainer/<maintainer>/')
@ViewRegistrar('/api/v1/metapackages/outdated-by-maintainer/<maintainer>/<bound>/')
def api_v1_metapackages_outdated_by_maintainer(maintainer: str, bound: str | None = None) -> Response:
    return flask.redirect(flask.url_for('api_v1_projects', bound=bound, maintainer=maintainer, outdated=1), 301)


@ViewRegistrar('/graph/total/metapackages.svg')
def graph_total_metapackages() -> Response:
    return flask.redirect(flask.url_for('graph_total_projects'), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_total.svg')
def graph_repo_metapackages_total(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_total', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_newest.svg')
def graph_repo_metapackages_newest(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_newest', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_newest_percent.svg')
def graph_repo_metapackages_newest_percent(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_newest_percent', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_outdated.svg')
def graph_repo_metapackages_outdated(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_outdated', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_outdated_percent.svg')
def graph_repo_metapackages_outdated_percent(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_outdated_percent', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_unique.svg')
def graph_repo_metapackages_unique(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_unique', repo=repo), 301)


@ViewRegistrar('/graph/repo/<repo>/metapackages_unique_percent.svg')
def graph_repo_metapackages_unique_percent(repo: str) -> Response:
    return flask.redirect(flask.url_for('graph_repo_projects_unique_percent', repo=repo), 301)


@ViewRegistrar('/badge/version-only-for-repo/<repo>/<name>.svg')
def badge_version_only_for_repo(repo: str, name: str) -> Response:
    return flask.redirect(
        flask.url_for(
            'badge_version_for_repo',
            repo=repo,
            name=name,
            header='',
            minversion=flask.request.args.to_dict().get('minversion')
        ),
        301
    )


@ViewRegistrar('/maintainer/<maintainer>/problems')
def maintainer_problems_legacy(maintainer: str) -> Response:
    # actual problems listing is tied to repository+maintainer pair,
    # so determine most active repo and redirect to it

    maintainer = maintainer.lower()

    maintainer_info = get_db().get_maintainer_information(maintainer)

    if not maintainer_info or not maintainer_info['num_projects_newest_per_repo']:
        return (flask.render_template('maintainer/404.html', maintainer=maintainer), 404)

    bestrepo = max(
        (
            maintainer_info['num_projects_newest_per_repo'][repo],
            -maintainer_info['num_projects_outdated_per_repo'][repo],
            repometadata[repo]['num_metapackages_newest'],
            repo
        )
        for repo in maintainer_info['num_projects_newest_per_repo'].keys()
    )[-1]

    return flask.redirect(
        flask.url_for(
            'maintainer_problems',
            repo=bestrepo,
            maintainer=maintainer
        ),
        301
    )


@ViewRegistrar('/addrepo')
@ViewRegistrar('/docs/addrepo')
def addrepo() -> Response:
    return flask.redirect(flask.url_for('docs_requirements'), 301)


@ViewRegistrar('/about')
def about() -> Response:
    return flask.redirect(flask.url_for('docs_about'), 301)
