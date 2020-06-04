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
	delta,
	has_related
FROM
(
	SELECT
		effname,
		sum(delta) AS delta
	FROM project_turnover
	WHERE ts >= now() - interval '%(period)s second'
	GROUP BY effname
	HAVING sum(delta) {% if negative %}< -1{% else %}> 1{% endif %}
	ORDER BY delta {% if negative %}ASC{% else %}DESC{% endif %}, effname
	-- important to limit the inner query, otherwise a lot of `metapackages`
	-- rows would be fetched and ineffective plan involving seqscan would
	-- be chosen
	LIMIT %(limit)s
) AS turnover
INNER JOIN metapackages USING(effname)
-- keep sorted
ORDER BY delta {% if negative %}ASC{% else %}DESC{% endif %}, effname;
