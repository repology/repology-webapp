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
-- @param cpe_vendor
-- @param cpe_product
-- @param cpe_edition
-- @param cpe_lang
-- @param cpe_sw_edition
-- @param cpe_target_sw
-- @param cpe_target_hw
-- @param cpe_other
--
-- @returns array of dicts
--------------------------------------------------------------------------------
WITH deleted AS (
	DELETE
	FROM manual_cpes
	WHERE
		effname=%(effname)s AND
		cpe_vendor=%(cpe_vendor)s AND
		cpe_product=%(cpe_product)s AND
		cpe_edition=%(cpe_edition)s AND
		cpe_lang=%(cpe_lang)s AND
		cpe_sw_edition=%(cpe_sw_edition)s AND
		cpe_target_sw=%(cpe_target_sw)s AND
		cpe_target_hw=%(cpe_target_hw)s AND
		cpe_other=%(cpe_other)s
	RETURNING *
), register_update AS (
	INSERT INTO cpe_updates (cpe_vendor, cpe_product)
	SELECT cpe_vendor, cpe_product FROM deleted
)
SELECT *
FROM deleted;
