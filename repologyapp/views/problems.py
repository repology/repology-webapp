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

from typing import Optional

import flask

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.view_registry import Response


def problems_generic(repo: str, maintainer: Optional[str] = None, start: Optional[str] = None, end: Optional[str] = None) -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    problems = get_db().get_problems(
        repo=repo,
        maintainer=maintainer,
        start=start,
        end=end,
        limit=config['PROBLEMS_PER_PAGE']
    )

    first, last = get_db().get_problems_range(repo=repo, maintainer=maintainer)

    is_first_page, is_last_page = False, False
    for problem in problems:
        if problem['effname'] == first:
            is_first_page = True
        if problem['effname'] == last:
            is_last_page = True

    return flask.render_template(
        'problems.html',
        repo=repo,
        maintainer=maintainer,
        start=start,
        end=end,
        first=first,
        last=last,
        is_first_page=is_first_page,
        is_last_page=is_last_page,
        problems=problems
    )
