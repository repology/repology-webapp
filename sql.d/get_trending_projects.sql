-- Copyright (C) 2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param period
-- @param limit=None
-- @param negative=False
--
-- @returns array of dicts
--------------------------------------------------------------------------------
SELECT
	effname,
	sum(delta) AS delta,
	now() - max(ts) FILTER(WHERE delta {% if negative %}< 0{% else %}> 0{% endif %}) AS age_since_last_change,
	(SELECT has_related FROM metapackages WHERE effname = project_turnover.effname) AS has_related
FROM project_turnover
WHERE ts >= now() - %(period)s
GROUP BY effname
HAVING sum(delta) {% if negative %}< -1{% else %}> 1{% endif %}
ORDER BY delta {% if negative %}ASC{% else %}DESC{% endif %}, age_since_last_change, effname
LIMIT %(limit)s;
