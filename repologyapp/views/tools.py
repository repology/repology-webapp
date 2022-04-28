# Copyright (C) 2020-2022 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

import json
from dataclasses import dataclass
from datetime import timedelta
from enum import Enum
from typing import List

import flask

from repologyapp.cache import cache
from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.template_functions import url_for_self
from repologyapp.view_registry import Response, ViewRegistrar


class EndpointType(Enum):
    HTML = 1
    JSON = 2


@dataclass
class AllowedTargetPage:
    endpoint: str
    desc: str
    args: List[str]
    type_: EndpointType = EndpointType.HTML


_ALLOWED_TARGET_PAGES = [
    AllowedTargetPage('project_versions', 'Project versions — /project/<name>/versions', ['name']),
    AllowedTargetPage('project_packages', 'Project packages — /project/<name>/packages', ['name']),
    AllowedTargetPage('project_information', 'Project information — /project/<name>/information', ['name']),
    AllowedTargetPage('project_history', 'Project history — /project/<name>/history', ['name']),
    AllowedTargetPage('project_badges', 'Project badges — /project/<name>/badges', ['name']),
    AllowedTargetPage('project_reports', 'Project reports — /project/<name>/reports', ['name']),

    AllowedTargetPage('badge_vertical_allrepos', 'Vertical badge — /badge/vertical-allrepos/<name>.svg', ['name']),
    AllowedTargetPage('badge_tiny_repos', 'Tiny badge with number of repositories — /badge/tiny-repos/<name>.svg', ['name']),
    AllowedTargetPage('badge_latest_versions', 'Tiny badge with latest packaged version(s) — /badge/tiny-versions/<name>.svg', ['name']),

    # XXX: repo argument for badge clashes with the repo argument for redirect
    # pro: it automatically handles the argument
    # con: it's not possible to reference badge for another repository
    # Probably in future we'll need more elaborate mechanism of
    # passing parameters for redirect target, such as a namespace (repo=...&target:repo=...)
    AllowedTargetPage('badge_version_for_repo', 'Tiny badge with version for this repository — /badge/version-for-repo/<repo>/<name>.svg', ['name', 'repo']),

    AllowedTargetPage('api_v1_project', 'API v1 project information — /api/v1/project/<name>', ['name'], EndpointType.JSON),
]


_EXTRA_ALLOWED_ARGS = {
    'allow_ignored',
    'columns'
    'header',
    'minversion',
}


_ALLOWED_FAMILIES = {
    'adelie',
    'alpine',
    'centos',
    'debuntu',
    'fedora',
    'freebsd',
    'gentoo',
    'guix',
    'homebrew',
    'homebrew_casks',
    'scoop',
    'sisyphus',
}


@ViewRegistrar('/tools/project-by')
def tool_project_by() -> Response:
    repo = flask.request.args.get('repo')
    name_type = flask.request.args.get('name_type')
    name = flask.request.args.get('name')
    noautoresolve = bool(flask.request.args.get('noautoresolve'))

    target_page = None

    for allowed_target_page in _ALLOWED_TARGET_PAGES:
        if allowed_target_page.endpoint == flask.request.args.get('target_page'):
            target_page = allowed_target_page
            break

    template_url = None

    if repo and name_type and target_page:
        if repo not in repometadata.active_names():
            return (flask.render_template('project-by-failed.html', reason='no_repo'), 404)
        elif not repometadata[repo]['family'] in _ALLOWED_FAMILIES:
            return (flask.render_template('project-by-failed.html', reason='disallowed_repo'), 403)
        elif name:
            targets = []

            for project in get_db().get_projects_by_name(repo=repo, name_type=name_type, name=name):
                possible_args = {'name': project, 'repo': repo}
                real_args = {k: possible_args[k] for k in target_page.args}

                targets.append((project, flask.url_for(target_page.endpoint, **real_args)))

            if not targets:
                return (flask.render_template('project-by-failed.html', reason='no_package'), 404)
            elif noautoresolve and len(targets) > 1:
                if target_page.type_ == EndpointType.JSON:
                    return (
                        json.dumps(
                            {
                                '_comment': 'Ambiguous redirect, multiple target projects are possible',
                                'targets': {
                                    project: url for project, url in targets
                                }
                            }
                        ),
                        300,
                        {'Content-type': 'application/json'},
                    )
                else:
                    return (
                        flask.render_template(
                            'project-by-ambiguity.html',
                            targets=targets,
                        ),
                        300
                    )
            else:
                return flask.redirect(targets[0][1], 302)
        else:
            args = {k: v for k, v in flask.request.args.items() if k in _EXTRA_ALLOWED_ARGS | {'repo', 'name_type', 'noautoresolve', 'target_page'}}
            template_url = url_for_self(**args)

    return flask.render_template(
        'project-by.html',
        allowed_target_pages=_ALLOWED_TARGET_PAGES,
        template_url=template_url,
        allowed_families=_ALLOWED_FAMILIES,
    )


@ViewRegistrar('/tools/trending')
def trending() -> Response:
    return flask.render_template(
        'projects-trending.html',
        trending=cache(
            'trending-positive',
            lambda: get_db().get_trending_projects(  # type: ignore  # https://github.com/python/mypy/issues/9590
                timedelta(days=31),
                config['TRENDING_PER_PAGE']
            )
        ),
        declining=cache(
            'trending-negative',
            lambda: get_db().get_trending_projects(  # type: ignore  # https://github.com/python/mypy/issues/9590
                timedelta(days=91),
                config['TRENDING_PER_PAGE'],
                negative=True
            )
        ),
    )


@ViewRegistrar('/tools/important_updates')
def important_updates() -> Response:
    return flask.render_template(
        'tools/important-updates.html',
        updates=cache(
            'recent-updates-1d-100',
            lambda: get_db().get_important_updates(  # type: ignore  # https://github.com/python/mypy/issues/9590
                timedelta(days=1),
                100
            )
        )
    )
