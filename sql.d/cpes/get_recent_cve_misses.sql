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
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH latest_modified_cves AS (
	SELECT
		cve_id,
		last_modified,
		matches
	FROM cves
	WHERE cpe_pairs IS NOT NULL
	ORDER BY last_modified DESC
	LIMIT 2000
), cves_expanded AS (
	SELECT
		cve_id,
		last_modified,
		jsonb_array_elements(matches)->>0 AS cpe_vendor,
		jsonb_array_elements(matches)->>1 AS cpe_product,
		jsonb_array_elements(matches)->>2 AS cpe_edition,
		jsonb_array_elements(matches)->>3 AS cpe_lang,
		jsonb_array_elements(matches)->>4 AS cpe_sw_edition,
		jsonb_array_elements(matches)->>5 AS cpe_target_sw,
		jsonb_array_elements(matches)->>6 AS cpe_target_hw,
		jsonb_array_elements(matches)->>7 AS cpe_other
	FROM latest_modified_cves
), cves_expanded_unmatched AS (
	SELECT
		*
	FROM cves_expanded
	WHERE
		NOT EXISTS (
			SELECT *
			FROM manual_cpes
			WHERE
				cpe_vendor = cves_expanded.cpe_vendor AND
				cpe_product = cves_expanded.cpe_product AND
				coalesce(nullif(cpe_edition, '*') = nullif(cves_expanded.cpe_edition, '*'), TRUE) AND
				coalesce(nullif(cpe_lang, '*') = nullif(cves_expanded.cpe_lang, '*'), TRUE) AND
				coalesce(nullif(cpe_sw_edition, '*') = nullif(cves_expanded.cpe_sw_edition, '*'), TRUE) AND
				coalesce(nullif(cpe_target_sw, '*') = nullif(cves_expanded.cpe_target_sw, '*'), TRUE) AND
				coalesce(nullif(cpe_target_hw, '*') = nullif(cves_expanded.cpe_target_hw, '*'), TRUE) AND
				coalesce(nullif(cpe_other, '*') = nullif(cves_expanded.cpe_other, '*'), TRUE)
		)
)
SELECT
	max(last_modified) AS last_modified,
	cpe_vendor,
	cpe_product,
	cpe_edition,
	cpe_lang,
	cpe_sw_edition,
	cpe_target_sw,
	cpe_target_hw,
	cpe_other,
	array_agg(
		DISTINCT cve_id
		ORDER BY cve_id
	) AS cve_ids,
	EXISTS(SELECT * FROM metapackages WHERE effname = cpe_product) AS has_project
FROM cves_expanded_unmatched
GROUP BY
	cpe_vendor,
	cpe_product,
	cpe_edition,
	cpe_lang,
	cpe_sw_edition,
	cpe_target_sw,
	cpe_target_hw,
	cpe_other
ORDER BY
	last_modified DESC,
	cpe_vendor,
	cpe_product,
	cpe_edition,
	cpe_lang,
	cpe_sw_edition,
	cpe_target_sw,
	cpe_target_hw,
	cpe_other;
