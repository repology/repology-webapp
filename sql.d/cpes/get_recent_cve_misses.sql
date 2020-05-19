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
WITH latest_cves AS (
	SELECT
		cve_id,
		added_ts,
		published,
		cpe_pairs
	FROM cves
	WHERE cpe_pairs IS NOT NULL
	ORDER BY
		added_ts DESC,
		published DESC
	LIMIT 500
), latest_cves_expanded AS (
	SELECT
		cve_id,
		added_ts,
		published,
		split_part(unnest(cpe_pairs), ':', 1) AS cpe_vendor,
		split_part(unnest(cpe_pairs), ':', 2) AS cpe_product
	FROM latest_cves
), latest_cves_expanded_with_matches AS (
	SELECT
		*,
		EXISTS (
			SELECT *
			FROM all_cpes
			WHERE
				all_cpes.cpe_vendor = latest_cves_expanded.cpe_vendor AND
				all_cpes.cpe_product = latest_cves_expanded.cpe_product
		) AS match
	FROM latest_cves_expanded
), latest_cves_expanded_with_matches_expanded AS (
    SELECT
        cve_id,
		added_ts,
        published,
        cpe_vendor,
        cpe_product,
        bool_or(match) OVER(partition BY cve_id) AS match
    FROM
        latest_cves_expanded_with_matches
)
SELECT
	cve_id,
	published,
	cpe_vendor,
	cpe_product,
	EXISTS(SELECT * FROM metapackages WHERE effname = cpe_product) AS has_project
FROM latest_cves_expanded_with_matches_expanded
WHERE NOT match
ORDER BY
	added_ts DESC,
	published DESC,
	split_part(cve_id, '-', 2)::integer DESC,
	split_part(cve_id, '-', 3)::integer DESC,
	cpe_vendor,
	cpe_product;
