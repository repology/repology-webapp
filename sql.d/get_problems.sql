-- Copyright (C) 2016-2018,2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param maintainer=None
-- @param start=None
-- @param end=None
-- @param limit=None
--
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH unsorted AS (
	SELECT
		packages.*,  -- XXX: remove this after #1129
		maintainer,
		"type",
		data,
		(
			SELECT url
			FROM links
			WHERE id IN (
				SELECT
					link_id
				FROM (
					SELECT
						(json_array_elements(links)->>0)::integer AS link_type,
						(json_array_elements(links)->>1)::integer AS link_id
				) AS expanded_links
				WHERE
					link_type IN (
						5, -- PACKAGE_HOMEPAGE
						7, -- PACKAGE_SOURCES
						9, -- PACKAGE_RECIPE
						10 -- PACKAGE_RECIPE_RAW
					)
			) --AND coalesce(ipv4_success, true)  -- XXX: better display link status
			LIMIT 1
		) AS url
	FROM problems
	INNER JOIN packages ON packages.id = problems.package_id
	WHERE
		problems.repo = %(repo)s
		{% if maintainer %}AND maintainer = %(maintainer)s{% endif %}
		{% if start %}AND problems.effname >= %(start)s{% endif %}
		{% if end %}AND problems.effname <= %(end)s{% endif %}
	ORDER BY
		{% if end %}
		problems.effname DESC, problems.maintainer DESC
		{% else %}
		problems.effname, problems.maintainer
		{% endif %}
	LIMIT %(limit)s
)
SELECT *
FROM unsorted
ORDER BY effname, maintainer;
