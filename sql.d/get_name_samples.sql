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
-- @param nsamples
-- @returns array of dicts
--------------------------------------------------------------------------------
SELECT
	*
FROM (
	SELECT
		*,
		row_number() OVER (PARTITION BY repo ORDER BY score DESC) AS nsample
	FROM (
		SELECT
			repo,
			effname,
			projectname_seed,
			trackname,
			srcname,
			binname,
			(
				SELECT
					count(DISTINCT n) FILTER (WHERE n != 'null'::jsonb)
				FROM (
					SELECT jsonb_array_elements(
						jsonb_build_array(
							effname,
							projectname_seed,
							trackname,
							srcname,
							binname
						)
					) AS n
				) AS tmp
			) AS score
		FROM packages
	) AS tmp
) AS tmp1
WHERE
	nsample <= %(nsamples)s
ORDER BY repo, effname;
