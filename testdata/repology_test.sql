--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP INDEX public.url_relations_urlhash_metapackage_id_idx;
DROP INDEX public.url_relations_metapackage_id_urlhash_idx;
DROP INDEX public.url_relations_all_metapackage_id_idx;
DROP INDEX public.runs_repository_id_start_ts_idx_failed;
DROP INDEX public.runs_repository_id_start_ts_idx;
DROP INDEX public.repository_project_maintainers_project_id_idx;
DROP INDEX public.repository_events_repository_id_ts_idx;
DROP INDEX public.repositories_name_idx;
DROP INDEX public.reports_updated_idx;
DROP INDEX public.reports_effname_created_idx;
DROP INDEX public.reports_created_idx;
DROP INDEX public.repo_metapackages_effname_idx;
DROP INDEX public.project_redirects_repository_id_trackname_idx;
DROP INDEX public.project_redirects_project_id_repository_id_trackname_idx;
DROP INDEX public.project_redirects_manual_newname_idx;
DROP INDEX public.project_names_project_id_idx;
DROP INDEX public.project_names_name_repository_id_idx;
DROP INDEX public.problems_repo_effname_idx;
DROP INDEX public.problems_maintainer_idx;
DROP INDEX public.problems_effname_idx;
DROP INDEX public.packages_effname_idx;
DROP INDEX public.metapackages_recently_removed_idx;
DROP INDEX public.metapackages_recently_added_idx;
DROP INDEX public.metapackages_num_repos_newest_idx;
DROP INDEX public.metapackages_num_repos_idx;
DROP INDEX public.metapackages_num_families_newest_idx;
DROP INDEX public.metapackages_num_families_idx;
DROP INDEX public.metapackages_events_effname_ts_idx;
DROP INDEX public.metapackages_effname_trgm;
DROP INDEX public.metapackages_effname_idx;
DROP INDEX public.metapackages_active_idx;
DROP INDEX public.maintainers_recently_removed_idx;
DROP INDEX public.maintainers_recently_added_idx;
DROP INDEX public.maintainers_maintainer_trgm;
DROP INDEX public.maintainers_maintainer_idx;
DROP INDEX public.maintainers_active_idx;
DROP INDEX public.maintainer_repo_metapackages__maintainer_id_repository_id_t_idx;
DROP INDEX public.maintainer_metapackages_effname_idx;
DROP INDEX public.maintainer_and_repo_metapackages_effname_idx;
DROP INDEX public.links_next_check_idx;
DROP INDEX public.category_metapackages_effname_idx;
ALTER TABLE ONLY public.statistics_history DROP CONSTRAINT statistics_history_pkey;
ALTER TABLE ONLY public.runs DROP CONSTRAINT runs_pkey;
ALTER TABLE ONLY public.repositories DROP CONSTRAINT repositories_pkey;
ALTER TABLE ONLY public.repositories_history DROP CONSTRAINT repositories_history_pkey;
ALTER TABLE ONLY public.repositories_history_new DROP CONSTRAINT repositories_history_new_pkey;
ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
ALTER TABLE ONLY public.repo_tracks DROP CONSTRAINT repo_tracks_pkey;
ALTER TABLE ONLY public.repo_track_versions DROP CONSTRAINT repo_track_versions_pkey;
ALTER TABLE ONLY public.repo_metapackages DROP CONSTRAINT repo_metapackages_pkey;
ALTER TABLE ONLY public.project_releases DROP CONSTRAINT project_releases_pkey;
ALTER TABLE ONLY public.project_redirects_manual DROP CONSTRAINT project_redirects_manual_pkey;
ALTER TABLE ONLY public.project_hashes DROP CONSTRAINT project_hashes_pkey;
ALTER TABLE ONLY public.packages DROP CONSTRAINT packages_pkey;
ALTER TABLE ONLY public.metapackages DROP CONSTRAINT metapackages_pkey;
ALTER TABLE ONLY public.maintainers DROP CONSTRAINT maintainers_pkey;
ALTER TABLE ONLY public.maintainer_metapackages DROP CONSTRAINT maintainer_metapackages_pkey;
ALTER TABLE ONLY public.maintainer_and_repo_metapackages DROP CONSTRAINT maintainer_and_repo_metapackages_pkey;
ALTER TABLE ONLY public.log_lines DROP CONSTRAINT log_lines_pkey;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey;
ALTER TABLE ONLY public.category_metapackages DROP CONSTRAINT category_metapackages_pkey;
DROP TABLE public.url_relations_all;
DROP TABLE public.url_relations;
DROP TABLE public.statistics_history;
DROP TABLE public.statistics;
DROP TABLE public.runs;
DROP TABLE public.repository_project_maintainers;
DROP TABLE public.repository_events;
DROP TABLE public.repositories_history_new;
DROP TABLE public.repositories_history;
DROP TABLE public.repositories;
DROP TABLE public.reports;
DROP TABLE public.repo_tracks;
DROP TABLE public.repo_track_versions;
DROP TABLE public.repo_metapackages;
DROP TABLE public.project_turnover;
DROP TABLE public.project_releases;
DROP TABLE public.project_redirects_manual;
DROP TABLE public.project_redirects;
DROP TABLE public.project_names;
DROP TABLE public.project_hashes;
DROP TABLE public.problems;
DROP TABLE public.packages;
DROP TABLE public.metapackages_events;
DROP TABLE public.metapackages;
DROP TABLE public.maintainers;
DROP TABLE public.maintainer_repo_metapackages_events;
DROP TABLE public.maintainer_metapackages;
DROP TABLE public.maintainer_and_repo_metapackages;
DROP TABLE public.log_lines;
DROP TABLE public.links;
DROP TABLE public.category_metapackages;
DROP FUNCTION public.version_set_changed(old text[], new text[]);
DROP FUNCTION public.simplify_url(url text);
DROP FUNCTION public.nullifless(value1 integer, value2 integer);
DROP FUNCTION public.nullifless(value1 double precision, value2 double precision);
DROP FUNCTION public.metapackage_create_events_trigger();
DROP FUNCTION public.maintainer_repo_metapackages_create_events_trigger();
DROP FUNCTION public.is_ignored_by_masks(statuses_mask integer, flags_mask integer);
DROP FUNCTION public.get_added_active_repos(oldrepos text[], newrepos text[]);
DROP TYPE public.run_type;
DROP TYPE public.run_status;
DROP TYPE public.repository_state;
DROP TYPE public.project_name_type;
DROP TYPE public.metapackage_event_type;
DROP TYPE public.maintainer_repo_metapackages_event_type;
DROP TYPE public.log_severity;
--
-- Name: libversion; Type: EXTENSION; Schema: -; Owner: -
--



--
-- Name: EXTENSION libversion; Type: COMMENT; Schema: -; Owner: 
--



--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--



--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--



--
-- Name: log_severity; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.log_severity AS ENUM (
    'notice',
    'warning',
    'error'
);


ALTER TYPE public.log_severity OWNER TO repology_test;

--
-- Name: maintainer_repo_metapackages_event_type; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.maintainer_repo_metapackages_event_type AS ENUM (
    'added',
    'uptodate',
    'outdated',
    'ignored',
    'removed'
);


ALTER TYPE public.maintainer_repo_metapackages_event_type OWNER TO repology_test;

--
-- Name: metapackage_event_type; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.metapackage_event_type AS ENUM (
    'history_start',
    'repos_update',
    'version_update',
    'catch_up',
    'history_end'
);


ALTER TYPE public.metapackage_event_type OWNER TO repology_test;

--
-- Name: project_name_type; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.project_name_type AS ENUM (
    'name',
    'srcname',
    'binname'
);


ALTER TYPE public.project_name_type OWNER TO repology_test;

--
-- Name: repository_state; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.repository_state AS ENUM (
    'new',
    'active',
    'legacy',
    'readded'
);


ALTER TYPE public.repository_state OWNER TO repology_test;

--
-- Name: run_status; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.run_status AS ENUM (
    'running',
    'successful',
    'failed',
    'interrupted'
);


ALTER TYPE public.run_status OWNER TO repology_test;

--
-- Name: run_type; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.run_type AS ENUM (
    'fetch',
    'parse',
    'database_push',
    'database_postprocess'
);


ALTER TYPE public.run_type OWNER TO repology_test;

--
-- Name: get_added_active_repos(text[], text[]); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.get_added_active_repos(oldrepos text[], newrepos text[]) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
	RETURN array((SELECT unnest(newrepos) EXCEPT SELECT unnest(oldrepos)) INTERSECT SELECT name FROM repositories WHERE state = 'active');
END;
$$;


ALTER FUNCTION public.get_added_active_repos(oldrepos text[], newrepos text[]) OWNER TO repology_test;

--
-- Name: is_ignored_by_masks(integer, integer); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.is_ignored_by_masks(statuses_mask integer, flags_mask integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
	RETURN (statuses_mask & ((1<<3) | (1<<7) | (1<<8) | (1<<9) | (1<<10)))::boolean OR (flags_mask & ((1<<2) | (1<<3) | (1<<4) | (1<<5) | (1<<7)))::boolean;
END;
$$;


ALTER FUNCTION public.is_ignored_by_masks(statuses_mask integer, flags_mask integer) OWNER TO repology_test;

--
-- Name: maintainer_repo_metapackages_create_events_trigger(); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.maintainer_repo_metapackages_create_events_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	-- remove
	IF (TG_OP = 'DELETE') THEN
		IF (EXISTS (SELECT * FROM repositories WHERE id = OLD.repository_id AND state = 'active'::repository_state)) THEN
			PERFORM maintainer_repo_metapackages_create_event(OLD.maintainer_id, OLD.repository_id, OLD.metapackage_id, 'removed'::maintainer_repo_metapackages_event_type, '{}'::jsonb);
		END IF;
		RETURN NULL;
	END IF;

	IF (NOT EXISTS (SELECT * FROM repositories WHERE id = NEW.repository_id AND state = 'active'::repository_state)) THEN
		RETURN NULL;
	END IF;

	-- add
	IF (TG_OP = 'INSERT') THEN
		PERFORM maintainer_repo_metapackages_create_event(NEW."maintainer_id", NEW.repository_id, NEW.metapackage_id, 'added'::maintainer_repo_metapackages_event_type, '{}'::jsonb);
	END IF;

	-- update
	IF (NEW.versions_uptodate IS NOT NULL AND (TG_OP = 'INSERT' OR OLD.versions_uptodate[1] IS DISTINCT FROM NEW.versions_uptodate[1])) THEN
		PERFORM maintainer_repo_metapackages_create_event(NEW.maintainer_id, NEW.repository_id, NEW.metapackage_id, 'uptodate'::maintainer_repo_metapackages_event_type,
			jsonb_build_object('version', NEW.versions_uptodate[1])
		);
	END IF;

	IF (NEW.versions_outdated IS NOT NULL AND (TG_OP = 'INSERT' OR OLD.versions_outdated[1] IS DISTINCT FROM NEW.versions_outdated[1])) THEN
		PERFORM maintainer_repo_metapackages_create_event(NEW.maintainer_id, NEW.repository_id, NEW.metapackage_id, 'outdated'::maintainer_repo_metapackages_event_type,
			jsonb_build_object(
				'version', NEW.versions_outdated[1],
				'newest_versions', (SELECT devel_versions||newest_versions FROM metapackages WHERE id = NEW.metapackage_id)
			)
		);
	END IF;

	IF (NEW.versions_ignored IS NOT NULL AND (TG_OP = 'INSERT' OR OLD.versions_ignored[1] IS DISTINCT FROM NEW.versions_ignored[1])) THEN
		PERFORM maintainer_repo_metapackages_create_event(NEW.maintainer_id, NEW.repository_id, NEW.metapackage_id, 'ignored'::maintainer_repo_metapackages_event_type,
			jsonb_build_object('version', NEW.versions_ignored[1])
		);
	END IF;

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.maintainer_repo_metapackages_create_events_trigger() OWNER TO repology_test;

--
-- Name: metapackage_create_events_trigger(); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.metapackage_create_events_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	catch_up text[];
	repos_added text[];
	repos_removed text[];
BEGIN
	-- history_start
	IF (NEW.all_repos IS NOT NULL AND (TG_OP = 'INSERT' OR OLD.all_repos IS NULL)) THEN
		PERFORM metapackage_create_event(NEW.effname, 'history_start'::metapackage_event_type,
			jsonb_build_object(
				'devel_versions', NEW.devel_versions,
				'newest_versions', NEW.newest_versions,
				'devel_repos', NEW.devel_repos,
				'newest_repos', NEW.newest_repos,
				'all_repos', NEW.all_repos
			)
		);

		RETURN NULL;
	END IF;

	-- history_end
	IF (NEW.all_repos IS NULL AND OLD.all_repos IS NOT NULL) THEN
		PERFORM metapackage_create_event(NEW.effname, 'history_end'::metapackage_event_type,
			jsonb_build_object(
				'last_repos', OLD.all_repos
			)
		);

		RETURN NULL;
	END IF;

	-- repos_update
	repos_added := (SELECT get_added_active_repos(OLD.all_repos, NEW.all_repos));
	repos_removed := (SELECT get_added_active_repos(NEW.all_repos, OLD.all_repos));
	IF (repos_added != repos_removed) THEN
		PERFORM metapackage_create_event(NEW.effname, 'repos_update'::metapackage_event_type,
			jsonb_build_object(
				'repos_added', repos_added,
				'repos_removed', repos_removed
			)
		);
	END IF;

	-- version_update & catch_up for devel
	IF (version_set_changed(OLD.devel_versions, NEW.devel_versions)) THEN
		PERFORM metapackage_create_event(NEW.effname, 'version_update'::metapackage_event_type,
			jsonb_build_object(
				'branch', 'devel',
				'versions', NEW.devel_versions,
				'repos', NEW.devel_repos,
				'passed',
					CASE
						WHEN
							-- only account if the repository hasn't just appeared
							EXISTS (SELECT unnest(NEW.devel_repos) INTERSECT SELECT unnest(OLD.all_repos))
						THEN
							extract(epoch FROM now() - OLD.devel_version_update)
						ELSE NULL
					END
			)
		);
	ELSE
		catch_up := (SELECT get_added_active_repos(OLD.devel_repos, NEW.devel_repos));
		IF (catch_up != '{}') THEN
			PERFORM metapackage_create_event(NEW.effname, 'catch_up'::metapackage_event_type,
				jsonb_build_object(
					'branch', 'devel',
					'repos', catch_up,
					'lag',
						CASE
							WHEN
								-- only account if the repository hasn't just appeared
								EXISTS (SELECT unnest(NEW.devel_repos) INTERSECT SELECT unnest(OLD.all_repos))
							THEN
								extract(epoch FROM now() - OLD.devel_version_update)
							ELSE NULL
						END
				)
			);
		END IF;
	END IF;

	-- version_update & catch_up for newest
	IF (version_set_changed(OLD.newest_versions, NEW.newest_versions)) THEN
		PERFORM metapackage_create_event(NEW.effname, 'version_update'::metapackage_event_type,
			jsonb_build_object(
				'branch', 'newest',
				'versions', NEW.newest_versions,
				'repos', NEW.newest_repos,
				'passed',
					CASE
						WHEN
							-- only account if the repository hasn't just appeared
							EXISTS (SELECT unnest(NEW.newest_repos) INTERSECT SELECT unnest(OLD.all_repos))
						THEN
							extract(epoch FROM now() - OLD.newest_version_update)
						ELSE NULL
					END
			)
		);
	ELSE
		catch_up := (SELECT get_added_active_repos(OLD.newest_repos, NEW.newest_repos));
		IF (catch_up != '{}') THEN
			PERFORM metapackage_create_event(NEW.effname, 'catch_up'::metapackage_event_type,
				jsonb_build_object(
					'branch', 'newest',
					'repos', catch_up,
					'lag',
						CASE
							WHEN
								-- only account if the repository hasn't just appeared
								EXISTS (SELECT unnest(NEW.newest_repos) INTERSECT SELECT unnest(OLD.all_repos))
							THEN
								extract(epoch FROM now() - OLD.newest_version_update)
							ELSE NULL
						END
				)
			);
		END IF;
	END IF;

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.metapackage_create_events_trigger() OWNER TO repology_test;

--
-- Name: nullifless(double precision, double precision); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.nullifless(value1 double precision, value2 double precision) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
	RETURN CASE WHEN value1 < value2 THEN NULL ELSE value1 END;
END;
$$;


ALTER FUNCTION public.nullifless(value1 double precision, value2 double precision) OWNER TO repology_test;

--
-- Name: nullifless(integer, integer); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.nullifless(value1 integer, value2 integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
	RETURN CASE WHEN value1 < value2 THEN NULL ELSE value1 END;
END;
$$;


ALTER FUNCTION public.nullifless(value1 integer, value2 integer) OWNER TO repology_test;

--
-- Name: simplify_url(text); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.simplify_url(url text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
BEGIN
	RETURN regexp_replace(
		regexp_replace(
			regexp_replace(
				regexp_replace(
					regexp_replace(
						regexp_replace(
							-- lowercase
							lower(url),
							-- unwrap archive.org links
							'^https?://web.archive.org/web/([0-9]{10}[^/]*/|\*/)?', ''
						),
						-- drop fragment
						'#.*$', ''
					),
					-- drop parameters
					'\?.*$', ''
				),
				-- drop trailing slash
				'/$', ''
			),
			-- drop schema
			'^https?://', ''
		),
		-- drop www.
		'^www\.', ''
	);
END;
$_$;


ALTER FUNCTION public.simplify_url(url text) OWNER TO repology_test;

--
-- Name: version_set_changed(text[], text[]); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.version_set_changed(old text[], new text[]) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
	RETURN
		(
			old IS NOT NULL AND
			new IS NOT NULL AND
			version_compare2(old[1], new[1]) != 0
		) OR (old IS NULL) != (new IS NULL);
END;
$$;


ALTER FUNCTION public.version_set_changed(old text[], new text[]) OWNER TO repology_test;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category_metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.category_metapackages (
    category text NOT NULL,
    effname text NOT NULL,
    "unique" boolean NOT NULL
);


ALTER TABLE public.category_metapackages OWNER TO repology_test;

--
-- Name: links; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.links (
    url text NOT NULL,
    first_extracted timestamp with time zone DEFAULT now() NOT NULL,
    orphaned_since timestamp with time zone,
    next_check timestamp with time zone DEFAULT now() NOT NULL,
    last_checked timestamp with time zone,
    ipv4_last_success timestamp with time zone,
    ipv4_last_failure timestamp with time zone,
    ipv4_success boolean,
    ipv4_status_code smallint,
    ipv4_permanent_redirect_target text,
    ipv6_last_success timestamp with time zone,
    ipv6_last_failure timestamp with time zone,
    ipv6_success boolean,
    ipv6_status_code smallint,
    ipv6_permanent_redirect_target text
);


ALTER TABLE public.links OWNER TO repology_test;

--
-- Name: log_lines; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.log_lines (
    run_id integer NOT NULL,
    lineno integer NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    severity public.log_severity NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.log_lines OWNER TO repology_test;

--
-- Name: maintainer_and_repo_metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.maintainer_and_repo_metapackages (
    maintainer_id integer NOT NULL,
    repository_id smallint NOT NULL,
    effname text NOT NULL,
    newest boolean NOT NULL,
    outdated boolean NOT NULL,
    problematic boolean NOT NULL
);


ALTER TABLE public.maintainer_and_repo_metapackages OWNER TO repology_test;

--
-- Name: maintainer_metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.maintainer_metapackages (
    maintainer_id integer NOT NULL,
    effname text NOT NULL,
    newest boolean NOT NULL,
    outdated boolean NOT NULL,
    problematic boolean NOT NULL
);


ALTER TABLE public.maintainer_metapackages OWNER TO repology_test;

--
-- Name: maintainer_repo_metapackages_events; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.maintainer_repo_metapackages_events (
    id integer NOT NULL,
    maintainer_id integer NOT NULL,
    repository_id smallint NOT NULL,
    ts timestamp with time zone NOT NULL,
    metapackage_id integer NOT NULL,
    type public.maintainer_repo_metapackages_event_type NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.maintainer_repo_metapackages_events OWNER TO repology_test;

--
-- Name: maintainer_repo_metapackages_events_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.maintainer_repo_metapackages_events ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.maintainer_repo_metapackages_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: maintainers; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.maintainers (
    id integer NOT NULL,
    maintainer text NOT NULL,
    num_packages integer DEFAULT 0 NOT NULL,
    num_packages_newest integer DEFAULT 0 NOT NULL,
    num_packages_outdated integer DEFAULT 0 NOT NULL,
    num_packages_ignored integer DEFAULT 0 NOT NULL,
    num_packages_unique integer DEFAULT 0 NOT NULL,
    num_packages_devel integer DEFAULT 0 NOT NULL,
    num_packages_legacy integer DEFAULT 0 NOT NULL,
    num_packages_incorrect integer DEFAULT 0 NOT NULL,
    num_packages_untrusted integer DEFAULT 0 NOT NULL,
    num_packages_noscheme integer DEFAULT 0 NOT NULL,
    num_packages_rolling integer DEFAULT 0 NOT NULL,
    num_projects integer DEFAULT 0 NOT NULL,
    num_projects_newest integer DEFAULT 0 NOT NULL,
    num_projects_outdated integer DEFAULT 0 NOT NULL,
    num_projects_problematic integer DEFAULT 0 NOT NULL,
    counts_per_repo jsonb,
    num_projects_per_category jsonb,
    num_repos integer DEFAULT 0 NOT NULL,
    first_seen timestamp with time zone DEFAULT now() NOT NULL,
    orphaned_at timestamp with time zone
);


ALTER TABLE public.maintainers OWNER TO repology_test;

--
-- Name: maintainers_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.maintainers ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.maintainers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.metapackages (
    id integer NOT NULL,
    effname text NOT NULL,
    num_repos smallint DEFAULT 0 NOT NULL,
    num_repos_nonshadow smallint DEFAULT 0 NOT NULL,
    num_families smallint DEFAULT 0 NOT NULL,
    num_repos_newest smallint DEFAULT 0 NOT NULL,
    num_families_newest smallint DEFAULT 0 NOT NULL,
    has_related boolean DEFAULT false NOT NULL,
    first_seen timestamp with time zone DEFAULT now() NOT NULL,
    orphaned_at timestamp with time zone
);


ALTER TABLE public.metapackages OWNER TO repology_test;

--
-- Name: metapackages_events; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.metapackages_events (
    effname text NOT NULL,
    ts timestamp with time zone NOT NULL,
    type public.metapackage_event_type NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.metapackages_events OWNER TO repology_test;

--
-- Name: metapackages_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.metapackages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.metapackages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: packages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.packages (
    id integer NOT NULL,
    repo text NOT NULL,
    family text NOT NULL,
    subrepo text,
    name text,
    srcname text,
    binname text,
    trackname text NOT NULL,
    visiblename text NOT NULL,
    projectname_seed text NOT NULL,
    origversion text NOT NULL,
    rawversion text NOT NULL,
    arch text,
    maintainers text[],
    category text,
    comment text,
    homepage text,
    licenses text[],
    downloads text[],
    extrafields jsonb NOT NULL,
    effname text NOT NULL,
    version text NOT NULL,
    versionclass smallint,
    flags integer NOT NULL,
    shadow boolean NOT NULL,
    flavors text[],
    branch text
);


ALTER TABLE public.packages OWNER TO repology_test;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.packages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: problems; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.problems (
    package_id integer NOT NULL,
    repo text NOT NULL,
    name text NOT NULL,
    effname text NOT NULL,
    maintainer text,
    problem text NOT NULL
);


ALTER TABLE public.problems OWNER TO repology_test;

--
-- Name: project_hashes; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_hashes (
    effname text NOT NULL,
    hash bigint NOT NULL
);


ALTER TABLE public.project_hashes OWNER TO repology_test;

--
-- Name: project_names; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_names (
    project_id integer NOT NULL,
    repository_id smallint NOT NULL,
    name_type public.project_name_type NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.project_names OWNER TO repology_test;

--
-- Name: project_redirects; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_redirects (
    project_id integer NOT NULL,
    repository_id smallint NOT NULL,
    is_actual boolean NOT NULL,
    trackname text NOT NULL
);


ALTER TABLE public.project_redirects OWNER TO repology_test;

--
-- Name: project_redirects_manual; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_redirects_manual (
    oldname text NOT NULL,
    newname text NOT NULL
);


ALTER TABLE public.project_redirects_manual OWNER TO repology_test;

--
-- Name: project_releases; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_releases (
    effname text NOT NULL,
    version text NOT NULL,
    start_ts timestamp with time zone,
    trusted_start_ts timestamp with time zone,
    end_ts timestamp with time zone
);


ALTER TABLE public.project_releases OWNER TO repology_test;

--
-- Name: project_turnover; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_turnover (
    effname text NOT NULL,
    delta smallint NOT NULL,
    ts timestamp with time zone DEFAULT now() NOT NULL,
    family text NOT NULL
);


ALTER TABLE public.project_turnover OWNER TO repology_test;

--
-- Name: repo_metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repo_metapackages (
    repository_id smallint NOT NULL,
    effname text NOT NULL,
    newest boolean NOT NULL,
    outdated boolean NOT NULL,
    problematic boolean NOT NULL,
    "unique" boolean NOT NULL
);


ALTER TABLE public.repo_metapackages OWNER TO repology_test;

--
-- Name: repo_track_versions; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repo_track_versions (
    repository_id smallint NOT NULL,
    refcount smallint NOT NULL,
    trackname text NOT NULL,
    version text NOT NULL,
    start_ts timestamp with time zone DEFAULT now() NOT NULL,
    end_ts timestamp with time zone,
    any_statuses integer DEFAULT 0 NOT NULL,
    any_flags integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.repo_track_versions OWNER TO repology_test;

--
-- Name: repo_tracks; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repo_tracks (
    repository_id smallint NOT NULL,
    refcount smallint NOT NULL,
    start_ts timestamp with time zone DEFAULT now() NOT NULL,
    restart_ts timestamp with time zone,
    end_ts timestamp with time zone,
    trackname text NOT NULL
);


ALTER TABLE public.repo_tracks OWNER TO repology_test;

--
-- Name: reports; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    created timestamp with time zone NOT NULL,
    updated timestamp with time zone NOT NULL,
    client text,
    effname text NOT NULL,
    need_verignore boolean NOT NULL,
    need_split boolean NOT NULL,
    need_merge boolean NOT NULL,
    comment text,
    reply text,
    accepted boolean
);


ALTER TABLE public.reports OWNER TO repology_test;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.reports ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repositories (
    id smallint NOT NULL,
    name text NOT NULL,
    state public.repository_state NOT NULL,
    num_packages integer DEFAULT 0 NOT NULL,
    num_packages_newest integer DEFAULT 0 NOT NULL,
    num_packages_outdated integer DEFAULT 0 NOT NULL,
    num_packages_ignored integer DEFAULT 0 NOT NULL,
    num_packages_unique integer DEFAULT 0 NOT NULL,
    num_packages_devel integer DEFAULT 0 NOT NULL,
    num_packages_legacy integer DEFAULT 0 NOT NULL,
    num_packages_incorrect integer DEFAULT 0 NOT NULL,
    num_packages_untrusted integer DEFAULT 0 NOT NULL,
    num_packages_noscheme integer DEFAULT 0 NOT NULL,
    num_packages_rolling integer DEFAULT 0 NOT NULL,
    num_metapackages integer DEFAULT 0 NOT NULL,
    num_metapackages_unique integer DEFAULT 0 NOT NULL,
    num_metapackages_newest integer DEFAULT 0 NOT NULL,
    num_metapackages_outdated integer DEFAULT 0 NOT NULL,
    num_metapackages_comparable integer DEFAULT 0 NOT NULL,
    num_metapackages_problematic integer DEFAULT 0 NOT NULL,
    num_problems integer DEFAULT 0 NOT NULL,
    num_maintainers integer DEFAULT 0 NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    last_fetched timestamp with time zone,
    last_parsed timestamp with time zone,
    last_updated timestamp with time zone,
    used_package_fields text[],
    ruleset_hash text,
    metadata jsonb NOT NULL,
    sortname text NOT NULL,
    type text NOT NULL,
    "desc" text NOT NULL,
    statsgroup text NOT NULL,
    singular text NOT NULL,
    family text NOT NULL,
    color text,
    shadow boolean NOT NULL,
    repolinks jsonb NOT NULL,
    packagelinks jsonb NOT NULL
);


ALTER TABLE public.repositories OWNER TO repology_test;

--
-- Name: repositories_history; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repositories_history (
    ts timestamp with time zone NOT NULL,
    snapshot jsonb NOT NULL
);


ALTER TABLE public.repositories_history OWNER TO repology_test;

--
-- Name: repositories_history_new; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repositories_history_new (
    repository_id smallint NOT NULL,
    ts timestamp with time zone NOT NULL,
    num_problems integer,
    num_maintainers integer,
    num_projects integer,
    num_projects_unique integer,
    num_projects_newest integer,
    num_projects_outdated integer,
    num_projects_comparable integer,
    num_projects_problematic integer
);


ALTER TABLE public.repositories_history_new OWNER TO repology_test;

--
-- Name: repository_events; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repository_events (
    id integer NOT NULL,
    repository_id smallint NOT NULL,
    ts timestamp with time zone NOT NULL,
    metapackage_id integer NOT NULL,
    type public.maintainer_repo_metapackages_event_type NOT NULL,
    data jsonb NOT NULL
);


ALTER TABLE public.repository_events OWNER TO repology_test;

--
-- Name: repository_events_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.repository_events ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.repository_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: repository_project_maintainers; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repository_project_maintainers (
    maintainer_id integer NOT NULL,
    project_id integer NOT NULL,
    repository_id smallint NOT NULL
);


ALTER TABLE public.repository_project_maintainers OWNER TO repology_test;

--
-- Name: runs; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.runs (
    id integer NOT NULL,
    type public.run_type NOT NULL,
    repository_id smallint,
    status public.run_status DEFAULT 'running'::public.run_status NOT NULL,
    no_changes boolean DEFAULT false NOT NULL,
    start_ts timestamp with time zone NOT NULL,
    finish_ts timestamp with time zone,
    num_lines integer,
    num_warnings integer,
    num_errors integer,
    utime interval,
    stime interval,
    maxrss integer,
    maxrss_delta integer,
    traceback text
);


ALTER TABLE public.runs OWNER TO repology_test;

--
-- Name: runs_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.runs ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: statistics; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.statistics (
    num_packages integer DEFAULT 0 NOT NULL,
    num_metapackages integer DEFAULT 0 NOT NULL,
    num_problems integer DEFAULT 0 NOT NULL,
    num_maintainers integer DEFAULT 0 NOT NULL,
    num_urls_checked integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.statistics OWNER TO repology_test;

--
-- Name: statistics_history; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.statistics_history (
    ts timestamp with time zone NOT NULL,
    snapshot jsonb NOT NULL
);


ALTER TABLE public.statistics_history OWNER TO repology_test;

--
-- Name: url_relations; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.url_relations (
    metapackage_id integer NOT NULL,
    urlhash bigint NOT NULL
);


ALTER TABLE public.url_relations OWNER TO repology_test;

--
-- Name: url_relations_all; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.url_relations_all (
    metapackage_id integer NOT NULL,
    urlhash bigint NOT NULL
);


ALTER TABLE public.url_relations_all OWNER TO repology_test;

--
-- Data for Name: category_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.category_metapackages (category, effname, "unique") FROM stdin;
devel	a52dec	t
app-misc	asciinema	t
app-test	aspell	t
app-misc	away	t
ham	baudline	t
games-action	chromium-bsu	t
development	kforth	t
sysutils	kiconvtool	t
system	oracle-xe	t
network	teamviewer	t
system	virtualbox	t
audio	vorbis-tools	t
\.


--
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.links (url, first_extracted, orphaned_since, next_check, last_checked, ipv4_last_success, ipv4_last_failure, ipv4_success, ipv4_status_code, ipv4_permanent_redirect_target, ipv6_last_success, ipv6_last_failure, ipv6_success, ipv6_status_code, ipv6_permanent_redirect_target) FROM stdin;
http://www.virtualbox.org/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://ccreweb.org/software/kforth/kforth.html	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://asciinema.org/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.vorbis.com/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/SDKRef.pdf	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/VirtualBox-5.0.30.tar.bz2	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.0.5.tar.bz2	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://unbeatenpath.net/software/away/away-0.9.5.tar.bz2	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
ftp://ccreweb.org/software/kforth/linux/kforth-x86-linux-1.5.2.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
mirror://gnu-alpha/aspell/aspell-0.60.7-rc1.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/baudline_1.08_linux_i686.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
mirror://sourceforge/chromium-bsu/chromium-bsu-0.9.15.1.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
ftp://ftp.kernel.org/pub/linux/daemons/autofs/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://www.teamviewer.com/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://wiki.freebsd.org/DmitryMarakasov/kiconvtool	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://liba52.sourceforge.net/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.zlib.net/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/UserManual.pdf	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://chromium-bsu.sourceforge.net/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://unbeatenpath.net/software/away/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://download.teamviewer.com/download/teamviewer_i386.deb	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/VBoxGuestAdditions_5.0.30.iso	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://aspell.net/	2020-03-27 19:29:23.081609+03	\N	2020-03-27 19:29:23.081609+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: log_lines; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.log_lines (run_id, lineno, "timestamp", severity, message) FROM stdin;
1	1	2020-03-27 19:29:22.814494+03	notice	parsing started
1	2	2020-03-27 19:29:22.817493+03	notice	parsing source core started
1	3	2020-03-27 19:29:22.839343+03	notice	parsing source core complete
1	4	2020-03-27 19:29:22.840513+03	notice	parsing source extra started
1	5	2020-03-27 19:29:22.843908+03	notice	parsing source extra complete
1	6	2020-03-27 19:29:22.845009+03	notice	parsing source community started
1	7	2020-03-27 19:29:22.847978+03	notice	parsing source community complete
1	8	2020-03-27 19:29:22.849121+03	notice	parsing source multilib started
1	9	2020-03-27 19:29:22.853789+03	notice	parsing source multilib complete
1	10	2020-03-27 19:29:22.85652+03	notice	parsing complete, 1 packages
2	1	2020-03-27 19:29:22.865046+03	notice	parsing started
2	2	2020-03-27 19:29:22.866799+03	notice	parsing source CPAN started
2	3	2020-03-27 19:29:22.873168+03	notice	parsing source CPAN complete
2	4	2020-03-27 19:29:22.875738+03	notice	parsing complete, 1 packages
3	1	2020-03-27 19:29:22.882753+03	notice	parsing started
3	2	2020-03-27 19:29:22.883982+03	notice	parsing source main started
3	3	2020-03-27 19:29:22.890447+03	notice	parsing source main complete
3	4	2020-03-27 19:29:22.891538+03	notice	parsing source contrib started
3	5	2020-03-27 19:29:22.894556+03	notice	parsing source contrib complete
3	6	2020-03-27 19:29:22.89564+03	notice	parsing source non-free started
3	7	2020-03-27 19:29:22.898697+03	notice	parsing source non-free complete
3	8	2020-03-27 19:29:22.901258+03	notice	parsing complete, 1 packages
4	1	2020-03-27 19:29:22.908334+03	notice	parsing started
4	2	2020-03-27 19:29:22.909532+03	notice	parsing source INDEX-11 started
4	3	2020-03-27 19:29:22.919566+03	notice	parsing source INDEX-11 complete
4	4	2020-03-27 19:29:22.924588+03	notice	parsing complete, 2 packages
5	1	2020-03-27 19:29:22.934955+03	notice	parsing started
5	2	2020-03-27 19:29:22.936357+03	notice	parsing source gentoo started
5	3	2020-03-27 19:29:23.022357+03	notice	parsing source gentoo complete
5	4	2020-03-27 19:29:23.025108+03	notice	parsing complete, 4 packages
6	1	2020-03-27 19:29:23.035898+03	notice	parsing started
6	2	2020-03-27 19:29:23.038057+03	notice	parsing source recipes started
6	3	2020-03-27 19:29:23.044533+03	notice	parsing source recipes complete
6	4	2020-03-27 19:29:23.047289+03	notice	parsing complete, 1 packages
7	1	2020-03-27 19:29:23.054298+03	notice	parsing started
7	2	2020-03-27 19:29:23.055456+03	notice	parsing source slackbuilds started
7	3	2020-03-27 19:29:23.074573+03	notice	parsing source slackbuilds complete
7	4	2020-03-27 19:29:23.077278+03	notice	parsing complete, 5 packages
\.


--
-- Data for Name: maintainer_and_repo_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_and_repo_metapackages (maintainer_id, repository_id, effname, newest, outdated, problematic) FROM stdin;
1	6	a52dec	t	f	f
8	2	baudline	t	f	f
12	2	oracle-xe	t	f	f
16	3	vorbis-tools	t	f	f
10	2	kforth	t	f	f
6	5	away	t	f	f
4	6	a52dec	t	f	f
9	5	chromium-bsu	t	f	f
15	2	virtualbox	t	f	f
3	6	a52dec	t	f	f
14	2	teamviewer	t	f	f
2	6	a52dec	t	f	f
6	5	aspell	t	f	f
11	3	kiconvtool	t	f	f
5	5	asciinema	t	f	f
\.


--
-- Data for Name: maintainer_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_metapackages (maintainer_id, effname, newest, outdated, problematic) FROM stdin;
3	a52dec	t	f	f
15	virtualbox	t	f	f
4	a52dec	t	f	f
1	a52dec	t	f	f
9	chromium-bsu	t	f	f
11	kiconvtool	t	f	f
5	asciinema	t	f	f
2	a52dec	t	f	f
6	aspell	t	f	f
14	teamviewer	t	f	f
16	vorbis-tools	t	f	f
10	kforth	t	f	f
12	oracle-xe	t	f	f
6	away	t	f	f
8	baudline	t	f	f
\.


--
-- Data for Name: maintainer_repo_metapackages_events; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_repo_metapackages_events (id, maintainer_id, repository_id, ts, metapackage_id, type, data) FROM stdin;
\.


--
-- Data for Name: maintainers; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainers (id, maintainer, num_packages, num_packages_newest, num_packages_outdated, num_packages_ignored, num_packages_unique, num_packages_devel, num_packages_legacy, num_packages_incorrect, num_packages_untrusted, num_packages_noscheme, num_packages_rolling, num_projects, num_projects_newest, num_projects_outdated, num_projects_problematic, counts_per_repo, num_projects_per_category, num_repos, first_seen, orphaned_at) FROM stdin;
13	jaldhar@cpan	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"cpan": [1, 1, 1, 0, 0]}	\N	1	2020-03-27 19:29:23.081609+03	\N
2	dmitrij.ledkov@ubuntu.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": [1, 1, 1, 0, 0]}	{"devel": 1}	1	2020-03-27 19:29:23.081609+03	\N
9	games@gentoo.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"gentoo": [1, 1, 1, 0, 0]}	{"games-action": 1}	1	2020-03-27 19:29:23.081609+03	\N
5	kensington@gentoo.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"gentoo": [1, 1, 1, 0, 0]}	{"app-misc": 1}	1	2020-03-27 19:29:23.081609+03	\N
16	naddy@freebsd.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"freebsd": [1, 1, 1, 0, 0]}	{"audio": 1}	1	2020-03-27 19:29:23.081609+03	\N
10	gschoen@iinet.net.au	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": [1, 1, 1, 0, 0]}	{"development": 1}	1	2020-03-27 19:29:23.081609+03	\N
11	amdmi3@freebsd.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"freebsd": [1, 1, 1, 0, 0]}	{"sysutils": 1}	1	2020-03-27 19:29:23.081609+03	\N
3	sam+deb@zoy.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": [1, 1, 1, 0, 0]}	{"devel": 1}	1	2020-03-27 19:29:23.081609+03	\N
14	willysr@slackbuilds.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": [1, 1, 1, 0, 0]}	{"network": 1}	1	2020-03-27 19:29:23.081609+03	\N
6	maintainer-needed@gentoo.org	2	0	0	0	2	0	0	0	0	0	0	2	2	0	0	{"gentoo": [2, 2, 2, 0, 0]}	{"app-misc": 1, "app-test": 1}	1	2020-03-27 19:29:23.081609+03	\N
12	slack.dhabyx@gmail.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": [1, 1, 1, 0, 0]}	{"system": 1}	1	2020-03-27 19:29:23.081609+03	\N
8	joshuakwood@gmail.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": [1, 1, 1, 0, 0]}	{"ham": 1}	1	2020-03-27 19:29:23.081609+03	\N
15	pprkut@liwjatan.at	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": [1, 1, 1, 0, 0]}	{"system": 1}	1	2020-03-27 19:29:23.081609+03	\N
4	siretart@tauware.de	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": [1, 1, 1, 0, 0]}	{"devel": 1}	1	2020-03-27 19:29:23.081609+03	\N
1	pkg-multimedia-maintainers@lists.alioth.debian.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": [1, 1, 1, 0, 0]}	{"devel": 1}	1	2020-03-27 19:29:23.081609+03	\N
\.


--
-- Data for Name: metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.metapackages (id, effname, num_repos, num_repos_nonshadow, num_families, num_repos_newest, num_families_newest, has_related, first_seen, orphaned_at) FROM stdin;
1	a52dec	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
2	asciinema	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
3	aspell	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
4	autofs	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
5	away	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
6	baudline	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
7	chromium-bsu	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
8	kforth	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
9	kiconvtool	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
10	oracle-xe	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
11	perl:acme-brainfuck	1	0	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
12	teamviewer	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
13	virtualbox	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
14	vorbis-tools	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
15	zlib	1	1	1	0	0	f	2020-03-27 19:29:23.081609+03	\N
\.


--
-- Data for Name: metapackages_events; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.metapackages_events (effname, ts, type, data) FROM stdin;
a52dec	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["debian_unstable"], "newest_repos": ["debian_unstable"], "newest_versions": ["0.7.4"]}
asciinema	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["1.3.0"]}
aspell	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["gentoo"], "devel_repos": ["gentoo"], "devel_versions": ["0.60.7_rc1"]}
autofs	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["gobolinux"], "newest_repos": ["gobolinux"], "newest_versions": ["5.0.5"]}
away	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["0.9.5"]}
baudline	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["1.08"]}
chromium-bsu	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["0.9.15.1"]}
kforth	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["1.5.2p1"]}
kiconvtool	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["freebsd"], "newest_repos": ["freebsd"], "newest_versions": ["0.97"]}
oracle-xe	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["11.2.0"]}
perl:acme-brainfuck	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["cpan"], "newest_repos": ["cpan"], "newest_versions": ["1.1.1"]}
teamviewer	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["12.0.76279"]}
virtualbox	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["5.0.30"]}
vorbis-tools	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["freebsd"], "newest_repos": ["freebsd"], "newest_versions": ["1.4.0"]}
zlib	2020-03-27 19:29:23.081609+03	history_start	{"all_repos": ["arch"], "newest_repos": ["arch"], "newest_versions": ["1.2.8"]}
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.packages (id, repo, family, subrepo, name, srcname, binname, trackname, visiblename, projectname_seed, origversion, rawversion, arch, maintainers, category, comment, homepage, licenses, downloads, extrafields, effname, version, versionclass, flags, shadow, flavors, branch) FROM stdin;
1	debian_unstable	debuntu	main	\N	a52dec	\N	a52dec	a52dec	a52dec	0.7.4	0.7.4-18	\N	{pkg-multimedia-maintainers@lists.alioth.debian.org,dmitrij.ledkov@ubuntu.com,sam+deb@zoy.org,siretart@tauware.de}	devel	\N	http://liba52.sourceforge.net/	{}	{}	{}	a52dec	0.7.4	4	0	f	{}	\N
2	gentoo	gentoo	\N	\N	app-misc/asciinema	\N	app-misc/asciinema	app-misc/asciinema	asciinema	1.3.0	1.3.0	\N	{kensington@gentoo.org}	app-misc	Command line recorder for asciinema.org service	https://asciinema.org/	{GPL-3+}	{https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz}	{}	asciinema	1.3.0	4	1024	f	{}	\N
3	gentoo	gentoo	\N	\N	app-test/aspell	\N	app-test/aspell	app-test/aspell	aspell	0.60.7_rc1	0.60.7_rc1	\N	{maintainer-needed@gentoo.org}	app-test	A spell checker replacement for ispell	http://aspell.net/	{LGPL-2}	{mirror://gnu-alpha/aspell/aspell-0.60.7-rc1.tar.gz}	{}	aspell	0.60.7_rc1	4	1026	f	{}	\N
4	gobolinux	gobolinux	\N	AutoFS	\N	\N	AutoFS	AutoFS	AutoFS	5.0.5	5.0.5	\N	{}	\N	Automounting daemon	ftp://ftp.kernel.org/pub/linux/daemons/autofs/	{"GNU General Public License (GPL)"}	{http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.0.5.tar.bz2}	{}	autofs	5.0.5	4	0	f	{}	\N
5	gentoo	gentoo	\N	\N	app-misc/away	\N	app-misc/away	app-misc/away	away	0.9.5	0.9.5-r1	\N	{maintainer-needed@gentoo.org}	app-misc	Terminal locking program with few additional features	http://unbeatenpath.net/software/away/	{GPL-2}	{http://unbeatenpath.net/software/away/away-0.9.5.tar.bz2}	{}	away	0.9.5	4	1024	f	{}	\N
6	slackbuilds	slackbuilds	\N	\N	ham/baudline	\N	ham/baudline	ham/baudline	baudline	1.08	1.08	\N	{joshuakwood@gmail.com}	ham	\N	http://www.baudline.com/	{}	{http://www.baudline.com/baudline_1.08_linux_i686.tar.gz,http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz}	{}	baudline	1.08	4	0	f	{}	\N
7	gentoo	gentoo	\N	\N	games-action/chromium-bsu	\N	games-action/chromium-bsu	games-action/chromium-bsu	chromium-bsu	0.9.15.1	0.9.15.1	\N	{games@gentoo.org}	games-action	Chromium B.S.U. - an arcade game	http://chromium-bsu.sourceforge.net/	{Clarified-Artistic}	{mirror://sourceforge/chromium-bsu/chromium-bsu-0.9.15.1.tar.gz}	{}	chromium-bsu	0.9.15.1	4	1024	f	{}	\N
8	slackbuilds	slackbuilds	\N	\N	development/kforth	\N	development/kforth	development/kforth	kforth	1.5.2p1	1.5.2p1	\N	{gschoen@iinet.net.au}	development	\N	http://ccreweb.org/software/kforth/kforth.html	{}	{ftp://ccreweb.org/software/kforth/linux/kforth-x86-linux-1.5.2.tar.gz}	{}	kforth	1.5.2p1	4	0	f	{}	\N
9	freebsd	freebsd	\N	\N	sysutils/kiconvtool	kiconvtool	sysutils/kiconvtool	sysutils/kiconvtool	kiconvtool	0.97	0.97_1	\N	{amdmi3@freebsd.org}	sysutils	Tool to preload kernel iconv charset tables	http://wiki.freebsd.org/DmitryMarakasov/kiconvtool	{}	{}	{}	kiconvtool	0.97	4	0	f	{}	\N
10	slackbuilds	slackbuilds	\N	\N	system/oracle-xe	\N	system/oracle-xe	system/oracle-xe	oracle-xe	11.2.0	11.2.0	\N	{slack.dhabyx@gmail.com}	system	\N	http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html	{}	{http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip}	{}	oracle-xe	11.2.0	4	0	f	{}	\N
11	cpan	cpan	\N	Acme-Brainfuck	\N	\N	Acme-Brainfuck	Acme-Brainfuck	Acme-Brainfuck	1.1.1	1.1.1	\N	{jaldhar@cpan}	\N	\N	http://search.cpan.org/dist/Acme-Brainfuck/	{}	{}	{}	perl:acme-brainfuck	1.1.1	4	0	t	{}	\N
12	slackbuilds	slackbuilds	\N	\N	network/teamviewer	\N	network/teamviewer	network/teamviewer	teamviewer	12.0.76279	12.0.76279	\N	{willysr@slackbuilds.org}	network	\N	https://www.teamviewer.com/	{}	{https://download.teamviewer.com/download/teamviewer_i386.deb}	{}	teamviewer	12.0.76279	4	0	f	{}	\N
13	slackbuilds	slackbuilds	\N	\N	system/virtualbox	\N	system/virtualbox	system/virtualbox	virtualbox	5.0.30	5.0.30	\N	{pprkut@liwjatan.at}	system	\N	http://www.virtualbox.org/	{}	{http://download.virtualbox.org/virtualbox/5.0.30/VirtualBox-5.0.30.tar.bz2,http://download.virtualbox.org/virtualbox/5.0.30/VBoxGuestAdditions_5.0.30.iso,http://download.virtualbox.org/virtualbox/5.0.30/UserManual.pdf,http://download.virtualbox.org/virtualbox/5.0.30/SDKRef.pdf}	{}	virtualbox	5.0.30	4	0	f	{}	5.0
14	freebsd	freebsd	\N	\N	audio/vorbis-tools	vorbis-tools	audio/vorbis-tools	audio/vorbis-tools	vorbis-tools	1.4.0	1.4.0_10,3	\N	{naddy@freebsd.org}	audio	Play, encode, and manage Ogg Vorbis files	http://www.vorbis.com/	{}	{}	{}	vorbis-tools	1.4.0	4	0	f	{}	\N
15	arch	arch	core	\N	zlib	zlib	zlib	zlib	zlib	1.2.8	1:1.2.8-7	\N	{}	\N	Compression library implementing the deflate compression method found in gzip and PKZIP	http://www.zlib.net/	{custom}	{}	{}	zlib	1.2.8	4	0	f	{}	\N
\.


--
-- Data for Name: problems; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.problems (package_id, repo, name, effname, maintainer, problem) FROM stdin;
11	cpan	Acme-Brainfuck	perl:acme-brainfuck	jaldhar@cpan	Homepage link "http://search.cpan.org/dist/Acme-Brainfuck/" points to CPAN which was discontinued. The link should be updated to https://metacpan.org (probably along with download URLs). See https://www.perl.com/article/saying-goodbye-to-search-cpan-org/ for details.
\.


--
-- Data for Name: project_hashes; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_hashes (effname, hash) FROM stdin;
a52dec	7844150428968220107
asciinema	6317799669749541295
aspell	1886560663048167445
autofs	7396613092264535011
away	354791858141513789
baudline	4494653134480871125
chromium-bsu	3009053120292285718
kforth	1486099903387192056
kiconvtool	3210279976390103027
oracle-xe	8615056855276994792
perl:acme-brainfuck	420334450674930592
teamviewer	5141382745846338822
virtualbox	9078782462727320595
vorbis-tools	4137730599650045270
zlib	6305965680004789435
\.


--
-- Data for Name: project_names; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_names (project_id, repository_id, name_type, name) FROM stdin;
14	3	srcname	audio/vorbis-tools
4	1	name	AutoFS
2	5	srcname	app-misc/asciinema
5	5	srcname	app-misc/away
12	2	srcname	network/teamviewer
6	2	srcname	ham/baudline
9	3	srcname	sysutils/kiconvtool
7	5	srcname	games-action/chromium-bsu
11	4	name	Acme-Brainfuck
15	7	srcname	zlib
9	3	binname	kiconvtool
14	3	binname	vorbis-tools
13	2	srcname	system/virtualbox
1	6	srcname	a52dec
10	2	srcname	system/oracle-xe
8	2	srcname	development/kforth
15	7	binname	zlib
3	5	srcname	app-test/aspell
\.


--
-- Data for Name: project_redirects; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_redirects (project_id, repository_id, is_actual, trackname) FROM stdin;
\.


--
-- Data for Name: project_redirects_manual; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_redirects_manual (oldname, newname) FROM stdin;
\.


--
-- Data for Name: project_releases; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_releases (effname, version, start_ts, trusted_start_ts, end_ts) FROM stdin;
a52dec	0.7.4	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
asciinema	1.3.0	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
aspell	0.60.7_rc1	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
autofs	5.0.5	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
away	0.9.5	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
baudline	1.08	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
chromium-bsu	0.9.15.1	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
kforth	1.5.2p1	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
kiconvtool	0.97	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
oracle-xe	11.2.0	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
perl:acme-brainfuck	1.1.1	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
teamviewer	12.0.76279	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
virtualbox	5.0.30	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
vorbis-tools	1.4.0	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
zlib	1.2.8	2020-03-27 19:29:23.081609+03	2020-03-27 19:29:23.081609+03	\N
\.


--
-- Data for Name: project_turnover; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_turnover (effname, delta, ts, family) FROM stdin;
\.


--
-- Data for Name: repo_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repo_metapackages (repository_id, effname, newest, outdated, problematic, "unique") FROM stdin;
1	autofs	t	f	f	t
2	baudline	t	f	f	t
2	kforth	t	f	f	t
2	oracle-xe	t	f	f	t
2	teamviewer	t	f	f	t
2	virtualbox	t	f	f	t
3	kiconvtool	t	f	f	t
3	vorbis-tools	t	f	f	t
5	asciinema	t	f	f	t
5	aspell	t	f	f	t
5	away	t	f	f	t
5	chromium-bsu	t	f	f	t
6	a52dec	t	f	f	t
7	zlib	t	f	f	t
\.


--
-- Data for Name: repo_track_versions; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repo_track_versions (repository_id, refcount, trackname, version, start_ts, end_ts, any_statuses, any_flags) FROM stdin;
6	1	a52dec	0.7.4	2020-03-27 19:29:23.081609+03	\N	16	0
4	1	Acme-Brainfuck	1.1.1	2020-03-27 19:29:23.081609+03	\N	16	0
5	1	games-action/chromium-bsu	0.9.15.1	2020-03-27 19:29:23.081609+03	\N	16	1024
5	1	app-misc/asciinema	1.3.0	2020-03-27 19:29:23.081609+03	\N	16	1024
3	1	sysutils/kiconvtool	0.97	2020-03-27 19:29:23.081609+03	\N	16	0
5	1	app-misc/away	0.9.5	2020-03-27 19:29:23.081609+03	\N	16	1024
3	1	audio/vorbis-tools	1.4.0	2020-03-27 19:29:23.081609+03	\N	16	0
5	1	app-test/aspell	0.60.7_rc1	2020-03-27 19:29:23.081609+03	\N	16	1026
2	1	development/kforth	1.5.2p1	2020-03-27 19:29:23.081609+03	\N	16	0
1	1	AutoFS	5.0.5	2020-03-27 19:29:23.081609+03	\N	16	0
7	1	zlib	1.2.8	2020-03-27 19:29:23.081609+03	\N	16	0
2	1	system/oracle-xe	11.2.0	2020-03-27 19:29:23.081609+03	\N	16	0
2	1	network/teamviewer	12.0.76279	2020-03-27 19:29:23.081609+03	\N	16	0
2	1	system/virtualbox	5.0.30	2020-03-27 19:29:23.081609+03	\N	16	0
2	1	ham/baudline	1.08	2020-03-27 19:29:23.081609+03	\N	16	0
\.


--
-- Data for Name: repo_tracks; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repo_tracks (repository_id, refcount, start_ts, restart_ts, end_ts, trackname) FROM stdin;
2	1	2020-03-27 19:29:23.081609+03	\N	\N	ham/baudline
2	1	2020-03-27 19:29:23.081609+03	\N	\N	development/kforth
1	1	2020-03-27 19:29:23.081609+03	\N	\N	AutoFS
3	1	2020-03-27 19:29:23.081609+03	\N	\N	sysutils/kiconvtool
5	1	2020-03-27 19:29:23.081609+03	\N	\N	games-action/chromium-bsu
5	1	2020-03-27 19:29:23.081609+03	\N	\N	app-misc/asciinema
3	1	2020-03-27 19:29:23.081609+03	\N	\N	audio/vorbis-tools
6	1	2020-03-27 19:29:23.081609+03	\N	\N	a52dec
2	1	2020-03-27 19:29:23.081609+03	\N	\N	network/teamviewer
4	1	2020-03-27 19:29:23.081609+03	\N	\N	Acme-Brainfuck
5	1	2020-03-27 19:29:23.081609+03	\N	\N	app-test/aspell
2	1	2020-03-27 19:29:23.081609+03	\N	\N	system/virtualbox
5	1	2020-03-27 19:29:23.081609+03	\N	\N	app-misc/away
7	1	2020-03-27 19:29:23.081609+03	\N	\N	zlib
2	1	2020-03-27 19:29:23.081609+03	\N	\N	system/oracle-xe
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.reports (id, created, updated, client, effname, need_verignore, need_split, need_merge, comment, reply, accepted) FROM stdin;
\.


--
-- Data for Name: repositories; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repositories (id, name, state, num_packages, num_packages_newest, num_packages_outdated, num_packages_ignored, num_packages_unique, num_packages_devel, num_packages_legacy, num_packages_incorrect, num_packages_untrusted, num_packages_noscheme, num_packages_rolling, num_metapackages, num_metapackages_unique, num_metapackages_newest, num_metapackages_outdated, num_metapackages_comparable, num_metapackages_problematic, num_problems, num_maintainers, first_seen, last_seen, last_fetched, last_parsed, last_updated, used_package_fields, ruleset_hash, metadata, sortname, type, "desc", statsgroup, singular, family, color, shadow, repolinks, packagelinks) FROM stdin;
7	arch	active	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	0	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:22.859214+03	2020-03-27 19:29:23.081609+03	{subrepo,versionclass,repo,trackname,version,projectname_seed,binname,homepage,licenses,rawversion,srcname,family,visiblename,origversion,comment,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "Arch", "name": "arch", "type": "repository", "color": "0088cc", "family": "arch", "shadow": false, "singular": "Arch package", "sortname": "arch", "repolinks": [{"url": "https://www.archlinux.org/", "desc": "Arch Linux home"}, {"url": "https://www.archlinux.org/packages/", "desc": "Arch Linux Packages"}], "statsgroup": "Arch+derivs", "packagelinks": [{"url": "https://www.archlinux.org/packages/?q={binname}", "desc": "Package details on www.archlinux.org"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk?h=packages/{srcname}", "desc": "Git repository"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk/PKGBUILD?h=packages/{srcname}", "desc": "PKGBUILD"}, {"url": "https://www.archlinux.org/packages/{subrepo}/x86_64/{binname}/", "desc": "Package information (x86_64)"}], "update_period": 600}	arch	repository	Arch	Arch+derivs	Arch package	arch	0088cc	f	[{"url": "https://www.archlinux.org/", "desc": "Arch Linux home"}, {"url": "https://www.archlinux.org/packages/", "desc": "Arch Linux Packages"}]	[{"url": "https://www.archlinux.org/packages/?q={binname}", "desc": "Package details on www.archlinux.org"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk?h=packages/{srcname}", "desc": "Git repository"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk/PKGBUILD?h=packages/{srcname}", "desc": "PKGBUILD"}, {"url": "https://www.archlinux.org/packages/{subrepo}/x86_64/{binname}/", "desc": "Package information (x86_64)"}]
4	cpan	active	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:22.878079+03	2020-03-27 19:29:23.081609+03	{versionclass,repo,trackname,shadow,version,projectname_seed,name,maintainers,homepage,rawversion,family,visiblename,origversion,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "CPAN", "name": "cpan", "type": "modules", "color": null, "family": "cpan", "shadow": true, "singular": "CPAN package", "sortname": "cpan", "repolinks": [{"url": "http://cpan.org/", "desc": "CPAN"}], "statsgroup": "CPAN", "packagelinks": [], "update_period": 600}	cpan	modules	CPAN	CPAN	CPAN package	cpan	\N	t	[{"url": "http://cpan.org/", "desc": "CPAN"}]	[]
6	debian_unstable	active	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	4	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:22.903495+03	2020-03-27 19:29:23.081609+03	{subrepo,versionclass,repo,trackname,version,projectname_seed,maintainers,homepage,category,rawversion,srcname,family,visiblename,origversion,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "Debian Unstable", "name": "debian_unstable", "type": "repository", "color": "c70036", "family": "debuntu", "shadow": false, "singular": "Debian Unstable package", "sortname": "debian_unstable", "repolinks": [{"url": "https://www.debian.org/distrib/packages", "desc": "Debian packages"}, {"url": "https://packages.debian.org/unstable/", "desc": "Debian packages in unstable"}, {"url": "https://buildd.debian.org/", "desc": "Debian package auto-building status"}], "statsgroup": "Debian+derivs", "packagelinks": [{"url": "https://packages.debian.org/unstable/source/{srcname}", "desc": "Package details on packages.debian.org"}, {"url": "https://bugs.debian.org/{srcname}", "desc": "Related bugs in Debian bugzilla"}, {"url": "https://buildd.debian.org/status/package.php?p={srcname}&suite=unstable", "desc": "Package auto-building status"}, {"url": "https://qa.debian.org/popcon-graph.php?packages={srcname}", "desc": "Popularity contest statistics"}], "update_period": 600}	debian_unstable	repository	Debian Unstable	Debian+derivs	Debian Unstable package	debuntu	c70036	f	[{"url": "https://www.debian.org/distrib/packages", "desc": "Debian packages"}, {"url": "https://packages.debian.org/unstable/", "desc": "Debian packages in unstable"}, {"url": "https://buildd.debian.org/", "desc": "Debian package auto-building status"}]	[{"url": "https://packages.debian.org/unstable/source/{srcname}", "desc": "Package details on packages.debian.org"}, {"url": "https://bugs.debian.org/{srcname}", "desc": "Related bugs in Debian bugzilla"}, {"url": "https://buildd.debian.org/status/package.php?p={srcname}&suite=unstable", "desc": "Package auto-building status"}, {"url": "https://qa.debian.org/popcon-graph.php?packages={srcname}", "desc": "Popularity contest statistics"}]
3	freebsd	active	2	0	0	0	2	0	0	0	0	0	0	2	2	0	0	0	0	0	2	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:22.92896+03	2020-03-27 19:29:23.081609+03	{versionclass,repo,trackname,version,projectname_seed,maintainers,binname,homepage,category,rawversion,srcname,family,visiblename,origversion,comment,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "FreeBSD Ports", "name": "freebsd", "type": "repository", "color": "990000", "family": "freebsd", "shadow": false, "singular": "FreeBSD port", "sortname": "freebsd", "repolinks": [{"url": "https://www.freebsd.org/", "desc": "FreeBSD home"}, {"url": "https://www.freebsd.org/ports/", "desc": "About FreeBSD ports"}, {"url": "https://www.freshports.org/", "desc": "FreshPorts - The Place For Ports"}, {"url": "https://svnweb.freebsd.org/ports/head/", "desc": "FreeBSD ports SVN repository"}, {"url": "https://pkg-status.freebsd.org/", "desc": "Package builds status"}], "statsgroup": "FreeBSD Ports", "packagelinks": [{"url": "https://www.freshports.org/{srcname}", "desc": "FreshPorts page"}, {"url": "https://svnweb.freebsd.org/ports/head/{srcname}/", "desc": "SVNWeb"}, {"url": "https://svnweb.freebsd.org/ports/head/{srcname}/Makefile?view=co", "desc": "Port's Makefile"}, {"url": "http://portsmon.freebsd.org/portoverview.py?category={srcname|dirname}&portname={srcname|basename}", "desc": "PortsMon"}, {"url": "https://bugs.freebsd.org/bugzilla/buglist.cgi?quicksearch={srcname}", "desc": "Related bugs in FreeBSD bugzilla"}], "update_period": 600}	freebsd	repository	FreeBSD Ports	FreeBSD Ports	FreeBSD port	freebsd	990000	f	[{"url": "https://www.freebsd.org/", "desc": "FreeBSD home"}, {"url": "https://www.freebsd.org/ports/", "desc": "About FreeBSD ports"}, {"url": "https://www.freshports.org/", "desc": "FreshPorts - The Place For Ports"}, {"url": "https://svnweb.freebsd.org/ports/head/", "desc": "FreeBSD ports SVN repository"}, {"url": "https://pkg-status.freebsd.org/", "desc": "Package builds status"}]	[{"url": "https://www.freshports.org/{srcname}", "desc": "FreshPorts page"}, {"url": "https://svnweb.freebsd.org/ports/head/{srcname}/", "desc": "SVNWeb"}, {"url": "https://svnweb.freebsd.org/ports/head/{srcname}/Makefile?view=co", "desc": "Port's Makefile"}, {"url": "http://portsmon.freebsd.org/portoverview.py?category={srcname|dirname}&portname={srcname|basename}", "desc": "PortsMon"}, {"url": "https://bugs.freebsd.org/bugzilla/buglist.cgi?quicksearch={srcname}", "desc": "Related bugs in FreeBSD bugzilla"}]
5	gentoo	active	4	0	0	0	4	0	0	0	0	0	0	4	4	0	0	0	0	0	3	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:23.027444+03	2020-03-27 19:29:23.081609+03	{versionclass,repo,trackname,version,flags,projectname_seed,maintainers,homepage,category,licenses,rawversion,downloads,family,visiblename,origversion,srcname,comment,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "Gentoo", "name": "gentoo", "type": "repository", "color": "62548f", "family": "gentoo", "shadow": false, "singular": "Gentoo package", "sortname": "gentoo", "repolinks": [{"url": "https://gentoo.org/", "desc": "Gentoo Linux home"}, {"url": "https://packages.gentoo.org/", "desc": "Gentoo Packages"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/", "desc": "Official Gentoo ebuild repository"}, {"url": "https://github.com/gentoo/gentoo", "desc": "Gentoo ebuild repository mirror on GitHub"}], "statsgroup": "Gentoo", "packagelinks": [{"url": "https://packages.gentoo.org/packages/{srcname}", "desc": "Package details"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/{srcname}/{srcname|basename}-{rawversion}.ebuild", "desc": "View ebuild"}], "update_period": 600}	gentoo	repository	Gentoo	Gentoo	Gentoo package	gentoo	62548f	f	[{"url": "https://gentoo.org/", "desc": "Gentoo Linux home"}, {"url": "https://packages.gentoo.org/", "desc": "Gentoo Packages"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/", "desc": "Official Gentoo ebuild repository"}, {"url": "https://github.com/gentoo/gentoo", "desc": "Gentoo ebuild repository mirror on GitHub"}]	[{"url": "https://packages.gentoo.org/packages/{srcname}", "desc": "Package details"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/{srcname}/{srcname|basename}-{rawversion}.ebuild", "desc": "View ebuild"}]
1	gobolinux	active	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	0	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:23.04963+03	2020-03-27 19:29:23.081609+03	{versionclass,repo,trackname,version,projectname_seed,name,homepage,licenses,rawversion,downloads,family,visiblename,origversion,comment,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "GoboLinux", "name": "gobolinux", "type": "repository", "color": null, "family": "gobolinux", "shadow": false, "singular": "GoboLinux package", "sortname": "gobolinux", "repolinks": [{"url": "http://gobolinux.org/", "desc": "GoboLinux home"}, {"url": "https://github.com/gobolinux/Recipes", "desc": "GoboLinux recipes repository"}], "statsgroup": "GoboLinux", "packagelinks": [{"url": "https://github.com/gobolinux/Recipes/tree/master/trunk/{name}/{origversion}", "desc": "Git"}], "update_period": 600}	gobolinux	repository	GoboLinux	GoboLinux	GoboLinux package	gobolinux	\N	f	[{"url": "http://gobolinux.org/", "desc": "GoboLinux home"}, {"url": "https://github.com/gobolinux/Recipes", "desc": "GoboLinux recipes repository"}]	[{"url": "https://github.com/gobolinux/Recipes/tree/master/trunk/{name}/{origversion}", "desc": "Git"}]
2	slackbuilds	active	5	0	0	0	5	0	0	0	0	0	0	5	5	0	0	0	0	0	5	2020-03-27 19:29:09.020211+03	2020-03-27 19:29:09.020211+03	\N	2020-03-27 19:29:23.079887+03	2020-03-27 19:29:23.081609+03	{versionclass,repo,trackname,version,projectname_seed,maintainers,homepage,category,branch,rawversion,downloads,family,visiblename,origversion,srcname,effname}	21302537cd750d776d314feed662e547d309ec4e797ff6a2e0e987f9f427d924	{"desc": "SlackBuilds", "name": "slackbuilds", "type": "repository", "color": "000000", "family": "slackbuilds", "shadow": false, "singular": "SlackBuilds package", "sortname": "slackbuilds", "repolinks": [{"url": "https://slackbuilds.org/", "desc": "SlackBuilds.org"}], "statsgroup": "SlackBuilds", "packagelinks": [{"url": "https://slackbuilds.org/repository/14.2/{srcname}/", "desc": "SlackBuilds.org page"}], "update_period": 600}	slackbuilds	repository	SlackBuilds	SlackBuilds	SlackBuilds package	slackbuilds	000000	f	[{"url": "https://slackbuilds.org/", "desc": "SlackBuilds.org"}]	[{"url": "https://slackbuilds.org/repository/14.2/{srcname}/", "desc": "SlackBuilds.org page"}]
\.


--
-- Data for Name: repositories_history; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repositories_history (ts, snapshot) FROM stdin;
2020-03-27 19:29:23.081609+03	{"arch": {"num_problems": 0, "num_maintainers": 0, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "cpan": {"num_problems": 1, "num_maintainers": 1, "num_metapackages": 0, "num_metapackages_newest": 0, "num_metapackages_unique": 0, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "gentoo": {"num_problems": 0, "num_maintainers": 3, "num_metapackages": 4, "num_metapackages_newest": 0, "num_metapackages_unique": 4, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "freebsd": {"num_problems": 0, "num_maintainers": 2, "num_metapackages": 2, "num_metapackages_newest": 0, "num_metapackages_unique": 2, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "gobolinux": {"num_problems": 0, "num_maintainers": 0, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "slackbuilds": {"num_problems": 0, "num_maintainers": 5, "num_metapackages": 5, "num_metapackages_newest": 0, "num_metapackages_unique": 5, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "debian_unstable": {"num_problems": 0, "num_maintainers": 4, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}}
\.


--
-- Data for Name: repositories_history_new; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repositories_history_new (repository_id, ts, num_problems, num_maintainers, num_projects, num_projects_unique, num_projects_newest, num_projects_outdated, num_projects_comparable, num_projects_problematic) FROM stdin;
1	2020-03-27 19:29:23.081609+03	0	0	1	1	0	0	0	0
4	2020-03-27 19:29:23.081609+03	1	1	0	0	0	0	0	0
2	2020-03-27 19:29:23.081609+03	0	5	5	5	0	0	0	0
7	2020-03-27 19:29:23.081609+03	0	0	1	1	0	0	0	0
6	2020-03-27 19:29:23.081609+03	0	4	1	1	0	0	0	0
5	2020-03-27 19:29:23.081609+03	0	3	4	4	0	0	0	0
3	2020-03-27 19:29:23.081609+03	0	2	2	2	0	0	0	0
\.


--
-- Data for Name: repository_events; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repository_events (id, repository_id, ts, metapackage_id, type, data) FROM stdin;
\.


--
-- Data for Name: repository_project_maintainers; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repository_project_maintainers (maintainer_id, project_id, repository_id) FROM stdin;
1	1	6
8	6	2
13	11	4
12	10	2
16	14	3
10	8	2
6	5	5
4	1	6
9	7	5
15	13	2
3	1	6
14	12	2
2	1	6
6	3	5
11	9	3
5	2	5
\.


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.runs (id, type, repository_id, status, no_changes, start_ts, finish_ts, num_lines, num_warnings, num_errors, utime, stime, maxrss, maxrss_delta, traceback) FROM stdin;
1	parse	7	successful	f	2020-03-27 19:29:22.809808+03	2020-03-27 19:29:22.857632+03	10	0	0	00:00:00.003079	00:00:00.023797	93776	1272	\N
2	parse	4	successful	f	2020-03-27 19:29:22.863149+03	2020-03-27 19:29:22.876879+03	4	0	0	00:00:00.006981	00:00:00	93996	220	\N
3	parse	6	successful	f	2020-03-27 19:29:22.881294+03	2020-03-27 19:29:22.902343+03	8	0	0	00:00:00.011415	00:00:00	94524	528	\N
4	parse	3	successful	f	2020-03-27 19:29:22.906868+03	2020-03-27 19:29:22.926459+03	4	0	0	00:00:00.010698	00:00:00	95076	272	\N
5	parse	5	successful	f	2020-03-27 19:29:22.933266+03	2020-03-27 19:29:23.026261+03	4	0	0	00:00:00.017688	00:00:00.007656	95248	172	\N
6	parse	1	successful	f	2020-03-27 19:29:23.032818+03	2020-03-27 19:29:23.048437+03	4	0	0	00:00:00.007014	00:00:00.000011	95248	0	\N
7	parse	2	successful	f	2020-03-27 19:29:23.052912+03	2020-03-27 19:29:23.078473+03	4	0	0	00:00:00.018666	00:00:00.000037	95248	0	\N
\.


--
-- Data for Name: statistics; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.statistics (num_packages, num_metapackages, num_problems, num_maintainers, num_urls_checked) FROM stdin;
15	14	1	15	0
\.


--
-- Data for Name: statistics_history; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.statistics_history (ts, snapshot) FROM stdin;
2020-03-27 19:29:23.081609+03	{"num_packages": 15, "num_problems": 1, "num_maintainers": 15, "num_metapackages": 14, "num_urls_checked": 0}
\.


--
-- Data for Name: url_relations; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.url_relations (metapackage_id, urlhash) FROM stdin;
\.


--
-- Data for Name: url_relations_all; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.url_relations_all (metapackage_id, urlhash) FROM stdin;
1	-6077476760067996376
2	3490203301255378983
3	-2836390072400046438
5	-695720082797309195
6	-2678859427031366852
7	-4535905535348466812
8	-6003843800635942089
9	8578644866517750217
10	8442068323236658063
11	921174328525418101
12	2323294126506090197
13	5266043467733527660
14	1013301472977689047
15	-6992331818153831371
\.


--
-- Name: maintainer_repo_metapackages_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.maintainer_repo_metapackages_events_id_seq', 1, false);


--
-- Name: maintainers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.maintainers_id_seq', 17, true);


--
-- Name: metapackages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.metapackages_id_seq', 16, true);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.packages_id_seq', 15, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, false);


--
-- Name: repository_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.repository_events_id_seq', 1, false);


--
-- Name: runs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.runs_id_seq', 7, true);


--
-- Name: category_metapackages category_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.category_metapackages
    ADD CONSTRAINT category_metapackages_pkey PRIMARY KEY (category, effname);


--
-- Name: links links_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey PRIMARY KEY (url);


--
-- Name: log_lines log_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.log_lines
    ADD CONSTRAINT log_lines_pkey PRIMARY KEY (run_id, lineno);


--
-- Name: maintainer_and_repo_metapackages maintainer_and_repo_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.maintainer_and_repo_metapackages
    ADD CONSTRAINT maintainer_and_repo_metapackages_pkey PRIMARY KEY (maintainer_id, repository_id, effname);


--
-- Name: maintainer_metapackages maintainer_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.maintainer_metapackages
    ADD CONSTRAINT maintainer_metapackages_pkey PRIMARY KEY (maintainer_id, effname);


--
-- Name: maintainers maintainers_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.maintainers
    ADD CONSTRAINT maintainers_pkey PRIMARY KEY (id);


--
-- Name: metapackages metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.metapackages
    ADD CONSTRAINT metapackages_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: project_hashes project_hashes_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.project_hashes
    ADD CONSTRAINT project_hashes_pkey PRIMARY KEY (effname);


--
-- Name: project_redirects_manual project_redirects_manual_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.project_redirects_manual
    ADD CONSTRAINT project_redirects_manual_pkey PRIMARY KEY (oldname, newname);


--
-- Name: project_releases project_releases_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.project_releases
    ADD CONSTRAINT project_releases_pkey PRIMARY KEY (effname, version);


--
-- Name: repo_metapackages repo_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repo_metapackages
    ADD CONSTRAINT repo_metapackages_pkey PRIMARY KEY (repository_id, effname);


--
-- Name: repo_track_versions repo_track_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repo_track_versions
    ADD CONSTRAINT repo_track_versions_pkey PRIMARY KEY (repository_id, trackname, version);


--
-- Name: repo_tracks repo_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repo_tracks
    ADD CONSTRAINT repo_tracks_pkey PRIMARY KEY (repository_id, trackname);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: repositories_history_new repositories_history_new_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repositories_history_new
    ADD CONSTRAINT repositories_history_new_pkey PRIMARY KEY (repository_id, ts);


--
-- Name: repositories_history repositories_history_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repositories_history
    ADD CONSTRAINT repositories_history_pkey PRIMARY KEY (ts);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: runs runs_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_pkey PRIMARY KEY (id);


--
-- Name: statistics_history statistics_history_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.statistics_history
    ADD CONSTRAINT statistics_history_pkey PRIMARY KEY (ts);


--
-- Name: category_metapackages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX category_metapackages_effname_idx ON public.category_metapackages USING btree (effname);


--
-- Name: links_next_check_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX links_next_check_idx ON public.links USING btree (next_check);


--
-- Name: maintainer_and_repo_metapackages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainer_and_repo_metapackages_effname_idx ON public.maintainer_and_repo_metapackages USING btree (effname);


--
-- Name: maintainer_metapackages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainer_metapackages_effname_idx ON public.maintainer_metapackages USING btree (effname);


--
-- Name: maintainer_repo_metapackages__maintainer_id_repository_id_t_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainer_repo_metapackages__maintainer_id_repository_id_t_idx ON public.maintainer_repo_metapackages_events USING btree (maintainer_id, repository_id, ts DESC);


--
-- Name: maintainers_active_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX maintainers_active_idx ON public.maintainers USING btree (maintainer) WHERE (num_packages > 0);


--
-- Name: maintainers_maintainer_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX maintainers_maintainer_idx ON public.maintainers USING btree (maintainer);


--
-- Name: maintainers_maintainer_trgm; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainers_maintainer_trgm ON public.maintainers USING gin (maintainer public.gin_trgm_ops) WHERE (num_packages > 0);


--
-- Name: maintainers_recently_added_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainers_recently_added_idx ON public.maintainers USING btree (first_seen DESC, maintainer) WHERE (num_packages > 0);


--
-- Name: maintainers_recently_removed_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX maintainers_recently_removed_idx ON public.maintainers USING btree (orphaned_at DESC, maintainer) WHERE (orphaned_at IS NOT NULL);


--
-- Name: metapackages_active_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX metapackages_active_idx ON public.metapackages USING btree (effname) WHERE (num_repos_nonshadow > 0);


--
-- Name: metapackages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX metapackages_effname_idx ON public.metapackages USING btree (effname);


--
-- Name: metapackages_effname_trgm; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_effname_trgm ON public.metapackages USING gin (effname public.gin_trgm_ops) WHERE (num_repos_nonshadow > 0);


--
-- Name: metapackages_events_effname_ts_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_events_effname_ts_idx ON public.metapackages_events USING btree (effname, ts DESC);


--
-- Name: metapackages_num_families_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_num_families_idx ON public.metapackages USING btree (num_families) WHERE ((num_repos_nonshadow > 0) AND (num_families >= 5));


--
-- Name: metapackages_num_families_newest_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_num_families_newest_idx ON public.metapackages USING btree (num_families_newest) WHERE ((num_repos_nonshadow > 0) AND (num_families_newest >= 1));


--
-- Name: metapackages_num_repos_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_num_repos_idx ON public.metapackages USING btree (num_repos) WHERE ((num_repos_nonshadow > 0) AND (num_repos >= 5));


--
-- Name: metapackages_num_repos_newest_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_num_repos_newest_idx ON public.metapackages USING btree (num_repos_newest) WHERE ((num_repos_nonshadow > 0) AND (num_repos_newest >= 1));


--
-- Name: metapackages_recently_added_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_recently_added_idx ON public.metapackages USING btree (first_seen DESC, effname) WHERE (num_repos_nonshadow > 0);


--
-- Name: metapackages_recently_removed_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_recently_removed_idx ON public.metapackages USING btree (orphaned_at DESC, effname) WHERE (orphaned_at IS NOT NULL);


--
-- Name: packages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX packages_effname_idx ON public.packages USING btree (effname);


--
-- Name: problems_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX problems_effname_idx ON public.problems USING btree (effname);


--
-- Name: problems_maintainer_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX problems_maintainer_idx ON public.problems USING btree (maintainer);


--
-- Name: problems_repo_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX problems_repo_effname_idx ON public.problems USING btree (repo, effname);


--
-- Name: project_names_name_repository_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX project_names_name_repository_id_idx ON public.project_names USING btree (name, repository_id);


--
-- Name: project_names_project_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX project_names_project_id_idx ON public.project_names USING btree (project_id);


--
-- Name: project_redirects_manual_newname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX project_redirects_manual_newname_idx ON public.project_redirects_manual USING btree (newname);


--
-- Name: project_redirects_project_id_repository_id_trackname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX project_redirects_project_id_repository_id_trackname_idx ON public.project_redirects USING btree (project_id, repository_id, trackname);


--
-- Name: project_redirects_repository_id_trackname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX project_redirects_repository_id_trackname_idx ON public.project_redirects USING btree (repository_id, trackname) WHERE is_actual;


--
-- Name: repo_metapackages_effname_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX repo_metapackages_effname_idx ON public.repo_metapackages USING btree (effname);


--
-- Name: reports_created_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX reports_created_idx ON public.reports USING btree (created DESC) WHERE (accepted IS NULL);


--
-- Name: reports_effname_created_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX reports_effname_created_idx ON public.reports USING btree (effname, created DESC);


--
-- Name: reports_updated_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX reports_updated_idx ON public.reports USING btree (updated DESC);


--
-- Name: repositories_name_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX repositories_name_idx ON public.repositories USING btree (name);


--
-- Name: repository_events_repository_id_ts_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX repository_events_repository_id_ts_idx ON public.repository_events USING btree (repository_id, ts DESC);


--
-- Name: repository_project_maintainers_project_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX repository_project_maintainers_project_id_idx ON public.repository_project_maintainers USING btree (project_id);


--
-- Name: runs_repository_id_start_ts_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX runs_repository_id_start_ts_idx ON public.runs USING btree (repository_id, start_ts DESC);


--
-- Name: runs_repository_id_start_ts_idx_failed; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX runs_repository_id_start_ts_idx_failed ON public.runs USING btree (repository_id, start_ts DESC) WHERE (status = 'failed'::public.run_status);


--
-- Name: url_relations_all_metapackage_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX url_relations_all_metapackage_id_idx ON public.url_relations_all USING btree (metapackage_id);


--
-- Name: url_relations_metapackage_id_urlhash_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX url_relations_metapackage_id_urlhash_idx ON public.url_relations USING btree (metapackage_id, urlhash);


--
-- Name: url_relations_urlhash_metapackage_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE UNIQUE INDEX url_relations_urlhash_metapackage_id_idx ON public.url_relations USING btree (urlhash, metapackage_id);


--
-- PostgreSQL database dump complete
--

