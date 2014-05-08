--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: earaujoassis; Tablespace: 
--

CREATE TABLE customers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    full_name text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.customers OWNER TO earaujoassis;

--
-- Name: customers_iid_seq; Type: SEQUENCE; Schema: public; Owner: earaujoassis
--

CREATE SEQUENCE customers_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_iid_seq OWNER TO earaujoassis;

--
-- Name: customers_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: earaujoassis
--

ALTER SEQUENCE customers_iid_seq OWNED BY customers.iid;


--
-- Name: loyalty_points; Type: TABLE; Schema: public; Owner: earaujoassis; Tablespace: 
--

CREATE TABLE loyalty_points (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    iid integer NOT NULL,
    customer_id uuid,
    description text,
    previous_points integer DEFAULT 0,
    current_points integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.loyalty_points OWNER TO earaujoassis;

--
-- Name: loyalty_points_iid_seq; Type: SEQUENCE; Schema: public; Owner: earaujoassis
--

CREATE SEQUENCE loyalty_points_iid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loyalty_points_iid_seq OWNER TO earaujoassis;

--
-- Name: loyalty_points_iid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: earaujoassis
--

ALTER SEQUENCE loyalty_points_iid_seq OWNED BY loyalty_points.iid;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: earaujoassis; Tablespace: 
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.schema_info OWNER TO earaujoassis;

--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: earaujoassis
--

ALTER TABLE ONLY customers ALTER COLUMN iid SET DEFAULT nextval('customers_iid_seq'::regclass);


--
-- Name: iid; Type: DEFAULT; Schema: public; Owner: earaujoassis
--

ALTER TABLE ONLY loyalty_points ALTER COLUMN iid SET DEFAULT nextval('loyalty_points_iid_seq'::regclass);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: earaujoassis; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: loyalty_points_pkey; Type: CONSTRAINT; Schema: public; Owner: earaujoassis; Tablespace: 
--

ALTER TABLE ONLY loyalty_points
    ADD CONSTRAINT loyalty_points_pkey PRIMARY KEY (id);


--
-- Name: customers_iid_index; Type: INDEX; Schema: public; Owner: earaujoassis; Tablespace: 
--

CREATE UNIQUE INDEX customers_iid_index ON customers USING btree (iid);


--
-- Name: loyalty_points_iid_index; Type: INDEX; Schema: public; Owner: earaujoassis; Tablespace: 
--

CREATE UNIQUE INDEX loyalty_points_iid_index ON loyalty_points USING btree (iid);


--
-- Name: loyalty_points_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: earaujoassis
--

ALTER TABLE ONLY loyalty_points
    ADD CONSTRAINT loyalty_points_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

