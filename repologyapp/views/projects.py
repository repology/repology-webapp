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

from typing import Any

import flask

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.metapackage_request import MetapackageRequest
from repologyapp.metapackages import MetapackagesFilterInfo, get_packages_name_range, packages_to_summary_items
from repologyapp.package import PackageDataSummarizable
from repologyapp.view_registry import Response, ViewRegistrar


@ViewRegistrar('/projects/')
@ViewRegistrar('/projects/<bound>/')
def projects(bound: str | None = None) -> Response:
    # process search
    filterinfo = MetapackagesFilterInfo()
    filterinfo.parse_flask_args()

    request = filterinfo.get_request()
    request.set_bound(bound)

    # get packages
    def get_packages(request: MetapackageRequest) -> tuple[dict[str, dict[str, Any]], list[PackageDataSummarizable]]:
        metapackages = get_db().query_metapackages(
            **request.__dict__,
            limit=config['METAPACKAGES_PER_PAGE'],
        )

        packages = [
            PackageDataSummarizable(**item)
            for item in get_db().get_metapackages_packages(
                list(metapackages.keys()),
                summarizable=True
            )
        ]

        return metapackages, packages

    metapackages, packages = get_packages(request)

    # on empty result, fallback to show first, last set of results
    if not packages:
        request = filterinfo.get_request()
        if bound and bound.startswith('..'):
            request.require_name_to(None)
        metapackages, packages = get_packages(request)

    firstname, lastname = get_packages_name_range(packages)

    metapackagedata = packages_to_summary_items(packages, filterinfo.get_repo(), filterinfo.get_maintainer())

    return flask.render_template(
        'projects/index.html',
        firstname=firstname,
        lastname=lastname,
        search=filterinfo.get_dict(),
        advanced=filterinfo.is_advanced(),
        metapackages=metapackages,
        metapackagedata=metapackagedata,
        repo=filterinfo.get_repo(),
        maintainer=filterinfo.get_maintainer()
    )
