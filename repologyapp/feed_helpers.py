# Copyright (C) 2018-2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
from typing import Any, Dict, List, Optional


def unicalize_feed_timestamps(entries: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    prev_ts: Optional[datetime.datetime] = None

    # it is likely for multiple events to share the same timestamp,
    # however at least W3C feed validator (https://validator.w3.org/feed)
    # recommends to use unique values:
    # "Two entries with the same value for atom:updated:"
    #
    # We thus modify event timestamps here to make them unique.
    # - 1 second is used as minimal interval between events as it's assumed
    #   that some readers may not have sub-second precision
    # - We move events into the past and not the future, to make
    #   timestamps stable if deed length changes
    for entry in entries:
        if 'ts' in entry and prev_ts and entry['ts'] >= prev_ts:
            entry['ts'] = prev_ts - datetime.timedelta(seconds=1)
        prev_ts = entry['ts']

    return entries
