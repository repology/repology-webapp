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
-- @param effname
-- @param limit=None
--
-- @returns array of tuples
--------------------------------------------------------------------------------
SELECT
	cve_id,
	to_char(published::timestamptz at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI"Z"') AS published,
	to_char(last_modified::timestamptz at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI"Z"') AS last_modified,
	cpe_vendor,
	cpe_product,
	start_version,
	end_version,
	start_version_excluded,
	end_version_excluded
FROM (
	SELECT
		*
	FROM (
		SELECT
			cve_id,
			published,
			last_modified,
			jsonb_array_elements(matches)->>0 AS cpe_vendor,
			jsonb_array_elements(matches)->>1 AS cpe_product,
			jsonb_array_elements(matches)->>2 AS start_version,
			jsonb_array_elements(matches)->>3 AS end_version,
			(jsonb_array_elements(matches)->>4)::boolean AS start_version_excluded,
			(jsonb_array_elements(matches)->>5)::boolean AS end_version_excluded,
			row_number() OVER (ORDER BY split_part(cve_id, '-', 2)::integer DESC, split_part(cve_id, '-', 3)::integer DESC) AS rn
		FROM cves
		WHERE cpe_pairs && (
			SELECT
				array_agg(cpe_vendor || ':' || cpe_product)
			FROM all_cpes
			WHERE effname = %(effname)s
		)
	) AS tmp
	{% if limit is not none %}
	WHERE rn <= %(limit)s
	{% endif %}
) AS expanded_cves
INNER JOIN all_cpes USING (cpe_vendor, cpe_product)
WHERE effname = %(effname)s
ORDER BY
	-- assuming CVE-xxxx-yyyyy format
	split_part(cve_id, '-', 2)::integer,
	split_part(cve_id, '-', 3)::integer,
	end_version::versiontext,
	start_version::versiontext NULLS FIRST;
