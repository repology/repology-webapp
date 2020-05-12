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
	EXISTS (
		SELECT
			*
		FROM project_cpe
		WHERE project_cpe.cpe_vendor = manual_cpes.cpe_vendor AND project_cpe.cpe_product = manual_cpes.cpe_product
	) AS redundant,
	EXISTS (
		SELECT
			*
		FROM metapackages
		WHERE metapackages.effname = manual_cpes.effname AND num_repos > 0
	) AS has_project,
	EXISTS (
		SELECT
			*
		FROM vulnerable_versions
		WHERE vulnerable_versions.cpe_vendor = manual_cpes.cpe_vendor AND vulnerable_versions.cpe_product = manual_cpes.cpe_product
	) AS has_cves
FROM manual_cpes
ORDER BY effname, cpe_vendor, cpe_product;
