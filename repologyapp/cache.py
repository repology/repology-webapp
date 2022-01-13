# Copyright (C) 2021 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
from typing import Any, Callable, TypeVar

from flask import request


__all__ = ['cache']


_cache: dict[str, tuple[Any, float]] = {}


T = TypeVar('T')


def cache(label: str, retriever: Callable[[], T], duration: float = 60) -> T:
    global _cache

    should_bypass = request and request.headers.get('x-repology-cache-disable')

    now = time.monotonic()

    if not should_bypass:
        cached: tuple[T, float] | None = _cache.get(label)

        if cached is not None:
            data, timestamp = cached

            if timestamp > now - duration:
                return data

    data = retriever()
    _cache[label] = (data, now)
    return data
