-- Copyright (C) 2021 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param max_age
-- @param limit=None
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH expanded_matches AS (
	SELECT DISTINCT
		cve_id,
		published,

		jsonb_array_elements(matches)->>0 AS cpe_vendor,
		jsonb_array_elements(matches)->>1 AS cpe_product,
		jsonb_array_elements(matches)->>2 AS cpe_edition,
		jsonb_array_elements(matches)->>3 AS cpe_lang,
		jsonb_array_elements(matches)->>4 AS cpe_sw_edition,
		jsonb_array_elements(matches)->>5 AS cpe_target_sw,
		jsonb_array_elements(matches)->>6 AS cpe_target_hw,
		jsonb_array_elements(matches)->>7 AS cpe_other
	FROM cves
	WHERE published > now() - %(max_age)s
)
SELECT
	published,
	cve_id,
	manual_cpes.added_ts > now() - interval '7 day' AS recent,
	array_agg(DISTINCT effname ORDER BY effname) AS effnames
FROM expanded_matches INNER JOIN manual_cpes ON
	expanded_matches.cpe_product = manual_cpes.cpe_product AND
	expanded_matches.cpe_vendor = manual_cpes.cpe_vendor AND
	coalesce(nullif(expanded_matches.cpe_edition, '*') = nullif(manual_cpes.cpe_edition, '*'), TRUE) AND
	coalesce(nullif(expanded_matches.cpe_lang, '*') = nullif(manual_cpes.cpe_lang, '*'), TRUE) AND
	coalesce(nullif(expanded_matches.cpe_sw_edition, '*') = nullif(manual_cpes.cpe_sw_edition, '*'), TRUE) AND
	coalesce(nullif(expanded_matches.cpe_target_sw, '*') = nullif(manual_cpes.cpe_target_sw, '*'), TRUE) AND
	coalesce(nullif(expanded_matches.cpe_target_hw, '*') = nullif(manual_cpes.cpe_target_hw, '*'), TRUE) AND
	coalesce(nullif(expanded_matches.cpe_other, '*') = nullif(manual_cpes.cpe_other, '*'), TRUE)
GROUP BY cve_id, published, recent
ORDER BY published DESC, cve_id DESC
LIMIT %(limit)s;
