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
-- @returns array of tuples
--------------------------------------------------------------------------------
WITH candidates AS (
	SELECT
		%(effname)s AS effname,
		cpe_vendor,
		cpe_product
	FROM (
		SELECT DISTINCT
			split_part(unnest(cpe_pairs), ':', 1) AS cpe_vendor,
			split_part(unnest(cpe_pairs), ':', 2) AS cpe_product
		FROM cves
	) AS tmp
	WHERE cpe_product = %(effname)s
), inserted AS (
	INSERT INTO manual_cpes (
		effname,
		cpe_vendor,
		cpe_product
	)
	SELECT *
	FROM candidates
	WHERE
		NOT EXISTS(
			SELECT *
			FROM project_cpe
			WHERE
				project_cpe.effname = candidates.effname AND
				project_cpe.cpe_vendor = candidates.cpe_vendor AND
				project_cpe.cpe_product = candidates.cpe_product
		) AND EXISTS (
			SELECT *
			FROM cves
			WHERE cpe_pairs @> ARRAY[cpe_vendor || ':' || cpe_product]
		)
	ON CONFLICT(effname, cpe_vendor, cpe_product)
	DO NOTHING
	RETURNING cpe_vendor, cpe_product
), register_cpe_updates AS (
    INSERT INTO cpe_updates (cpe_vendor, cpe_product)
	SELECT cpe_vendor, cpe_product FROM inserted
)
SELECT
	cpe_vendor,
	cpe_product
FROM inserted;
