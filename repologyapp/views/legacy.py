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

import flask

from repologyapp.view_registry import Response, ViewRegistrar


@ViewRegistrar('/project/<name>')
@ViewRegistrar('/project/<name>/')
def project(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


# /metapackage/*: logs are poluted by spam requests from huawei cloud, recheck after banning it
@ViewRegistrar('/metapackage/<name>')
def metapackage(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


@ViewRegistrar('/metapackage/<name>/versions')
def metapackage_versions(name: str) -> Response:
    return flask.redirect(flask.url_for('project_versions', name=name), 301)


@ViewRegistrar('/metapackage/<name>/packages')
def metapackage_packages(name: str) -> Response:
    return flask.redirect(flask.url_for('project_packages', name=name), 301)


# active badges on smartmontools.org, lyx.org and others
@ViewRegistrar('/badge/version-only-for-repo/<repo>/<name>.svg')
def badge_version_only_for_repo(repo: str, name: str) -> Response:
    return flask.redirect(
        flask.url_for(
            'badge_version_for_repo',
            repo=repo,
            name=name,
            header='',
            minversion=flask.request.args.to_dict().get('minversion')
        ),
        301
    )
