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

from repologyapp.template_filters import maintainer_to_links, maintainers_to_group_mailto


def test_email():
    assert maintainer_to_links('amdmi3@freebsd.org') == ['mailto:amdmi3@freebsd.org']


def test_garbage():
    assert maintainer_to_links('foo') == []


def test_cpan():
    assert maintainer_to_links('foo@cpan') == ['https://metacpan.org/author/foo']


def test_aur():
    assert maintainer_to_links('foo@aur') == ['https://aur.archlinux.org/account/foo']


def test_alt():
    assert maintainer_to_links('foo@altlinux.org') == ['http://sisyphus.ru/en/packager/foo/', 'mailto:foo@altlinux.org']
    assert maintainer_to_links('foo@altlinux.ru') == ['http://sisyphus.ru/en/packager/foo/', 'mailto:foo@altlinux.ru']


def test_group():
    assert maintainers_to_group_mailto(['some@notemail', 'amdmi3@freebsd.org', 'amdmi3@amdmi3.ru']) == 'mailto:amdmi3@amdmi3.ru,amdmi3@freebsd.org'
    assert maintainers_to_group_mailto(['some@notemail', 'amdmi3@freebsd.org', 'amdmi3@amdmi3.ru'], 'Hello, world!') == 'mailto:amdmi3@amdmi3.ru,amdmi3@freebsd.org?subject=Hello, world!'
    assert maintainers_to_group_mailto(['some@notemail'], 'Hello, world!') is None
    assert maintainers_to_group_mailto(['some@notemail']) is None
