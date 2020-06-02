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
WITH expanded_cves AS (
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
		jsonb_array_elements(matches)->>7 AS cpe_other,

		jsonb_array_elements(matches)->>8 AS start_version,
		jsonb_array_elements(matches)->>9 AS end_version,
		(jsonb_array_elements(matches)->>10)::boolean AS start_version_excluded,
        (jsonb_array_elements(matches)->>11)::boolean AS end_version_excluded
	FROM cves
)
SELECT
	expanded_cves.*,
	effname
FROM expanded_cves
INNER JOIN manual_cpes ON
    expanded_cves.cpe_vendor = manual_cpes.cpe_vendor AND
    expanded_cves.cpe_product = manual_cpes.cpe_product AND
    coalesce(nullif(expanded_cves.cpe_edition, '*') = nullif(manual_cpes.cpe_edition, '*'), TRUE) AND
    coalesce(nullif(expanded_cves.cpe_lang, '*') = nullif(manual_cpes.cpe_lang, '*'), TRUE) AND
    coalesce(nullif(expanded_cves.cpe_sw_edition, '*') = nullif(manual_cpes.cpe_sw_edition, '*'), TRUE) AND
    coalesce(nullif(expanded_cves.cpe_target_sw, '*') = nullif(manual_cpes.cpe_target_sw, '*'), TRUE) AND
    coalesce(nullif(expanded_cves.cpe_target_hw, '*') = nullif(manual_cpes.cpe_target_hw, '*'), TRUE) AND
    coalesce(nullif(expanded_cves.cpe_other, '*') = nullif(manual_cpes.cpe_other, '*'), TRUE)
WHERE end_version IS NULL
ORDER BY effname, cve_id;
