# Copyright (C) 2016 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

# mypy: no-disallow-untyped-calls

import json
import os
import sys
import xml.etree.ElementTree
from typing import Any

import pytest

from repologyapp import app


# setup test client
if 'REPOLOGY_CONFIG' not in os.environ:
    requires_database = pytest.mark.skip('flask tests require database filled with test data; please prepare the database and configuration file (see repology-test.conf.default for reference) and pass it via REPOLOGY_CONFIG environment variable')
else:
    def requires_database(test):
        return test
    #requires_database = lambda _: _

test_client = app.test_client()


# setup tidy
TIDY_OPTIONS = {'drop-empty-elements': False, 'doctype': 'html5'}


try:
    from tidylib import tidy_document
    _, errors = tidy_document('<!DOCTYPE html><html><head><title>test</title></head><body><nav>test</nav></body></html>')
    if errors.find('<nav> is not recognized') != -1:
        raise RuntimeError('Tidylib does not support HTML5')
    html_validation = True
except ImportError:
    print('Unable to import tidylib, HTML validation is disabled', file=sys.stderr)
    html_validation = False
except RuntimeError:
    print('Tidylib HTML5 support check failed, HTML validation is disabled', file=sys.stderr)
    html_validation = False


# HTTP request check helpers (which also return content)
def checkurl_data(url: str, status_code: int | None = 200, mimetype: str | None = None) -> bytes:
    __tracebackhide__ = True
    reply = test_client.get(url)
    if status_code is not None:
        assert reply.status_code == status_code
    if mimetype is not None:
        assert reply.mimetype == mimetype
    return reply.data


def checkurl_text(url: str, status_code: int | None = 200, mimetype: str | None = 'text/plain', has: list[str] = [], hasnot: list[str] = []) -> str:
    __tracebackhide__ = True
    text = checkurl_data(url, status_code, mimetype).decode('utf-8')
    assert isinstance(text, str)
    for pattern in has:
        assert pattern in text
    for pattern in hasnot:
        assert not (pattern in text)
    return text


def checkurl_html(url: str, status_code: int | None = 200, mimetype: str | None = 'text/html', has: list[str] = [], hasnot: list[str] = []) -> str:
    __tracebackhide__ = True
    document = checkurl_text(url, status_code, mimetype, has, hasnot)
    if html_validation:
        for line in tidy_document(document, options=TIDY_OPTIONS)[1].split('\n'):
            if not line:
                continue
            if 'trimming empty <span>' in line:
                continue
            pytest.fail(f'tidy error: {line}')
    return document


def checkurl_json(url: str, status_code: int | None = 200, mimetype: str | None = 'application/json', has: list[str] = [], hasnot: list[str] = []) -> Any:
    __tracebackhide__ = True
    return json.loads(
        checkurl_text(url, status_code, mimetype, has, hasnot)
    )


def checkurl_xml(url: str, status_code: int | None = 200, mimetype: str | None = 'application/xml', has: list[str] = [], hasnot: list[str] = []) -> xml.etree.ElementTree.Element:
    __tracebackhide__ = True
    return xml.etree.ElementTree.fromstring(
        checkurl_text(url, status_code, mimetype, has, hasnot)
    )


def checkurl_svg(url: str, status_code: int | None = 200, mimetype: str | None = 'image/svg+xml', has: list[str] = [], hasnot: list[str] = []) -> xml.etree.ElementTree.Element:
    __tracebackhide__ = True
    return checkurl_xml(url, status_code, mimetype, has, hasnot)


def checkurl_atom(url: str, status_code: int | None = 200, mimetype: str | None = 'application/atom+xml', has: list[str] = [], hasnot: list[str] = []) -> xml.etree.ElementTree.Element:
    __tracebackhide__ = True
    return checkurl_xml(url, status_code, mimetype, has, hasnot)


def checkurl_301(url: str) -> str:
    __tracebackhide__ = True
    return checkurl_data(url, 301)


def checkurl_302(url: str) -> str:
    __tracebackhide__ = True
    return checkurl_data(url, 302)


def checkurl_403(url: str) -> str:
    __tracebackhide__ = True
    return checkurl_data(url, 403)


def checkurl_404(url: str) -> str:
    __tracebackhide__ = True
    return checkurl_data(url, 404)


# real tests start from here
def test_static_pages():
    checkurl_html('/api', has=['/api/v1/projects/firefox'])
    checkurl_html('/docs')
    checkurl_html('/docs/about')
    checkurl_html('/docs/bots')
    checkurl_html('/docs/not_supported')
    checkurl_html('/docs/requirements')
    checkurl_data('/favicon.ico', mimetype='image/vnd.microsoft.icon')
    checkurl_html('/news', has=['Added', 'repository'])  # assume we always have "Added xxx repository" news there


def test_static_pages_legacy():
    checkurl_301('/about')
    checkurl_301('/addrepo')
    checkurl_301('/docs/addrepo')


@requires_database
def test_titlepage():
    checkurl_html('/', has=['FreeBSD', 'virtualbox'])


@requires_database
def test_badges():
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg', has=['<svg', 'FreeBSD'])
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg?header=FooBar', has=['<svg', 'FreeBSD', 'FooBar'])
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg?minversion=99999999', has=['<svg', 'FreeBSD', 'e00000'])
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg?columns=5', has=['<svg', 'FreeBSD'])
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg?exclude_sources=repository', has=['<svg'], hasnot=['FreeBSD'])
    checkurl_svg('/badge/vertical-allrepos/kiconvtool.svg?exclude_unsupported=1', has=['<svg'])
    checkurl_svg('/badge/vertical-allrepos/nonexistent.svg', has=['<svg', 'No known packages'])

    checkurl_svg('/badge/tiny-repos/kiconvtool.svg', has=['<svg', '>1<'])
    checkurl_svg('/badge/tiny-repos/nonexistent.svg', has=['<svg', '>0<'])

    checkurl_svg('/badge/version-for-repo/freebsd/kiconvtool.svg', has=['<svg', '>0.97<'])
    checkurl_svg('/badge/version-for-repo/freebsd/kiconvtool.svg?minversion=99999999', has=['<svg', '>0.97<', 'e00000'])
    checkurl_svg('/badge/version-for-repo/freebsd/nonexistent.svg', has=['<svg', '>-<'])
    checkurl_404('/badge/version-for-repo/nonexistent/kiconvtool.svg')

    checkurl_301('/badge/version-only-for-repo/freebsd/kiconvtool.svg')
    checkurl_301('/badge/version-only-for-repo/freebsd/kiconvtool.svg?minversion=99999999')
    checkurl_301('/badge/version-only-for-repo/freebsd/nonexistent.svg')
    checkurl_301('/badge/version-only-for-repo/nonexistent/kiconvtool.svg')

    checkurl_svg('/badge/latest-versions/kiconvtool.svg', has=['<svg', '>0.97<'])
    checkurl_svg('/badge/latest-versions/nonexistent.svg', has=['<svg', '>-<'])

    checkurl_svg('/badge/versions-matrix.svg?projects=kiconvtool&header=HEADER', has=['<svg', 'FreeBSD', '>0.97<', 'HEADER'])


@requires_database
def test_graphs():
    checkurl_svg('/graph/total/projects.svg')
    checkurl_svg('/graph/total/maintainers.svg')
    checkurl_svg('/graph/total/problems.svg')

    checkurl_svg('/graph/map_repo_size_fresh.svg')
    checkurl_svg('/graph/map_repo_size_fresh_nonunique.svg')
    checkurl_svg('/graph/map_repo_size_freshness.svg')

    checkurl_svg('/graph/map_repo_size_fresh.svg?xlimit=500&ylimit=500')

    checkurl_svg('/graph/repo/freebsd/projects_total.svg')
    checkurl_svg('/graph/repo/freebsd/projects_newest.svg')
    checkurl_svg('/graph/repo/freebsd/projects_newest_percent.svg')
    checkurl_svg('/graph/repo/freebsd/projects_outdated.svg')
    checkurl_svg('/graph/repo/freebsd/projects_outdated_percent.svg')
    checkurl_svg('/graph/repo/freebsd/projects_unique.svg')
    checkurl_svg('/graph/repo/freebsd/projects_unique_percent.svg')
    checkurl_svg('/graph/repo/freebsd/projects_problematic.svg')
    checkurl_svg('/graph/repo/freebsd/projects_problematic_percent.svg')
    checkurl_svg('/graph/repo/freebsd/projects_vulnerable.svg')
    checkurl_svg('/graph/repo/freebsd/projects_vulnerable_percent.svg')
    checkurl_svg('/graph/repo/freebsd/maintainers.svg')
    checkurl_svg('/graph/repo/freebsd/problems.svg')


@requires_database
def test_project():
    checkurl_html('/project/kiconvtool/versions', has=['FreeBSD', '0.97', 'amdmi3'])
    checkurl_html('/project/nonexistent/versions', has=['Unknown project'], status_code=404)

    checkurl_html('/project/kiconvtool/versions-compact', has=['FreeBSD', '0.97', 'amdmi3'])
    checkurl_html('/project/nonexistent/versions-compact', has=['Unknown project'], status_code=404)

    checkurl_html('/project/kiconvtool/packages', has=['FreeBSD', '0.97', 'amdmi3'])
    checkurl_html('/project/nonexistent/packages', has=['Unknown project'], status_code=404)

    checkurl_html('/project/kiconvtool/information', has=['FreeBSD', '0.97', 'amdmi3'])
    checkurl_html('/project/nonexistent/information', has=['Unknown project'], status_code=404)

    #checkurl_html('/project/kiconvtool/related')  # , has=['0.97']) # XXX: no related packages in current testdata
    checkurl_html('/project/nonexistent/related', has=['Unknown project'], status_code=404)

    checkurl_html('/project/kiconvtool/badges', has=[
        # XXX: agnostic to site home
        '/project/kiconvtool',
        '/badge/vertical-allrepos/kiconvtool.svg',
        '/badge/tiny-repos/kiconvtool.svg',
    ])

    checkurl_html('/project/kiconvtool/report')

    checkurl_html('/project/kiconvtool/history')


@requires_database
def test_maintaners():
    checkurl_html('/maintainers/a/', has=['amdmi3@freebsd.org'])
    checkurl_html('/maintainers/?search=%20AMDmi3%20', has=['amdmi3@freebsd.org'])


@requires_database
def test_maintainer():
    checkurl_html('/maintainer/amdmi3@freebsd.org', has=['mailto:amdmi3@freebsd.org', 'kiconvtool'])
    checkurl_html('/maintainer/nonexistent', 404, has=['noindex'])


@requires_database
def test_maintainer_problems():
    checkurl_301('/maintainer/amdmi3@freebsd.org/problems')  # legacy
    checkurl_html('/maintainer/amdmi3@freebsd.org/problems-for-repo/freebsd')


@requires_database
def test_maintainer_feeds():
    checkurl_html('/maintainer/amdmi3@freebsd.org/feed-for-repo/freebsd')
    checkurl_atom('/maintainer/amdmi3@freebsd.org/feed-for-repo/freebsd/atom')


@requires_database
def test_repositories():
    checkurl_html('/repositories/statistics', has=['FreeBSD'])
    checkurl_html('/repositories/statistics/newest', has=['FreeBSD'])
    checkurl_html('/repositories/packages', has=['FreeBSD'])
    checkurl_html('/repositories/graphs')
    checkurl_html('/repositories/updates', has=['FreeBSD'])


@requires_database
def test_log():
    checkurl_html('/log/1', has=['successful'])
    checkurl_404('/log/9999')


@requires_database
def test_link():
    checkurl_html('/link/http://chromium-bsu.sourceforge.net/', has=['chromium-bsu.sourceforge.net'])
    checkurl_404('/link/http://non-existing-link')


@requires_database
def test_repository():
    checkurl_html('/repository/freebsd', has=['FreeBSD'])


@requires_database
def test_repository_problems():
    checkurl_html('/repository/freebsd/problems', has=['FreeBSD'])


@requires_database
def test_repository_feeds():
    checkurl_html('/repository/freebsd/feed')
    checkurl_atom('/repository/freebsd/feed/atom')


@requires_database
def test_projects():
    checkurl_html('/projects/', has=['kiconvtool', '0.97', 'chromium-bsu', '0.9.15.1'])

    checkurl_html('/projects/k/', has=['kiconvtool', 'virtualbox'], hasnot=['chromium-bsu'])
    checkurl_html('/projects/..l/', has=['kiconvtool', 'chromium-bsu'], hasnot=['virtualbox'])

    checkurl_html('/projects/?search=iconv', has=['kiconvtool'], hasnot=['chromium-bsu'])
    checkurl_html('/projects/?search=%20ICONV%20', has=['kiconvtool'], hasnot=['chromium-bsu'])
    checkurl_html('/projects/?category=games-action', has=['chromium-bsu'], hasnot=['kiconvtool'])
    checkurl_html('/projects/?inrepo=freebsd', has=['kiconvtool'], hasnot=['oracle-xe'])
    checkurl_html('/projects/?notinrepo=freebsd', has=['oracle-xe'], hasnot=['kiconvtool'])
    checkurl_html('/projects/?maintainer=amdmi3@freebsd.org', has=['kiconvtool'], hasnot=['kforth', 'teamviewer'])

    # XXX add some duplicated packages in testdata and add spread and unique tests

    # special cases: check fallback code for going before first or after last entry
    checkurl_html('/projects/..0/', has=['kiconvtool'])
    checkurl_html('/projects/zzzzzz/', has=['kiconvtool'])


def test_tools_static():
    checkurl_html('/tools')
    checkurl_html('/tools/project-by')


@requires_database
def test_tools_project_by():
    checkurl_html('/tools/project-by?repo=freebsd&name_type=srcname&target_page=project_versions')
    checkurl_404('/tools/project-by?repo=freebsd&name_type=srcname&target_page=project_versions&name=nonexisting-package')
    checkurl_302('/tools/project-by?repo=freebsd&name_type=srcname&target_page=project_versions&name=sysutils/kiconvtool')
    checkurl_404('/tools/project-by?repo=nonexisting-repo&name_type=srcname&target_page=project_versions')

    # XXX: need testdata for disallowed repo
    #checkurl_403('/tools/project-by?repo=wikidata&name_type=srcname&target_page=project_versions')

    # XXX: need more testdata for multiple choices


@requires_database
def test_tools_trending():
    checkurl_html('/tools/trending')


@requires_database
def test_tools_important_updates():
    checkurl_html('/tools/important_updates')


@requires_database
def test_security():
    checkurl_html('/security/recent-cves')
    checkurl_html('/security/recent-cpes')


def test_experimental_static():
    checkurl_html('/experimental/')


@requires_database
def test_experimental():
    checkurl_html('/experimental/turnover/maintainers')
    checkurl_html('/experimental/distromap')


@requires_database
def test_api_v1_project():
    assert checkurl_json('/api/v1/project/kiconvtool') == [
        {
            'repo': 'freebsd',
            'srcname': 'sysutils/kiconvtool',
            'binname': 'kiconvtool',
            'visiblename': 'sysutils/kiconvtool',
            'version': '0.97',
            'origversion': '0.97_1',
            'status': 'unique',
            'categories': ['sysutils'],
            'summary': 'Tool to preload kernel iconv charset tables',
            'maintainers': ['amdmi3@freebsd.org'],
        }
    ]
    assert checkurl_json('/api/v1/project/nonexistent') == []


@requires_database
def test_api_v1_projects():
    checkurl_json('/api/v1/projects/', has=['kiconvtool', '0.97', 'chromium-bsu', '0.9.15.1'])

    checkurl_json('/api/v1/projects/k/', has=['kiconvtool', 'virtualbox'], hasnot=['chromium-bsu'])
    checkurl_json('/api/v1/projects/..l/', has=['kiconvtool', 'chromium-bsu'], hasnot=['virtualbox'])

    checkurl_json('/api/v1/projects/?search=iconv', has=['kiconvtool'], hasnot=['chromium-bsu'])
    checkurl_json('/api/v1/projects/?category=games-action', has=['chromium-bsu'], hasnot=['kiconvtool'])
    checkurl_json('/api/v1/projects/?inrepo=freebsd', has=['kiconvtool'], hasnot=['oracle-xe'])
    checkurl_json('/api/v1/projects/?notinrepo=freebsd', has=['oracle-xe'], hasnot=['kiconvtool'])
    checkurl_json('/api/v1/projects/?maintainer=amdmi3@freebsd.org', has=['kiconvtool'], hasnot=['kforth', 'teamviewer'])


@requires_database
def test_api_v1_problems():
    # XXX: empty output for now
    checkurl_json('/api/v1/maintainer/amdmi3@freebsd.org/problems-for-repo/freebsd')
    checkurl_json('/api/v1/repository/freebsd/problems')


@requires_database
def test_api_experimental_distromap():
    checkurl_json('/api/experimental/distromap?fromrepo=freebsd&torepo=gentoo')
    checkurl_json('/api/experimental/distromap?fromrepo=freebsd&torepo=gentoo&expand=1')

    checkurl_text('/api/experimental/distromap?fromrepo=freebsd&torepo=gentoo&format=plaintext')
    checkurl_text('/api/experimental/distromap?fromrepo=freebsd&torepo=gentoo&expand=1&format=plaintext')


@requires_database
def test_api_experimental_updates():
    checkurl_json('/api/experimental/updates')


@requires_database
def test_sitemaps():
    checkurl_xml('/sitemaps/index.xml')
    checkurl_xml('/sitemaps/main.xml')
    checkurl_xml('/sitemaps/maintainers.xml')
    checkurl_xml('/sitemaps/repositories.xml')
    checkurl_xml('/sitemaps/projects_0.xml')
    checkurl_404('/sitemaps/projects_1.xml')
