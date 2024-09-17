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
from typing import Any

import flask


__all__ = ['url_for_self']


PYTHON_TO_RUST_ENDPOINT_NAMES = {
    'api_v1_projects': 'ApiV1Project',
    'badge_tiny_repos': 'BadgeTinyRepos',
    'badge_version_for_repo': 'BadgeVersionForRepo',
    'badge_vertical_allrepos': 'BadgeVerticalAllRepos',
    'badge_latest_versions': 'BadgeLatestVersions',
}

RUST_TO_PYTHON_ENDPOINT_NAMES = {rust: python for python, rust in PYTHON_TO_RUST_ENDPOINT_NAMES.items()}


def url_for(**args: Any) -> Any:
    if endpoint := RUST_TO_PYTHON_ENDPOINT_NAMES.get(args['endpoint']):
        args['endpoint'] = endpoint
    return flask.url_for(**args)


def url_for_self(**args: Any) -> Any:
    assert flask.request.endpoint is not None
    return flask.url_for(flask.request.endpoint, **dict(flask.request.view_args, **args))


def url_for_static(**args: Any) -> Any:
    return url_for(endpoint='static', filename=args['file'])


def needs_ipv6_notice(*variants: str) -> bool:
    now = datetime.datetime.now()
    return now.month == 6 and now.day == 6 and ':' not in flask.request.environ['REMOTE_ADDR'] and flask.request.endpoint != 'index'
