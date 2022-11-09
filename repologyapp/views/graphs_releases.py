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

import time
from dataclasses import dataclass

from repologyapp.config import config
from repologyapp.db import get_db
from repologyapp.globals import get_text_width
from repologyapp.view_registry import Response, ViewRegistrar
from repologyapp.xmlwriter import XmlDocument


@dataclass
class _Release:
    version: str
    start_ts: float
    trusted_start_ts: float | None
    end_ts: float | None


@ViewRegistrar('/graph/project/<project>/releases.svg')
def graph_releases(project: str) -> Response:
    releases = [_Release(**row) for row in get_db().get_project_releases(project)]

    row_height = 20
    bar_height_fraction = 0.75

    width = 1140
    height = row_height * len(releases)
    padding = 5
    max_fadein = 20

    max_time = time.time()
    min_time = min(min((release.start_ts for release in releases)), max_time - 1.0)

    version_column_width = padding * 2 + max((get_text_width(release.version, 13, True) for release in releases))
    time_column_width = width - version_column_width

    doc = XmlDocument('svg', xmlns='http://www.w3.org/2000/svg', width=width, height=height)

    with doc.tag('linearGradient', id='untrustedFadein', x2='100%', y2=0):
        doc.tag('stop', ('offset', 0), ('stop-color', '#9f9f9f'), ('stop-opacity', 0))
        doc.tag('stop', ('offset', 1), ('stop-color', '#9f9f9f'), ('stop-opacity', 1))

    with doc.tag('linearGradient', id='trustedFadein', x2='100%', y2=0):
        doc.tag('stop', ('offset', 0), ('stop-color', '#e05d44'), ('stop-opacity', 0))
        doc.tag('stop', ('offset', 1), ('stop-color', '#e05d44'), ('stop-opacity', 1))

    doc.tag('line', x1=time_column_width + 0.5, x2=time_column_width + 0.5, y1=0, y2=height, stroke='#00000040')

    def draw_bar(left: float, right: float | None, trusted: bool) -> None:
        left_frac = (left - min_time) / (max_time - min_time)
        right_frac = (right - min_time) / (max_time - min_time) if right is not None else 1.0

        fillname = '#e05d44' if trusted else '#9f9f9f'

        x = left_frac * time_column_width
        width = (right_frac - left_frac) * time_column_width
        y = nrow * row_height + row_height * (1.0 - bar_height_fraction) / 2 + 0.5
        height = row_height * bar_height_fraction

        if left < config['HISTORY_CUTOFF_TIMESTAMP']:
            fadein_fillname = 'url(#trustedFadein)' if trusted else 'url(#untrustedFadein)'

            if width < max_fadein:
                # bar too small for separate fadein part, so just fill whole bar with gradient
                fillname = fadein_fillname
            else:
                # draw separated fadein part
                doc.tag('rect', x=x, width=max_fadein, y=y, height=height, fill=fadein_fillname)
                x += max_fadein
                width -= max_fadein

        doc.tag('rect', x=x, width=width, y=y, height=height, fill=fillname)

    for nrow, release in enumerate(releases):
        with doc.tag('g', ('fill', '#000'), ('font-family', 'DejaVu Sans,Verdana,Geneva,sans-serif'), ('font-size', 13), ('font-weight', 'bold'), ('text-anchor', 'left')):
            with doc.tag('text', x=time_column_width + padding + 0.5, y=nrow * row_height + row_height // 2 + 5 + 0.5):
                doc.text(release.version)

        if release.trusted_start_ts is not None:
            draw_bar(release.trusted_start_ts, release.end_ts, True)

            if release.trusted_start_ts != release.start_ts:
                draw_bar(release.start_ts, release.trusted_start_ts, False)
        else:
            draw_bar(release.start_ts, release.end_ts, False)

        if nrow > 0:
            doc.tag('line', x1=0, x2=width, y1=nrow * row_height + 0.5, y2=nrow * row_height + 0.5, stroke='#00000040')

    return (
        doc.render(),
        {'Content-type': 'image/svg+xml'}
    )
