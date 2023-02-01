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

from collections import defaultdict
from dataclasses import dataclass
from functools import cmp_to_key
from typing import Iterable

from repologyapp.package import AnyPackageDataMinimal, PackageFlags, PackageStatus, package_version_compare


def packageset_sort_by_version(packages: Iterable[AnyPackageDataMinimal]) -> list[AnyPackageDataMinimal]:
    return sorted(packages, key=cmp_to_key(package_version_compare), reverse=True)


def _is_good_representative_package(package: AnyPackageDataMinimal, allow_ignored: bool) -> bool:
    """Check if a package is suitable to represent a repository."""
    # avoid recalled packages
    if package.flags & PackageFlags.RECALLED:
        return False

    # avoid ignored packages, unless explicitly allowed
    if not allow_ignored and PackageStatus.is_ignored(package.versionclass):
        return False

    return True


def packageset_to_best_by_repo(packages: Iterable[AnyPackageDataMinimal], allow_ignored: bool = False) -> dict[str, AnyPackageDataMinimal]:
    """Given a collection of packages, return representative package for each encountered repository.

    Sometimes we need to choose a single package to represent a
    repository, e.g. on a badge where there's place for only one
    entry per repository. For that purpose we pick a package with
    highest version. We skip some subsets of packages such as
    ignored and recalled ones, but fallback to these if there's
    no other option.
    """
    state_by_repo: dict[str, AnyPackageDataMinimal] = {}
    good_by_repo: dict[str, bool] = {}

    for package in packageset_sort_by_version(packages):
        if package.repo not in state_by_repo:
            # start with picking the first available package
            state_by_repo[package.repo] = package
            good_by_repo[package.repo] = _is_good_representative_package(package, allow_ignored)
        elif not good_by_repo[package.repo] and _is_good_representative_package(package, allow_ignored):
            # but then replace it by more suitable one if possible
            state_by_repo[package.repo] = package
            good_by_repo[package.repo] = True

    return state_by_repo


def packageset_to_best(packages: Iterable[AnyPackageDataMinimal], allow_ignored: bool = False) -> AnyPackageDataMinimal | None:
    """Given a collection of packages, return a representative package.

    Same logic as packageset_to_best_by_repo, but assumes that all
    packages belong to a single repository. A bit more efficient.
    """
    sorted_packages = packageset_sort_by_version(packages)

    for package in sorted_packages:
        if _is_good_representative_package(package, allow_ignored):
            return package

    return sorted_packages[0] if sorted_packages else None


def packageset_sort_by_name_version(packages: Iterable[AnyPackageDataMinimal]) -> list[AnyPackageDataMinimal]:
    def compare(p1: AnyPackageDataMinimal, p2: AnyPackageDataMinimal) -> int:
        if p1.visiblename < p2.visiblename:
            return -1
        if p1.visiblename > p2.visiblename:
            return 1
        return -package_version_compare(p1, p2)

    return sorted(packages, key=cmp_to_key(compare))


@dataclass
class VersionAggregation:
    version: str
    versionclass: int
    numfamilies: int
    vulnerable: bool


def packageset_aggregate_by_version(packages: Iterable[AnyPackageDataMinimal], classmap: dict[int, int] = {}) -> list[VersionAggregation]:
    def create_version_aggregation(packages: Iterable[AnyPackageDataMinimal]) -> Iterable[VersionAggregation]:
        aggregated: dict[tuple[str, int], list[AnyPackageDataMinimal]] = defaultdict(list)

        for package in packages:
            aggregated[
                (package.version, classmap.get(package.versionclass, package.versionclass))
            ].append(package)

        for (version, versionclass), packages in sorted(aggregated.items()):
            yield VersionAggregation(
                version=version,
                versionclass=versionclass,
                numfamilies=len(set(package.family for package in packages)),
                vulnerable=any(package.flags & PackageFlags.VULNERABLE for package in packages),
            )

    def post_sort_same_version(versions: Iterable[VersionAggregation]) -> list[VersionAggregation]:
        return sorted(versions, key=lambda v: (v.numfamilies, v.version, v.versionclass), reverse=True)

    def aggregate_by_version(packages: Iterable[AnyPackageDataMinimal]) -> Iterable[list[VersionAggregation]]:
        current: list[AnyPackageDataMinimal] = []
        for package in packageset_sort_by_version(packages):
            if not current or package_version_compare(current[0], package) == 0:
                current.append(package)
            else:
                yield post_sort_same_version(create_version_aggregation(current))
                current = [package]

        if current:
            yield post_sort_same_version(create_version_aggregation(current))

    return sum(aggregate_by_version(packages), [])
