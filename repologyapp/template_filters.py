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

from typing import Iterable
from urllib.parse import urlparse

from repologyapp.package import PackageStatus


__all__ = ['maintainer_to_links', 'maintainers_to_group_mailto', 'css_for_versionclass']


def maintainer_to_links(maintainer: str) -> list[str]:
    links = []

    if '@' in maintainer:
        name, domain = maintainer.split('@', 1)

        if domain == 'cpan':
            links.append('https://metacpan.org/author/' + name)
        elif domain == 'aur':
            links.append('https://aur.archlinux.org/account/' + name)
        elif domain in ('altlinux.org', 'altlinux.ru'):
            links.append('http://sisyphus.ru/en/packager/' + name + '/')
        elif domain == 'github':
            links.append('https://github.com/' + name)
        elif domain == 'freshcode':
            links.append('http://freshcode.club/search?user=' + name)

        if '.' in domain:
            links.append('mailto:' + maintainer)

    return links


def maintainers_to_group_mailto(maintainers: Iterable[str], subject: str | None = None) -> str | None:
    emails = []

    for maintainer in maintainers:
        if '@' in maintainer and '.' in maintainer.split('@', 1)[1]:
            emails.append(maintainer)

    if not emails:
        return None

    return 'mailto:' + ','.join(sorted(emails)) + ('?subject=' + subject if subject else '')


def css_for_versionclass(value: int) -> str:
    if value == PackageStatus.IGNORED:
        return 'ignored'
    elif value == PackageStatus.UNIQUE:
        return 'unique'
    elif value == PackageStatus.DEVEL:
        return 'devel'
    elif value == PackageStatus.NEWEST:
        return 'newest'
    elif value == PackageStatus.LEGACY:
        return 'legacy'
    elif value == PackageStatus.OUTDATED:
        return 'outdated'
    elif value == PackageStatus.INCORRECT:
        return 'incorrect'
    elif value == PackageStatus.UNTRUSTED:
        return 'untrusted'
    elif value == PackageStatus.NOSCHEME:
        return 'noscheme'
    elif value == PackageStatus.ROLLING:
        return 'rolling'
    else:
        raise RuntimeError('unknown versionclass {}'.format(value))


def extract_netloc(url: str) -> str:
    return urlparse(url).netloc
