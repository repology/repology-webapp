--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 11.5

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

DROP TRIGGER metapackage_update ON public.metapackages;
DROP TRIGGER metapackage_create ON public.metapackages;
DROP TRIGGER maintainer_repo_metapackage_update ON public.maintainer_repo_metapackages;
DROP TRIGGER maintainer_repo_metapackage_addremove ON public.maintainer_repo_metapackages;
DROP INDEX public.url_relations_urlhash_metapackage_id_idx;
DROP INDEX public.runs_repository_id_start_ts_idx_failed;
DROP INDEX public.runs_repository_id_start_ts_idx;
DROP INDEX public.repositories_name_idx;
DROP INDEX public.reports_updated_idx;
DROP INDEX public.reports_effname_created_idx;
DROP INDEX public.reports_created_idx;
DROP INDEX public.repo_metapackages_effname_idx;
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
DROP INDEX public.metapackages_events_effname_ts_type_idx;
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
ALTER TABLE ONLY public.url_relations DROP CONSTRAINT url_relations_pkey;
ALTER TABLE ONLY public.statistics_history DROP CONSTRAINT statistics_history_pkey;
ALTER TABLE ONLY public.runs DROP CONSTRAINT runs_pkey;
ALTER TABLE ONLY public.repository_ruleset_hashes DROP CONSTRAINT repository_ruleset_hashes_pkey;
ALTER TABLE ONLY public.repositories DROP CONSTRAINT repositories_pkey;
ALTER TABLE ONLY public.repositories_history DROP CONSTRAINT repositories_history_pkey;
ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
ALTER TABLE ONLY public.repo_metapackages DROP CONSTRAINT repo_metapackages_pkey;
ALTER TABLE ONLY public.project_redirects DROP CONSTRAINT project_redirects_pkey;
ALTER TABLE ONLY public.packages DROP CONSTRAINT packages_pkey;
ALTER TABLE ONLY public.metapackages DROP CONSTRAINT metapackages_pkey;
ALTER TABLE ONLY public.maintainers DROP CONSTRAINT maintainers_pkey;
ALTER TABLE ONLY public.maintainer_repo_metapackages DROP CONSTRAINT maintainer_repo_metapackages_pkey;
ALTER TABLE ONLY public.maintainer_repo_metapackages_events DROP CONSTRAINT maintainer_repo_metapackages_events_pkey;
ALTER TABLE ONLY public.maintainer_metapackages DROP CONSTRAINT maintainer_metapackages_pkey;
ALTER TABLE ONLY public.maintainer_and_repo_metapackages DROP CONSTRAINT maintainer_and_repo_metapackages_pkey;
ALTER TABLE ONLY public.log_lines DROP CONSTRAINT log_lines_pkey;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey;
ALTER TABLE ONLY public.category_metapackages DROP CONSTRAINT category_metapackages_pkey;
DROP TABLE public.url_relations;
DROP TABLE public.statistics_history;
DROP TABLE public.statistics;
DROP TABLE public.runs;
DROP TABLE public.repository_ruleset_hashes;
DROP TABLE public.repositories_history;
DROP TABLE public.repositories;
DROP TABLE public.reports;
DROP TABLE public.repo_metapackages;
DROP TABLE public.project_redirects;
DROP TABLE public.problems;
DROP TABLE public.packages;
DROP TABLE public.metapackages_events;
DROP TABLE public.metapackages;
DROP TABLE public.maintainers;
DROP TABLE public.maintainer_repo_metapackages_events;
DROP TABLE public.maintainer_repo_metapackages;
DROP TABLE public.maintainer_metapackages;
DROP TABLE public.maintainer_and_repo_metapackages;
DROP TABLE public.log_lines;
DROP TABLE public.links;
DROP TABLE public.category_metapackages;
DROP FUNCTION public.version_set_changed(old text[], new text[]);
DROP FUNCTION public.simplify_url(url text);
DROP FUNCTION public.metapackage_create_events_trigger();
DROP FUNCTION public.metapackage_create_event(effname text, type public.metapackage_event_type, data jsonb);
DROP FUNCTION public.maintainer_repo_metapackages_create_events_trigger();
DROP FUNCTION public.maintainer_repo_metapackages_create_event(maintainer_id integer, repository_id smallint, metapackage_id integer, type public.maintainer_repo_metapackages_event_type, data jsonb);
DROP FUNCTION public.get_added_active_repos(oldrepos text[], newrepos text[]);
DROP TYPE public.run_type;
DROP TYPE public.run_status;
DROP TYPE public.repository_state;
DROP TYPE public.metapackage_event_type;
DROP TYPE public.maintainer_repo_metapackages_event_type;
DROP TYPE public.log_severity;
--
-- Name: libversion; Type: EXTENSION; Schema: -; Owner: 
--



--
-- Name: EXTENSION libversion; Type: COMMENT; Schema: -; Owner: 
--



--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
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
-- Name: repository_state; Type: TYPE; Schema: public; Owner: repology_test
--

CREATE TYPE public.repository_state AS ENUM (
    'new',
    'active',
    'legacy'
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
-- Name: maintainer_repo_metapackages_create_event(integer, smallint, integer, public.maintainer_repo_metapackages_event_type, jsonb); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.maintainer_repo_metapackages_create_event(maintainer_id integer, repository_id smallint, metapackage_id integer, type public.maintainer_repo_metapackages_event_type, data jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO maintainer_repo_metapackages_events (
		maintainer_id,
		repository_id,
		ts,
		metapackage_id,
		type,
		data
	) SELECT
		maintainer_id,
		repository_id,
		now(),
		metapackage_id,
		type,
		jsonb_strip_nulls(data);
END;
$$;


ALTER FUNCTION public.maintainer_repo_metapackages_create_event(maintainer_id integer, repository_id smallint, metapackage_id integer, type public.maintainer_repo_metapackages_event_type, data jsonb) OWNER TO repology_test;

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
-- Name: metapackage_create_event(text, public.metapackage_event_type, jsonb); Type: FUNCTION; Schema: public; Owner: repology_test
--

CREATE FUNCTION public.metapackage_create_event(effname text, type public.metapackage_event_type, data jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO metapackages_events (
		effname,
		ts,
		type,
		data
	) SELECT
		effname,
		now(),
		type,
		jsonb_strip_nulls(data);
END;
$$;


ALTER FUNCTION public.metapackage_create_event(effname text, type public.metapackage_event_type, data jsonb) OWNER TO repology_test;

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

SET default_with_oids = false;

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
    last_extracted timestamp with time zone DEFAULT now() NOT NULL,
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
-- Name: maintainer_repo_metapackages; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.maintainer_repo_metapackages (
    maintainer_id integer NOT NULL,
    repository_id smallint NOT NULL,
    metapackage_id integer NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    versions_uptodate text[],
    versions_outdated text[],
    versions_ignored text[]
);


ALTER TABLE public.maintainer_repo_metapackages OWNER TO repology_test;

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
    num_packages integer NOT NULL,
    num_packages_newest integer NOT NULL,
    num_packages_outdated integer NOT NULL,
    num_packages_ignored integer NOT NULL,
    num_packages_unique integer NOT NULL,
    num_packages_devel integer NOT NULL,
    num_packages_legacy integer NOT NULL,
    num_packages_incorrect integer NOT NULL,
    num_packages_untrusted integer NOT NULL,
    num_packages_noscheme integer NOT NULL,
    num_packages_rolling integer NOT NULL,
    num_projects integer NOT NULL,
    num_projects_newest integer NOT NULL,
    num_projects_outdated integer NOT NULL,
    num_projects_problematic integer NOT NULL,
    num_packages_per_repo jsonb DEFAULT '{}'::jsonb NOT NULL,
    num_projects_per_repo jsonb DEFAULT '{}'::jsonb NOT NULL,
    num_projects_newest_per_repo jsonb DEFAULT '{}'::jsonb NOT NULL,
    num_projects_outdated_per_repo jsonb DEFAULT '{}'::jsonb NOT NULL,
    num_projects_problematic_per_repo jsonb DEFAULT '{}'::jsonb NOT NULL,
    bestrepo text,
    bestrepo_num_projects integer DEFAULT 0 NOT NULL,
    bestrepo_num_projects_newest integer DEFAULT 0,
    bestrepo_num_projects_outdated integer DEFAULT 0,
    bestrepo_num_projects_problematic integer DEFAULT 0,
    num_projects_per_category jsonb DEFAULT '{}'::jsonb NOT NULL,
    num_repos integer DEFAULT 0 NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL
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
    num_repos smallint NOT NULL,
    num_repos_nonshadow smallint NOT NULL,
    num_families smallint NOT NULL,
    num_repos_newest smallint NOT NULL,
    num_families_newest smallint NOT NULL,
    max_repos smallint NOT NULL,
    max_families smallint NOT NULL,
    has_related boolean DEFAULT false NOT NULL,
    first_seen timestamp with time zone NOT NULL,
    last_seen timestamp with time zone NOT NULL,
    devel_versions text[],
    devel_repos text[],
    devel_version_update timestamp with time zone,
    newest_versions text[],
    newest_repos text[],
    newest_version_update timestamp with time zone,
    all_repos text[]
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
    basename text,
    keyname text,
    visiblename text NOT NULL,
    projectname_seed text NOT NULL,
    trackname text,
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
-- Name: project_redirects; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.project_redirects (
    oldname text NOT NULL,
    newname text NOT NULL,
    manual boolean DEFAULT false NOT NULL
);


ALTER TABLE public.project_redirects OWNER TO repology_test;

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
    used_package_fields text[],
    sortname text NOT NULL,
    type text NOT NULL,
    "desc" text NOT NULL,
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
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: repology_test
--

ALTER TABLE public.repositories ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: repository_ruleset_hashes; Type: TABLE; Schema: public; Owner: repology_test
--

CREATE TABLE public.repository_ruleset_hashes (
    repository text NOT NULL,
    ruleset_hash text
);


ALTER TABLE public.repository_ruleset_hashes OWNER TO repology_test;

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
-- Data for Name: category_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.category_metapackages (category, effname, "unique") FROM stdin;
system	oracle-xe	t
audio	vorbis-tools	t
ham	baudline	t
system	virtualbox	t
network	teamviewer	t
app-test	aspell	t
development	kforth	t
devel	a52dec	t
sysutils	kiconvtool	t
app-misc	asciinema	t
app-misc	away	t
games-action	chromium-bsu	t
\.


--
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.links (url, first_extracted, last_extracted, next_check, last_checked, ipv4_last_success, ipv4_last_failure, ipv4_success, ipv4_status_code, ipv4_permanent_redirect_target, ipv6_last_success, ipv6_last_failure, ipv6_success, ipv6_status_code, ipv6_permanent_redirect_target) FROM stdin;
https://asciinema.org/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
mirror://gnu-alpha/aspell/aspell-0.60.7-rc1.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/VirtualBox-5.0.30.tar.bz2	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://unbeatenpath.net/software/away/away-0.9.5.tar.bz2	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://wiki.freebsd.org/DmitryMarakasov/kiconvtool	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.vorbis.com/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
ftp://ccreweb.org/software/kforth/linux/kforth-x86-linux-1.5.2.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
ftp://ftp.kernel.org/pub/linux/daemons/autofs/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/UserManual.pdf	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://chromium-bsu.sourceforge.net/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://ccreweb.org/software/kforth/kforth.html	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.virtualbox.org/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://aspell.net/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.zlib.net/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://www.teamviewer.com/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://unbeatenpath.net/software/away/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.baudline.com/baudline_1.08_linux_i686.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
mirror://sourceforge/chromium-bsu/chromium-bsu-0.9.15.1.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://liba52.sourceforge.net/	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/SDKRef.pdf	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://download.virtualbox.org/virtualbox/5.0.30/VBoxGuestAdditions_5.0.30.iso	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.0.5.tar.bz2	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://download.teamviewer.com/download/teamviewer_i386.deb	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: log_lines; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.log_lines (run_id, lineno, "timestamp", severity, message) FROM stdin;
1	1	2019-11-12 17:54:10.6681+03	notice	parsing started
1	2	2019-11-12 17:54:10.669744+03	notice	parsing source core started
1	3	2019-11-12 17:54:10.687341+03	notice	parsing source core complete
1	4	2019-11-12 17:54:10.688922+03	notice	parsing source extra started
1	5	2019-11-12 17:54:10.692255+03	notice	parsing source extra complete
1	6	2019-11-12 17:54:10.693334+03	notice	parsing source community started
1	7	2019-11-12 17:54:10.696638+03	notice	parsing source community complete
1	8	2019-11-12 17:54:10.697768+03	notice	parsing source multilib started
1	9	2019-11-12 17:54:10.701073+03	notice	parsing source multilib complete
1	10	2019-11-12 17:54:10.703914+03	notice	parsing complete, 1 packages
2	1	2019-11-12 17:54:10.712996+03	notice	parsing started
2	2	2019-11-12 17:54:10.714286+03	notice	parsing source CPAN started
2	3	2019-11-12 17:54:10.720779+03	notice	parsing source CPAN complete
2	4	2019-11-12 17:54:10.72404+03	notice	parsing complete, 1 packages
3	1	2019-11-12 17:54:10.731004+03	notice	parsing started
3	2	2019-11-12 17:54:10.732282+03	notice	parsing source main started
3	3	2019-11-12 17:54:10.740774+03	notice	parsing source main complete
3	4	2019-11-12 17:54:10.741948+03	notice	parsing source contrib started
3	5	2019-11-12 17:54:10.746108+03	notice	parsing source contrib complete
3	6	2019-11-12 17:54:10.747273+03	notice	parsing source non-free started
3	7	2019-11-12 17:54:10.751309+03	notice	parsing source non-free complete
3	8	2019-11-12 17:54:10.753855+03	notice	parsing complete, 1 packages
4	1	2019-11-12 17:54:10.760619+03	notice	parsing started
4	2	2019-11-12 17:54:10.761945+03	notice	parsing source INDEX-11 started
4	3	2019-11-12 17:54:10.773538+03	notice	parsing source INDEX-11 complete
4	4	2019-11-12 17:54:10.776756+03	notice	parsing complete, 2 packages
5	1	2019-11-12 17:54:10.783493+03	notice	parsing started
5	2	2019-11-12 17:54:10.784732+03	notice	parsing source gentoo started
5	3	2019-11-12 17:54:10.804927+03	notice	parsing source gentoo complete
5	4	2019-11-12 17:54:10.808034+03	notice	parsing complete, 4 packages
6	1	2019-11-12 17:54:10.81459+03	notice	parsing started
6	2	2019-11-12 17:54:10.815814+03	notice	parsing source recipes started
6	3	2019-11-12 17:54:10.822242+03	notice	parsing source recipes complete
6	4	2019-11-12 17:54:10.824819+03	notice	parsing complete, 1 packages
7	1	2019-11-12 17:54:10.831639+03	notice	parsing started
7	2	2019-11-12 17:54:10.832837+03	notice	parsing source slackbuilds started
7	3	2019-11-12 17:54:10.852352+03	notice	parsing source slackbuilds complete
7	4	2019-11-12 17:54:10.855286+03	notice	parsing complete, 5 packages
\.


--
-- Data for Name: maintainer_and_repo_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_and_repo_metapackages (maintainer_id, repository_id, effname, newest, outdated, problematic) FROM stdin;
15	2	teamviewer	t	f	f
14	2	oracle-xe	t	f	f
6	2	baudline	t	f	f
7	5	asciinema	t	f	f
10	6	a52dec	t	f	f
13	6	a52dec	t	f	f
9	3	vorbis-tools	t	f	f
8	5	aspell	t	f	f
4	2	kforth	t	f	f
1	3	kiconvtool	t	f	f
8	5	away	t	f	f
11	2	virtualbox	t	f	f
12	6	a52dec	t	f	f
2	6	a52dec	t	f	f
3	5	chromium-bsu	t	f	f
\.


--
-- Data for Name: maintainer_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_metapackages (maintainer_id, effname, newest, outdated, problematic) FROM stdin;
7	asciinema	t	f	f
14	oracle-xe	t	f	f
6	baudline	t	f	f
12	a52dec	t	f	f
9	vorbis-tools	t	f	f
13	a52dec	t	f	f
4	kforth	t	f	f
1	kiconvtool	t	f	f
8	away	t	f	f
15	teamviewer	t	f	f
8	aspell	t	f	f
2	a52dec	t	f	f
11	virtualbox	t	f	f
3	chromium-bsu	t	f	f
10	a52dec	t	f	f
\.


--
-- Data for Name: maintainer_repo_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_repo_metapackages (maintainer_id, repository_id, metapackage_id, first_seen, last_seen, versions_uptodate, versions_outdated, versions_ignored) FROM stdin;
\.


--
-- Data for Name: maintainer_repo_metapackages_events; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainer_repo_metapackages_events (id, maintainer_id, repository_id, ts, metapackage_id, type, data) FROM stdin;
\.


--
-- Data for Name: maintainers; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.maintainers (id, maintainer, num_packages, num_packages_newest, num_packages_outdated, num_packages_ignored, num_packages_unique, num_packages_devel, num_packages_legacy, num_packages_incorrect, num_packages_untrusted, num_packages_noscheme, num_packages_rolling, num_projects, num_projects_newest, num_projects_outdated, num_projects_problematic, num_packages_per_repo, num_projects_per_repo, num_projects_newest_per_repo, num_projects_outdated_per_repo, num_projects_problematic_per_repo, bestrepo, bestrepo_num_projects, bestrepo_num_projects_newest, bestrepo_num_projects_outdated, bestrepo_num_projects_problematic, num_projects_per_category, num_repos, first_seen, last_seen) FROM stdin;
5	jaldhar@cpan	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"cpan": 1}	{"cpan": 1}	{"cpan": 1}	{"cpan": 0}	{"cpan": 0}	cpan	1	1	0	0	{}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
1	amdmi3@freebsd.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"freebsd": 1}	{"freebsd": 1}	{"freebsd": 1}	{"freebsd": 0}	{"freebsd": 0}	freebsd	1	1	0	0	{"sysutils": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
2	dmitrij.ledkov@ubuntu.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 0}	{"debian_unstable": 0}	debian_unstable	1	1	0	0	{"devel": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
3	games@gentoo.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"gentoo": 1}	{"gentoo": 1}	{"gentoo": 1}	{"gentoo": 0}	{"gentoo": 0}	gentoo	1	1	0	0	{"games-action": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
4	gschoen@iinet.net.au	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 0}	{"slackbuilds": 0}	slackbuilds	1	1	0	0	{"development": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
6	joshuakwood@gmail.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 0}	{"slackbuilds": 0}	slackbuilds	1	1	0	0	{"ham": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
7	kensington@gentoo.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"gentoo": 1}	{"gentoo": 1}	{"gentoo": 1}	{"gentoo": 0}	{"gentoo": 0}	gentoo	1	1	0	0	{"app-misc": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
8	maintainer-needed@gentoo.org	2	0	0	0	2	0	0	0	0	0	0	2	2	0	0	{"gentoo": 2}	{"gentoo": 2}	{"gentoo": 2}	{"gentoo": 0}	{"gentoo": 0}	gentoo	2	2	0	0	{"app-misc": 1, "app-test": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
9	naddy@freebsd.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"freebsd": 1}	{"freebsd": 1}	{"freebsd": 1}	{"freebsd": 0}	{"freebsd": 0}	freebsd	1	1	0	0	{"audio": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
10	pkg-multimedia-maintainers@lists.alioth.debian.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 0}	{"debian_unstable": 0}	debian_unstable	1	1	0	0	{"devel": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
11	pprkut@liwjatan.at	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 0}	{"slackbuilds": 0}	slackbuilds	1	1	0	0	{"system": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
12	sam+deb@zoy.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 0}	{"debian_unstable": 0}	debian_unstable	1	1	0	0	{"devel": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
13	siretart@tauware.de	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 1}	{"debian_unstable": 0}	{"debian_unstable": 0}	debian_unstable	1	1	0	0	{"devel": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
14	slack.dhabyx@gmail.com	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 0}	{"slackbuilds": 0}	slackbuilds	1	1	0	0	{"system": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
15	willysr@slackbuilds.org	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 1}	{"slackbuilds": 0}	{"slackbuilds": 0}	slackbuilds	1	1	0	0	{"network": 1}	1	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03
\.


--
-- Data for Name: metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.metapackages (id, effname, num_repos, num_repos_nonshadow, num_families, num_repos_newest, num_families_newest, max_repos, max_families, has_related, first_seen, last_seen, devel_versions, devel_repos, devel_version_update, newest_versions, newest_repos, newest_version_update, all_repos) FROM stdin;
1	a52dec	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{0.7.4}	{debian_unstable}	\N	{debian_unstable}
2	asciinema	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.3.0}	{gentoo}	\N	{gentoo}
3	aspell	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	{0.60.7_rc1}	{gentoo}	\N	\N	\N	\N	{gentoo}
4	autofs	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{5.0.5}	{gobolinux}	\N	{gobolinux}
5	away	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{0.9.5}	{gentoo}	\N	{gentoo}
6	baudline	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.08}	{slackbuilds}	\N	{slackbuilds}
7	chromium-bsu	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{0.9.15.1}	{gentoo}	\N	{gentoo}
8	kforth	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.5.2p1}	{slackbuilds}	\N	{slackbuilds}
9	kiconvtool	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{0.97}	{freebsd}	\N	{freebsd}
10	oracle-xe	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{11.2.0}	{slackbuilds}	\N	{slackbuilds}
11	perl:acme-brainfuck	1	0	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.1.1}	{cpan}	\N	{cpan}
12	teamviewer	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{12.0.76279}	{slackbuilds}	\N	{slackbuilds}
13	virtualbox	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{5.0.30}	{slackbuilds}	\N	{slackbuilds}
14	vorbis-tools	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.4.0}	{freebsd}	\N	{freebsd}
15	zlib	1	1	1	0	0	1	1	f	2019-11-12 17:54:10.859209+03	2019-11-12 17:54:10.859209+03	\N	\N	\N	{1.2.8}	{arch}	\N	{arch}
\.


--
-- Data for Name: metapackages_events; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.metapackages_events (effname, ts, type, data) FROM stdin;
a52dec	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["debian_unstable"], "newest_repos": ["debian_unstable"], "newest_versions": ["0.7.4"]}
asciinema	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["1.3.0"]}
aspell	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["gentoo"], "devel_repos": ["gentoo"], "devel_versions": ["0.60.7_rc1"]}
autofs	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["gobolinux"], "newest_repos": ["gobolinux"], "newest_versions": ["5.0.5"]}
away	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["0.9.5"]}
baudline	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["1.08"]}
chromium-bsu	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["gentoo"], "newest_repos": ["gentoo"], "newest_versions": ["0.9.15.1"]}
kforth	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["1.5.2p1"]}
kiconvtool	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["freebsd"], "newest_repos": ["freebsd"], "newest_versions": ["0.97"]}
oracle-xe	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["11.2.0"]}
perl:acme-brainfuck	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["cpan"], "newest_repos": ["cpan"], "newest_versions": ["1.1.1"]}
teamviewer	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["12.0.76279"]}
virtualbox	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["slackbuilds"], "newest_repos": ["slackbuilds"], "newest_versions": ["5.0.30"]}
vorbis-tools	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["freebsd"], "newest_repos": ["freebsd"], "newest_versions": ["1.4.0"]}
zlib	2019-11-12 17:54:10.859209+03	history_start	{"all_repos": ["arch"], "newest_repos": ["arch"], "newest_versions": ["1.2.8"]}
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.packages (id, repo, family, subrepo, name, srcname, binname, basename, keyname, visiblename, projectname_seed, trackname, origversion, rawversion, arch, maintainers, category, comment, homepage, licenses, downloads, extrafields, effname, version, versionclass, flags, shadow, flavors, branch) FROM stdin;
1	debian_unstable	debuntu	main	a52dec	\N	\N	\N	\N	a52dec	a52dec	\N	0.7.4	0.7.4-18	\N	{pkg-multimedia-maintainers@lists.alioth.debian.org,dmitrij.ledkov@ubuntu.com,sam+deb@zoy.org,siretart@tauware.de}	devel	\N	http://liba52.sourceforge.net/	{}	{}	{}	a52dec	0.7.4	4	0	f	{}	\N
2	gentoo	gentoo	\N	asciinema	\N	\N	\N	app-misc/asciinema	app-misc/asciinema	asciinema	\N	1.3.0	1.3.0	\N	{kensington@gentoo.org}	app-misc	Command line recorder for asciinema.org service	https://asciinema.org/	{GPL-3+}	{https://github.com/asciinema/asciinema/archive/v1.3.0.tar.gz}	{}	asciinema	1.3.0	4	1024	f	{}	\N
3	gentoo	gentoo	\N	aspell	\N	\N	\N	app-test/aspell	app-test/aspell	aspell	\N	0.60.7_rc1	0.60.7_rc1	\N	{maintainer-needed@gentoo.org}	app-test	A spell checker replacement for ispell	http://aspell.net/	{LGPL-2}	{mirror://gnu-alpha/aspell/aspell-0.60.7-rc1.tar.gz}	{}	aspell	0.60.7_rc1	4	1026	f	{}	\N
4	gobolinux	gobolinux	\N	AutoFS	\N	\N	\N	\N	AutoFS	AutoFS	\N	5.0.5	5.0.5	\N	{}	\N	Automounting daemon	ftp://ftp.kernel.org/pub/linux/daemons/autofs/	{"GNU General Public License (GPL)"}	{http://www.kernel.org/pub/linux/daemons/autofs/v5/autofs-5.0.5.tar.bz2}	{}	autofs	5.0.5	4	0	f	{}	\N
5	gentoo	gentoo	\N	away	\N	\N	\N	app-misc/away	app-misc/away	away	\N	0.9.5	0.9.5-r1	\N	{maintainer-needed@gentoo.org}	app-misc	Terminal locking program with few additional features	http://unbeatenpath.net/software/away/	{GPL-2}	{http://unbeatenpath.net/software/away/away-0.9.5.tar.bz2}	{}	away	0.9.5	4	1024	f	{}	\N
6	slackbuilds	slackbuilds	\N	baudline	\N	\N	\N	\N	baudline	baudline	\N	1.08	1.08	\N	{joshuakwood@gmail.com}	ham	\N	http://www.baudline.com/	{}	{http://www.baudline.com/baudline_1.08_linux_i686.tar.gz,http://www.baudline.com/baudline_1.08_linux_x86_64.tar.gz}	{}	baudline	1.08	4	0	f	{}	\N
7	gentoo	gentoo	\N	chromium-bsu	\N	\N	\N	games-action/chromium-bsu	games-action/chromium-bsu	chromium-bsu	\N	0.9.15.1	0.9.15.1	\N	{games@gentoo.org}	games-action	Chromium B.S.U. - an arcade game	http://chromium-bsu.sourceforge.net/	{Clarified-Artistic}	{mirror://sourceforge/chromium-bsu/chromium-bsu-0.9.15.1.tar.gz}	{}	chromium-bsu	0.9.15.1	4	1024	f	{}	\N
8	slackbuilds	slackbuilds	\N	kforth	\N	\N	\N	\N	kforth	kforth	\N	1.5.2p1	1.5.2p1	\N	{gschoen@iinet.net.au}	development	\N	http://ccreweb.org/software/kforth/kforth.html	{}	{ftp://ccreweb.org/software/kforth/linux/kforth-x86-linux-1.5.2.tar.gz}	{}	kforth	1.5.2p1	4	0	f	{}	\N
9	freebsd	freebsd	\N	kiconvtool	\N	\N	\N	sysutils/kiconvtool	sysutils/kiconvtool	kiconvtool	\N	0.97	0.97_1	\N	{amdmi3@freebsd.org}	sysutils	Tool to preload kernel iconv charset tables	http://wiki.freebsd.org/DmitryMarakasov/kiconvtool	{}	{}	{}	kiconvtool	0.97	4	0	f	{}	\N
10	slackbuilds	slackbuilds	\N	oracle-xe	\N	\N	\N	\N	oracle-xe	oracle-xe	\N	11.2.0	11.2.0	\N	{slack.dhabyx@gmail.com}	system	\N	http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html	{}	{http://download.oracle.com/otn/linux/oracle11g/xe/oracle-xe-11.2.0-1.0.x86_64.rpm.zip}	{}	oracle-xe	11.2.0	4	0	f	{}	\N
11	cpan	cpan	\N	Acme-Brainfuck	\N	\N	\N	\N	Acme-Brainfuck	Acme-Brainfuck	\N	1.1.1	1.1.1	\N	{jaldhar@cpan}	\N	\N	http://search.cpan.org/dist/Acme-Brainfuck/	{}	{}	{}	perl:acme-brainfuck	1.1.1	4	0	t	{}	\N
12	slackbuilds	slackbuilds	\N	teamviewer	\N	\N	\N	\N	teamviewer	teamviewer	\N	12.0.76279	12.0.76279	\N	{willysr@slackbuilds.org}	network	\N	https://www.teamviewer.com/	{}	{https://download.teamviewer.com/download/teamviewer_i386.deb}	{}	teamviewer	12.0.76279	4	0	f	{}	\N
13	slackbuilds	slackbuilds	\N	virtualbox	\N	\N	\N	\N	virtualbox	virtualbox	\N	5.0.30	5.0.30	\N	{pprkut@liwjatan.at}	system	\N	http://www.virtualbox.org/	{}	{http://download.virtualbox.org/virtualbox/5.0.30/VirtualBox-5.0.30.tar.bz2,http://download.virtualbox.org/virtualbox/5.0.30/VBoxGuestAdditions_5.0.30.iso,http://download.virtualbox.org/virtualbox/5.0.30/UserManual.pdf,http://download.virtualbox.org/virtualbox/5.0.30/SDKRef.pdf}	{}	virtualbox	5.0.30	4	0	f	{}	5.0
14	freebsd	freebsd	\N	vorbis-tools	\N	\N	\N	audio/vorbis-tools	audio/vorbis-tools	vorbis-tools	\N	1.4.0	1.4.0_10,3	\N	{naddy@freebsd.org}	audio	Play, encode, and manage Ogg Vorbis files	http://www.vorbis.com/	{}	{}	{}	vorbis-tools	1.4.0	4	0	f	{}	\N
15	arch	arch	core	zlib	\N	\N	zlib	\N	zlib	zlib	\N	1.2.8	1:1.2.8-7	\N	{}	\N	Compression library implementing the deflate compression method found in gzip and PKZIP	http://www.zlib.net/	{custom}	{}	{"base": "zlib"}	zlib	1.2.8	4	0	f	{}	\N
\.


--
-- Data for Name: problems; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.problems (package_id, repo, name, effname, maintainer, problem) FROM stdin;
11	cpan	Acme-Brainfuck	perl:acme-brainfuck	jaldhar@cpan	Homepage link "http://search.cpan.org/dist/Acme-Brainfuck/" points to CPAN which was discontinued. The link should be updated to https://metacpan.org (probably along with download URLs). See https://www.perl.com/article/saying-goodbye-to-search-cpan-org/ for details.
\.


--
-- Data for Name: project_redirects; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.project_redirects (oldname, newname, manual) FROM stdin;
\.


--
-- Data for Name: repo_metapackages; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repo_metapackages (repository_id, effname, newest, outdated, problematic, "unique") FROM stdin;
6	a52dec	t	f	f	t
5	asciinema	t	f	f	t
5	aspell	t	f	f	t
1	autofs	t	f	f	t
5	away	t	f	f	t
2	baudline	t	f	f	t
5	chromium-bsu	t	f	f	t
2	kforth	t	f	f	t
3	kiconvtool	t	f	f	t
2	oracle-xe	t	f	f	t
2	teamviewer	t	f	f	t
2	virtualbox	t	f	f	t
3	vorbis-tools	t	f	f	t
7	zlib	t	f	f	t
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.reports (id, created, updated, client, effname, need_verignore, need_split, need_merge, comment, reply, accepted) FROM stdin;
\.


--
-- Data for Name: repositories; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repositories (id, name, state, num_packages, num_packages_newest, num_packages_outdated, num_packages_ignored, num_packages_unique, num_packages_devel, num_packages_legacy, num_packages_incorrect, num_packages_untrusted, num_packages_noscheme, num_packages_rolling, num_metapackages, num_metapackages_unique, num_metapackages_newest, num_metapackages_outdated, num_metapackages_comparable, num_metapackages_problematic, num_problems, num_maintainers, first_seen, last_seen, used_package_fields, sortname, type, "desc", singular, family, color, shadow, repolinks, packagelinks) FROM stdin;
4	cpan	new	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	2019-11-12 17:53:58.093469+03	2019-11-12 17:53:58.093469+03	{rawversion,family,shadow,maintainers,versionclass,repo,name,effname,homepage,visiblename,version,projectname_seed,origversion}	cpan	modules	CPAN	CPAN package	cpan	\N	t	[{"url": "http://cpan.org/", "desc": "CPAN"}]	{}
6	debian_unstable	new	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	4	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{rawversion,family,subrepo,effname,maintainers,versionclass,repo,name,category,homepage,visiblename,version,projectname_seed,origversion}	debian_unstable	repository	Debian Unstable	Debian Unstable package	debuntu	c70036	f	[{"url": "https://www.debian.org/distrib/packages", "desc": "Debian packages"}, {"url": "https://packages.debian.org/unstable/", "desc": "Debian packages in unstable"}, {"url": "https://buildd.debian.org/", "desc": "Debian package auto-building status"}]	[{"url": "https://packages.debian.org/unstable/source/{name}", "desc": "Package details on packages.debian.org"}, {"url": "https://bugs.debian.org/{name}", "desc": "Related bugs in Debian bugzilla"}, {"url": "https://buildd.debian.org/status/package.php?p={name}&suite=unstable", "desc": "Package auto-building status"}, {"url": "https://qa.debian.org/popcon-graph.php?packages={name}", "desc": "Popularity contest statistics"}]
5	gentoo	new	4	0	0	0	4	0	0	0	0	0	0	4	4	0	0	0	0	0	3	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{flags,rawversion,family,licenses,effname,maintainers,versionclass,repo,name,category,homepage,keyname,comment,downloads,visiblename,version,projectname_seed,origversion}	gentoo	repository	Gentoo	Gentoo package	gentoo	62548f	f	[{"url": "https://gentoo.org/", "desc": "Gentoo Linux home"}, {"url": "https://packages.gentoo.org/", "desc": "Gentoo Packages"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/", "desc": "Official Gentoo ebuild repository"}, {"url": "https://github.com/gentoo/gentoo", "desc": "Gentoo ebuild repository mirror on GitHub"}]	[{"url": "https://packages.gentoo.org/packages/{category}/{name}", "desc": "Package details"}, {"url": "https://gitweb.gentoo.org/repo/gentoo.git/tree/{category}/{name}/{name}-{rawversion}.ebuild", "desc": "View ebuild"}]
1	gobolinux	new	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	0	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{rawversion,family,licenses,effname,versionclass,name,repo,downloads,homepage,comment,visiblename,version,projectname_seed,origversion}	gobolinux	repository	GoboLinux	GoboLinux package	gobolinux	\N	f	[{"url": "http://gobolinux.org/", "desc": "GoboLinux home"}, {"url": "https://github.com/gobolinux/Recipes", "desc": "GoboLinux recipes repository"}]	[{"url": "https://github.com/gobolinux/Recipes/tree/master/trunk/{name}/{origversion}", "desc": "Git"}]
2	slackbuilds	new	5	0	0	0	5	0	0	0	0	0	0	5	5	0	0	0	0	0	5	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{rawversion,family,effname,maintainers,versionclass,repo,name,category,homepage,downloads,visiblename,branch,version,projectname_seed,origversion}	slackbuilds	repository	SlackBuilds	SlackBuilds package	slackbuilds	000000	f	[{"url": "https://slackbuilds.org/", "desc": "SlackBuilds.org"}]	[{"url": "https://slackbuilds.org/repository/14.2/{category}/{name}/", "desc": "SlackBuilds.org page"}]
3	freebsd	new	2	0	0	0	2	0	0	0	0	0	0	2	2	0	0	0	0	0	2	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{rawversion,family,effname,maintainers,versionclass,repo,name,category,homepage,keyname,comment,visiblename,version,projectname_seed,origversion}	freebsd	repository	FreeBSD Ports	FreeBSD port	freebsd	990000	f	[{"url": "https://www.freebsd.org/", "desc": "FreeBSD home"}, {"url": "https://www.freebsd.org/ports/", "desc": "About FreeBSD ports"}, {"url": "https://www.freshports.org/", "desc": "FreshPorts - The Place For Ports"}, {"url": "https://svnweb.freebsd.org/ports/head/", "desc": "FreeBSD ports SVN repository"}, {"url": "https://pkg-status.freebsd.org/", "desc": "Package builds status"}]	[{"url": "https://www.freshports.org/{keyname}", "desc": "FreshPorts page"}, {"url": "https://svnweb.freebsd.org/ports/head/{keyname}/", "desc": "SVNWeb"}, {"url": "https://svnweb.freebsd.org/ports/head/{keyname}/Makefile?view=co", "desc": "Port's Makefile"}, {"url": "http://portsmon.freebsd.org/portoverview.py?category={keyname|dirname}&portname={keyname|basename}", "desc": "PortsMon"}, {"url": "https://bugs.freebsd.org/bugzilla/buglist.cgi?quicksearch={keyname}", "desc": "Related bugs in FreeBSD bugzilla"}]
7	arch	new	1	0	0	0	1	0	0	0	0	0	0	1	1	0	0	0	0	0	0	2019-11-12 17:53:58.093469+03	2019-11-12 17:54:10.859209+03	{rawversion,family,subrepo,licenses,versionclass,name,repo,extrafields,effname,homepage,comment,visiblename,basename,version,projectname_seed,origversion}	arch	repository	Arch	Arch package	arch	0088cc	f	[{"url": "https://www.archlinux.org/", "desc": "Arch Linux home"}, {"url": "https://www.archlinux.org/packages/", "desc": "Arch Linux Packages"}]	[{"url": "https://www.archlinux.org/packages/?q={name}", "desc": "Package details on www.archlinux.org"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk?h=packages/{archbase}", "desc": "Git repository"}, {"url": "https://git.archlinux.org/svntogit/{archrepo}.git/tree/trunk/PKGBUILD?h=packages/{archbase}", "desc": "PKGBUILD"}, {"url": "https://www.archlinux.org/packages/{subrepo}/x86_64/{name}/", "desc": "Package information (x86_64)"}]
\.


--
-- Data for Name: repositories_history; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repositories_history (ts, snapshot) FROM stdin;
2019-11-12 17:54:10.859209+03	{"arch": {"num_problems": 0, "num_maintainers": 0, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "cpan": {"num_problems": 1, "num_maintainers": 0, "num_metapackages": 0, "num_metapackages_newest": 0, "num_metapackages_unique": 0, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "gentoo": {"num_problems": 0, "num_maintainers": 3, "num_metapackages": 4, "num_metapackages_newest": 0, "num_metapackages_unique": 4, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "freebsd": {"num_problems": 0, "num_maintainers": 2, "num_metapackages": 2, "num_metapackages_newest": 0, "num_metapackages_unique": 2, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "gobolinux": {"num_problems": 0, "num_maintainers": 0, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "slackbuilds": {"num_problems": 0, "num_maintainers": 5, "num_metapackages": 5, "num_metapackages_newest": 0, "num_metapackages_unique": 5, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}, "debian_unstable": {"num_problems": 0, "num_maintainers": 4, "num_metapackages": 1, "num_metapackages_newest": 0, "num_metapackages_unique": 1, "num_metapackages_outdated": 0, "num_metapackages_comparable": 0, "num_metapackages_problematic": 0}}
\.


--
-- Data for Name: repository_ruleset_hashes; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.repository_ruleset_hashes (repository, ruleset_hash) FROM stdin;
arch	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
cpan	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
debian_unstable	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
freebsd	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
gentoo	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
gobolinux	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
slackbuilds	096024ac45d72b976a25e8e4043a6197aa0b818cf181e9e091586a480db19d7d
\.


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.runs (id, type, repository_id, status, no_changes, start_ts, finish_ts, num_lines, num_warnings, num_errors, utime, stime, maxrss, maxrss_delta, traceback) FROM stdin;
1	parse	7	successful	f	2019-11-12 17:54:10.664678+03	2019-11-12 17:54:10.70508+03	10	0	0	00:00:00.026126	00:00:00.00009	90520	416	\N
2	parse	4	successful	f	2019-11-12 17:54:10.711381+03	2019-11-12 17:54:10.725191+03	4	0	0	00:00:00.007547	00:00:00	91452	932	\N
3	parse	6	successful	f	2019-11-12 17:54:10.729387+03	2019-11-12 17:54:10.755049+03	8	0	0	00:00:00.015903	00:00:00	91788	336	\N
4	parse	3	successful	f	2019-11-12 17:54:10.759106+03	2019-11-12 17:54:10.777942+03	4	0	0	00:00:00.012407	00:00:00	92528	740	\N
5	parse	5	successful	f	2019-11-12 17:54:10.781965+03	2019-11-12 17:54:10.809148+03	4	0	0	00:00:00.020775	00:00:00	92548	20	\N
6	parse	1	successful	f	2019-11-12 17:54:10.813083+03	2019-11-12 17:54:10.825972+03	4	0	0	00:00:00.006964	00:00:00.000029	92548	0	\N
7	parse	2	successful	f	2019-11-12 17:54:10.830105+03	2019-11-12 17:54:10.856386+03	4	0	0	00:00:00.020208	00:00:00.000038	92580	32	\N
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
2019-11-12 17:54:10.859209+03	{"num_packages": 15, "num_problems": 1, "num_maintainers": 15, "num_metapackages": 14, "num_urls_checked": 0}
\.


--
-- Data for Name: url_relations; Type: TABLE DATA; Schema: public; Owner: repology_test
--

COPY public.url_relations (metapackage_id, urlhash) FROM stdin;
\.


--
-- Name: maintainer_repo_metapackages_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.maintainer_repo_metapackages_events_id_seq', 1, false);


--
-- Name: maintainers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.maintainers_id_seq', 16, true);


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
-- Name: repositories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: repology_test
--

SELECT pg_catalog.setval('public.repositories_id_seq', 8, true);


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
    ADD CONSTRAINT log_lines_pkey PRIMARY KEY (run_id, lineno, "timestamp", severity);


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
-- Name: maintainer_repo_metapackages_events maintainer_repo_metapackages_events_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.maintainer_repo_metapackages_events
    ADD CONSTRAINT maintainer_repo_metapackages_events_pkey PRIMARY KEY (id);


--
-- Name: maintainer_repo_metapackages maintainer_repo_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.maintainer_repo_metapackages
    ADD CONSTRAINT maintainer_repo_metapackages_pkey PRIMARY KEY (maintainer_id, repository_id, metapackage_id);


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
-- Name: project_redirects project_redirects_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.project_redirects
    ADD CONSTRAINT project_redirects_pkey PRIMARY KEY (oldname, newname);


--
-- Name: repo_metapackages repo_metapackages_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repo_metapackages
    ADD CONSTRAINT repo_metapackages_pkey PRIMARY KEY (repository_id, effname);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


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
-- Name: repository_ruleset_hashes repository_ruleset_hashes_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.repository_ruleset_hashes
    ADD CONSTRAINT repository_ruleset_hashes_pkey PRIMARY KEY (repository);


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
-- Name: url_relations url_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: repology_test
--

ALTER TABLE ONLY public.url_relations
    ADD CONSTRAINT url_relations_pkey PRIMARY KEY (metapackage_id, urlhash);


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

CREATE INDEX maintainer_repo_metapackages__maintainer_id_repository_id_t_idx ON public.maintainer_repo_metapackages_events USING btree (maintainer_id, repository_id, ts DESC, type DESC);


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

CREATE INDEX maintainers_recently_removed_idx ON public.maintainers USING btree (last_seen DESC, maintainer) WHERE (num_packages = 0);


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
-- Name: metapackages_events_effname_ts_type_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX metapackages_events_effname_ts_type_idx ON public.metapackages_events USING btree (effname, ts DESC, type DESC);


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

CREATE INDEX metapackages_recently_removed_idx ON public.metapackages USING btree (last_seen DESC, effname) WHERE (num_repos = 0);


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
-- Name: runs_repository_id_start_ts_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX runs_repository_id_start_ts_idx ON public.runs USING btree (repository_id, start_ts DESC);


--
-- Name: runs_repository_id_start_ts_idx_failed; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX runs_repository_id_start_ts_idx_failed ON public.runs USING btree (repository_id, start_ts DESC) WHERE (status = 'failed'::public.run_status);


--
-- Name: url_relations_urlhash_metapackage_id_idx; Type: INDEX; Schema: public; Owner: repology_test
--

CREATE INDEX url_relations_urlhash_metapackage_id_idx ON public.url_relations USING btree (urlhash, metapackage_id);


--
-- Name: maintainer_repo_metapackages maintainer_repo_metapackage_addremove; Type: TRIGGER; Schema: public; Owner: repology_test
--

CREATE TRIGGER maintainer_repo_metapackage_addremove AFTER INSERT OR DELETE ON public.maintainer_repo_metapackages FOR EACH ROW EXECUTE PROCEDURE public.maintainer_repo_metapackages_create_events_trigger();


--
-- Name: maintainer_repo_metapackages maintainer_repo_metapackage_update; Type: TRIGGER; Schema: public; Owner: repology_test
--

CREATE TRIGGER maintainer_repo_metapackage_update AFTER UPDATE ON public.maintainer_repo_metapackages FOR EACH ROW WHEN (((old.versions_uptodate IS DISTINCT FROM new.versions_uptodate) OR (old.versions_outdated IS DISTINCT FROM new.versions_outdated) OR (old.versions_ignored IS DISTINCT FROM new.versions_ignored))) EXECUTE PROCEDURE public.maintainer_repo_metapackages_create_events_trigger();


--
-- Name: metapackages metapackage_create; Type: TRIGGER; Schema: public; Owner: repology_test
--

CREATE TRIGGER metapackage_create AFTER INSERT ON public.metapackages FOR EACH ROW EXECUTE PROCEDURE public.metapackage_create_events_trigger();


--
-- Name: metapackages metapackage_update; Type: TRIGGER; Schema: public; Owner: repology_test
--

CREATE TRIGGER metapackage_update AFTER UPDATE ON public.metapackages FOR EACH ROW WHEN (((old.devel_versions IS DISTINCT FROM new.devel_versions) OR (old.devel_repos IS DISTINCT FROM new.devel_repos) OR (old.newest_versions IS DISTINCT FROM new.newest_versions) OR (old.newest_repos IS DISTINCT FROM new.newest_repos) OR (old.all_repos IS DISTINCT FROM new.all_repos))) EXECUTE PROCEDURE public.metapackage_create_events_trigger();


--
-- PostgreSQL database dump complete
--

