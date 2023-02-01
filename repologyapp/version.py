# Copyright (C) 2018-2019 Dmitry Marakasov <amdmi3@amdmi3.ru>
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


from copy import copy
from functools import total_ordering
from typing import Any, Iterable

from libversion import ANY_IS_PATCH, P_IS_PATCH, version_compare

from repologyapp.package import AnyPackageDataMinimal, PackageFlags


@total_ordering
class UserVisibleVersionInfo:
    __slots__ = ['version', 'versionclass', 'metaorder', 'versionflags', 'vulnerable', 'recalled', 'spread']

    version: str
    versionclass: int
    metaorder: int
    versionflags: int
    vulnerable: bool
    recalled: bool
    spread: int

    def __init__(self, package: AnyPackageDataMinimal, spread: int = 1) -> None:
        self.version = package.version
        self.versionclass = package.versionclass

        self.metaorder = PackageFlags.get_metaorder(package.flags)
        self.versionflags = (((package.flags & PackageFlags.P_IS_PATCH) and P_IS_PATCH) |
                             ((package.flags & PackageFlags.ANY_IS_PATCH) and ANY_IS_PATCH))

        self.vulnerable = bool(package.flags & PackageFlags.VULNERABLE)
        self.recalled = bool(package.flags & PackageFlags.RECALLED)
        self.spread = spread

    def as_with_spread(self, spread: int) -> 'UserVisibleVersionInfo':
        result = copy(self)
        result.spread = spread
        return result

    def __eq__(self, other: Any) -> bool:
        return (self.metaorder == other.metaorder and
                self.versionclass == other.versionclass and
                self.version == other.version and
                version_compare(self.version, other.version, self.versionflags, other.versionflags) == 0 and
                self.vulnerable == other.vulnerable and
                self.recalled == other.recalled and
                self.spread == other.spread)

    def __lt__(self, other: 'UserVisibleVersionInfo') -> bool:
        if self.metaorder < other.metaorder:
            return True
        if self.metaorder > other.metaorder:
            return False

        res = version_compare(
            self.version,
            other.version,
            self.versionflags,
            other.versionflags
        )

        if res < 0:
            return True
        if res > 0:
            return False

        if self.versionclass < other.versionclass:
            return True
        if self.versionclass > other.versionclass:
            return False

        # XXX: We may not need to distinguish these - a version recalled/vulnerable
        # in one repository, but not another is still recalled/vulnerable
        # However to do that properly we'll need to merge these fields
        if self.vulnerable > other.vulnerable:
            return True
        if self.vulnerable < other.vulnerable:
            return False

        if self.recalled > other.recalled:
            return True
        if self.recalled < other.recalled:
            return False

        if self.spread < other.spread:
            return True
        if self.spread > other.spread:
            return False

        return self.version < other.version

    def __hash__(self) -> int:
        return hash((self.metaorder, self.versionclass, self.version, self.spread))


def iter_aggregate_versions(packages: Iterable[AnyPackageDataMinimal]) -> Iterable[UserVisibleVersionInfo]:
    seen: set[tuple[str, int, int]] = set()

    for package in packages:
        version = UserVisibleVersionInfo(package)

        key = (version.version, version.versionclass, version.metaorder)

        if key not in seen:
            seen.add(key)
            yield version
