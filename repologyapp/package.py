# Copyright (C) 2019-2021 Dmitry Marakasov <amdmi3@amdmi3.ru>
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

from dataclasses import dataclass
from typing import ClassVar, Dict, List, Optional, Protocol, Tuple, TypeVar

from libversion import ANY_IS_PATCH, P_IS_PATCH, version_compare

__all__ = [
    'AnyPackageDataMinimal',
    'AnyPackageDataSummarizable',
    'PackageDataMinimal',
    'PackageDataSummarizable',
    'PackageDataDetailed',
    'PackageFlags',
    'PackageStatus',
]


class PackageStatus:
    # XXX: better make this state innrepresentable by introducing an intermediate
    # type for inprocessed package, missing versionclass and other fields which
    # are filled later
    UNPROCESSED: ClassVar[int] = 0

    NEWEST: ClassVar[int] = 1
    OUTDATED: ClassVar[int] = 2
    IGNORED: ClassVar[int] = 3
    UNIQUE: ClassVar[int] = 4
    DEVEL: ClassVar[int] = 5
    LEGACY: ClassVar[int] = 6
    INCORRECT: ClassVar[int] = 7
    UNTRUSTED: ClassVar[int] = 8
    NOSCHEME: ClassVar[int] = 9
    ROLLING: ClassVar[int] = 10

    @staticmethod
    def is_ignored(val: int) -> bool:
        """Return whether a specified val is equivalent to ignored."""
        return (val == PackageStatus.IGNORED or
                val == PackageStatus.INCORRECT or
                val == PackageStatus.UNTRUSTED or
                val == PackageStatus.NOSCHEME or
                val == PackageStatus.ROLLING)

    @staticmethod
    def as_string(val: int) -> str:
        """Return string representation of a version class."""
        return {
            PackageStatus.NEWEST: 'newest',
            PackageStatus.OUTDATED: 'outdated',
            PackageStatus.IGNORED: 'ignored',
            PackageStatus.UNIQUE: 'unique',
            PackageStatus.DEVEL: 'devel',
            PackageStatus.LEGACY: 'legacy',
            PackageStatus.INCORRECT: 'incorrect',
            PackageStatus.UNTRUSTED: 'untrusted',
            PackageStatus.NOSCHEME: 'noscheme',
            PackageStatus.ROLLING: 'rolling',
        }[val]


class PackageFlags:
    REMOVE: ClassVar[int] = 1 << 0
    DEVEL: ClassVar[int] = 1 << 1
    IGNORE: ClassVar[int] = 1 << 2
    INCORRECT: ClassVar[int] = 1 << 3
    UNTRUSTED: ClassVar[int] = 1 << 4
    NOSCHEME: ClassVar[int] = 1 << 5
    ROLLING: ClassVar[int] = 1 << 7
    OUTDATED: ClassVar[int] = 1 << 8
    LEGACY: ClassVar[int] = 1 << 9
    P_IS_PATCH: ClassVar[int] = 1 << 10
    ANY_IS_PATCH: ClassVar[int] = 1 << 11
    TRACE: ClassVar[int] = 1 << 12
    WEAK_DEVEL: ClassVar[int] = 1 << 13
    STABLE: ClassVar[int] = 1 << 14
    ALTVER: ClassVar[int] = 1 << 15
    VULNERABLE: ClassVar[int] = 1 << 16

    ANY_IGNORED: ClassVar[int] = IGNORE | INCORRECT | UNTRUSTED | NOSCHEME

    @staticmethod
    def get_metaorder(val: int) -> int:
        """Return a higher order version sorting key based on flags.

        E.g. rolling versions always precede normal versions,
        and normal versions always precede outdated versions

        Within a specific metaorder versions are compared normally
        """
        if val & PackageFlags.ROLLING:
            return 1
        if val & PackageFlags.OUTDATED:
            return -1
        return 0

    @staticmethod
    def as_string(val: int) -> str:
        """Return string representation of a flags combination."""
        if val == 0:
            return '-'

        return '|'.join(
            name for var, name in {
                PackageFlags.REMOVE: 'REMOVE',
                PackageFlags.DEVEL: 'DEVEL',
                PackageFlags.IGNORE: 'IGNORE',
                PackageFlags.INCORRECT: 'INCORRECT',
                PackageFlags.UNTRUSTED: 'UNTRUSTED',
                PackageFlags.NOSCHEME: 'NOSCHEME',
                PackageFlags.ROLLING: 'ROLLING',
                PackageFlags.OUTDATED: 'OUTDATED',
                PackageFlags.LEGACY: 'LEGACY',
                PackageFlags.P_IS_PATCH: 'P_IS_PATCH',
                PackageFlags.ANY_IS_PATCH: 'ANY_IS_PATCH',
                PackageFlags.TRACE: 'TRACE',
                PackageFlags.WEAK_DEVEL: 'WEAK_DEVEL',
                PackageFlags.STABLE: 'STABLE',
                PackageFlags.ALTVER: 'ALTVER',
            }.items() if val & var
        )


class LinkType:
    UPSTREAM_HOMEPAGE: ClassVar[int] = 0
    UPSTREAM_DOWNLOAD: ClassVar[int] = 1
    UPSTREAM_REPOSITORY: ClassVar[int] = 2
    UPSTREAM_ISSUE_TRACKER: ClassVar[int] = 3
    PROJECT_HOMEPAGE: ClassVar[int] = 4
    PACKAGE_HOMEPAGE: ClassVar[int] = 5
    PACKAGE_DOWNLOAD: ClassVar[int] = 6
    PACKAGE_REPOSITORY: ClassVar[int] = 7
    PACKAGE_ISSUE_TRACKER: ClassVar[int] = 8
    PACKAGE_RECIPE: ClassVar[int] = 9
    PACKAGE_RECIPE_RAW: ClassVar[int] = 10
    PACKAGE_PATCH: ClassVar[int] = 11
    PACKAGE_PATCH_RAW: ClassVar[int] = 12
    PACKAGE_BUILD_LOG: ClassVar[int] = 13
    PACKAGE_BUILD_LOG_RAW: ClassVar[int] = 14
    PACKAGE_NEW_VERSION_CHECKER: ClassVar[int] = 15
    UPSTREAM_DOCUMENTATION: ClassVar[int] = 16
    UPSTREAM_CHANGELOG: ClassVar[int] = 17
    PROJECT_DOWNLOAD: ClassVar[int] = 18
    UPSTREAM_DONATION: ClassVar[int] = 19  # XXX: to be used sparingly not to provide obsolete funding info
    UPSTREAM_DISCUSSION: ClassVar[int] = 20
    UPSTREAM_COVERAGE: ClassVar[int] = 21
    UPSTREAM_CI: ClassVar[int] = 22
    UPSTREAM_WIKI: ClassVar[int] = 23
    OTHER: ClassVar[int] = 99


@dataclass
class PackageDataMinimal:
    repo: str
    family: str

    visiblename: str
    effname: str

    version: str
    versionclass: int

    flags: int


@dataclass
class PackageDataSummarizable(PackageDataMinimal):
    maintainers: Optional[List[str]]


@dataclass
class PackageDataDetailed(PackageDataSummarizable):
    subrepo: Optional[str]

    name: Optional[str]
    srcname: Optional[str]
    binname: Optional[str]
    trackname: Optional[str]

    origversion: str
    rawversion: str

    category: Optional[str]
    comment: Optional[str]
    licenses: Optional[List[str]]
    links: Optional[List[Tuple[int, int]]]

    extrafields: Dict[str, str]


AnyPackageDataMinimal = TypeVar('AnyPackageDataMinimal', bound=PackageDataMinimal)
AnyPackageDataSummarizable = TypeVar('AnyPackageDataSummarizable', bound=PackageDataSummarizable)


class VersionComparable(Protocol):
    flags: int
    version: str


def package_version_compare(a: VersionComparable, b: VersionComparable) -> int:
    metaorder_a = 1 if a.flags & PackageFlags.ROLLING else -1 if a.flags & PackageFlags.OUTDATED else 0
    metaorder_b = 1 if b.flags & PackageFlags.ROLLING else -1 if b.flags & PackageFlags.OUTDATED else 0

    if metaorder_a < metaorder_b:
        return -1
    if metaorder_a > metaorder_b:
        return 1

    return version_compare(
        a.version,
        b.version,
        ((a.flags & PackageFlags.P_IS_PATCH) and P_IS_PATCH) |
        ((a.flags & PackageFlags.ANY_IS_PATCH) and ANY_IS_PATCH),
        ((b.flags & PackageFlags.P_IS_PATCH) and P_IS_PATCH) |
        ((b.flags & PackageFlags.ANY_IS_PATCH) and ANY_IS_PATCH)
    )
