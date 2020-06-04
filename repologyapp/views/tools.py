# Copyright (C) 2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from dataclasses import dataclass
from typing import Any, List

import flask

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.template_functions import url_for_self
from repologyapp.view_registry import ViewRegistrar


@dataclass
class AllowedTargetPage:
    endpoint: str
    desc: str
    args: List[str]


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

    AllowedTargetPage('api_v1_project', 'API v1 project information — /api/v1/project/<name>', ['name']),
]


_EXTRA_ALLOWED_ARGS = {
    'allow_ignored',
    'columns'
    'header',
    'minversion',
}


_ALLOWED_FAMILIES = {
    'debuntu',
    'freebsd',
}


@ViewRegistrar('/tools/project-by')
def tool_project_by() -> Any:
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
        if not repometadata[repo]['family'] in _ALLOWED_FAMILIES:
            flask.abort(403)
        elif repo not in repometadata.active_names():
            flask.abort(404)
        elif name:
            targets = []

            for project in get_db().get_projects_by_name(repo=repo, name_type=name_type, name=name):
                possible_args = {'name': project, 'repo': repo}
                real_args = {k: possible_args[k] for k in target_page.args}

                targets.append((project, flask.url_for(target_page.endpoint, **real_args)))

            if not targets:
                flask.abort(404)
            elif noautoresolve and len(targets) > 1:
                return flask.render_template(
                    'project-by-ambiguity.html',
                    targets=targets,
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
def trending() -> Any:
    return flask.render_template(
        'projects-trending.html',
        trending=get_db().get_trending_projects(60 * 60 * 24 * 31, config['TRENDING_PER_PAGE']),
        declining=get_db().get_trending_projects(60 * 60 * 24 * 91, config['TRENDING_PER_PAGE'], negative=True),
    )
