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
--
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH inserted AS (
	INSERT INTO manual_cpes (
		effname,
		cpe_vendor,
		cpe_product,
		cpe_edition,
		cpe_lang,
		cpe_sw_edition,
		cpe_target_sw,
		cpe_target_hw,
		cpe_other
	)
	SELECT
		cpe_product AS effname,
		cpe_vendor,
		cpe_product,
		cpe_edition,
		cpe_lang,
		cpe_sw_edition,
		cpe_target_sw,
		cpe_target_hw,
		cpe_other
	FROM vulnerable_cpes
	WHERE cpe_product = %(effname)s
	ON CONFLICT DO NOTHING
	RETURNING *
), register_cpe_updates AS (
    INSERT INTO cpe_updates (cpe_vendor, cpe_product)
	SELECT cpe_vendor, cpe_product FROM inserted
)
SELECT *
FROM inserted;
