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

import datetime
from typing import Any, Callable

import flask

from repologyapp.db import get_db
from repologyapp.globals import repometadata
from repologyapp.graphprocessor import GraphProcessor
from repologyapp.math import safe_percent
from repologyapp.view_registry import Response, ViewRegistrar


def graph_generic(getgraph: Callable[[int], GraphProcessor], color: str, suffix: str = '') -> Response:
    # use autoscaling until history is filled
    numdays = 21
    width = 1140
    height = 400
    gwidth = width - 50
    gheight = height - 20
    period = 60 * 60 * 24 * numdays

    graph = getgraph(period)

    return (
        flask.render_template(
            'graph.svg',
            width=width,
            height=height,
            gwidth=gwidth,
            gheight=gheight,
            points=graph.get_points(period),
            yticks=graph.get_y_ticks(suffix),
            color=color,
            numdays=numdays,
            x=lambda x: int((1.0 - x) * gwidth) + 0.5,
            y=lambda y: int(10.0 + (1.0 - y) * (gheight - 20.0)) + 0.5,
        ),
        {'Content-type': 'image/svg+xml'}
    )


def graph_repo_generic(repo: str, getvalue: Callable[[Any], float], color: str, suffix: str = '') -> Response:
    if repo not in repometadata.active_names():
        flask.abort(404)

    def get_graph(period: int) -> GraphProcessor:
        graph = GraphProcessor()

        for histentry in get_db().get_repository_history_since(repo, datetime.timedelta(seconds=period)):
            try:
                graph.add_point(histentry['timedelta'], getvalue(histentry['snapshot']))
            except:
                pass  # ignore missing keys, division errors etc.

        return graph

    return graph_generic(get_graph, color, suffix)


def graph_total_generic(getvalue: Callable[[Any], float], color: str, suffix: str = '') -> Response:
    def get_graph(period: int) -> GraphProcessor:
        graph = GraphProcessor()

        for histentry in get_db().get_statistics_history_since(datetime.timedelta(seconds=period)):
            try:
                graph.add_point(histentry['timedelta'], getvalue(histentry['snapshot']))
            except:
                pass  # ignore missing keys, division errors etc.

        return graph

    return graph_generic(get_graph, color, suffix)


@ViewRegistrar('/graph/repo/<repo>/projects_total.svg')
def graph_repo_projects_total(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages'], '#000000')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_newest.svg')
def graph_repo_projects_newest(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_newest'], '#5cb85c')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_newest_percent.svg')
def graph_repo_projects_newest_percent(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: safe_percent(s['num_metapackages_newest'], s['num_metapackages_newest'] + s['num_metapackages_outdated']), '#5cb85c', '%')


@ViewRegistrar('/graph/repo/<repo>/projects_outdated.svg')
def graph_repo_projects_outdated(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_outdated'], '#d9534f')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_outdated_percent.svg')
def graph_repo_projects_outdated_percent(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: safe_percent(s['num_metapackages_outdated'], s['num_metapackages_newest'] + s['num_metapackages_outdated']), '#d9534f', '%')


@ViewRegistrar('/graph/repo/<repo>/projects_unique.svg')
def graph_repo_projects_unique(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_unique'], '#5bc0de')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_unique_percent.svg')
def graph_repo_projects_unique_percent(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_unique'] / s['num_metapackages'] * 100.0, '#5bc0de', '%')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_problematic.svg')
def graph_repo_projects_problematic(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_problematic'], '#808080')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_problematic_percent.svg')
def graph_repo_projects_problematic_percent(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_problematic'] / s['num_metapackages'] * 100.0, '#808080', '%')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_vulnerable.svg')
def graph_repo_projects_vulnerable(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_metapackages_vulnerable'], '#ff0000')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/projects_vulnerable_percent.svg')
def graph_repo_projects_vulnerable_percent(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: safe_percent(s['num_metapackages_vulnerable'], s['num_metapackages']), '#ff0000', '%')


@ViewRegistrar('/graph/repo/<repo>/problems.svg')
def graph_repo_problems(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_problems'], '#c00000')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/problems_per_metapackage.svg')
def graph_repo_problems_per_metapackage(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_problems'] / s['num_metapackages'], '#c00000')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/maintainers.svg')
def graph_repo_maintainers(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_maintainers'], '#c000c0')  # type: ignore


@ViewRegistrar('/graph/repo/<repo>/packages_per_maintainer.svg')
def graph_repo_packages_per_maintainer(repo: str) -> Response:
    return graph_repo_generic(repo, lambda s: s['num_packages'] / s['num_maintainers'], '#c000c0')  # type: ignore


@ViewRegistrar('/graph/total/packages.svg')
def graph_total_packages() -> Response:
    return graph_total_generic(lambda s: s['num_packages'], '#000000')  # type: ignore


@ViewRegistrar('/graph/total/projects.svg')
def graph_total_projects() -> Response:
    return graph_total_generic(lambda s: s['num_metapackages'], '#000000')  # type: ignore


@ViewRegistrar('/graph/total/maintainers.svg')
def graph_total_maintainers() -> Response:
    return graph_total_generic(lambda s: s['num_maintainers'], '#c000c0')  # type: ignore


@ViewRegistrar('/graph/total/problems.svg')
def graph_total_problems() -> Response:
    return graph_total_generic(lambda s: s['num_problems'], '#c00000')  # type: ignore
