-- Copyright (C) 2022 Dmitry Marakasov <amdmi3@amdmi3.ru>
--
-- This file is part of repology
--
-- repology is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- repology is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with repology.  If not, see <http://www.gnu.org/licenses/>.

--------------------------------------------------------------------------------
-- @param interval
-- @param limit
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH ordered_recent_events AS (
	SELECT
		effname,
		ts,
		spread,
		data->'versions' as versions,
		row_number() OVER(PARTITION BY effname ORDER BY ts DESC) AS rn
	FROM global_version_events
	WHERE
		type = 'newest_update'::global_version_event_type
		AND ts > now() - INTERVAL %(interval)s
), unicalized_recent_events AS (
	SELECT
		effname,
		ts,
		spread,
		versions
	FROM ordered_recent_events
	-- XXX: this filters multiple events per project, but doesn't handle
	-- the case where version goes down (such as after new fake vesion was
	-- ignored), while we should exclude such events. Because of that, this
	-- query is not really production ready
	WHERE rn = 1
	ORDER BY spread DESC, effname
	LIMIT %(limit)s
)
SELECT
	EXTRACT(EPOCH FROM ts)::integer AS ts,
	effname AS project,
	versions
FROM unicalized_recent_events
ORDER BY ts DESC, effname;
