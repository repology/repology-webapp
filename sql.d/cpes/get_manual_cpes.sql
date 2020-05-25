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
SELECT
	effname,
	cpe_vendor,
    cpe_product,
    cpe_edition,
    cpe_lang,
    cpe_sw_edition,
    cpe_target_sw,
    cpe_target_hw,
    cpe_other,
	EXISTS (
		SELECT * FROM metapackages WHERE effname = manual_cpes.effname AND num_repos > 0
	) AS has_alive_project,
	EXISTS (
		SELECT * FROM project_redirects AS old INNER JOIN project_redirects AS new USING(repository_id, trackname)
		WHERE NOT old.is_actual AND new.is_actual AND old.project_id = (SELECT id FROM metapackages WHERE effname = manual_cpes.effname)
	) AS has_project_redirect,
	EXISTS (
		SELECT * FROM vulnerable_cpes WHERE
			cpe_vendor = manual_cpes.cpe_vendor AND
			cpe_product = manual_cpes.cpe_product AND
			coalesce(nullif(cpe_edition, '*') = nullif(manual_cpes.cpe_edition, '*'), TRUE) AND
			coalesce(nullif(cpe_lang, '*') = nullif(manual_cpes.cpe_lang, '*'), TRUE) AND
			coalesce(nullif(cpe_sw_edition, '*') = nullif(manual_cpes.cpe_sw_edition, '*'), TRUE) AND
			coalesce(nullif(cpe_target_sw, '*') = nullif(manual_cpes.cpe_target_sw, '*'), TRUE) AND
			coalesce(nullif(cpe_target_hw, '*') = nullif(manual_cpes.cpe_target_hw, '*'), TRUE) AND
			coalesce(nullif(cpe_other, '*') = nullif(manual_cpes.cpe_other, '*'), TRUE)
	) AS has_cves,
	EXISTS (
		SELECT * FROM cpe_dictionary WHERE
			cpe_vendor = manual_cpes.cpe_vendor AND
			cpe_product = manual_cpes.cpe_product AND
			coalesce(nullif(cpe_edition, '*') = nullif(manual_cpes.cpe_edition, '*'), TRUE) AND
			coalesce(nullif(cpe_lang, '*') = nullif(manual_cpes.cpe_lang, '*'), TRUE) AND
			coalesce(nullif(cpe_sw_edition, '*') = nullif(manual_cpes.cpe_sw_edition, '*'), TRUE) AND
			coalesce(nullif(cpe_target_sw, '*') = nullif(manual_cpes.cpe_target_sw, '*'), TRUE) AND
			coalesce(nullif(cpe_target_hw, '*') = nullif(manual_cpes.cpe_target_hw, '*'), TRUE) AND
			coalesce(nullif(cpe_other, '*') = nullif(manual_cpes.cpe_other, '*'), TRUE)
	) AS has_dict
FROM manual_cpes
ORDER BY effname, cpe_vendor, cpe_product, cpe_edition, cpe_lang, cpe_sw_edition, cpe_target_sw, cpe_target_hw, cpe_other;
