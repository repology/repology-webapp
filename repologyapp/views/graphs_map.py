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

import math
from dataclasses import dataclass
from typing import Any, Callable, Dict, Tuple

import flask

from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.view_registry import Response, ViewRegistrar
from repologyapp.xmlwriter import XmlDocument


def _clever_ceil(value: float) -> int:
    if value == 0:
        return 1

    tick = math.pow(10, math.ceil(math.log(value, 10) - 2))
    return int(math.ceil(value / tick) * tick)


@dataclass
class _MapPoint:
    x: float
    y: float
    text: str
    color: str


def _map_repo_generic(getx: Callable[[Dict[str, Any]], float],
                     gety: Callable[[Dict[str, Any]], float],
                     namex: str = 'X',
                     namey: str = 'Y',
                     unitx: str = '',
                     unity: str = '',
                     xlimit: int | None = None,
                     ylimit: int | None = None) -> Response:
    points = [
        _MapPoint(
            x=getx(repo),
            y=gety(repo),
            text=repometadata[repo['name']]['desc'],
            color=repometadata[repo['name']].get('color', '000000'),
        ) for repo in get_db().get_active_repositories()
    ]

    width = 1140
    height = 800

    min_x = 0
    min_y = 0
    max_x = _clever_ceil(max(map(lambda p: p.x, points))) if points else 1
    max_y = _clever_ceil(max(map(lambda p: p.y, points))) if points else 1

    if xlimit is not None:
        max_x = min(max_x, xlimit)
    if ylimit is not None:
        max_y = min(max_y, ylimit)

    doc = XmlDocument('svg', xmlns='http://www.w3.org/2000/svg', width=width, height=height)

    # define arrow marker
    with doc.tag('defs'):
        with doc.tag('marker', id='arrow', markerWidth=10, markerHeight=10, refX=2, refY=3, orient='auto', markerUnits='strokeWidth'):
            doc.tag('path', d='M0,0 L2,3 L0,6 L9,3 z', fill='#000')

    # background
    with doc.tag('rect', width=width, height=height, fill='#f0f0f0'):
        pass

    offset_left = 40
    offset_top = 30
    offset_right = 50
    offset_bottom = 20

    # axes
    doc.tag(
        'line', ('marker-end', 'url(#arrow)'),
        x1=offset_left + 0.5, x2=offset_left + 0.5,
        y1=height - offset_bottom + 0.5, y2=offset_top // 2 + 0.5,
        stroke='#000'
    )
    doc.tag(
        'line', ('marker-end', 'url(#arrow)'),
        x1=offset_left + 0.5, x2=width - offset_right // 2 + 0.5,
        y1=height - offset_bottom + 0.5, y2=height - offset_bottom + 0.5,
        stroke='#000'
    )

    # axes labels
    with doc.tag('g', ('fill', '#000'), ('font-family', 'DejaVu Sans,Verdana,Geneva,sans-serif'), ('font-size', 13), ('font-weight', 'bold'), ('text-anchor', 'middle')):
        with doc.tag('text', x=offset_left + (width - offset_right - offset_left) // 2 + 0.5, y=height - offset_bottom // 2 + 3 + 0.5):
            doc.text(namex)
        with doc.tag('text', x=0, y=0, transform=f'translate({offset_left // 2 + 0.5},{offset_top + (height - offset_top - offset_bottom) // 2 + 0.5}),rotate(-90)'):
            doc.text(namey)

    # axes ticks
    with doc.tag('g', ('fill', '#000'), ('font-family', 'DejaVu Sans,Verdana,Geneva,sans-serif'), ('font-size', 11)):
        with doc.tag('text', ('text-anchor', 'middle'), x=width - offset_right + 3 + 0.5, y=height - offset_bottom // 2 + 3 + 0.5):
            doc.text(f'{max_x}{unitx}')
        with doc.tag('text', ('text-anchor', 'middle'), x=offset_left + 0.5, y=height - offset_bottom // 2 + 0.5):
            doc.text(f'{min_x}{unitx}')
        with doc.tag('text', ('text-anchor', 'end'), x=offset_left - 5 + 0.5, y=height - offset_bottom + 3 + 0.5):
            doc.text(f'{min_y}{unity}')
        with doc.tag('text', ('text-anchor', 'end'), x=offset_left - 5 + 0.5, y=offset_top + 3 + 0.5):
            doc.text(f'{max_y}{unity}')

    # data points (labels)
    def point_coords(point: _MapPoint) -> Tuple[float, float]:
        return (
            int(offset_left + point.x / max_x * (width - offset_left - offset_right)) + 0.5,
            int(height - offset_bottom - point.y / max_y * (height - offset_top - offset_bottom)) + 0.5
        )

    with doc.tag('g', ('font-family', 'DejaVu Sans,Verdana,Geneva,sans-serif'), ('font-size', 11), ('text-anchor', 'start')):
        for point in points:
            if point.text:
                x, y = point_coords(point)
                with doc.tag('text', ('stroke-linecap', 'round'), ('stroke-width', 3), fill='#f0f0f0', stroke='#f0f0f0', x=x + 5, y=y + 3):
                    doc.text(point.text)
                with doc.tag('text', fill='#000000', x=x + 5, y=y + 3):
                    doc.text(point.text)

    # data points (points)
    for point in points:
        x, y = point_coords(point)
        doc.tag('circle', cx=x, cy=y, r=5, fill='#f0f0f0')
        doc.tag('circle', cx=x, cy=y, r=4, fill=f'#{point.color}')

    return (
        doc.render(),
        {'Content-type': 'image/svg+xml'}
    )


def _parse_limits() -> tuple[int | None, int | None]:
    args = flask.request.args.to_dict()

    def get_arg(key: str) -> int | None:
        if key in args:
            try:
                return int(args[key])
            except (TypeError, ValueError):
                pass

        return None

    return get_arg('xlimit'), get_arg('ylimit')


@ViewRegistrar('/graph/map_repo_size_fresh.svg')
def graph_map_repo_size_fresh() -> Response:
    xlimit, ylimit = _parse_limits()

    return _map_repo_generic(
        # XXX: to fix following type ignores, repometadata should be converted into dataclass
        getx=lambda repo: repo['num_metapackages'],  # type: ignore
        gety=lambda repo: repo['num_metapackages_newest'],  # type: ignore
        namex='Number of packages in repository',
        namey='Number of fresh packages in repository',
        xlimit=xlimit,
        ylimit=ylimit,
    )


@ViewRegistrar('/graph/map_repo_size_fresh_nonunique.svg')
def graph_map_repo_size_fresh_nonunique() -> Response:
    xlimit, ylimit = _parse_limits()

    return _map_repo_generic(
        getx=lambda repo: repo['num_metapackages_newest'] + repo['num_metapackages_outdated'],  # type: ignore
        gety=lambda repo: repo['num_metapackages_newest'],  # type: ignore
        namex='Number of non-unique packages in repository',
        namey='Number of fresh packages in repository',
        xlimit=xlimit,
        ylimit=ylimit,
    )


@ViewRegistrar('/graph/map_repo_size_freshness.svg')
def graph_map_repo_size_freshness() -> Response:
    xlimit, ylimit = _parse_limits()

    return _map_repo_generic(
        getx=lambda repo: repo['num_metapackages'],  # type: ignore
        gety=lambda repo: 100.0 * repo['num_metapackages_newest'] / repo['num_metapackages'] if repo['num_metapackages'] else 0.0,  # type: ignore
        namex='Number of packages in repository',
        namey='Percentage of fresh packages',
        unity='%',
        xlimit=xlimit,
        ylimit=ylimit,
    )
