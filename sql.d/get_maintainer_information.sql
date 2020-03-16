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
--
-- @param maintainer
--
-- @returns single dict
--
--------------------------------------------------------------------------------
SELECT
	num_packages,
	num_packages_newest,
	num_packages_outdated,
	num_packages_ignored,
	num_packages_unique,
	num_packages_devel,
	num_packages_legacy,
	num_packages_incorrect,
	num_packages_untrusted,
	num_packages_noscheme,
	num_packages_rolling,

	num_projects,
    num_projects_newest,
    num_projects_outdated,
    num_projects_problematic,

	(SELECT jsonb_object_agg(key, (value->>0)::integer) FROM jsonb_each(counts_per_repo)) AS num_packages_per_repo,

	(SELECT jsonb_object_agg(key, (value->>1)::integer) FROM jsonb_each(counts_per_repo)) AS num_projects_per_repo,
	(SELECT jsonb_object_agg(key, (value->>2)::integer) FROM jsonb_each(counts_per_repo)) AS num_projects_newest_per_repo,
	(SELECT jsonb_object_agg(key, (value->>3)::integer) FROM jsonb_each(counts_per_repo)) AS num_projects_outdated_per_repo,
	(SELECT jsonb_object_agg(key, (value->>4)::integer) FROM jsonb_each(counts_per_repo)) AS num_projects_problematic_per_repo,

	num_projects_per_category,

	first_seen,
	orphaned_at,
	now() - first_seen AS first_seen_ago,
	now() - orphaned_at AS orphaned_ago
FROM maintainers
WHERE maintainer = %(maintainer)s;
