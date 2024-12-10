--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: default
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "default";

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: default
--

COMMENT ON SCHEMA public IS '';


--
-- Name: Role; Type: TYPE; Schema: public; Owner: default
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'ADMIN'
);


ALTER TYPE public."Role" OWNER TO "default";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _doctorsOnServices; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public."_doctorsOnServices" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_doctorsOnServices" OWNER TO "default";

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO "default";

--
-- Name: _proceduresOnServices; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public."_proceduresOnServices" (
    "A" integer NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_proceduresOnServices" OWNER TO "default";

--
-- Name: animals; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.animals (
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    sex text NOT NULL,
    castrated boolean NOT NULL,
    race text NOT NULL,
    "dateExit" timestamp(3) without time zone,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "homeId" text,
    "typeAnimalId" integer
);


ALTER TABLE public.animals OWNER TO "default";

--
-- Name: collaborators; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.collaborators (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    password text NOT NULL,
    type public."Role" DEFAULT 'USER'::public."Role" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "statusAccount" boolean DEFAULT true NOT NULL
);


ALTER TABLE public.collaborators OWNER TO "default";

--
-- Name: doctors; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.doctors (
    id text NOT NULL,
    name text NOT NULL,
    crmv text NOT NULL,
    expertise text NOT NULL,
    phone text NOT NULL,
    "socialReason" text NOT NULL,
    "openHours" text NOT NULL,
    cep text NOT NULL,
    state text NOT NULL,
    city text NOT NULL,
    address text NOT NULL,
    number text NOT NULL,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    district text NOT NULL
);


ALTER TABLE public.doctors OWNER TO "default";

--
-- Name: documents; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    key text NOT NULL,
    "animalId" text,
    "serviceId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.documents OWNER TO "default";

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: default
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO "default";

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: default
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: homes; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.homes (
    id text NOT NULL,
    cep text NOT NULL,
    state text NOT NULL,
    city text NOT NULL,
    address text NOT NULL,
    number text NOT NULL,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "collaboratorId" text,
    district text NOT NULL
);


ALTER TABLE public.homes OWNER TO "default";

--
-- Name: procedures; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.procedures (
    name text NOT NULL,
    description text NOT NULL,
    dosage text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.procedures OWNER TO "default";

--
-- Name: procedures_id_seq; Type: SEQUENCE; Schema: public; Owner: default
--

CREATE SEQUENCE public.procedures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.procedures_id_seq OWNER TO "default";

--
-- Name: procedures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: default
--

ALTER SEQUENCE public.procedures_id_seq OWNED BY public.procedures.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public.services (
    id text NOT NULL,
    description text NOT NULL,
    status boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "animalId" text
);


ALTER TABLE public.services OWNER TO "default";

--
-- Name: typesAnimals; Type: TABLE; Schema: public; Owner: default
--

CREATE TABLE public."typesAnimals" (
    type text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public."typesAnimals" OWNER TO "default";

--
-- Name: typesAnimals_id_seq; Type: SEQUENCE; Schema: public; Owner: default
--

CREATE SEQUENCE public."typesAnimals_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."typesAnimals_id_seq" OWNER TO "default";

--
-- Name: typesAnimals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: default
--

ALTER SEQUENCE public."typesAnimals_id_seq" OWNED BY public."typesAnimals".id;


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: procedures id; Type: DEFAULT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.procedures ALTER COLUMN id SET DEFAULT nextval('public.procedures_id_seq'::regclass);


--
-- Name: typesAnimals id; Type: DEFAULT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."typesAnimals" ALTER COLUMN id SET DEFAULT nextval('public."typesAnimals_id_seq"'::regclass);


--
-- Data for Name: _doctorsOnServices; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public."_doctorsOnServices" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
f0821201-eb4c-4e3e-af02-160677830967	0454d954b0c7637e590caa9d4d9b867e73f8c74079956d8d0caeae291bbce792	2024-10-24 20:46:21.508547+00	20240528225436_create_database	\N	\N	2024-10-24 20:46:20.731739+00	1
35350ff2-f0d4-4b9b-b61a-a3ee4a85fcdb	f59abf90fd87b2350372eca0a914d5ed6155824369ade03147085ca96380057f	2024-10-24 20:46:22.541803+00	20240528230057_rename_status_collaborator	\N	\N	2024-10-24 20:46:21.803551+00	1
ad2633f3-6642-4495-a49e-f3e10f3b9aae	4f7476273cc1e5a0764a6b89e8aa77b76fb05e2b672570e75b4fe74a30c3e0cf	2024-10-24 20:46:23.584357+00	20240614145334_add_row_district_homes	\N	\N	2024-10-24 20:46:22.836434+00	1
7b7bb10d-d291-4206-9eef-22f05ffb1319	9c79e2138195d2ddff81d8d2ba63cda9412a8c1999a1626a8125e5a5231fda46	2024-10-24 20:46:24.670687+00	20240620161345_toggle_types_for_index	\N	\N	2024-10-24 20:46:23.880456+00	1
00ca93ef-216b-4c62-b744-940d2c37c27e	aa6ead6edbd9205ebad990c3888dfa68dd7d1ffa1bd956006f355db256652ec8	2024-10-24 20:46:25.749987+00	20240621151136_create_relations_any_for_any	\N	\N	2024-10-24 20:46:24.962492+00	1
1e7d809a-ef39-4a19-a523-4cf01a2e708a	e16dbc3a756072026e3870e8bd2226ff04ccb427bce5a34e16558d044dc0a869	2024-10-24 20:46:26.773665+00	20240626212011_add_district_in_doctors	\N	\N	2024-10-24 20:46:26.042207+00	1
64e58cc6-e5b7-4d22-8ea9-9a43892c8e5c	3acc59d17a3c8ad31fecd9a6b873827212aac068ee0a7e09a07f486347aed74f	2024-10-24 20:46:27.805474+00	20240626213720_add_unique_crmv	\N	\N	2024-10-24 20:46:27.067802+00	1
10b6727a-34b9-4d71-8503-1803e7d6623b	a3cd9cbc126f0a33e7737a61242edefbedb11f85432e7575c85ddfe0e89c7fd1	2024-10-24 20:46:28.836164+00	20240702212842_remove_optional_in_services	\N	\N	2024-10-24 20:46:28.099574+00	1
9071626d-23f3-4287-85f9-b5a1a73c34ec	c52bbe8635997e9d139f364e930e01005b67fc219cf440ecb8a4fbc1f9998054	2024-10-24 20:46:29.921172+00	20240704171048_add_on_delete_cascade_in_relations	\N	\N	2024-10-24 20:46:29.13697+00	1
208835a3-e70b-46ee-ad07-c9fdb9293931	42460fde13acb6c2380fbb95747368669241ca429c2711085199afddf72f4438	2024-10-24 20:46:30.999678+00	20240704172514_toggle_cascate_for_setnull_in_relations	\N	\N	2024-10-24 20:46:30.21456+00	1
927b9b60-edf5-4837-93e7-6dc81d72d570	f2fdff4b9269e8608ba66d5dee821e4d068aaca2b4b91bb347c2b5129ebbdf5f	2024-10-24 20:46:47.879483+00	20241024204646_	\N	\N	2024-10-24 20:46:47.134892+00	1
bc310f1b-8a0a-4027-8a09-1b1cb5d9e012	ca0058625bd0b06e3b6ecff100d6ff164070580d4156ff94c6b40e1f70ca2d49	2024-10-25 17:35:38.492224+00	20241025173536_update_table_documents	\N	\N	2024-10-25 17:35:37.645998+00	1
\.


--
-- Data for Name: _proceduresOnServices; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public."_proceduresOnServices" ("A", "B") FROM stdin;
1	3f601af7-d6df-4dfc-83a4-41f836c0e6c6
\.


--
-- Data for Name: animals; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.animals (id, name, description, sex, castrated, race, "dateExit", status, "createdAt", "updatedAt", "homeId", "typeAnimalId") FROM stdin;
80121b44-08ac-4b85-8060-0ded3fd2ace0	Scooby	Cão Bravo	M	t	Lavrador	\N	t	2024-10-25 16:59:48.805	2024-10-25 16:59:48.805	0dcb6656-d49c-4a7c-ab85-a1e5087f9460	1
\.


--
-- Data for Name: collaborators; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.collaborators (id, name, email, phone, password, type, "createdAt", "updatedAt", "statusAccount") FROM stdin;
d377c864-9720-4bfe-af16-0f72b118fad6	Patrick Vinicius	patrick.oliveira@univale.br	55 33 999999999	$2b$10$WgXvkPB5F.FksQ73ae6i7eWbFpldFbT9/HY18GMy1PsMbCa5/n/0G	ADMIN	2024-10-24 22:07:02.031	2024-10-24 22:06:29.295	t
ed1cd443-2f17-477d-981c-9f17a46118fb	Vinicius Duarte	vini3546@hotmail.com	55 33 999999999	$2b$10$jX.axJ99cIqV0ijXqirHuOC8DFTmnhgNF/FltqDFMFdVbN8PNz.2S	ADMIN	2024-10-24 22:07:34.939	2024-10-24 22:07:10.435	t
87ffa6b9-4fb8-4144-86cc-824fe5caddad	Fabiano Pereira	fabiano.santos@univale.br	(33) 99999-9998	$2b$10$e3j5BXoh1HSvHSbyt4C1UuM1jd0.B50NNJHDcImYIY50kIUKF02hC	ADMIN	2024-10-24 22:07:07.052	2024-10-24 22:08:01.338	t
3041fc89-6552-440a-bed4-23caf98c4b16	Jefferson Guimares 	jeff@inapostasia.com	(33) 98835-5585	$2b$10$hLHupgl2VKeNVcwNGhz2EeEFZ8RrDg.4FlMY/MRG6dTudwbZzutGy	ADMIN	2024-11-02 20:04:12.278	2024-11-02 20:04:12.278	t
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.doctors (id, name, crmv, expertise, phone, "socialReason", "openHours", cep, state, city, address, number, status, "createdAt", "updatedAt", district) FROM stdin;
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.documents (id, key, "animalId", "serviceId", "createdAt", "updatedAt") FROM stdin;
35	/uploads/arvore-1730391029332.jpg	\N	3f601af7-d6df-4dfc-83a4-41f836c0e6c6	2024-10-31 16:10:29.355	2024-10-31 16:10:29.355
\.


--
-- Data for Name: homes; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.homes (id, cep, state, city, address, number, status, "createdAt", "updatedAt", "collaboratorId", district) FROM stdin;
0dcb6656-d49c-4a7c-ab85-a1e5087f9460	00000-000	Minas Gerais	Governador Valadares	Rua Jose da Silva	104b	t	2024-10-25 16:59:03.873	2024-10-25 16:59:03.873	87ffa6b9-4fb8-4144-86cc-824fe5caddad	Centro
d6b0a8d5-4688-45e7-8b4f-8691c2f4ddf7	35024-460	MG	Governador Valadares	Rua Francisco Xavier	283	t	2024-11-02 20:04:29.673	2024-11-02 20:04:29.673	3041fc89-6552-440a-bed4-23caf98c4b16	Sir
\.


--
-- Data for Name: procedures; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.procedures (name, description, dosage, "createdAt", "updatedAt", id) FROM stdin;
Vacina Gripe Canina	Protege contra o vírus da gripe canina	1 dose	2024-10-25 17:00:11.726	2024-10-25 17:00:11.726	1
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public.services (id, description, status, "createdAt", "updatedAt", "animalId") FROM stdin;
3f601af7-d6df-4dfc-83a4-41f836c0e6c6	Esse serviço foi urgente devido a...	t	2024-10-25 17:00:34.921	2024-10-25 17:00:34.921	80121b44-08ac-4b85-8060-0ded3fd2ace0
\.


--
-- Data for Name: typesAnimals; Type: TABLE DATA; Schema: public; Owner: default
--

COPY public."typesAnimals" (type, "createdAt", "updatedAt", id) FROM stdin;
Cachorro	2024-10-25 16:59:35.457	2024-10-25 16:59:35.457	1
\.


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: default
--

SELECT pg_catalog.setval('public.documents_id_seq', 35, true);


--
-- Name: procedures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: default
--

SELECT pg_catalog.setval('public.procedures_id_seq', 1, true);


--
-- Name: typesAnimals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: default
--

SELECT pg_catalog.setval('public."typesAnimals_id_seq"', 1, true);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: animals animals_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- Name: collaborators collaborators_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.collaborators
    ADD CONSTRAINT collaborators_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: homes homes_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.homes
    ADD CONSTRAINT homes_pkey PRIMARY KEY (id);


--
-- Name: procedures procedures_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT procedures_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: typesAnimals typesAnimals_pkey; Type: CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."typesAnimals"
    ADD CONSTRAINT "typesAnimals_pkey" PRIMARY KEY (id);


--
-- Name: _doctorsOnServices_AB_unique; Type: INDEX; Schema: public; Owner: default
--

CREATE UNIQUE INDEX "_doctorsOnServices_AB_unique" ON public."_doctorsOnServices" USING btree ("A", "B");


--
-- Name: _doctorsOnServices_B_index; Type: INDEX; Schema: public; Owner: default
--

CREATE INDEX "_doctorsOnServices_B_index" ON public."_doctorsOnServices" USING btree ("B");


--
-- Name: _proceduresOnServices_AB_unique; Type: INDEX; Schema: public; Owner: default
--

CREATE UNIQUE INDEX "_proceduresOnServices_AB_unique" ON public."_proceduresOnServices" USING btree ("A", "B");


--
-- Name: _proceduresOnServices_B_index; Type: INDEX; Schema: public; Owner: default
--

CREATE INDEX "_proceduresOnServices_B_index" ON public."_proceduresOnServices" USING btree ("B");


--
-- Name: collaborators_email_key; Type: INDEX; Schema: public; Owner: default
--

CREATE UNIQUE INDEX collaborators_email_key ON public.collaborators USING btree (email);


--
-- Name: doctors_crmv_key; Type: INDEX; Schema: public; Owner: default
--

CREATE UNIQUE INDEX doctors_crmv_key ON public.doctors USING btree (crmv);


--
-- Name: _doctorsOnServices _doctorsOnServices_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."_doctorsOnServices"
    ADD CONSTRAINT "_doctorsOnServices_A_fkey" FOREIGN KEY ("A") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _doctorsOnServices _doctorsOnServices_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."_doctorsOnServices"
    ADD CONSTRAINT "_doctorsOnServices_B_fkey" FOREIGN KEY ("B") REFERENCES public.services(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _proceduresOnServices _proceduresOnServices_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."_proceduresOnServices"
    ADD CONSTRAINT "_proceduresOnServices_A_fkey" FOREIGN KEY ("A") REFERENCES public.procedures(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _proceduresOnServices _proceduresOnServices_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public."_proceduresOnServices"
    ADD CONSTRAINT "_proceduresOnServices_B_fkey" FOREIGN KEY ("B") REFERENCES public.services(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: animals animals_homeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT "animals_homeId_fkey" FOREIGN KEY ("homeId") REFERENCES public.homes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: animals animals_typeAnimalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT "animals_typeAnimalId_fkey" FOREIGN KEY ("typeAnimalId") REFERENCES public."typesAnimals"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: documents documents_animalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT "documents_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES public.animals(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: documents documents_serviceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT "documents_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES public.services(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: homes homes_collaboratorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.homes
    ADD CONSTRAINT "homes_collaboratorId_fkey" FOREIGN KEY ("collaboratorId") REFERENCES public.collaborators(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: services services_animalId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: default
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT "services_animalId_fkey" FOREIGN KEY ("animalId") REFERENCES public.animals(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: default
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

