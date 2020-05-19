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
-- @param new_effname=None
-- @param new_cpe_vendor=None
-- @param new_cpe_product=None
--------------------------------------------------------------------------------
UPDATE manual_cpes
SET
	effname = CASE WHEN %(new_effname)s IS NOT NULL THEN %(new_effname)s ELSE effname END,
	cpe_vendor = CASE WHEN %(new_cpe_vendor)s IS NOT NULL THEN %(new_cpe_vendor)s ELSE cpe_vendor END,
	cpe_product = CASE WHEN %(new_cpe_product)s IS NOT NULL THEN %(new_cpe_product)s ELSE cpe_product END
WHERE
	effname = %(effname)s AND
	cpe_vendor = %(cpe_vendor)s AND
	cpe_product = %(cpe_product)s;
