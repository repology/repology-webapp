-- Copyright (C) 2016-2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param limit
--
-- @returns dict of dicts
--------------------------------------------------------------------------------
SELECT
	effname,
	rank,
	num_families,
	has_related
FROM project_get_related(
	(SELECT id FROM metapackages WHERE effname=%(effname)s),
	%(limit)s
)
INNER JOIN metapackages ON (metapackages.id = related_project_id)
ORDER BY rank DESC, effname;
