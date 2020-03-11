-- Copyright (C) 2019-2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param name
-- @param incoming
--
-- @returns array of dicts
--------------------------------------------------------------------------------

{% set my = 'new' if incoming else 'old' %}
{% set other = 'old' if incoming else 'new' %}

	SELECT DISTINCT
		false AS is_manual,
		(SELECT effname FROM metapackages WHERE id = old.project_id) AS oldname,
		(SELECT effname FROM metapackages WHERE id = new.project_id) AS newname,
		EXISTS (
			SELECT *
			FROM metapackages
			WHERE metapackages.id = {{ other }}.project_id AND metapackages.num_repos > 0
		) AS is_alive
	FROM project_redirects AS old INNER JOIN project_redirects AS new USING(repository_id, trackname)
	WHERE
		{{ my }}.project_id = (SELECT id FROM metapackages WHERE effname = %(name)s)
		AND NOT old.is_actual AND new.is_actual
UNION ALL
	SELECT
		true AS manual,
		oldname,
		newname,
		EXISTS (
			SELECT *
			FROM metapackages
			WHERE metapackages.effname = project_redirects_manual.{{ other }}name AND metapackages.num_repos > 0
		) AS is_alive
	FROM project_redirects_manual
	WHERE {{ my }}name = %(name)s
ORDER BY oldname, newname;
