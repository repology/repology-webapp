-- Copyright (C) 2020-2021 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param repo
-- @param limit
-- @param max_age=None
-- @param min_count=5
--
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH candidates AS (
	-- fetch up to [limit] latest events
	SELECT
		id,
		ts,
		metapackage_id,
		type,
		data
	FROM repository_events
	WHERE
		repository_id = (SELECT id FROM repositories WHERE name = %(repo)s)
	-- sorting by id here guarantees stable result
	ORDER BY ts DESC, id
	LIMIT %(limit)s
),
candidates_numbered AS (
	-- same, but introduce row numbering if we need it later
	SELECT
		*
		{% if min_count %}
		, row_number() OVER (ORDER BY ts DESC, id) AS row_number
		{% endif %}
	FROM candidates
)
SELECT
	*,
	-- project names are looked up here for effeciency - we may need them for less rows
	(SELECT effname FROM metapackages WHERE id = metapackage_id) AS effname
FROM candidates_numbered
{% if max_age %}
WHERE
	-- limit by age if requested...
	ts >= now() - %(max_age)s
	{% if min_count %}
	-- ...but leave some minimal number of entries
	OR row_number <= %(min_count)s
	{% endif %}
{% endif %}
ORDER BY ts DESC, effname, type DESC, id;
