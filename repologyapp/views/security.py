# Copyright (C) 2021 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

import flask

from repologyapp.cache import cache
from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.view_registry import Response, ViewRegistrar


@ViewRegistrar('/security/recent-cves')
def security_recent_cves() -> Response:
    autorefresh = flask.request.args.to_dict().get('autorefresh')

    return flask.render_template(
        'security/recent-cves.html',
        cves=cache(
            'recent-cves',
            lambda: get_db().get_recent_cves(  # type: ignore  # https://github.com/python/mypy/issues/9590
                max_age=datetime.timedelta(days=config['RECENT_CVES_MAX_AGE_DAYS']),
                limit=config['RECENT_CVES_MAX_COUNT']
            )
        ),
        autorefresh=autorefresh
    )


@ViewRegistrar('/security/recent-cpes')
def security_recent_cpes() -> Response:
    autorefresh = flask.request.args.to_dict().get('autorefresh')

    return flask.render_template(
        'security/recent-cpes.html',
        cpes=get_db().get_recent_cpes(limit=config['RECENT_CPES_MAX_COUNT']),
        autorefresh=autorefresh
    )
