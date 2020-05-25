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

	expanded_cves.cpe_vendor,
	expanded_cves.cpe_product,
	expanded_cves.cpe_edition,
	expanded_cves.cpe_lang,
	expanded_cves.cpe_sw_edition,
	expanded_cves.cpe_target_sw,
	expanded_cves.cpe_target_hw,
	expanded_cves.cpe_other,

	start_version,
	end_version,
	start_version_excluded,
	end_version_excluded
FROM (
	SELECT
		*
	FROM (
		-- preselect possibly matching CVEs; this may contain unrelated CVEs
		-- for only vendor/product are checked here; they are filtered in the top-level join
		SELECT
			cve_id,
			published,
			last_modified,
			jsonb_array_elements(matches)->>0 AS cpe_vendor,
			jsonb_array_elements(matches)->>1 AS cpe_product,
			jsonb_array_elements(matches)->>2 AS cpe_edition,
			jsonb_array_elements(matches)->>3 AS cpe_lang,
			jsonb_array_elements(matches)->>4 AS cpe_sw_edition,
			jsonb_array_elements(matches)->>5 AS cpe_target_sw,
			jsonb_array_elements(matches)->>6 AS cpe_target_hw,
			jsonb_array_elements(matches)->>7 AS cpe_other,

			jsonb_array_elements(matches)->>8 AS start_version,
			jsonb_array_elements(matches)->>9 AS end_version,
			(jsonb_array_elements(matches)->>10)::boolean AS start_version_excluded,
			(jsonb_array_elements(matches)->>11)::boolean AS end_version_excluded,
			row_number() OVER (ORDER BY split_part(cve_id, '-', 2)::integer DESC, split_part(cve_id, '-', 3)::integer DESC) AS rn
		FROM cves
		WHERE cpe_pairs && (
			SELECT
				array_agg(cpe_vendor || ':' || cpe_product)
			FROM manual_cpes
			WHERE effname = %(effname)s
		)
	) AS tmp
	{% if limit is not none %}
	WHERE rn <= %(limit)s
	{% endif %}
) AS expanded_cves
INNER JOIN manual_cpes ON
	expanded_cves.cpe_vendor = manual_cpes.cpe_vendor AND
	expanded_cves.cpe_product = manual_cpes.cpe_product AND
	coalesce(nullif(expanded_cves.cpe_edition, '*') = nullif(manual_cpes.cpe_edition, '*'), TRUE) AND
	coalesce(nullif(expanded_cves.cpe_lang, '*') = nullif(manual_cpes.cpe_lang, '*'), TRUE) AND
	coalesce(nullif(expanded_cves.cpe_sw_edition, '*') = nullif(manual_cpes.cpe_sw_edition, '*'), TRUE) AND
	coalesce(nullif(expanded_cves.cpe_target_sw, '*') = nullif(manual_cpes.cpe_target_sw, '*'), TRUE) AND
	coalesce(nullif(expanded_cves.cpe_target_hw, '*') = nullif(manual_cpes.cpe_target_hw, '*'), TRUE) AND
	coalesce(nullif(expanded_cves.cpe_other, '*') = nullif(manual_cpes.cpe_other, '*'), TRUE)
WHERE effname = %(effname)s
ORDER BY
	-- assuming CVE-xxxx-yyyyy format
	split_part(cve_id, '-', 2)::integer,
	split_part(cve_id, '-', 3)::integer,
	end_version::versiontext,
	start_version::versiontext NULLS FIRST;
