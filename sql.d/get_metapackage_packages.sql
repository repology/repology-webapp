-- Copyright (C) 2016-2018 Dmitry Marakasov <amdmi3@amdmi3.ru>
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
-- @param effname
-- @param fields=None
-- @param minimal=False
-- @param summarizable=False
-- @param detailed=False
-- @param url=False
-- @param repo=None
--
-- @returns array of dicts
--
--------------------------------------------------------------------------------
SELECT
{% if minimal or summarizable or detailed %}
	repo,
	family,

	visiblename,
	effname,

	version,
	versionclass,

	flags
{%  if summarizable or detailed %},
	maintainers
{%   if detailed %},
	subrepo,

	name,
	srcname,
	binname,
	trackname,

	origversion,
	rawversion,

	category,
	comment,
	licenses,
	extrafields,
	links
{%   endif %}
{%   if url %},
	(
		SELECT url
		FROM links
		WHERE id IN (
			SELECT
				link_id
			FROM (
				SELECT
					(json_array_elements(links)->>0)::integer AS link_type,
					(json_array_elements(links)->>1)::integer AS link_id
			) AS expanded_links
			WHERE
				link_type IN (
					5, -- PACKAGE_HOMEPAGE
					24, -- PACKAGE_REPOSITORY_DIR
					7 -- PACKAGE_REPOSITORY
				)
		) AND coalesce(ipv4_success, true)
		LIMIT 1
	) AS url
{%   endif %}
{%  endif %}
{% elif fields %}
	{{ fields | join(',') }}
{% endif %}
FROM packages
WHERE
	effname = %(effname)s
	{% if repo is not none %}
		AND repo = %(repo)s
	{% endif %};
