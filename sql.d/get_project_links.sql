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
-- @param effname
--
-- @returns dict of dicts
--------------------------------------------------------------------------------
WITH link_ids AS (
	SELECT DISTINCT (json_array_elements(links)->>1)::integer AS id
	FROM packages
	WHERE effname = %(effname)s
)
SELECT
	id,
	url,
	last_checked,
	ipv4_success,
	ipv4_permanent_redirect_target,
	ipv6_success,
	ipv6_permanent_redirect_target
FROM links INNER JOIN link_ids USING(id);
