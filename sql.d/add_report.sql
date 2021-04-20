-- Copyright (C) 2016-2018,2020 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param need_verignore
-- @param need_split
-- @param need_merge
-- @param need_vuln
-- @param comment
--------------------------------------------------------------------------------
INSERT INTO reports (
	effname,
	need_verignore,
	need_split,
	need_merge,
	need_vuln,
	comment
) VALUES (
	%(effname)s,
	%(need_verignore)s,
	%(need_split)s,
	%(need_merge)s,
	%(need_vuln)s,
	%(comment)s
);
