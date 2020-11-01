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

import flask

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.view_registry import Response, ViewRegistrar


_MAX_URLS_PER_SITEMAP = 50000
_PAGES_PER_PROJECT = 4


@ViewRegistrar('/sitemaps/index.xml')
def sitemap_index() -> Response:
    num_projects = get_db().get_active_projects_count(minspread=config['SITEMAP_PROJECTS_MIN_SPREAD'])

    return flask.render_template(
        'sitemaps/index.xml',
        num_projects_pages=(num_projects * _PAGES_PER_PROJECT + _MAX_URLS_PER_SITEMAP - 1) // _MAX_URLS_PER_SITEMAP,
    ), {'Content-type': 'application/xml'}


@ViewRegistrar('/sitemaps/main.xml')
def sitemap_main() -> Response:
    return flask.render_template('sitemaps/main.xml'), {'Content-type': 'application/xml'}


@ViewRegistrar('/sitemaps/repositories.xml')
def sitemap_repositories() -> Response:
    return flask.render_template(
        'sitemaps/repositories.xml',
        repositories=get_db().get_active_repositories_names(limit=_MAX_URLS_PER_SITEMAP)
    ), {'Content-type': 'application/xml'}


@ViewRegistrar('/sitemaps/maintainers.xml')
def sitemap_maintainers() -> Response:
    return flask.render_template(
        'sitemaps/maintainers.xml',
        maintainers=get_db().get_active_maintainers_names(limit=_MAX_URLS_PER_SITEMAP)
    ), {'Content-type': 'application/xml'}


@ViewRegistrar('/sitemaps/projects_<int:page>.xml')
def sitemap_projects(page: int) -> Response:
    projects = get_db().get_active_projects_names(
        minspread=config['SITEMAP_PROJECTS_MIN_SPREAD'],
        offset=page * _MAX_URLS_PER_SITEMAP // _PAGES_PER_PROJECT,
        limit=_MAX_URLS_PER_SITEMAP // _PAGES_PER_PROJECT
    )

    if not projects:
        flask.abort(404)

    return flask.render_template(
        'sitemaps/projects.xml',
        projects=projects,
    ), {'Content-type': 'application/xml'}
