# Copyright (C) 2016-2017 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from repologyapp.view_registry import Response, ViewRegistrar


@ViewRegistrar('/news')
def news() -> Response:
    return flask.render_template('news.html')


@ViewRegistrar('/docs')
def docs() -> Response:
    return flask.render_template('docs/index.html')


@ViewRegistrar('/docs/about')
def docs_about() -> Response:
    return flask.render_template('docs/about.html')


@ViewRegistrar('/docs/bots')
def docs_bots() -> Response:
    return flask.render_template('docs/bots.html')


@ViewRegistrar('/docs/not_supported')
def docs_not_supported() -> Response:
    return flask.render_template('docs/not_supported.html')


@ViewRegistrar('/docs/requirements')
def docs_requirements() -> Response:
    return flask.render_template('docs/requirements.html')


@ViewRegistrar('/favicon.ico')
def favicon() -> Response:
    return flask.current_app.send_static_file('repology.v1.ico')


@ViewRegistrar('/tools')
def tools() -> Response:
    return flask.render_template('tools/index.html')
