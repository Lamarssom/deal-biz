--
-- PostgreSQL database dump
--

\restrict h5iTooealNd1hl7F17bfXjE1JESrPDePj85Ciabg1omZ0DhJENdDucDlNrllgCc

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: merchants_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.merchants_role_enum AS ENUM (
    'MERCHANT'
);


ALTER TYPE public.merchants_role_enum OWNER TO postgres;

--
-- Name: promotions_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.promotions_type_enum AS ENUM (
    'STANDARD',
    'MICRO'
);


ALTER TYPE public.promotions_type_enum OWNER TO postgres;

--
-- Name: users_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.users_role_enum AS ENUM (
    'CUSTOMER'
);


ALTER TYPE public.users_role_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: lgas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lgas (
    id integer NOT NULL,
    state character varying(100) NOT NULL,
    lga character varying(100) NOT NULL,
    ward character varying(100),
    latitude numeric(10,6) NOT NULL,
    longitude numeric(10,6) NOT NULL
);


ALTER TABLE public.lgas OWNER TO postgres;

--
-- Name: lgas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lgas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lgas_id_seq OWNER TO postgres;

--
-- Name: lgas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lgas_id_seq OWNED BY public.lgas.id;


--
-- Name: merchants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchants (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role public.merchants_role_enum DEFAULT 'MERCHANT'::public.merchants_role_enum NOT NULL,
    "businessName" character varying NOT NULL,
    category character varying NOT NULL,
    latitude numeric(10,6),
    longitude numeric(10,6),
    "isVerified" boolean DEFAULT false NOT NULL,
    "verificationCode" character varying,
    "verificationExpiresAt" timestamp without time zone,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "businessLGA" character varying NOT NULL,
    "outstandingBalance" numeric(12,2) DEFAULT 0 NOT NULL,
    "lastInvoicedAt" timestamp without time zone,
    "dailySpendThisDay" numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    "dailyResetAt" timestamp without time zone,
    "dailyPromoLimit" integer DEFAULT 5 NOT NULL,
    "maxActivePromos" integer DEFAULT 3 NOT NULL
);


ALTER TABLE public.merchants OWNER TO postgres;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "merchantId" uuid NOT NULL,
    type public.promotions_type_enum NOT NULL,
    fee numeric(10,2) NOT NULL,
    price numeric(10,2),
    "originalPrice" integer,
    title character varying NOT NULL,
    description text,
    "photoUrl" character varying,
    "radiusKm" numeric(10,2),
    expiry timestamp without time zone NOT NULL,
    "quantityLimit" integer DEFAULT 0 NOT NULL,
    "redeemedCount" integer DEFAULT 0 NOT NULL,
    views integer DEFAULT 0 NOT NULL,
    "popularityScore" integer DEFAULT 0 NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "idempotencyKey" character varying,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- Name: redemptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redemptions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "promotionId" uuid NOT NULL,
    "customerId" uuid NOT NULL,
    "qrCode" character varying NOT NULL,
    "isRedeemed" boolean DEFAULT false NOT NULL,
    "redeemedAt" timestamp without time zone,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.redemptions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role public.users_role_enum DEFAULT 'CUSTOMER'::public.users_role_enum NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: lgas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lgas ALTER COLUMN id SET DEFAULT nextval('public.lgas_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Data for Name: lgas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lgas (id, state, lga, ward, latitude, longitude) FROM stdin;
1001	Benue	Obi	Odiapa	7.046354	8.263301
1002	Kano	Rano	Lausu	11.542085	8.592535
1003	Borno	Gubio	Felo	12.698702	12.986963
1004	Osun	Boluwaduro	Gbeleru Obaala I	7.909419	4.774131
1005	Katsina	Bakori	Kakumi	11.773333	7.349428
1006	Akwa Ibom	Ini	Iwerre	5.388056	7.847818
1007	Niger	Rafi	Tegina Gari	10.061332	6.125486
1008	Cross River	Ikom	Akparabong	6.078178	8.737356
1009	Ondo	Akure North	Oke-Afa/Owode	7.346624	5.245782
1010	Anambra	Ogbaru	Atani  I	5.947023	6.755108
1011	Ebonyi	Afikpo North	Ohaisu Afikpo 'A'	5.906122	7.923216
1012	Kogi	Ankpa	Ojoku III	7.404333	7.709696
1013	Kogi	Yagba West	Iyamerin/Igbaruku	8.381858	5.565368
1014	Kaduna	Igabi	Turunku	10.832607	7.670500
1015	Imo	Isiala Mbano	Umunkwo	5.642391	7.128220
1016	Nassarawa	Wamba	Wayo	8.862548	8.573004
1017	Oyo	Ogbomosho South	Oke-Ola/Farm Settlement	8.101408	4.237879
1018	Kano	Sumaila	Rumo	11.446386	8.858941
1019	Kano	Gabasawa	Joda	12.012514	8.850073
1020	Ondo	Akure South	Oda	7.145458	5.265618
1021	Kano	Tofa	Lambu	11.996842	8.319024
1022	Anambra	Dunukofia	Umunnachi  II	6.173136	6.914771
1023	Bauchi	Bauchi	Dawaki	10.327708	9.859390
1024	Imo	Ikeduru	Atta II	5.599789	7.154160
1025	Borno	Shani	Kombo	10.080747	11.942476
1026	Katsina	Zango	Yardaje	13.002124	8.577428
1027	Katsina	Malumfashi	Yaba	11.774411	7.551825
1028	Niger	Bida	Masaga II	9.093702	6.012886
1029	Kogi	Okehi	Ohueta	7.561966	6.121791
1030	Kano	Garum Mallam	Dorawar-Sallau	11.649167	8.384243
1031	Kebbi	Ngaski	Ngaski	10.367434	4.795321
1032	Kano	Takai	Fajewa	11.425110	9.062229
1033	Enugu	Udi	Egede/Umuoka	6.555082	7.351867
1034	Ekiti	Ikere	Afao/Kajola	7.512658	5.252835
1035	Anambra	Njikoka	Abagana  I	6.172380	6.956532
1036	Oyo	Afijio	Iware	7.695223	3.992855
1037	Kano	Albasu	Faragai	11.630297	8.953585
1038	Lagos	Surulere	Ikate	6.522041	3.335031
1039	Zamfara	Gusau	Wanke	11.991006	6.627054
1040	Ekiti	Efon	Efon VI	7.693039	4.981396
1041	Zamfara	Maru	Kanoma	12.182625	6.256287
1042	Kwara	Ilorin South	Balogun-Fulani II	8.484132	4.679385
1043	Yobe	Yusufari	Jebuwa	13.113222	10.929410
1044	Kano	Dambatta	Goron Maje	12.519643	8.648419
1045	Jigawa	Miga	Garbo	12.126229	9.757486
1046	Ondo	AkokoNorthWest	Ajowa/Igasi/Eriti/Gedegede	7.702250	5.862322
1047	Imo	Ideato South	Isiekenesi II	5.788179	7.172355
1048	Anambra	Njikoka	Nimo  I	6.147211	6.935359
1049	Niger	Muya	Daza	9.582012	6.971018
1050	Anambra	Dunukofia	Ifitedunu  II	6.212377	6.925190
1051	Ebonyi	Afikpo South	Nguzu	5.760436	7.810023
1052	Ogun	Odeda	Olodo	7.218929	3.561089
1053	Katsina	Kankiya	Sukuntuni	12.301149	7.772748
1054	Sokoto	Rabah	Rabah	13.138964	5.525354
1055	Rivers	Ikwerre	Omagwa	4.989977	6.925712
1056	Kano	Warawa	J/Galadima	11.919794	8.624816
1057	Ogun	Shagamu	Ogijo/Likosi	6.759221	3.462929
1058	Kano	Warawa	Garin Dau	11.810015	8.784276
1059	Enugu	Oji-River	Ugwuoba I	6.266657	7.157985
1060	Cross River	Akamkpa	Mbarakom	5.250981	8.290820
1061	Niger	Rijau	Ushe	11.199792	5.070533
1062	Katsina	Mai'Adua	Mai'adua 'C'	13.197839	8.209126
1063	Borno	Kala/Balge	Jilbe "B"/Koma Kaudi	11.937123	14.553067
1064	Osun	Ifedayo	Isinmi	8.011701	5.009363
1065	Jigawa	Kazaure	Unguwar Gabas	12.643882	8.429916
1066	Akwa Ibom	Onna	Oniong east II	4.622107	7.875698
1067	Akwa Ibom	Etim Ekpo	Etim Ekpo IV	4.970253	7.614822
1068	Niger	Chanchaga	Nassarawa 'C'	9.633210	6.530619
1069	Kwara	Baruten	Ilesha	8.875961	3.219765
1070	Kogi	Bassa	Akuba I	7.863423	7.090269
1071	Katsina	Mani	Jani	12.826898	7.796637
1072	Edo	Oredo	Ogbelaka/ Nekpenekpen	6.269561	5.593370
1073	Bayelsa	Kolokuma-Opokuma	Okoloba (Sabagreia) II	4.990914	6.193943
1074	Borno	Maiduguri	Shehuri  North	11.858822	13.220220
1075	Jigawa	Kaugama	Marke	12.312844	9.718827
1076	Oyo	Ibadan North West	Ward I NI (Part I)	7.373835	3.899428
1077	Edo	Esan West	Urohi	6.621202	6.107252
1078	Adamawa	Song	Kilange Hirna	9.676017	12.727887
1079	Kaduna	Kaduna North	Gabasawa	10.521565	7.464695
1080	Federal Capital Territory	Abaji	Yaba	8.653611	6.772622
1081	Oyo	Surulere	Baya-Oje	8.189855	4.380330
1082	Kebbi	Danko Wasagu	Kyabu/Kandu	11.643615	5.346363
1083	Plateau	Wase	Kumbong	9.067434	9.889815
1084	Ogun	Odeda	Odeda	7.220080	3.644725
1085	Sokoto	Tureta	Tsamiya	12.543328	5.454456
1086	Gombe	Akko	Tukulma	10.144878	11.013479
1087	Abia	Ukwa West	Ozaa Ukwu	4.897820	7.287909
1088	Yobe	Borsari	Garun Dole / Garin Alkali	12.776789	11.164552
1089	Yobe	Borsari	Danani	12.598354	11.639300
1090	Ogun	Obafemi-Owode	Moloko-Asipa	6.879209	3.377502
1091	Bauchi	Giade	Uzum "B"	11.515503	10.270223
1092	Osun	Irepodun	Olobu 'C'	7.832812	4.489443
1093	Osun	IfeCentral	Moore Ojaja	7.467509	4.627578
1094	Anambra	Nnewi North	Nnewi-ichi  I	6.029989	6.894520
1095	Jigawa	Kiyawa	Katanga	11.669165	9.467667
1096	Borno	Mafa	Anadua	11.932956	13.790611
1097	Anambra	Onitsha North	Inland Town V	6.104250	6.794594
1098	Osun	Irewole	Ikire 'E'	7.379075	4.208611
1099	Ebonyi	Ikwo	Ndufu Echara	6.108734	8.154924
1100	Imo	Nkwerre	Umukor (Nkwerre III)	5.716710	7.104798
1101	Bayelsa	Southern Ijaw	Ukubie	4.616218	5.781736
1102	Osun	Ila	Eyindi/Iperin	8.020705	4.905801
1103	Borno	Maiduguri	Fezzan	11.847689	13.216264
1104	Cross River	Ikom	Nde	6.096913	8.613236
1105	Osun	Iwo	Gidigbo  I	7.617870	4.157843
1106	Kwara	Offa	Ojomu North/North West	8.165956	4.722737
1107	Lagos	Lagos Island	Olowogbowo/Elegbata	6.463777	3.375459
1108	Katsina	Bakori	Dawan Musa	11.492451	7.531569
1109	Ondo	Ondo West	Ilunla/Bagbe/Odowo II	7.007251	4.808858
1110	Ekiti	Ido-Osi	Ido I	7.811533	5.144562
1111	Kwara	Ilorin South	Okaka II	8.480415	4.645138
1112	Cross River	Ogoja	Mbube West I	6.511710	8.886109
1113	Osun	Ayedaade	Olufi	7.491000	4.390949
1114	Kaduna	Makarfi	Tudun Wada	11.374586	7.880368
1115	Rivers	Oyigbo	Umuagbai	4.836444	7.375577
1116	Osun	Egbedore	Okin Ni/Olorunsogo/Ofatedo	7.797676	4.526359
1117	Katsina	Dutsin-M	Karofi B	12.484841	7.581987
1118	Jigawa	Kafin Hausa	Majawa	12.175492	10.083075
1119	Kano	Kunchi	Shamakawa	12.406681	8.283083
1120	Delta	Bomadi	Ogo - Eze	5.314479	5.788067
1121	Benue	Gwer West	Mbabuande	7.652147	8.160744
1122	Yobe	Karasuwa	Waro	12.902134	11.017699
1123	Yobe	Potiskum	Bolewa 'B'	11.666260	11.118130
1124	Ebonyi	Ezza South	Amagu/Nsokkara	6.109811	8.052492
1125	Rivers	Tai	Ward VII (Nonwa)	4.745477	7.251824
1126	Kano	Gwale	Galadanchi	11.973691	8.498447
1127	Anambra	Onitsha South	Bridge Head II	6.059383	6.753321
1128	Enugu	Udenu	Amala	6.933333	7.547319
1129	Bauchi	Kirfi	Badara	10.335481	10.366321
1130	Anambra	Dunukofia	Ukpo  I	6.194778	6.936291
1131	Kaduna	Makarfi	Daguziri	11.328299	7.881340
1132	Ondo	Ilaje	Ugbo I	6.147302	4.759681
1133	Kano	Kumbotso	Panshekara	11.886854	8.443657
1134	Akwa Ibom	Okobo	Eweme II	4.792340	8.081800
1135	Kaduna	Birnin Gwari	Kazagekage	10.891635	6.958575
1136	Kebbi	Dandi	Fana	11.657966	3.958226
1137	Imo	Ohaji-Egbema	Egbema 'B'	5.572593	6.762006
1138	Kano	Kabo	Dugabau	11.798381	8.213992
1139	Adamawa	Gombi	Gombi South	10.095955	12.833374
1140	Enugu	Nkanu East	Nomeh	6.184267	7.558936
1141	Sokoto	Kware	Basansan	13.096414	5.346497
1142	Oyo	Ibadan South West	Ward 08 SW7	7.377375	3.871736
1143	Jigawa	Babura	Jigawa	12.639925	8.963998
1144	Kaduna	Chikun	Kunai	10.505739	7.092425
1145	Osun	Isokan	Asalu Ikoyi	7.315991	4.142609
1146	Katsina	Dutsi	Yamel B	12.971933	8.073223
1147	Enugu	Enugu North	Onu-Asata	6.438110	7.499804
1148	Ogun	Ijebu North-East	Odosimadegun/Odosebora	6.908807	4.011838
1149	Imo	Nwangele	Dim-Na Nume	5.709575	7.120645
1150	Cross River	Bakassi	Efut Inwang	4.747923	8.526779
1151	Delta	Patani	Patani   III	5.227894	6.197717
1152	Borno	Damboa	Gumsuri/Misakurbudu	11.021086	12.874227
1153	Katsina	Katsina (K)	Wakilin Kudu II	12.982338	7.610297
1154	Zamfara	Bungudu	Furfuri/Kwai-Kwai	12.196741	6.543219
1155	Kwara	Ilorin West	Warrah/Egbe Jila/Oshin	8.419053	4.579990
1156	Nassarawa	Lafia	Makama	8.485502	8.495959
1157	Kaduna	Kudan	Garu	11.249036	7.712764
1158	Katsina	Katsina (K)	Shinkafi 'A	13.039313	7.649880
1159	Kano	Ajingi	Ungawar Bai	12.054053	8.994261
1160	Ondo	Akoko North-East	Isowopo I	7.537035	5.846765
1161	Kano	Dawakin Kudu	Tsakuwa	11.784934	8.630204
1162	Plateau	Wase	Nyalum/Kampani	9.126224	10.465121
1163	Cross River	Biase	Biakpan	5.564067	7.913083
1164	Kaduna	Birnin Gwari	Dogon Dawa	11.055769	7.125598
1165	Benue	Gwer East	Mbaikyaan	7.267378	8.236888
1166	Yobe	Fune	Kayeri	12.024814	11.113462
1167	Akwa Ibom	Oron	Oron Urban  X	4.805983	8.199647
1168	Kano	Bunkure	Kumurya	11.701907	8.690691
1169	Kogi	Adavi	Iruvucheba	7.620824	6.379840
1170	Kano	Sumaila	Magami	11.208020	8.898955
1171	Oyo	Lagelu	Ejioku/Igbon/Ariku	7.491936	4.078719
1172	Ebonyi	Ikwo	Ndufu Amagu	6.018724	8.142289
1173	Borno	Hawul	Shaffa	10.518828	12.365262
1174	Katsina	Mashi	Jigawa	13.043513	7.941671
1175	Rivers	Bonny	Ward VII Dema Abbey	4.453852	7.279849
1176	Oyo	Ibadan South East	Ward XI  E9 I	7.394507	3.942824
1177	Lagos	Surulere	Shitta/Ogunlana Drive	6.518016	3.346199
1178	Kano	Gezawa	Ketawa	12.058950	8.748496
1179	Kano	Gwarzo	Madadi	11.902943	8.063829
1180	Delta	IsokoNor	Ozoro  II	5.540683	6.260864
1181	Zamfara	Birnin Magaji	Gusami Hayi	12.396602	6.983201
1182	Benue	Katsina- Ala	Mbajir	7.541626	9.842009
1183	Niger	Lavun	Lagun	9.585909	5.489285
1184	Jigawa	Maigatari	Jajeri	12.665764	9.690875
1185	Delta	Warri South-West	Ogidigben	5.505502	5.277607
1186	Lagos	Lagos Island	Ilupesi	6.459937	3.391945
1187	Kano	Takai	Faruruwa	11.437364	9.222876
1188	Niger	Mokwa	Ja'agi	9.084251	5.365426
1189	Ekiti	Irepodun-Ifelodun	Iyin I	7.668554	5.212384
1190	Osun	Ilesha East	Upper & Lower Ijoka	7.619457	4.772058
1191	Akwa Ibom	Onna	Oniong west III	4.629405	7.822174
1192	Ondo	Ilaje	Aheri	6.324760	4.588192
1193	Imo	Oguta	Izombe	5.606753	6.865123
1194	Ekiti	Ijero	odo Owa	7.913233	5.046982
1195	Kaduna	Kaura	Mallagum	9.648920	8.411805
1196	Borno	Askira/Uba	Lassa	10.662302	13.313543
1197	Osun	Iwo	Molete  II	7.640410	4.203258
1198	Lagos	Agege	Agbotikuyo/Dopemu	6.631853	3.298156
1199	Kogi	Okene	Otutu	7.467278	6.231575
1200	Enugu	Nkanu East	Nkerefi I	6.149994	7.675379
1201	Osun	Osogbo	Ataoja  'B'	7.719365	4.574768
1202	Lagos	Ikorodu	Isiu	6.656158	3.613440
1203	Kano	Nasarawa	Dakata	12.004840	8.516294
1204	Ogun	Ijebu East	Imobi II	6.621084	4.081182
1205	Delta	EthiopeE	Agbon  V	5.714611	5.934923
1206	Katsina	Jibia	Farfaru	13.049984	7.262736
1207	Rivers	Ikwerre	Aluu	4.913387	6.930383
1208	Akwa Ibom	Ika	Achan Ika	5.040408	7.591110
1209	Jigawa	Malam Mado	Fateka Akurya	12.488251	9.956491
1210	Jigawa	Auyo	Auyo	12.321984	9.948628
1211	Enugu	Nkanu West	Obe	6.285194	7.479128
1212	Lagos	Kosofe	Anthony/Ajao Estate/Mende/Maryland	6.587874	3.364585
1213	Kano	Tofa	Janguza	11.932909	8.357882
1214	Ebonyi	Ishielu	Nkalagu	6.476507	7.769650
1215	Rivers	Oyigbo	Okoloma	4.831267	7.247286
1216	Lagos	Ikorodu	Igbogbo I	6.589652	3.506400
1217	Ondo	Ifedore	Ilara II	7.342846	5.077987
1218	Ogun	Odogbolu	Ogbo/Moraika/Ita-Epo I	6.743369	3.912535
1219	Ogun	Ijebu East	Ijebu Ife I	6.852025	4.151947
1220	Ondo	Akoko South-East	Epinmi I	7.481673	5.838336
1221	Kaduna	Zangon Kataf	Zonkwa	9.774553	8.313035
1222	Kaduna	Lere	Rimin Kura	10.177265	8.537809
1223	Taraba	Gassol	Nam Nai	8.719884	10.890038
1224	Kano	Dawakin Tofa	Dawaki East	12.112347	8.343793
1225	Kano	Garum Mallam	Garun Babba	11.578830	8.423268
1226	Kano	Karaye	Kurugu	11.816353	8.003016
1227	Abia	Ugwunagbo	Ward One	5.012197	7.348308
1228	Abia	Umuahia North	Isingwu	5.545442	7.431306
1229	Nassarawa	Toto	Ugya	8.163264	7.102696
1230	Gombe	Billiri	Billiri North	9.966684	11.187909
1231	Kwara	Offa	Ojomu Central II	8.157439	4.707125
1232	Bayelsa	Sagbama	Trofani	5.286537	6.360278
1233	Delta	Okpe	Aragba  Town	5.770399	5.806693
1234	Ebonyi	Onicha	Isi-Onicha	6.096761	7.774022
1235	Sokoto	Tangazar	Salewa	13.589530	5.091756
1236	Ogun	Ijebu-Ode	Itantebo	6.753917	3.967042
1237	Borno	Monguno	Kaguram	12.421273	13.339050
1238	Bayelsa	Sagbama	Sagbama	5.164770	6.211904
1239	Yobe	Fune	Daura/Bulanyiwa/Dubbul/Bauwa	11.460144	11.427046
1240	Kano	Karaye	Kafin Dafga	11.798287	8.107868
1241	Gombe	Yalmatu / Deba	Deba	10.246451	11.465794
1242	Niger	Chanchaga	Sabon Gari	9.611199	6.541636
1243	Jigawa	Garki	Gwarzon Garki	12.344921	8.817813
1244	Ekiti	Oye	Oye I	7.825039	5.311892
1245	Borno	Kaga	Ngamdu	11.778804	12.309928
1246	Ekiti	Ilejemeje	Eda Oniyo	7.966008	5.255032
1247	Borno	Dikwa	Gajibo	12.088667	13.994643
1248	Zamfara	Birnin Magaji	Gusami Gari	12.392812	6.861017
1249	Yobe	Tarmuwa	Biriri/Churokusko	12.050267	11.745403
1250	Katsina	Katsina (K)	Wakilin Kudu I	12.984766	7.594952
1251	Anambra	Onitsha South	Odoakpu V	6.074718	6.755687
1252	Plateau	Langtang South	Dadin Kowa	8.691362	9.881917
1253	Sokoto	Dange-Shuni	Tsafanade	12.847407	5.414812
1254	Jigawa	Biriniwa	Machinamari	12.923124	10.173118
1255	Katsina	Kankara	Kukasheka	11.840491	7.547081
1256	Adamawa	Shelleng	Bodwai	10.085262	12.284426
1257	Yobe	Yunusari	Mozogun/Kujari	12.895230	11.791439
1258	Bauchi	Toro	Rahama	10.462568	8.802036
1259	Delta	Sapele	Elume	5.781062	5.701773
1260	Delta	Patani	Agoloma	5.172289	6.162733
1261	Abia	Aba South	Aba River	5.086226	7.370527
1262	Imo	Ezinihitte Mbaise	Oboama/Umunama	5.430561	7.298538
1263	Katsina	Batsari	Yauyau/Mallamawa	12.979947	7.272541
1264	Abia	Isuikwuato	Isu Amawu	5.703665	7.450817
1265	Benue	Ukum	Borikyo	7.517979	9.691455
1266	Anambra	Oyi	Nteje  III	6.283370	6.929691
1267	Katsina	Dandume	Dandume A	11.459927	7.127641
1268	Kano	Dambatta	Saidawa	12.325437	8.595751
1269	Enugu	Nkanu West	Ibite Akegbe Ugwu	6.360925	7.453207
1270	Anambra	Awka South	Amawbia  III	6.197916	7.057184
1271	Katsina	Batsari	Karare	12.702099	7.351503
1272	Akwa Ibom	Urue Offong|Oruko	Urue Offong III	4.759694	8.165766
1273	Jigawa	Birnin Kudu	Kwangwara	11.511579	9.596900
1274	Anambra	Njikoka	Nawfia  I	6.196260	6.990012
1275	Plateau	Bassa	Kishika	10.051108	8.679716
1276	Ebonyi	Abakalik	Timber Shed	6.304779	8.094850
1277	Borno	Gwoza	Kirawa/Jimini	11.235797	13.897109
1278	Bayelsa	Nembe	Ogbolomabiri III	4.460765	6.327623
1279	Akwa Ibom	Etinan	Southern Iman III	4.752018	7.816822
1280	Kogi	Mopa-Muro	Okeagi/Ilai	8.006326	5.779210
1281	Yobe	Damaturu	Damakasu	11.780070	12.084313
1282	Adamawa	Fufore	Pariya	9.432879	12.754405
1283	Imo	Oru-East	Awo-Omamma IV	5.662656	6.979855
1284	Imo	Okigwe	Umualumuoke	5.707282	7.388086
1285	Bayelsa	Ogbia	Kolo	4.769334	6.392078
1286	Kogi	Ajaokuta	Ichuwa/Upaja	7.592857	6.478068
1287	Anambra	Nnewi North	Uruagu  I	6.010100	6.883296
1288	Abia	Bende	Item A	5.758077	7.669340
1289	Imo	Nkwerre	Owerre Nkworji I	5.742019	7.129961
1290	Imo	Ehime-Mbano	Nzerem/Ikpem	5.688472	7.339769
1291	Benue	Guma	Abinsi	7.737615	8.713510
1292	Yobe	Tarmuwa	Koka/Sungul	12.111198	12.140348
1293	Sokoto	Binji	Fakka	13.176332	4.973948
1294	Ekiti	Gboyin	Aisegba I	7.572064	5.393565
1295	Ebonyi	Ikwo	Ekpanwudele	6.078936	8.178510
1296	Akwa Ibom	Urue Offong|Oruko	Urue Offong II	4.751057	8.180549
1297	Lagos	Shomolu	Gbagada Phase II /Bariga/Apelehin	6.562943	3.389520
1298	Kebbi	Sakaba	Tudun Kuka	11.245156	5.447802
1299	Enugu	Igbo-eze South	Iheaka (Likki/Akutara Ward)	6.890558	7.452569
1300	Oyo	Irepo	Iba IV	9.132765	3.880267
1301	Benue	Konshisha	Mbayegh/Mbaikyer	6.850427	8.922547
1302	Abia	Osisioma	Ama - Asaa	5.250323	7.362105
1303	Katsina	Danmusa	Dan Alkima	12.238970	7.353386
1304	Enugu	Ezeagu	Oghe I	6.452827	7.284092
1305	Osun	Boluwaduro	Eripa	7.930378	4.741391
1306	Delta	IkaNorth	Otolokpo	6.226015	6.290551
1307	Abia	Isiala Ngwa South	Mbutu Ukwu	5.308434	7.310944
1308	Ogun	Abeokuta North	Ikija	7.219020	3.330241
2334	Ogun	Ipokia	Tube	6.501982	2.773083
1309	Anambra	Orumba North	Ndi Okpalaeze	6.095598	7.154076
1310	Enugu	Igbo-eze North	Umuozzi VIII	7.037830	7.480497
1311	Federal Capital Territory	Gwagwalada	Dobi	9.079171	6.946626
1312	Niger	Gbako	Gogata	9.187438	6.137038
1313	Anambra	Idemili South	Akwukwu	6.062369	6.788693
1314	Katsina	Mai'Adua	Mai'adua 'A'	13.162077	8.234575
1315	Kaduna	Sanga	Bokana	9.273124	8.618734
1316	Rivers	Ogba/Egbema/Andoni	Ndoni I	5.515328	6.591129
1317	Ondo	IleOluji/Okeigbo	Ileoluji I	7.254121	4.945970
1318	Katsina	Zango	Rogogo/Cidari	12.938888	8.526966
1319	Kano	Gwarzo	Jama' A	11.810982	7.904779
1320	Benue	Vandeikya	Ningev	6.852612	9.001052
1321	Plateau	Mikang	Garkawa North East	8.977382	9.752400
1322	Ondo	Akure South	Oke aro/uro II	7.178794	5.188492
1323	Niger	Mariga	Igwama	10.510786	5.983508
1324	Akwa Ibom	Eastern Obolo	Eastern Obolo X	4.533205	7.799506
1325	Kwara	Edu	Tsonga III	8.975769	5.144825
1326	Sokoto	Tureta	Kuruwa	12.452979	5.436720
1327	Kaduna	Kaduna North	Gaji	10.477056	7.447756
1328	Anambra	Ayamelum	Omasi	6.632954	7.040575
1329	Kogi	Ijumu	Egbeda Egga/Okedayo	7.892259	5.865565
1330	Ogun	Ijebu North	Atikori	7.055833	3.976345
1331	Kebbi	Gwandu	Maruda	12.536468	4.780536
1332	Ebonyi	Ohaozara	Umunaga	5.979316	7.707840
1333	Akwa Ibom	Ibeno	Ibeno X	4.567753	8.084911
1334	Ekiti	Ido-Osi	Ayetoro I	7.902697	5.106756
1335	Benue	Gboko	Mbadam	7.485236	8.712762
1336	Ebonyi	Afikpo South	Amaigbo	5.736495	7.829678
1337	Niger	Suleja	Hashimi 'A'	9.178617	7.147877
1338	Cross River	Obubra	Iyamoyong	5.853370	8.334888
1339	Zamfara	Gummi	Birnin Magaji	12.184700	5.496439
1340	Bayelsa	Sagbama	Ofoni II	5.101130	5.986460
1341	Niger	Kontogur	Magajiya	10.428938	5.486592
1342	Zamfara	Zurmi	Boko	12.745775	6.498027
1343	Borno	Bama	Lawanti / Malam / Mastari / Abbaram	11.617503	13.822719
1344	Ogun	Odeda	Alagbagba	7.219323	3.717794
1345	Kebbi	Bunza	Raha	12.047936	4.100344
1346	Taraba	Kurmi	Ndaforo/Geanda	7.232576	10.561471
1347	Rivers	Akukutor	Briggs II	4.702005	6.727045
1348	Akwa Ibom	Eket	Okon II	4.676898	7.885435
1349	Delta	Udu	Udu II	5.472538	5.861124
1350	Oyo	Olorunsogo	Seriki II (Agbele)	8.754092	4.125794
1351	Kwara	Ilorin East	Balogun Gambari II	8.508745	4.591632
1352	Edo	Uhunmwonde	Irhue	6.694720	5.896082
1353	Abia	Umu-Nneochi	Umuchieze I	5.995992	7.451439
1354	Oyo	Ibadan North East	Ward V E5A	7.369212	3.907210
1355	Kaduna	Jema'a	Bedde	9.217130	8.095151
1356	Ondo	Akoko South-East	Isua I	7.438433	5.885047
1357	Delta	EthiopeE	Agbon  VII	5.692771	6.010169
1358	Abia	Ohafia	Ohafor Ohafia	5.601715	7.864550
1359	Niger	Lapai	Arewa/Yamma	9.059817	6.559115
1360	Rivers	Asari-Toru	Buguma East  West	4.740023	6.856959
1361	Sokoto	Binji	Ruggar Iya	13.263861	4.925948
1362	Osun	Ife South	Aare	7.158878	4.668239
1363	Osun	Ife South	Abiri Ogudu	7.355933	4.665015
1364	Ondo	AkokoNorthWest	Ogbagi	7.566922	5.711788
1365	Niger	Magama	Ibelu North	10.642289	5.220566
1366	Akwa Ibom	Oron	Oron Urban VIII	4.781788	8.238394
1367	Adamawa	Shelleng	Kiri	9.711049	12.104619
1368	Abia	Aba South	Aba Town Hall	5.103210	7.362260
1369	Oyo	Ori-Ire	Ori Ire V	8.395134	4.106976
1370	Katsina	Daura	Madobi A	12.903753	8.252531
1371	Jigawa	Kaugama	Dabuwaran	12.385674	9.739205
1372	Sokoto	Sabon Birni	Kalgo	13.369909	6.275965
1373	Kano	Kibiya	Nariya	11.550420	8.643144
1374	Jigawa	Dutse	Kudai	11.613565	9.312742
1375	Niger	Rafi	Kundu	9.909135	6.158936
1376	Plateau	Pankshin	Pankshin  South (Belning)	9.228447	9.397939
1377	Kogi	Ibaji	Odeke	6.710182	6.778173
1378	Kogi	Ajaokuta	Old Ajaokuta	7.460580	6.650363
1379	Yobe	Yusufari	Yusufari	13.116042	11.216958
1380	Borno	Shani	Gwaskara	10.240334	12.247186
1381	Anambra	Aguata	Akpo	5.963007	7.099617
1382	Sokoto	Tambawal	Tambuwal/Shinfiri	12.352041	4.728383
1383	Plateau	Langtang South	Magama	8.450113	9.755041
1384	Sokoto	Sokoto North	Magajin Gari 'A'	13.076916	5.275182
1385	Ekiti	Ikole	Araromi/Bolorunduro	7.978383	5.469994
1386	Ogun	Obafemi-Owode	Oba	6.944783	3.324261
1387	Edo	Esan Centtral	Uwessan I	6.764327	6.324689
1388	Katsina	Ingawa	Yandoma	12.747438	8.084514
1389	Bayelsa	Nembe	Mini	4.609220	6.423866
1390	Anambra	Orumba South	Agbudu	5.990489	7.172617
1391	Kaduna	Kaura	Kukum	9.583128	8.373790
1392	Lagos	Shomolu	Palmgrove/Ijebutedo	6.555349	3.365162
1393	Yobe	Nguru	Maja-Kura	12.867800	10.328481
1394	Nassarawa	Keffi	Keffi Town East / Kofar Goriya	8.842146	7.889816
1395	Ogun	Egbado North	Imasai	6.962812	2.880873
1396	Akwa Ibom	Itu	East Itam III	5.156273	7.951785
1397	Ekiti	Ado-Ekiti	Ado 'J' Okesa	7.618037	5.198009
1398	Sokoto	Binji	Kilgori	13.106295	4.928302
1399	Kaduna	Kachia	Agunu	10.007718	7.935766
1400	Adamawa	Mayo-Belwa	Ndikong	9.134679	12.123778
1401	Oyo	Olorunsogo	Onigbeti III & IV (Agbeni)	8.770032	4.089316
1402	Ekiti	Ikere	Agbado/Oyo	7.493864	5.179497
1403	Edo	Ovia North East	Oghede	6.117872	5.353897
1404	Benue	Ogbadibo	Orokam III	6.972346	7.707381
1405	Kaduna	Giwa	Kidandan	10.914070	7.237263
1406	Oyo	Oyo East	Oluajo	7.914019	4.041073
1407	Kano	Garko	Katumari	11.535276	8.974526
1408	Yobe	Gujba	Goniri	11.495935	12.305702
1409	Benue	Agatu	Odugbeho	7.817369	8.118843
1410	Ondo	Irele	Ajagba II	6.446815	4.953263
1411	Kaduna	Kachia	Doka	9.913104	7.488272
1412	Kebbi	Arewa	Daura/Sakkwabe/Jarkuka	13.155821	4.309439
1413	Kano	Gezawa	Gezawa	12.115641	8.748604
1414	Benue	Gwer West	Ikyaghev	7.579325	8.175900
1415	Sokoto	Silame	Labani	12.894298	4.909692
1416	Cross River	Yakurr	Ntan	5.853770	8.137666
1417	Nassarawa	Obi	Agwatashi	8.340259	8.895973
1418	Borno	Biu	Dadin Kowa	10.832657	11.921580
1419	Delta	Ndokwa West	Ogume  I	5.722697	6.281784
1420	Bayelsa	Southern Ijaw	Oporoma II	4.872484	6.153379
1421	Kano	Tundun Wada	Yaryasa	11.281223	8.309766
1422	Zamfara	Bungudu	Nahuch	12.400173	6.538602
1423	Kwara	Kaiama	Kaiama II	9.633953	4.273909
1424	Oyo	Oyo West	Iseke	7.843521	3.920627
1425	Ogun	Ifo	Ibogun	6.857084	3.078261
1426	Bauchi	Zaki	Gumai	12.036231	10.367042
1427	Oyo	Oyo East	Jabata	7.851740	3.952268
1428	Enugu	Aninri	Okpanku	5.953306	7.671211
1429	Ekiti	Ido-Osi	Ilogbo	7.851517	5.133759
1430	Abia	Umuahia North	Ibeku East I	5.551341	7.496958
1431	Oyo	Atisbo	Baasi	8.324277	3.422519
1432	Niger	Tafa	Ija Gwari	9.246378	7.244601
1433	Akwa Ibom	Ibiono Ibom	Ikpanya	5.332319	7.855148
1434	Benue	Ushongo	Mbagba	7.009876	9.094258
1435	Oyo	Surulere	Iresaapa	8.053636	4.366586
1436	Sokoto	Tambawal	Faga/Alasan	12.283198	4.643665
1437	Anambra	Awka North	Achalla  I	6.367369	6.988986
1438	Akwa Ibom	Esit Eket	Ekpene Obo	4.669374	8.031464
1439	Ebonyi	Ivo	Ihenta Ogidi	5.917097	7.685182
1440	Bauchi	Tafawa-Balewa	Tapshin	9.607500	9.388204
1441	Kano	Wudil	Sabon Gari	11.797396	8.847192
1442	Imo	Ahiazu-Mbaise	Nnarambia	5.507113	7.256599
1443	Osun	Isokan	Awala  II	7.284750	4.266214
1444	Kaduna	Kauru	Geshere	10.124235	8.384941
1445	Borno	Ngala	Logumane	12.170027	14.108083
1446	Kwara	Edu	Lafiagi III	8.776132	5.248119
1447	Borno	Chibok	Shikarkir	10.772834	12.702176
1448	Osun	Oriade	Erin-Ijesa	7.563457	4.888306
1449	Kebbi	Yauri	Zamare	10.847587	4.786171
1450	Niger	Lapai	Ebbo/Gbacinku	8.480237	6.525534
1451	Anambra	Anambra East	Otuocha  II	6.327405	6.849357
1452	Rivers	Opobo/Nkoro	Diepiri	4.515825	7.539983
1453	Plateau	Langtang North	Reak	9.221764	9.831239
1454	Kano	Kibiya	Tarai	11.469421	8.643767
1455	Katsina	Musawa	Gingin	12.003089	7.777518
1456	Kwara	Asa	Odo-Ode/Aboto	8.172363	4.533894
1457	Nassarawa	Toto	Shege	8.118729	7.296078
1458	Kogi	Idah	Owoli Apa	7.085750	6.730388
1459	Anambra	Dunukofia	Ukpo  II	6.197012	6.947886
1460	Nassarawa	Wamba	Wamba East	8.953448	8.623175
1461	Imo	Ideato South	Umuchima	5.805235	7.107164
1462	Edo	Esan North East	Uelen/ Okugbe	6.718497	6.337046
1463	Kogi	Ogori Magongo	Ugugu	7.493536	6.125937
1464	Imo	Unuimo	Aboh/Okohia	5.821193	7.243813
1465	Benue	Oturkpo	Otukpo Town West	7.218835	8.128827
1466	Kogi	Mopa-Muro	Agbafogun	8.211276	5.918893
1467	Edo	Orhionmw	Ugboko	6.177533	5.968344
1468	Oyo	Olorunsogo	Onigbeti I (Iyamopo)	8.703559	4.111959
1469	Katsina	Malumfashi	Malum Fashi 'A'	11.761974	7.638589
1470	Katsina	Batagarawa	Yargamji	12.730689	7.535981
1471	Oyo	Ibadan North East	Ward I. EI	7.365045	3.906708
1472	Enugu	Igbo-Eti	Ejuoha/Udeme	6.678353	7.296268
1473	Ogun	Ipokia	Mauni I	6.527919	2.834947
1474	Oyo	Ogbomosho North	Sabo/Tara	8.196984	4.262042
1475	Plateau	Jos East	Federe	9.835443	9.112562
1476	Delta	Ughelli North	Ughelli  III	5.541612	5.972667
1477	Ondo	Ilaje	Mahin II	6.246739	4.685073
1478	Adamawa	Michika	Tumbara / Ngabili	10.547372	13.379041
1479	Rivers	Ahoada West	Ubie II	5.162674	6.559556
1480	Jigawa	Babura	Kuzunzumi	12.595241	8.689448
1481	Bauchi	Gamawa	Gamawa	12.146183	10.524148
1482	Imo	Okigwe	Ogii	5.764660	7.373462
1483	Borno	Kukawa	Yoyo	12.768672	13.688182
1484	Osun	Ayedaade	Ode-Omu Rural	7.567957	4.403839
1485	Ogun	Odogbolu	Odogbolu II	6.725300	3.723810
1486	Lagos	Lagos Mainland	Yaba/Igbobi	6.523159	3.367497
1487	Osun	Odo Otin	Baale	8.023959	4.666908
1488	Niger	Katcha	Badeggi	9.092557	6.175948
1489	Cross River	Yala	Wanihem	6.684332	8.600308
1490	Kano	Tofa	Ginsawa	12.019687	8.236561
1491	Benue	Obi	Irabi	7.005046	8.276980
1492	Taraba	Sardauna	Gembu 'A'	6.708597	11.273061
1493	Kano	Rimin Gado	Doka Dawa	11.970045	8.170418
1494	Ebonyi	Ishielu	Azuinyaba "A"	6.353618	7.777254
1495	Kogi	Okehi	Okaito/Usungwen	7.659669	6.336692
1496	Gombe	Gombe	Jeka Dafari	10.312113	11.225106
1497	Ogun	Odogbolu	Odogbolu I	6.773288	3.753551
1498	Imo	Oru-West	Otulu	5.736282	6.929015
1499	Rivers	Ikwerre	Umuanwa	5.060856	6.888388
1500	Edo	Esan South East	Illushi I	6.628591	6.575104
1501	Borno	Kaga	Dongo	11.563012	12.469213
1502	Anambra	Anambra East	Nando  I	6.316379	6.934141
1503	Niger	Rijau	Shambo	10.993491	5.315217
1504	Oyo	Irepo	Agoro	9.084977	3.845268
1505	Kano	Garum Mallam	Jobawa	11.693946	8.307356
1506	Oyo	Ogo-Oluwa	Ayetoro	7.952323	4.307860
1507	Delta	Udu	Opete/Assagba/Edjophe	5.530814	5.809395
1508	Taraba	Kurmi	Bente/Galea	7.002203	10.234428
1509	Imo	Ngor-Okpala	Obiangwu	5.392248	7.191330
1510	Imo	Ehime-Mbano	Umunakanu	5.631584	7.250701
1511	Cross River	Akamkpa	Awi	5.299849	8.432295
1512	Rivers	Emuoha	Ibaa	4.973429	6.790930
1513	Katsina	Safana	Zakka 'A'	12.611120	7.355297
1514	Borno	Jere	Old Maiduguri	11.851891	13.277784
1515	Yobe	Fune	Borno Kiji/Ngarho/Bebbende	12.156731	11.290679
1516	Benue	Ushongo	Ikyov	7.007937	9.351290
1517	Plateau	Kanke	Ampang-East	9.347647	9.506155
1518	Ondo	Idanre	Idale-Lemikan	7.107864	5.132947
1519	Katsina	Kafur	Masari	11.628777	7.656008
1520	Bayelsa	Southern Ijaw	East Bomo I	4.797263	6.123155
1521	Anambra	Idemili North	Oraukwu	6.106910	6.960190
1522	Kano	Kunchi	Kasuwar Kuka	12.394427	8.335824
1523	Rivers	Akukutor	Briggs III	4.709341	6.744762
1524	Imo	Mbaitoli	Orodo 'B'	5.625274	7.003503
1525	Kano	Gabasawa	Yautar Kudu	12.154620	8.762868
1526	Akwa Ibom	Esit Eket	Etebi Akwata	4.663878	8.111126
1527	Ekiti	Gboyin	Iluomoba	7.671678	5.411790
1528	Kaduna	Kajuru	Kufana	10.222279	7.843884
1529	Osun	Ola-Oluwa	Ogbaagba  II	7.707416	4.275270
1530	Kano	Tsanyawa	Dunbulun	12.167344	8.009135
1531	Sokoto	Wamakko	Kammata	12.956592	5.068991
1532	Kano	Kumbotso	Danmaliki	11.905556	8.500606
1533	Kwara	Pategi	Kpada I	8.635929	6.082211
1534	Kaduna	Kubau	Pambegua	10.622385	8.300681
1535	Bauchi	Zaki	Murmur  South	12.005742	10.261676
1536	Osun	Ede South	Babasanya	7.688897	4.447762
1537	Akwa Ibom	Uyo	Uyo Urban II	5.036860	7.920541
1538	Niger	Mokwa	Labozhi	9.165205	5.362176
1539	Katsina	Bindawa	Doro	12.772609	7.899608
1540	Imo	Unuimo	Okwelle	5.778418	7.226783
1541	Abia	Ikwuano	Oboro II	5.449346	7.549762
1542	Yobe	Gulani	Bumsa	10.970166	11.787132
1543	Benue	Apa	Ikobi	7.683022	8.012665
1544	Abia	Aba North	Industrial Area	5.114282	7.371861
1545	Jigawa	Auyo	Kafur	12.372338	10.036103
1546	Cross River	Obanliku	Bendi I	6.583199	9.173461
1547	Kano	Dawakin Kudu	Gurjiya	11.848802	8.561017
1548	Abia	Umu-Nneochi	Umuchieze  III	5.911870	7.362620
1549	Kwara	Kaiama	Gwanabe I	9.417215	4.293456
1550	Rivers	Obio/Akpor	Rumuodara	4.857112	7.036832
1551	Kebbi	Maiyama	Kuben Rigidiga	12.118860	4.255901
1552	Kano	Gaya	Wudilawa	11.744741	8.899202
1553	Imo	Ikeduru	Inyishi/Umudim	5.581427	7.185480
1554	Enugu	Nsukka	Ede-Ukwu	6.796637	7.405346
1555	Sokoto	Dange-Shuni	Bodai/Jurga	12.735784	5.394730
1556	Kano	Kunchi	Matan Fada	12.543897	8.229407
1557	Lagos	Oshodi/Isolo	Ilasamaja	6.534644	3.316602
1558	Anambra	Awka North	Ugbene	6.393520	7.063429
1559	Kwara	Moro	Ajanaku	8.617018	4.537454
1560	Plateau	Kanke	Dawaki	9.481603	9.594670
1561	Oyo	Lagelu	Oyedeji/Olode/Kutayi	7.555914	4.059891
1562	Bayelsa	Kolokuma-Opokuma	Sampou/Kalama	5.154045	6.373405
1563	Bauchi	Alkaleri	Yuli/ Lim	9.778164	10.388256
1564	Imo	Ihitte-Uboma Isinweke	Umuezegwu	5.606496	7.335137
1565	Rivers	Degema	Degema  III	4.775288	6.757060
1566	Kano	Garum Mallam	Kadawa	11.617423	8.407589
1567	Abia	Arochukwu	Ohaeke	5.549006	7.689244
1568	Bayelsa	Brass	Odioma/Diema	4.627556	6.578376
1569	Kano	Gezawa	Gawo	11.981472	8.747985
1570	Borno	Marte	Borsori	12.205399	13.729169
1571	Benue	Katsina- Ala	Mbayongo	7.285753	9.797672
1572	Abia	Ukwa East	Ikwuriator East	4.934822	7.457633
1573	Osun	Atakumosa West	Osu I	7.594020	4.629466
1574	Jigawa	Maigatari	Maigatari Arewa	12.808104	9.407940
1575	Gombe	Balanga	Kindiyo	9.713118	11.721484
1576	Borno	Mobbar	Gashagar	13.265261	12.632752
1577	Delta	IsokoNor	Ozoro  III	5.565216	6.234817
1578	Oyo	Oyo West	Isokun I	7.845533	3.932744
1579	Katsina	Kurfi	Tsauri 'B'	12.749764	7.460502
1580	Bayelsa	Yenagoa	Zarama	5.054374	6.393151
1581	Anambra	Aguata	Nkpologwu	5.969473	7.083463
1582	Edo	Owan West	Uzebba  II	6.998640	5.891624
1583	Abia	Isiala Ngwa North	Isiala Nsulu	5.353552	7.430983
1584	Cross River	Akamkpa	Oban	5.272354	8.668423
1585	Borno	Jere	Gongulong	11.937834	13.253692
1586	Ondo	Akure South	Odopetu	7.232200	5.187304
1587	Kano	Warawa	Gogel	11.904434	8.759454
1588	Cross River	Calabar South	Nine (9)	4.902230	8.258948
1589	Bauchi	Itas/Gadau	Zubuki	11.917594	10.086634
1590	Akwa Ibom	Obot Akara	Obot Akara III	5.270651	7.630794
1591	Borno	Konduga	Kelumiri / Ngalbi Amari / Yale	11.679565	13.705927
1592	Katsina	Bindawa	Faru/Dallaji	12.699167	7.882220
1593	Bauchi	Gamawa	Zindi	11.868976	10.769325
1594	Kebbi	Danko Wasagu	Ayu	11.167894	5.837750
1595	Kaduna	Giwa	Yakawada	11.210623	7.350566
1596	Abia	Aba North	Osusu II	5.120463	7.353904
1597	Osun	Atakumosa East	Igangan	7.452237	4.764366
1598	Kano	Nasarawa	Kawaji	12.004688	8.531783
1599	Imo	Unuimo	Ezelu	5.734021	7.210574
1600	Taraba	Sardauna	Mbamnga	6.592199	11.193249
1601	Rivers	Degema	Tomble  II	4.426918	6.975176
1602	Niger	Chanchaga	Tudun Wada South	9.580060	6.532465
1603	Osun	Ilesha West	Ikoyi / Ikoti Araromi	7.630054	4.734771
1604	Adamawa	Mubi North	Kolere	10.236415	13.318334
1605	Katsina	Dutsi	Sirika B	12.951709	8.108477
1606	Adamawa	Ganye	Yebbi	8.546081	11.923897
1607	Jigawa	Kafin Hausa	Gafaya	12.078872	9.970698
1608	Enugu	Nkanu West	Umueze	6.300183	7.500349
1609	Kano	Makoda	Makoda	12.423259	8.407854
1610	Bayelsa	Southern Ijaw	Oporoma I	4.836693	6.166284
1611	Yobe	Damaturu	Kukareta/Warsala	11.817581	12.210086
1612	Ebonyi	Ezza South	Echara	6.145514	7.926400
1613	Sokoto	Wamakko	Dundaye/Gumburawa	13.102673	5.219482
1614	Ogun	Abeokuta South	Ijemo	7.175777	3.360592
1615	Lagos	Lagos Island	Oluwole	6.453877	3.385344
1616	Sokoto	Wamakko	Arkilla	12.990611	5.233702
1617	Rivers	Ogu/Bolo	Ogu  I	4.700076	7.211115
1618	Osun	Ede South	Oloki/Akoda	7.624614	4.459579
1619	Ondo	Owo	Iyere	7.175632	5.640971
1620	Zamfara	Maradun	Maradun North	12.583761	6.353628
1621	Jigawa	Kafin Hausa	Ruba	11.991457	9.902029
1622	Kogi	Mopa-Muro	Illeteju II	8.074637	5.839258
1623	Jigawa	Kiyawa	Garko	11.839152	9.495820
1624	Kano	Tarauni	Darmanawa	11.950311	8.514494
1625	Katsina	Jibia	Jibia A	13.088789	7.224929
1626	Nassarawa	Nassarawa Egon	Agunji	8.673157	8.337873
1627	Kogi	Bassa	Mozum	7.824193	6.943488
1628	Kogi	Idah	Ukwaja	7.068306	6.728781
1629	Imo	Obowo	Umunachi	5.525993	7.394549
1630	Osun	Ila	Oke Ola	8.053328	4.885575
1631	Benue	Oju	Oju	6.829172	8.413918
1632	Anambra	Njikoka	Nimo  III	6.154594	6.982070
1633	Akwa Ibom	Oruk Anam	Ndot/Ikot Okoro II	4.932814	7.713439
1634	Ogun	Ipokia	Ihunbo/Ilase	6.783360	2.750387
1635	Adamawa	Guyuk	Purokayo	9.889566	12.042909
1636	Kaduna	Sanga	Gidan Waya	9.401812	8.450935
1637	Ekiti	Oye	Ayede North	7.753075	5.336184
1638	Ekiti	Ijero	Ekameta	7.693019	5.087914
1639	Niger	Gurara	Gawu	9.261651	6.986822
1640	Ogun	Ipokia	Ipokia I	6.621113	2.848229
1641	Niger	Mariga	Inkwai	10.143136	5.981338
1642	Akwa Ibom	Uruan	Northern Uruan I	5.077795	8.029135
1643	Borno	Gubio	Gazabure	12.883146	12.876006
1644	Rivers	Ogu/Bolo	Ogu  IV	4.695059	7.204243
1645	Yobe	Nangere	Degubi	11.635487	11.000975
1646	Delta	Sapele	Amuokpe	5.854475	5.676309
1647	Benue	Kwande	Usar	6.778034	9.573827
1648	Plateau	Barkin Ladi	Tafan	9.625161	8.999815
1649	Ondo	Akoko North-East	Oorun I	7.520342	5.747559
1650	Abia	Isiala Ngwa South	Amaise / Amaise Anaba	5.254293	7.293024
1651	Taraba	Yorro	Bikassa I	8.847281	11.627702
1652	Enugu	Igbo-eze North	Umuozzi VII	6.989680	7.401266
1653	Niger	Bida	Masaga  I	9.092879	6.018933
1654	Federal Capital Territory	Municipal	Kashi	8.752025	7.476980
1655	Ondo	Odigbo	Ebijan	6.711635	5.048078
1656	Borno	Kwaya Kusar	Gusi / Billa	10.409788	12.077432
1657	Taraba	Yorro	Nyaja II	8.992835	11.469892
1658	Adamawa	Ganye	Ganye II	8.392335	12.107600
1659	Lagos	Eti-Osa	Victoria Island II	6.428129	3.438113
1660	Sokoto	Silame	Gande West	13.064617	4.834358
1661	Sokoto	Bodinga	Sifawa/Lukuyawa	12.783754	5.153550
1662	Nassarawa	Awe	Kanje/Abuni	8.376875	9.232124
1663	Kano	Gwale	Diso	11.972463	8.502848
1664	Ekiti	Irepodun-Ifelodun	Igede III	7.665580	5.119406
1665	Kwara	Oke-Ero	Odo-Owa II	8.155913	5.280786
1666	Rivers	Gokana	Bomu II	4.630384	7.311894
1667	Kebbi	Jega	Alelu/Gehuru	12.072018	4.554404
1668	Delta	Bomadi	Kolafiogbene/Ekametagbene	5.193119	5.779730
1669	Sokoto	Bodinga	Bangi/Dabaga	12.724622	5.295497
1670	Taraba	Ibi	Sarkin Kudu III	8.167639	9.456979
1671	Imo	Mbaitoli	Ifakala	5.565265	7.005601
1672	Osun	Olorunda	Owode  II	7.780797	4.565235
1673	Anambra	Oyi	Awkuzu  II	6.245234	6.917663
1674	Nassarawa	Wamba	Konvah	8.903255	8.669652
1675	Akwa Ibom	Udung Uko	Udung Uko V	4.750419	8.245722
1676	Bayelsa	Southern Ijaw	Amassoma I	4.944278	6.110483
1677	Cross River	Obubra	Ofodua	5.980434	8.200652
1678	Nassarawa	Toto	Toto	8.368722	7.030256
1679	Ebonyi	Afikpo South	Amiri Ekoli	5.722531	7.861262
1680	Federal Capital Territory	Bwari	Kawu	9.280221	7.570337
1681	Ondo	Ilaje	Mahin I	6.237246	4.785018
1682	Enugu	Enugu East	Ibagwa-Nike/Edem	6.546966	7.524848
1683	Lagos	Lagos Mainland	Iwaya	6.508053	3.383279
1684	Oyo	Ibadan North	Ward II, N3	7.400737	3.896507
1685	Enugu	Isi-Uzo	Mbu I	6.796083	7.643671
1686	Kano	Fagge	Rijiyar Lemo	11.981242	8.533803
1687	Niger	Lapai	Gulu/Anguwa Vatsa	8.630701	6.570279
1688	Imo	Isu	Umundugba I	5.653265	7.087165
1689	Borno	Marte	Kulli	12.329304	13.628034
1690	Kano	Kura	Kosawa	11.742173	8.462044
1691	Kaduna	Kauru	Badurum Sama	9.923293	8.511687
1692	Ebonyi	Ohaukwu	Umuagara / Amechi	6.421877	8.000100
1693	Jigawa	Malam Mado	Arki	12.420432	9.919301
1694	Benue	Makurdi	Fildi	7.670637	8.610378
1695	Kwara	Oyun	Erin-Ile South	8.072132	4.642653
1696	Taraba	Ardo-Kola	Alim-Gora	8.953319	11.163009
1697	Kwara	Oyun	Igosun	8.085035	4.763131
1698	Lagos	Surulere	Yaba/Ojuelegba	6.522690	3.359301
1699	Lagos	Ifako/Ijaye	Ijaye	6.662047	3.337871
1700	Edo	Egor	Egor	6.374259	5.545130
1701	Lagos	Alimosho	Ikotun/Ijegun	6.541045	3.239307
1702	Zamfara	Shinkafi	Jangeru	12.971804	6.512701
1703	Lagos	Agege	Orile Agege/Oko Oba	6.658086	3.294638
1704	Kano	Ajingi	Chula	11.999226	8.992927
1705	Edo	Ikpoba-Okha	Oregbeni	6.344242	5.645290
1706	Lagos	Lagos Mainland	Glover/Ebute Metta	6.487099	3.374855
1707	Katsina	Dandume	Magaji Wando B	11.408863	7.145472
1708	Akwa Ibom	Essien Udim	Ukana West I	5.146234	7.637311
1709	Ekiti	Irepodun-Ifelodun	Awo	7.737212	5.129779
1710	Anambra	Ogbaru	Atani  II	5.912883	6.759485
1711	Kaduna	Kudan	Hunkuyi	11.261126	7.648732
1712	Kaduna	Kudan	Sabon Gari Hunkuyi	11.219389	7.700149
1713	Niger	Agaie	Magaji	8.887967	6.377432
1714	Taraba	Zing	Bitako	8.919967	11.882209
1715	Niger	Agaie	Tagagi	8.848739	6.494903
1716	Anambra	Njikoka	Abba  I	6.211576	6.966058
1717	Delta	IsokoSou	Oleh  II	5.455478	6.213934
1718	Oyo	Surulere	Mayin	8.016994	4.322205
1719	Oyo	Ibadan South East	S 1	7.351304	3.900281
1720	Ogun	Ipokia	Idiroko	6.792669	2.788159
1721	Benue	Oturkpo	Ugboju-Icho	7.371804	7.894799
1722	Akwa Ibom	Nsit Atai	Eastern Nsit VIII	4.790944	8.034415
1723	Yobe	Geidam	Shame Kura / Dilawa	12.843936	12.083270
1724	Kwara	Ifelodun	Idofian II	8.379642	4.663318
1725	Kano	Shanono	Kokiya	11.973613	8.051858
1726	Ondo	AkokoNorthWest	Arigidi/Iye I	7.587776	5.757708
1727	Bauchi	Ningi	Kurmi	11.079006	9.134668
1728	Zamfara	Maradun	Gora	12.858171	6.121656
1729	Nassarawa	Kokona	Hadari	8.898790	7.961811
1730	Enugu	Udi	Udi/Agbudu	6.316145	7.402892
1731	Sokoto	Wamakko	Wamakko	12.997405	5.098151
1732	Ondo	IleOluji/Okeigbo	Ileoluji V	7.321070	5.008891
1733	Kwara	Oyun	Igbona	8.180480	4.647219
1734	Kano	Rimin Gado	Zango Dan Abdu	11.993292	8.242197
1735	Akwa Ibom	Ibesikpo Asutan	Ibesikpo V	4.920066	7.923660
1736	Niger	Mokwa	Kpaki/Takuma	9.362657	5.297969
1737	Delta	Udu	Udu I	5.442309	5.864933
1738	Jigawa	Kafin Hausa	Jabo	12.311128	10.063790
1739	Cross River	Bekwarra	Nyanya	6.684311	8.943426
1740	Nassarawa	Akwanga	Akwanga East	8.935078	8.458338
1741	Anambra	Anambra East	Umuleri  II	6.299042	6.856154
1742	Ondo	Akoko North-East	IlepaII	7.521673	5.764867
1743	Anambra	Anambra West	Umuenwelum-anam	6.386119	6.736823
1744	Kano	Karaye	Karaye	11.791073	8.022594
1745	Kaduna	Zaria	Kwarbai "B"	11.049290	7.705465
1746	Kaduna	Kubau	Damau	10.834109	8.463576
1747	Oyo	Ibarapa East	Itabo	7.698919	3.546252
1748	Adamawa	Michika	Thukudou / Sufuku / zah	10.485662	13.429910
1749	Rivers	Ahoada East	Uppata  III	5.077509	6.613419
1750	Yobe	Damaturu	Maisandari/Waziri Ibrahim Estate	11.776926	12.005832
1751	Plateau	Barkin Ladi	Zabot	9.727429	8.934065
1752	Ogun	Egbado North	Aye Toro I	7.313294	2.923621
1753	Kebbi	Aleiro	Aliero  Dangaladima I	12.280255	4.479413
1754	Rivers	Khana	Taabaa	4.713380	7.400811
1755	Jigawa	Biriniwa	Nguwa	12.884309	10.129297
1756	Gombe	Gombe	Bolari East	10.311040	11.234763
1757	Ebonyi	Ohaukwu	Ezzamgbo	6.372920	7.978002
1758	Katsina	Batsari	Madogara	12.686979	7.235549
1759	Adamawa	Teungo	Kongin Baba II	8.062657	11.502993
1760	Cross River	Ogoja	Mbube West II	6.561089	8.864873
1761	Bauchi	Toro	Wonu	10.259261	9.077733
1762	Bauchi	Misau	Sirko	11.367712	10.449769
1763	Imo	Owerri North	Orji	5.510974	7.045302
1764	Sokoto	Sokoto North	S/Adar Gandu	13.043357	5.257155
1765	Akwa Ibom	Okobo	Eweme I	4.738212	8.066859
1766	Katsina	Danmusa	Dan Ali	12.129244	7.480474
1767	Sokoto	Gada	Dukamaje/Ilah	13.732480	5.841953
1768	Plateau	Mangu	Mangu Halle	9.528922	9.065356
1769	Edo	Owan West	Uzebba  I	7.007336	5.910773
1770	Sokoto	Tangazar	Kwacce-Huru	13.214944	5.070570
1771	Osun	Ayedire	Oluponna  III	7.510616	4.172623
1772	Kwara	Asa	Owode/Gbogun	8.436642	4.385319
1773	Kogi	Koton-Karfe	Ukwo-Koton-Karfe	8.084480	6.833644
1774	Kano	Gwale	Gyaranya	11.985495	8.501708
1775	Ondo	Ese-Odo	Apoi I	6.271578	4.889514
1776	Osun	Egbedore	Awo/Abudo	7.769576	4.420234
1777	Kaduna	Igabi	Igabi	10.878649	7.776035
1778	Plateau	Jos East	Shere East	9.979195	9.069287
1779	Bayelsa	Sagbama	Ebedebiri	5.141480	6.106967
1780	Kwara	Baruten	Gwedebereru/Babane	9.272754	3.686463
1781	Kogi	Ijumu	Iyamoye	7.781832	5.851562
1782	Katsina	Kurfi	Kurfi 'A'	12.651939	7.467361
1783	Kano	Sumaila	Kanawa	11.371384	9.018170
1784	Anambra	Aguata	Agulueze chukwu	6.002686	7.083584
1785	Kano	Shanono	Shanono	12.045624	7.970345
1786	Taraba	Takum	Bete	7.299624	9.920688
1787	Yobe	Fika	Mubi / Fusami / Garin Wayo	11.314988	11.290418
1788	Delta	Uvwie	Ugbomro/Ugbolokposo	5.562240	5.821080
1789	Cross River	Abi	Imabana I	5.925299	8.114460
1790	Kano	Minjibir	Kantama	12.164031	8.568670
1791	Akwa Ibom	Eastern Obolo	Eastern Obolo VIII	4.520397	7.752532
1792	Kebbi	Dandi	Kwakkwaba	11.751015	3.747805
1793	Bauchi	Tafawa-Balewa	Lere  South	9.700609	9.454634
1794	Ogun	Ifo	Coker	6.796352	3.106332
1795	Imo	Isiala Mbano	Osu-Owerre I	5.657061	7.234462
1796	Akwa Ibom	Ikot Ekpene	Ikot Ekpene I	5.153740	7.711515
1797	Benue	Apa	Edikwu I	7.598861	7.958815
1798	Borno	Bayo	Gamadadi	10.342665	11.659111
1799	Ebonyi	Ohaukwu	Okposhi II	6.446493	7.941193
1800	Ogun	Ijebu-Ode	Odo-Egbo/Oliworo	6.700485	3.944348
1801	Enugu	Igbo-eze North	Umuozzi IX	7.064589	7.463453
1802	Kaduna	Sanga	Arak	9.249867	8.391899
1803	Kaduna	Kauru	Makami	10.643167	8.069999
1804	Zamfara	Maru	Maru	12.345660	6.361535
1805	Borno	Biu	Yawi	10.601325	12.234574
1806	Kebbi	Yauri	Yelwa South	10.922352	4.740990
1807	Abia	Umuahia North	Ibeku East II	5.497583	7.504483
1808	Anambra	Orumba North	Ajalli  II (Umuabiama and Amaga)	6.045232	7.194030
1809	Kaduna	Kachia	Gidan Tagwai	9.691398	8.004023
1810	Nassarawa	Lafia	Adogi	8.565863	8.689749
1811	Kwara	Oke-Ero	Idofin Igbana I	8.197690	5.379814
1812	Imo	Aboh-Mbaise	Nguru-Nwenkwo	5.487162	7.226132
1813	Gombe	Funakaye	Bodor / Tilde	10.741184	11.310456
1814	Sokoto	Tangazar	Kalanjeni	13.274182	5.081719
1815	Borno	Hawul	Pama/Whitambaya	10.369338	12.220312
1816	Kwara	Baruten	Shinawu/Tunbuyan	9.063875	3.524849
1817	Katsina	Batsari	Abadau/Kagara	12.774921	7.340772
1818	Adamawa	Jada	Nyibango	8.579731	12.329240
1819	Abia	Oboma Ngwa	Ahiaba	5.149774	7.392221
1820	Kaduna	Soba	Kwassallo	11.162333	8.010972
1821	Akwa Ibom	Mkpat Enin	Ikpa Ikono II	4.790984	7.771814
1822	Katsina	Mashi	Tamilo 'A'	13.101452	7.923863
1823	Rivers	Ogba/Egbema/Andoni	Omoku Town V	5.424230	6.631014
1824	Rivers	Degema	Bakana  I	4.687383	6.931437
1825	Gombe	Akko	Kalshingi	10.161193	11.273457
1826	Lagos	Amuwo Odofin	Amuwo	6.456274	3.285695
1827	Kwara	Baruten	Kpaura/Yakiru	8.754558	2.869715
1828	Plateau	Mangu	Mangu  I	9.519272	9.136321
1829	Abia	Isuikwuato	Umunnekwu	5.787101	7.462700
1830	Kogi	Ajaokuta	Omgbo	7.633513	6.708519
1831	Ekiti	Ado-Ekiti	Ado 'L' Igbehin	7.635041	5.213729
1832	Benue	Gwer East	Gbemacha	7.610647	8.709861
1833	Akwa Ibom	Ibesikpo Asutan	Asutan III	4.880544	7.993002
1834	Lagos	Ifako/Ijaye	Alakuko/Kollington	6.698443	3.266996
1835	Lagos	Ikorodu	Odogunyan	6.676404	3.519620
1836	Anambra	Ayamelum	Umumbo	6.541601	7.010514
1837	Benue	Kwande	Tondov I	6.722663	9.233265
1838	Niger	Mashegu	Dapangi/Makera	9.578053	5.156821
1839	Bayelsa	Ogbia	Emeyal	4.871831	6.364508
1840	Niger	Lavun	Dassun	9.372243	5.496602
1841	Imo	Ehime-Mbano	Umualumaku/Umuihim	5.629277	7.281358
1842	Delta	Oshimili South	Cable Point I	6.151754	6.747539
1843	Imo	Njaba	Amucha I	5.725820	7.058641
1844	Katsina	Rimi	Masabo/Kurabau	12.962084	7.761259
1845	Imo	Ehime-Mbano	Nsu 'A' Ikpe	5.624150	7.310770
1846	Enugu	Igbo-Eti	Ukehe I	6.664675	7.454372
1847	Rivers	Ogu/Bolo	Ogu  V	4.690234	7.222094
1848	Kwara	Moro	Abati/Alara	8.570965	4.653003
1849	Kwara	Ilorin West	Adewole	8.505051	4.532826
1850	Katsina	Zango	Zango	13.049211	8.497611
1851	Abia	Ukwa East	Akwete	4.892909	7.396469
1852	Osun	Ola-Oluwa	Asa Ajagunlase	7.796614	4.204149
1853	Akwa Ibom	Ibesikpo Asutan	Asutan II	4.891228	7.975415
1854	Gombe	Akko	Akko	10.314953	10.959276
1855	Ogun	Ewekoro	Itori	6.847268	3.322455
1856	Bauchi	Giade	Sabon Sara	11.426371	10.285056
1857	Delta	Sapele	Sapele  Urban  V	5.895387	5.676178
1858	Rivers	Okrika	Kalio	4.746617	7.113299
1859	Oyo	Saki East	Sepeteri II	8.651166	3.743113
1860	Jigawa	Maigatari	Kukayasku	12.686072	9.558229
1861	Oyo	Ori-Ire	Ori Ire VII	8.019307	4.107507
1862	Oyo	Ona-Ara	Ogbere Tioya	7.347701	3.955621
1863	Kaduna	Sabon Gari	Zabi	11.161986	7.744993
1864	Benue	Okpokwu	Ugbokolo	7.133269	7.751942
1865	Nassarawa	Nasarawa	Kanah/Ondo/Apawu	8.345791	7.628513
1866	Bauchi	Bogoro	Bogoro "A"	9.695535	9.517886
1867	Bayelsa	Ogbia	Ogbia	4.692777	6.318932
1868	Yobe	Bade	Dagona	12.798800	10.738681
1869	Kogi	Yagba West	Isaulu Esa/Okoloke/Okunran	8.486198	5.523002
1870	Kaduna	Chikun	Kakau	10.330193	7.502854
1871	Ekiti	Ikole	Ijesa Isu	7.690785	5.504123
1872	Oyo	Ibadan South West	Ward 5 SW4	7.372091	3.886001
1873	Kwara	Moro	Babadudu	8.647842	4.716108
1874	Oyo	Oluyole	Olomi/Olurinde	7.302538	3.919019
1875	Ebonyi	Afikpo South	Ebunwana	5.786691	7.861228
1876	Ebonyi	Ebonyi	Echiaba	6.631335	8.099678
1877	Imo	Nwangele	Abajah Ward II	5.679892	7.096175
1878	Katsina	Danja	Tsangamawa	11.373506	7.476739
1879	Niger	Mokwa	Kudu	9.274579	5.340295
1880	Borno	Gwoza	Gwoza Town Gadamayo	11.080828	13.698552
1881	Borno	Bama	Yabiri Kura/Yabiri Gana/Chongolo	11.376097	14.070522
1882	Akwa Ibom	Udung Uko	Udung Uko II	4.747237	8.235452
1883	Federal Capital Territory	Gwagwalada	Tungan Maje	9.061726	7.136255
1884	Nassarawa	Keffi	Liman Abaji	8.846434	7.874205
1885	Ekiti	Ikole	Itapaji/Iyemero	8.030310	5.397528
1886	Kano	Kiru	Badafi	11.361055	8.177881
1887	Delta	Oshimili North	Ukala	6.418820	6.598733
1888	Lagos	Lagos Island	Olushi/Kakawa	6.450190	3.392533
1889	Niger	Rafi	Kusherki North	10.505205	6.417312
1890	Osun	Ede South	Kuye	7.688395	4.444087
1891	Akwa Ibom	Etinan	Etinan Urban I	4.838360	7.851151
1892	Osun	Odo Otin	Olukotun	7.982468	4.675556
1893	Lagos	Epe	Ajaganabe	6.557796	3.925920
1894	Lagos	Eti-Osa	Ikoyi II	6.447024	3.440303
1895	Ogun	Abeokuta South	Ago-Egun/Ijesa	7.151040	3.374371
1896	Bayelsa	Nembe	Ikensi	4.547737	6.453217
1897	Jigawa	Gagarawa	Medu	12.491789	9.433484
1898	Delta	Warri South	Bowen	5.503114	5.758313
1899	Cross River	Calabar Municipality	Three	4.962376	8.355680
1900	Cross River	Ikom	Nnam	6.312236	8.548735
1901	Bauchi	Gamjuwa	Yali	10.811604	10.400769
1902	Niger	Katcha	Essa	9.147732	6.247379
1903	Imo	Ikeduru	Ngugo/Ikembara	5.555264	7.151888
1904	Benue	Gwer West	Gaambe - Ushin	7.741667	8.113350
1905	Rivers	Ahoada East	Ahoada II	5.065945	6.651520
1906	Kano	Sumaila	Sitti	11.237191	8.744430
1907	Ondo	Ese-Odo	Arogbo I	6.202495	5.018152
1908	Lagos	Agege	Darocha	6.631870	3.321580
1909	Niger	Paikoro	Jere	9.471682	6.686402
1910	Kogi	Koton-Karfe	Irenodu	7.863089	6.823856
1911	Plateau	Bokkos	Butura	9.354778	8.933330
1912	Kogi	Olamaboro	Olamaboro IV	7.224582	7.528867
1913	Plateau	Langtang South	Mabudi	8.704857	9.792786
1914	Bauchi	Gamjuwa	Gungura	10.922688	9.704874
1915	Ebonyi	Ezza South	Umunwagu / Idembia	6.122904	7.954457
1916	Ondo	Ese-Odo	Arogbo II	6.164448	4.956834
1917	Katsina	Matazu	Matazu 'B'	12.265119	7.684448
1918	Kano	Gaya	Gaya Arewa	11.830674	9.034708
1919	Akwa Ibom	Nsit Ubium	Ibiakpan Obotim I	4.706738	7.927816
1920	Bauchi	Kirfi	Bara	10.300713	10.736832
1921	Plateau	Shendam	Yelwa	8.799377	9.692602
1922	Kogi	Mopa-Muro	Odole II	7.942661	5.785875
1923	Benue	Buruku	Binev	7.489629	9.254946
1924	Ebonyi	Ishielu	Ntezi	6.394034	7.899677
1925	Jigawa	Taura	Chukuto	12.237655	9.168217
1926	Anambra	Ihiala	Orsumoghu	5.870462	6.921787
1927	Osun	Ife South	Aye	7.251749	4.596121
1928	Lagos	Alimosho	Egbe/Agodo	6.546342	3.267186
1929	Imo	Isiala Mbano	Osuama/Anara	5.689250	7.183256
1930	Ebonyi	Afikpo North	Itim Afikpo	5.851724	7.896141
1931	Enugu	Ezeagu	Agba Umana	6.350058	7.162615
1932	Akwa Ibom	Ikot Ekpene	Ikot Ekpene II	5.167558	7.730895
1933	Oyo	Ogbomosho South	Ijeru I	8.098588	4.239586
1934	Akwa Ibom	Onna	Oniong west II	4.582495	7.824573
1935	Kwara	Isin	Ijara	8.236669	5.024347
1936	Rivers	Gokana	Kpor/Lewe/Gbe	4.641157	7.291967
1937	Kwara	Ifelodun	Share III	8.826167	4.855131
1938	Edo	Akoko Edo	Ososo	7.386361	6.295880
1939	Oyo	Ibarapa Central	Idere III (Koso/Apa)	7.497833	3.225642
1940	Akwa Ibom	Ibeno	Ibeno IX	4.565526	8.213532
1941	Ekiti	Gboyin	Ode II	7.667999	5.574039
1942	Taraba	Gashaka	Mai-Idanu	7.186630	11.567187
1943	Osun	Ilesha East	Ijamo	7.594612	4.761134
1944	Imo	Oru-East	Awo-Omamma I	5.648324	6.932038
1945	Osun	Ayedaade	Obalufon	7.286354	4.364787
1946	Yobe	Gulani	Bara	10.893571	11.714819
1947	Anambra	Idemili South	Nnokwa	6.085835	6.948593
1948	Kaduna	Lere	Saminaka	10.411282	8.680130
1949	Kano	Fagge	Yammata	11.992657	8.536146
1950	Kwara	Ilorin East	Maya/Ile-Apa	8.508976	4.648468
1951	Edo	Ikpoba-Okha	St. Saviour	6.320115	5.672283
1952	Akwa Ibom	Ikot Abasi	Ikpa Ibekwe I	4.574018	7.551626
1953	Borno	Kwaya Kusar	Kubuku	10.429448	12.001854
1954	Plateau	Bokkos	Mushere  West	9.106006	8.992139
1955	Bauchi	Bauchi	Zungur/Liman  Katagum	10.065110	9.756947
1956	Abia	Aba North	Umuola	5.108935	7.378079
1957	Sokoto	Gwadabaw	Huchi	13.362701	5.465683
1958	Kano	Tundun Wada	Jita	11.197769	8.505054
1959	Benue	Buruku	Mbaazagee	7.105239	9.127088
1960	Borno	Gwoza	Gwoza Wakane / Bulabulin	11.105867	13.670196
1961	Imo	Orsu	Orsu Ihiteukwa	5.845867	6.999712
1962	Delta	Uvwie	Enerhen II	5.518560	5.780391
1963	Imo	Ideato South	Dikenafia	5.740730	7.188040
1964	Adamawa	Madagali	Hyambula	10.886800	13.520742
1965	Lagos	Lagos Island	Eiyekole	6.462511	3.400920
1966	Federal Capital Territory	Abaji	Nuku	8.489699	6.946966
1967	Niger	Rafi	Sabon Gari	10.123253	6.299091
1968	Gombe	Kwami	Malleri	10.601923	11.531804
1969	Ogun	Ijebu East	Ikija	6.946786	4.267691
1970	Enugu	Enugu East	Mbulu-Njodo East	6.527691	7.611088
1971	Enugu	Igbo-Eti	Aku III	6.711797	7.337318
1972	Taraba	Takum	Fete	7.390966	9.984737
1973	Plateau	Bokkos	Richa	9.154736	8.876505
1974	Katsina	Bakori	Tsiga	11.621086	7.501848
1975	Jigawa	Birnin Kudu	Wurno	11.370205	9.607373
1976	Ebonyi	Izzi	Igbeagu Ndi Ettah	6.323756	8.287098
1977	Imo	Owerri Municipal	Aladinma I	5.506649	7.024943
1978	Benue	Apa	Ofoke	7.627868	7.815276
1979	Delta	Oshimili North	Ibusa  IV	6.173049	6.626600
1980	Adamawa	Yola South	Yolde Kohi	9.143581	12.511310
1981	Kebbi	Bagudo	Lolo/Giris	11.596028	3.642723
1982	Adamawa	Lamurde	Rigange	9.564613	11.760921
1983	Katsina	Bakori	Barde/Kwantakwaran	11.581622	7.515465
1984	Yobe	Geidam	Kawuri	12.895818	11.973035
1985	Rivers	Degema	Degema  II	4.758785	6.758640
1986	Benue	Okpokwu	Okpaile/Ingle	7.032902	7.865618
1987	Kebbi	Dandi	Geza	11.999009	3.864689
1988	Borno	Magumeri	Ardo Ram	12.175414	12.672558
1989	Bayelsa	Brass	Konsho	4.445420	6.090837
1990	Anambra	Ekwusigo	Ozubulu  II	5.945326	6.811337
1991	Lagos	Epe	Ago Owu	6.656077	3.741764
1992	Taraba	Gassol	Wuryo	8.320659	10.554340
1993	Kano	Gaya	Gaya kudu	11.791181	9.030483
1994	Delta	AniochaS	Aba - Unor	6.068550	6.484839
1995	Kaduna	Soba	Kinkiba	10.984209	7.849521
1996	Ebonyi	Ohaukwu	Okposhi  I	6.548153	8.040595
1997	Imo	Unuimo	Ozimo/Umuneze	5.797257	7.230688
1998	Oyo	Olorunsogo	Elerugba/Elehinke/Sagbo (Aperu)	8.747886	4.133626
1999	Kebbi	Koko/Bes	Koko Fircin	11.395658	4.493729
2000	Enugu	Nkanu East	Amagunze	6.352243	7.695159
2001	Kaduna	Kaura	Manchok	9.668307	8.531511
2002	Lagos	Ojo	Etegbin	6.453211	3.143017
2003	Kwara	Isin	Alla	8.312987	4.925533
2004	Akwa Ibom	Oron	Oron Urban IV	4.745202	8.295009
2005	Anambra	Ayamelum	Omor I	6.495365	6.985192
2006	Sokoto	Wurno	Lahodu/G/Bango	13.216662	5.368157
2007	Katsina	Musawa	Yaradau/Tabanni	12.086048	7.821489
2008	Katsina	Sandamu	Fago 'A'	12.896969	8.402026
2009	Kogi	Okene	Orietesu	7.463025	6.284479
2010	Rivers	Oyigbo	Oyigbo central	4.876114	7.139214
2011	Rivers	Obio/Akpor	Rumuigbo (8A)	4.856812	6.989440
2012	Imo	Ehime-Mbano	Umukabia	5.732728	7.306881
2013	Delta	Ughelli South	Jeremi III	5.382762	5.762560
2014	Rivers	Ogba/Egbema/Andoni	Egi  II	5.242760	6.611431
2015	Kano	Dala	Gwammaja	12.010189	8.475908
2016	Kogi	Ofu	Ugwolawo I	7.224639	6.963061
2017	Adamawa	Demsa	Dwam	9.416330	12.197260
2018	Lagos	Ikeja	Wasimi/Opebi/Allen	6.604660	3.345909
2019	Kano	Wudil	Achika	11.675577	8.879879
2020	Yobe	Yunusari	Degaltura/Ngamzai	13.027700	12.288411
2021	Ogun	Remo North	Ipara	6.963879	3.696990
2022	Oyo	Lagelu	Lalupon III	7.457776	4.034577
2023	Oyo	Iwajowa	Sabi Gana IV	7.870498	3.231668
2024	Ondo	Akoko North-East	Oyinmo	7.507737	5.744945
2025	Federal Capital Territory	Gwagwalada	Gwagwalada Centre	8.922588	7.038767
2026	Bauchi	Jama'are	Dogon jeji "B"	11.733085	9.865036
2027	Imo	Oguta	Oguta 'A'	5.644775	6.739876
2028	Bauchi	Tafawa-Balewa	Ball	9.851974	9.784459
2029	Osun	Ilesha West	Ereja	7.614970	4.741582
2030	Ogun	Ado Odo-Ota	Ilogbo	6.567329	2.880274
2031	Benue	Ukum	Lumbuv	7.744337	9.482103
2032	Adamawa	Guyuk	Kola	9.690486	12.036037
2033	Delta	Ughelli North	Evwreni	5.388327	6.043958
2034	Borno	Magumeri	Borno Yesu	12.195000	12.476685
2035	Adamawa	Mubi North	Vimtim	10.318544	13.334955
2036	Ebonyi	Onicha	Okuzu-Ukawu	6.037377	7.901686
2037	Kano	Kiru	Dansohiya	11.540581	8.054224
2038	Yobe	Machina	Maskandare	13.006546	10.015302
2039	Lagos	Agege	Iloro/Onipetesi	6.624430	3.304486
2040	Lagos	Kosofe	Ojota/Ogudu	6.599310	3.390610
2041	Niger	Mariga	Gulbin - Boka	10.776904	5.450707
2042	Kaduna	Igabi	Afaka	10.676600	7.318102
2043	Nassarawa	Lafia	Agyaragun Tofa	8.434082	8.517521
2044	Gombe	Billiri	Tanglang	9.848737	11.087366
2045	Kebbi	Ngaski	Wara	10.222818	4.605554
2046	Kano	Minjibir	Tsakiya	12.121081	8.540822
2047	Katsina	Danja	Dabai	11.381194	7.634517
2048	Gombe	Kaltungo	Ture	9.834426	11.460336
2049	Sokoto	Sabon Birni	Lajinge	13.587101	6.158931
2050	Cross River	Ikom	Yala/Nkum	5.991656	8.672316
2051	Niger	Shiroro	She	9.617566	6.727657
2052	Lagos	Epe	Oke-Balogun	6.567257	4.019093
2053	Sokoto	Rabah	Gandi 'A'	13.065970	5.798357
2054	Kwara	Ilorin East	Magaji Are I	8.456032	4.608158
2055	Delta	AniochaS	Ubulu - Unor	6.169699	6.460422
2056	Cross River	Boki	Bunyia/Okubuchi	6.402987	8.986910
2057	Kano	Kibiya	Kibiya II	11.490865	8.662084
2058	Adamawa	Fufore	Gurin	9.173144	12.822626
2059	Niger	Paikoro	Paiko Central	9.412218	6.626522
2060	Katsina	Baure	Hui	12.718003	8.726764
2061	Ebonyi	Ezza South	Onueke Urban	6.165197	8.025205
2062	Borno	Gwoza	Johode/Chikide/Kughum	11.057000	13.786652
2063	Jigawa	Gwaram	Gwaram Tsohuwa	11.254096	9.909136
2064	Jigawa	Yankwashi	Karkarna	12.766628	8.518253
2065	Adamawa	Numan	Sabon Pegi	9.465598	12.144052
2066	Delta	Ethiope West	Oghara II	5.940982	5.669670
2067	Kebbi	Aleiro	Aliero  Dangaladima II	12.222230	4.454594
2068	Benue	Ado	Royongo	6.951922	8.071282
2069	Lagos	Kosofe	Oworonshoki	6.577219	3.417551
2070	Imo	Owerri North	Awaka/Ihitte-Ogada	5.454591	7.148270
2071	Taraba	Yorro	Pupule III	9.065550	11.735738
2072	Borno	Ngala	Old Gamboru 'A'	12.162208	14.175875
2073	Ogun	Ijebu-Ode	Ijade/Imepe I	6.812740	3.884516
2074	Jigawa	Gwiwa	Shafe	12.807558	8.249342
2075	Benue	Ohimini	Idekpa	7.288936	7.944228
2076	Niger	Magama	Nassarawa	9.972234	4.620793
2077	Cross River	Biase	Umon South	5.342804	8.081158
2078	Kwara	Pategi	Kpada II	8.440285	5.963782
2079	Ondo	Ese-Odo	Ukparama II	6.038108	5.062852
2080	Abia	Umu-Nneochi	Ndiawa/Umuelem/I	5.976770	7.407888
2081	Osun	Ife South	Osi	7.274130	4.554212
2082	Kano	Bagwai	Kwajali	12.049394	8.203329
2083	Sokoto	Sabon Birni	Kurawa	13.483243	6.232490
2084	Akwa Ibom	Ibiono Ibom	Ibiono Southern II	5.055179	7.846623
2085	Adamawa	Mubi South	Dirbishi/Gandira	10.220774	13.450305
2086	Plateau	Barkin Ladi	Marit/Mazat	9.475576	8.941153
2087	Imo	Oguta	Uwaorie	5.543261	6.900146
2088	Ebonyi	Afikpo North	Uwana Afikpo II	5.768071	7.898939
2089	Benue	Okpokwu	Okpoga South	6.894976	7.842582
2090	Jigawa	Gumel	Danama	12.621740	9.318414
2091	Delta	Warri North	Opuama (Egbema I)	5.695048	5.161244
2092	Lagos	Eti-Osa	Ilado/Eti-Osa and Environs	6.437349	3.596889
2093	Lagos	Lagos Mainland	Oyingbo Market/Ebute Metta	6.479484	3.381595
2094	Osun	Isokan	Alapomu  II	7.306933	4.224170
2095	Ondo	Ondo East	Bolorunduro I	7.170140	4.992403
2096	Kogi	Ajaokuta	Ebiya South	7.436232	6.521685
2097	Katsina	Safana	Runka 'B'	12.347969	7.218343
2098	Oyo	Oluyole	Olonde/Aba-Nla	7.131077	3.797353
2099	Benue	Oturkpo	Adoka-Icho	7.448110	7.941987
2100	Ogun	Abeokuta South	Ibara I	7.139388	3.333187
2101	Borno	Dikwa	Dikwa	12.049245	13.940167
2102	Kwara	Asa	Adigbongbo/Awe/Orimaro	8.513635	4.344261
2103	Katsina	Rimi	Fardami	12.874382	7.737302
2104	Kaduna	Soba	Maigana	10.953646	7.898252
2105	Anambra	Aguata	Umuona	6.029520	7.045525
2106	Anambra	Aguata	Amesi	5.943041	7.090958
2107	Kwara	Asa	Ila-Oja	8.134460	4.549275
2108	Borno	Maiduguri	Shehuri South	11.851784	13.220752
2109	Akwa Ibom	Essien Udim	Odoro Ikot I	5.138374	7.550958
2110	Kebbi	Jega	Jega Magaji 'B'	12.161492	4.444842
2111	Oyo	Iwajowa	Sabi Gana I	7.976585	3.244411
2112	Taraba	Kurmi	Abong	7.074516	10.670317
2113	Osun	Osogbo	Jagun B'	7.740603	4.585060
2114	Gombe	Nafada	Nafada Central	11.148508	11.298818
2115	Ekiti	Ikere	Ilapetu/Ijao	7.547062	5.205588
2116	Borno	Biu	Kenken	10.610074	12.187687
2117	Osun	Boripe	Agba	7.876223	4.703723
2118	Enugu	Igbo-eze North	Essodo I	7.032903	7.449393
2119	Gombe	Kwami	Dukul	10.610986	11.455079
2120	Rivers	Abua/Odu	Abua  IV	4.875091	6.651182
2121	Sokoto	Tureta	Lambar Tureta	12.652904	5.591680
2122	Ondo	Odigbo	Ore II	6.721871	5.015011
2123	Benue	Gboko	Mbaa Varakaa	7.424077	8.776134
2124	Plateau	Jos North	Abba Na Shehu	9.932074	8.891118
2125	Kaduna	Kauru	Damakasuwa	9.913707	8.587604
2126	Zamfara	Birnin Magaji	Gora	12.445455	6.736274
2127	Katsina	Funtua	Ung Ibrahim	11.515719	7.310113
2128	Oyo	Iseyin	Ado-awaye	7.789688	3.392805
2129	Jigawa	Guri	Lafiya	12.774192	10.500719
2130	Imo	Isu	Isu-Njaba I	5.704713	7.057319
2131	Rivers	Obio/Akpor	Rumuokoro	4.868004	6.997230
2132	Benue	Konshisha	Mbaikyase	7.181669	8.594366
2133	Rivers	Ogba/Egbema/Andoni	Usomini South Kreigani	5.252530	6.589032
2134	Kaduna	Kagarko	Jere North	9.474729	7.387221
2135	Sokoto	Isa	Isa South	13.176307	6.380969
2136	Delta	Burutu	Seimbiri	5.140395	5.620644
2137	Rivers	Akukutor	Obonoma	4.673830	6.755945
2138	Ebonyi	Ezza South	Amana	6.160042	8.069493
2139	Ekiti	Ido-Osi	Igbole/Ifisin/Aaye	7.806469	5.212906
2140	Benue	Kwande	Adikpo Metropolis	6.819315	9.243507
2141	Cross River	Obubra	Apiapum	5.995389	8.326499
2142	Lagos	Kosofe	Ketu/Alapere/Agidi/Orisigu/Kosofe/Ajelogo/Akanimod	6.611887	3.406714
2143	Gombe	Kaltungo	Kamo	9.974699	11.436564
2144	Sokoto	Wurno	Dimbiso	13.328229	5.519701
2145	Osun	Ede South	Sekona	7.590731	4.463726
2146	Jigawa	Gagarawa	Madaka	12.514313	9.556425
2147	Yobe	Damaturu	Njiwaji/Gwange	11.691851	11.980212
2148	Akwa Ibom	Ukanafun	Northern Afaha I	4.947467	7.703316
2149	Ondo	Okitipupa	Ikoya/oloto	6.496609	4.657329
2150	Katsina	Kafur	Kafur	11.680660	7.678587
2151	Abia	Isuikwuato	Imenyi	5.689394	7.519016
2152	Plateau	Langtang North	Pishe/Yashi	9.218204	9.898732
2153	Kebbi	Bagudo	Bahindi/Boki-Doma	11.470047	4.107457
2154	Imo	Ideato North	Isiokpo	5.911090	7.098728
2155	Kano	Doguwa	Ririwai	10.737119	8.721461
2156	Taraba	Karim-Lamido	Didango	9.175638	11.052604
2157	Enugu	Nkanu West	Akegbe-Ugwu (okwuo)	6.315651	7.442351
2158	Kaduna	Kaduna South	Sabon Gari North	10.522030	7.421209
2159	Sokoto	Tangazar	Raka	13.445043	5.093919
2160	Niger	Gbako	Batagi	9.126469	6.116973
2161	Jigawa	Birnin Kudu	Kiyako	11.357725	9.554901
2162	Anambra	Njikoka	Abba  II	6.210983	6.954879
2163	Jigawa	Kiyawa	Guruduba	11.757579	9.408532
2164	Adamawa	Madagali	Shelmi / Sukur/ Vapura	10.822900	13.549102
2165	Oyo	Ibarapa North	Tapa I	7.571561	3.299152
2166	Gombe	Billiri	Baganje North	9.892885	11.102315
2167	Delta	Oshimili North	Illah	6.413777	6.658005
2168	Enugu	Udi	Obinagu	6.290757	7.396420
2169	Katsina	Mani	Tsagem/Takusheyi	12.964098	7.837740
2170	Anambra	Orumba North	Ndiokolo/Ndiokpaleke	6.034624	7.153119
2171	Anambra	Ekwusigo	Ozubulu  I	5.941614	6.832384
2172	Ogun	Ikenne	Ikenne I	6.825486	3.702990
2173	Gombe	Shomgom	Lalaipido	9.722487	11.215824
2174	Borno	Nganzai	Kuda	12.646151	13.102661
2175	Lagos	Mushin	Ilupeju	6.561842	3.352899
2176	Enugu	Enugu North	Gui Newlayout	6.425109	7.501561
2177	Abia	Umuahia South	Omaegwu	5.487194	7.403940
2178	Katsina	Kankiya	Magam/Tsa	12.414774	7.843220
2179	Anambra	Orumba South	Ogboji	6.016070	7.160769
2180	Bauchi	Ningi	Balma	11.246950	9.355229
2181	Plateau	Pankshin	Chip	9.135610	9.362322
2182	Osun	Ife East	Okerewe  II	7.395357	4.604337
2183	Ebonyi	Ohaukwu	Wigbeke II	6.671272	8.049735
2184	Osun	Boluwaduro	Oke-Irun	7.926402	4.798068
2185	Plateau	Langtang North	Lipchok	9.113273	9.833394
2186	Kebbi	Sakaba	Janbirni	11.171239	5.626602
2187	Ondo	Idanre	Ala-Elefosan	6.995962	5.369702
2188	Bauchi	Toro	Toro / Tulai	10.042904	9.114162
2189	Akwa Ibom	Etim Ekpo	Etim Ekpo X	4.932297	7.508568
2190	Ekiti	Ilejemeje	Obada	7.960883	5.233233
2191	Kano	Bagwai	Rimin Dako	12.080314	8.199629
2192	Borno	Askira/Uba	Ngohi	10.605189	12.735492
2193	Enugu	Nkanu West	Ndiuno Uwani (Akpugo I)	6.313534	7.573426
2194	Edo	Etsako West	Auchi  III	7.100535	6.229437
2195	Kano	Bebeji	Kofa	11.560935	8.240585
2196	Ebonyi	Ezza North	Ekka	6.174778	7.938788
2197	Kebbi	Zuru	Manga/Ushe	11.385938	5.224006
2198	Zamfara	Talata-Mafara	Ruwan Gizo	12.226642	6.029482
2199	Lagos	Lagos Island	Agarawu/Obadina	6.455981	3.389560
2200	Osun	Ede North	Olusokun	7.715954	4.524136
2201	Kano	Albasu	Chamarana	11.651930	9.091372
2202	Abia	Bende	Igbere 'B'	5.701404	7.666644
2203	Jigawa	Maigatari	Matoya	12.726436	9.458899
2204	Enugu	Aninri	Oduma IV	6.052344	7.622135
2205	Rivers	Ogba/Egbema/Andoni	Omoku  Town II	5.353995	6.673534
2206	Edo	Etsako East	Okpella IV	7.216847	6.367751
2207	Katsina	Kusada	Yashe 'A	12.371695	7.946903
2208	Kano	Dala	Dogon Nama	11.983914	8.441984
2209	Ondo	Ifedore	Igbaka-oke I	7.420356	5.048918
2210	Ebonyi	Onicha	Isinkwo-Ukawu	5.997321	7.944104
2211	Anambra	Orumba North	Awgbu  I	6.109290	7.085691
2212	Kebbi	Zuru	Tadurga	11.600217	5.396288
2213	Bauchi	Warji	Tudun Wada West	11.195388	9.692864
2214	Oyo	Olorunsogo	Onigbeti II/Sagbon Agoro (Sagbon)	8.751063	4.133633
2215	Edo	Etsako East	Weppa	7.023190	6.596871
2216	Borno	Jere	Alau	11.718891	13.325997
2217	Kano	Garum Mallam	Fankurun	11.642385	8.328302
2218	Oyo	Oyo West	Owode	7.819230	3.915417
2219	Ogun	Ijebu North	Omen	6.968307	3.994258
2220	Akwa Ibom	Ibeno	Ibeno VIII	4.538900	7.878905
2221	Bauchi	Katagum	Madangala	11.679015	10.197448
2222	Kano	Shanono	Alajawa	12.098848	7.955963
2223	Yobe	Damaturu	Bindigari/Fawari	11.781973	11.949240
2224	Anambra	Idemili North	Umuoji	6.091712	6.891591
2225	Rivers	Obio/Akpor	Rumuolumeni	4.806314	6.933780
2226	Ebonyi	Ivo	Okue	5.894794	7.617277
2227	Delta	IkaNorth	Owa  VI	6.196594	6.183091
2228	Ekiti	Ekiti East	Omuo-Oke I	7.739189	5.785563
2229	Ondo	Okitipupa	Ilutitun III	6.557856	4.614189
2230	Kano	Shanono	Tsaure	12.040314	7.881257
2231	Zamfara	Tsafe	Dauki	11.934054	7.189198
2232	Jigawa	Buji	Y/Tukur	11.545679	9.793098
4486	Enugu	Awgu	Awgu I	6.074206	7.485765
2233	Benue	Ogbadibo	Itabono I	6.852994	7.674445
2234	Ebonyi	Izzi	Igbeagu  III	6.401042	8.376778
2235	Taraba	Wukari	Kente	7.956622	9.508495
2236	Benue	Makurdi	Modern Market	7.728032	8.440173
2237	Adamawa	Gombi	Ga'anda	10.173490	12.508815
2238	Edo	Oredo	Uzebu	6.281841	5.534018
2239	Kaduna	Igabi	Kerawa	10.953141	7.493044
2240	Oyo	Ogbomosho South	Ilogbo	8.090503	4.238827
2241	Ogun	Abeokuta North	Ita-Oshin/Olomore	7.141025	3.277247
2242	Akwa Ibom	Eket	Central IV	4.654241	7.995508
2243	Anambra	Awka South	Agu Oka	6.233233	7.077089
2244	Delta	IkaSouth	Ihuozomor (Ozanogogo Alisimie)	6.311148	6.109634
2245	Benue	Obi	Ikwokwu	6.959309	8.246921
2246	Kebbi	Shanga	Dugu Tsoho/Dugu Raha	11.178227	4.672055
2247	Kano	Madobi	Kanwa	11.855607	8.431089
2248	Anambra	Onitsha North	Water-side Central  I	6.109380	6.757279
2249	Bauchi	Dass	Baraza	9.949034	9.429319
2250	Ogun	Ikenne	Iperu III	6.994043	3.640147
2251	Oyo	Atiba	Bashorun	7.887028	3.953459
2252	Ogun	Odeda	Balogun Itesi	7.300172	3.571773
2253	Kano	Rogo	Fulatan	11.420459	7.886073
2254	Rivers	Ahoada West	Igbuduya I	5.023905	6.520052
2255	Edo	Oredo	Unueru/Ogboka	6.276386	5.582224
2256	Niger	Agwara	Kokoli	10.591081	4.536156
2257	Osun	Ifelodun	Iba  II	7.949107	4.713788
2258	Borno	Bama	Buduwa / Bula Chirabe	11.296875	14.163994
2259	Borno	Bayo	Jara Dali	10.277562	11.793595
2260	Akwa Ibom	Abak	Abak Urban I	4.976360	7.803775
2261	Abia	Osisioma	Amaitolu Mbutu Umuojima	5.103312	7.304258
2262	Delta	Ughelli South	Olomu II	5.408944	5.913537
2263	Katsina	Funtua	Unguwar Musa	11.527817	7.301846
2264	Kaduna	Kaduna North	Kawo	10.618595	7.455915
2265	Kebbi	Maiyama	Kawara/S/Sara/Yarkamba	11.970142	4.257514
2266	Bauchi	Damban	Dambam	11.688073	10.721791
2267	Osun	Ife South	Oke Owena	7.140239	4.524256
2268	Imo	Isiala Mbano	Umuozu	5.704369	7.262425
2269	Akwa Ibom	Oruk Anam	Abak Midim III	4.671370	7.596226
2270	Imo	Ahiazu-Mbaise	Otulu/Aguneze	5.536079	7.298686
2271	Borno	Konduga	Dawa East / Malari / Kangamari	11.621660	13.365490
2272	Gombe	Dukku	Gombe Abba	10.817858	10.639097
2273	Oyo	Ogbomosho North	Isale Alaasa	8.094438	4.291478
2274	Osun	Ila	Isedo  I	7.997957	4.914481
2275	Enugu	Oji-River	Achiagu II	6.167404	7.315181
2276	Adamawa	Hong	Bangshika	10.301400	12.982394
2277	Kaduna	Giwa	Danmahawayi	11.290542	7.581327
2278	Kogi	Lokoja	Kupa South West	8.466171	6.330450
2279	Osun	Ayedire	Oke-Osun	7.525064	4.251584
2280	Kano	Kumbotso	Unguwar Rimi	11.879179	8.565234
2281	Borno	Askira/Uba	Dille / Huyum	10.744797	13.198811
2282	Rivers	Obio/Akpor	Choba	4.865951	6.922853
2283	Benue	Ogbadibo	Ai-Oono III	7.090955	7.688746
2284	Nassarawa	Obi	Kyakale	8.316518	8.518605
2285	Enugu	Igbo-eze South	Ovoko (Ajuona Ward)	6.871799	7.435909
2286	Benue	Oju	Oboru/Oye	6.805341	8.563215
2287	Nassarawa	Karu	Panda / Kare	9.269247	7.811778
2288	Kogi	Mopa-Muro	Orokere	8.137744	5.840146
2289	Borno	Gwoza	Kurana Bassa/Ngoshe - Sama'a	11.016978	13.719444
2290	Imo	Unuimo	Okwelle I	5.792991	7.256904
2291	Kano	Gezawa	Wangara	12.034036	8.791590
2292	Jigawa	Guri	Matara Baba	12.754204	10.390849
2293	Borno	Ngala	Wurge	12.343716	14.173663
2294	Adamawa	Mubi South	Duvu/ Chaba/ Girburum	10.144373	13.409099
2295	Borno	Kaga	Mainok	11.853110	12.619070
2296	Oyo	Olorunsogo	Aboke (Aboyun Ogun)	8.685539	4.167446
2297	Borno	Gwoza	Bita / Izge	11.237203	13.503029
2298	Ogun	Egbado North	Ebute Igbooro	6.915144	2.807686
2299	Delta	Warri North	Ogheye	5.840207	5.051984
2300	Zamfara	Zurmi	Mashem	13.076313	6.727784
2301	Kebbi	Dandi	Kyangakwai	11.924736	3.761727
2302	Kano	Minjibir	Gandurwawa	12.130051	8.610286
2303	Plateau	Shendam	Kurungbau (B)	8.607887	9.634010
2304	Plateau	Mikang	Koenoem 'B'	9.050229	9.451873
2305	Nassarawa	Keana	Oki	8.187181	8.804360
2306	Ekiti	Ekiti West	Ikogosi	7.541111	5.008305
2307	Plateau	Jos East	Fursum	9.761504	9.015611
2308	Akwa Ibom	Obot Akara	Nto Edino IV	5.294593	7.602826
2309	Anambra	Awka South	Nibo  III	6.182633	7.084719
2310	Plateau	Langtang South	Gamakai	8.621024	9.828819
2311	Kwara	Asa	Ogbondoroko/Reke	8.342918	4.633335
2312	Oyo	Ona-Ara	Odi Odeyale/Odi Aperin	7.319750	3.991401
2313	Kwara	Ilorin West	Badari	8.476003	4.535946
2314	Borno	Damboa	Mulgwai / Kopchi	11.098375	13.235812
2315	Edo	Igueben	Ewossa	6.458934	6.245723
2316	Borno	Abadam	Mallamfatori Kessa	13.679241	13.346485
2317	Osun	Ila	Ejigbo  III	8.001163	4.865958
2318	Ebonyi	Abakalik	Abakpa	6.308384	8.113370
2319	Osun	Egbedore	Ido-Osun	7.759111	4.473898
2320	Sokoto	Isa	Tsabren Sarkin Darai	13.253010	6.249400
2321	Katsina	Dandume	Tumburkai B	11.327340	7.276217
2322	Oyo	Iwajowa	Agbaakin I	7.978213	3.253272
2323	Imo	Ehime-Mbano	Umuezeala	5.607922	7.284167
2324	Akwa Ibom	Ikot Ekpene	Ikot Ekpene VI	5.160371	7.689133
2325	Ekiti	Ikere	Ogbonjana	7.499355	5.215083
2326	Sokoto	Binji	Birniruwa	13.137344	4.846744
2327	Oyo	Ido	Akinware/Akindele	7.587197	3.763894
2328	Katsina	Faskari	Sabonlayi/Galadima	11.643245	6.952510
2329	Ebonyi	Ohaozara	Okposi Okwu	6.017852	7.800782
2330	Gombe	Gombe	Bolari West	10.305426	11.238470
2331	Benue	Makurdi	Agan	7.798335	8.598258
2332	Edo	Esan North East	Efandion	6.695274	6.340930
2333	Taraba	Donga	Gindin Dutse	7.484363	10.260523
2335	Bauchi	Ningi	Nasaru	11.229421	9.564746
2336	Katsina	Malumfashi	Gorar Dansaka	11.894393	7.761947
2337	Anambra	Awka North	Ebenebe  I	6.307338	7.106593
2338	Kogi	Ajaokuta	Abodi/Patesi	7.550889	6.485801
2339	Yobe	Fune	Dogon Kuka/Gishiwari/Gununu	11.637440	11.450018
2340	Nassarawa	Lafia	Akurba/Bakin Rijiya	8.551553	8.559974
2341	Anambra	Onitsha South	Fegge III	6.061276	6.743844
2342	Imo	Isiala Mbano	Amaraku	5.655063	7.111677
2343	Nassarawa	Keana	Madaki	8.168638	8.659979
2344	Enugu	Enugu East	Amorji	6.514711	7.528622
2345	Jigawa	Kiyawa	Faki	11.715925	9.568054
2346	Borno	Mobbar	Zanna Umorti	12.888975	12.638073
2347	Gombe	Kaltungo	Tungo	9.924760	11.377508
2348	Imo	Orsu	Okwuamaraihie II	5.833287	6.947756
2349	Enugu	Igbo-eze North	Umuitodo I	6.959470	7.474379
2350	Kebbi	Bunza	Bunza Marafa	12.022275	3.981878
2351	Ondo	AkokoNorthWest	Ese/Afin	7.639729	5.706317
2352	Osun	Oriade	Ipetu-Ijesa  II	7.488740	4.891751
2353	Osun	Boripe	Oke Esa/Oke Ogi	7.916266	4.718599
2354	Kogi	Idah	Ogegele	7.052408	6.688527
2355	Enugu	EnuguSou	Akwuke	6.399899	7.466265
2356	Imo	Njaba	Atta I	5.749874	7.000087
2357	Ebonyi	Ezza South	Ameka	6.143711	8.110283
2358	Imo	Ihitte-Uboma Isinweke	Umuihi	5.593957	7.343170
2359	Taraba	Kurmi	Bissaula	7.086789	10.350077
2360	Anambra	Anaocha	Adazi Ani I	6.074340	6.964658
2361	Anambra	Onitsha South	Fegge V	6.067793	6.741143
2362	Kano	Rimin Gado	Jili	11.905453	8.278532
2363	Kano	Ajingi	Gafasa	11.973081	9.127197
2364	Ogun	Abeokuta North	Totoro/Sokori	7.100049	3.252680
2365	Niger	Mariga	Bangi	10.746767	5.786090
2366	Nassarawa	Keana	Iwagu	8.177446	8.750367
2367	Adamawa	Girie	Dakri	9.328268	12.565763
2368	Rivers	Gokana	Nweol/Gioko/Barako	4.658854	7.318883
2369	Kebbi	Fakai	Penin Amana/Penin Gaba	11.343611	4.994360
2370	Oyo	Egbeda	Erunmu	7.437017	4.066015
2371	Adamawa	Mayo-Belwa	Nassarawo Jereng	8.839323	11.994126
2372	Kogi	Yagba East	Ife Olukotun II	7.860708	5.670067
2373	Plateau	Jos South	Gyel 'B'	9.790123	8.777158
2374	Kano	Tarauni	Gyadi-Gyadi Kudu	11.963650	8.513845
2375	Ogun	Ipokia	Agosasa	6.603270	2.774136
2376	Nassarawa	Obi	Tudun Adabu	8.343642	8.717203
2377	Abia	Ikwuano	Ibere I	5.425177	7.598606
2378	Sokoto	Wamakko	G/Hamidu/G/Kaya	13.132266	5.155830
2379	Bauchi	Gamjuwa	Kubi East	10.504024	10.001413
2380	Jigawa	Dutse	Duru	11.895809	9.267880
2381	Kano	Dawakin Kudu	Jido	11.890003	8.629534
2382	Delta	Oshimili North	Okpanam	6.289697	6.686946
2383	Niger	Mashegu	Kasanga	10.014910	5.868574
2384	Kano	Dawakin Kudu	Yanbarau	11.822544	8.589435
2385	Kaduna	Kagarko	Kurmin Jibrin	9.470947	7.918861
2386	Imo	Oru-East	Omuma	5.712956	6.963850
2387	Borno	Jere	Bale Galtimari	11.757224	13.257407
2388	Cross River	Akpabuyo	Idundu/Anyanganse	5.027869	8.381005
2389	Kaduna	Zangon Kataf	Unguwar Rimi	9.569548	8.204495
2390	Cross River	Abi	Adadama	5.922301	8.080274
2391	Akwa Ibom	Mbo	Ibaka	4.641309	8.303010
2392	Imo	Ahiazu-Mbaise	Umunumo/Umuchieze	5.577231	7.289141
2393	Zamfara	Kaura-Namoda	S/Baura/S/Mafara	12.597996	6.606220
2394	Osun	Ayedaade	Anlugbua	7.170722	4.226289
2395	Ogun	Ijebu North-East	Oju Ona	6.926255	4.057951
2396	Benue	Oturkpo	Ugboju-Ehaje	7.374662	8.075544
2397	Kebbi	Argungu	Kokani South	12.744008	4.533748
2398	Kogi	Ijumu	Ogidi	7.771085	5.959461
2399	Borno	Shani	Kwaba	10.197614	12.046693
2400	Oyo	Oluyole	Idi-Osan/Egbeda-Atuba	7.272469	3.983267
2401	Benue	Okpokwu	Amejo	7.135578	7.812881
2402	Ebonyi	Ishielu	Ezillo II	6.423378	7.813317
2403	Yobe	Tarmuwa	Lantaiwa	12.322718	11.670836
2404	Borno	Askira/Uba	Mussa	10.683246	13.088934
2405	Osun	Odo Otin	Olunisa	7.956913	4.656271
2406	Benue	Ukum	Mbayenge	7.679583	9.697417
2407	Borno	Dikwa	Sogoma / Afuye	11.857397	13.983165
2408	Akwa Ibom	Eket	Urban I	4.650622	7.893596
2409	Akwa Ibom	Ikot Ekpene	Ikot Ekpene III	5.199917	7.719785
2410	Kogi	Okene	Bariki	7.517771	6.203165
2411	Anambra	Orumba North	Oko I	6.004018	7.106009
2412	Akwa Ibom	Ika	Achan  II	5.053141	7.534189
2413	Osun	Boluwaduro	Oke-Otan	7.970542	4.812974
2414	Taraba	Karim-Lamido	Jen Ardido	9.384088	11.484746
2415	Borno	Biu	Zarawuyaku	10.689615	12.251746
2416	Borno	Mafa	Gawa	11.878886	13.860086
2417	Cross River	Calabar Municipality	Two	4.939373	8.328798
2418	Ekiti	Ikole	Ipao/Oke Ako/Irele	8.041724	5.467755
2419	Benue	Ado	Akoge/Ogbilolo	6.606127	7.908841
2420	Ondo	Idanre	Ofosu/Onisere	6.871416	5.106609
2421	Edo	Esan Centtral	Ikekato	6.761481	6.263345
2422	Adamawa	Girie	Damare	9.287294	12.585169
2423	Kogi	Olamaboro	Ogugu III	7.156466	7.446471
2424	Nassarawa	Keffi	Angwan Iya II	8.839167	7.861309
2425	Akwa Ibom	Uruan	Southern Uruan II	4.956918	8.078659
2426	Imo	Nwangele	Abba Ward	5.673474	7.114036
2427	Akwa Ibom	Oruk Anam	Abak Midim II	4.696629	7.607936
2428	Ogun	Shagamu	Isokun/Oyebajo	6.715054	3.624950
2429	Kebbi	Sakaba	Maza/Maza	11.325045	5.438809
2430	Lagos	Apapa	Olodan st Olojowou st/Alhdogo Olatokunbo st Iganmu	6.476868	3.351007
2431	Kogi	Dekina	Ojikpadala	7.391451	7.218942
2432	Imo	Orlu	Orlu/Mgbee/Orlu Govt. Station	5.772574	7.114964
2433	Bauchi	Darazo	Konkiyal	11.118521	10.485883
2434	Osun	Ifedayo	Co-Operative	8.005038	5.031007
2435	Lagos	Ojo	Ajangbadi	6.474754	3.175400
2436	Kano	Madobi	Galinja	11.858032	8.499642
2437	Enugu	EnuguSou	Awkunanaw East	6.404559	7.495278
2438	Bauchi	Kirfi	Kirfi	10.298995	10.543343
2439	Plateau	Kanke	Garram	9.253297	9.477132
2440	Imo	Ehime-Mbano	Agbaja	5.687669	7.300566
2441	Ebonyi	Abakalik	Ndiagu	6.308555	8.124395
2442	Ebonyi	Afikpo North	Uwana Afikpo I	5.794645	7.894037
2443	Yobe	Tarmuwa	Mafa	12.309438	12.200139
2444	Lagos	Shomolu	Bajulaiye	6.547121	3.375713
2445	Benue	Tarka	Mbaigba	7.480262	8.861654
2446	Katsina	Musawa	Jikamshi	12.189292	7.759405
2447	Bauchi	Bauchi	Makama/Sarki Baki	10.289314	9.830164
2448	Taraba	Yorro	Pupule I	9.045532	11.595940
2449	Rivers	Akukutor	Jack II	4.712698	6.750075
2450	Bayelsa	Sagbama	Asamabiri	5.350754	6.522151
2451	Adamawa	Song	Waltandi	9.764409	12.349008
2452	Ebonyi	Ikwo	Igbudu II	6.025330	8.177560
2453	Kebbi	Gwandu	Masama Kwasgara	12.531102	4.707073
2454	Lagos	Agege	Isale Odo	6.644241	3.292959
2455	Imo	Owerri West	Irete/Orogwe	5.525025	6.984280
2456	Benue	Logo	Mbater	7.571527	9.389813
2457	Ogun	Ijebu North-East	Imewiro/Ododeyo/Imomo	6.864365	4.039322
2458	Kano	Dambatta	Kore	12.373757	8.726333
2459	Enugu	Udi	Awhum/Ukana	6.516391	7.416799
2460	Ekiti	Oye	Ire II	7.764012	5.387067
2461	Osun	Oriade	Iwoye	7.697410	4.842773
2462	Anambra	Ihiala	Lilu	5.878612	6.933887
2463	Kano	Bagwai	Sare-Sare	12.115341	8.018947
2464	Osun	Ife East	Okerewe  III	7.354433	4.607850
2465	Kebbi	Argungu	Alwasa/Gotomo	12.570088	4.432747
2466	Kaduna	Jaba	Sabzuro	9.459739	7.971760
2467	Anambra	Njikoka	Enugwu-agidi  II	6.224889	6.985742
2468	Ogun	Obafemi-Owode	Ofada	6.711643	3.396356
2469	Kano	Bagwai	Gadanya	12.080448	8.055263
2470	Niger	Rijau	Dugge	11.082453	5.076157
2471	Kano	Fagge	Fagge D	11.981409	8.567573
2472	Kano	Kano Municipal	Dan'agundi	11.932835	8.486029
2473	Bayelsa	Sagbama	Ossiama	4.876159	6.026799
2474	Kogi	Ankpa	Ojoku IV	7.400179	7.813241
2475	Abia	Arochukwu	Isu	5.380275	7.940282
2476	Borno	Biu	Mandara Girau	10.706918	12.427461
2477	Bauchi	Gamjuwa	Nasarawa  South	10.934641	10.228829
2478	Rivers	Khana	Boue	4.614190	7.361543
2479	Oyo	Atiba	Aremo	7.889118	3.942721
2480	Kaduna	Kauru	Kauru West	10.560943	8.129181
2481	Plateau	Jos East	Mai Gemu	9.975086	9.159041
2482	Ebonyi	Ikwo	Igbudu I	6.056206	8.138595
2483	Zamfara	Shinkafi	Kware	12.999056	6.611388
2484	Borno	Magumeri	Gaji Ganna I	12.312098	12.961717
2485	Enugu	Isi-Uzo	Umualor	6.648325	7.656650
2486	Oyo	Atisbo	Owo/Agunrege/Sabe	8.405737	3.393584
2487	Bauchi	Bauchi	Majidadi 'A'	10.312857	9.860689
2488	Kano	Kabo	Kanwa	11.826125	8.148378
2489	Sokoto	Illela	G/ Katta	13.635526	5.310670
2490	Kano	Ajingi	Dundun	11.904101	9.004243
2491	Kwara	Isin	Sabaja/Pamo	8.306433	5.142947
2492	Katsina	Mai'Adua	Danyashe	13.092677	8.171409
2493	Jigawa	Birnin Kudu	Unguwar"Ya	11.381848	9.275105
2494	Kogi	Adavi	Kuroko I	7.772751	6.560298
2495	Imo	Ideato North	Ozuakoki/Umuago	5.822190	7.090862
2496	Sokoto	Illela	Garu	13.630199	5.365232
2497	Rivers	Opobo/Nkoro	Nkoro II	4.561251	7.481060
2498	Kano	Kano Municipal	Zango	11.946490	8.500294
2499	Kebbi	Zuru	Zodi	11.484759	5.367302
2500	Yobe	Machina	Falimaram	13.044714	9.921067
2501	Yobe	Damaturu	Damaturu Central	11.678330	11.964187
2502	Oyo	Irepo	Iba V	9.143042	3.840065
2503	Benue	Logo	Mbadyul	7.540366	9.388648
2504	Katsina	Matazu	Mazoji 'B'	12.279156	7.561370
2505	Kaduna	Kaduna North	Unguwan Dosa	10.585490	7.464896
2506	Delta	IkaNorth	Akumazi	6.260471	6.340493
2507	Ekiti	Ikole	Ikole East	7.815008	5.464107
2508	Cross River	Ogoja	Ekajuk I	6.411889	8.561429
2509	Kogi	Ijumu	Ibgolayere/Ilaere	7.727705	5.949831
2510	Yobe	Yunusari	Dekwa	13.018771	12.171536
2511	Akwa Ibom	Urue Offong|Oruko	Oruko IV	4.724833	8.160828
2512	Enugu	Udenu	Udunedem	6.893268	7.492159
2513	Anambra	Oyi	Ogbunike  II	6.149874	6.858956
2514	Niger	Gurara	Kabo	9.400549	7.187305
2515	Sokoto	Shagari	Shagari	12.571672	5.033760
2516	Oyo	Ibadan North	Ward III, N4	7.398893	3.904897
2517	Rivers	Gokana	Yeghe II	4.675081	7.332749
2518	Benue	Ohimini	Onyagede Icho (Ogoli)	7.305516	7.877662
2519	Kwara	Ilorin West	Magaji Ngeri	8.492461	4.561217
2520	Kogi	Yagba West	Odo Ara Omi Ogga	8.091511	5.576831
2521	Kogi	Okehi	Eika/Ohizenyi	7.785243	6.465493
2522	Delta	Warri North	Koko I	5.952241	5.365367
2523	Osun	Ifedayo	Oyi	7.905913	4.954565
2524	Niger	Borgu	Malale	10.145725	4.339614
2525	Bayelsa	Ekeremor	Eduwini I	5.104393	5.428898
2526	Anambra	Onitsha North	Inland Town II	6.107044	6.782981
2527	Borno	Kukawa	Doro / Duguri	13.095687	13.563024
2528	Katsina	Charanchi	Banye	12.669712	7.584669
2529	Lagos	Kosofe	Isheri-Olowo-Ira/Shangisha/Magodo Phase I & II	6.635545	3.381394
2530	Edo	Egor	Otubu	6.324342	5.527761
2531	Ebonyi	Ezza South	Amuzu	6.184943	8.014116
2532	Niger	Lapai	Gupa/Abugi	8.391274	6.734974
2533	Yobe	Bade	Sarkin Hausawa	12.825782	11.020089
2534	Bauchi	Shira	Sambuwal	11.510600	10.013079
2535	Enugu	Igbo-Eti	Ohaodo II	6.750488	7.433472
2536	Ondo	IleOluji/Okeigbo	Oke-igbo III	7.216730	4.895038
2537	Delta	Okpe	Mereje  III	5.732769	5.758704
2538	Sokoto	Kebbe	Kebbe West	12.115300	4.835878
2539	Oyo	Atisbo	Irawo Ile	8.491974	3.384012
2540	Niger	Muya	Guni	9.806032	6.911365
2541	Bauchi	Shira	Andubun	11.477792	9.972444
2542	Katsina	Safana	Tsaskiya	12.498165	7.372525
2543	Kano	Kumbotso	Guringawa	11.914603	8.486801
2544	Oyo	Irepo	Iba I	9.003200	3.782335
2545	Kano	Madobi	Madobi	11.767875	8.280329
2546	Ekiti	Moba	Igogo I	7.958691	5.112162
2547	Akwa Ibom	Onna	Awa II	4.688909	7.821444
2548	Kebbi	Sakaba	Sakaba	11.030173	5.626788
2549	Akwa Ibom	Etim Ekpo	Etim Ekpo VII	4.948305	7.560780
2550	Anambra	Ayamelum	Anaku	6.448915	6.888321
2551	Anambra	Ekwusigo	Ichi	6.039690	6.859619
2552	Kwara	Moro	Ejidongari	8.985956	4.585639
2553	Kwara	Moro	Logun/Jehunkunnu	8.923177	4.387536
2554	Kaduna	Zaria	Dutsen Abba	10.990679	7.668799
2555	Gombe	Dukku	Malala	11.026142	10.749563
2556	Delta	AniochaN	Onicha Ugbo	6.295104	6.426614
2557	Borno	Nganzai	Damaram	12.552323	13.199505
2558	Benue	Logo	Turan	7.673761	9.225765
2559	Cross River	Abi	Itigidi	5.896372	8.005574
2560	Kwara	Ifelodun	Igbaja II	8.451699	4.887339
2561	Niger	Edati	Gbangban	9.098068	5.709052
2562	Lagos	Ikorodu	Erikorodu	6.651879	3.548110
2563	Nassarawa	Kokona	Koya  / Kana	8.634579	7.971905
2564	Katsina	Kankara	Burdugau	11.804469	7.491048
2565	Enugu	Awgu	Owelli/Amoli/Ugbo/Ogugu	6.188202	7.425759
2566	Ekiti	Irepodun-Ifelodun	Igbemo	7.687615	5.388850
2567	Edo	Igueben	Udo	6.606439	6.305830
2568	Kano	Rano	Yalwa	11.381020	8.504482
2569	Gombe	Balanga	Bangu	9.940926	11.834610
2570	Kebbi	Zuru	Ciroman Dabai	11.493287	5.281144
2571	Kogi	Kabba-Bunu	Odo-Akete	7.826313	6.081869
2572	Taraba	Karim-Lamido	Bikwin	9.477827	11.217309
2573	Nassarawa	Nasarawa	Nasarawa North	8.542910	7.833877
2574	Ekiti	Ado-Ekiti	Ado 'C' Idolofin	7.548797	5.351863
2575	Niger	Wushishi	Kodo	9.589148	6.136246
2576	Kano	Shanono	Dutsen-Bakoshi	11.982033	7.949042
2577	Yobe	Nangere	Langawa / Darin	11.574021	11.014388
2578	Nassarawa	Nassarawa Egon	Aloce/Ginda	8.850745	8.304223
2579	Kogi	Lokoja	Lokoja-A	7.789205	6.725259
2580	Osun	Ifelodun	Olonde Ikirun	7.916521	4.688598
2581	Anambra	Nnewi South	Osumenyi  I	5.943627	6.943590
2582	Niger	Rijau	T/Magajiya	11.230195	5.262546
2583	Bauchi	Kirfi	Dewu East	10.607407	10.575835
2584	Akwa Ibom	Nsit Ibom	Asang IV	4.908994	7.854558
2585	Niger	Magama	Ibelu West	10.620898	4.988978
2586	Jigawa	Gwiwa	Darina	12.761536	8.290816
2587	Adamawa	Hong	Hildi	10.403360	13.159797
2588	Osun	IfeCentral	Akarabata	7.419803	4.585929
2589	Borno	Mobbar	Duji	13.092089	12.550566
2590	Cross River	Yala	Okpoma	6.610648	8.449822
2591	Katsina	Danja	Kahutu B	11.338223	7.719170
2592	Delta	Ukwuani	Obiaruku  II	5.839280	6.164205
2593	Ekiti	Irepodun-Ifelodun	Igede II	7.675324	5.162436
2594	Katsina	Mani	Duwan/Makau	12.767027	8.019369
2595	Kebbi	Argungu	Gulma	12.676787	4.323664
2596	Borno	Kala/Balge	Jarawa/Sangaya	11.909523	14.417843
2597	Bayelsa	Ogbia	Imiringi	4.847377	6.309554
2598	Akwa Ibom	Ika	Odoro I	4.958908	7.510496
2599	Jigawa	Gwiwa	F/Yamma	12.768026	8.368908
2600	Taraba	Takum	Manya	7.449244	10.235269
2601	Ekiti	Ekiti East	Obadore II	7.675607	5.642138
2602	Edo	Etsako West	Auchi I	7.052735	6.215455
2603	Abia	Umuahia North	Umuahia Urban II	5.542326	7.495893
2604	Imo	Owerri West	Obinze	5.403706	6.995618
2605	Zamfara	Bungudu	Sankalawa	12.170767	6.774838
2606	Plateau	Bokkos	Damwai	9.057372	8.834077
2607	Katsina	Dandume	Mahuta B	11.451497	7.230465
2608	Cross River	Etung	Agbokim	5.905453	8.868297
2609	Taraba	Kurmi	Ashuku/Eneme	7.140024	10.696381
2610	Kwara	Ilorin South	Okaka I	8.410110	4.683143
2611	Kano	Warawa	'Yan Dalla	11.881923	8.819211
2612	Benue	Buruku	Mbakyaan	7.320360	9.224432
2613	Sokoto	Bodinga	Tulluwa/Kulafasa	12.914686	5.185990
2614	Katsina	Katsina (K)	Wakilin Arewa (B)	13.021559	7.585686
2615	Kogi	Ogori Magongo	Oturu Opowuroye	7.462667	6.118684
2616	Benue	Agatu	Usha	7.970688	7.773064
2617	Kebbi	Shanga	Rafin Kirya/Tefki Tara	11.452472	4.652729
2618	Kwara	Ilorin West	Ajikobi	8.510740	4.549607
2619	Taraba	Lau	Lau I	9.164658	11.304550
2620	Jigawa	Ringim	Karshi	12.243492	8.959418
2621	Oyo	Afijio	Awe II	7.788222	4.030835
2622	Bauchi	Damban	Gurbana	11.656196	10.779820
2623	Plateau	Barkin Ladi	Gassa/Sho	9.575554	8.881948
2624	Osun	Ola-Oluwa	Bode-Osi	7.761568	4.231201
2625	Kogi	Bassa	Ozugbe	7.957085	7.234828
2626	Rivers	Obio/Akpor	Rumueme (7B)	4.813388	6.981798
2627	Enugu	Awgu	Awgu II	6.039526	7.476543
2628	Edo	Esan North East	Arue	6.732426	6.297914
2629	Ogun	Abeokuta North	Olorunda Ijale	7.264361	3.093645
2630	Rivers	Omumma	Oyoro	5.147633	7.200004
2631	Rivers	Emuoha	Ogbakiri  II	4.782578	6.891373
2632	Nassarawa	Doma	Akpanaja	7.848679	8.297781
2633	Bayelsa	Brass	Minibie	4.483371	6.122958
2634	Bauchi	Dass	Dott	10.034775	9.521841
2635	Borno	Konduga	Nyaleri/Sandia/Yejiwa	11.340392	12.905668
2636	Kwara	Baruten	Gure/Gwasoro	9.561819	3.408949
2637	Kano	Warawa	Madari Mata	11.901847	8.709227
2638	Bayelsa	Sagbama	Adagbabiri	5.120189	6.177886
2639	Ogun	Remo North	Ode I	6.978790	3.683217
2640	Akwa Ibom	Mbo	Efiat II	4.622274	8.327005
2641	Borno	Kala/Balge	Rann  "A"	12.315869	14.462165
2642	Delta	Patani	Odorubu/Adobu/Bolou Apelebri	5.162596	6.019491
2643	Jigawa	Ringim	Ringim	12.145800	9.138060
2644	Rivers	Ahoada West	Ubie I	5.173002	6.524041
2645	Ebonyi	Abakalik	Edda	6.222248	8.234214
2646	Imo	Ikeduru	Amatta	5.531063	7.091286
2647	Delta	Warri South-West	Oporoza	5.486069	5.484719
2648	Kano	Minjibir	Minjibir	12.158821	8.656771
2649	Niger	Agwara	Kashini	10.690152	4.567448
2650	Imo	Ohaji-Egbema	Awara/Ikwerede	5.338547	6.768111
2651	Gombe	Shomgom	Gwandum	9.659650	11.100364
2652	Rivers	Asari-Toru	Buguma South East	4.688133	6.880911
2653	Bayelsa	Ekeremor	Oporomor III	5.047001	5.783198
2654	Kebbi	Ngaski	Utono/Hoge	10.624780	4.711691
2655	Osun	IfeCentral	Ilare III	7.435071	4.614600
2656	Lagos	Shomolu	Onipanu	6.546905	3.365964
2657	Ondo	Akure North	Ayetoro	7.384594	5.265740
2658	Enugu	Igbo-Eti	Ozalla I	6.729119	7.375645
2659	Edo	Oredo	Ihogbe/ Isekhere/ Oreoghene/ Ibiwe/ Ice Road	6.303753	5.560137
2660	Borno	Magumeri	Kalizoram / Banoram	11.989535	12.553963
2661	Rivers	Okrika	Okrika  III	4.704545	7.123365
2662	Sokoto	Illela	Illela	13.726289	5.305794
2663	Cross River	Obanliku	Becheve	6.397086	9.371974
2664	Lagos	Lagos Island	Onikan	6.451904	3.410476
2665	Enugu	Igbo-eze North	Umuozzi X	6.997828	7.493945
2666	Kaduna	Chikun	Sabon Tasha	10.439792	7.503029
2667	Abia	Bende	Amankalu/Akoliufu	5.727696	7.583204
2668	Delta	IsokoSou	Aviara	5.368003	6.290578
2669	Bauchi	Kirfi	Tubule	10.463765	10.671382
2670	Akwa Ibom	Oruk Anam	Ibesit/Nung Ikot I	4.755610	7.643084
2671	Nassarawa	Awe	Akiri	8.002620	9.144602
2672	Anambra	Ogbaru	Ogwu-Ikpele	5.711922	6.658183
2673	Adamawa	Girie	Girei  II	9.390567	12.669477
2674	Imo	Ohaji-Egbema	Ekwuato	5.322226	6.934539
2675	Rivers	Asari-Toru	Buguma North  West II	4.736484	6.860055
2676	Kwara	Kaiama	Adena	9.195593	4.502779
2677	Enugu	Awgu	Mgbowo	6.124085	7.510753
2678	Yobe	Nguru	Bulanguwa	13.006364	10.386919
2679	Kano	Makoda	Wailare	12.258329	8.502802
2680	Oyo	Ogbomosho North	Abogunde	8.102836	4.256357
2681	Enugu	Aninri	Oduma I	6.102243	7.582469
2682	Kwara	Ekiti	Isapa	8.134756	5.365966
2683	Edo	Egor	Ugbowo	6.392055	5.595398
2684	Kogi	Lokoja	Lokoja-B	7.968628	6.284655
2685	Enugu	Enugu North	G.R.A	6.465654	7.495987
2686	Niger	Mariga	Beri	10.412992	5.729200
2687	Borno	Guzamala	Gudumbali West	13.023949	12.977922
2688	Ogun	Odeda	Obete	7.325600	3.336104
2689	Rivers	Akukutor	Jack III	4.728732	6.713993
2690	Zamfara	Tsafe	Yan Waren Daji	12.023322	7.030321
2691	Imo	Owerri North	Agbala/Obube/Ulakwo	5.376807	7.066837
2692	Zamfara	Tsafe	Kwaren Ganuwa	11.930168	6.758878
2693	Nassarawa	Nasarawa	Nasarawa Main Town	8.545870	7.664482
2694	Taraba	Ibi	Ibi Nwonyo I	8.222293	9.732982
2695	Anambra	Onitsha South	Fegge VII	6.064490	6.763097
2696	Nassarawa	Karu	Kafin Shanu/Betti	8.731122	7.835812
2697	Osun	Ifelodun	Iba  I	7.952700	4.690844
2698	Adamawa	Madagali	Duhu/ Shuwa	10.787087	13.479310
2699	Osun	Atakumosa West	Osu II	7.617236	4.593612
2700	Kaduna	Ikara	Auchan	11.404179	8.053207
2701	Ondo	Ilaje	Mahin III	6.359776	4.742322
2702	Ekiti	Ijero	Ikoro Ward 'A'	7.807578	5.051241
2703	Katsina	Ingawa	Bidore/Yaya	12.467431	8.117700
2704	Akwa Ibom	Nsit Atai	Eastern Nsit VII	4.761484	8.029310
2705	Plateau	Langtang North	Nyer	8.857498	9.789900
2706	Ogun	Abeokuta South	Keesi/Emere	7.209367	3.361977
2707	Ogun	Ipokia	Ijofin/Idosa	6.538007	2.756601
2708	Niger	Magama	Auna Central	10.188374	4.706426
2709	Rivers	Oyigbo	Asa	4.835983	7.195326
2710	Niger	Bida	Nassarafu	9.074616	6.014681
2711	Kwara	Edu	Tsonga I	9.089348	5.072972
2712	Kano	Tofa	Gajida	12.073229	8.255178
2713	Adamawa	Mubi South	Gude	10.208411	13.379451
2714	Gombe	Shomgom	Lapan	9.719333	11.348638
2715	Bauchi	Bauchi	Majidadi 'B'	10.292239	9.854459
2716	Kaduna	Zangon Kataf	Kamuru Ikulu North	9.998644	8.133865
2717	Akwa Ibom	Esit Eket	Ikpa	4.661999	8.049379
2718	Sokoto	Sokoto South	S/Zamfara 'B'	13.015000	5.254081
2719	Ebonyi	Izzi	Mgbalaukwu Inyimagu I	6.447455	8.275349
2720	Ondo	Odigbo	Agbabu	6.671964	4.861546
2721	Kwara	Offa	Shawo South West	8.116804	4.652530
2722	Bayelsa	Kolokuma-Opokuma	Odi (South) III	5.139454	6.258377
2723	Oyo	Ibadan South East	C1	7.357307	3.905543
2724	Oyo	Ibadan South East	S 7A	7.332761	3.901334
2725	Sokoto	Isa	Gebe 'B'	13.229246	6.542873
2726	Edo	Etsako West	Jagbe	6.819339	6.274406
2727	Jigawa	Yankwashi	Gwarta	12.810901	8.513771
2728	Bayelsa	Southern Ijaw	Central Bomo I	4.681016	6.112431
2729	Rivers	Oyigbo	Obete	4.812631	7.466615
2730	Bauchi	Alkaleri	Maimadi	9.980553	10.676691
2731	Cross River	Calabar Municipality	Six	4.984948	8.327973
2732	Osun	Irewole	Ikire 'I'	7.393978	4.169032
2733	Kano	Ungogo	Kadawa	12.051922	8.470726
2734	Jigawa	Kaugama	Hadin	12.336448	9.807498
2735	Akwa Ibom	Ibeno	Ibeno II	4.546187	7.961818
2736	Oyo	Itesiwaju	Owode/Ipapo	8.254519	3.605156
2737	Osun	Ede North	Abogunde/Sagba	7.709197	4.448257
2738	Rivers	Tai	Ward VI (Gio/Kporghor/Gbam)	4.714657	7.226976
2739	Nassarawa	Awe	Makwangiji	8.070985	9.112593
2740	Kaduna	Kachia	Awon	9.677366	7.747473
2741	Benue	Guma	Mbawa	7.925455	8.585416
2742	Rivers	Bonny	Ward IX Nanabie	4.550614	7.258975
2743	Lagos	Badagary	Posukoh	6.415814	2.886276
2744	Nassarawa	Obi	Gidan Ausa II	8.305045	8.602992
2745	Katsina	Bindawa	Tama/Daye	12.598930	7.921819
2746	Kano	Bichi	Badume	12.179259	8.300481
2747	Imo	Isiala Mbano	Osu-Owerre II	5.659960	7.153757
2748	Osun	Olorunda	Ayetoro	7.827328	4.586269
2749	Kaduna	Ikara	Janfala	11.130774	8.285035
2750	Gombe	Balanga	Kulani / Degre /Sikkam	9.850937	11.824156
2751	Niger	Bosso	Chanchaga	9.551364	6.559016
2752	Nassarawa	Akwanga	Anchobaba	9.105402	8.291852
2753	Abia	Umuahia South	Ahiaukwu  II	5.466261	7.494275
2754	Kebbi	Danko Wasagu	Kanya	11.328564	5.682804
2755	Taraba	Wukari	Akwana	7.906916	9.269034
2756	Rivers	Akukutor	Georgewill I	4.715200	6.749314
2757	Imo	Aboh-Mbaise	Nguru-Ahiato	5.481642	7.206580
2758	Abia	Oboma Ngwa	Alaukwu Ohanze	5.132509	7.466652
2759	Delta	IkaNorth	Ute - Ogbeje	6.207898	6.349170
2760	Taraba	Yorro	Sumbu II	8.904425	11.474274
2761	Benue	Ogbadibo	Itabono II	6.879867	7.651583
2762	Osun	Ejigbo	Inisa I/Aato/Igbon	7.825790	4.343485
2763	Kano	Makoda	Durma	12.338306	8.449454
2764	Kwara	Ilorin East	Apado	8.668263	4.871240
2765	Nassarawa	Nassarawa Egon	Ubbe	8.869696	8.433580
2766	Akwa Ibom	Itu	East Itam V	5.156155	7.990174
2767	Rivers	Degema	Bukuma	4.595095	6.988148
2768	Osun	Ayedire	Kuta  I	7.627986	4.330683
2769	Ogun	Ijebu North	Mamu/Etiri	6.970371	3.805396
2770	Sokoto	Wurno	Achida	13.169686	5.420335
2771	Enugu	Enugu East	Trans-Ekulu	6.483256	7.488681
2772	Jigawa	Biriniwa	Kachallari	12.664012	9.859159
2773	Imo	Okigwe	Ezinachi	5.722895	7.365968
2774	Akwa Ibom	Essien Udim	Adiasim	5.073265	7.726564
2775	Oyo	Ibadan North West	Ward 10 NW7	7.405434	3.866020
2776	Osun	Boripe	Oja - Oba	7.876169	4.692367
2777	Oyo	Ibadan South West	Ward 4 SW3A & 3B	7.362763	3.894723
2778	Taraba	Sardauna	Warwar	6.597111	11.312274
2779	Lagos	Kosofe	Owode Onirin/Ajegunle/Odo-Ogun	6.628350	3.428181
2780	Kwara	Baruten	Okuta	9.079240	3.196468
2781	Ebonyi	Ohaukwu	Umu Ogudu Oshia	6.469106	7.934596
2782	Katsina	Dandume	Mahuta A	11.408401	7.263721
2783	Kwara	Irepodun	Ajase Ipo II	8.124968	4.824285
2784	Edo	Esan Centtral	Uneah	6.791219	6.303275
2785	Plateau	Jos South	Shen	9.765957	8.897038
2786	Oyo	Ido	Omi Adio/Omi Onigbagbo Bakatari	7.402944	3.743379
2787	Sokoto	Goronyo	Goronyo	13.384179	5.768393
2788	Adamawa	Song	Gudu Mboi	9.939713	12.444539
2789	Akwa Ibom	Uruan	Southern Uruan III	4.923655	8.098095
2790	Katsina	Kusada	Kaikai	12.488005	8.006483
2791	Akwa Ibom	Ikot Ekpene	Ikot Ekpene VII	5.209953	7.696197
2792	Nassarawa	Doma	Doka	8.250152	8.346147
2793	Abia	Bende	Ugwueke/Ezeukwu	5.796093	7.581136
2794	Katsina	Batagarawa	Barawa	12.898383	7.507011
2795	Kano	Dawakin Tofa	Ganduje	12.224688	8.468903
2796	Plateau	Mangu	Jannaret	9.520437	9.251744
2797	Zamfara	Anka	Matseri	12.115215	5.873346
2798	Osun	Obokun	Ilase/Idominasi	7.712953	4.674873
2799	Kaduna	Jema'a	Takau 'B'	9.493702	8.269694
2800	Cross River	Calabar South	Eight (8)	4.905094	8.238072
2801	Delta	Oshimili North	Akwukwu	6.312734	6.622727
2802	Ebonyi	Izzi	Igbeagu Nduogbu	6.352608	8.244114
2803	Zamfara	Kaura-Namoda	Kurya Madaro	12.489889	6.543998
2804	Akwa Ibom	Ika	Achan  III	5.022800	7.570478
2805	Katsina	Zango	Kawarin Malawamai	12.882056	8.590787
2806	Osun	Ilesha East	Ilerin	7.572869	4.785716
2807	Ebonyi	Izzi	Agbaja Offia Onwe	6.716274	8.198321
2808	Gombe	Balanga	Mwona	9.680694	11.622675
2809	Nassarawa	Kokona	Ninkoro	9.019394	8.026668
2810	Jigawa	Roni	Kwaita	12.578189	8.312153
2811	Kaduna	Igabi	Gwaraji	10.587866	7.804909
2812	Kebbi	Gwandu	Kambaza	12.385137	4.624382
2813	Kano	Kibiya	Kibiya I	11.519800	8.625748
2814	Delta	Ethiope West	Mosogar II	5.939456	5.774336
2815	Katsina	Batsari	Ruma	12.838880	7.173135
2816	Enugu	Nsukka	Owerre/Umuoyo	6.846474	7.399184
2817	Sokoto	Dange-Shuni	Wababe/Salau	12.774728	5.578151
2818	Kwara	Ifelodun	Oke-Ode III	8.537928	4.962213
2819	Ondo	Ifedore	Igbaka-oke II	7.418896	5.082878
2820	Niger	Shiroro	Manta	9.845310	6.355966
2821	Rivers	Gokana	Biara II	4.684491	7.295639
2822	Edo	Uhunmwonde	Isi South	6.452814	5.951450
2823	Osun	Oriade	Ira	7.511781	4.932594
2824	Imo	Ikeduru	Eziama	5.532239	7.192027
2825	Osun	Ifelodun	Owode Ikirun	7.892063	4.671682
2826	Kwara	Ekiti	Obbo-Aiyeggunle I	7.992770	5.309585
2827	Ekiti	Moba	Osun	7.938036	5.068621
2828	Adamawa	Teungo	Gumti	7.771631	11.923838
2829	Sokoto	Yabo	Yabo 'B'	12.710521	5.000092
2830	Enugu	Igbo-eze South	Iheakpu (Ezzi Ngwu Ward)	6.901639	7.401070
2831	Borno	Nganzai	Badu	12.729649	13.162098
2832	Kogi	Kabba-Bunu	Odo-Ape	7.930780	6.146834
2833	Osun	Olorunda	Agowande	7.789653	4.553208
2834	Anambra	Ogbaru	Ochuche-Umuodu/Ogbakuba/Amiyi	5.864642	6.728758
2835	Adamawa	Yola South	Adarawo	9.173916	12.649774
2836	Rivers	Akukutor	Manuel  I	4.721562	6.746252
2837	Zamfara	Birnin Magaji	Madomawa East	12.562768	6.739810
2838	Bauchi	Kirfi	Beni "A"	10.472442	10.399016
2839	Anambra	Orumba North	Ufuma  II	6.083047	7.203691
2840	Ekiti	Ikere	Oke-Osun	7.458112	5.249566
2841	Abia	Ukwa West	Ipu South	4.944045	7.295865
2842	Zamfara	Bungudu	Bingi South	11.899128	6.441772
2843	Kano	Takai	Durbunde	11.527935	9.210192
2844	Kano	Kunchi	Bumai	12.412012	8.161785
2845	Jigawa	Taura	Majiya	12.306121	9.467126
2846	Sokoto	Goronyo	Kagara	13.355517	5.638522
2847	Lagos	Shomolu	Alade	6.550823	3.371979
4487	Niger	Rafi	Yakila	9.937847	6.041777
2848	Jigawa	Birnin Kudu	Birnin Kudu	11.448758	9.485372
2849	Akwa Ibom	Obot Akara	Obot Akara I	5.260645	7.666362
2850	Jigawa	Birnin Kudu	Surko	11.326505	9.481041
2851	Kano	Kumbotso	Challawa	11.902816	8.406871
2852	Kogi	Ankpa	Ankpa Suburb II	7.309919	7.494368
2853	Gombe	Balanga	Nyuwar / Jessu	9.774075	11.809709
2854	Rivers	Ahoada West	Ediro I	5.090802	6.453639
2855	Gombe	Balanga	Talasse / Dong / Reme	9.944180	11.695351
2856	Osun	Ede South	Loogun	7.620836	4.400179
2857	Kwara	Ifelodun	Igbaja III	8.473807	4.762913
2858	Kebbi	Dandi	Kamba / Kamba	11.898775	3.651716
2859	Oyo	Akinyele	Iroko	7.646859	3.897788
2860	Anambra	Aguata	Isuofia	6.013859	7.045080
2861	Kano	Takai	Takai	11.556412	9.111899
2862	Anambra	Aguata	Umuchu I	5.937336	7.123941
2863	Jigawa	Biriniwa	Matamu	12.799110	10.259563
2864	Benue	Ukum	Tsaav	7.794747	9.433772
2865	Kwara	Ilorin East	Marafa/Pepele	8.634581	4.934072
2866	Kano	Tofa	Kwami	12.008853	8.285444
2867	Niger	Wushishi	Barwa	9.714153	6.039710
2868	Niger	Gurara	Lambata	9.283134	7.012464
2869	Jigawa	Jahun	Jabarna	11.995702	9.538794
2870	Kogi	Okene	Okene-Eba/Agassa/Ahache	7.489146	6.190834
2871	Benue	Ado	Ekile	6.797241	8.117262
2872	Bauchi	Zaki	Tashena / Gadai	12.285153	10.293485
2873	Kebbi	Fakai	Inga(Bulu) Maikende	11.627435	4.855915
2874	Taraba	Karim-Lamido	Kwanchi	9.322486	11.099964
2875	Kano	Tofa	Yarimawa	12.012139	8.342654
2876	Bauchi	Alkaleri	Futuk	9.855733	10.884362
2877	Anambra	Idemili South	Alor  I	6.081569	6.932480
2878	Delta	Warri North	Ogbinbiri (Egbema III)	5.780598	5.120714
2880	Benue	Logo	Mbavuur	7.716543	9.338643
2881	Adamawa	Numan	Kodomti	9.460814	11.987783
2882	Yobe	Fune	Alagarno	11.931090	11.619685
2883	Kwara	Oyun	Ilemona	8.048608	4.702317
2884	Jigawa	Buji	Gantsa	11.663665	9.733932
2885	Imo	Nkwerre	Amaokpara	5.721220	7.125505
2886	Oyo	Iseyin	Ijemba/Oke-Ola/Oke-Oja	7.969065	3.594939
2887	Jigawa	Kirika Samma	Tsheguwa	12.530788	10.112850
2888	Bayelsa	Brass	Os-Inibiri	4.313030	6.129810
2889	Oyo	Iwajowa	Iwere-Ile IV	7.947132	2.870294
2890	Akwa Ibom	Obot Akara	Nto Edino II	5.286528	7.559502
2891	Akwa Ibom	Uyo	Etoi II	4.986582	7.989804
2892	Osun	Ilesha West	Ayeso	7.609256	4.709795
2893	Ogun	Shagamu	Isote	6.800036	3.480465
2894	Enugu	Enugu North	China Town	6.451898	7.506908
2895	Jigawa	Malam Mado	Tashena	12.423280	9.973901
2896	Yobe	Geidam	Zurgu Ngilewa / Borko	12.632972	12.292958
2897	Ekiti	Ijero	Ijero Ward 'C'	7.765014	5.080067
2898	Adamawa	Ganye	Jaggu	8.376141	12.188547
2899	Sokoto	Gada	Kadassaka	13.689824	5.587163
2900	Ogun	Egbado South	Ilaro I	6.917444	3.023407
2901	Borno	Kukawa	Kukawa	12.938255	13.479098
2902	Akwa Ibom	Ini	Ikpe II	5.396266	7.761086
2903	Gombe	Kaltungo	Kaltungo East	9.771814	11.426331
2904	Imo	Ahiazu-Mbaise	Ogbor/Umueze	5.568608	7.249646
2905	Anambra	Nnewi South	Azuigbo	5.998763	6.944599
2906	Enugu	Igbo-eze South	Alor Agu	7.035962	7.329554
2907	Abia	Oboma Ngwa	Ntighauzo Amairi	5.063772	7.467620
2908	Ebonyi	Ishielu	Agba	6.235320	7.852677
2909	Akwa Ibom	Itu	West Itam I	5.056359	7.903494
2910	Adamawa	Lamurde	Suwa	9.542778	11.603979
2911	Imo	Ideato South	Umuakam/Umuago	5.821812	7.122332
2912	Anambra	Ayamelum	Omor III	6.511787	6.925432
2913	Zamfara	Zurmi	Kanwa	12.702527	6.624378
2914	Akwa Ibom	Okobo	Nung Atai/Ube I	4.857963	8.183256
2915	Katsina	Ingawa	Daunaka/B.Kwari	12.623791	8.101300
2916	Ondo	Odigbo	Ore I	6.751775	4.839994
2917	Oyo	Oluyole	Okanhinde/Latunde	7.144780	3.963676
2918	Ogun	Obafemi-Owode	Alapako-Oni	7.088882	3.532225
2919	Kwara	Ilorin East	Ibagun	8.540067	4.569235
2920	Kogi	Ijumu	Aiyetoro II	7.928358	5.931893
2921	Bayelsa	Sagbama	Ofoni I	5.135118	5.972930
2922	Kaduna	Kudan	Likoro	11.179944	7.820247
2923	Bauchi	Misau	Ajilin/Gugulin	11.344115	10.563362
2924	Ogun	Ado Odo-Ota	Ere	6.537475	2.883449
2925	Kano	Gaya	Shagogo	11.797036	8.927614
2926	Ekiti	Ekiti East	Omuo-Oke II	7.754965	5.762431
2927	Kogi	Olamaboro	Olamaboro III	7.091671	7.567977
2928	Oyo	Oyo West	Isokun II	7.844485	3.896446
2929	Imo	Orlu	Owerri Ebeiri	5.769461	7.036234
2930	Zamfara	Tsafe	Tsafe	11.947415	6.875937
2931	Oyo	Atisbo	Tede II	8.396091	3.676076
2932	Zamfara	Gusau	Tudun Wada	12.160501	6.703533
2933	Zamfara	Bukkuyum	Ruwan Jema	12.261740	5.778040
2934	Kano	Albasu	Daho	11.679251	9.207549
2935	Enugu	Ezeagu	Mgbagbu Owa III	6.426057	7.308523
2936	Delta	EthiopeE	Agbon  III	5.643753	6.024802
2937	Kebbi	Danko Wasagu	Gwanfi/Kele	11.586387	5.204228
2938	Enugu	Igbo-Eti	Ikolo/Ohebe	6.688662	7.371920
2939	Kogi	Ajaokuta	Ganaga/Township	7.557963	6.667073
2940	Ondo	Akoko South-West	Akungba II	7.458077	5.728853
2941	Plateau	Jos East	Fobur 'A'	9.889411	9.052811
2942	Yobe	Tarmuwa	Babangida	12.181217	11.866818
2943	Ogun	Ogun Waterside	Makun/Irokun	6.468780	4.422359
2944	Zamfara	Tsafe	Yankuzo "B"	12.012224	7.115180
2945	Ogun	Shagamu	Surulere	6.724922	3.504649
2946	Enugu	Udenu	Obollo-Afor	6.912695	7.525294
2947	Edo	Etsako West	Auchi II	7.046658	6.267488
2948	Kogi	Dekina	Emewe	7.432988	6.869631
2949	Kogi	Bassa	Ikende	7.914457	7.288866
2950	Yobe	Geidam	Hausari	12.880463	11.922399
2951	Imo	Unuimo	Umuna	5.757871	7.291569
2952	Benue	Buruku	Mbaakura	7.150179	9.230186
2953	Anambra	Onitsha South	Odoakpu  II	6.089431	6.764297
2954	Edo	Egor	Okhoro	6.364510	5.613065
2955	Kebbi	Fakai	Bangu/Garinisa	11.603417	4.730175
2956	Edo	Orhionmw	Urhonigbe North	5.996609	6.188205
2957	Delta	Ndokwa West	Utagba  Ogbe	5.731937	6.407752
2958	Jigawa	Auyo	Ayan	12.366286	10.077986
2959	Yobe	Yusufari	Mayori	13.222761	10.537292
2960	Delta	Ndokwa East	Ashaka	5.634649	6.383993
2961	Enugu	Oji-River	Achiuno I	6.112503	7.343512
2962	Jigawa	Dutse	Limawa	11.756637	9.337165
2963	Oyo	Akinyele	Iwokoto/Talontan/Idi-oro	7.611065	3.953633
2964	Bauchi	Zaki	Sakwa	12.120115	10.325000
2965	Cross River	Obubra	Osopong II	6.182799	8.350511
2966	Delta	Sapele	Sapele  Urban  VII	5.897432	5.582845
2967	Osun	Orolu	Olufon Orolu 'H'	7.886460	4.508811
2968	Edo	Akoko Edo	Makeke/ Ojah/ Dangbala/ Ojirami/ Anyawoza	7.380419	6.216012
2969	Cross River	Odukpani	Eki	5.262573	8.051464
2970	Katsina	Bakori	Guga	11.708876	7.345057
2971	Adamawa	Song	Zumo	9.792159	13.048583
2972	Adamawa	Michika	Sina / Kamale / kwande	10.550976	13.522686
2973	Taraba	Donga	Mararraba	7.587190	10.336109
2974	Jigawa	Kazaure	Ba'auzini	12.669651	8.493722
2975	Cross River	Odukpani	Obomitiat/Mbiabo/Ediong	5.206820	8.094773
2976	Borno	Damboa	Wawa / Korede	11.129175	12.543592
2977	Kano	Minjibir	Tsakuwa	12.188993	8.638256
2978	Anambra	Awka North	Mgbakwu  I (Anezike)	6.269505	7.076767
2979	Oyo	Ogbomosho North	Aaje/Ogunbado	8.125204	4.213277
2980	Borno	Mobbar	Chamba	13.342714	12.765698
2981	Kano	Gwarzo	Kara	11.858340	7.917786
2982	Edo	Etsako West	Uzairue North East	7.134252	6.338939
2983	Rivers	Akukutor	Jack I	4.708613	6.718301
2984	Benue	Gboko	Yandev North	7.420478	9.044447
2985	Katsina	Katsina (K)	Wakilin Arewa (A)	12.993178	7.594527
2986	Borno	Ngala	Sagir	12.245412	14.135532
2987	Ogun	Ogun Waterside	Iwopin	6.483261	4.202749
2988	Ogun	Ipokia	Agada	6.481179	2.810334
2989	Borno	Kaga	Afa/Dig/Maudori	11.409537	12.653326
2990	Benue	Logo	Nenzev	7.582938	9.231904
2991	Rivers	Degema	Bakana V	4.709424	6.987655
2992	Oyo	Saki West	Sangote/Booda/Baabo/Ilua	8.571895	3.068017
2993	Kano	Ungogo	Zango	12.027659	8.569893
2994	Ekiti	Emure	Oke Emure I	7.367145	5.453959
2995	Borno	Mafa	Masu	12.204863	13.400957
2996	Ekiti	Ijero	Iloro Waard 'A'	7.875018	5.007230
2997	Gombe	Yalmatu / Deba	Jagali North	10.155658	11.729116
2998	Benue	Makurdi	Ankpa/Wadata	7.734386	8.508915
2999	Ogun	Obafemi-Owode	Ajebo	7.109388	3.673007
3000	Osun	Ola-Oluwa	Ikire ile/Iwara	7.725114	4.240786
3001	Lagos	Ifako/Ijaye	Ajegunle/Akinde/Animashaun	6.702796	3.260071
3002	Akwa Ibom	Esit Eket	Edor	4.616819	8.028080
3003	Nassarawa	Kokona	Bassa	8.599027	8.161387
3004	Anambra	Orumba North	Awgbu  II	6.099487	7.105463
3005	Kano	Madobi	Kwankwaso	11.837495	8.393924
3006	Oyo	Itesiwaju	Babaode	8.165254	3.237945
3007	Plateau	Langtang North	Jat	9.256895	9.802921
3008	Oyo	Saki West	Ekokan / Imua	8.674861	3.225956
3009	Plateau	Mangu	Langai	9.625901	9.169883
3010	Imo	Nwangele	Amaju Community Ward (Amaigbo)	5.693292	7.137478
3011	Ebonyi	Ivo	Ngwogwo	5.969211	7.587652
3012	Sokoto	Goronyo	Birjingo	13.450304	5.819808
3013	Kebbi	Danko Wasagu	Danko/Maga	11.655725	5.178685
3014	Cross River	Etung	Ajassor	5.855221	8.823088
3015	Oyo	Ogo-Oluwa	Opete	8.025435	4.208470
3016	Yobe	Borsari	Damnawa/Juluri	12.898615	11.646946
3017	Oyo	Ibadan North East	Ward IX E7II	7.367639	3.934690
3018	Taraba	Yorro	Sumbu I	8.970092	11.425814
3019	Jigawa	Maigatari	Dankumbo	12.730413	9.337173
3020	Osun	Olorunda	Akogun	7.774151	4.559382
3021	Kano	Rimin Gado	Tamawa	11.906277	8.316801
3022	Kano	Karaye	Yola	11.674614	7.957534
3023	Edo	Akoko Edo	Imoga/ Lampese/ Bekuma/ Ekpe	7.482872	6.093599
3024	Nassarawa	Keana	Aloshi	8.244477	8.842248
3025	Adamawa	Gombi	Tawa	10.179587	12.637226
3026	Osun	Irewole	ikire 'A'	7.342979	4.171607
3027	Jigawa	Miga	Sansani	12.220109	9.786645
3028	Bayelsa	Southern Ijaw	Amassoma III	4.955279	6.083615
3029	Lagos	Surulere	Aguda	6.502231	3.331347
3030	Enugu	EnuguSou	Obeagu II	6.369083	7.536885
3031	Delta	Oshimili South	Agu	6.195407	6.700866
3032	Jigawa	Taura	Taura	12.181720	9.270437
3033	Bauchi	Warji	Katanga	11.188641	9.780228
3034	Niger	Shiroro	Gurmana	10.000139	6.631628
3035	Delta	EthiopeE	Abraka  I	5.806758	6.103965
3036	Borno	Guzamala	Wamiri	12.775711	13.371824
3037	Ekiti	Efon	Efon VII	7.664343	4.986185
3038	Plateau	Bokkos	Toff	9.131625	8.812708
3039	Oyo	Lagelu	Lagelu Market/Kajola/Gbena	7.429021	3.978155
3040	Cross River	Obanliku	Basang	6.542772	9.225280
3041	Jigawa	Jahun	Idanduna	12.016843	9.641360
3042	Anambra	Anambra East	Enugwu-otu	6.439189	6.926326
3043	Ekiti	Ikole	Ikole West I	7.723284	5.436523
3044	Kebbi	Jega	Jega Kokani	12.145050	4.484735
3045	Ebonyi	Afikpo South	Amaeke Ekoli	5.844288	7.854276
3046	Kano	Tarauni	Hotoro (NNPC)	11.950446	8.550476
3047	Katsina	Danja	Danja A	11.403163	7.545033
3048	Niger	Wushishi	Gwarjiko	9.599323	5.973858
3049	Yobe	Geidam	Damakarwa/Kusur	12.547334	12.055663
3050	Abia	Ohafia	Amaeke Abiriba	5.720511	7.755220
3051	Enugu	Oji-River	Inyi Iv	6.164579	7.288443
3052	Edo	Oredo	Ikpema/Eguadase	6.282799	5.583961
3053	Akwa Ibom	Eket	Central III	4.665274	7.955982
3054	Oyo	Itesiwaju	Otu II	8.206092	3.379290
3055	Lagos	Mushin	Ilasamaja	6.543156	3.330656
3056	Imo	Nwangele	Amamnaisi (Amaigbo IV)	5.691286	7.116785
3057	Sokoto	Yabo	Kilgori	12.812312	4.986650
3058	Delta	Ughelli South	Olomu I	5.434527	5.959375
3059	Borno	Bama	Dipchari / Jere / Dar-jamal / Kotembe	11.383183	13.913045
3060	Lagos	Badagary	Ajara	6.482168	2.913134
3061	Adamawa	Yola North	Karewa	9.228964	12.480801
3062	Taraba	Sardauna	Kakara	6.774557	11.044058
3063	Kaduna	Zangon Kataf	Zangon Urban	9.834329	8.406253
3064	Osun	Obokun	Ipetu-Ile/Adaowode	7.817823	4.735737
3065	Ogun	Ijebu East	Ijebu Ife II	6.686983	4.189873
3066	Lagos	Mushin	Mushin/Atewolara	6.555214	3.340985
3067	Jigawa	Garki	Kanya	12.363558	8.939669
3068	Imo	Aboh-Mbaise	Enyiogugu	5.467064	7.188366
3069	Benue	Buruku	Mbaya	7.561203	8.991865
3070	Delta	IsokoSou	Erowa/Umeh	5.261116	6.197099
3071	Kaduna	Makarfi	Gubuchi	11.249144	8.042538
3072	Osun	IfeCentral	Iremo/Ajebandele	7.477874	4.591722
3073	Imo	Owerri Municipal	Ikenegbu I	5.494185	7.037827
3074	Zamfara	Bukkuyum	Bukuyyum	12.186668	5.640191
3075	Adamawa	Ganye	Bakari Guso	8.446647	12.243900
3076	Osun	Isokan	Awala  I	7.264054	4.235643
3077	Delta	AniochaN	Issele Uku I	6.295974	6.480369
3078	Cross River	Obanliku	Busi	6.551569	9.298244
3079	Taraba	Ussa	Fikyu	7.100462	9.905516
3080	Yobe	Nguru	Bulabulin	12.862100	10.469789
3081	Ekiti	Gboyin	Aisegba II	7.627920	5.445170
3082	Kogi	Yagba East	Ife Olukotun I	7.900489	5.742323
3083	Imo	Aboh-Mbaise	Mbutu	5.445731	7.198970
3084	Ebonyi	Ohaukwu	Umu Ogudu Akpu II	6.506866	7.935071
3085	Imo	Oru-West	Amafuo	5.818630	6.932492
3086	Kebbi	Kalgo	Diggi	12.289029	4.024365
3087	Plateau	Jos East	Zandi	9.865898	9.173196
3088	Bayelsa	Yenagoa	Epie I	4.965424	6.373601
3089	Borno	Maiduguri	Gwange  II	11.837060	13.234154
3090	Adamawa	Song	Song Waje	9.697456	12.633494
3091	Bauchi	Katagum	Ragwam/Magonshi	11.751600	10.117188
3092	Edo	Owan West	Eruere	7.043908	5.913925
3093	Niger	Suleja	Wambai	9.177129	7.135546
3094	Taraba	Ardo-Kola	Zongon Kombi	8.782431	11.083181
3095	Katsina	Bakori	Bakori A	11.524569	7.411866
3096	Edo	Ikpoba-Okha	Aduwawa / Evbo Modu	6.357112	5.674900
3097	Ekiti	Ise-Orun	Oraye III	7.494444	5.436874
3098	Niger	Suleja	Bagama 'B'	9.192801	7.162173
3099	Sokoto	Tangazar	Ruwa-Wuri	13.718179	5.010122
3100	Cross River	Calabar South	Seven (7)	4.909429	8.257219
3101	Abia	Isiala Ngwa South	Akunekpu Eziama Na Obuba	5.324320	7.448683
3102	Zamfara	Talata-Mafara	Kagara	12.311248	6.093519
3103	Kogi	Ogori Magongo	Oshobane	7.447912	6.208858
3104	Bauchi	Damban	Garuza	11.626286	10.708033
3105	Katsina	Malumfashi	Rawan Sanyi	11.733507	7.593733
3106	Yobe	Machina	Kuka-Yasku	12.965179	10.032766
3107	Adamawa	Girie	Wuro Dole	9.509840	12.715909
3108	Plateau	Pankshin	Pankshin  Chigwong	9.372859	9.399080
3109	Borno	Marte	Njine	12.349064	13.952130
3110	Lagos	Badagary	Ikoga	6.500917	2.968834
3111	Katsina	Danja	Tandama	11.460287	7.464556
3112	Borno	Mobbar	Asaga	13.167377	13.015898
3113	Sokoto	Rabah	Tsamiya	12.915231	5.707586
3114	Rivers	Etche	Akpoku/Umuoye	5.144865	7.010419
3115	Lagos	Shomolu	Fola agoro/Bajulaiye/Igbari-Akoka	6.539878	3.377854
3116	Akwa Ibom	Mbo	Uda II	4.620397	8.183814
3117	Osun	Ife East	Yekemi	7.286786	4.598833
3118	Borno	Marte	Musune	12.359588	13.742183
3119	Enugu	Nsukka	Agbemebe/Umabor	6.812625	7.451453
3120	Imo	Isu	Ekwe II	5.690549	7.059519
3121	Imo	Njaba	Umuaka IV	5.645516	7.021309
3122	Plateau	Riyom	Jol/Kwi	9.559169	8.812806
3123	Katsina	Bakori	Bakori B	11.545677	7.455221
3124	Katsina	Faskari	Daudawa	11.654435	7.188352
3125	Adamawa	Demsa	Mbula Kuli	9.457453	12.301568
3126	Osun	Osogbo	Ataoja  'E'	7.758319	4.554604
3127	Kaduna	Kauru	Kauru East	10.561431	8.217158
3128	Delta	Ethiope West	Jesse  III	5.819984	5.807586
3129	Edo	Egor	Uselu II	6.373798	5.600331
3130	Kwara	Baruten	Yashikira	9.773977	3.666787
3131	Katsina	Funtua	Makera	11.539388	7.293388
3132	Rivers	Port Harcourt	Port Harcourt Township VI	4.731320	7.029174
3133	Oyo	Afijio	Imini	7.762434	3.778978
3134	Rivers	Andoni/Odual	Agwut-Obolo	4.468090	7.367729
3135	Nassarawa	Nassarawa Egon	Nasarawa Eggon	8.687909	8.552281
3136	Nassarawa	Wamba	Arum	9.064684	8.650917
3137	Oyo	Ibadan North	Ward XI, NW8	7.433333	3.898818
3138	Adamawa	Jada	Koma I	8.778453	12.712991
3139	Sokoto	Tangazar	Sakkwai	13.603494	4.888752
3140	Niger	Lapai	Birnin Maza/Tashibo	8.973122	6.669627
3141	Kano	Bunkure	Bunkure	11.684772	8.532921
3142	Oyo	Ibarapa Central	Igbole/Pako	7.438880	3.335964
3143	Ondo	Odigbo	Ayesan	6.667774	5.021430
3144	Cross River	Bakassi	Atai Ema	4.708375	8.492446
3145	Borno	Magumeri	Ngubala	12.469653	12.545330
3146	Abia	Aba North	Osusu I	5.120993	7.347149
3147	Osun	Irewole	Ikire 'G'	7.350041	4.142552
3148	Sokoto	Sabon Birni	S/birni East	13.598632	6.352901
3149	Katsina	Malumfashi	Makaurachi	11.867377	7.814137
3150	Jigawa	Guri	Margadu	12.793154	10.353989
3151	Cross River	Etung	Etomi	5.953104	8.802686
3152	Enugu	Ezeagu	Okpogho	6.464046	7.259619
3153	Delta	Ughelli North	Agbarho I	5.566816	5.895614
3154	Rivers	Asari-Toru	Buguma South	4.702146	6.855905
3155	Ogun	Odogbolu	Ogbo/Moraika/Ita Epo II	6.745481	3.837548
3156	Akwa Ibom	Ini	Odoro Ukwok	5.327159	7.762809
3157	Kaduna	Jema'a	Jagindi	9.339492	8.244512
3158	Sokoto	Sokoto South	Gagi 'C'	12.998382	5.275387
3159	Nassarawa	Toto	Shafan Abakpa	8.319882	7.188863
3160	Imo	Owerri West	Amakohia-Ubi/Ndegwu Ohii	5.521588	6.925664
3161	Imo	Orsu	Eziawa	5.882181	7.034467
3162	Bauchi	Kirfi	Wanka	10.404806	10.419377
3163	Oyo	Ibarapa East	Aborerin	7.508965	3.421770
3164	Edo	Ikpoba-Okha	Gorretti	6.290017	5.621534
3165	Akwa Ibom	Itu	Mbiase/Ayadehe	5.199025	8.046833
3166	Rivers	Obio/Akpor	Elelenwo (3B)	4.829145	7.095591
3167	Bauchi	Bauchi	Dandango/Yamrat	10.115733	9.867123
3168	Plateau	Jos North	Jenta Apata	9.947041	8.876132
3169	Imo	Owerri West	Nekede	5.407866	7.033050
3170	Kaduna	Kagarko	Kukui	9.347491	7.677159
3171	Borno	Hawul	Dzar/ Vinadum/ Birni/ Dlandi	10.590395	12.122223
3172	Edo	Akoko Edo	Uneme-Nekhua/Akpama/ Aiyetoro/ Ekpedo/ Erhurun/ Un	7.335439	6.169063
3173	Borno	Kala/Balge	Jilbe  "A"	11.854279	14.585670
3174	Oyo	Ogbomosho South	Ibapon	8.094971	4.202758
3175	Kaduna	Zaria	Kaura	10.986160	7.706144
3176	Kwara	Ilorin South	Akanbi V	8.406984	4.644260
3177	Jigawa	Roni	Roni	12.633361	8.256854
3178	Lagos	Agege	Oyewole/Papa Ashafa	6.634222	3.293100
3179	Akwa Ibom	Uyo	Ikono II	4.930425	7.816383
3180	Ekiti	Efon	Efon V	7.561008	4.949651
3181	Kwara	Ekiti	Eruku	8.132498	5.450786
3182	Yobe	Fika	Zangaya/Mazawaun	11.265340	11.471990
3183	Anambra	Nnewi North	Nnewi-ichi  II	6.014916	6.909037
3184	Akwa Ibom	Etinan	Etinan Urban III	4.862744	7.850888
3185	Akwa Ibom	Abak	Midim I	5.025249	7.710332
3186	Delta	IsokoNor	Ofagbe	5.555802	6.339564
3187	Oyo	Atisbo	Ofiki	8.315534	3.281435
3188	Benue	Konshisha	Mbagusa/mbatser	7.040672	8.523988
3189	Rivers	Port Harcourt	Nkpolu Oroworukwo	4.796155	6.993523
3190	Cross River	Ikom	Ikom Urban I	5.956472	8.728551
3191	Edo	Igueben	Amahor/Ugun	6.444523	6.153566
3192	Ogun	Remo North	Moborode/Oke-Ola	6.925451	3.731286
3193	Kwara	Oke-Ero	Iloffa	8.120843	5.205073
3194	Enugu	Uzo-Uwani	Igga/Asaba	6.726513	6.948473
3195	Borno	Biu	Sulumthla	10.607308	12.203476
3196	Imo	Ezinihitte Mbaise	Udo-Na-Obizi	5.501127	7.359974
3197	Oyo	Ibarapa East	New Eruwa	7.554887	3.452677
3198	Plateau	Pankshin	Jiblik	9.255153	9.269466
3199	Ondo	Irele	Ajagba I	6.427460	4.983449
3200	Ebonyi	Afikpo South	Amangwu	5.807490	7.807840
3201	Osun	Ede South	Olodan	7.601090	4.505024
3202	Kaduna	Birnin Gwari	Tabanni	11.299137	6.957176
3203	Jigawa	Gwaram	Fagam	11.045056	9.992890
3204	Oyo	Lagelu	Arulogun Ehin/Kelebe	7.496928	4.012935
3205	Jigawa	Gwaram	Farin Dutse	11.169067	9.974564
3206	Abia	Isuikwuato	Achara / Mgbugwu	5.851628	7.411687
3207	Sokoto	Isa	Bargaja	13.167231	6.462709
3208	Akwa Ibom	Oron	Oron Urban I	4.826435	8.218300
3209	Zamfara	Maradun	Birnin Kaya / Dosara	12.487504	6.258151
3210	Bauchi	Shira	Beli/Gagidaba	11.522001	10.068464
3211	Kano	Makoda	Babbar Riga	12.322537	8.519289
3212	Niger	Gbako	Edokota	9.228129	5.921215
3213	Kano	Doguwa	Falgore	11.056287	8.607837
3214	Ekiti	Ilejemeje	Iye I	7.962554	5.211561
3215	Edo	Ikpoba-Okha	Iwogban/Uteh	6.376163	5.646481
3216	Rivers	Ahoada West	Igbuduya II	5.103624	6.504266
3217	Nassarawa	Kokona	Agwada	8.618749	8.070942
3218	Edo	Etsako West	Anwain	6.872714	6.386605
3219	Cross River	Obudu	Utugwang North	6.622693	9.013834
3220	Osun	Irewole	Ikire 'C'	7.369635	4.187147
3221	Ondo	Ifedore	Obo/Ikota/Olo-gbo	7.394946	5.131764
3222	Niger	Gurara	Bonu	9.347581	6.942951
3223	Borno	Kwaya Kusar	Yimirthalang	10.309297	11.930681
3224	Sokoto	Gudu	Balle	13.497331	4.669856
3225	Cross River	Yakurr	Nkpolo/Ukpawen	5.883282	8.165716
3226	Jigawa	Gwaram	Kwandiko	11.132760	10.138443
3227	Imo	Unuimo	Ofeahia/Umuanumeze	5.812261	7.225447
3228	Ogun	Ifo	Iseri	6.653127	3.387648
3229	Niger	Bida	Umaru Majigi  II	9.071520	6.008319
3230	Delta	Bomadi	Akugbene III	5.292969	5.767072
3231	Rivers	Andoni/Odual	Samanga	4.563349	7.369893
3232	Ogun	Ifo	Agbado	6.686521	3.339350
3233	Enugu	Igbo-eze South	Echara	6.940159	7.376109
3234	Akwa Ibom	Etinan	Southern Iman I	4.783711	7.810004
3235	Oyo	Ibarapa East	Oke Otun	7.597048	3.521186
3236	Oyo	Ibadan South West	Ward 3 SW2	7.369452	3.895047
3237	Katsina	Jibia	Bugaje	12.962338	7.482759
3238	Sokoto	Gudu	Chilas/Makuya	13.269971	4.280438
3239	Sokoto	Shagari	Dandin Mahe	12.642527	5.159817
3240	Borno	Abadam	Yau	13.421210	13.238908
3241	Imo	Nwangele	Umuanu Community Ward (Amaigbo II)	5.700688	7.165343
3242	Enugu	Igbo-eze North	Ezzodo	6.937437	7.489090
3243	Kwara	Ilorin West	Ojuekun/Zarumi	8.528967	4.543590
3244	Jigawa	Jahun	Gunka	12.136703	9.435478
3245	Kaduna	Kaduna South	Television	10.423000	7.421662
3246	Abia	Ukwa East	Nkporobe/Ohuru	4.953702	7.412592
3247	Borno	Monguno	Wulo	12.376792	13.407743
3248	Benue	Gwer West	Tijime	7.464503	8.182344
3249	Anambra	Orumba North	Oko  II	6.037698	7.112933
3250	Benue	Ogbadibo	Ai-Oono I	7.047335	7.728531
3251	Kogi	Okene	Upogoro/Odenku	7.441350	6.415619
3252	Plateau	Kanke	Kabwir/Gyangyang	9.484882	9.691763
3253	Bauchi	Jama'are	Dogon jeji "C"	11.708792	9.948505
3254	Ekiti	Ijero	Ijero Ward 'B'	7.754512	5.023075
3255	Akwa Ibom	Ukanafun	Northern Ukanafun I	4.928607	7.611557
3256	Kano	Ungogo	Ungogo	12.083843	8.474766
3257	Imo	Orlu	Ohafor/Okporo/Umutanze	5.763903	7.016109
3258	Oyo	Ibadan North West	Ward 8 NW5	7.392774	3.898013
3259	Katsina	Zango	Sara	12.999142	8.508712
3260	Osun	Ife North	Ipetumodu I	7.388035	4.407544
3261	Akwa Ibom	Nsit Ubium	Ndiya	4.785795	7.915901
3262	Lagos	Ikorodu	Ipakodo	6.642746	3.465743
3263	Lagos	Apapa	Apapa II (Liverpool rd. and Environs)	6.449085	3.365195
3264	Osun	Ejigbo	Ifeodan 'A'/Owu-Ile	7.815995	4.099404
3265	Niger	Edati	Rokota	9.054750	5.462855
3266	Kano	Bebeji	Rantan	11.525928	8.350035
3267	Kebbi	Sakaba	Makuku	11.000971	5.492357
3268	Ogun	Egbado South	Ilaro III	6.831261	2.891638
3269	Borno	Mafa	Limanti	11.940522	13.484531
3270	Kwara	Ilorin West	Balogun Alanamu Central	8.470659	4.551794
3271	Gombe	Funakaye	Tongo	10.723364	11.392146
3272	Imo	Ahiazu-Mbaise	Okirika Nweke	5.561314	7.296435
3273	Lagos	Ajeromi/Ifelodun	Layeni	6.474184	3.323145
3274	Ogun	Imeko-Afon	Ilara/Alagbe	7.728090	2.936228
3275	Kogi	Omala	Olla	7.548466	7.495228
3276	Zamfara	Bukkuyum	Gwashi	11.793134	5.869440
3277	Oyo	Ogbomosho South	Lagbedu	8.091569	4.247211
3278	Katsina	Funtua	Sabon Gari	11.529133	7.338568
3279	Akwa Ibom	Ibiono Ibom	Ibiono Eastern I	5.230306	7.947655
3280	Osun	Odo Otin	Faji/Opete	8.026132	4.625602
3281	Borno	Hawul	Kwajaffa/Hang	10.516158	12.547268
3282	Delta	Uvwie	Ugborikoko	5.543169	5.767229
3283	Oyo	Ido	Ogundele/Alaho/Siba/Idi-Ahun	7.337951	3.762503
3284	Adamawa	Shelleng	Ketembere	9.984897	12.092160
3285	Kano	Garko	Gurjiya	11.604869	8.823938
3286	Kano	Dala	Dala	11.999412	8.457929
3287	Kano	Tundun Wada	Dalawa	11.324088	8.638924
3288	Ekiti	Ido-Osi	Ido II	7.847543	5.209548
3289	Cross River	Akpabuyo	Eneyo	4.947716	8.555070
3290	Osun	Egbedore	Ira Gberi I	7.777232	4.366962
3291	Taraba	Jalingo	Majidadi	8.875334	11.414156
3292	Enugu	Igbo-eze North	Umuozzi III	6.959845	7.509731
3293	Zamfara	Anka	Magaji	12.066269	5.974321
3294	Niger	Agaie	Kutiriko	9.182357	6.439097
3295	Adamawa	Lamurde	Lamurde	9.625735	11.786053
3296	Anambra	Ekwusigo	Ozubulu  III	5.978622	6.843772
3297	Borno	Shani	Gwalasho	10.170337	12.214845
3298	Osun	Ola-Oluwa	Ajagba/Iwooke	7.787121	4.252401
3299	Kano	Kiru	Galadimawa	11.753179	8.230325
3300	Katsina	Charanchi	Kuraye	12.694762	7.636322
3301	Kaduna	Ikara	Saya-Saya	11.191737	8.328025
3302	Kogi	Ankpa	Ojoku II	7.476502	7.742030
3303	Kano	Fagge	Fagge B	11.972812	8.573832
3304	Ekiti	Ise-Orun	Orun II	7.345379	5.424758
3305	Benue	Gboko	Mbatyu	7.402974	8.945932
3306	Niger	Mashegu	Babban  Rami	10.194693	5.350442
3307	Imo	Oru-East	Awo-Omamma III	5.690757	6.980130
3308	Akwa Ibom	Uruan	Southern Uruan I	4.938587	8.018760
3309	Kebbi	Ngaski	Libata/Kwangia	10.153612	4.595442
3310	Borno	Nganzai	Gajiram	12.404324	13.052394
3311	Anambra	Awka South	Nibo  I	6.166693	7.067824
3312	Oyo	Ogbomosho North	Okelerin	8.134373	4.243742
3313	Plateau	Kanke	Langshi	9.284221	9.533677
3314	Delta	Bomadi	Esanma	5.163881	5.899111
3315	Osun	Oriade	Ipetu Ijesa  I	7.447851	4.903051
3316	Kaduna	Sanga	Ninzam South	9.045627	8.517381
3317	Katsina	Kurfi	Rawayau 'A'	12.591573	7.592859
3318	Bauchi	Jama'are	Dogon jeji "A"	11.739223	9.982828
3319	Kaduna	Kudan	Kudan	11.299942	7.741709
3320	Enugu	Igbo-eze South	Nkalagu Obukpa	6.930849	7.309403
3321	Kano	Rimin Gado	Sakaratsa	11.907072	8.371945
3322	Kaduna	Lere	Lere	10.316378	8.521109
3323	Osun	Irepodun	Elerin 'C'	7.816602	4.500164
3324	Edo	Ovia North East	Uhen	6.788831	5.471499
3325	Kano	Kiru	Zuwo	11.764770	8.182207
3326	Kano	Gwale	Goron Dutse	11.981819	8.490015
3327	Ekiti	Ikole	Odo Ayedun I	7.959930	5.584991
3328	Anambra	Awka South	Awka  I	6.214275	7.096099
3329	Katsina	Jibia	Gangara	12.958671	7.396091
3330	Edo	Igueben	Ekpon	6.399965	6.243897
3331	Rivers	Degema	Bakana VI	4.714809	6.931829
3332	Anambra	Nnewi South	Ukpor V	5.953119	6.895816
3333	Cross River	Akamkpa	Eku	5.435689	8.666194
3334	Kaduna	Kaduna South	Tudun Wada South	10.492878	7.422040
3335	Bayelsa	Sagbama	Agoro	5.037941	6.117737
3336	Gombe	Nafada	Nafada East	11.222948	11.304592
3337	Delta	Sapele	Sapele  Urban  IV	5.893339	5.658228
3338	Bauchi	Tafawa-Balewa	Bununu	9.840090	9.673849
3339	Kano	Bunkure	Barkum	11.629800	8.676243
3340	Anambra	Nnewi South	Ezinifite  II	5.898481	6.941375
3341	Ekiti	Ise-Orun	Odo Ise III	7.525972	5.488016
3342	Akwa Ibom	Mbo	Enwang II	4.643302	8.270686
3343	Osun	Ayedaade	Lagere/Amola	7.542827	4.437234
3344	Katsina	Dutsin-M	Dutsin-Ma B	12.444008	7.472126
3345	Kano	Dawakin Tofa	Dan Guguwa	12.044363	8.378337
3346	Lagos	Eti-Osa	Obalende	6.447700	3.412178
3347	Kaduna	Zangon Kataf	Kamantan	9.834477	8.108489
3348	Niger	Shiroro	Allawa	10.378997	6.641779
3349	Kaduna	Jaba	Sambam	9.411104	8.046345
3350	Katsina	Kurfi	Rawayau 'B'	12.601063	7.556772
3351	Borno	Abadam	Arege	13.390333	13.375613
3352	Osun	Olorunda	Owoope	7.772771	4.576963
3353	Oyo	Oyo West	Fasola/Soku	7.888706	3.788116
3354	Sokoto	Sokoto North	Waziri 'B'	13.064357	5.287466
3355	Kano	Kano Municipal	Shahuchi	11.949492	8.483948
3356	Imo	Unuimo	Owerre-Okwe	5.743804	7.255142
3357	Jigawa	Gumel	Garin Alhaji Barka	12.561383	9.351324
3358	Kebbi	Birnin Kebbi	Birnin Kebbi Mafara	12.481288	4.194233
3359	Taraba	Bali	Bali A	7.804026	10.895685
3360	Lagos	Alimosho	Pleasure/Oke-Odo	6.630894	3.278524
3361	Katsina	Charanchi	Radda	12.466943	7.660842
3362	Abia	Ukwa East	Azumini	5.001142	7.455076
3363	Ekiti	Ekiti South West	Ilawe II	7.582819	5.124095
3364	Cross River	Biase	Erei North	5.751344	7.920948
3365	Jigawa	Babura	Dorawa	12.524584	8.821403
3366	Jigawa	Taura	Kwalam	12.225444	9.453621
3367	Jigawa	Babura	Babura	12.799990	8.968595
3368	Delta	Ughelli North	Uwheru	5.276862	6.069113
3369	Oyo	Egbeda	Olubadan Estate	7.376730	3.949636
3370	Oyo	Akinyele	Ojo-Emo/Moniya	7.525108	3.925062
3371	Borno	Marte	Kirenowa	12.250104	13.588581
3372	Abia	Ugwunagbo	Ward Three	5.032208	7.374530
3373	Abia	Umuahia North	Nkwoegwu	5.590611	7.478756
3374	Bayelsa	Southern Ijaw	Otuan	4.880092	6.093565
3375	Bauchi	Katagum	Bulkachuwa/Dagaro	11.630533	10.507867
3376	Anambra	Nnewi South	Ukpor IV	5.930650	6.904056
3377	Rivers	Gokana	Derken/Deeyor/Nweribiara	4.685690	7.314688
3378	Jigawa	Garki	Garki	12.403881	9.175449
3379	Anambra	Dunukofia	Umudioka  II	6.153166	6.895824
3380	Oyo	Ibarapa North	Tapa II	7.567912	3.218602
3381	Nassarawa	Doma	Ungwan Dan Galadima	8.437829	8.331353
3382	Lagos	Eti-Osa	Ado/Langbasa/Badore	6.507025	3.592403
3383	Ondo	Akoko North-East	Iyometa II	7.516446	5.663829
3384	Benue	Gwer West	Avihijime	7.451122	8.132639
3385	Osun	Obokun	Ibokun	7.785926	4.709788
3386	Katsina	Malumfashi	Dayi	11.948336	7.676968
3387	Kano	Makoda	Tangaji	12.301236	8.484323
3388	Ondo	Akoko North-East	Ekan	7.504880	5.748382
3389	Katsina	Bindawa	Shibdawa	12.755996	7.799145
3390	Cross River	Yala	Ijiraga	6.457816	8.511111
3391	Cross River	Etung	Mkpot/Ayuk Aba	5.739256	8.701634
3392	Katsina	Kankara	Garagi	12.126053	7.220874
3393	Kaduna	Ikara	K/Kogi	11.211126	8.176645
3394	Sokoto	Sabon Birni	Makuwana	13.597103	6.231219
3395	Niger	Lavun	Doko	8.927650	5.964048
3396	Edo	Uhunmwonde	Umagbae North	6.418545	5.788980
3397	Taraba	Ussa	Rufu	7.164679	10.084943
3398	Kaduna	Kaduna North	Shaba	10.518269	7.444359
3399	Ogun	Ipokia	Ifonyintedo	6.848324	2.771180
3400	Nassarawa	Wamba	Gitta	9.040324	8.603222
3401	Enugu	Isi-Uzo	Ikem I	6.808424	7.705209
3402	Delta	Bomadi	Bomadi	5.170834	5.953372
3403	Plateau	Bassa	Ta'agbe	9.860171	8.677195
3404	Niger	Paikoro	Gwam	9.470583	6.799423
3405	Lagos	Ojo	Ilogbo	6.475371	3.123729
3406	Edo	Uhunmwonde	Igieduma	6.586549	5.879666
3407	Cross River	Bakassi	Archibong	4.787823	8.524588
3408	Oyo	Surulere	Oko	7.958444	4.376203
3409	Kano	Gwarzo	Sabon Birni	11.861477	8.007671
3410	Plateau	Jos North	Gangare	9.909524	8.892992
3411	Katsina	Kafur	Gamzago	11.808398	7.799127
3412	Enugu	Enugu East	Abakpa II	6.482227	7.512225
3413	Oyo	Saki West	Okere II	8.570127	3.312099
3414	Oyo	Ogo-Oluwa	Ajaawa I	7.931950	4.110012
3415	Adamawa	Song	Dumne	9.773972	12.447675
3416	Nassarawa	Nassarawa Egon	Ende	8.848482	8.468768
3417	Imo	Ngor-Okpala	Logara/Umuohiagu	5.422041	7.203079
3418	Rivers	Port Harcourt	Rumuwoji (Three)	4.767596	6.999282
3419	Ondo	Owo	Ijebu II	7.036078	5.542128
3420	Nassarawa	Nassarawa Egon	Mada Station	8.763829	8.303006
3421	Imo	Nkwerre	Umudi/Umuwala	5.722610	7.146213
3422	Osun	Irewole	Ikire 'J'	7.413697	4.214368
3423	Ebonyi	Ikwo	Ndiagu Echara II	6.144918	8.266951
3424	Plateau	Bokkos	Tangur	9.236487	9.014895
3425	Gombe	Akko	Kumo East	10.060379	11.407174
3426	Akwa Ibom	Mbo	Uda I	4.663591	8.213634
3427	Plateau	Shendam	Kalong	8.636753	9.419337
3428	Niger	Agaie	Dauaci	8.968585	6.333791
3429	Gombe	Shomgom	Kulishin	9.829413	11.304800
3430	Akwa Ibom	Eastern Obolo	Eastern Obolo V	4.514142	7.671963
3431	Ekiti	Efon	Efon III	7.637881	4.954332
3432	Anambra	Ayamelum	Umu elum	6.451920	6.984302
3433	Benue	Okpokwu	Ojigo	6.998675	7.927770
3434	Imo	Oguta	Oseemotor/Enuigbo	5.704101	6.750599
3435	Kwara	Edu	Lafiagi I	8.803942	5.409142
3436	Jigawa	Kazaure	Gada	12.593724	8.449945
3437	Kano	Garko	Garin Ali	11.519162	8.816726
3438	Adamawa	Girie	Tambo	9.547608	12.513956
3439	Kaduna	Lere	Lazuru	10.237767	8.653151
3440	Edo	Ovia North East	Oluku	6.433315	5.591164
3441	Jigawa	Kaugama	Jarkasa	12.716109	9.745819
3442	Katsina	Funtua	Tudun Iya	11.328867	7.365220
3443	Lagos	Epe	Oriba/Ladaba	6.560022	3.738203
3444	Ebonyi	Ikwo	Echialike	6.187126	8.250945
3445	Akwa Ibom	Eastern Obolo	Eastern Obolo VI	4.504190	7.622428
3446	Adamawa	Demsa	Dong	9.365520	11.975522
3447	Benue	Ukum	Uyam	7.500179	9.586432
3448	Oyo	Lagelu	Lagun	7.550147	4.094387
3449	Delta	IsokoNor	Otibio	5.550416	6.169749
3450	Ondo	Akoko North-East	Iyometa I	7.498577	5.668952
3451	Niger	Tafa	Ija Koro	9.268007	7.252719
3452	Imo	Ohaji-Egbema	Umuapu	5.231201	6.882915
3453	Osun	Ife South	Ikija  I	7.216645	4.703331
3454	Kwara	Ilorin East	Gambari I	8.484128	4.583900
3455	Osun	Ife South	Mefoworade	7.094672	4.601070
3456	Ebonyi	Ivo	Iyioji Akaeze	5.885384	7.695915
3457	Taraba	Ardo-Kola	Sarkin Dutse	8.742528	11.227820
3458	Osun	Irepodun	Olobu 'A'	7.836078	4.492243
3459	Ogun	Ijebu North-East	Ilese	6.863016	3.994277
3460	Rivers	Opobo/Nkoro	Queens Town Kalama	4.469722	7.540176
3461	Cross River	Bekwarra	Beten	6.752674	8.929620
3462	Plateau	Riyom	Rim	9.532902	8.764947
3463	Kano	Wudil	Darki	11.637297	8.889708
3464	Delta	Patani	Patani   II	5.227934	6.186165
3465	Taraba	Sardauna	Kabri	6.676580	11.431858
3466	Ogun	Ijebu-Ode	Isoku/Ososa	6.827022	3.933096
3467	Delta	Ndokwa East	Aboh/Akarrai	5.557341	6.513508
3468	Akwa Ibom	Eastern Obolo	Eastern Obolo III	4.524494	7.717571
3469	Adamawa	Numan	Imburu	9.505089	12.107256
3470	Katsina	Dutsi	Ruwankaya B	12.919022	8.178818
3471	Kaduna	Ikara	Paki	11.474218	8.125683
3472	Cross River	Yakurr	Assiga	5.944095	8.139398
3473	Jigawa	Dutse	Chamo	11.979105	9.289671
3474	Ebonyi	Ohaozara	Umuchima	6.030725	7.721705
3475	Lagos	Oshodi/Isolo	Isolo	6.549000	3.315909
3476	Kano	Fagge	Fagge E	11.984553	8.550975
3477	Bayelsa	Southern Ijaw	Central Bomo II	4.626102	6.133284
3478	Akwa Ibom	Mkpat Enin	Ikpa Ikono I	4.853545	7.788960
3479	Ebonyi	Ezza South	Ikwuator/Idembia	6.105027	7.961942
3480	Kaduna	Kaduna South	Tudun Nuwapa	10.529063	7.436417
3481	Niger	Mashegu	Ibbi	9.602259	4.899884
3482	Abia	Aba South	Enyimba	5.077383	7.328221
3483	Zamfara	Bungudu	Rawayya / Bela	12.322116	6.666591
3484	Delta	AniochaS	Nsukwa	6.071998	6.410214
3485	Yobe	Machina	Lamisu	13.129286	10.148927
3486	Kwara	Ilorin East	Oke Oyi/Oke Ose/Alalubosa	8.530350	4.650072
3487	Taraba	Gashaka	Mayo Selbe	7.338691	11.261294
3488	Borno	Bayo	Fikayel	10.506814	11.784111
3489	Osun	IfeCentral	Ilare I	7.458296	4.605655
3490	Delta	IsokoSou	Irri I	5.438689	6.211515
3491	Federal Capital Territory	Abaji	Rimba Ebagi	8.434714	6.858830
3492	Jigawa	Kiyawa	Kwanda	11.925401	9.823341
3493	Zamfara	Maru	Ruwan Dorawa	12.166705	6.361122
3494	Niger	Suleja	Magajiya	9.181572	7.144586
3495	Delta	Oshimili North	Ibusa  III	6.201572	6.651879
3496	Borno	Shani	Gasi / Salifawa	10.167308	11.971873
3497	Ebonyi	Afikpo North	Nkpoghoro Afikpo	5.873948	7.946473
3498	Niger	Muya	Kabula	9.859076	7.174677
3499	Plateau	Kanam	Dengi	9.362941	9.941078
3500	Plateau	Barkin Ladi	Barakin Ladi	9.517062	8.887234
3501	Borno	Mobbar	Zari	13.071078	12.518546
3502	Yobe	Potiskum	Bolewa 'A'	11.672666	11.105844
3503	Imo	Obowo	Okwuohia	5.560962	7.357703
3504	Adamawa	Michika	Bazza Margi	10.561200	13.345133
3505	Taraba	Zing	Zing AI	9.022691	11.859288
3506	Enugu	Udi	Umulumgbe	6.588108	7.421237
3507	Jigawa	Maigatari	Turbus	12.750257	9.671791
3508	Adamawa	Yola South	Bole Yolde Pate	9.126294	12.643737
3509	Kano	Sumaila	Masu	11.160803	8.796348
3510	Enugu	Uzo-Uwani	Ukpata	6.633629	7.132795
3511	Jigawa	Kaugama	Askandu	12.381311	9.859408
3512	Kano	Gwarzo	Kutama	11.891071	7.900276
3513	Kano	Ungogo	Yadakunya	12.060387	8.595494
3514	Rivers	Asari-Toru	Buguma  East II	4.733216	6.861795
3515	Kaduna	Lere	Gure/Kahugu	10.295614	8.411427
3516	Borno	Ngala	Fuye	12.269390	14.377999
3517	Lagos	Surulere	Igbaja/Stadium	6.510593	3.356765
3518	Ondo	Ilaje	Ugbo VI	5.928887	5.011391
3519	Kano	Fagge	Sabongari East	11.988687	8.575144
3520	Delta	Burutu	Ngbilebiri I	5.330724	5.747861
3521	Kwara	Kaiama	Kaima III	9.823372	4.157870
3522	Sokoto	Wurno	Alkammu/Gyelgyel	13.131924	5.402139
3523	Imo	Oru-West	Ubulu	5.802573	6.930548
3524	Imo	Ideato North	Osina	5.861359	7.123194
3525	Nassarawa	Nassarawa Egon	Alogani	8.742777	8.496921
3526	Edo	Ovia South West	Siluko	6.382008	5.131312
3527	Kano	Kiru	Dangora	11.542095	8.141683
3528	Adamawa	Mayo-Belwa	Gangfada	8.585056	12.100827
3529	Kano	Kura	Dalili	11.770276	8.391856
3530	Kaduna	Giwa	Gangara	11.307635	7.416143
3531	Katsina	Sandamu	Kagare	12.950439	8.407777
3532	Kogi	Olamaboro	Olamaboro II	7.178505	7.672193
3533	Sokoto	Kebbe	Fakku	11.633601	4.654660
3534	Akwa Ibom	Mbo	Ebughu I	4.712760	8.276713
3535	Zamfara	Bungudu	Bungudu	12.290978	6.582912
3536	Jigawa	Kirika Samma	Fandum	12.436466	10.173817
3537	Kano	Tundun Wada	Jandutse	11.242875	8.455228
3538	Benue	Okpokwu	Okpoga Central	7.031590	7.817722
3539	Rivers	Port Harcourt	Mgbundukwu (Two)	4.775662	6.996660
3540	Rivers	Ogu/Bolo	Ele	4.658186	7.178849
3541	Ogun	Ifo	Sunren	6.838170	3.152158
3542	Akwa Ibom	Abak	Otoro I	5.014103	7.779817
3543	Enugu	Ezeagu	Mgbagbu Owa II	6.403081	7.190155
3544	Borno	Hawul	Marama/Kidang	10.428727	12.155072
3545	Abia	Bende	Umuhu / Ezechi	5.666514	7.592611
3546	Imo	Ngor-Okpala	Ohekelem Mnorie	5.335722	7.135216
3547	Yobe	Yusufari	Kaska/Tulotulowa	13.294924	10.946939
3548	Lagos	Ojo	Tafi	6.411427	3.112710
3549	Oyo	Ogo-Oluwa	Ajaawa II	7.955863	4.146836
3550	Borno	Abadam	Yawa kura	13.638556	13.298338
3551	Oyo	Ibarapa East	Oke-Imale	7.574041	3.454182
3552	Kaduna	Sanga	Gwantu	9.224015	8.463747
3553	Enugu	Nsukka	Ejuona/Uwani	6.740696	7.337123
3554	Anambra	Anaocha	Obeledu	6.059052	7.002133
3555	Osun	Odo Otin	Ekosin/Iyeku	8.023958	4.586308
3556	Jigawa	Biriniwa	Dangwaleri	12.686572	9.925107
3557	Ondo	Akoko North-East	Edo	7.506266	5.761181
3558	Ogun	Remo North	Ayegbami	7.002494	3.677532
3559	Kwara	Irepodun	Esie/Ijan	8.167648	4.906968
3560	Anambra	Awka North	Awba-ofemmili	6.413798	7.020696
3561	Nassarawa	Keffi	Tudun Kofa T.V	8.845668	7.871985
3562	Cross River	Boki	Oku/Borum/Njua	6.417275	8.874661
3563	Lagos	Ikorodu	Isele III	6.622090	3.513722
3564	Kwara	Ifelodun	Oke-Ode I	8.589530	5.172034
3565	Katsina	Musawa	Musawa	12.097977	7.644584
3566	Jigawa	Garki	Kargo	12.469550	9.100345
3567	Delta	Ukwuani	Umuebu	5.775886	6.159538
3568	Jigawa	Malam Mado	Tonikutara	12.517617	10.046246
3569	Adamawa	Gombi	Gabun	10.258034	12.462286
3570	Imo	Oguta	Oguta 'B'	5.691760	6.811922
3571	Edo	Esan West	Iruekpen	6.751017	6.036449
3572	Akwa Ibom	Essien Udim	Odoro Ikot II	5.112269	7.569207
3573	Ondo	IleOluji/Okeigbo	Oke-igbo I	7.240696	4.931634
3574	Niger	Mashegu	Mazakuka/Likoro	10.097119	5.063459
3575	Akwa Ibom	Urue Offong|Oruko	Oruko V	4.679741	8.146652
3576	Kaduna	Zangon Kataf	Unguwar Gaiya	9.748464	8.406013
3577	Nassarawa	Awe	Jangaru	8.389127	9.066473
3578	Delta	Warri South-West	Gbaramatu	5.653708	5.222429
3579	Niger	Suleja	Iku South II	9.155890	7.155191
3580	Kano	Rogo	Falgore	11.473431	7.710594
3581	Imo	Okigwe	Amuro	5.748682	7.338926
3582	Rivers	Ikwerre	Ubima	5.133376	6.902496
3583	Rivers	Abua/Odu	Emughan  II	4.947899	6.569805
3584	Borno	Nganzai	Alarge	12.628479	13.256187
3585	Delta	Ughelli South	Ewu II	5.278546	5.952364
3586	Gombe	Gombe	Ajiya	10.320747	11.235553
3587	Niger	Kontogur	Usalle	10.283847	5.626280
3588	Benue	Gboko	Mbaanku	7.368836	8.697652
3589	Abia	Aba South	Ngwa	5.062760	7.354629
3590	Ondo	Ondo West	Lodasa/Iparuku/Lijoka	7.082801	4.832190
3591	Delta	Ndokwa West	Onicha - Ukwani	5.837618	6.418302
3592	Rivers	Bonny	Ward X Oloma Ayaminima	4.458736	7.200722
3593	Borno	Bama	Wulbari/Ndine/Chachile	11.535911	14.115517
3594	Anambra	Awka South	Ezinato/Isiagu	6.198660	7.115675
3595	Niger	Suleja	Maje North	9.237600	7.148476
3596	Cross River	Akamkpa	Iko	5.631394	8.327608
3597	Niger	Chanchaga	Limawa 'B'	9.621707	6.494973
3598	Enugu	Ezeagu	Aguobu-Owa I	6.382874	7.278367
3599	Bauchi	Darazo	Lago	11.177218	10.555181
3600	Ekiti	Irepodun-Ifelodun	Iworoko	7.722601	5.273047
3601	Ogun	Ikenne	Ogere II	6.858582	3.692654
3602	Ekiti	Ijero	Ijero Ward 'D'	7.728970	5.073227
3603	Delta	AniochaN	Onicha - Olona	6.376525	6.552473
3604	Bayelsa	Kolokuma-Opokuma	Opokuma North	5.065921	6.277824
3605	Osun	Ede North	Alusekere	7.688019	4.519172
3606	Rivers	Ikwerre	Elele II	5.062429	6.793391
3607	Edo	Ovia South West	Iguobazuwa East	6.553846	5.342443
3608	Akwa Ibom	Nsit Ubium	Ubium South II	4.699627	8.007183
3609	Zamfara	Shinkafi	Chiki	12.915064	6.504711
3610	Oyo	Oyo East	Agboye/Molete	7.863355	4.033459
3611	Zamfara	Kaura-Namoda	Banga	12.503689	6.629194
3612	Oyo	Oyo East	Ajagba	7.841686	3.982304
3613	Kaduna	Chikun	Kuriga	10.677777	6.870348
3614	Akwa Ibom	Mkpat Enin	Ibiaku I	4.763654	7.725722
3615	Enugu	Oji-River	Oji-river IV	6.206349	7.232087
3616	Enugu	Igbo-Eti	Aku II	6.703012	7.315803
3617	Kano	Kumbotso	Mariri	11.923630	8.581628
3618	Sokoto	Goronyo	Kwakwazo	13.527327	5.625780
3619	Kano	Warawa	Warawa	11.831569	8.729351
3620	Delta	Warri North	Isekelewu (Egbema II)	5.737586	5.122015
3621	Edo	Esan Centtral	Ewu I	6.773334	6.239876
3622	Nassarawa	Karu	Tattara/Kondoro	9.229449	7.923749
3623	Katsina	Funtua	Maska	11.362959	7.313045
3624	Osun	Egbedore	Ara I	7.833007	4.397974
3625	Kano	Gwarzo	Mainika	11.920935	7.862838
3626	Imo	Nwangele	Umuozu Ward	5.679372	7.143376
3627	Edo	Oredo	Ogbe	6.268779	5.553305
3628	Cross River	Obubra	Osopong I	6.177012	8.377373
3629	Benue	Ushongo	Mbakuha	7.046843	8.925394
3630	Abia	Umuahia North	Umuahia Urban  I	5.506783	7.472668
3631	Abia	Oboma Ngwa	Mgboko Itungwa	5.194555	7.480284
3632	Benue	Agatu	Obagaji	7.927223	7.904889
3633	Akwa Ibom	Oruk Anam	Ndot/Ikot Okoro I	4.885678	7.673425
3634	Zamfara	Bakura	Bakura	12.690701	5.896391
3635	Ondo	Ondo East	Ateru/Otasan/Igba	6.958879	4.956609
3636	Kebbi	Arewa	Feske/Jaffeji	12.673232	3.943967
3637	Benue	Oju	Iyeche	6.848763	8.485079
3638	Bauchi	Itas/Gadau	Bilkicheri	11.895922	9.897457
3639	Sokoto	Tambawal	Dogondaji/Sala	12.442549	4.901196
3640	Oyo	Ido	Fenwa/Oganla/Elenusonso	7.434484	3.812652
3641	Bauchi	Itas/Gadau	Bambal	11.740833	9.682180
3642	Ondo	Ondo West	Orisunmibare/Araromi	7.032904	4.902983
3643	Benue	Oju	Ainu	6.875802	8.236595
3644	Gombe	Funakaye	Wawa / Wakkulutu	10.772631	11.230839
3645	Edo	Etsako Central	Ogbona	7.112713	6.447548
3646	Jigawa	Maigatari	Madana	12.588864	9.691495
3647	Kano	Doguwa	Dariya	10.663667	8.765742
3648	Enugu	Uzo-Uwani	Uvuru	6.710039	7.163952
3649	Ekiti	Ekiti South West	Ilawe V	7.512655	5.081708
3650	Akwa Ibom	Mkpat Enin	Ikpa Ibom III	4.585469	7.756418
3651	Nassarawa	Nasarawa	Nasarawa East	8.512935	7.664806
3652	Bayelsa	Sagbama	Agbere	5.238558	6.358604
3653	Kwara	Isin	Isanlu I	8.214350	5.105613
3654	Kebbi	Arewa	Laima/Jantullu	12.990435	4.210201
3655	Cross River	Yakurr	Idomi	5.734421	8.090139
3656	Zamfara	Bukkuyum	Zauma	12.227322	5.595089
3657	Kano	Bunkure	Bono	11.714653	8.588041
3658	Akwa Ibom	Oron	Oron Urban VII	4.815402	8.231253
3659	Sokoto	Sokoto South	S/Zamfara 'A'	13.023995	5.260384
3660	Benue	Makurdi	North Bank I	7.777837	8.545588
3661	Rivers	Emuoha	Omudioga/ Akpadu	5.134471	6.747857
3662	Katsina	Sabuwa	Sabuwa 'A'	11.172560	7.142327
3663	Sokoto	Kware	Tunga/ Mallamawa	13.065104	5.425948
3664	Ogun	Ogun Waterside	Oni	6.551420	4.234960
3665	Borno	Maiduguri	Hausari/Zango	11.842860	13.211627
3666	Plateau	Wase	Kadarko	8.837669	10.166898
3667	Niger	Wushishi	Kanwuri	9.733539	6.036906
3668	Imo	Okigwe	Umulolo	5.813958	7.374849
3669	Imo	Orsu	Okwuamaraihie I	5.817808	6.957458
3670	Adamawa	Mayo-Belwa	Yoffo	8.995715	12.029837
3671	Zamfara	Bungudu	Samawa	12.266947	6.744163
3672	Kogi	Adavi	Kuroko II	7.645730	6.470664
3673	Anambra	Idemili North	Abacha	6.125213	6.949079
3674	Adamawa	Jada	Jada I	8.718923	12.274389
3675	Cross River	Akpabuyo	Ikot Edem Odo	4.883055	8.362595
3676	Benue	Katsina- Ala	Mbatula/Mberev	7.434613	9.870335
3677	Kano	Bichi	Kwamarawa	12.266477	8.396494
3678	Kano	Albasu	Albasu Central	11.651497	9.153337
3679	Delta	Ndokwa East	Ossissa	5.928619	6.499822
3680	Plateau	Riyom	Ta-Hoss	9.580773	8.701127
3681	Edo	Owan East	Otuo  I	7.208485	5.999155
3682	Osun	Irepodun	Bara 'A'	7.875856	4.533301
3683	Jigawa	Kafin Hausa	Sarawa	12.242834	10.006118
3684	Enugu	Oji-River	Achiuno IV	6.114591	7.364473
3685	Bayelsa	Yenagoa	Attissa II	4.910992	6.200910
3686	Bauchi	Dass	Wandi	9.990367	9.491394
3687	Anambra	Idemili South	Oba I	6.054228	6.828941
3688	Rivers	Oyigbo	Komkom	4.854774	7.152129
3689	Ondo	Ose	Ifon II	6.912394	5.734605
3690	Kaduna	Igabi	Zangon Aya	10.932475	7.678616
3691	Ogun	Ijebu East	Imobi I	6.590327	4.126981
3692	Kogi	Okehi	Obaiba II	7.587500	6.161995
3693	Plateau	Bokkos	Mushere Central	9.122746	9.058536
3694	Imo	Oru-West	Ibiaso Egbe	5.751348	6.905577
3695	Akwa Ibom	Eastern Obolo	Eastern Obolo II	4.532764	7.754805
3696	Lagos	Ojo	Okokomaiko	6.476607	3.201360
3697	Anambra	Anambra East	Umureli  I	6.312206	6.879802
3698	Kano	Rogo	Gwangwan	11.536773	7.739713
3699	Plateau	Bokkos	Mbar/Mangar	9.131487	8.922250
3700	Enugu	Enugu North	Asata Township	6.448060	7.499837
3701	Enugu	Igbo-Eti	Ozalla II	6.720380	7.384403
3702	Delta	Bomadi	Ogbeinama/Okoloba	5.232091	5.824352
3703	Adamawa	Demsa	Kpasham	9.265589	11.890201
3704	Gombe	Akko	Garko	10.251598	11.155862
3705	Ondo	Akoko South-East	Epinmi II	7.445814	5.847103
3706	Sokoto	Wurno	Dankemu	13.266569	5.425119
3707	Edo	Esan West	Emuhi/ Ukpenu/ Ujoelen	6.699778	6.093667
3708	Kano	Ungogo	Panisau	12.050605	8.516636
3709	Oyo	Ido	Ido/Onikede/Okuna Awo	7.475194	3.756871
3710	Kogi	Ankpa	Ojoku I	7.456589	7.679890
3711	Cross River	Obanliku	Bishiri North	6.675525	9.219869
3712	Kaduna	Birnin Gwari	MagajinG2	10.817489	6.427916
3713	Plateau	Jos North	Sarkin Arab	9.930835	8.886124
3714	Kano	Tsanyawa	Yanganau	12.231458	7.922683
3715	Benue	Tarka	Shitile	7.573801	8.796964
3716	Anambra	Ekwusigo	Oraifite  I	6.016733	6.798616
3717	Abia	Ikwuano	Oloko II	5.333486	7.571767
3718	Enugu	Nkanu East	Nara II	6.199358	7.678889
3719	Akwa Ibom	Etinan	Southern Iman IV	4.721700	7.842805
3720	Imo	Ahiazu-Mbaise	Oparanadim	5.588889	7.252516
3721	Akwa Ibom	Ukanafun	Southern Afaha, Adat Ifang IV	4.813094	7.555225
3722	Kaduna	Sanga	Ninzam North	9.119169	8.551791
3723	Oyo	Ogo-Oluwa	Ayede	8.006035	4.165221
3724	Osun	Ola-Oluwa	Obamoro/Ile Ogo	7.744810	4.171173
3725	Borno	Damboa	Ajign (A)	11.080049	12.367198
3726	Yobe	Karasuwa	Burkati	12.911080	10.890273
3727	Borno	Chibok	Mboa Kura	10.927171	12.769988
3728	Katsina	Sandamu	Karkarku	12.980525	8.347296
3729	Katsina	Batagarawa	Batagarawa A	12.872485	7.608797
3730	Katsina	Kusada	Boko	12.508296	7.957273
3731	Bauchi	Ningi	Sama	10.845407	9.120251
3732	Kebbi	Birnin Kebbi	Maurida /Karyo/Ung. Mijin-Nana	12.553684	4.176162
3733	Imo	Oru-West	Mgbidi I	5.691006	6.888996
3734	Enugu	Nkanu West	Amurri	6.253931	7.509063
3735	Rivers	Eleme	Ogale	4.800114	7.146446
3736	Plateau	Langtang North	Kwallak	9.135786	9.749751
3737	Enugu	Igbo-Eti	Aku IV	6.683319	7.338098
3738	Ogun	Egbado North	Ohunbe	6.974171	2.772671
3739	Edo	Esan South East	Emu	6.555663	6.480039
3740	Adamawa	Michika	Moda / Dlaka / Ghenjuwa	10.620958	13.411271
3741	Gombe	Kwami	Bojude	10.624310	11.087713
3742	Niger	Mokwa	Gbajibo/Muwo	9.365512	4.757675
3743	Lagos	Badagary	Apa	6.435483	2.798138
3744	Sokoto	Bodinga	Mazan Gari/Jirga Miyo	12.830789	5.189506
3745	Oyo	Surulere	Iresaadu	8.104940	4.427536
3746	Sokoto	Binji	Yabo 'A'	13.222755	4.816737
3747	Ogun	Ijebu North-East	Igede/Itamarun	6.899882	3.975465
3748	Ekiti	Ikere	Are Araromi	7.453530	5.289550
3749	Oyo	Itesiwaju	Oke-Amu	8.115735	3.637733
3750	Jigawa	Guri	Adiyani	12.787063	10.426746
3751	Imo	Ohaji-Egbema	Assa/Obile	5.353494	6.855293
3752	Borno	Guzamala	Aduwa	12.863205	13.204911
3753	Yobe	Potiskum	Yerimaram/Garin Daye/Badejo/Nahuta	11.668307	11.151296
3754	Borno	Magumeri	Ngamma	12.344667	12.697633
3755	Zamfara	Maru	Dan Kurmi	11.499718	6.028422
3756	Plateau	Wase	Saluwe	9.191221	9.962543
3757	Delta	Warri North	Eghoro	5.857134	5.449644
3758	Kogi	Ibaji	Onyedega	6.909159	6.696620
3759	Kano	Gaya	Kazurawa	11.703624	9.007421
3760	Imo	Oru-West	Ohakpu	5.741986	6.876523
3761	Nassarawa	Akwanga	Ancho Nighaan	9.025736	8.438311
3762	Rivers	Khana	Wiiyaa Kara	4.643242	7.439586
3763	Imo	Mbaitoli	Ogbaku	5.554149	6.959925
3764	Zamfara	Gummi	Ubandawaki	12.129372	5.236799
3765	Yobe	Gujba	Wagir	11.365162	11.784719
3766	Benue	Guma	Kaambe	7.739899	8.880764
3767	Imo	Nwangele	Ezeobolo/Ofeahia/Duruoha/Umukabia (Amaigbo Ward V)	5.696950	7.099113
3768	Anambra	Orumba South	Umunze I	5.949634	7.213024
3769	Taraba	Lau	Abbare I	9.288697	11.572802
3770	Plateau	Pankshin	Kadung	9.514477	9.363585
3771	Delta	Warri North	Ogbudugbudu (Egbema IV)	5.790368	5.251769
3772	Adamawa	Madagali	Wagga	10.909781	13.631597
3773	Osun	Ifedayo	Temidire	7.961850	5.033769
3774	Adamawa	Girie	Modire/ Vinikilang	9.249825	12.653277
3775	Delta	AniochaN	Obior	6.261020	6.397799
3776	Zamfara	Bakura	Damri	12.433097	5.758949
3777	Kwara	Oke-Ero	Odo-Owa I	8.181775	5.230659
3778	Anambra	Aguata	Ezinifite I	5.983492	7.057753
3779	Delta	Ethiope West	Jesse  I	5.886535	5.785190
3780	Plateau	Qua'anpa	Doemak-Koplong	8.936524	9.241050
3781	Oyo	Ogo-Oluwa	Odo-Oba	8.054599	4.181297
3782	Katsina	Ingawa	Ingawa	12.647223	8.045324
3783	Taraba	Ibi	Ibi Nwonyo II	8.224628	9.846503
3784	Osun	Ayedaade	Araromi-Owu	7.128085	4.352823
3785	Anambra	Dunukofia	Nawgu  I	6.256834	6.962483
3786	Delta	EthiopeE	Agbon  IV	5.595942	5.949533
3787	Imo	Owerri Municipal	New Owerri I	5.467194	7.018141
3788	Kaduna	Sanga	Wasa Station	9.109764	8.197515
3789	Kaduna	Sabon Gari	Muchia	11.125300	7.756351
3790	Yobe	Nangere	Watinani	11.809397	10.955176
3791	Gombe	Yalmatu / Deba	Zambul / Kwali	10.363552	11.409211
3792	Bayelsa	Yenagoa	Biseni II	5.238421	6.517991
3793	Rivers	Degema	Obuama	4.805053	6.726810
3794	Anambra	Onitsha South	Odoakpu VII	6.074008	6.751513
3795	Bauchi	Jama'are	Jama'are "D"	11.688395	9.916460
3796	Benue	Ohimini	Onyagede-Ehaje (Alle)	7.275355	7.848004
3797	Osun	Osogbo	Ataoja  'A'	7.725009	4.568218
3798	Kwara	Offa	Balogun	8.134076	4.715871
3799	Anambra	Njikoka	Enugwu Ukwu  I	6.173459	7.000686
3800	Adamawa	Fufore	Farang	9.589677	12.981933
3801	Rivers	Emuoha	Ogbakiri  I	4.814238	6.891125
3802	Enugu	Udi	Ngwo Asa	6.427828	7.424509
3803	Ekiti	Oye	Omu Oke/Omu Odo/Ijelu	7.907631	5.392807
3804	Akwa Ibom	Mkpat Enin	Ikpa Ikono III	4.741689	7.787415
3805	Oyo	Ogbomosho South	Isoko	8.097005	4.233237
3806	Katsina	Sandamu	Daneji 'A'	12.873896	8.285689
3807	Ekiti	Ado-Ekiti	Ado 'A' Idofin	7.556381	5.271797
3808	Taraba	Jalingo	Abbare Yelwa	8.965232	11.322965
3809	Cross River	Obudu	Obudu Urban I	6.658544	9.140805
3810	Rivers	Etche	Obibi/Akwukabi	5.062404	7.100931
3811	Akwa Ibom	Nsit Ibom	Mbaiso V	4.808699	7.877029
3812	Benue	Ushongo	Mbagwe	7.184652	8.909273
3813	Oyo	Oyo East	Oke Apo	7.860183	3.965933
3814	Jigawa	Babura	Garu	12.585164	8.791270
3815	Osun	Ejigbo	Ilawo/Isoko/Isundunrin	7.860630	4.266147
3816	Anambra	Orumba North	Amaokpala / Omogho	6.068014	7.113109
3817	Abia	Ohafia	Isiama Ohafia	5.662265	7.791683
3818	Delta	Ukwuani	Ebedei	5.842816	6.248875
3819	Zamfara	Maru	Mayanchi	12.339407	6.262147
3820	Delta	AniochaS	Ubulu Okiti	6.281016	6.524598
3821	Akwa Ibom	Eket	Okon I	4.673990	7.910862
3822	Yobe	Nangere	Nangere	11.833018	11.092201
3823	Rivers	Port Harcourt	Mgbundukwu (One)	4.775086	7.002477
3824	Kano	Madobi	Cinkoso	11.800202	8.284108
3825	Federal Capital Territory	Kwali	Pai	8.877767	7.008951
3826	Benue	Oju	Ukpa/Ainu Ette	6.926816	8.440282
3827	Osun	Ilesha East	Biladu	7.567421	4.732884
3828	Cross River	Obubra	Ofumbongha/Yala	6.069228	8.398623
3829	Sokoto	Tureta	Fura Girke	12.591069	5.499313
3830	Kebbi	Suru	Dakingari	11.617008	4.108644
3831	Gombe	Dukku	Wuro Tale	10.948246	10.768597
3832	Anambra	Awka South	Awka  IV	6.215726	7.068155
3833	Anambra	Anaocha	Agulu Uzoigbo	6.032169	7.006808
3834	Anambra	Aguata	Achina II	5.942151	7.110574
3835	Kaduna	Kaduna North	Kwarau	10.688108	7.554257
3836	Sokoto	Shagari	Jaredi	12.733619	5.142244
3837	Niger	Muya	Gini	9.720030	6.915141
3838	Yobe	Nangere	Dadiso / Chukuriwa	11.971016	10.954662
3839	Osun	Ilesha East	Imo	7.603589	4.791948
3840	Jigawa	Maigatari	Galadi	12.763862	9.599417
3841	Benue	Oju	Idelle	6.812446	8.196502
3842	Oyo	Afijio	Fiditi II	7.700691	3.905965
3843	Ogun	Obafemi-Owode	Owode	6.797920	3.415208
3844	Kogi	Lokoja	Kupa North East	8.260362	6.503146
3845	Kebbi	Birnin Kebbi	Nassarawa I	12.455353	4.221509
3846	Enugu	Ezeagu	Obe agu Umana	6.337361	7.339687
3847	Adamawa	Fufore	Karlahi	8.882869	12.606047
3848	Rivers	Ogba/Egbema/Andoni	Igburu	5.306612	6.688442
3849	Oyo	Atiba	Oke-afin I	7.906031	3.937242
3850	Akwa Ibom	Ika	Odoro II	4.989525	7.486355
3851	Jigawa	Maigatari	Balarabe	12.609010	9.524577
3852	Akwa Ibom	Nsit Ibom	Mbaiso IV	4.832905	7.879505
3853	Niger	Agwara	Gallah	10.697558	4.431676
3854	Nassarawa	Nassarawa Egon	Kagbu Wana	8.738847	8.407277
3855	Anambra	Onitsha South	Odoakpu  III	6.079327	6.752449
3856	Edo	Esan North East	Uzea	6.824713	6.456960
3857	Kogi	Omala	Bagana	7.960559	7.463836
3858	Katsina	Daura	Tudun Wada	12.989229	8.299092
3859	Kaduna	Birnin Gwari	Gayam	10.746382	6.666876
3860	Ogun	Ewekoro	Mosan	6.961924	3.206268
3861	Zamfara	Maru	Kuyan Bana	11.152006	6.291172
3862	Rivers	Gokana	Yeghe I	4.695282	7.327637
3863	Imo	Orsu	Okwufuruaku	5.832374	6.979588
3864	Kaduna	Jema'a	Kaninkon	9.481266	8.299912
3865	Ekiti	Ekiti West	Okemesi I	7.828193	4.937545
3866	Federal Capital Territory	Bwari	Igu	9.274341	7.511396
3867	Abia	Ikwuano	Oboro III	5.399574	7.536665
3868	Lagos	Mushin	Idi-Oro/Odi-Olowu	6.547248	3.352429
3869	Rivers	Omumma	Obibi/Ajuloke Community	5.035204	7.164990
3870	Akwa Ibom	Ibiono Ibom	Ibiono Western I	5.142960	7.890439
3871	Osun	Ede North	Bara Ejemu	7.702789	4.464594
4488	Jigawa	Miga	Koya	12.220899	9.830459
3872	Bauchi	Damban	Gargawa	11.709494	10.820222
3873	Cross River	Odukpani	Akamkpa	5.113189	8.118478
3874	Ondo	Ose	Ikaro/Elegbeka	7.081781	5.751996
3875	Oyo	Atisbo	Irawo Owode	8.502321	3.400665
3876	Enugu	Udi	Eke	6.473452	7.311136
3877	Akwa Ibom	Ikot Abasi	Ukpum Ete II	4.561756	7.630849
3878	Delta	Sapele	Sapele  Urban  III	5.886842	5.679690
3879	Lagos	Ikorodu	Imota II	6.669669	3.660457
3880	Osun	Ola-Oluwa	Telemu	7.648948	4.250112
3881	Oyo	Ibarapa East	Isaba	7.470328	3.492681
3882	Enugu	Ezeagu	Ulo/Amagu/Umulokpa II	6.454005	7.109871
3883	Zamfara	Maradun	Kaya	12.757922	6.398306
3884	Anambra	Anaocha	Neni  I	6.055673	6.981113
3885	Abia	Umuahia South	Old Umuahia	5.439087	7.462363
3886	Taraba	Bali	Badakoshi	8.212758	11.080074
3887	Niger	Lavun	Batati	9.166338	5.725941
3888	Benue	Oju	Ibilla	6.878430	8.400213
3889	Delta	Warri South-West	Madangho	5.586327	5.262950
3890	Rivers	Ogu/Bolo	Ogu  VI	4.624476	7.164831
3891	Benue	Ado	Ulayi	6.738956	8.024525
3892	Anambra	Nnewi South	Ebenator	5.919486	6.919685
3893	Delta	IkaNorth	Owa  V	6.221997	6.190273
3894	Anambra	Oyi	Awkuzu  IV	6.236912	6.912694
3895	Akwa Ibom	Nsit Ubium	Ubium North III	4.798907	7.964126
3896	Ondo	Ondo West	Ifore/Odosida/Loro	6.919287	4.743121
3897	Kogi	Igalamela-Odolu	Ajaka II	7.141939	6.832347
3898	Borno	Chibok	Korongilim	10.859136	12.702959
3899	Ebonyi	Ikwo	Ndufu Amagu I	6.041397	8.111770
3900	Katsina	Charanchi	Tsakatsa	12.571709	7.682318
3901	Ebonyi	Ohaozara	Okposi Achara	5.964240	7.777111
3902	Nassarawa	Wamba	Mangar	9.126837	8.714727
3903	Cross River	Bakassi	Ekpot Abia	4.713543	8.518986
3904	Akwa Ibom	Etinan	Northern Iman II	4.908152	7.835286
3905	Adamawa	Girie	Jera Bakari	9.468659	12.616352
3906	Kano	Fagge	Sabongari West	11.991593	8.562942
3907	Delta	Ndokwa West	Emu	5.652610	6.295418
3908	Ondo	Akoko South-West	Oka II B Okia/Korowa/Simerin/Uba	7.490662	5.789631
3909	Jigawa	Gwiwa	Korayel	12.764129	8.184808
3910	Cross River	Odukpani	Ikoneto	5.039008	8.115251
3911	Kwara	Edu	Lafiagi II	8.627107	5.456342
3912	Rivers	Ahoada West	Ubie IV	5.134258	6.539651
3913	Anambra	Anaocha	Agulu   IV	6.059756	7.020184
3914	Benue	Vandeikya	Mbagbera	6.797262	9.094518
3915	Jigawa	Kazaure	Unguwar Yamma	12.652241	8.409917
3916	Lagos	Ibeju/Lekki	S1, (Lekki I)	6.481704	3.698481
3917	Kano	Dawakin Kudu	Dosan	11.770552	8.709400
3918	Ogun	Abeokuta North	Isaga Ilewo	7.132944	3.153881
3919	Delta	Bomadi	Ogriagbene	5.188043	5.893421
3920	Nassarawa	Karu	Karshi II	8.787458	7.633501
3921	Bauchi	Gamjuwa	Nasarawa North	10.776770	10.186984
3922	Kaduna	Kaduna North	Unguwan Liman	10.495609	7.448407
3923	Edo	Oredo	Gra/Etete	6.185741	5.508509
3924	Borno	Chibok	Chibok Wuntaku	10.866328	12.796565
3925	Ogun	Ado Odo-Ota	Igbesa	6.558394	3.082847
3926	Gombe	Kaltungo	Awak	9.959071	11.539240
3927	Akwa Ibom	Onna	Awa I	4.671031	7.831483
3928	Taraba	Ussa	Kpambo Puri	7.006337	10.040208
3929	Taraba	Jalingo	Sintali	8.873611	11.431994
3930	Lagos	Oshodi/Isolo	Mafoluku	6.568762	3.323620
3931	Zamfara	Talata-Mafara	Shiyar Galadima	12.484168	6.099635
3932	Adamawa	Mubi North	Lokuwa	10.257848	13.332116
3933	Rivers	Ogba/Egbema/Andoni	Omoku  Town I	5.357519	6.630798
3934	Delta	Warri North	Koko II	5.970246	5.484437
3935	Kebbi	Birnin Kebbi	Gawasu	12.531916	4.212606
3936	Rivers	Okrika	Ogoloma I	4.685573	7.116991
3937	Ekiti	Oye	Ilupeju II	7.796474	5.353756
3938	Oyo	Ibarapa North	Igangan I	7.637040	3.070438
3939	Enugu	EnuguSou	Amechi II	6.392288	7.525368
3940	Ebonyi	Ebonyi	Abofia	6.567595	8.119330
3941	Kano	Gezawa	Jogana	12.009813	8.702106
3942	Delta	IkaNorth	Igbodo	6.329978	6.355096
3943	Kano	Warawa	Danlasan	11.844384	8.775610
3944	Kano	Madobi	Kubaraci	11.783451	8.355320
3945	Benue	Ado	Ukwonyo	6.950048	7.981572
3946	Cross River	Boki	Buda	6.446770	8.918044
3947	Enugu	Aninri	Ndeabo	6.028999	7.551254
3948	Cross River	Yakurr	Ikpakapit	5.820630	8.114050
3949	Kwara	Baruten	Boriya/Shiya	9.330394	3.356994
3950	Sokoto	Silame	Kubodu South	12.954118	4.927667
3951	Kogi	Adavi	Nagazi Farm Center	7.561393	6.241773
3952	Anambra	Anambra East	Igbariam	6.394412	6.936632
3953	Katsina	Musawa	Kurkujan 'B'	12.120780	7.752487
3954	Abia	Umuahia North	Umuhu	5.625407	7.422176
3955	Zamfara	Gusau	Mada	12.149040	7.020614
3956	Nassarawa	Wamba	Jimiya	8.956164	8.803912
3957	Akwa Ibom	Ikono	Ikono Middle II	5.272688	7.701673
3958	Zamfara	Kaura-Namoda	Kungurki	12.608023	6.508204
3959	Anambra	Ihiala	Uli  I	5.820673	6.879609
3960	Kano	Gabasawa	Yumbu	12.263066	8.811777
3961	Ogun	Egbado North	Ijoun	7.337899	2.786126
3962	Kano	Rano	Dawaki	11.514931	8.530201
3963	Imo	Nkwerre	Nkwerre IV (Umunubo/Umunachi)	5.721289	7.090744
3964	Lagos	Mushin	Papa-Ajao	6.560485	3.334086
3965	Lagos	Mushin	Ojuwoye	6.555416	3.347281
3966	Jigawa	Gwaram	Maruta	11.378686	9.817625
3967	Kogi	Koton-Karfe	Girinya	8.189412	6.748070
3968	Enugu	Udenu	Obollo-Eke	6.836898	7.637436
3969	Oyo	Orelope	Aare	8.842281	3.760145
3970	Nassarawa	Keana	Kadarko	8.190968	8.562676
3971	Kebbi	Kalgo	Zuguru	12.317445	4.101640
3972	Imo	Nkwerre	Nnanano (Nkwerre II)	5.708106	7.091182
3973	Abia	Isuikwuato	Ikeagha I	5.831400	7.491665
3974	Kebbi	Yauri	Yelwa West	10.914339	4.743750
3975	Rivers	Andoni/Odual	Unyen Gala	4.482595	7.394274
3976	Osun	Osogbo	Otun Hagun B	7.746193	4.576714
3977	Jigawa	Jahun	Gauza Tazara	12.067564	9.728721
3978	Katsina	Kafur	Gozaki	11.445795	7.602660
3979	Nassarawa	Keffi	Yara	8.837114	7.881756
3980	Plateau	Kanam	Gagdi	9.585556	9.857784
3981	Katsina	Mashi	Doguru 'A'	13.179446	8.033922
3982	Rivers	Etche	Ulakwo	5.013733	7.075760
3983	Kebbi	Arewa	Falde	12.611709	3.794677
3984	Oyo	Ibarapa Central	Iberekodo I /(Pataoju)	7.371640	3.283851
3985	Ekiti	Ekiti West	Aramoko III/Erio	7.773569	4.957583
3986	Zamfara	Tsafe	Danjibga/Kunchin - Kalgo	11.760716	6.852619
3987	Ogun	Ijebu-Ode	Itamapako	6.729377	3.958474
3988	Cross River	Etung	Abia	5.949987	8.915006
3989	Katsina	Safana	Babban Duhu 'B'	12.616522	7.136214
3990	Niger	Shiroro	Kushaka/Kurebe	10.475620	6.837240
3991	Jigawa	Birnin Kudu	Kangire	11.521890	9.470165
3992	Osun	Ejigbo	Inisa II/Afaake/Ayegunle	7.767747	4.310978
3993	Gombe	Kwami	Malam Sidi	10.515690	11.353981
3994	Anambra	Anambra West	Nzam	6.460845	6.730247
3995	Ondo	Akoko North-East	Ikado II	7.544195	5.763777
3996	Kaduna	Sabon Gari	Chikaji	11.125967	7.713186
3997	Borno	Bama	Shehuri / Hausari / Mairi	11.500951	13.699633
3998	Katsina	Zango	Garni	12.872267	8.496963
3999	Imo	Unuimo	Umucheke	5.766922	7.259786
4000	Imo	Ideato South	Ntueke	5.813354	7.149393
4001	Kogi	Ofu	Ejule Allah	7.391899	7.072497
4002	Katsina	Dandume	Dandume B	11.498061	7.127655
4003	Enugu	Enugu North	Ogui Township	6.444476	7.489896
4004	Bayelsa	Ogbia	Ologi	4.795004	6.220404
4005	Katsina	Faskari	Faskari	11.731253	7.019712
4006	Imo	Owerri Municipal	GRA	5.514787	7.026396
4007	Taraba	Gassol	Mutum Biyu II	8.634705	10.773403
4008	Kebbi	Zuru	Senchi	11.375512	5.297721
4009	Benue	Gwer East	Mbabur	7.367492	8.514518
4010	Ebonyi	Izzi	Agbaja Anyanwuigwe	6.578465	8.193237
4011	Jigawa	Gagarawa	Gagarawa Tasha	12.415071	9.534445
4012	Enugu	Enugu North	New Haven	6.467862	7.579620
4013	Rivers	Obio/Akpor	Rumuokwu (2B)	4.869299	7.075538
4014	Plateau	Langtang North	Waroh	9.234203	9.724798
4015	Anambra	Awka North	Ebenebe  II	6.344147	7.100298
4016	Plateau	Bokkos	Daffo	9.241844	8.841387
4017	Abia	Umuahia South	Ubakala  'B'	5.461258	7.415810
4018	Niger	Tafa	Wuse  East	9.322631	7.241998
4019	Cross River	Abi	Ekureku II	5.949384	8.018234
4020	Ogun	Odogbolu	Imodi	6.874820	3.785232
4021	Lagos	Badagary	Ilogbo-Araromi	6.494788	3.045955
4022	Anambra	Anaocha	Agulu  II	6.085471	7.018360
4023	Yobe	Fune	Kollere/Kafaje	11.909050	11.224182
4024	Delta	Udu	Ovwian II	5.469493	5.805692
4025	Ondo	Ose	Idogun	7.288194	5.904879
4026	Kano	Warawa	Imawa	11.882002	8.772939
4027	Katsina	Funtua	Mai Gamji	11.459417	7.306228
4028	Yobe	Fika	Gadaka/Shembire	11.362627	11.259275
4029	Kaduna	Kaduna South	Barnawa	10.455077	7.436029
4030	Ebonyi	Abakalik	Amachi (Ndebo)	6.290875	8.229508
4031	Taraba	Sardauna	Gembu 'B'	6.738700	11.198052
4032	Ebonyi	Abakalik	Azuiyi Udene	6.312300	8.131398
4033	Kogi	Yagba West	Oke Egbe II	8.218929	5.579068
4034	Edo	Owan West	Sobe	6.843121	5.772149
4035	Delta	IsokoSou	Irri  II	5.476979	6.296778
4036	Kwara	Oyun	Ojoku	8.283708	4.674894
4037	Kogi	Lokoja	Lokoja-E	7.924050	6.712687
4038	Katsina	Mashi	Gallu	13.125931	8.055339
4039	Akwa Ibom	Etim Ekpo	Etim Ekpo III	4.997217	7.585310
4040	Bayelsa	Brass	Brass I	4.344007	6.323208
4041	Oyo	Itesiwaju	Igbojaiye	8.223040	3.289668
4042	Plateau	Jos South	Du	9.739830	8.851772
4043	Oyo	Ibadan North West	Ward 9 NW6	7.390936	3.872720
4044	Bauchi	Ningi	Bashe	11.166201	8.980851
4045	Abia	Ukwa West	Ogwe	5.005595	7.268888
4046	Osun	IfeCentral	Iremo II (Eleyele)	7.443802	4.595332
4047	Ebonyi	Ishielu	Obeagu	6.603489	7.736122
4048	Abia	Oboma Ngwa	Mgboko Umuanunu	5.250864	7.507639
4049	Oyo	Itesiwaju	Ipapo	8.100346	3.471509
4050	Rivers	Eleme	Alesa	4.780498	7.111807
4051	Jigawa	Biriniwa	Batu	12.802140	10.095873
4052	Kogi	Yagba East	Ejuku	8.126124	5.686318
4053	Imo	Oguta	Obudi/Aro	5.561160	6.927228
4054	Borno	Konduga	Mairamri / Yeleri / Bazamri	11.706639	13.504876
4055	Nassarawa	Keana	Amiri	8.193330	8.873950
4056	Jigawa	Garki	Jirima	12.322015	8.903388
4057	Anambra	Ihiala	Amorka	5.764041	6.876704
4058	Kwara	Ilorin West	Ubandawaki	8.453511	4.533432
4059	Abia	Osisioma	Aro - Ngwa	5.222512	7.329186
4060	Anambra	Awka North	Isu Aniocha	6.255814	7.012931
4061	Katsina	Bindawa	Yangora	12.804066	7.913387
4062	Adamawa	Hong	Mayo Lope	10.237930	13.184061
4063	Borno	Magumeri	Hoyo / Chin Gowa	11.994274	12.932174
4064	Kebbi	Birnin Kebbi	Godongaji	12.473049	4.258330
4065	Borno	Shani	Kubo	10.087536	12.157503
4066	Yobe	Tarmuwa	Barkami / Bulturi	12.281658	11.936081
4067	Borno	Jere	Mairi	11.765263	13.297395
4068	Borno	Mafa	Abbari	12.036930	13.744186
4069	Niger	Tafa	Zuma East	9.191882	7.205050
4070	Edo	Igueben	Uhe/Idumuogbo/Idumueke	6.595242	6.263047
4071	Ekiti	Ido-Osi	Ayetoro II	7.898983	5.149396
4072	Adamawa	Maiha	Belel	9.611956	13.226122
4073	Delta	IsokoSou	Emede	5.409916	6.205289
4074	Kwara	Ekiti	Obbo-Ile	8.087173	5.370743
4075	Yobe	Fika	Daya/Chana	11.482098	11.022273
4076	Kano	Minjibir	Kuru	12.157251	8.514068
4077	Yobe	Geidam	Asheikri	12.919691	11.932468
4078	Ebonyi	Ohaozara	Ene- Na - Ezeraku	6.022037	7.853748
4079	Federal Capital Territory	Kuje	Gaube	8.767438	7.253497
4080	Akwa Ibom	Okobo	Offi II	4.793454	8.164817
4081	Oyo	Iwajowa	Iwere-Ile I	8.110956	3.087375
4082	Kwara	Ifelodun	Ora	8.417954	5.147381
4083	Katsina	Danmusa	Dandire 'B'	12.298205	7.188283
4084	Akwa Ibom	Mkpat Enin	Ibiaku II	4.823972	7.774914
4085	Taraba	Yorro	Pantisawa I	8.990926	11.537501
4086	Katsina	Dutsi	Ruwankaya A	12.876210	8.208804
4087	Enugu	Igbo-Eti	Diogbe/Umunko	6.680431	7.462623
4088	Delta	Ughelli North	Orogun   I	5.625451	6.152328
4089	Akwa Ibom	Nsit Ibom	Mbaiso I	4.851595	7.900788
4090	Borno	Kaga	Tobolo	11.578340	12.621312
4091	Adamawa	Yola North	Limawa	9.286094	12.520123
4092	Jigawa	Kazaure	Kanti	12.611379	8.394192
4093	Ogun	Egbado North	Ido Foi	7.388173	2.898956
4094	Adamawa	Lamurde	Opalo	9.526658	11.904801
4095	Delta	Ughelli South	Ekakpamre	5.525818	5.873428
4096	Adamawa	Yola North	Gwadabawa	9.249203	12.547108
4097	Nassarawa	Awe	Azara	8.343537	9.476468
4098	Imo	Okigwe	Ndimoko Ofeimo/Ibinta/Okanachi/Umuowa Ibu	5.905476	7.249847
4099	Imo	Oru-West	Aji	5.763480	6.940052
4100	Ondo	Ondo West	Okeagunla Okerowo/Okekuta	7.070863	4.820846
4101	Kano	Nasarawa	Gwagwarwa	12.013056	8.485458
4102	Zamfara	Zurmi	Rukudawa	12.724668	6.929074
4103	Niger	Bida	Kyari	9.087072	6.016544
4104	Oyo	Iwajowa	Agbaakin II	7.970573	3.193840
4105	Kano	Kiru	Tsaudawa	11.673657	8.190777
4106	Rivers	Eleme	Agbonchia	4.813736	7.136476
4107	Taraba	Sardauna	Ndum-Yaji	6.622042	11.129767
4108	Edo	Akoko Edo	Ibillo/ Ekpesa/ Ekor/ Ikiran-Ile/ Oke	7.449656	6.032964
4109	Kwara	Oke-Ero	Imoji/Ilale/Erinmope	8.036383	5.162736
4110	Edo	Owan East	IHIEVBE I	7.025603	6.102848
4111	Katsina	Kaita	Dankaba	13.234196	7.783094
4112	Rivers	Port Harcourt	Abuloma/Amadi-Ama	4.775713	7.070803
4113	Zamfara	Zurmi	Zurmi	12.794258	6.751305
4114	Ebonyi	Ebonyi	Abakpa	6.428815	8.085823
4115	Bayelsa	Nembe	Igbeta-Ewoama/Fantuo	4.500227	6.243956
4116	Imo	Ihitte-Uboma Isinweke	Awuchinumo	5.637660	7.387347
4117	Borno	Gwoza	Dure / Wala / Warabe	11.256657	13.646957
4118	Rivers	Khana	Bargha	4.726635	7.499958
4119	Oyo	Ibadan North West	Ward 2 NI (Part II)	7.380829	3.903610
4120	Zamfara	Zurmi	Dauran / Birnin-Tsaba	12.672256	6.754140
4121	Imo	Isu	Amurie Omanze II	5.661668	7.063327
4122	Anambra	Nnewi South	Ezinifite	5.913764	6.936294
4123	Zamfara	Gusau	Rijiya	12.098483	6.738292
4124	Osun	Ila	Iperin	8.047165	4.934909
4125	Ogun	Ogun Waterside	Ayede/Lomiro	6.407899	4.384356
4126	Kano	Kunchi	Gwarmai	12.326978	8.325333
4127	Imo	Isu	Ekwe I	5.676428	7.065232
4128	Sokoto	Sokoto North	Magajin gari B	13.073959	5.263981
4129	Taraba	Bali	Gangtiba	8.444229	11.644309
4130	Osun	Oriade	Erinmo/Iwaraja	7.610799	4.860964
4131	Kogi	Omala	Bagaji	7.957851	7.598709
4132	Plateau	Bassa	Kadamo	10.164295	8.785508
4133	Osun	Ife North	Famia	7.286227	4.463470
4134	Oyo	Ibarapa Central	Oke-Odo	7.397303	3.191814
4135	Kaduna	Jaba	Daddu	9.567329	8.111398
4136	Abia	Oboma Ngwa	Ibeme	5.061516	7.504590
4137	Ebonyi	Onicha	Oguduokwo Oshiri	6.127274	7.892623
4138	Borno	Ngala	Ndufu	12.114364	14.386541
4139	Cross River	Bakassi	Odiong	4.724637	8.501892
4140	Adamawa	Ganye	Ganye I	8.365979	12.057286
4141	Zamfara	Zurmi	Kuturu/Mayasa	12.912903	6.749647
4142	Enugu	Enugu East	Ugwugo Nike	6.598341	7.501647
4143	Benue	Vandeikya	Mbakaange	6.778781	9.012228
4144	Oyo	Ona-Ara	Olode/Gbedun/Ojebode	7.213149	4.054265
4145	Adamawa	Fufore	Yadim	8.922211	12.365822
4146	Rivers	Ahoada East	Uppata  V	4.926094	6.631858
4147	Edo	Owan West	Sabongida/Ora/Ogbeturu	6.843244	5.870926
4148	Federal Capital Territory	Kuje	Kwaku	8.721659	7.149228
4149	Ogun	Shagamu	Ode-Lemo	6.683153	3.431184
4150	Osun	Orolu	Olufon Orolu  'A'	7.862331	4.478988
4151	Oyo	Lagelu	Lalupon II	7.481573	4.054951
4152	Ondo	IleOluji/Okeigbo	Oke-igbo II	7.210606	4.959175
4153	Kogi	Yagba West	Ogbe	8.031390	5.553193
4154	Yobe	Potiskum	Bare-Bare/Bauya/Lalai Dumbulwa	11.664170	11.082296
4155	Bauchi	Misau	Zadawa	11.458585	10.365204
4156	Kwara	Baruten	Kenu/Taberu	8.979653	2.839089
4157	Katsina	Musawa	Kira	12.179595	7.807841
4158	Jigawa	Kiyawa	Tsurma	11.880867	9.509023
4159	Anambra	Oyi	Nteje  II	6.272728	6.917121
4160	Kogi	Yagba West	Odo Ere Oke Ere	8.167374	5.557578
4161	Lagos	Alimosho	Ayobo/Ijon Village (Camp David)	6.589958	3.211960
4162	Nassarawa	Toto	Kanyehu	8.222360	7.128092
4163	Oyo	Saki West	Okere I	8.547869	3.257095
4164	Lagos	Mushin	Itire	6.532724	3.327257
4165	Oyo	Ibadan North West	Ward 5 NW3 (Part I)	7.384978	3.889486
4166	Jigawa	Guri	Dawa	12.635372	10.393249
4167	Sokoto	Kware	Tsaki/ Walake'e	13.025003	5.325432
4168	Lagos	Lagos Island	Iduntafa	6.467352	3.394455
4169	Anambra	Orumba South	Umunze III	5.985455	7.241441
4170	Zamfara	Kaura-Namoda	Kagara	12.390927	6.684693
4171	Abia	Ohafia	Ebem Ohafia	5.597910	7.793219
4172	Jigawa	Kiyawa	Maje	11.922755	9.600795
4173	Edo	Uhunmwonde	Isi North	6.406390	6.053078
4174	Taraba	Ibi	Sarkin Kudu II	8.210608	9.656329
4175	Niger	Rijau	Rijau	11.117197	5.248792
4176	Abia	Arochukwu	Arochukwu I	5.388028	7.908423
4177	Nassarawa	Keana	Agaza	8.269123	8.817527
4178	Ebonyi	Ikwo	Enyibichiri	6.163719	8.257340
4179	Sokoto	Rabah	Gawakuke	13.099236	5.427002
4180	Oyo	Oluyole	Orisunbare/Ojo-Ekun	7.265756	3.806236
4181	Borno	Shani	Buma	10.164832	11.878974
4182	Kwara	Moro	Womi/Ayaki	8.788162	4.468368
4183	Rivers	Okrika	Ogoloma III	4.674990	7.094708
4184	Oyo	Ogo-Oluwa	Otamokun	7.947457	4.203349
4185	Delta	Warri North	Gbokoda	5.899755	5.096896
4186	Plateau	Qua'anpa	Namu	8.670623	9.045913
4187	Gombe	Kaltungo	Tula Baule	9.887224	11.616647
4188	Plateau	Wase	Danbiram	9.118598	9.969427
4189	Akwa Ibom	Ikono	Nkwot II	5.279124	7.786509
4190	Lagos	Alimosho	Egbeda/Alimosho	6.610367	3.283853
4191	Akwa Ibom	Oruk Anam	Ibesit	4.855973	7.721016
4192	Osun	Isokan	Osa Ikoyi (Oloke)	7.319423	4.165475
4193	Kano	Ungogo	Karo	12.099452	8.506646
4194	Zamfara	Shinkafi	Galadi	13.021202	6.364347
4195	Osun	Odo Otin	Ijabe/Ila Odo	7.988412	4.734613
4196	Ondo	Akoko South-West	Supare II	7.460309	5.656950
4197	Ogun	Egbado North	Iboro/Joga	7.058557	2.998237
4198	Oyo	Ibadan North West	Ward 4 NW2	7.381591	3.887974
4199	Sokoto	Silame	Kubodu North	12.981635	4.995889
4200	Jigawa	Ringim	Tofa	12.164973	9.054685
4201	Ebonyi	Izzi	Ezza Inyimagu - Iziogo	6.677111	8.250741
4202	Kano	Gwale	Kabuga	11.971875	8.457312
4203	Osun	Ife North	Edunabon  I	7.513418	4.527621
4204	Jigawa	Gumel	Kofar Yamma	12.640238	9.389539
4205	Niger	Paikoro	Chimbi	9.465620	7.005701
4206	Oyo	Ona-Ara	Olorunsogo	7.346286	3.943485
4207	Rivers	Khana	Opuoko/Kalaoko	4.683784	7.495613
4208	Ebonyi	Ikwo	Inyimagu II	6.063010	8.248359
4209	Ogun	Ijebu North	Ago Iwoye II	6.913397	3.839610
4210	Katsina	Kafur	Yari bori	11.628514	7.574348
4211	Akwa Ibom	Udung Uko	Udung Uko X	4.762973	8.213435
4212	Borno	Monguno	Mintar	12.503815	13.582486
4213	Kano	Shanono	Faruruwa	12.210989	7.871961
4214	Rivers	Gokana	K-Dere I	4.667543	7.261794
4215	Kebbi	Sakaba	Gelwasa	11.304239	5.374436
4216	Oyo	Surulere	Arolu	7.989178	4.457621
4217	Kano	Bichi	Bichi	12.190727	8.193985
4218	Kwara	Ilorin East	Zango	8.532862	4.603449
4219	Enugu	EnuguSou	Amechi I	6.382441	7.501711
4220	Enugu	Oji-River	Achiuno II	6.146550	7.361108
4221	Sokoto	Dange-Shuni	Rudu/Amanawa	12.848556	5.362803
4222	Edo	Ovia North East	Isiuwa	6.537097	5.637106
4223	Delta	Burutu	Ojobo	5.136516	5.535152
4224	Lagos	Epe	Ejirin	6.633460	3.850089
4225	Kogi	Yagba East	Ponyan	7.931165	5.669746
4226	Delta	IkaNorth	Owa I	6.143868	6.219674
4227	Zamfara	Anka	Dan Galadima	12.052879	5.923641
4228	Oyo	Ori-Ire	Ori Ire VI	8.540172	4.112789
4229	Akwa Ibom	Abak	Midim II	5.011003	7.693643
4230	Ogun	Shagamu	Ibido/Ituwa/Alara	6.900092	3.596365
4231	Niger	Wushishi	Tukunji/Yamigi	9.606661	5.762036
4232	Cross River	Odukpani	Creek Town I	4.973118	8.189701
4233	Oyo	Irepo	Ikolaba	9.100362	3.787456
4234	Yobe	Yusufari	Alanjirori	13.136516	11.142822
4235	Kwara	Ilorin South	Oke-Ogun	8.479821	4.608540
4236	Sokoto	Bodinga	Dingyadi/Badawa	12.929913	5.138999
4237	Kaduna	Igabi	Gadan Gayan	10.716007	7.759740
4238	Lagos	Oshodi/Isolo	Sogunle	6.591660	3.333478
4239	Enugu	EnuguSou	Awkunanaw West	6.399537	7.498550
4240	Enugu	EnuguSou	Ugwuaji	6.404604	7.553236
4241	Kebbi	Suru	Dendane	11.972603	4.181380
4242	Abia	Ukwa West	Obokwe	5.020086	7.236076
4243	Kaduna	Kubau	Haskiya	10.987592	8.469318
4244	Kogi	Koton-Karfe	Odaki-Koton-Karfe	8.133682	6.955937
4245	Kogi	Kabba-Bunu	Okedayo	7.689461	6.174029
4246	Rivers	Ahoada East	Uppata II	4.995909	6.559956
4247	Ogun	Abeokuta South	Itoko	7.192752	3.347223
4248	Kano	Rano	Madachi	11.573887	8.584915
4249	Benue	Konshisha	Mbanor	6.967945	8.865676
4250	Ogun	Egbado North	Aye Toro II	7.227618	2.878551
4251	Gombe	Gombe	Nasarawa	10.298004	11.257585
4252	Ebonyi	Izzi	Ezza Inyimagu - Igweledoha	6.626736	8.255264
4253	Edo	Etsako East	Three Ibies	7.217549	6.441769
4254	Kano	Tundun Wada	Burumburum	11.393755	8.718123
4255	Adamawa	Mayo-Belwa	Mayo-Belwa	8.981827	12.154040
4256	Oyo	Ona-Ara	Araromi/Aperin	7.143515	4.044605
4257	Ogun	Egbado South	Iwoye	6.821543	2.834831
4258	Delta	IsokoSou	Uzere	5.334092	6.234113
4259	Benue	Ushongo	Mbaanyam	7.165619	9.004938
4260	Benue	Buruku	Mbaityough	7.203954	9.140566
4261	Anambra	Orumba North	Ajalli  I (Obinikpa and Umueve)	6.042864	7.211895
4262	Oyo	Ibadan North	Ward X, N6B PART II	7.412794	3.904472
4263	Kaduna	Sanga	Nandu	9.241858	8.488862
4264	Akwa Ibom	Oruk Anam	Ekparakwa	4.816162	7.728867
4265	Niger	Wushishi	Kwata	9.776625	6.061433
4266	Kebbi	Koko/Bes	Zariya Kalakala/Amiru	11.268275	4.322169
4267	Katsina	Dutsin-M	Dabawa	12.512737	7.459141
4268	Rivers	Port Harcourt	Port Harcourt VII	4.709525	7.061251
4269	Katsina	Kusada	Yashe 'B'	12.360465	7.913719
4270	Kebbi	Augie	Augie South	12.910267	4.613045
4271	Jigawa	Gumel	Garin Gambo	12.641620	9.412380
4272	Adamawa	Teungo	Kiri I	8.139167	11.913254
4273	Kano	Rimin Gado	Rimin Gado	11.954081	8.257523
4274	Gombe	Yalmatu / Deba	Nono / Kunwal / W. Birdeka	10.166484	11.419948
4275	Kogi	Ankpa	Enjema IV	7.590923	7.714223
4276	Kano	Dambatta	Gwanda	12.552034	8.568569
4277	Yobe	Jakusko	Zabudum / Dachia	12.714330	10.796425
4278	Kebbi	Bagudo	Matsinka/Geza	11.449736	4.291478
4279	Oyo	Atiba	Agunpopo I	7.916439	3.965061
4280	Kano	Rimin Gado	Yalwan Danziyal	11.946092	8.291051
4281	Imo	Ideato South	Ogboko II	5.801925	7.162631
4282	Kano	Dawakin Tofa	Marke	12.114435	8.252242
4283	Enugu	Nsukka	Eha-Ndiagu	6.789732	7.532309
4284	Anambra	Ihiala	Okija  II	5.874398	6.873318
4285	Niger	Mokwa	Mokwa	9.317868	4.995915
4286	Rivers	Opobo/Nkoro	Kalaibiama I	4.524393	7.502277
4287	Ekiti	Moba	Ikun I	7.984036	5.189699
4288	Kebbi	Kalgo	Dangoma/Gayi	12.180910	4.136813
4289	Katsina	Charanchi	Ganuwa	12.633834	7.647427
4290	Rivers	Obio/Akpor	Worji	4.826666	7.051855
4291	Osun	Orolu	Olufon Orolu 'D'	7.838653	4.478257
4292	Kano	Gabasawa	Mekiya	12.236261	8.897287
4293	Kogi	Yagba West	Oke Egbe I	8.199230	5.470987
4294	Osun	Ilesha East	Bolorunduro	7.576097	4.749903
4295	Ogun	Ado Odo-Ota	Ado Odo II	6.534621	2.956465
4296	Kano	Gezawa	Tsamiya-Babba	11.985701	8.633449
4297	Benue	Gwer West	Gbaange/Tongov	7.766776	8.251994
4298	Benue	Okpokwu	Okpoga North	7.083456	7.767863
4299	Bauchi	Toro	Mara / Palama	10.075316	9.288210
4300	Benue	Oturkpo	Ugboju-Otahe	7.363335	7.981637
4301	Oyo	Lagelu	Sagbe/Pabiekun	7.545724	4.016223
4302	Lagos	Ikeja	Adekunle Vill./Adeniyi Jones/Ogba	6.630802	3.334567
4303	Ebonyi	Ezza North	Okposi Umuoghara	6.320235	7.953235
4304	Anambra	Nnewi North	Umudim  I	5.952701	6.866918
4305	Edo	Owan East	Ivbianion	7.111981	5.920219
4306	Cross River	Ogoja	Ogoja Urban I	6.664018	8.797172
4307	Akwa Ibom	Essien Udim	Ukana East	5.099371	7.731647
4308	Niger	Bida	Mayaki Ndajiya	9.078545	6.004249
4309	Katsina	Kaita	Dankama	13.291895	7.799532
4310	Kebbi	Koko/Bes	Dutsin Mari/Dulmeru	11.213592	4.463598
4311	Kebbi	Koko/Bes	Jadadi	11.576280	4.308668
4312	Bauchi	Tafawa-Balewa	Dull	9.719143	9.813921
4313	Benue	Ogbadibo	Ai-Oodo II	7.023166	7.648011
4314	Oyo	Ibadan North East	Ward VII E6	7.367839	3.917781
4315	Enugu	Igbo-Eti	Ukehe IV	6.615777	7.395470
4316	Kano	Garko	Kafin Malamai	11.640073	8.822101
4317	Akwa Ibom	Okobo	Offi I	4.797625	8.126750
4318	Kebbi	Arewa	Yeldu	12.801069	4.232739
4319	Cross River	Biase	Abayong	5.771946	7.996479
4320	Anambra	Ihiala	Ihite	5.785534	6.797551
4321	Abia	Ohafia	Ndi Elu Nkporo	5.768392	7.728778
4322	Plateau	Langtang North	Pil gani	9.216222	9.881089
4323	Jigawa	Babura	Kanya	12.458769	8.842196
4324	Borno	Marte	Gumna	12.426456	13.794153
4325	Adamawa	Ganye	Sangasumi	8.363673	12.048670
4326	Ogun	Abeokuta North	Elega	7.257015	3.282829
4327	Gombe	Billiri	Todi	9.770320	11.165572
4328	Bauchi	Itas/Gadau	Gadau	11.875476	10.192641
4329	Kano	Dawakin Tofa	Dawanau	12.103158	8.408571
4330	Ekiti	Ekiti West	Ido Ajinare	7.722612	5.009456
4331	Zamfara	Bukkuyum	Zarummai	12.027039	5.670808
4332	Jigawa	Birnin Kudu	Kantoga	11.479957	9.381831
4333	Cross River	Calabar South	Three (3)	4.917029	8.256124
4334	Benue	Buruku	Shorov	7.259543	9.188411
4335	Adamawa	Teungo	Dawo I	8.230435	11.692281
4336	Oyo	Surulere	Igbon/Gambari	8.247381	4.343591
4337	Osun	Ejigbo	Elejigbo 'D'/Ejemu	7.901623	4.324350
4338	Kogi	Ajaokuta	Adodo	7.636622	6.578387
4339	Cross River	Yakurr	Afrekpe/Ekpenti	5.907947	8.144651
4340	Enugu	EnuguSou	Achara Layout east	6.410031	7.490997
4341	Nassarawa	Obi	Duduguru	8.441909	8.635578
4342	Benue	Ogbadibo	Ai-oono II	7.012367	7.687337
4343	Delta	Ndokwa East	Ibrede/Igbuku / Onogbokor	5.544465	6.405603
4344	Osun	Irepodun	Elerin 'E'	7.819746	4.503045
4345	Bauchi	Ningi	Kudu / Yamma	10.950673	9.368516
4346	Kaduna	Sanga	Ninzam West	9.130854	8.414393
4347	Imo	Okigwe	Okigwe II	5.787316	7.301269
4348	Katsina	Mashi	Tamilo 'B'	13.187621	7.935907
4349	Kano	Rogo	Zoza	11.563588	7.884342
4350	Plateau	Mangu	Pushit	9.435292	9.262281
4351	Osun	Irepodun	Elerin 'B'	7.810396	4.496330
4352	Rivers	Eleme	Akpajo	4.802132	7.101071
4353	Osun	Atakumosa East	Faforiji	7.232182	4.754687
4354	Ebonyi	Izzi	Ezza Inyimagu Igbuhu	6.471643	8.218969
4355	Jigawa	Kafin Hausa	Dumadumin Toka	12.075531	9.881022
4356	Rivers	Ahoada East	Akoh  III	5.150136	6.614839
4357	Enugu	Igbo-eze South	Unadu	7.001503	7.320634
4358	Lagos	Shomolu	Igbobi/Fadeyi	6.539380	3.363699
4359	Niger	Shiroro	Egwa/Gwada	9.777125	6.790224
4360	Kebbi	Shanga	Yarbesse	11.284081	4.605799
4361	Rivers	Obio/Akpor	Rumukwuta (8B)	4.841313	6.984845
4362	Rivers	Okrika	Ogoloma II	4.687920	7.124287
4363	Osun	Iwo	Molete  I	7.634108	4.183945
4364	Benue	Tarka	Mbaikyo/Mbayia	7.599920	8.886186
4365	Oyo	Ona-Ara	Badeku	7.309226	4.098155
4366	Kwara	Edu	Tsaragi II	9.082563	4.966833
4367	Imo	Ohaji-Egbema	Egbema 'D'	5.429851	6.786983
4368	Borno	Kaga	Wajiro / Burgumma	11.734984	12.415769
4369	Kebbi	Bunza	Tunga	12.138971	4.030894
4370	Adamawa	Hong	Gaya	10.473183	12.980202
4371	Anambra	Oyi	Umunya  I	6.218648	6.880733
4372	Ogun	Ewekoro	Abalabi	6.910183	3.122072
4373	Kogi	Omala	Abejukolo	7.811223	7.403211
4374	Ekiti	Ido-Osi	Ifaki II	7.778450	5.192477
4375	Bayelsa	Ekeremor	Oyiakiri I	4.963234	5.820769
4376	Nassarawa	Kokona	Dari	8.770856	8.170371
4377	Borno	Chibok	Kautikari	10.808405	13.035724
4378	Kaduna	Ikara	Pala	11.164266	8.430041
4379	Plateau	Kanam	Birbyang	9.496860	10.244711
4380	Plateau	Mangu	Pan Yam	9.431321	9.211924
4381	Ogun	Odogbolu	Obore/Ibido/Ikise	6.751570	3.878335
4382	Oyo	Akinyele	Arulogun/Eniosa/Aroro	7.548322	3.986953
4383	Delta	Ughelli North	Agbarho II	5.595283	5.890707
4384	Delta	Ndokwa West	Utagba  Uno  III	5.910049	6.407961
4385	Borno	Ngala	Wulgo	12.330526	14.230426
4386	Bauchi	Bauchi	Galambi/Gwaskwaram	10.155566	10.140329
4387	Cross River	Etung	Effraya	5.883362	8.748333
4388	Oyo	Ogbomosho South	Arowomole	8.065463	4.259796
4389	Akwa Ibom	Ikot Abasi	Edemaya II	4.629740	7.605533
4390	Enugu	Igbo-eze North	Umuozzi I	7.044464	7.383319
4391	Taraba	Ussa	Kwesati	7.196468	10.201511
4392	Taraba	Bali	Gang Dole	8.324710	11.493814
4393	Borno	Konduga	Sojiri/ Nguro - Nguro	11.572618	13.232145
4394	Kano	Rano	Rurum Sabon-Gari	11.487481	8.436739
4395	Enugu	Igbo-eze South	Iheaka (Ugo Akoyi)	6.902829	7.432302
4396	Edo	Ikpoba-Okha	Obayantor	6.159393	5.620231
4397	Borno	Damboa	Azur/Multe/Forfor	10.940267	12.625992
4398	Akwa Ibom	Uyo	Ikono I	5.029793	7.821791
4399	Kano	Rimin Gado	Butu-Butu	11.946769	8.206601
4400	Osun	Isokan	Idogun Ward	7.253645	4.144282
4401	Katsina	Musawa	Tuge	11.986402	7.592918
4402	Sokoto	Wurno	Kwasare/Sisawa	13.181182	5.380411
4403	Katsina	Mashi	Doguru 'B'	13.198067	7.994585
4404	Borno	Maiduguri	Limanti	11.848890	13.225864
4405	Rivers	Ahoada West	Ediro II	5.065022	6.437266
4406	Imo	Ohaji-Egbema	Egbema 'C'	5.515580	6.838651
4407	Ogun	Remo North	Orile-Oko	6.989811	3.728894
4408	Kebbi	Birnin Kebbi	Gulumbe	12.371153	4.349948
4409	Jigawa	Taura	Ajaura	12.289997	9.531559
4410	Rivers	Asari-Toru	Buguma West	4.734499	6.861679
4411	Jigawa	Hadejia	Sabon Garu	12.452676	10.047943
4412	Akwa Ibom	Ikot Abasi	Edemaya III	4.649902	7.634219
4413	Ondo	Owo	Igboroko I	7.198384	5.583836
4414	Imo	Obowo	Avutu	5.511710	7.381888
4415	Bauchi	Warji	Dagu East	11.123273	9.728338
4416	Bayelsa	Ogbia	Opume	4.668373	6.397037
4417	Federal Capital Territory	Abaji	Abaji Central	8.476076	6.949026
4418	Nassarawa	Akwanga	Akwanga West	8.905100	8.396979
4419	Edo	Orhionmw	Aibiokula II	6.328809	6.057607
4420	Sokoto	Isa	Tidibale	13.196978	6.108666
4421	Delta	IkaNorth	Owa III	6.236296	6.218387
4422	Anambra	Orumba South	Nawfija	6.022896	7.228347
4423	Anambra	Njikoka	Abagana  IV	6.174929	6.942576
4424	Borno	Monguno	Damakuli	12.492301	13.388702
4425	Ogun	Ifo	Oke-Aro/Ibaragun/Robiyan	6.709507	3.341231
4426	Jigawa	Yankwashi	Gurjiya	12.690439	8.607546
4427	Katsina	Daura	Mazoji B	12.994672	8.189362
4428	Anambra	Aguata	Ekwulobia II	5.995369	7.074509
4429	Adamawa	Yola North	Doubeli	9.268652	12.486408
4430	Cross River	Boki	Ekpashi	6.379492	8.749664
4431	Niger	Lavun	Egbako	9.386662	5.795327
4432	Ekiti	Ekiti East	Obadore IV	7.744023	5.646850
4433	Oyo	Ibarapa North	Ofiki I	7.579613	3.163658
4434	Imo	Owerri North	Egbu	5.456021	7.088152
4435	Gombe	Shomgom	Gundale	9.602002	11.088132
4436	Rivers	Andoni/Odual	Ikuru  Town	4.463762	7.478209
4437	Edo	Ikpoba-Okha	Ugbekun	6.310277	5.651831
4438	Jigawa	Roni	Yanzaki	12.556660	8.414494
4439	Osun	Ilesha West	Upper/Lower Igbogi	7.635119	4.741842
4440	Oyo	Iseyin	Koso II	7.920352	3.550737
4441	Plateau	Shendam	Moekat	8.458433	9.588953
4442	Niger	Katcha	Katcha	8.739828	6.248392
4443	Enugu	Enugu East	Mbuluiyiukwu	6.597171	7.584392
4444	Niger	Gurara	Shako	9.447604	7.136571
4445	Kogi	Okehi	Oboroke Eba	7.614503	6.105396
4446	Niger	Borgu	Kabe/Pissa	10.715891	4.117186
4447	Osun	Ife East	Ilode  II	7.391025	4.646476
4448	Oyo	Ibadan North	Ward IX, (N6B PART I)	7.406653	3.892950
4449	Kwara	Edu	Tsaragi III	8.817430	5.103875
4450	Borno	Nganzai	Gadai	12.509063	13.038801
4451	Ebonyi	Ezza South	Ezzama	6.162354	7.990659
4452	Enugu	Igbo-eze North	Ette I	7.103209	7.410960
4453	Kano	Kura	Rigar Duka	11.809927	8.428221
4454	Anambra	Njikoka	Nimo  IV	6.131860	6.972665
4455	Bayelsa	Yenagoa	Ekpetiama II	4.979577	6.315356
4456	Niger	Paikoro	Ishau	9.651122	7.231259
4457	Sokoto	Rabah	Gandi 'B'	12.973457	5.930669
4458	Imo	Unuimo	Eziama	5.754679	7.219559
4459	Ekiti	Ado-Ekiti	Ado 'E' Ijoka	7.626483	5.258249
4460	Cross River	Yakurr	Mkpani/Agoi	5.755621	8.204112
4461	Abia	Isuikwuato	Isiala Amawu	5.732557	7.490135
4462	Cross River	Calabar Municipality	Eigth	5.012317	8.309798
4463	Osun	Ilesha East	Iloro/Roye	7.588243	4.765352
4464	Jigawa	Jahun	Kale	12.070609	9.343183
4465	Imo	Ihitte-Uboma Isinweke	Ikperejere	5.665451	7.371819
4466	Jigawa	Babura	Takwasa	12.599780	8.875761
4467	Imo	Orlu	Okua Bala/Ihioma	5.822321	7.043237
4468	Niger	Rijau	Dukku	11.204090	4.871793
4469	Kogi	Omala	Opoda/Ofejiji	7.671628	7.470724
4470	Imo	Ezinihitte Mbaise	Onicha I	5.489812	7.320769
4471	Benue	Apa	Edikwu II	7.638055	8.011073
4472	Gombe	Dukku	Kunde	10.722590	10.617161
4473	Katsina	Ingawa	Kurfeji/Yankaura	12.684908	7.953676
4474	Osun	Olorunda	Oba Oke	7.884157	4.581403
4475	Niger	Edati	Gazhe  II	8.948763	5.724831
4476	Ekiti	Efon	Efon IX	7.666484	4.934171
4477	Ekiti	Ado-Ekiti	Ado 'G' Oke Ila	7.617672	5.355326
4478	Katsina	Mai'Adua	Mai'adua 'B'	13.171003	8.265954
4479	Benue	Kwande	Yaav	6.799907	9.415649
4480	Kogi	Olamaboro	Ogugu II	7.153425	7.368205
4481	Osun	Isokan	Oosa Adifa	7.274130	4.185996
4482	Akwa Ibom	Ibiono Ibom	Ibiono Northern I	5.280152	7.846277
4483	Osun	Ilesha West	Isida/Adeti	7.628061	4.741934
4484	Jigawa	Gumel	Galagamma	12.634061	9.399478
4485	Imo	Mbaitoli	Amaike Mbieri	5.589230	7.075084
4489	Sokoto	Kebbe	Kebbe East	12.115436	4.921203
4490	Enugu	Uzo-Uwani	Ogurugu	6.804560	6.951585
4491	Benue	Ogbadibo	Orokam I	7.001460	7.555667
4492	Bauchi	Toro	Tilden Fulani	10.048614	8.991771
4493	Ondo	Akure South	Aponmu	7.245398	5.106329
4494	Jigawa	Garki	Rafin Marke	12.445631	9.011221
4495	Abia	Ikwuano	Ariam	5.347212	7.610924
4496	Kano	Tsanyawa	Kabagiwa	12.284207	8.010220
4497	Ebonyi	Ishielu	Umuhuali	6.537121	7.794132
4498	Gombe	Nafada	Gudukku	11.163492	11.069791
4499	Oyo	Ibarapa North	Igangan III	7.700186	3.201135
4500	Imo	Owerri North	Obibi-Uratta II	5.503502	7.078298
4501	Sokoto	Gudu	Gwazange/Boto	13.357349	4.417147
4502	Sokoto	Tangazar	Magonho	13.482835	4.907891
4503	Federal Capital Territory	Bwari	Usama	9.158159	7.339424
4504	Kebbi	Koko/Bes	Koko Magaji	11.421777	4.517863
4505	Delta	Oshimili South	Cable point II	6.186177	6.746958
4506	Taraba	Lau	Mayo Lope	9.193540	11.727967
4507	Anambra	Ogbaru	Akili - Ozizor	5.901941	6.712696
4508	Oyo	Ibarapa North	Igangan II	7.678152	3.238521
4509	Federal Capital Territory	Abaji	Gawu	9.110990	6.812929
4510	Sokoto	Wurno	Dinawa	13.228089	5.438234
4511	Ondo	Ese-Odo	Apoi II	6.277107	4.958625
4512	Borno	Dikwa	Ufaye / Gujile	11.996716	13.950251
4513	Bayelsa	Southern Ijaw	Apoi	4.776250	5.856929
4514	Katsina	Mashi	Sonkaya	13.041691	8.112519
4515	Yobe	Nguru	Dumsai/Dogon-Kuka	12.848866	10.513513
4516	Jigawa	Gwiwa	Rorau	12.797942	8.148538
4517	Kano	Dala	Kofar Mazugal	11.999316	8.477980
4518	Rivers	Emuoha	Emohua I	4.844073	6.810616
4519	Niger	Bida	Bariki	9.060992	5.992532
4520	Niger	Rijau	T/Bunu	11.032253	5.168681
4521	Ebonyi	Afikpo South	Ogbu (amato)	5.811431	7.862227
4522	Edo	Ovia North East	Oduna	6.351601	5.462725
4523	Osun	Iwo	Oke-Adan  I	7.636125	4.181579
4524	Kaduna	Zaria	Tukur Tukur	11.087342	7.690693
4525	Abia	Isiala Ngwa South	Okporo Ahaba	5.225751	7.381900
4526	Benue	Guma	Mbadwem	8.028072	8.700889
4527	Oyo	Atisbo	Ago Are I	8.460766	3.397121
4528	Oyo	Irepo	Iba II	9.080544	3.858400
4529	Osun	Isokan	Olukoyi (Oja-Osun)	7.305263	4.162615
4530	Ondo	Idanre	Owena/Aponmulona	7.201940	5.050481
4531	Kwara	Moro	Megida	8.761563	4.283214
4532	Zamfara	Gusau	Wonaka	12.274887	6.992877
4533	Katsina	Charanchi	Doka	12.618447	7.767790
4534	Adamawa	Mubi North	Muchalla	10.361228	13.435341
4535	Adamawa	Michika	Michika I	10.616379	13.382400
4536	Yobe	Geidam	Ma'anna/Dagambi	12.733244	11.870562
4537	Oyo	Akinyele	Olode/Amosun/Onidundu	7.630253	3.910500
4538	Kebbi	Jega	Dunbegu/Bausara	12.220315	4.345906
4539	Kwara	Ilorin South	Akanbi II	8.419124	4.754710
4540	Jigawa	Kazaure	Sabaru	12.665679	8.458046
4541	Akwa Ibom	Mkpat Enin	Ibiaku III	4.705697	7.764541
4542	Kano	Rano	Zurgu	11.525302	8.489973
4543	Benue	Obi	Adum West	6.917949	8.279168
4544	Ogun	Ado Odo-Ota	Iju	6.575810	3.164212
4545	Sokoto	Sokoto North	S/Musulmi 'B'	13.059282	5.276648
4546	Zamfara	Gusau	Ruwan Bore	12.196330	6.924133
4547	Plateau	Kanke	Amper Seri	9.292557	9.645396
4548	Kano	Dambatta	Ajumawa	12.458011	8.519878
4549	Ebonyi	Izzi	Ndieze Inyimagu II Ndiabor Ishiagu	6.413778	8.291059
4550	Borno	Magumeri	Kubti	12.342802	12.547592
4551	Plateau	Bassa	Kakkek	9.932181	8.704636
4552	Rivers	Etche	Igbodo	5.170496	7.121651
4553	Nassarawa	Karu	Agada/Bagaji	8.973317	7.810925
4554	Katsina	Safana	Safana	12.355513	7.402267
4555	Kaduna	Soba	Rahama	10.860638	8.127164
4556	Osun	Ilesha East	Isare	7.587332	4.756708
4557	Kebbi	Yauri	Tondi	10.971001	4.792789
4558	Abia	Isiala Ngwa North	Ngwa Ukwu I	5.392243	7.368677
4559	Akwa Ibom	Ika	Urban II	5.016012	7.524509
4560	Imo	Oru-West	Mgbidi II	5.712167	6.898761
4561	Edo	Orhionmw	Ukpato	6.156447	5.827374
4562	Nassarawa	Karu	Uke	8.858178	7.717361
4563	Kebbi	Aleiro	Kashin Zama	12.336276	4.485517
4564	Ondo	Ilaje	Etikan	6.286654	4.637454
4565	Sokoto	Sokoto South	Gagi 'B'	12.986651	5.271533
4566	Imo	Mbaitoli	Ubomiri	5.565120	6.978211
4567	Ekiti	Gboyin	Imesi	7.560884	5.569375
4568	Borno	Guzamala	Mairari	12.668818	13.418194
4569	Kano	Dawakin Kudu	Dawakiji	11.831993	8.661085
4570	Adamawa	Guyuk	Dumna	9.717440	11.906841
4571	Cross River	Akamkpa	Uyanga	5.373716	8.245151
4572	Cross River	Biase	Agwagune/Okurike	5.669072	8.023846
4573	Lagos	Lagos Island	Isale-Agbede	6.457189	3.391178
4574	Delta	Warri South	Okere	5.723382	5.570328
4575	Zamfara	Maru	Dan Sadau	11.374651	6.620031
4576	Kwara	Asa	Elebue/Agbona/Fata	8.590595	4.316241
4577	Bauchi	Darazo	Gabciyari	11.059734	10.588415
4578	Gombe	Billiri	Bare	9.903689	11.216690
4579	Anambra	Ayamelum	Ifite Ogwari II	6.597290	6.972338
4580	Rivers	Obio/Akpor	Rumuodomaya (3A)	4.856727	7.016390
4581	Kaduna	Giwa	Idasu	11.135154	7.252784
4582	Imo	Owerri West	Emeabiam/Okolochi	5.275508	6.998270
4583	Ekiti	Ekiti East	Kota I	7.772542	5.692581
4584	Borno	Maiduguri	Gwange  I	11.847172	13.236457
4585	Bauchi	Gamjuwa	Miya West	10.705976	10.068348
4586	Edo	Ovia North East	Uhiere	6.667965	5.736866
4587	Ekiti	Ekiti West	Ipole Iloro	7.656214	5.028146
4588	Osun	Ife East	Modakeke  II	7.372065	4.577977
4589	Kwara	Oke-Ero	Idofin/Odo-Ashe	8.266998	5.339164
4590	Jigawa	Yankwashi	Achilafiya	12.799244	8.420203
4591	Niger	Shiroro	Kato	9.859542	6.553070
4592	Kebbi	Aleiro	Sabiyal	12.332254	4.460981
4593	Benue	Ohimini	Agadagba	7.187427	7.922081
4594	Ekiti	Moba	Otun III	7.973855	5.074828
4595	Imo	Isiala Mbano	Ibeme	5.628392	7.206237
4596	Kebbi	Bagudo	Bagudo/Tuga	11.370560	4.268153
4597	Abia	Aba North	Ogbor I	5.103887	7.382165
4598	Katsina	Sabuwa	Sayau	11.327126	7.054961
4599	Akwa Ibom	Ikot Abasi	Edemaya I	4.628280	7.557670
4600	Rivers	Port Harcourt	Oromineke/Ezimgbu	4.795529	7.008394
4601	Benue	Ohimini	Ochobo	7.122713	7.980536
4602	Imo	Ahiazu-Mbaise	Okirika Nwenkwo	5.553470	7.269901
4603	Bayelsa	Yenagoa	Ekpetiama I	4.967387	6.268994
4604	Ogun	Ijebu-Ode	Isiwo	6.706801	4.014648
4605	Delta	Ndokwa West	Abbi   II	5.721345	6.200578
4606	Akwa Ibom	Nsit Atai	Eastern Nsit IX	4.794796	7.996758
4607	Plateau	Bokkos	Bokkos	9.279950	8.996104
4608	Ogun	Egbado South	Ilobi/Erinja	6.747221	2.850078
4609	Osun	Ede South	Alajue I	7.667594	4.447349
4610	Benue	Ogbadibo	Ai-Oodo I	7.072000	7.655287
4611	Kogi	Bassa	Kpata	7.765533	6.859595
4612	Kano	Kura	Karfi	11.811987	8.477335
4613	Bauchi	Shira	Tumfafi	11.406957	10.198689
4614	Cross River	Etung	Abijang	5.828889	8.714723
4615	Akwa Ibom	Ikono	Ndiya/Ikot Idana	5.149484	7.774080
4616	Akwa Ibom	Nsit Atai	Eastern Nsit V	4.862770	8.059937
4617	Rivers	Khana	Uegwere	4.635455	7.339732
4618	Anambra	Anaocha	Adazi Enu  I	6.037738	6.967834
4619	Enugu	Isi-Uzo	Neke II	6.755425	7.670107
4620	Bauchi	Shira	Zubo	11.568608	10.144039
4621	Kaduna	Kachia	Kachia Urban	9.921815	7.865754
4622	Sokoto	Silame	Katami South	12.870817	4.805895
4623	Oyo	Itesiwaju	Okaka I	8.264390	3.481004
4624	Kogi	Okehi	Obaroke Uvete	7.597143	6.053702
4625	Taraba	Bali	Maihula	8.059303	10.965676
4626	Ogun	Shagamu	Oko/Epe/Itula II	6.833837	3.595360
4627	Bayelsa	Yenagoa	Gbarain I	5.029594	6.344197
4628	Borno	Gubio	Kingowa	12.541037	12.897202
4629	Cross River	Odukpani	Adiabo/Efut	5.055023	8.265001
4630	Niger	Gbako	Etsu audu	9.246194	6.002765
4631	Bauchi	Alkaleri	Pali	10.058274	10.508425
4632	Ondo	Ilaje	Ugbo V	5.985351	4.970572
4633	Ogun	Ikenne	Ilisan II	6.880527	3.720763
4634	Adamawa	Jada	Yelli	8.658414	12.469616
4635	Enugu	Oji-River	Oji-river III	6.249368	7.243358
4636	Akwa Ibom	Ibesikpo Asutan	Asutan I	4.879693	7.934615
4637	Niger	Wushishi	Lokogoma	9.576559	6.051690
4638	Katsina	Bakori	Jargaba	11.647425	7.439266
4639	Kano	Karaye	Tudun Kaya	11.696727	7.910219
4640	Rivers	Andoni/Odual	Ataba  I	4.536479	7.343561
4641	Osun	Osogbo	Ekerin	7.744137	4.582787
4642	Rivers	Obio/Akpor	Rukpoku	4.907028	7.010628
4643	Kaduna	Kagarko	Jere South	9.376500	7.473776
4644	Yobe	Potiskum	Danchuwa/Bula	11.746155	11.228371
4645	Lagos	Ikeja	Ojodu/Agidingbi/Omole	6.641218	3.355529
4646	Benue	Logo	Mbagber	7.796568	9.258221
4647	Bauchi	Darazo	Sade	11.280190	10.675114
4648	Edo	Ovia South West	Umaza	6.510446	5.221513
4649	Niger	Wushishi	Sabon Gari	9.689099	6.117814
4650	Kogi	Ajaokuta	Obangede/Ohunene/Ukoko Inye're	7.340029	6.639047
4651	Kano	Kiru	Bargoni	11.735530	8.122006
4652	Anambra	Anambra East	Nando  III	6.346298	6.932468
4653	Katsina	Daura	Sarkin Yara A	13.001377	8.285005
4654	Ekiti	Ijero	Iloro/Ijunrin Ward 'B'	7.821704	4.981130
4655	Borno	Damboa	Nguda / Wuyaram	11.142986	12.729741
4656	Lagos	Lagos Mainland	Maroko/Ebute Metta	6.495619	3.377301
4657	Rivers	Omumma	Ariraniiri/Owu-Ahia Community	5.092887	7.177289
4658	Katsina	Dutsin-M	Karofi A	12.538584	7.600089
4659	Yobe	Nangere	Kukuri/Chiromari	11.860572	10.906702
4660	Oyo	Ido	Aba Emo/Ilaju/Alako	7.488404	3.618162
4661	Anambra	Idemili South	Nnobi I	6.043018	6.912435
4662	Cross River	Obudu	Angiaba / Begiaka	6.574981	9.067174
4663	Kaduna	Soba	Soba	10.975208	8.069328
4664	Gombe	Billiri	Tudu Kwaya	9.746396	11.043692
4665	Plateau	Jos South	Turu	9.647232	8.744653
4666	Bayelsa	Nembe	Ogbolomabiri II	4.513211	6.303991
4667	Lagos	Apapa	Apapa III (Creek rd. Tincan/Snake Island	6.429752	3.349055
4668	Lagos	Epe	Abomiti	6.501200	4.107570
4669	Yobe	Gujba	Gotala/Gotumba	11.582411	12.316102
4670	Borno	Monguno	Monguno	12.501173	13.695702
4671	Borno	Konduga	Masba / Dalwa West	11.542739	12.962256
4672	Enugu	Igbo-Eti	Onyohor/Ochima/Idoha	6.647154	7.357727
4673	Yobe	Damaturu	Gabir/Maduri	11.665848	12.099657
4674	Niger	Tafa	Garam	9.299363	7.301794
4675	Nassarawa	Wamba	Wamba West	8.952575	8.585812
4676	Yobe	Gulani	Dokshi	11.025680	11.953723
4677	Borno	Askira/Uba	Husara / Tampul	10.565043	13.253107
4678	Gombe	Yalmatu / Deba	Kanawa / Wajari	10.298417	11.414402
4679	Borno	Kukawa	Baga	13.027229	13.701197
4680	Nassarawa	Nassarawa Egon	Wakama	8.859422	8.390664
4681	Imo	Mbaitoli	Ogwa II	5.615577	7.107210
4682	Bauchi	Gamjuwa	Kafin Madaki	10.875017	10.015582
4683	Anambra	Onitsha South	Bridge Head III	6.059069	6.758096
4684	Kano	Bebeji	Gwarmai	11.500348	8.291981
4685	Federal Capital Territory	Gwagwalada	Ibwa	9.177549	6.944726
4686	Yobe	Damaturu	Kalallawa/Gabai	11.897395	11.873106
4687	Edo	Ovia North East	Adolor	6.490450	5.603907
4688	Borno	Bayo	Balbaya	10.613654	11.834405
4689	Ondo	Okitipupa	Ayeka/Igbodigo	6.441895	4.789122
4690	Imo	Oru-West	Ozara	5.810707	6.946581
4691	Bauchi	Kirfi	Shango	10.547443	10.370284
4692	Kano	Kabo	Durun	11.880931	8.218297
4797	Kano	Albasu	Hungu	11.601177	8.986266
4693	Kano	Bunkure	Gafan	11.667199	8.470625
4694	Imo	Ideato North	Akpulu	5.899151	7.084689
4695	Kwara	Asa	Efue/Berikodo	8.494857	4.473642
4696	Kano	Ungogo	Gayawa	12.043956	8.550677
4697	Borno	Marte	Ala	12.203837	13.886549
4698	Jigawa	Jahun	Harbo Tsohuwa	12.121802	9.567447
4699	Anambra	Onitsha South	Bridge Head I	6.059862	6.750609
4700	Kebbi	Arewa	Gumumdai/Rafin Tsaka	12.276114	3.737586
4701	Katsina	Bakori	Kurami/Yankwani	11.562855	7.372025
4702	Niger	Chanchaga	Nassarawa 'B'	9.615980	6.527438
4703	Anambra	Onitsha North	Woluwo Layout	6.098526	6.773678
4704	Lagos	Mushin	Babalosa	6.550143	3.347092
4705	Ondo	Ondo West	ILUNLA/Bagbe/Odowo I	6.962310	4.780578
4706	Yobe	Fune	Mashio	11.818157	11.575720
4707	Edo	Esan North East	Amedokhian	6.743898	6.380686
4708	Gombe	Billiri	Tal	9.804099	11.100282
4709	Delta	IsokoNor	Iyede II	5.483652	6.079045
4710	Nassarawa	Doma	Agbashi	8.018611	8.268168
4711	Bauchi	Misau	Tofu	11.420289	10.423418
4712	Delta	Sapele	Sapele Urban  I	5.886063	5.688281
4713	Kebbi	Bunza	Sabon Birni	12.108095	4.086003
4714	Borno	Gwoza	Gavva / Agapalwa	11.113356	13.824185
4715	Delta	Ughelli North	Agbarha	5.569170	6.073007
4716	Niger	Katcha	Sidi saba	8.994074	6.123571
4717	Cross River	Abi	Imabana II	5.949962	8.113276
4718	Akwa Ibom	Ini	Ikpe I	5.346711	7.797181
4719	Oyo	Saki West	Aganmu/Kooko	8.454854	3.226824
4720	Yobe	Gulani	Njibulwa	10.994201	11.598965
4721	Akwa Ibom	Nsit Ibom	Asang I	4.971537	7.857739
4722	Niger	Shiroro	Erana	10.075945	6.720436
4723	Niger	Gbako	Edozhigi	9.048996	5.860632
4724	Zamfara	Talata-Mafara	Gwaram	12.236292	6.162637
4725	Kogi	Ijumu	Ekinrin Ade	7.838727	5.846514
4726	Ondo	Ondo East	Tepo	7.112582	4.896157
4727	Kebbi	Argungu	Dikko	12.731071	4.503203
4728	Ebonyi	Ohaukwu	Effium I	6.655824	8.015518
4729	Katsina	Safana	Babban Duhu 'A'	12.623869	7.263334
4730	Anambra	Ihiala	Ogbolo	5.822479	6.789982
4731	Plateau	Mikang	Piapung 'A'	9.057334	9.515436
4732	Katsina	Sabuwa	Maibakko	11.264605	7.139101
4733	Delta	Ughelli South	Effurun - Otor	5.472510	5.930497
4734	Ondo	Irele	Irele II	6.622645	5.027467
4735	Kano	Rimin Gado	Gulu	11.852325	8.286455
4736	Delta	Ethiope West	Oghara III	5.954151	5.651317
4737	Imo	Orsu	Ebenator	5.811084	6.977150
4738	Katsina	Musawa	Dangani	12.086191	7.547180
4739	Adamawa	Hong	Hushere Zum	10.103751	13.080659
4740	Bayelsa	Yenagoa	Epie II	4.930549	6.324071
4741	Rivers	Etche	Igbo II	4.988776	7.005078
4742	Rivers	Khana	Llueku/Nyokuru	4.750918	7.434061
4743	Jigawa	Dutse	Jigawar Tsada	11.668120	9.291672
4744	Imo	Ahiazu-Mbaise	Oru-Na-Lude	5.527882	7.272266
4745	Kebbi	Kalgo	Etene	12.183605	4.046498
4746	Delta	IkaSouth	Ekuku - Agbor	6.060166	6.290425
4747	Anambra	Anaocha	Ichida I	6.010614	6.956045
4748	Ogun	Ewekoro	Elere/Onigbedu	6.969450	3.084196
4749	Sokoto	Sokoto North	Waziri 'C'	13.067913	5.294570
4750	Delta	Warri South	Pessu	5.555109	5.694160
4751	Bauchi	Bogoro	Bogoro "C"	9.675429	9.630375
4752	Sokoto	Goronyo	Takakume	13.532691	5.821467
4753	Rivers	Tai	Oyigbo West	4.747390	7.225085
4754	Lagos	Badagary	Iya-afin	6.464214	2.872774
4755	Jigawa	Maigatari	Fulata	12.755400	9.393546
4756	Niger	Wushishi	Zungeru	9.791930	6.172232
4757	Ogun	Shagamu	Simawa/Iwelepe	6.839789	3.504420
4758	Zamfara	Bakura	Dan Manau	12.569960	5.840464
4759	Adamawa	Jada	Danaba	8.544084	12.193800
4760	Kwara	Kaiama	Kemanji	9.830478	3.933924
4761	Katsina	Daura	Madobi B	12.938630	8.256568
4762	Jigawa	Kazaure	Dandi	12.644909	8.671272
4763	Cross River	Odukpani	Odukpani Central	5.115242	8.307305
4764	Ekiti	Gboyin	Egbe/Iro	7.654660	5.631467
4765	Akwa Ibom	Ika	Urban I	5.030004	7.535214
4766	Gombe	Gombe	herwagana	10.312470	11.248238
4767	Kwara	Moro	Lanwa	8.818357	4.760406
4768	Borno	Gwoza	Pulka/Bokko	11.252987	13.809371
4769	Kano	Tofa	Yanoko	12.044031	8.271701
4770	Kano	Bichi	Saye	12.230681	8.395631
4771	Jigawa	Sule Tankarkar	Yandamo	12.716597	9.106498
4772	Bauchi	Gamawa	Kafin  Romi	12.068704	10.472710
4773	Lagos	Oshodi/Isolo	Ajao Estate	6.570566	3.310316
4774	Anambra	Orumba South	Ihite	5.944607	7.250691
4775	Akwa Ibom	Udung Uko	Udung Uko I	4.735089	8.264358
4776	Kano	Gwarzo	Unguwar Tudu	11.915332	7.998570
4777	Kogi	Yagba West	Ejiba	8.437276	5.590536
4778	Federal Capital Territory	Bwari	Ushafa	9.209365	7.403970
4779	Katsina	Jibia	Kusa	13.056638	7.463800
4780	Akwa Ibom	Onna	Oniong east I	4.601271	7.874998
4781	Ondo	Ifedore	Ilara I	7.354140	5.117952
4782	Rivers	Okrika	Ogan	4.712645	7.123135
4783	Kano	Ungogo	Rangaza	12.040039	8.608172
4784	Taraba	Zing	Zing AII	8.974861	11.811248
4785	Taraba	Jalingo	Sarkin Dawaki	8.861016	11.431001
4786	Benue	Vandeikya	Mbatyough	6.706232	9.119240
4787	Adamawa	Michika	Minkisi/ Wuro Ngiki	10.668410	13.424378
4788	Ebonyi	Ishielu	Amaezu	6.553460	7.748213
4789	Osun	Ilesha West	Ilaje	7.639718	4.690343
4790	Kwara	Irepodun	Oro I	8.286654	4.849473
4791	Kebbi	Fakai	Birnin Tudu	11.576097	5.010105
4792	Borno	Magumeri	Kareram	12.182735	12.789014
4793	Imo	Ezinihitte Mbaise	Eziudo	5.485920	7.359684
4794	Kogi	Ofu	Itobe/Okokenyi	7.258350	6.716049
4795	Bayelsa	Ekeremor	Oporomor IV	4.974416	5.631016
4796	Adamawa	Hong	Shangui	10.259165	12.899905
4798	Cross River	Boki	Ogep/Osokom	6.405648	8.801876
4799	Kaduna	Kaura	Zankan	9.512366	8.435750
4800	Kwara	Moro	Pakunmo	8.734587	4.562656
4801	Bauchi	Bauchi	Dan'iya Hardo	10.315877	9.818938
4802	Enugu	Udenu	Obollo-Etiti	6.882953	7.593636
4803	Zamfara	Gummi	Bardoki	11.830933	5.202756
4804	Ogun	Ijebu East	Ijebu Mushin II	6.764444	4.069903
4805	Jigawa	Buji	K/Lelen Kudu	11.467274	9.738034
4806	Taraba	Bali	Kaigama	8.366300	11.230623
4807	Kano	Gezawa	Zango	12.078348	8.691739
4808	Oyo	Afijio	Ilora II	7.776504	3.863979
4809	Edo	Owan East	Otuo  II	7.199449	5.944502
4810	Katsina	Kankara	Zango/Zabaro	12.010913	7.243560
4811	Edo	Oredo	New Benin II	6.322998	5.593106
4812	Adamawa	Demsa	Bille	9.224570	11.997913
4813	Ondo	Akoko South-West	Ikun	7.389871	5.778424
4814	Enugu	Enugu East	Umuenwene	6.497550	7.480436
4815	Plateau	Mangu	Mangu  II	9.493030	9.164308
4816	Osun	Ilesha West	Isokun	7.643219	4.744858
4817	Oyo	Kajola	Ilaji Oke/Iwere-Oke	8.067070	3.316545
4818	Kano	Dala	Adakawa	12.000018	8.466022
4819	Kano	Kunchi	Shuwaki	12.477258	8.215664
4820	Ekiti	Moba	Igogo II	7.953819	5.146248
4821	Kaduna	Ikara	Saulawa	11.304311	8.120144
4822	Borno	Abadam	Jabullam	13.412187	13.117058
4823	Ondo	IleOluji/Okeigbo	Ileoluji IV	7.278517	4.963354
4824	Kano	Tundun Wada	Shuwaki	11.311560	8.378659
4825	Kogi	Koton-Karfe	Chikara South	8.302536	6.857834
4826	Cross River	Odukpani	Creek Town II	5.079788	8.222083
4827	Oyo	Olorunsogo	Waro/Apata-Alaje	8.674984	4.013286
4828	Delta	Burutu	Torugbene	5.131685	5.825041
4829	Kaduna	Kachia	Ankwa	9.866988	7.790573
4830	Adamawa	Jada	Mbulo	8.691741	12.203396
4831	Imo	Ideato North	Umuokwara/Umuezeaga	5.876947	7.166099
4832	Anambra	Anaocha	Adazi Enu  II	6.031606	6.982247
4833	Yobe	Bade	Lawan Fannami	12.844636	11.018494
4834	Niger	Agwara	Suteku	10.621480	4.634125
4835	Ondo	Ifedore	Ijare I	7.392485	5.154501
4836	Plateau	Riyom	Bum	9.689653	8.620859
4837	Ogun	Ikenne	Ogere I	6.965140	3.652816
4838	Imo	Orsu	Okwuetiti	5.856139	6.958224
4839	Enugu	Nsukka	Ogbozalla/Idi	6.780110	7.467906
4840	Osun	Ila	Isedo  II	8.004376	4.957067
4841	Ondo	Akure South	Owode/Imuagun	7.305391	5.161170
4842	Gombe	Yalmatu / Deba	Kuri /Lano / Lambam	10.121950	11.555744
4843	Benue	Konshisha	Mbawar	6.916878	8.834050
4844	Edo	Oredo	New Benin I	6.297278	5.577079
4845	Jigawa	Kazaure	Unguwar Arewa	12.655732	8.411529
4846	Nassarawa	Nasarawa	Ara II	8.591089	7.595027
4847	Kaduna	Kagarko	Katugal	9.351720	7.832396
4848	Edo	Etsako Central	Fugar II	7.098377	6.496515
4849	Osun	Boluwaduro	Oke-Omi Otan	7.957354	4.789811
4850	Lagos	Surulere	Orile	6.487253	3.335153
4851	Abia	Osisioma	Amavo	5.127107	7.288200
4852	Zamfara	Maru	Bingin	12.000302	6.318777
4853	Ondo	Akoko South-West	Supare I	7.385990	5.612130
4854	Jigawa	Gumel	Dantanoma	12.633634	9.371548
4855	Cross River	Biase	Ehom	5.462005	8.161259
4856	Rivers	Ikwerre	Omerelu	5.175912	6.836699
4857	Katsina	Dutsi	Yamel A	12.890378	8.126431
4858	Adamawa	Yola North	Ajiya	9.248587	12.510553
4859	Kano	Rimin Gado	Dawakin Gulu	11.872046	8.322750
4860	Bauchi	Gamawa	Gololo	12.298986	10.717334
4861	Akwa Ibom	Nsit Atai	Eastern Nsit VI	4.868170	8.017307
4862	Ondo	Owo	Ipele	7.152525	5.679919
4863	Osun	Atakumosa East	Eti-Oni	7.346119	4.796566
4864	Anambra	Ekwusigo	Oraifite  III	5.997968	6.845018
4865	Kogi	Olamaboro	Ogugu I	7.117980	7.329432
4866	Oyo	Afijio	Ilora III	7.707477	3.846336
4867	Abia	Ugwunagbo	Ward Two	5.008074	7.395386
4868	Anambra	Dunukofia	Nawgu  II	6.243541	6.964128
4869	Imo	Ihitte-Uboma Isinweke	Amakohia	5.609501	7.356876
4870	Kogi	Dekina	Odu I	7.686899	7.205844
4871	Borno	Gubio	Ngetra	12.647231	12.637985
4872	Anambra	Nnewi South	Ukpor II	5.917714	6.859443
4873	Anambra	Nnewi North	Uruagu  III	6.006347	6.896869
4874	Lagos	Agege	Isale/Idimangoro	6.626435	3.316298
4875	Ebonyi	Ohaukwu	Ishi Ngbo II	6.552608	7.983085
4876	Ondo	Akure North	Igoba/Isinigbo	7.304293	5.242737
4877	Kebbi	Birnin Kebbi	Ujariyo	12.484491	4.466518
4878	Sokoto	Binji	Torankawa	13.252896	4.882321
4879	Rivers	Etche	Akwa/Odogwa	4.957802	7.114833
4880	Katsina	Sandamu	Sandamu	12.944606	8.358959
4881	Adamawa	Shelleng	Jumbul	9.804532	12.122627
4882	Adamawa	Gombi	Boga/ Dingai	10.109874	12.426848
4883	Nassarawa	Akwanga	Agyaga	9.003580	8.319484
4884	Akwa Ibom	Oron	Oron Urban II	4.825055	8.235476
4885	Edo	Egor	Evbareke	6.357377	5.590644
4886	Delta	IsokoSou	Enhwe/Okpolo	5.348562	6.110500
4887	Delta	IsokoNor	Iyede I	5.450823	6.103889
4888	Gombe	Billiri	Billiri South	9.944766	11.279187
4889	Plateau	Jos South	Kuru 'B'	9.680181	8.771936
4890	Zamfara	Talata-Mafara	Ruwan Bore	12.463350	6.054779
4891	Gombe	Balanga	Dadiya	9.652427	11.454200
4892	Akwa Ibom	Uyo	Uyo Urban III	5.029799	7.941726
4893	Lagos	Badagary	Iworo Gbanko	6.438901	3.032802
4894	Plateau	Mikang	Piapung 'B'	8.986497	9.467264
4895	Rivers	Emuoha	Obelle	5.006950	6.789697
4896	Edo	Etsako Central	Ekperi I	7.045855	6.441859
4897	Jigawa	Gwiwa	Guntai	12.767732	8.351979
4898	Zamfara	Shinkafi	Shinkafi South	13.058435	6.546398
4899	Akwa Ibom	Ika	Ito II	4.999724	7.518909
4900	Rivers	Tai	Ward I (Botem/Gbeneo)	4.722655	7.276768
4901	Osun	Olorunda	Atelewo	7.772800	4.561719
4902	Edo	Esan North East	Ewoyi	6.713080	6.309438
4903	Ogun	Egbado North	Igua	7.104629	2.841283
4904	Ogun	Abeokuta South	Ake II	7.183663	3.384150
4905	Ondo	Akure North	Igbatoro	7.144360	5.362654
4906	Kogi	Koton-Karfe	Akpasu	7.911015	6.904412
4907	Enugu	Enugu North	Udi Siding/Iva Valley	6.454857	7.457396
4908	Katsina	Kurfi	Wurma 'A'	12.564640	7.445469
4909	Ondo	Owo	Igboroko II	7.210968	5.587629
4910	Ondo	Ose	Okeluse	6.854105	5.574856
4911	Ebonyi	Onicha	Abaomege	6.017016	7.996459
4912	Akwa Ibom	Ibesikpo Asutan	Asutan V	4.857218	7.971807
4913	Imo	Ngor-Okpala	Imerienwe	5.244846	7.035722
4914	Kogi	Dekina	Iyale	7.563884	7.068888
4915	Delta	Patani	Taware/Kolowara Aven	5.200820	6.179477
4916	Katsina	Danmusa	Dandire A	12.267164	7.211285
4917	Ekiti	Ekiti West	Okemesi II	7.796717	4.950664
4918	Imo	Orlu	Umuzike/Umuowa	5.748094	7.025118
4919	Bauchi	Bogoro	B O I "C"	9.584417	9.456157
4920	Osun	Oriade	Erin-Oke	7.533700	4.858569
4921	Kogi	Mopa-Muro	Ileteju I	8.003103	5.866812
4922	Anambra	Ekwusigo	Ihiteoha	5.925639	6.810289
4923	Yobe	Geidam	Futchimiram	12.728741	12.392523
4924	Kano	Karaye	Daura	11.751919	7.957092
4925	Rivers	Oyigbo	Obeakpu	4.848696	7.315036
4926	Ogun	Ijebu-Ode	Ijasi/Idepo	6.879698	3.917282
4927	Lagos	Ikorodu	Isele I	6.622202	3.496972
4928	Niger	Bida	Masaba I	9.089255	6.005486
4929	Nassarawa	Nasarawa	Guto/Aisa	8.166911	7.695427
4930	Ebonyi	Ebonyi	Enyibichiri II	6.338224	8.081743
4931	Kogi	Yagba West	Oke Egbe IV	8.273875	5.608243
4932	Delta	Uvwie	Ekpan II	5.560888	5.744667
4933	Kebbi	Augie	Bayawa South	12.751695	4.750818
4934	Imo	Aboh-Mbaise	Lorji	5.399138	7.282835
4935	Benue	Ukum	Mbatian	7.558517	9.726128
4936	Kaduna	Kubau	Kubau	10.812409	8.170700
4937	Cross River	Calabar Municipality	Nine	5.032991	8.335549
4938	Kogi	Adavi	Ege/Iruvochinomi	7.521467	6.257767
4939	Akwa Ibom	Uruan	Southern Uruan IV	4.898175	8.056040
4940	Federal Capital Territory	Municipal	Orozo	8.907018	7.505502
4941	Niger	Kontogur	Rafin Gora	10.240633	5.467011
4942	Kaduna	Birnin Gwari	Randagi	10.557800	6.243609
4943	Ebonyi	Ezza North	Ogboji	6.212660	7.937968
4944	Benue	Gwer East	Mbayom	7.257571	8.376430
4945	Abia	Ohafia	Ndi Etiti Nkporo	5.775958	7.780617
4946	Abia	Aba North	Ogbor II	5.077358	7.379749
4947	Cross River	Yala	Yahe	6.356022	8.430623
4948	Rivers	Khana	Bane	4.642797	7.505223
4949	Kaduna	Soba	Garun Gwanki	10.834027	7.970087
4950	Ondo	Okitipupa	Iju-odo/Erekiti	6.553757	4.687029
4951	Kebbi	Koko/Bes	Lani/Manyan/Tafukka/Shiba	11.612802	4.417503
4952	Plateau	Qua'anpa	Kwalla Yitla'ar	8.939699	9.280506
4953	Ekiti	Ekiti East	Ilasa II/Ikun/Araromi	7.804288	5.609039
4954	Ogun	Ewekoro	Owowo	7.043860	3.242137
4955	Abia	Umuahia South	Nsirimo	5.474835	7.438042
4956	Oyo	Ibadan South East	S 4A	7.349976	3.919346
4957	Benue	Buruku	Mbaapen	7.488064	9.134461
4958	Akwa Ibom	Okobo	Okopedi I	4.851981	8.100770
4959	Zamfara	Maradun	Damaga / Damagiwa	12.460440	6.403693
4960	Nassarawa	Akwanga	Gwanje	8.932336	8.352228
4961	Imo	Owerri West	Avu/Oforola	5.419921	6.957616
4962	Yobe	Yunusari	Zajibiri / Dumbal	13.020298	11.854751
4963	Yobe	Karasuwa	Yajiri	12.965732	10.608525
4964	Oyo	Ori-Ire	Ori Ire III	8.333837	4.281106
4965	Kano	Wudil	Wudil	11.813507	8.828012
4966	Kano	Bunkure	Sanda	11.673154	8.712553
4967	Jigawa	Guri	Kadira	12.610610	10.502571
4968	Kaduna	Giwa	Shika	11.187419	7.555863
4969	Osun	Iwo	Gidigbo  II	7.632672	4.177401
4970	Katsina	Musawa	Garu	12.238165	7.795230
4971	Abia	Isiala Ngwa North	Amasaa Ntigha	5.426186	7.368623
4972	Abia	Aba North	Eziama	5.123177	7.367187
4973	Kwara	Offa	Essa-A	8.129720	4.740273
4974	Ekiti	Ekiti West	Okemesi III	7.791202	4.926723
4975	Sokoto	Kebbe	Margai - B	12.175151	4.878872
4976	Abia	Aba North	Uratta	5.104692	7.334398
4977	Adamawa	Mubi North	Sabon Layi	10.269482	13.271494
4978	Ebonyi	Ikwo	Etam	6.002895	8.065342
4979	Plateau	Kanam	Kanam	9.505478	9.988057
4980	Kwara	Offa	Shawo Central	8.138455	4.682396
4981	Borno	Maiduguri	Bolori I	11.856946	13.175080
4982	Akwa Ibom	Ini	Itu Mbonuso	5.473204	7.704264
4983	Sokoto	Dange-Shuni	Giere/Gajara	12.931596	5.488542
4984	Kano	Sumaila	Sumaila	11.487016	8.928129
4985	Ogun	Ijebu North	Ako-Onigbagbo/Gelete	6.933341	3.767345
4986	Oyo	Iseyin	Faramora	8.002782	3.677917
4987	Imo	Owerri West	Okuku	5.474645	6.933285
4988	Gombe	Gombe	Bajoga	10.321326	11.248415
4989	Cross River	Akamkpa	Ojuk North	5.052406	8.547381
4990	Zamfara	Birnin Magaji	Nasarawa Godal West	12.528412	6.795555
4991	Edo	Igueben	Owu/ Okuta/ Eguare Ebelle	6.491052	6.222526
4992	Zamfara	Gummi	Birnin Tudu	11.983150	5.443006
4993	Adamawa	Maiha	Pakka	10.096253	13.252995
4994	Oyo	Surulere	Iregba	8.027639	4.512284
4995	Delta	AniochaN	Obomkpa	6.390623	6.503318
4996	Imo	Owerri North	Emil	5.418174	7.128499
4997	Kwara	Pategi	Lade II	8.753631	5.553820
4998	Borno	Gubio	Ardimini	12.513478	12.617358
4999	Cross River	Bekwarra	Otukpuru	6.720819	8.939450
5000	Niger	Rijau	Jama'are	11.092059	5.360677
5001	Katsina	Safana	Zakka 'B'	12.588616	7.294797
5002	Edo	Igueben	Ekekhen/Idumuogo/Egbiki	6.579377	6.212377
5003	Kebbi	Aleiro	Jiga Birni	12.309457	4.508537
5004	Kaduna	Giwa	Pan Hauya	11.101570	7.577691
5005	Ondo	Akoko South-West	Akungba I	7.481523	5.746188
5006	Sokoto	Yabo	Birniruwa	12.856384	5.088878
5007	Kano	Karaye	Kwanyawa	11.770363	7.900669
5008	Benue	Vandeikya	Mbadede	6.922581	9.025097
5009	Katsina	Danja	Kahutu A	11.378932	7.698256
5010	Kogi	Kabba-Bunu	Egbeda	7.751709	6.088122
5011	Borno	Ngala	Gamboru 'B'	12.336911	14.284677
5012	Enugu	Aninri	Nnenwe III	6.124875	7.555820
5013	Kebbi	Ngaski	Gafara Machupa	10.410045	4.603082
5014	Akwa Ibom	Ini	Ikono North III	5.317941	7.670680
5015	Oyo	Ibarapa Central	Idofin Isaganun	7.381160	3.224301
5016	Plateau	Jos North	Jenta Adamu	9.868835	8.896283
5017	Borno	Mafa	Loskuri	11.841499	13.532250
5018	Plateau	Kanam	Munbutbo	9.629002	10.180510
5019	Niger	Borgu	Shagunu	10.324199	4.354550
5020	Imo	Ideato North	Obodoukwu	5.875793	7.093133
5021	Ogun	Egbado North	Sunwa	7.178364	3.015655
5022	Oyo	Ogbomosho North	Aguodo/ Masifa	8.167716	4.294052
5023	Rivers	Asari-Toru	West Cental Group	4.728145	6.818898
5024	Ogun	Imeko-Afon	Imeko	7.519140	2.842351
5025	Akwa Ibom	Ikot Ekpene	Ikot Ekpene X	5.216190	7.660540
5026	Nassarawa	Obi	Deddere/Riri	8.443897	8.729631
5027	Borno	Jere	Tuba	12.053082	13.225496
5028	Benue	Ukum	Kundav	7.436854	9.625264
5029	Ogun	Obafemi-Owode	Onidundu	7.013400	3.318711
5030	Akwa Ibom	Etinan	Southern Iman II	4.772688	7.852156
5031	Sokoto	Goronyo	Boyeka I	13.405645	5.569247
5032	Akwa Ibom	Etim Ekpo	Etim Ekpo IX	4.890253	7.497075
5033	Imo	Ngor-Okpala	Nguru/Umuowa	5.371965	7.149089
5034	Nassarawa	Lafia	Shabu/Kwandere	8.604185	8.517232
5035	Kogi	Yagba West	Odo Egbe	8.327043	5.397222
5036	Kaduna	Zaria	Dambo	11.060843	7.782315
5037	Kwara	Ifelodun	Oro-Ago	8.394441	5.289938
5038	Anambra	Aguata	Uga I	5.935085	7.048276
5039	Osun	Ede South	Jagun/Jagun	7.688343	4.439656
5040	Rivers	Okrika	Okrika VII	4.665334	7.052299
5041	Oyo	Ibadan South West	Ward 12 SW9 II	7.370288	3.845467
5042	Imo	Nkwerre	Onusa	5.725522	7.107195
5043	Akwa Ibom	Udung Uko	Udung Uko VI	4.761599	8.242738
5044	Kano	Rogo	Jajaye	11.524825	7.964553
5045	Abia	Bende	Umu - Imenyi	5.632288	7.505883
5046	Benue	Obi	Obeko	6.914389	8.352384
5047	Delta	Warri South-West	Ugborodo	5.720732	5.409462
5048	Delta	IsokoSou	Olomoro	5.442283	6.148987
5049	Katsina	Ingawa	Dara	12.718490	8.109430
5050	Katsina	Batsari	Kandawa	12.926071	7.299654
5051	Benue	Gboko	Mbatan	7.318366	8.855663
5052	Niger	Agaie	Ekowugi	8.997359	6.308994
5053	Akwa Ibom	Nsit Atai	Eastern Nsit I	4.830078	8.047326
5054	Oyo	Ogbomosho North	Isale Ora/Saja	8.118577	4.301675
5055	Rivers	Etche	Ndashi	5.165645	7.080832
5056	Kano	Kabo	Masanawa	11.827825	8.253584
5057	Enugu	Udi	Obioma	6.364569	7.387114
5058	Lagos	Kosofe	Agboyi II	6.605139	3.427480
5059	Zamfara	Bukkuyum	Masama	12.120300	5.689291
5060	Anambra	Aguata	Ikenga	5.997641	7.043081
5061	Kano	Takai	Bagwaro	11.360868	9.143475
5062	Bauchi	Shira	Disina	11.369091	9.998821
5063	Sokoto	Sokoto North	Magajin Rafi 'A'	13.056854	5.287744
5064	Imo	Ihitte-Uboma Isinweke	Abueke	5.610754	7.383232
5065	Kano	Gezawa	Tumbau	12.003136	8.778411
5066	Enugu	Nkanu West	Obuoffia	6.310640	7.471144
5067	Borno	Bama	Gulumba / Jukkuri / Batra	11.607128	13.975248
5068	Plateau	Bokkos	Sha	9.194293	8.770555
5069	Anambra	Nnewi South	Amichi  I	5.964368	6.946127
5070	Osun	Ilesha West	Omofe/Idasa	7.631009	4.739042
5071	Ekiti	Ado-Ekiti	Ado 'D' Ijigbo	7.583969	5.189118
5072	Jigawa	Taura	S/Garin Yaya	12.191359	9.326708
5073	Adamawa	Michika	Sukumu / Tillijo	10.530420	13.353600
5074	Kano	Tsanyawa	Gozaki	12.182529	8.061161
5075	Federal Capital Territory	Abaji	Alu Mamagi	8.513163	6.805569
5076	Kwara	Moro	Bode-Saadu	8.982322	4.766308
5077	Edo	Oredo	Oredo	6.287551	5.594693
5078	Kogi	Kabba-Bunu	Asuta	7.849101	6.182297
5079	Delta	EthiopeE	Agbon  II	5.689275	5.891198
5080	Benue	Kwande	Moon	6.979299	9.648111
5081	Kebbi	Maiyama	Giwa Tazo/Zara	12.085481	4.321280
5082	Abia	Ugwunagbo	Ward Five	5.008760	7.329061
5083	Kaduna	Igabi	Rigasa	10.521375	7.316590
5084	Sokoto	Gwadabaw	Asara  Arewa	13.557089	5.382008
5085	Kano	Garum Mallam	Yalwan  Yadakwari	11.688659	8.401166
5086	Niger	Lavun	Busu/Kuchi	8.869789	6.034175
5087	Yobe	Potiskum	Mamudo	11.658364	11.238274
5088	Imo	Isiala Mbano	Amauzari	5.642510	7.099651
5089	Enugu	Uzo-Uwani	Adaba-nkume	6.571815	7.108115
5090	Federal Capital Territory	Kwali	Yangoji	8.778857	7.077552
5091	Oyo	Ibadan South East	S  S5	7.335975	3.922185
5092	Kaduna	Kajuru	Kajuru	10.271701	7.765579
5093	Enugu	Ezeagu	Oghe II	6.466698	7.278305
5094	Kano	Dawakin Kudu	Gano	11.810425	8.710544
5095	Oyo	Akinyele	Ajibade/Alabata/Elekuru	7.580684	3.842065
5096	Oyo	Atiba	Ashipa III	8.283090	3.900765
5097	Imo	Ngor-Okpala	Ozuzu	5.201320	7.046624
5098	Plateau	Jos South	Bukuru	9.743016	8.813781
5099	Cross River	Abi	Ediba	5.865288	8.035783
5100	Adamawa	Mubi South	Kwaja	10.129018	13.368453
5101	Cross River	Biase	Umon North	5.455952	8.057773
5102	Bayelsa	Nembe	Bassambiri III	4.444701	6.394579
5103	Katsina	Batagarawa	Ajiwa	12.953807	7.704622
5104	Niger	Edati	Fazhi	9.155751	5.622229
5105	Katsina	Daura	Mazoji A	13.018082	8.224152
5106	Taraba	Kurmi	Baissa	7.325290	10.836126
5107	Benue	Agatu	Ogwule Ogbaulu	7.864789	7.730312
5108	Kaduna	Ikara	Rumi	11.442066	8.004398
5109	Yobe	Borsari	Guji / Metalari	12.767578	11.664471
5110	Delta	AniochaN	Issele uku II	6.330406	6.483785
5111	Katsina	Dutsin-M	Kuki A	12.402996	7.586973
5112	Enugu	Enugu North	Umunevo	6.438479	7.506045
5113	Borno	Bama	Sabsabwa / Soye/ Bulongu	11.447566	13.785520
5114	Jigawa	Kazaure	Maradawa	12.621654	8.365496
5115	Abia	Ikwuano	Ibere II	5.455822	7.583774
5116	Kwara	Irepodun	Ipetu/Rore/Aran-Orin	8.056032	5.025964
5117	Kano	Bebeji	Tariwa	11.604009	8.300281
5118	Taraba	Wukari	Jibu	8.090456	9.921267
5119	Edo	Owan West	Avbiosi	6.946767	5.862262
5120	Jigawa	Kaugama	Arbus	12.584009	9.793017
5121	Kano	Kano Municipal	Sheshe	11.943474	8.465293
5122	Rivers	Ogba/Egbema/Andoni	Ndoni  III	5.548985	6.592238
5123	Katsina	Danja	Jiba	11.441137	7.408063
5124	Kano	Ungogo	Bachirawa	12.039626	8.438976
5125	Osun	IfeCentral	Iremo III	7.436426	4.605583
5126	Ekiti	Efon	Efon IV	7.743800	4.939620
5127	Kebbi	Maiyama	Andarai/ Kurunkwu/ Zongun Liba	11.826065	4.422078
5128	Kano	Kura	Dukawa	11.756195	8.591309
5129	Niger	Tafa	Zuma West	9.160279	7.194992
5130	Lagos	Oshodi/Isolo	Orile-Oshodi	6.572377	3.334675
5131	Sokoto	Illela	Araba	13.752429	5.356121
5132	Borno	Monguno	Sure	12.668487	13.758842
5133	Anambra	Idemili South	Oba II	6.072107	6.823403
5134	Osun	Irepodun	Olubu 'B'	7.825123	4.507466
5135	Ondo	Ondo West	Gbaghengha/Gbongbo/Ajagba Alafia	7.058297	4.679092
5136	Benue	Ogbadibo	Ehaje II	6.883502	7.724469
5137	Kaduna	Birnin Gwari	MagajinG1	10.609028	6.612004
5138	Taraba	Gashaka	Garbabi	7.607247	11.040859
5139	Kaduna	Kauru	Bital	10.193683	8.241042
5140	Akwa Ibom	Itu	East Itam I	5.111086	7.923134
5141	Cross River	Obanliku	Bisu	6.614109	9.204633
5142	Kano	Albasu	Fanda	11.589676	9.067180
5143	Edo	Esan South East	Ohordua	6.473435	6.415763
5144	Oyo	Atisbo	Alaga	8.319218	2.944546
5145	Imo	Orlu	Ogberuru/Obibi	5.777011	7.081358
5146	Delta	IkaSouth	Agbor Town I	6.275564	6.161612
5147	Nassarawa	Nasarawa	Nasarawa  Central	8.534875	7.705824
5148	Kogi	Ijumu	Aiyetoro I	8.004794	5.942946
5149	Anambra	Nnewi South	Osumenyi  II	5.931333	6.938845
5150	Taraba	Zing	Dinding	8.843182	11.847552
5151	Ekiti	Ise-Orun	Odo Ise I	7.297223	5.423267
5152	Benue	Buruku	Mbaikyongo/Nyifon	7.374029	9.235276
5153	Delta	IkaSouth	Ihiuiyase I	6.255934	6.097116
5154	Oyo	Egbeda	Olodo II	7.403251	3.967338
5155	Ogun	Abeokuta North	Oke-Ago Owu	7.213577	3.272368
5156	Bauchi	Ningi	Ningi	11.090699	9.545054
5157	Gombe	Funakaye	Kupto	10.703344	11.505477
5158	Lagos	Ikorodu	Ijede I	6.570663	3.618920
5159	Borno	Kala/Balge	Kumaga	12.035531	14.436521
5160	Yobe	Bade	Usur/Dawayo	12.827777	10.881623
5161	Kaduna	Sabon Gari	Bomo	11.189208	7.621191
5162	Niger	Edati	Sakpe	9.067936	5.616905
5163	Yobe	Gulani	Borno Kiji/Tetteba	10.756519	11.748098
5164	Oyo	Orelope	Onigboho/Alomo/Okere	8.886181	3.804158
5165	Kaduna	Kagarko	Aribi	9.567868	7.797518
5166	Edo	Etsako West	Uzairue North West	7.149282	6.261631
5167	Edo	Etsako East	Wanno II	7.098817	6.585168
5168	Oyo	Lagelu	Ajara/Opeodu	7.447905	3.965043
5169	Osun	Ifedayo	Ayetoro	7.972334	4.981565
5170	Anambra	Onitsha North	G.R.A	6.123305	6.790420
5171	Borno	Mafa	Laje	12.120379	13.614234
5172	Ekiti	Ido-Osi	Ifaki I	7.780627	5.232761
5173	Akwa Ibom	Nsit Ubium	Ibiakpan/Obotim II	4.746384	7.938032
5174	Yobe	Yusufari	Guya	13.033921	11.303748
5175	Niger	Gbako	Nuwankota	9.498608	6.014648
5176	Adamawa	Numan	Vulpi	9.423590	11.865277
5177	Lagos	Lagos Island	Olosun	6.451946	3.389809
5178	Rivers	Oyigbo	Azuogu	4.826421	7.428723
5179	Kogi	Adavi	Ino Ziomi/Ipaku/Osisi	7.698649	6.458541
5180	Enugu	Aninri	Mpu	5.996232	7.636867
5181	Delta	Ughelli South	Jeremi IV	5.220124	5.978200
5182	Kogi	Koton-Karfe	Gegu-Beki South	8.185090	6.888972
5183	Rivers	Khana	Sii/Betem/Kbaabbe	4.645998	7.410360
5184	Ogun	Ikenne	Ilisan I	6.910869	3.694586
5185	Cross River	Yakurr	Inyima	5.916617	8.189833
5186	Borno	Magumeri	Gaji Ganna  II	12.193592	12.973446
5187	Benue	Tarka	Mbaikyaa	7.610230	8.901756
5188	Anambra	Anambra West	Umuoba-anam	6.433834	6.828376
5189	Kaduna	Sabon Gari	Basawa	11.189216	7.670196
5190	Sokoto	Goronyo	Kojiyo	13.456615	5.627124
5191	Ebonyi	Abakalik	Azuiyiokwu Layout	6.312256	8.100462
5192	Kwara	Ekiti	Osi II	8.084548	5.249485
5193	Akwa Ibom	Eket	Central I	4.591397	7.959422
5194	Kwara	Isin	Edidi	8.236918	4.948386
5195	Edo	Ovia South West	Ugbogui	6.667287	5.201763
5196	Adamawa	Lamurde	Lafiya	9.674801	11.853807
5197	Ondo	Irele	Iyansan/Omi	6.489581	5.082055
5198	Bayelsa	Southern Ijaw	West Bomo	4.547674	6.012041
5199	Ogun	Ikenne	Ikenne II	6.841380	3.706919
5200	Nassarawa	Kokona	Amba	8.655079	8.150138
5201	Lagos	Ibeju/Lekki	Orimedu I	6.456004	3.753395
5202	Enugu	Ezeagu	Aguobu (Umumba)	6.327932	7.178605
5203	Rivers	Ogba/Egbema/Andoni	Ndoni II	5.567824	6.614569
5204	Delta	Ukwuani	Amai	5.784559	6.226310
5205	Akwa Ibom	Obot Akara	Nto Edino III	5.251577	7.571517
5206	Edo	Ikpoba-Okha	Idogbo	6.249528	5.717470
5207	Jigawa	Birnin Kudu	Yalwan Damai	11.439694	9.313179
5208	Delta	IkaSouth	Boji - Boji I	6.257697	6.188463
5209	Rivers	Gokana	Biara I	4.671029	7.304264
5210	Kogi	Kabba-Bunu	Okekoko	7.819685	6.116428
5211	Rivers	Abua/Odu	Emago-Kugbo	4.743776	6.504892
5212	Ogun	Imeko-Afon	Otapele	7.455839	2.832204
5213	Bayelsa	Ogbia	Otuabula	4.752724	6.304944
5214	Ebonyi	Abakalik	Amagu / Enyigba	6.199287	8.111805
5215	Ogun	Abeokuta South	Ibara II	7.133749	3.314957
5216	Rivers	Ikwerre	Ozuaha	5.065676	6.919124
5217	Sokoto	Goronyo	Shinaka	13.522322	5.684457
5218	Bayelsa	Kolokuma-Opokuma	Seibokorogha (Sabagreia) I	5.018716	6.248278
5219	Anambra	Nnewi South	Ukpor  I	5.885873	6.841098
5220	Anambra	Oyi	Nkwelle Ezunaka II	6.203612	6.860097
5221	Taraba	Ibi	Dampar II	8.662341	10.233106
5222	Jigawa	Guri	Abunabo	12.510899	10.534844
5223	Enugu	Igbo-eze South	Ezema Ward	6.907878	7.349962
5224	Bauchi	Itas/Gadau	Buzawa	11.796931	9.770458
5225	Niger	Rafi	Kongoma Central	10.418574	6.467767
5226	Katsina	Baure	Yanmaulu	12.763973	8.871407
5227	Cross River	Ogoja	Mbube East II	6.552362	8.937564
5228	Bauchi	Katagum	Madara	11.724672	10.456563
5229	Oyo	Ibadan North East	Ward IV  E4	7.353908	3.930229
5230	Katsina	Bindawa	Bindawa	12.677974	7.784307
5231	Kano	Fagge	Kwachiri	12.003566	8.553902
5232	Yobe	Borsari	Kurnawa	12.602866	11.311820
5233	Benue	Gboko	Gboko East	7.332300	9.010849
5234	Kano	Wudil	Lajawa	11.877455	8.868273
5235	Borno	Askira/Uba	Kopa / Multhafu	10.759285	13.326744
5236	Kaduna	Jaba	Fai	9.527994	8.075609
5237	Osun	Odo Otin	Ore/Agbeye	7.972987	4.583331
5238	Abia	Umu-Nneochi	Ezingodo	5.962563	7.416894
5239	Kwara	Moro	Oloru	8.665423	4.611286
5240	Taraba	Jalingo	Turaki 'B'	8.866220	11.459515
5241	Jigawa	Yankwashi	Zungumba	12.744488	8.404128
5242	Jigawa	Kiyawa	Abalago	11.888571	9.717953
5243	Edo	Owan West	Eme-Ora/Oke	6.924780	5.940156
5244	Ekiti	Ikole	Ikole South	7.750709	5.517334
5245	Lagos	Ikorodu	Olorunda/Igbaga	6.677403	3.588191
5246	Ondo	Okitipupa	Igbotako II	6.655707	4.656139
5247	Cross River	Boki	Kakwagom/Bawop	6.492721	8.792953
5248	Oyo	Ibarapa North	Ofiki II	7.742597	3.117845
5249	Kaduna	Zaria	Unguwan Fatika	11.040761	7.678592
5250	Bauchi	Bogoro	B O I "A"	9.626779	9.501361
5251	Kwara	Ekiti	Opin	8.108994	5.272235
5252	Osun	Ayedaade	Otun-Olufi	7.491096	4.356776
5253	Bauchi	Dass	Bagel/Bajar	10.082991	9.509614
5254	Kebbi	Fakai	Kangi	11.537370	4.630716
5255	Kano	Rogo	Zarewa	11.394711	7.803379
5256	Taraba	Lau	Jimlari	9.099793	11.526353
5257	Ogun	Ijebu North	Japara/Ojowo	7.090237	4.102191
5258	Kano	Dawakin Tofa	Dawaki West	12.075270	8.325846
5259	Taraba	Bali	Ganglari	8.579539	11.615155
5260	Enugu	EnuguSou	Uwani East	6.409959	7.483513
5261	Lagos	Amuwo Odofin	Igbologun	6.415325	3.330836
5262	Kogi	Kabba-Bunu	Aiyewa	7.860538	6.099381
5263	Adamawa	Ganye	Gurum	8.363547	11.854551
5264	Yobe	Yunusari	Bultuwa/Mar/Yaro	12.967768	12.053823
5265	Kebbi	Suru	Suru	11.877972	4.192918
5266	Lagos	Apapa	Malu road and Environs	6.459121	3.360081
5267	Oyo	Orelope	Bonni	8.920317	3.720380
5268	Ebonyi	Ohaukwu	Ngbo	6.482973	8.026352
5269	Kaduna	Chikun	Garin Arewa Tirkaniya	10.425038	7.369350
5270	Nassarawa	Toto	Gadagwa	8.375607	7.346586
5271	Cross River	Obanliku	Utanga	6.497795	9.346747
5272	Zamfara	Kaura-Namoda	Dan-Isa	12.369405	6.757286
5273	Ekiti	Ekiti South West	Ilawe I	7.600964	5.091818
5274	Sokoto	Gwadabaw	Chimola Arewa	13.378393	5.354262
5275	Delta	Ughelli South	Jeremi I	5.479658	5.898703
5276	Bauchi	Zaki	Mainako	12.387398	10.438562
5277	Kano	Kumbotso	Na'ibawa	11.898450	8.531872
5278	Anambra	Awka South	Awka  VI	6.215066	7.050385
5279	Lagos	Apapa	Apapa IV (Pelewura Crescent and Environs)	6.425197	3.380211
5280	Akwa Ibom	Ikot Abasi	Ikpa Ibekwe II	4.579465	7.594171
5281	Taraba	Ibi	Dampar III	8.420361	10.000202
5282	Borno	Kwaya Kusar	Kurba	10.430140	11.907620
5283	Kogi	Yagba East	Makutu II	8.316037	5.846074
5284	Rivers	Ahoada East	Uppata I	5.017813	6.623475
5285	Ogun	Ewekoro	Asa/Yobo	6.872974	3.221283
5286	Akwa Ibom	Ukanafun	Southern Afaha, Adat Ifang I	4.866576	7.587493
5287	Katsina	Musawa	Danjanku/Karachi	12.089415	7.704557
5288	Borno	Magumeri	Furram	12.284109	12.813635
5289	Abia	Isiala Ngwa South	Ovuokwu	5.272581	7.394195
5290	Osun	Iwo	Oke-oba  II	7.638798	4.115687
5291	Akwa Ibom	Uruan	Northern Uruan II	5.066514	7.982329
5292	Borno	Marte	Marte	12.371628	13.866720
5293	Anambra	Onitsha North	Ogbe Umuonicha	6.117148	6.767031
5294	Adamawa	Jada	Mapeo	8.726856	12.653570
5295	Enugu	Nkanu West	Agbani	6.273120	7.553755
5296	Anambra	Anaocha	Agulu  III	6.104710	7.020760
5297	Jigawa	Dutse	Dundubus	11.809944	9.192319
5298	Oyo	Itesiwaju	Komu	8.219586	3.183425
5299	Lagos	Shomolu	Ilaje/Akoka	6.539876	3.388029
5300	Adamawa	Madagali	Wula	10.771197	13.599243
5301	Akwa Ibom	Nsit Ubium	Ubium North I	4.737467	7.968274
5302	Lagos	Ifako/Ijaye	Iju-Obawole	6.679399	3.326524
5303	Sokoto	Silame	Gande East	13.055584	4.920778
5304	Kogi	Yagba East	Ilafin/Idofin/Odo-Ogba	8.208254	5.732928
5305	Kano	Nasarawa	Gawuna	12.011920	8.495897
5306	Taraba	Sardauna	Mayo-Ndaga	6.970996	11.513185
5307	Niger	Muya	Kazai	9.717754	7.056126
5308	Bauchi	Bauchi	Birshi/Miri	10.287856	9.719734
5309	Ondo	IleOluji/Okeigbo	Ileoluji II	7.274606	4.931939
5310	Bayelsa	Brass	Sangana	4.378577	6.000169
5311	Akwa Ibom	Nsit Ubium	Ubium South I	4.728324	8.016363
5312	Kebbi	Jega	Jega Magaji 'A'	12.140213	4.441879
5313	Adamawa	Lamurde	Ngbakowo	9.597276	11.697519
5314	Rivers	Tai	Bubu/Bara/Kani	4.770419	7.246018
5315	Oyo	Akinyele	Olorisa-oko/Okegbemi/Mele	7.547223	3.856247
5316	Ondo	Ese-Odo	Arogbo III	6.132074	5.043245
5317	Imo	Ihitte-Uboma Isinweke	Okata	5.635866	7.360581
5318	Benue	Katsina- Ala	Katsina-ala Town	7.169952	9.312365
5319	Imo	Owerri Municipal	Azuzi IV	5.495079	7.021605
5320	Benue	Guma	Nyiev	8.077849	8.558290
5321	Federal Capital Territory	Gwagwalada	Paiko	8.979176	6.924846
5322	Kogi	Ofu	Igo	7.345464	7.404643
5323	Anambra	Onitsha South	Fegge IV	6.071224	6.743205
5324	Rivers	Ikwerre	Isiokpo I	4.922851	6.852982
5325	Borno	Kaga	Guwo	11.604184	12.502604
5326	Rivers	Ogu/Bolo	Bolo III	4.639254	7.189699
5327	Kano	Garko	Garko	11.611002	8.754378
5328	Osun	Iwo	Oke-oba  I	7.639263	4.058681
5329	Kebbi	Yauri	Yelwa North	11.062583	4.587966
5330	Taraba	Takum	Rogo	7.473207	9.972928
5331	Osun	Ife South	Olode	7.282222	4.658743
5332	Akwa Ibom	Okobo	Nung Atai/Ube II	4.836094	8.119941
5333	Jigawa	Roni	Amaryawa	12.551719	8.371129
5334	Sokoto	Goronyo	Giyawa	13.362689	5.542868
5335	Kebbi	Augie	Birnin Tudu/Gudale	12.910055	4.706499
5336	Kebbi	Bunza	Zogrima	12.181415	3.927532
5337	Taraba	Zing	Monkin A	8.831197	11.775221
5338	Katsina	Baure	Mai Bara	12.826649	8.658125
5339	Delta	AniochaN	Issele - Azagba	6.310129	6.556598
5340	Akwa Ibom	Ikot Ekpene	Ikot Ekpene IX	5.191833	7.656373
5341	Ogun	Abeokuta North	Ikereku	7.219987	3.295260
5342	Kaduna	Kudan	Kauran Wali North	11.325908	7.823267
5343	Jigawa	Ringim	Kyarama	12.148845	8.981978
5344	Imo	Ikeduru	Uzoagba	5.527571	7.121763
5345	Cross River	Boki	Buentsebe	6.291694	9.166551
5346	Jigawa	Gwaram	Dingaya	11.208377	10.087939
5347	Kebbi	Koko/Bes	Madacci/Firini	11.336511	4.377920
5348	Ekiti	Irepodun-Ifelodun	Are	7.701545	5.326274
5349	Plateau	Jos South	Vwang	9.689631	8.686663
5350	Ebonyi	Ishielu	Ohofia	6.300128	7.866254
5351	Taraba	Gassol	Gassol	8.588081	10.482736
5352	Oyo	Ibarapa North	Ayete I	7.519687	3.218568
5353	Benue	Vandeikya	Tsambe	6.954303	9.115762
5354	Anambra	Aguata	Ezinifite II	5.962128	7.032897
5355	Oyo	Ibadan North East	Ward XII  E9 II	7.380691	3.932743
5356	Osun	Boripe	Isale-Oyo	7.831090	4.685182
5357	Ebonyi	Ezza South	Amaezekwe	6.121990	8.085464
5358	Osun	Ayedaade	Otun Balogun	7.468075	4.359883
5359	Nassarawa	Keffi	Jigwada	8.867508	7.868142
5360	Lagos	Ikeja	Gra/Police Barracks	6.596789	3.335849
5361	Ogun	Imeko-Afon	Kajola/Agberiodo	7.445209	3.041684
5362	Kano	Tarauni	Daurawa	11.973278	8.519646
5363	Cross River	Obubra	Ababene	5.900515	8.279492
5364	Benue	Obi	Orihi	6.907676	8.309384
5365	Plateau	Kanke	Amper Chika 'A'	9.397474	9.730535
5366	Jigawa	Miga	Miga	12.233796	9.672452
5367	Yobe	Fune	Fune/Ngelzarma/Milbiyar/Lawan Kalam	11.682148	11.665576
5368	Lagos	Epe	Ilara	6.666395	4.050207
5369	Cross River	Bekwarra	Afrike Okpeche	6.593096	8.852039
5370	Taraba	Lau	Abbere II	9.314474	11.661627
5371	Lagos	Ojo	Irewe	6.423969	3.157016
5372	Niger	Bosso	Kodo	9.565604	6.248321
5373	Kano	Ajingi	Toranke	11.939573	9.164285
5374	Gombe	Funakaye	Ribadu	10.666372	11.347178
5375	Delta	AniochaS	Ubulu - Uku II	6.211358	6.405170
5376	Enugu	Oji-River	Achiagu I	6.183132	7.331478
5377	Anambra	Nnewi North	Uruagu  II	6.020861	6.873896
5378	Taraba	Gassol	Gunduma	8.463122	10.818994
5379	Adamawa	Yola North	Yelwa	9.266131	12.504988
5380	Zamfara	Bakura	Dankadu	12.693622	5.939196
5381	Enugu	Udi	Abor	6.472344	7.414973
5382	Kebbi	Jega	Dangamaji	12.114672	4.371330
5383	Kaduna	Kudan	Zabi	11.281335	7.741694
5384	Edo	Etsako West	Uzairue South West	7.088532	6.291027
5385	Ebonyi	Ohaukwu	Wigbeke I	6.652106	8.038633
5386	Lagos	Epe	Orugbo	6.633050	3.782330
5387	Abia	Ohafia	Okamu Ohafia	5.662716	7.870836
5388	Ondo	Irele	Irele III	6.553766	5.005458
5389	Jigawa	Kirika Samma	Kirika Samma	12.680336	10.228347
5390	Delta	Ndokwa East	Afor/Obikwele	5.789534	6.480834
5391	Niger	Shiroro	Kwaki/Chukwuba	10.279234	6.896058
5392	Kaduna	Kudan	Taban Sani	11.248270	7.821760
5393	Rivers	Etche	Igbo III	4.961152	7.041810
5394	Yobe	Gujba	Gujba	11.383698	11.970516
5395	Plateau	Barkin Ladi	Lobiring	9.543315	8.956056
5396	Katsina	Kaita	Yanhoho	13.068628	7.734004
5397	Cross River	Bakassi	Akwa	4.816673	8.594678
5398	Yobe	Bade	Lawan Musa	12.843284	11.037012
5399	Rivers	Okrika	Okrika  IV	4.699262	7.120120
5400	Kwara	Baruten	Kiyoru/Bwen	8.612752	2.832680
5401	Adamawa	Yola North	Rumde	9.284974	12.504593
5402	Oyo	Ibarapa East	Oke -Oba	7.571209	3.381603
5403	Kogi	Bassa	Akuba II	7.718443	7.027112
5404	Kano	Gezawa	Sararin-Gezawa	12.083936	8.763754
5405	Sokoto	Wamakko	Gwamatse	13.039749	5.032840
5406	Nassarawa	Obi	Gidan Ausa I	8.385424	8.534601
5407	Sokoto	Dange-Shuni	Ruggar Gidado	12.920976	5.414181
5408	Akwa Ibom	Eket	Central II	4.637842	7.947686
5409	Cross River	Bakassi	Ambai Ekpa	4.731037	8.513645
5410	Niger	Edati	Gazhe  I	8.947584	5.785687
5411	Katsina	Baure	Kagara/Faski	12.872270	8.792026
5412	Akwa Ibom	Ikot Abasi	Ukpum Ete I	4.609404	7.641495
5413	Ebonyi	Onicha	Ugwu-Oshiri	6.100911	7.888696
5414	Kebbi	Bagudo	Kende/Kurgu	11.509252	4.236648
5415	Borno	Guzamala	Guzamala West	12.754460	13.253401
5416	Sokoto	Yabo	Torankawa	12.750411	4.946380
5417	Kogi	Ogori Magongo	Okesi	7.432671	6.145315
5418	Kano	Kano Municipal	Yakasai	11.947257	8.491526
5419	Kwara	Pategi	Lade I	8.808643	5.651155
5420	Adamawa	Michika	Madzi	10.616846	13.366819
5421	Kogi	Kabba-Bunu	Otu	7.773312	6.189798
5422	Bayelsa	Yenagoa	Attissa I	4.933242	6.259098
5423	Anambra	Onitsha North	American Quarters	6.113509	6.774804
5424	Yobe	Borsari	Kaliyari	12.907882	11.467594
5425	Benue	Oturkpo	Ewulo	7.127940	8.192814
5426	Anambra	Awka South	Awka  VII	6.201731	7.021516
5427	Katsina	Faskari	Mairuwa	11.593399	7.243500
5428	Cross River	Calabar South	Two (2)	4.926430	8.246554
5429	Rivers	Gokana	Mogho	4.657705	7.291192
5430	Kaduna	Kauru	Pari	9.791264	8.536663
5431	Enugu	Udi	Akpa Kwume/Nze	6.638358	7.231689
5432	Ebonyi	Ishielu	Nkalaha	6.591900	7.800443
5433	Abia	Umu-Nneochi	Umuaku	6.010142	7.394177
5434	Plateau	Bassa	Mafara	10.061925	8.741256
5435	Osun	Ife East	Ilode  I	7.388897	4.615446
5436	Osun	Ede North	Olaba/Atapara	7.710904	4.465875
5437	Niger	Bosso	Maitumbi	9.624932	6.606838
5438	Osun	Boripe	Oloti Iragbiji	7.888123	4.696754
5439	Oyo	Egbeda	Egbeda	7.370544	4.046556
5440	Anambra	Onitsha South	Fegge I	6.068368	6.753411
5441	Kano	Bebeji	Baguda	11.632625	8.292200
5442	Akwa Ibom	Ukanafun	Southern Afaha, Adat Ifang II	4.870559	7.637058
5443	Katsina	Kankara	Wawar Kaza	12.023706	7.495238
5444	Imo	Orlu	Okaeke/Okporo	5.784471	7.008067
5445	Akwa Ibom	Oron	Oron UrbanVI	4.809224	8.240173
5446	Jigawa	Kirika Samma	Gayin	12.726854	10.296071
5447	Anambra	Nnewi North	Otolo II	6.002120	6.920101
5448	Osun	Irepodun	Bara 'B'	7.840794	4.495330
5449	Abia	Osisioma	Amator	5.186397	7.279114
5450	Adamawa	Guyuk	Guyuk	9.894583	11.992011
5451	Benue	Ushongo	Lessel	7.121419	9.016362
5452	Kebbi	Shanga	Shanga	11.241737	4.743876
5453	Lagos	Ibeju/Lekki	S2, (Siriwon/Igbekodo I)	6.469904	3.944302
5454	Kebbi	Kalgo	Mutubari	12.216003	4.050890
5455	Katsina	Sandamu	Kwasarawa	12.973036	8.384400
5456	Rivers	Degema	Tomble  I	4.490499	6.944429
5457	Borno	Kala/Balge	Rann "B''/Daima	12.185756	14.523940
5458	Kano	Gwarzo	Lakwaya	11.947486	7.909892
5459	Kano	Dawakin Kudu	Zogarawa	11.861081	8.652743
5460	Kaduna	Sabon Gari	Hanwa	11.142447	7.687719
5461	Katsina	Jibia	Faru	13.035160	7.195969
5462	Kebbi	Augie	Bayawa North	12.851769	4.741071
5463	Oyo	Akinyele	Akinyele/Isabiyi/Irepodun	7.581157	3.918820
5464	Yobe	Nguru	Nglaiwa	12.901187	10.456093
5465	Abia	Isiala Ngwa North	Amapu Ntigha	5.412743	7.415995
5466	Ogun	Remo North	Odofin/Imagbo/Petekun/Dawara	6.946649	3.717302
5467	Zamfara	Anka	Bagega	11.885171	6.108415
5468	Kogi	Kabba-Bunu	Aiyetoro-Kiri	8.279535	6.276823
5469	Kebbi	Sakaba	Doka/Bere	11.167571	5.422530
5470	Jigawa	Yankwashi	Yankwashi	12.728853	8.532022
5471	Edo	Esan South East	Ubiaja I	6.649468	6.360106
5472	Edo	Esan South East	Ewatto	6.555908	6.362324
5473	Zamfara	Anka	Yar'sabaya	12.125263	6.092435
5474	Taraba	Jalingo	Kachalla Sembe	8.826867	11.497073
5475	Ebonyi	Ivo	Amonye	5.927109	7.545977
5476	Oyo	Ibadan South West	Ward 7  SW6	7.378947	3.885645
5477	Kebbi	Maiyama	Liba/Danwa/Kuka Kogo	11.709538	4.413394
5478	Ogun	Egbado South	Ilaro II	6.854438	2.972639
5479	Kogi	Ibaji	Akpanyo	6.814700	6.763704
5480	Imo	Ihitte-Uboma Isinweke	Amainyi	5.588377	7.385138
5481	Borno	Bayo	Wuyo	10.369235	11.849771
5482	Kwara	Irepodun	Omu-Aran II (Ihaye)	8.141753	5.148532
5483	Enugu	Enugu North	Ogbette West	6.421833	7.480070
5484	Benue	Apa	Oba	7.556302	7.812269
5485	Kebbi	Dandi	Shiko	11.793535	3.837892
5486	Nassarawa	Nassarawa Egon	Umme	8.740660	8.617964
5487	Katsina	Sabuwa	Machika	11.443429	7.076140
5488	Cross River	Calabar Municipality	Four	4.964130	8.308483
5489	Zamfara	Gusau	Galadima	12.217956	6.638043
5490	Sokoto	Dange-Shuni	Fajaldu	12.711146	5.489861
5491	Borno	Maiduguri	Mafoni	11.853320	13.210186
5492	Adamawa	Ganye	Gamu	8.232050	12.060170
5493	Jigawa	Taura	Gujungu	12.341138	9.536517
5494	Niger	Lavun	Jima	8.958481	5.915462
5495	Taraba	Gassol	Sarkin Shira	8.587515	10.994098
5496	Akwa Ibom	Mkpat Enin	Ukpum Minya IV	4.732095	7.750659
5497	Kogi	Omala	Oji-Aji	7.600632	7.523836
5498	Kano	Warawa	Tangar	11.950534	8.678005
5499	Kebbi	Zuru	Rikoto	11.453257	5.279463
5500	Zamfara	Maradun	Tsibiri	12.638676	6.251667
5501	Enugu	Awgu	Isu awa/Ogugu/Agbudu/Ituku	6.262625	7.417648
5502	Rivers	Andoni/Odual	Unyeada II	4.534374	7.392765
5503	Taraba	Ussa	Lissam II	7.225167	10.030406
5504	Nassarawa	Toto	Gwargwada	8.309771	7.318413
5505	Cross River	Obudu	Utugwang Central	6.648176	8.977415
5506	Borno	Bayo	Limanti	10.562593	11.783405
5507	Kebbi	Zuru	Rafin Zuru	11.428696	5.234770
5508	Kano	Nasarawa	Kaura Goje	12.023448	8.490368
5509	Zamfara	Gusau	Madawaki	12.167704	6.661351
5510	Ogun	Odeda	Osiele	7.305089	3.431015
5511	Anambra	Aguata	Ekwulobia I	6.018581	7.070755
5512	Kano	Albasu	Saya-saya	11.649223	8.933016
5513	Yobe	Damaturu	Nayinawa	11.732094	11.945008
5514	Kaduna	Kagarko	Kagarko South	9.461416	7.617452
5515	Rivers	Andoni/Odual	Unyeada I	4.510742	7.421492
5516	Enugu	Enugu East	Abakpa I	6.483130	7.536877
5517	Osun	Osogbo	Otun Jagun 'A'	7.772816	4.595685
5518	Enugu	Igbo-eze North	Umuitodo III	6.928922	7.449500
5519	Kano	Kibiya	Kadigawa	11.542001	8.711993
5520	Ekiti	Ekiti West	Aramoko II	7.759539	4.973731
5521	Cross River	Akpabuyo	Atimbo East	4.925362	8.421519
5522	Bauchi	Giade	Isawa	11.564768	10.259046
5523	Enugu	Udenu	Orba I	6.857722	7.450674
5524	Delta	Warri South	Edjeba	5.597053	5.624528
5525	Osun	Orolu	Olufon Orolu 'E'	7.859382	4.476775
5526	Adamawa	Michika	Munkavicita	10.591335	13.429212
5527	Akwa Ibom	Oruk Anam	Ikot Ibritam II	4.775374	7.593759
5528	Kogi	Kabba-Bunu	Aiyeteju	7.840772	6.264884
5529	Kaduna	Jema'a	Asso	9.291567	8.173999
5530	Sokoto	Illela	G/ Hamma	13.607758	5.500651
5531	Kano	Madobi	Rikadawa	11.731651	8.310951
5532	Osun	Egbedore	Iwoye/Idoo/Origo	7.704851	4.382382
5533	Sokoto	Sokoto North	S/Musulmi 'A'	13.060356	5.281976
5534	Kano	Takai	Kuka	11.523251	9.050849
5535	Ekiti	Ise-Orun	Erinwa I	7.320995	5.392334
5536	Ogun	Ogun Waterside	Abigi	6.554543	4.524401
5537	Akwa Ibom	Urue Offong|Oruko	Oruko I	4.735178	8.191399
5538	Federal Capital Territory	Gwagwalada	Gwako	9.022254	7.097024
5539	Sokoto	Shagari	Horo Birni	12.650335	5.242176
5540	Oyo	Ibadan South East	S 3	7.348953	3.908958
5541	Jigawa	Hadejia	Majema	12.450751	10.041874
5542	Delta	AniochaS	Ogwashi - Uku II	6.197095	6.521536
5543	Benue	Makurdi	North Bank II	7.752326	8.563211
5544	Adamawa	Demsa	Demsa	9.341348	12.353469
5545	Benue	Ado	Ogege	6.888480	8.000355
5546	Zamfara	Bukkuyum	Nasarawa	12.011195	5.856116
5547	Ekiti	Ekiti South West	Ilawe VI	7.549488	5.154554
5548	Katsina	Kurfi	Birchi	12.589595	7.506412
5549	Yobe	Gujba	Mallam Dunari	11.443571	12.223154
5550	Katsina	Batsari	Batsari	12.766127	7.242225
5551	Edo	Uhunmwonde	Umagbae South	6.467718	5.721005
5552	Kano	Madobi	Yakun	11.736227	8.268768
5553	Yobe	Machina	Damai	12.950682	9.888199
5554	Kwara	Asa	Ballah/Otte	8.367806	4.408660
5555	Kebbi	Jega	Katanga/Fagada	12.002493	4.510130
5556	Imo	Njaba	Okwudor	5.692845	7.020786
5557	Anambra	Orumba South	Enugu/umonyia	5.978375	7.144087
5558	Ebonyi	Ebonyi	Egwudinagu	6.403508	8.054680
5559	Jigawa	Kazaure	Daba	12.601222	8.510028
5560	Lagos	Shomolu	Mafowoku/Pedro	6.555448	3.376941
5561	Kwara	Ekiti	Osi I	8.059282	5.230261
5562	Yobe	Yunusari	Wadi/Kafiya	13.038809	11.701208
5563	Anambra	Dunukofia	Umudioka  I	6.168492	6.904028
5564	Kebbi	Gwandu	Gulmare	12.304033	4.569631
5565	Borno	Ngala	Ngala Ward	12.256109	14.214317
5566	Anambra	Anambra West	Oroma Etiti-anam	6.330319	6.741244
5567	Yobe	Borsari	Dapchi	12.501990	11.439576
5568	Kano	Rimin Gado	Karofin Yashi	11.897101	8.350933
5569	Akwa Ibom	Nsit Atai	Eastern Nsit IV	4.878176	8.037798
5570	Nassarawa	Karu	Gitata	9.113396	7.893907
5571	Edo	Esan Centtral	Uwessan II	6.783453	6.353147
5572	Niger	Borgu	Babanna	10.350227	3.920643
5573	Benue	Oju	Okpokpo	6.767663	8.374269
5574	Kebbi	Aleiro	Danwarai	12.246848	4.398044
5575	Rivers	Ikwerre	Isiokpo II	5.002981	6.852233
5576	Ekiti	Oye	Ire I	7.728871	5.375293
5577	Yobe	Bade	Zangon Musa/Zango Umaru	12.837543	11.045378
5578	Nassarawa	Lafia	Chiroma	8.494892	8.534420
5579	Kaduna	Birnin Gwari	Kuyelo	11.203169	6.891386
5580	Benue	Ukum	Ugbaam	7.481486	9.666546
5581	Kano	Rano	Saji	11.424646	8.535929
5582	Adamawa	Madagali	Babel	10.852545	13.621830
5583	Plateau	Bassa	Tahu	9.851428	8.730308
5584	Cross River	Obubra	Ochon	5.923676	8.423894
5585	Kaduna	Zaria	Kwarbai "A"	11.055640	7.730297
5586	Bayelsa	Sagbama	Toru-Ebeni	5.007071	6.012491
5587	Yobe	Bade	Gwio-Kura	12.606112	11.089859
5588	Oyo	Kajola	Gbelekale I & II	8.111030	3.399236
5589	Kano	Wudil	Kausani	11.839733	8.856640
5590	Zamfara	Gummi	Illelar Awal	12.193143	5.146284
5591	Cross River	Bekwarra	Abuochiche	6.704990	8.897712
5592	Niger	Chanchaga	Makera	9.595825	6.522391
5593	Benue	Agatu	Egba	7.895024	8.004732
5594	Anambra	Ihiala	Amamu  I	5.814869	6.827655
5595	Lagos	Surulere	Iponri Housing Estate/Eric Moore	6.493800	3.348588
5596	Ebonyi	Ebonyi	Mbeke	6.404445	8.106559
5597	Enugu	Nkanu East	Nkerefi II	6.084623	7.681307
5598	Gombe	Akko	Tumu	10.012350	11.064638
5599	Jigawa	Auyo	Tsidir	12.346861	9.968430
5600	Kano	Madobi	Gora	11.818152	8.331193
5601	Kano	Rogo	Ruwan Bago	11.459037	7.767725
5602	Yobe	Gulani	Ruhu	10.641124	11.681522
5603	Rivers	Abua/Odu	Agada	4.797394	6.501224
5604	Kaduna	Makarfi	Gazara	11.399208	7.955492
5605	Jigawa	Garki	Siyori	12.307281	9.283827
5606	Osun	Ola-Oluwa	Isero/Ikonifin	7.758296	4.113734
5607	Sokoto	Tangazar	Tangaza	13.374289	4.904286
5608	Zamfara	Talata-Mafara	Sauna R/ Gora	12.368430	6.018260
5609	Enugu	Igbo-Eti	Ekwegbe II	6.725335	7.454818
5610	Enugu	Ezeagu	Imezi Owa II	6.396818	7.341911
5611	Plateau	Jos South	Gyel 'A'	9.729781	8.756922
5612	Borno	Biu	Dugja	10.658204	12.130269
5613	Ogun	Abeokuta South	Imo/Isabo	7.157550	3.320888
5614	Akwa Ibom	Uruan	Southern Uruan VI	4.878830	8.083430
5615	Kebbi	Kalgo	Kalgo	12.274041	4.198991
5616	Yobe	Borsari	Bayamari	12.767895	11.537560
5617	Enugu	Nsukka	Ibagwani/Ibagwaga Okpaligbo	6.950509	7.287917
5618	Kaduna	Jema'a	Kafanchan 'A'	9.507746	8.291932
5619	Edo	Esan Centtral	Ewu II	6.784393	6.215492
6134	Oyo	Irepo	Atipa	9.066588	3.922314
5620	Bauchi	Bauchi	Kundum/Durum	10.465375	9.731897
5621	Bauchi	Jama'are	Galdimari	11.681691	10.049745
5622	Kwara	Ilorin West	Baboko	8.489246	4.544119
5623	Ogun	Obafemi-Owode	Ajura	6.897672	3.483073
5624	Jigawa	Gagarawa	Kore Balatu	12.382586	9.422054
5625	Bauchi	Ningi	Jangu	10.929917	9.552893
5626	Jigawa	Jahun	Aujara	12.045736	9.446144
5627	Ondo	AkokoNorthWest	Okeagbe	7.633466	5.772682
5628	Abia	Isiala Ngwa South	Mbutu Ngwa	5.304828	7.353106
5629	Osun	Ifedayo	Asaoni	8.020690	5.045558
5630	Imo	Ideato North	Umuopia/Umukegwu	5.891850	7.133898
5631	Anambra	Awka South	Amawbia  I	6.204356	7.044137
5632	Akwa Ibom	Essien Udim	Ikpe Annang	5.115560	7.763018
5633	Kwara	Isin	Oke Aba	8.300900	4.991202
5634	Borno	Hawul	Kida	10.558369	12.255229
5635	Borno	Bama	Andara / Ajiri /Wulba	11.489515	14.451448
5636	Borno	Maiduguri	Gwange  III	11.809793	13.242452
5637	Anambra	Ihiala	Okija  III	5.884564	6.801090
5638	Adamawa	Lamurde	Dubwangun	9.592787	11.867759
5639	Rivers	Okrika	Okrika  V	4.710837	7.146857
5640	Rivers	Akukutor	Kula  II	4.482342	6.740615
5641	Akwa Ibom	Mkpat Enin	Ukpum Minya III	4.678092	7.741696
5642	Osun	Ila	Ejigbo  II	8.014693	4.904215
5643	Adamawa	Maiha	Manjekin	10.049994	13.202657
5644	Osun	Ilesha East	Itisin/Ogudu	7.595532	4.759083
5645	Nassarawa	Lafia	Keffin/Wambai	8.559819	8.307452
5646	Imo	Ehime-Mbano	Nsu 'B' Ihitte	5.643471	7.333923
5647	Edo	Akoko Edo	Somorika / Ogbe / Sasaro / Onumu / Eshawa / Ogugu Igboshi-Afe / Igboshi - Ele / Aiyegunle	7.376550	6.078576
5648	Bauchi	Warji	Tiyin	11.128969	9.842710
5649	Plateau	Barkin Ladi	Kurra Falls	9.385141	8.765509
5650	Osun	Ayedire	Ileogbo  III	7.598581	4.269341
5651	Borno	Dikwa	Ngudoram	12.031903	13.991758
5652	Federal Capital Territory	Bwari	Byazhin	9.205160	7.320310
5653	Taraba	Ibi	Ibi Rimi Uku I	8.166724	9.750522
5654	Kaduna	Soba	Dan Wata	10.956745	8.191633
5655	Oyo	Kajola	Ijo	8.036996	3.296410
5656	Gombe	Dukku	Hashidu	10.907488	10.653180
5657	Delta	Ukwuani	Akoku	5.870838	6.298091
5658	Ogun	Ado Odo-Ota	Atan	6.671229	2.993365
5659	Kaduna	Kaduna North	Hayin Banki	10.578571	7.437347
5660	Niger	Kontogur	Gabas	10.426966	5.508293
5661	Ebonyi	Afikpo North	Amogu Akpoha	5.948345	7.966483
5662	Kano	Nasarawa	Tudun Wada	12.005028	8.497542
5663	Benue	Tarka	Tongov	7.625778	8.811007
5664	Benue	Okpokwu	Okpoga West	7.025384	7.778287
5665	Zamfara	Birnin Magaji	Madomawa West	12.510440	6.702840
5666	Kwara	Isin	Olla	8.203306	5.163942
5667	Enugu	Isi-Uzo	Ehamufu IV	6.681399	7.719294
5668	Niger	Lapai	Evuti/Kpada	8.558976	6.677597
5669	Niger	Muya	Dangunu	9.983975	7.075203
5670	Borno	Bama	Marka / Malge / Amchaka	11.659343	14.392407
5671	Ondo	Akoko South-West	Oka II A Ikanmu	7.460148	5.806581
5672	Kano	Rano	Zinyau	11.484423	8.523301
5673	Plateau	Kanam	Kunkyam	9.279721	9.969522
5674	Enugu	Ezeagu	Awha	6.410496	7.256284
5675	Osun	Ifelodun	Ikirun Rural	7.869349	4.635644
5676	Katsina	Jibia	Yangaiya	13.026943	7.340113
5677	Enugu	Nkanu East	Ugbawka I	6.227306	7.596966
5678	Ebonyi	Ezza North	Inyere	6.194024	7.926916
5679	Rivers	Abua/Odu	Abua III	4.850604	6.658530
5680	Katsina	Batsari	Wagini	12.681380	7.126041
5681	Sokoto	Gwadabaw	Gigane	13.473384	5.224251
5682	Abia	Oboma Ngwa	Akumaimo	5.050038	7.415197
5683	Kano	Dala	Madigawa	11.993158	8.457919
5684	Borno	Gwoza	Ashigashiya	11.147964	13.863571
5685	Borno	Chibok	Chibok Likama	10.932160	12.846964
5686	Plateau	Bassa	Rimi	10.280169	8.874037
5687	Niger	Magama	Nasko	10.487197	4.959094
5688	Akwa Ibom	Obot Akara	Obot Akara II	5.297293	7.644623
5689	Kano	Dambatta	Danbatta East	12.397388	8.536801
5690	Kano	Garko	Kwas	11.558096	8.759405
5691	Borno	Nganzai	Maiwa	12.198343	13.284863
5692	Yobe	Yusufari	Mai-Malari	13.096768	11.055079
5693	Adamawa	Fufore	Mayo Ine	9.126123	12.281078
5694	Abia	Ukwa East	Obohia	4.879656	7.452809
5695	Jigawa	Sule Tankarkar	Shabaru	12.555507	9.180108
5696	Taraba	Jalingo	Kona	8.943480	11.378422
5697	Enugu	Udi	Ngwo Uno	6.429233	7.392636
5698	Kano	Gezawa	Mesar-Tudu	12.121521	8.709417
5699	Osun	Iwo	Molete  III	7.651040	4.199237
5700	Edo	Uhunmwonde	Ehor	6.662133	6.012951
5701	Edo	Orhionmw	Aibiokunla I	6.295604	6.019520
5702	Kano	Tsanyawa	Tatsan	12.290411	8.048933
5703	Jigawa	Hadejia	Kasuwar Kofa	12.447694	10.042265
5704	Jigawa	Taura	Kiri	12.275799	9.478626
5705	Katsina	Sabuwa	Dugun Mu'azu	11.388931	6.988001
5706	Akwa Ibom	Ibeno	Ibeno I	4.570497	8.002190
5707	Kaduna	Kudan	Kauran Wali South	11.299869	7.853289
5708	Edo	Orhionmw	Igbanke West	6.354541	6.161810
5709	Kwara	Ilorin South	Balogun-Fulani III	8.453934	4.702296
5710	Rivers	Abua/Odu	Emughan  I	4.902296	6.584629
5711	Benue	Tarka	Mbachaver Ikyondo	7.582637	8.863319
5712	Plateau	Pankshin	Dok-Pai	9.181815	9.580713
5713	Katsina	Rimi	Sabon Garin/Alarain	12.723844	7.732448
5714	Sokoto	Rabah	Riji/Maikujera	13.099414	5.544711
5715	Kaduna	Kajuru	Rimau	10.382276	7.779328
5716	Oyo	Orelope	Igbope/Iyeye I	8.846667	3.899954
5717	Rivers	Akukutor	Manuel  II	4.721427	6.739028
5718	Benue	Kwande	Mbaikyor	6.911864	9.525388
5719	Borno	Bama	Kumshe /Nduguno	11.422906	14.207317
5720	Anambra	Orumba South	Umunze II	5.971568	7.252391
5721	Abia	Ukwa East	Ikwueke East	4.890896	7.370103
5722	Kogi	Ajaokuta	Badoko	7.540753	6.530248
5723	Kwara	Moro	Malete/Gbugudu	8.667534	4.485957
5724	Benue	Gboko	Gbk/Central Market	7.323201	9.000899
5725	Kebbi	Maiyama	Sarandosa/Gubba	12.017682	4.357948
5726	Taraba	Ardo-Kola	Ardo Kola	8.716372	11.434624
5727	Jigawa	Jahun	Jahun	12.081103	9.593435
5728	Lagos	Ojo	Ijanikin	6.508490	3.128425
5729	Lagos	Epe	Popo-Oba	6.579794	3.980635
5730	Katsina	Kafur	Sabuwar Kasa	11.543349	7.639154
5731	Kogi	Okehi	Oboroke Uvete II	7.630676	6.137067
5732	Anambra	Nnewi South	Ekwulumili	5.945474	6.973591
5733	Ebonyi	Ivo	Amagu	5.936209	7.562841
5734	Osun	Orolu	Olufon Orolu 'J'	7.897513	4.476311
5735	Ondo	Okitipupa	Ilutitun I	6.522261	4.615149
5736	Jigawa	Auyo	Gamafoi	12.280058	9.934997
5737	Akwa Ibom	Eastern Obolo	Eastern Obolo I	4.542309	7.757798
5738	Jigawa	Guri	Garbagal	12.712213	10.509624
5739	Nassarawa	Doma	Rukubi	8.083110	8.140175
5740	Imo	Owerri North	Naze	5.419949	7.061981
5741	Niger	Mariga	Kumbashi	10.902016	5.667031
5742	Jigawa	Babura	Gasakoli	12.477802	8.751505
5743	Kwara	Offa	Ojomu Central I	8.184538	4.704041
5744	Niger	Muya	Kuchi	9.935084	6.944337
5745	Lagos	Ibeju/Lekki	Lekki II	6.420306	4.090791
5746	Akwa Ibom	Nsit Ibom	Mbaiso II	4.818198	7.915554
5747	Kogi	Igalamela-Odolu	Odolu	7.061224	7.094672
5748	Ekiti	Ilejemeje	Iludun II	7.921921	5.250575
5749	Anambra	Orumba South	Umuomaku	5.937875	7.164492
5750	Delta	Ndokwa West	Abbi I	5.652951	6.199016
5751	Kwara	Ifelodun	Share IV	8.876731	4.890152
5752	Benue	Katsina- Ala	Utange	7.379954	9.722527
5753	Kwara	Ilorin East	Agbeyangi/Gbadamu/Osin	8.550430	4.725502
5754	Cross River	Odukpani	Eniong	5.308661	7.928381
5755	Enugu	Oji-River	Oji-river II	6.218177	7.270560
5756	Lagos	Amuwo Odofin	Amuwo-Odofin Housing Estate, Mile 2	6.496061	3.303516
5757	Bayelsa	Nembe	Oluasiri	4.535651	6.499133
5758	Bauchi	Warji	Tudun Wada East	11.182049	9.640898
5759	Plateau	Qua'anpa	Kwalla Moeda	8.854408	9.274774
5760	Gombe	Dukku	Waziri North	10.830714	10.978591
5761	Yobe	Potiskum	Ngojin/Alaraba	11.609809	11.133883
5762	Enugu	Nsukka	Eha-Uno	6.812479	7.490858
5763	Cross River	Etung	Itaka	5.747943	8.790882
5764	Ondo	Akoko North-East	Oorun II	7.519087	5.752462
5765	Anambra	Orumba South	Owerre-ezukala  II	6.028881	7.325513
5766	Jigawa	Gwaram	Basirka	11.091400	10.241198
5767	Kano	Gabasawa	Garun Danga	12.206326	8.824350
5768	Zamfara	Zurmi	Kwashbawa	12.936039	6.913150
5769	Osun	Olorunda	Owode  I	7.779908	4.559971
5770	Katsina	Danmusa	Mai Dabino A	12.147881	7.358427
5771	Rivers	Gokana	B-Dere	4.681906	7.264345
5772	Enugu	Igbo-Eti	Ukehe II	6.666054	7.404968
5773	Imo	Obowo	Umuariam/Achara	5.521762	7.360205
5774	Yobe	Nguru	Dabule	12.977613	10.450942
5775	Anambra	Awka North	Achalla  II	6.338717	7.016618
5776	Imo	Owerri North	Emekuku II	5.494345	7.098999
5777	Enugu	Ezeagu	Umana Ndiagu	6.349274	7.273789
5778	Kwara	Ilorin West	Oloje	8.523660	4.522061
5779	Lagos	Ibeju/Lekki	N2, (Ibeju II)	6.465842	3.833209
5780	Niger	Suleja	Iku South I	9.117712	7.155559
5781	Yobe	Gulani	Gagure	10.878825	11.620692
5782	Niger	Kontogur	Tunganwawa	10.305664	5.294148
5783	Benue	Logo	Yonov	7.620912	9.342780
5784	Taraba	Ardo-Kola	Mayo Ranewo	8.873506	10.986405
5785	Cross River	Bekwarra	Ibiaragidi	6.664347	8.909313
5786	Kano	Garko	Raba	11.656896	8.757689
5787	Kwara	Oke-Ero	Imode/Egosi	8.101653	5.164792
5788	Niger	Rafi	Kushirki South	10.339590	6.123659
5789	Bauchi	Katagum	Yayu	11.556458	10.600539
5790	Bauchi	Shira	Bukul/Bangire	11.272505	10.069902
5791	Zamfara	Gummi	Magajin Gari	11.991478	5.306203
5792	Borno	Magumeri	Ayi / yasku	12.371179	12.399606
5793	Anambra	Oyi	Awkuzu  III	6.231289	6.898152
5794	Imo	Owerri West	Ihiagwa	5.302822	7.011826
5795	Borno	Shani	Gora	10.061627	12.016968
5796	Niger	Kontogur	Tungan Kawo	10.395036	5.389532
5797	Benue	Obi	Adiko	6.958590	8.375020
5798	Akwa Ibom	Uruan	Central Uruan III	4.975413	8.039847
5799	Sokoto	Gada	Kaddi	13.637274	5.761545
5800	Kebbi	Koko/Bes	Maikwari/ Karamar/ Damba/ Bakoshi	11.363164	4.428697
5801	Ebonyi	Ebonyi	Kpirikpiri	6.528430	8.145121
5802	Akwa Ibom	Eket	Central V	4.565026	7.906887
5803	Kebbi	Suru	Daniya/Shema	11.970277	4.109336
5804	Kebbi	Birnin Kebbi	Laga	12.410398	4.488223
5805	Bayelsa	Yenagoa	Attissa III	4.864000	6.239894
5806	Katsina	Mani	Machika	12.844824	7.843244
5807	Enugu	Oji-River	Inyi II	6.126263	7.284703
5808	Delta	IsokoNor	Emevor	5.553564	6.128676
5809	Kano	Kano Municipal	Zaitawa	11.958912	8.495791
5810	Plateau	Jos North	Tudun Wada - Kabong	9.876711	8.829182
5811	Osun	Ayedire	Ileogbo  IV	7.613453	4.265431
5812	Abia	Ikwuano	Oboro I	5.466003	7.554282
5813	Yobe	Gulani	Gabai	11.114507	11.659428
5814	Rivers	Etche	Owu	5.148314	6.967833
5815	Bauchi	Itas/Gadau	Abdallawa/Magarya	11.829876	9.738146
5816	Ekiti	Emure	Ida Mudu I	7.421184	5.519597
5817	Enugu	Nsukka	Nnu	6.830268	7.424509
5818	Katsina	Danmusa	Mai Dabino B	12.172815	7.243730
5819	Taraba	Gashaka	Serti "A"	7.490559	11.400477
5820	Adamawa	Yola North	Nassarawo	9.264812	12.495331
5821	Delta	Okpe	Ughoton	5.617658	5.704187
5822	Benue	Kwande	Kumakwagh	7.153531	9.725254
5823	Bayelsa	Kolokuma-Opokuma	Igbedi	4.953342	6.155861
5824	Jigawa	Gumel	Gusau	12.607376	9.390527
5825	Borno	Konduga	Jewu / Lamboa	11.737613	12.802000
5826	Kogi	Koton-Karfe	Koton-Karfe South East	7.984073	6.811913
5827	Rivers	Bonny	Ward V Finima	4.398781	7.175466
5828	Rivers	Oyigbo	Egburu	4.797416	7.303599
5829	Plateau	Riyom	Danto	9.627599	8.637353
5830	Katsina	Batsari	Manawa	12.780771	7.166700
5831	Oyo	Saki West	Bagii	8.530777	3.264299
5832	Delta	Ughelli South	Jeremi II	5.390289	5.858274
5833	Bauchi	Giade	Zirrami	11.555869	10.337898
5834	Ogun	Ewekoro	papalanto	6.917226	3.252384
5835	Benue	Obi	Ogore	6.957595	8.164967
5836	Oyo	Atiba	Oke-afin II	7.910478	3.949146
5837	Kogi	Ajaokuta	Adogu/Apamira/Ogodo Uhuovene	7.318089	6.531608
5838	Rivers	Ahoada East	Uppata  IV	4.962706	6.619872
5839	Rivers	Gokana	Bera	4.661968	7.298924
5840	Borno	Mobbar	Layi	13.173717	12.590418
5841	Taraba	Yorro	Nyaja I	8.911443	11.591980
5842	Nassarawa	Nasarawa	Ara I	8.686717	7.551320
5843	Nassarawa	Doma	Madauchi	8.389558	8.354491
5844	Adamawa	Mayo-Belwa	Tola	8.742713	12.077354
5845	Abia	Ohafia	Agboji Abiriba	5.706534	7.773898
5846	Enugu	Uzo-Uwani	Umulokpa	6.512283	7.062299
5847	Plateau	Jos South	Zawan 'B'	9.779971	8.813825
5848	Enugu	Aninri	Oduma II	6.112193	7.616389
5849	Kogi	Ogori Magongo	Obinoyin	7.476449	6.145032
5850	Cross River	Abi	Usumutong	5.835762	8.003155
5851	Rivers	Port Harcourt	Orogbum	4.783081	7.020751
5852	Kano	Tarauni	Babban giji	11.963641	8.508109
5853	Oyo	Orelope	Alepata	8.692841	3.819438
5854	Plateau	Mangu	Chanso	9.584287	9.259223
5855	Cross River	Biase	Adim	5.729851	8.016063
5856	Adamawa	Demsa	Dilli	9.542972	12.212276
5857	Kano	Warawa	Jemagu	11.864848	8.730958
5858	Kogi	Ofu	Ochadamu	7.328077	6.981405
5859	Akwa Ibom	Ibesikpo Asutan	Ibesikpo IV	4.938121	7.972458
5860	Anambra	Oyi	Nkwelle Ezunaka I	6.167175	6.830060
5861	Kebbi	Fakai	Gulbin Kuka/Maijarhula	11.464718	4.832541
5862	Abia	Isuikwuato	Ogunduasa	5.738508	7.429172
5863	Rivers	Port Harcourt	Port Harcourt Township	4.736240	6.997607
5864	Anambra	Oyi	Nteje  IV	6.256444	6.926976
5865	Ebonyi	Onicha	Agbabor-Isu	6.190248	7.819093
5866	Ogun	Egbado South	Idogo	6.691691	2.869500
5867	Edo	Ovia North East	Okada east	6.620168	5.443822
5869	Plateau	Kanke	Amper Chika 'B'	9.333704	9.730029
5870	Ebonyi	Ishielu	Ezzagu II (Nkomoro)	6.293259	7.750497
5871	Imo	Owerri Municipal	Aladinma II	5.483335	7.059151
5872	Delta	Warri South	Okumagba II	5.623967	5.633069
5873	Anambra	Onitsha South	Odoakpu  IV	6.077456	6.742874
5874	Osun	Irepodun	Elerin 'A'	7.802850	4.479969
5875	Enugu	Nkanu East	Amankanu/Ogbahu	6.557795	7.675016
5876	Kano	Bagwai	Kiyawa	12.121621	8.168240
5877	Oyo	Orelope	Onibode III	8.812867	3.711812
5878	Plateau	Barkin Ladi	Kapwis	9.669343	9.027803
5879	Kogi	Igalamela-Odolu	Oforachi I	7.030954	6.824310
5880	Osun	Ola-Oluwa	Asamu/Ilemowu	7.670397	4.289923
5881	Adamawa	Yola North	Alkalawa	9.254905	12.505970
5882	Lagos	Epe	Agbowa Ikosi	6.634319	3.706148
5883	Bayelsa	Sagbama	Osekwenike	5.283315	6.458858
5884	Imo	Aboh-Mbaise	Umuhu	5.424576	7.256799
5885	Enugu	Igbo-eze North	Umuozzi V	6.981806	7.444794
5886	Abia	Oboma Ngwa	Abayi  I	5.126699	7.433302
5887	Rivers	Ogba/Egbema/Andoni	Egi I	5.228979	6.642324
5888	Nassarawa	Keana	Galadima	8.223774	8.617296
5889	Benue	Agatu	Ogbaulu	7.781081	7.986668
5890	Plateau	Mangu	Ampang west	9.282496	9.163728
5891	Ebonyi	Ezza North	Oriuzor	6.296938	8.019171
5892	Bayelsa	Kolokuma-Opokuma	Kaiama/Olobiri	5.104085	6.319739
5893	Akwa Ibom	Nsit Atai	Eastern Nsit III	4.834391	8.018743
5894	Federal Capital Territory	Kuje	Kabi	8.694912	7.379535
5895	Kebbi	Yauri	Yelwa Central	11.014450	4.509101
5896	Imo	Ideato South	Isiekenesi I	5.780687	7.143395
5897	Akwa Ibom	Itu	East Itam IV	5.153693	7.977230
5898	Taraba	Lau	Garin Dogo	9.080777	11.346621
5899	Borno	Nganzai	Jigalta	12.572400	13.362427
5900	Ekiti	Moba	Ikun II	7.970924	5.174974
5901	Anambra	Onitsha North	Inland Town VIII`	6.114788	6.807657
5902	Plateau	Qua'anpa	Kwa	9.007465	9.236724
5903	Kebbi	Yauri	Yelwa East	10.915893	4.822474
5904	Plateau	Langtang North	Keller	9.159691	9.860822
5905	Oyo	Egbeda	Osegere/Awaye	7.369589	4.102285
5906	Imo	Okigwe	Aku	5.850116	7.305320
5907	Akwa Ibom	Ikono	Ediene I	5.156458	7.813629
5908	Kano	Bichi	Yallami	12.234747	8.321296
5909	Kano	Dawakin Kudu	Tamburawa	11.836768	8.522130
5910	Cross River	Ogoja	Nkum Iborr	6.559179	8.718343
5911	Lagos	Lagos Mainland	Epetedo	6.480313	3.366171
5912	Kaduna	Kaduna South	Kakuri Gwari	10.439594	7.406995
5913	Zamfara	Bungudu	Kwatarkwashi	12.176933	6.818687
5914	Kwara	Isin	Oke Onigbin	8.180109	5.041308
5915	Kano	Garum Mallam	Chiromawa	11.604532	8.353904
5916	Kano	Albasu	Gagarame	11.590783	9.240032
5917	Niger	Bida	Masaba  II	9.088363	6.008799
5918	Lagos	Ajeromi/Ifelodun	Temidire I	6.454477	3.329979
5919	Ebonyi	Ezza North	Oshiegbe Umuezeokoha	6.243463	8.038518
5920	Kogi	Yagba East	Itedo	8.336246	5.979805
5921	Oyo	Ibarapa Central	Isale-Oba	7.442932	3.172420
5922	Bauchi	Damban	Jalam East	11.485273	10.895066
5923	Benue	Gwer East	Akpach'ayi	7.084273	8.388833
5924	Bayelsa	Brass	Okpoama	4.437800	6.613038
5925	Delta	AniochaN	Ukwu - Nzu	6.424530	6.482918
5926	Oyo	Oyo West	Opapa	7.855740	3.925861
8393	Kebbi	Dandi	Buma	11.644393	3.750970
5927	Kogi	Omala	Akpacha	7.660228	7.584874
5928	Niger	Wushishi	Akare	9.746626	5.901993
5929	Lagos	Amuwo Odofin	Festac I	6.491731	3.246608
5931	Sokoto	Bodinga	Bodinga/Tauma	12.803345	5.190735
5932	Ekiti	Ise-Orun	Oraye I	7.489819	5.317417
5933	Kebbi	Kalgo	Badariya/Magarza	12.206616	4.214428
5934	Bauchi	Katagum	Madachi/Gangai	11.514367	10.486429
5935	Rivers	Eleme	Ekporo	4.724209	7.204873
5936	Delta	IkaSouth	Boji - Boji III	6.264865	6.237461
5937	Adamawa	Girie	Gerei I	9.363498	12.612544
5938	Delta	IsokoNor	Iluelogbo	5.587681	6.205246
5939	Sokoto	Sokoto North	S/Adar/G/Igwai	13.072553	5.245507
5940	Oyo	Saki East	Oje owode II	8.638962	3.524307
5941	Kano	Dawakin Kudu	Yargaya	11.877265	8.643826
5942	Gombe	Billiri	Kalmai	9.920233	11.155319
5943	Lagos	Apapa	Ijora-Oloye	6.463436	3.366372
5944	Plateau	Kanam	Kantana	9.541434	10.123806
5945	Delta	Burutu	Tuomo	5.061009	5.691082
5946	Zamfara	Tsafe	Bilbis	11.855330	6.951893
5947	Gombe	Kwami	Jurara	10.543987	11.465228
5948	Rivers	Akukutor	Kula  I	4.393255	6.724069
5949	Bayelsa	Sagbama	Angalabiri	5.095878	6.080721
5950	Kebbi	Ngaski	Makawa Uleira	10.528814	4.634523
5951	Adamawa	Mubi South	Mugulbu/ Yadafa	10.167732	13.332980
5952	Osun	Ifelodun	Obagun	7.931465	4.691292
5953	Niger	Bida	Umaru/Majigi  I	9.077815	6.009979
5954	Niger	Agaie	Etsugaie	9.113755	6.336097
5955	Ekiti	Emure	Ogbontioro I	7.424384	5.444868
5956	Sokoto	Isa	Turba	13.265642	6.339409
5957	Ebonyi	Ohaukwu	Ishi Ngbo I	6.518878	7.951422
5958	Kaduna	Zaria	Unguwan Juma	11.004920	7.683636
5959	Adamawa	Lamurde	Waduku	9.483128	11.676784
5960	Jigawa	Guri	Guri	12.710121	10.382445
5961	Sokoto	Wamakko	Kalambaina/Girabshi	13.037259	5.210275
5962	Osun	Isokan	Alapomu  I (Odo-Osun)	7.292805	4.174062
5963	Kano	Kibiya	Fassi	11.390449	8.593777
5964	Adamawa	Maiha	Mayonguli	10.049171	13.247927
5965	Kano	Bagwai	Dangada	12.012457	8.150091
5966	Rivers	Ahoada East	Akoh  I	5.107220	6.671747
5967	Ogun	Ijebu-Ode	Ijade/Imepe II	6.827383	3.890182
5968	Akwa Ibom	Udung Uko	Udung Uko III	4.739539	8.224283
5969	Imo	Owerri Municipal	New Owerri II	5.458035	7.024474
5970	Rivers	Obio/Akpor	Oro-Igwe	4.877351	7.035672
5971	Sokoto	Bodinga	Takatuku/Madorawa	12.899708	5.244744
5972	Kaduna	Kajuru	Buda	10.295909	7.689748
5973	Delta	Uvwie	Ekpan I	5.576781	5.722498
5974	Abia	Umu-Nneochi	Amuda	5.994117	7.369878
5975	Niger	Mashegu	Saho-Rami	9.849447	5.293230
5976	Anambra	Ogbaru	Ossomala	5.812229	6.672640
5977	Rivers	Emuoha	Rumuekpe	4.959779	6.676031
5978	Katsina	Jibia	Jibia B	13.095552	7.237793
5979	Plateau	Jos East	Maijuju	9.756535	9.107699
5980	Delta	IsokoNor	Okpe - Isoko	5.472834	6.375127
5981	Akwa Ibom	Ukanafun	Northern Ukanafun II	4.975517	7.712121
5982	Kwara	Asa	Afon	8.252653	4.513813
5983	Kaduna	Jema'a	Maigizo 'A'	9.540699	8.315170
5984	Kaduna	Makarfi	Nassarawan Doya	11.241696	7.957834
5985	Osun	Ife South	Ikija  II	7.204778	4.719083
5986	Akwa Ibom	Okobo	Ekeya	4.892395	8.138799
5987	Plateau	Bassa	Gurum	10.066850	8.826039
5988	Edo	Esan Centtral	Otoruwo II	6.738849	6.201387
5989	Kaduna	Igabi	Birnin Yero	10.820096	7.562343
5990	Ekiti	Ilejemeje	Iye III	7.934141	5.180773
5991	Yobe	Tarmuwa	Jumbam	12.432445	11.613401
5992	Rivers	Bonny	Ward XI Peterside	4.506948	7.155168
5993	Rivers	Ogu/Bolo	Bolo  IV	4.669573	7.218200
5994	Bauchi	Darazo	Lanzai	11.372176	10.830614
5995	Abia	Ukwa West	Obuzor	4.964250	7.201986
5996	Sokoto	Tureta	Duma	12.603882	5.353216
5997	Delta	IsokoNor	Owhe/Akiehwe	5.511621	6.149406
5998	Bauchi	Gamawa	Udubo	12.025535	10.700913
5999	Zamfara	Talata-Mafara	Garbadu	12.404316	6.108583
6000	Jigawa	Kiyawa	Andaza	11.763487	9.478091
6001	Jigawa	Guri	Musari	12.496027	10.405335
6002	Ekiti	Ekiti South West	Ogotun II	7.511349	4.993424
6003	Lagos	Mushin	Kayode/Fadeyi	6.552370	3.356682
6004	Kogi	Ibaji	Ujeh	6.585394	6.709913
6005	Kano	Dambatta	Fagwalawa	12.309911	8.709364
6006	Kaduna	Lere	Yar Kasuwa	10.497187	8.480931
6007	Oyo	Kajola	Elero	8.127450	3.373933
6008	Akwa Ibom	Ibeno	Ibeno IV	4.529981	7.869933
6009	Oyo	Ibarapa North	Ayete II	7.532568	3.284820
6010	Katsina	Dandume	Dantankari	11.425062	7.187465
6011	Ogun	Ikenne	Ilisan/Irolu	6.925853	3.654933
6012	Oyo	Oluyole	Idi-Iroko/Ikereku	7.306791	3.830334
6013	Kwara	Kaiama	Gwanabe II	9.507084	3.978241
6014	Akwa Ibom	Ikono	Ikono Middle III	5.288852	7.723776
6015	Kaduna	Soba	Turawa	11.080993	8.093602
6016	Plateau	Pankshin	Wokkos	9.264915	9.420809
6017	Lagos	Alimosho	Ipaja North	6.604667	3.246085
6018	Abia	Umuahia North	Umuahia Urban  III	5.567727	7.470978
6019	Niger	Chanchaga	Minna South	9.583998	6.491906
6020	Lagos	Ajeromi/Ifelodun	Ago Hausa	6.467204	3.334163
6021	Ondo	Ondo West	Oke-otunba/Oke-diba/Sokoti	7.088907	4.788528
6022	Nassarawa	Nassarawa Egon	Igga/Burumburum	8.758239	8.342176
6023	Kano	Bebeji	Ranka	11.573733	8.302681
6024	Oyo	Orelope	Onibode II	8.835297	3.752856
6025	Akwa Ibom	Mkpat Enin	Ikpa Ibom IV	4.640906	7.803606
6026	Abia	Ohafia	Amaogudu Abiriba	5.680823	7.693573
6027	Kogi	Idah	Ega	7.043187	6.726732
6028	Ogun	Ijebu North	Oke Sopin	7.003128	3.870011
6029	Kogi	Bassa	Gboloko	7.647738	6.830634
6030	Kano	Gaya	Kademi	11.713065	8.933335
6031	Oyo	Kajola	Imoba/Oke-Ogun	8.013323	3.300757
6032	Benue	Kwande	Liev  I	7.021944	9.573998
6033	Abia	Isuikwuato	Ezere	5.734440	7.522661
6034	Lagos	Ajeromi/Ifelodun	Temidire II	6.452741	3.324754
6035	Katsina	Danmusa	Dan Musa A	12.262880	7.336564
6036	Enugu	Nsukka	Edem-Ani	6.866536	7.359725
6037	Kwara	Ilorin South	Balogun-Fulani I	8.439386	4.667578
6038	Borno	Guzamala	Moduri	12.896911	13.049421
6039	Ondo	Akoko South-East	Ifira	7.384998	5.902652
6040	Jigawa	Kaugama	Ja'e	12.503039	9.738671
6041	Osun	Oriade	Ijeji Arakeji/Owena	7.397390	4.945953
6042	Bauchi	Misau	Beti	11.268011	10.381112
6043	Ebonyi	Ivo	Akaeze Ukwu	5.964104	7.545600
6044	Enugu	Awgu	Ogbaku	6.187902	7.503004
6045	Kaduna	Kachia	Kurmin Musa	9.583293	8.065432
6046	Kogi	Adavi	Adavi-Eba	7.546440	6.162157
6047	Kano	Dala	Gobirawa	12.023205	8.475737
6048	Kaduna	Makarfi	Gimi	11.321186	7.937321
6049	Anambra	Nnewi South	Ukpor III	5.932150	6.885116
6050	Adamawa	Fufore	Ribadu	9.316369	12.802452
6051	Kogi	Dekina	Odu II	7.580807	7.269373
6052	Kogi	Bassa	Ozongulo/Kpanche	7.813030	7.236667
6053	Osun	IfeCentral	Iremo IV	7.429686	4.615024
6054	Akwa Ibom	Udung Uko	Udung Uko IV	4.756320	8.270842
6055	Oyo	Saki East	Sepeteri I	8.535546	3.745580
6056	Kaduna	Chikun	Narayi	10.456380	7.472512
6057	Enugu	Awgu	Mgbidi/Mmaku	6.110439	7.462263
6058	Rivers	Eleme	Alode	4.774002	7.124516
6059	Adamawa	Song	Song Gari	9.840488	12.593541
6060	Akwa Ibom	Abak	Abak Urban IV	4.979364	7.759604
6061	Yobe	Karasuwa	Karasuwa Galu	12.889895	10.589501
6062	Imo	Ideato South	Umuma Isiaku	5.754349	7.170611
6063	Benue	Agatu	Okokolo	7.872824	8.083586
6064	Jigawa	Biriniwa	Kazura	12.702291	10.005818
6065	Cross River	Yala	Okuku	6.653918	8.507669
6066	Nassarawa	Toto	Bugakarmo	8.533885	7.450988
6067	Ondo	Ose	Idoani I	7.243354	5.834937
6068	Delta	AniochaS	Ogwashi - Uku Village	6.175369	6.575968
6069	Kebbi	Fakai	Fakai/Zussun	11.494800	5.112597
6070	Oyo	Ori-Ire	Ori Ire VIII	8.098288	4.046667
6071	Oyo	Olorunsogo	Ikolaba/Obadimo	8.765831	4.161137
6072	Benue	Makurdi	Clerks/Market	7.747678	8.525569
6073	Akwa Ibom	Ikono	Ikono Middle I	5.257009	7.732994
6074	Bauchi	Zaki	Katagum	12.295558	10.383864
6075	Jigawa	Gumel	Hammado	12.570381	9.421886
6076	Edo	Orhionmw	Ugu	5.941960	5.906949
6077	Ebonyi	Ikwo	Noye Alike	6.177083	8.250844
6078	Kano	Dala	Kabuwaya	12.000891	8.462022
6079	Kebbi	Gwandu	Dalijan	12.540298	4.562188
6080	Kano	Makoda	Koren Tatso	12.488099	8.426416
6081	Osun	Isokan	Oranran Ward	7.256602	4.202560
6082	Anambra	Njikoka	Nawfia  II	6.184493	7.002735
6083	Kogi	Bassa	Eforo	7.513243	6.757162
6084	Yobe	Bade	Lawan Audu/Lawan Al - Wali	12.842047	10.994635
6085	Oyo	Olorunsogo	Seriki I & Abosino (Okin)	8.736780	4.080964
6086	Osun	Oriade	Ijeda Iloko	7.647581	4.850422
6087	Borno	Monguno	Kumalia	12.589401	13.657426
6088	Cross River	Ogoja	Nkum Irede	6.508659	8.631995
6089	Kano	Shanono	Leni	12.019552	8.076424
6090	Jigawa	Kafin Hausa	Zago	12.042626	10.039121
6091	Borno	Damboa	Ajign (B)	11.246360	12.251549
6092	Sokoto	Yabo	Bingaje	12.645255	4.977366
6093	Anambra	Aguata	Uga II	5.935379	7.079501
6094	Enugu	Nsukka	Obukpa	6.886386	7.399316
6095	Kogi	Adavi	Ikaraworo/Idobanyere	7.737544	6.603234
6096	Ondo	Ese-Odo	Apoi IV	6.421974	4.916721
6097	Katsina	Jibia	G/Baure/Mallamawa	12.916011	7.136823
6098	Rivers	Obio/Akpor	Ozuoba/Ogbogoro	4.844407	6.920760
6099	Jigawa	Roni	Baragumi	12.630467	8.232367
6100	Nassarawa	Nasarawa	Loko	8.032846	7.857394
6101	Adamawa	Guyuk	Bobini	10.007648	11.978389
6102	Lagos	Ajeromi/Ifelodun	Awodi-Ora	6.464551	3.319205
6103	Cross River	Boki	Boje	6.268598	8.894242
6104	Katsina	Matazu	Mazoji 'A'	12.218030	7.566655
6105	Katsina	Dandume	Magaji Wando A	11.347399	7.192443
6106	Cross River	Abi	Ebom	5.811924	7.950036
6107	Ekiti	Ikere	Odose	7.492189	5.282464
6108	Borno	Guzamala	Gudumbali East	12.974492	13.268335
6109	Rivers	Asari-Toru	Buguma North West I	4.735494	6.861443
6110	Akwa Ibom	Uyo	Oku II	5.053085	7.922307
6111	Rivers	Khana	Okwali	4.792983	7.380104
6112	Kaduna	Kagarko	Kagarko North	9.529742	7.525497
6113	Ondo	Akure North	Isimija/Irado	7.338958	5.282076
6114	Katsina	Funtua	Unguwar Rabiu	11.534215	7.310425
6115	Bauchi	Darazo	Yautare	10.967134	10.550704
6116	Akwa Ibom	Obot Akara	Ikot Abia I	5.231601	7.625747
6117	Kwara	Moro	Okutala	8.857279	4.543734
6118	Adamawa	Guyuk	Bodeno	9.966950	12.005572
6119	Kebbi	Argungu	Felande	12.650528	4.599632
6120	Osun	Osogbo	Ataoja  'C'	7.734901	4.564484
6121	Katsina	Katsina (K)	Wakili Kudu III	12.954347	7.602589
6122	Jigawa	Miga	Yanduna	12.148637	9.658417
6123	Abia	Aba South	Ohazu II	5.059118	7.368721
6124	Oyo	Saki East	Ogbooro II	8.760751	3.522316
6125	Ondo	Akure North	Odo-oja/Ijigbo	7.345670	5.316057
6126	Edo	Esan North East	Egbele	6.735099	6.328772
6127	Katsina	Mashi	S/rijiya	13.292401	7.911124
6128	Enugu	Ezeagu	Olo/Amagu Umulokpa I	6.466364	7.199166
6129	Ekiti	Ijero	Ekamarun Ward 'A'	7.865807	5.082049
6130	Yobe	Machina	Taganama	12.848354	9.796023
6131	Oyo	Atiba	Ashipa I	7.913718	3.933869
6132	Kwara	Edu	Tsonga II	8.999048	5.081658
6133	Kwara	Irepodun	Omu-Aran I (Aran)	8.116664	5.041970
6135	Lagos	Ikeja	Anifowoshe/Ikeja	6.610124	3.323028
6136	Katsina	Matazu	Matazu 'A	12.229844	7.679415
6137	Gombe	Funakaye	Ashaka / Magaba	10.882053	11.536479
6138	Imo	Oguta	Egwe/Egbuoma	5.752597	6.793056
6139	Enugu	Ezeagu	Mgbagbu Owa I	6.375016	7.160624
6140	Taraba	Jalingo	Mayo Goi	8.888889	11.440371
6141	Nassarawa	Lafia	Gayam	8.504945	8.509094
6142	Osun	Boripe	Ada I	7.883865	4.732909
6143	Niger	Borgu	Karabonde	9.928447	4.538846
6144	Anambra	Idemili North	Nkpor  I	6.091392	6.856078
6145	Kaduna	Soba	Gimba	11.079885	7.940373
6146	Borno	Bama	Kasugula	11.505272	13.729742
6147	Oyo	Irepo	Iba III	9.114926	3.906525
6148	Akwa Ibom	Eket	Urban II	4.642003	7.918034
6149	Kebbi	Shanga	Sokage/Golongo/Hundeji	11.027011	4.896258
6150	Borno	Shani	Walama	10.267105	12.031171
6151	Bauchi	Bauchi	Mun/Munsal	9.962609	9.954011
6152	Kaduna	Kubau	Mah	11.055872	8.263492
6153	Edo	Etsako West	Auchi	7.044956	6.251943
6154	Cross River	Ogoja	Mbube East I	6.584665	8.964124
6155	Rivers	Emuoha	Ubimini	5.255176	6.735875
6156	Nassarawa	Toto	Shafan Kwato	8.282241	7.042105
6157	Bauchi	Bogoro	Lusa  "A"	9.624305	9.758553
6158	Plateau	Jos South	Giring	9.797441	8.838680
6159	Anambra	Idemili South	Awka-etiti  II	6.030763	6.949795
6160	Kano	Sumaila	Gala	11.418606	8.921838
6161	Ebonyi	Ohaozara	Umuobuna	5.949462	7.732156
6162	Borno	Bayo	Briyel	10.374952	11.697775
6163	Anambra	Nnewi South	Ezinifite  III	5.900872	6.923243
6164	Sokoto	Dange-Shuni	Dange	12.807414	5.403170
6165	Benue	Gwer East	Ugee	7.399394	8.321938
6166	Ogun	Ado Odo-Ota	Alapoti	6.619358	2.939729
6167	Kwara	Ilorin East	Iponrin	8.600815	4.821152
6168	Katsina	Mani	Muduru	13.033688	7.835490
6169	Katsina	Zango	Dargage	13.002075	8.436089
6170	Zamfara	Gummi	Gayari	12.088239	5.062122
6171	Kaduna	Makarfi	Gwanki	11.306174	8.044268
6172	Anambra	Anaocha	Akwaeze	6.039418	6.992501
6173	Plateau	Pankshin	Fier	9.417693	9.345583
6174	Kano	Dambatta	Gwarabjawa	12.469193	8.574049
6175	Akwa Ibom	Etinan	Etinan Urban II	4.819735	7.831238
6176	Abia	Arochukwu	Arochukwu II	5.390339	7.890890
6177	Cross River	Abi	Ekureku I	5.996076	8.025059
6178	Taraba	Takum	Yukuben	7.357611	10.185388
6179	Katsina	Sabuwa	Gazari	11.177439	7.195866
6180	Jigawa	Malam Mado	Malam Madori	12.520467	9.891228
6181	Plateau	Langtang South	Talgwang	8.770468	9.798280
6182	Borno	Hawul	Gwanzang  Pusda	10.347245	12.131465
6183	Cross River	Akamkpa	Akamkpa Urban	5.431947	8.381877
6184	Plateau	Jos North	Tafawa Balewa	9.928337	8.881379
6185	Katsina	Matazu	Kogari	12.230862	7.734706
6186	Kaduna	Giwa	Kakangi	11.222697	7.458968
6187	Plateau	Mangu	Gindiri  I	9.561337	9.201699
6188	Abia	Osisioma	Amasator	5.146551	7.333412
6189	Oyo	Iseyin	Ekunle I	7.940157	3.680757
6190	Anambra	Orumba North	Awa	6.123662	7.188815
6191	Benue	Ushongo	Utange	7.061467	9.280555
6192	Kano	Kano Municipal	Jakara	11.949892	8.457974
6193	Gombe	Yalmatu / Deba	Kwadon / Liji / Kurba	10.317731	11.318997
6194	Niger	Mashegu	Kwatachi	9.742385	4.674845
6195	Oyo	Iseyin	Koso I	7.951720	3.502682
6196	Kano	Gabasawa	Karmami	12.097694	8.826490
6197	Kwara	Baruten	Gwanara	8.961490	2.972899
6198	Niger	Gbako	Sammajiko	9.437805	6.103792
6199	Osun	Atakumosa West	Osu III	7.565714	4.601107
6200	Yobe	Nangere	Pakarau Kare-Kare/ Pakarau Fulani	11.853684	11.026534
6201	Jigawa	Yankwashi	Belas	12.695021	8.415415
6202	Borno	Maiduguri	Lamisula/Jabba Mari	11.857386	13.207158
6203	Bauchi	Warji	Baima North / West	11.093590	9.784641
6204	Enugu	Uzo-Uwani	Nimbo II	6.853453	7.173904
6205	Yobe	Fika	Turmi / Maluri	11.370253	11.432394
6206	Imo	Ideato North	Ndi Iheme Arondizuogu	5.843650	7.177433
6207	Kogi	Igalamela-Odolu	Ekwuloko	6.874490	7.053436
6208	Benue	Agatu	Oshigbudu	7.824510	7.876451
6209	Ogun	Ijebu East	Ajebandele	7.033908	4.271478
6210	Jigawa	Gwiwa	Buntusu	12.718105	8.257417
6211	Gombe	Shomgom	Burak	9.620011	11.317216
6212	Kebbi	Sakaba	Fada	11.249277	5.513187
6213	Kano	Kiru	Dashi	11.708582	8.229284
6214	Akwa Ibom	Ikot Ekpene	Ikot Ekpene VIII	5.164714	7.648937
6215	Enugu	Nkanu West	Amodu	6.332319	7.509510
6216	Ekiti	Irepodun-Ifelodun	Afao	7.687535	5.354756
6217	Edo	Ovia South West	Udo	6.431187	5.312300
6218	Akwa Ibom	Itu	West Itam III	5.079831	7.905092
6219	Nassarawa	Nasarawa	Udenin	8.444662	8.058371
6220	Kebbi	Bagudo	Lafagu/Gante	11.171222	4.266519
6221	Enugu	Enugu East	Mbulu-Njodo West	6.527016	7.566750
6222	Niger	Gbako	Lemu	9.412856	6.037667
6223	Kogi	Dekina	Ogane Inigu	7.706772	7.353739
6224	Edo	Owan East	Igue/Ikao	7.173861	6.058721
6225	Ondo	Ose	Ijagba	6.874609	5.707797
6226	Osun	Boripe	Ada II	7.867313	4.755096
6227	Gombe	Shomgom	Bangunji	9.631865	11.376733
6228	Katsina	Dutsi	Dutsi A	12.835945	8.152271
6229	Plateau	Mangu	Kombun	9.408595	9.080400
6230	Kano	Bichi	Fagolo	12.243931	8.443520
6231	Akwa Ibom	Uruan	Central Uruan II	5.008346	8.068212
6232	Oyo	Ibadan North	Ward VII, N6A PART II	7.415065	3.891265
6233	Imo	Owerri Municipal	Ikenegbu II	5.476340	7.044501
6234	Kano	Minjibir	Kunya	12.213524	8.532083
6235	Taraba	Ussa	Kwambai	6.761414	9.768805
6236	Katsina	Kankiya	Rimaye	12.340842	7.829953
6237	Adamawa	Michika	Wamblimi / Tilli	10.571107	13.411082
6238	Kebbi	Shanga	Kawara/Ingu/Sargo	11.169457	4.597566
6239	Sokoto	Gudu	Kurdula	13.533666	4.334734
6240	Kano	Bebeji	Kuki	11.421553	8.353641
6241	Anambra	Awka North	Urum	6.288497	7.013504
6242	Rivers	Etche	Obite	5.159786	7.047281
6243	Enugu	EnuguSou	Obeagu I	6.378202	7.532286
6244	Kwara	Oke-Ero	Ekan	8.020865	5.107425
6245	Borno	Askira/Uba	Zadawa / Hausari	10.636008	12.883436
6246	Enugu	Udi	Umuaga	6.244065	7.347507
6247	Bauchi	Bogoro	B O I "B"	9.556915	9.516862
6248	Kogi	Lokoja	Kakanda	8.078479	6.627829
6249	Kogi	Okehi	Okuehu	7.599807	6.191887
6250	Edo	Esan West	Uhiele	6.714563	6.145906
6251	Katsina	Malumfashi	Na-Alma	11.954110	7.603257
6252	Ebonyi	Ikwo	Eka Awoke	6.047751	8.066900
6253	Rivers	Port Harcourt	Rumuobiekwe Ward	4.778197	7.003595
6254	Ondo	Odigbo	Odigbo	6.821309	4.848473
6255	Kebbi	Ngaski	Kambuwa/Danmaraya	10.839930	4.988318
6256	Enugu	Awgu	Agbogugu	6.248183	7.457608
6257	Ogun	Egbado South	Ajilete	6.719993	2.948292
6258	Niger	Borgu	Konkoso	10.941679	4.038351
6259	Bayelsa	Ekeremor	Oporomor I	4.907764	5.761404
6260	Yobe	Jakusko	Buduwa / Saminaka	12.238320	10.829877
6261	Kebbi	Koko/Bes	Dada/Alelu	11.525186	4.452442
6262	Oyo	Ogo-Oluwa	Mowolowo/Iwo-Ate	7.874675	4.112101
6263	Yobe	Nguru	Hausari	12.874625	10.438186
6264	Anambra	Ihiala	Okija  V	5.853295	6.794095
6265	Bayelsa	Kolokuma-Opokuma	Odi (Central) II	5.148268	6.315532
6266	Edo	Etsako Central	Fugar III	7.090149	6.451363
6267	Kano	Tofa	Jauben Kudu	12.026820	8.297037
6268	Kebbi	Sakaba	Dankolo	11.070738	5.748988
6269	Lagos	Badagary	Ibereko	6.451773	2.951425
6270	Edo	Etsako Central	Ekperi III	6.919342	6.578388
6271	Katsina	Bakori	Kandarawa	11.710003	7.406597
6272	Imo	Njaba	Amucha II	5.717334	7.030030
6273	Ondo	Okitipupa	Okitipupa I	6.525430	4.790740
6274	Gombe	Nafada	Jigawa	11.271442	11.088029
6275	Jigawa	Sule Tankarkar	Dangwanki	12.779611	9.242624
6276	Abia	Aba North	Umuogor	5.094344	7.326861
6277	Zamfara	Maru	Bindin	11.558042	6.333885
6278	Enugu	Udi	Umuabi	6.270265	7.379793
6279	Niger	Gurara	Izom	9.212534	7.070819
6280	Gombe	Kwami	Gadam	10.562971	11.211793
6281	Lagos	Badagary	Keta-east	6.407124	2.750689
6282	Delta	Udu	Orhuwhurun	5.501733	5.832489
6283	Edo	Owan East	Uokha/Ake	7.115085	6.023236
6284	Delta	Uvwie	Enerhen I	5.531030	5.774532
6285	Rivers	Khana	Baen/Kpean/Duburo	4.628598	7.465087
6286	Rivers	Gokana	Bomu I	4.631343	7.302049
6287	Edo	Esan South East	Ewohimi I	6.431264	6.324367
6288	Osun	Ilesha West	Lower Egbe-Idi	7.639775	4.766198
6289	Ekiti	Gboyin	Ode III	7.620584	5.529438
6290	Sokoto	Gada	Gada	13.761339	5.664059
6291	Lagos	Oshodi/Isolo	Ishagatedo	6.539157	3.314107
6292	Rivers	Abua/Odu	Anyu	4.859183	6.436892
6293	Niger	Magama	Auna East	10.303737	5.074690
6294	Kwara	Ilorin West	Ogidi	8.548810	4.532143
6295	Sokoto	Sabon Birni	Gatawa	13.478357	6.324856
6296	Kebbi	Gwandu	Cheberu/Bada	12.525996	4.606103
6297	Osun	Iwo	Isale Oba  I	7.599933	4.181342
6298	Ogun	Odogbolu	Omu	6.787376	3.894093
6299	Katsina	Katsina (K)	Wakilin Gabas II	12.987445	7.620821
6300	Yobe	Fika	Fika/Anze	11.300545	11.353385
6301	Yobe	Jakusko	Jawur/Katamma	12.707333	10.930911
6302	Rivers	Opobo/Nkoro	Dappaye Ama-Kiri I	4.507538	7.536706
6303	Osun	Odo Otin	Oloyan Elemosho / Esa	8.006234	4.783836
6304	Anambra	Anaocha	Adazi Nnukwu  II	6.084967	7.004559
6305	Lagos	Ikorodu	Igbogbo II	6.598317	3.548620
6306	Kano	Rogo	Rogo Sabon Gari	11.551902	7.835528
6307	Zamfara	Gummi	Felfeldu / Gamo	12.191439	5.351853
6308	Niger	Mokwa	Muregi	8.817715	5.741144
6309	Taraba	Takum	Shibong	7.304258	10.072012
6310	Rivers	Degema	Tomble IV	4.555895	6.988509
6311	Katsina	Kaita	Gafiya	13.099656	7.817317
6312	Ondo	Odigbo	Araromi Obu	6.599884	4.481956
6313	Imo	Okigwe	Ihube	5.837283	7.340584
6314	Federal Capital Territory	Abaji	Abaji North East	8.476316	6.921666
6315	Bauchi	Bogoro	Lusa  "B"	9.589782	9.590085
6316	Sokoto	Illela	R. Gati	13.815042	5.435898
6317	Osun	Obokun	Esa-Oke	7.772839	4.884110
6318	Abia	Oboma Ngwa	Abayi  II	5.115400	7.408271
6319	Kwara	Asa	Ago-Oja/Oshin/Sapati/Laduba	8.362128	4.562630
6320	Plateau	Qua'anpa	Dokan Kasuwa	9.080219	9.269780
6321	Ebonyi	Abakalik	Azumini/Azugwu	6.316890	8.137016
6322	Delta	Warri South	Ugbuwangue/Ekurede-Itsekiri	5.505000	5.725096
6323	Nassarawa	Karu	Aso / Kodape	8.998007	7.672402
6324	Ekiti	Ado-Ekiti	Ado 'I' Dallimore	7.570575	5.231722
6325	Benue	Gwer East	Mbaiase	7.201048	8.465146
6326	Abia	Ohafia	Ania Ohafia	5.537111	7.815349
6327	Rivers	Khana	Bori	4.674251	7.360119
6328	Jigawa	Hadejia	Dubantu	12.439049	10.017661
6329	Benue	Gwer West	Isambe/Mbasev	7.500428	8.214593
6330	Adamawa	Maiha	Sorau 'B'	9.762698	13.238463
6331	Ondo	Akure South	Gbogi/Isikan II	7.281911	5.131997
6332	Cross River	Akpabuyo	Ikang Central	4.813107	8.516702
6333	Bauchi	Bogoro	Bogoro "B"	9.673480	9.722093
6334	Jigawa	Gagarawa	Maikilili	12.520534	9.647047
6335	Lagos	Lagos Island	Anikantamo	6.465292	3.398650
6336	Katsina	Kaita	Girka	13.153895	7.742334
6337	Abia	Aba South	Eziukwu	5.095657	7.340666
6338	Niger	Magama	Auna South	10.014729	4.770346
6339	Bauchi	Giade	Giade	11.410347	10.233344
6340	Ogun	Ogun Waterside	Efire	6.355458	4.501650
6341	Ogun	Odeda	Ilugun	7.203280	3.474159
6342	Kano	Makoda	Koguna	12.377934	8.423448
6343	Ogun	Ijebu North-East	Isoyin	6.850792	3.967648
6344	Enugu	Nkanu East	Ihuokpara	6.300598	7.643910
6345	Abia	Isiala Ngwa North	Ihie	5.410190	7.343345
6346	Zamfara	Anka	Sabon Birini	11.734811	6.074277
6347	Osun	Olorunda	Oba-Ile	7.913248	4.564376
6348	Katsina	Kankiya	Kafin Dangi/Fakuwa	12.592205	7.837332
6349	Taraba	Yorro	Pantisawa II	8.939699	11.490355
6350	Anambra	Ayamelum	Igbakwu	6.552856	6.929908
6351	Bauchi	Alkaleri	Gwaram	10.140979	10.375375
6352	Plateau	Langtang North	Mban/Zamko	8.994209	9.798639
6353	Imo	Owerri North	Obibiezena	5.341654	7.047421
6354	Katsina	Batsari	Darini/Magaji/Abu	12.950519	7.248389
6355	Ogun	Ikenne	Iperu II	6.948519	3.629809
6356	Katsina	Kankiya	Galadima 'B'	12.516863	7.884888
6357	Kano	Kunchi	Yandadi	12.445168	8.257270
6358	Ogun	Ijebu North-East	Erunwon	6.883768	3.954329
6359	Kwara	Moro	Arobadi	8.737899	4.414447
6360	Kebbi	Suru	Ginga	12.013197	4.138027
6361	Jigawa	Auyo	Unik	12.335630	10.184150
6362	Sokoto	Wurno	Kwargaba	13.282484	5.503991
6363	Zamfara	Birnin Magaji	Birnin Magaji	12.579553	6.848366
6364	Katsina	Rimi	Makurda	13.012909	7.739288
6365	Ekiti	Ekiti East	Obadore I	7.722153	5.685787
6366	Zamfara	Bakura	Nasarawa	12.683278	5.740797
6367	Nassarawa	Awe	Wuse	8.427673	9.406382
6368	Akwa Ibom	Ikot Abasi	Ukpum Okon	4.588083	7.701517
6369	Ekiti	Moba	Erinmope I	7.994994	5.148036
6370	Taraba	Ibi	Sarkin Kudu I	8.323940	9.786723
6371	Ondo	Ose	Ute	6.944360	5.648963
6372	Anambra	Anambra East	Otuocha  I	6.357265	6.853596
6373	Kogi	Ibaji	Ayah	6.719182	6.660064
6374	Oyo	Ibadan South East	S 4B	7.340789	3.930231
6375	Cross River	Akpabuyo	Ikang North	4.853757	8.549204
6376	Bayelsa	Ogbia	Otuasega	4.934840	6.400769
6377	Delta	EthiopeE	Agbon  VI	5.729083	5.984286
6378	Kogi	Okehi	Obaiba I	7.601275	6.235487
6379	Kano	Doguwa	Maraku	10.595046	8.697833
6380	Edo	Ovia North East	Utoka	6.389039	5.470718
6381	Anambra	Idemili North	Eziowelle	6.129673	6.927607
6382	Plateau	Kanam	Gwamlar	9.423967	9.839239
6383	Kaduna	Kaduna South	Makera	10.471948	7.413821
6384	Adamawa	Mubi South	Nassarawo	10.218406	13.366769
6385	Rivers	Port Harcourt	Ochiri/Rumukalagbor	4.800765	7.018926
6386	Sokoto	Isa	Yanfako	13.286075	6.648341
6387	Enugu	Ezeagu	Umumba Ndiumo	6.325082	7.262275
6388	Kebbi	Bunza	Salwai	12.099074	3.978623
6389	Yobe	Jakusko	Dumbari	12.526857	10.798092
6390	Taraba	Zing	Lamma	8.789838	11.874360
6391	Kaduna	Kubau	Zuntu	10.748500	8.192510
6392	Bayelsa	Ekeremor	Eduwini II	4.844063	5.621478
6393	Osun	Atakumosa East	Forest reserve  II	7.323141	4.834945
6394	Oyo	Ibadan North East	Ward 2 NI (Part II)	7.361980	3.908473
6395	Anambra	Ayamelum	Ifite Ogwari I	6.598236	6.929628
6396	Kaduna	Jema'a	Kafanchan 'B'	9.530578	8.285816
6397	Adamawa	Song	Sigire	9.977181	12.613081
6398	Federal Capital Territory	Municipal	Jiwa	9.050936	7.290131
6399	Delta	Okpe	Mereje  II	5.681965	5.765355
6400	Ekiti	Gboyin	Agbado	7.565862	5.465395
6401	Imo	Aboh-Mbaise	Amuzu	5.366677	7.288777
6402	Jigawa	Gwaram	Zandan Nagogo	11.315919	9.879758
6403	Ekiti	Emure	Ida Mudu II	7.405843	5.488134
6404	Plateau	Shendam	Shendam Central (A)	8.919506	9.529029
6405	Ondo	Akoko South-West	Oka V B Oka Odo/Okela/Bolorunduro	7.459350	5.775741
6406	Kogi	Dekina	Adumu Egume	7.478674	7.270962
6407	Edo	Esan North East	Uwalor	6.675070	6.314885
6408	Niger	Shiroro	Gussoro	9.930955	6.766442
6409	Benue	Guma	Nzorov	7.890570	8.943469
6410	Kano	Bunkure	Chirin	11.615707	8.510991
6411	Katsina	Ingawa	Manomawa/Kafi	12.533305	8.076634
6412	Ekiti	Ise-Orun	Odo Ise II	7.378652	5.393238
6413	Taraba	Kurmi	Didan	7.108996	10.481776
6414	Lagos	Lagos Island	Idumota/Oke	6.465366	3.384171
6415	Kebbi	Augie	Bagaye/Mera	12.850189	4.582426
6416	Adamawa	Numan	Bare	9.584298	12.110769
6417	Plateau	Jos North	Garba Daho	9.919983	8.893558
6418	Delta	Udu	Udu III	5.426504	5.833884
6419	Katsina	Dutsin-M	Bagagadi	12.428656	7.571359
6420	Benue	Gboko	Gboko South	7.261296	9.000189
6421	Sokoto	Kware	Durbawa	13.066314	5.329117
6422	Kano	Gabasawa	Zakirai	12.101724	8.881764
6423	Katsina	Kankara	Gatakawa s/Gari/Mabai	11.857974	7.354199
6424	Delta	Warri South	Igbudu	5.565165	5.588626
6425	Federal Capital Territory	Abaji	Agyana/Pandagi	8.491651	6.872670
6426	Kano	Wudil	Dankaza	11.697907	8.830105
6427	Kaduna	Jaba	Sabchem	9.446821	8.004840
6428	Niger	Muya	Fuka	9.646441	6.957644
6429	Oyo	Ori-Ire	Ori Ire IV	8.458724	4.256520
6430	Gombe	Gombe	Shamaki	10.327581	11.240625
6431	Borno	Kala/Balge	Sigal/Karche	12.246011	14.540322
6432	Kaduna	Chikun	Nasarawa	10.432766	7.387828
6433	Enugu	Igbo-eze South	Uhunowerre	6.914444	7.410145
6434	Oyo	Ibadan South East	S. 6B	7.331878	3.913969
6435	Osun	Irewole	Ikire 'H'	7.383066	4.146990
6436	Bauchi	Dass	Bununu Central	9.971470	9.548851
6437	Kano	Kabo	Kabo	11.846586	8.179199
6438	Kano	Gwale	Sani Mai Magge	11.967941	8.484402
6439	Plateau	Pankshin	Tal	9.136113	9.498212
6440	Edo	Esan South East	Ubiaja II	6.662851	6.440590
6441	Akwa Ibom	Ibesikpo Asutan	Asutan IV	4.835479	7.951897
6442	Kebbi	Danko Wasagu	Ribah/Machika	11.450383	5.446805
6443	Ebonyi	Afikpo South	Oso	5.876879	7.775704
6444	Niger	Mokwa	Gbara	8.871227	5.760081
6445	Ekiti	Ilejemeje	Ijesamodu	7.936062	5.208055
6446	Kogi	Olamaboro	Imane II	7.239205	7.787407
6447	Gombe	Kaltungo	Kaltungo West	9.848890	11.368927
6448	Osun	Osogbo	Are-Ago	7.726212	4.598842
6449	Anambra	Dunukofia	Ukwulu  II	6.237533	6.939145
6450	Sokoto	Gwadabaw	Atakwanyo	13.343201	5.197555
6451	Kano	Tsanyawa	Gurun	12.337189	8.012435
6452	Imo	Owerri North	Emekuku I	5.479736	7.126626
6453	Benue	Konshisha	Mbatsen	7.000159	8.788834
6454	Yobe	Tarmuwa	Koriyel	12.220454	11.517799
6455	Adamawa	Shelleng	Wuro Yanka/ Libbo	9.695414	12.250196
6456	Oyo	Egbeda	Olode/Alakia	7.384456	3.982202
6457	Oyo	Orelope	Onibode I	8.831891	3.753492
6458	Nassarawa	Akwanga	Gudi	8.925262	8.234042
6459	Edo	Akoko Edo	Oloma/ Okpe/ Ijaja/ Kakuma/ Anyara	7.365381	5.991045
6460	Rivers	Akukutor	Georgwill III	4.715066	6.715920
6461	Bauchi	Itas/Gadau	Itas	11.851918	9.978125
6462	Ondo	Ondo West	Odojomu/Erinketa/Legiri	7.045474	4.826904
6463	Bauchi	Katagum	Buskuri	11.718447	10.326649
6464	Lagos	Ojo	Iba	6.508749	3.188969
6465	Kano	Gabasawa	Zugachi	12.061942	8.835984
6466	Kano	Bichi	Kyalli	12.262635	8.149080
6467	Zamfara	Bakura	Yar Kufoji	12.643386	5.938691
6468	Niger	Agaie	Ekobadeggi	9.020019	6.327706
6469	Kogi	Ijumu	Ogale/Aduge	7.645762	6.059567
6470	Ondo	Ilaje	Ugbo II	6.150871	4.826479
6471	Kano	Warawa	Amarawa	11.911375	8.808423
6472	Oyo	Kajola	Ayetoro-Oke I	8.051397	3.303797
6473	Edo	Ovia South West	Nikorogha	6.301693	5.319384
6474	Imo	Orsu	Assah Ubiri Elem	5.846477	7.023415
6475	Abia	Ugwunagbo	Ward Seven	5.045982	7.298075
6476	Benue	Logo	Tombo	7.775422	9.112414
6477	Jigawa	Yankwashi	Dawan-Gawo	12.780441	8.548092
6478	Katsina	Bindawa	Giremawa	12.766025	7.945969
6479	Lagos	Agege	Tabon Tabon/Oko Oba	6.651581	3.306495
6480	Osun	Odo Otin	Asi/Asaba	8.048281	4.787172
6481	Sokoto	Sabon Birni	Tara	13.473060	6.445703
6482	Kano	Gezawa	Babawa	12.033903	8.627205
6483	Cross River	Yakurr	Ijom	5.805502	8.046750
6484	Sokoto	Kebbe	uchi	11.800301	4.682021
6485	Anambra	Awka South	Awka  II	6.223139	7.086094
6486	Taraba	Zing	Monkin B	8.786837	11.797538
6487	Ondo	Akoko South-East	Isua III	7.443667	5.908208
6488	Kogi	Kabba-Bunu	Odolu	7.845774	6.049391
6489	Cross River	Bekwarra	Afrike Ochagbe	6.598972	8.896979
6490	Abia	Isiala Ngwa North	Amasaa Nsulu	5.313854	7.500825
6491	Taraba	Donga	Suntai	7.910377	10.378762
6492	Katsina	Rimi	Majengobir	12.784821	7.628395
6493	Kebbi	Gwandu	Dodoru	12.423827	4.657486
6494	Yobe	Nangere	Chilariye	11.681269	11.002077
6495	Rivers	Ogu/Bolo	Bolo I	4.668786	7.223963
6496	Nassarawa	Kokona	Garaku	8.903567	8.154315
6497	Edo	Etsako Central	Fugar I	7.080770	6.504083
6498	Delta	IkaSouth	Agbor Town II	6.262280	6.151951
6499	Bayelsa	Nembe	Ogbolomabiri I	4.568963	6.307457
6500	Imo	Ezinihitte Mbaise	Chokoneze/Akpodim/Ife	5.411488	7.316554
6501	Zamfara	Talata-Mafara	Take Tsaba/Makera	12.511688	6.169339
6502	Niger	Katcha	Kataregi	9.312844	6.372286
6503	Enugu	Igbo-Eti	Ohaodo I	6.741786	7.410703
6504	Ebonyi	Ezza North	Ndiaguazu - Umuoghara	6.243527	8.017422
6505	Taraba	Gashaka	Gashaka	7.426363	11.621254
6506	Niger	Wushishi	Maito	9.665745	6.037216
6507	Federal Capital Territory	Kuje	Kujekwa	8.571461	7.275640
6508	Enugu	Udi	Okpatu	6.556651	7.418087
6509	Taraba	Ussa	Bika	6.973971	9.780285
6510	Niger	Tafa	Wuse West	9.296548	7.235211
6511	Plateau	Mangu	Jipal/Chakfem	9.099811	9.167801
6512	Kwara	Oyun	Ikotun	8.224575	4.629000
6513	Ekiti	Ado-Ekiti	Ado "K' Irona	7.614508	5.166849
6514	Katsina	Rimi	Tsagero	12.912136	7.745904
6515	Cross River	Yakurr	Abanakpai	5.865876	8.183468
6516	Oyo	Ori-Ire	Ori Ire IX	8.223161	4.045102
6517	Bayelsa	Kolokuma-Opokuma	Odi (North) I	5.186717	6.307672
6518	Bauchi	Darazo	Gabarin	11.116814	10.406964
6519	Anambra	Nnewi South	Amichi  III	5.975630	6.936490
6520	Gombe	Nafada	Nafada West	11.246256	11.232129
6521	Nassarawa	Kokona	Yelwa	8.570070	8.128207
6522	Rivers	Asari-Toru	Buguma  East I	4.736652	6.865089
6523	Kogi	Olamaboro	Imane I	7.260909	7.708974
6524	Kano	Sumaila	Gediya	11.310219	8.896155
6525	Borno	Monguno	Ngurno	12.647081	13.656348
6526	Kaduna	Kajuru	Kasuwan Magani	10.329905	7.743245
6527	Adamawa	Fufore	Uki tuki	9.056788	12.470940
6528	Borno	Maiduguri	Maisandari	11.818041	13.188190
6529	Ondo	Irele	Irele V	6.498804	5.015123
6530	Edo	Esan West	Ihunmudumu/Idumebo/Uke/Ujemen	6.730662	6.071759
6531	Ogun	Egbado South	Owode II	6.789806	3.032713
6532	Niger	Lapai	Muye/Egba	8.335016	6.607851
6533	Borno	Ngala	Warshele	12.082370	14.229380
6534	Adamawa	Mayo-Belwa	Binyeri	8.715779	11.927027
6535	Yobe	Geidam	Gumsa	12.500133	11.795694
6536	Oyo	Saki East	Ogbooro I	8.735233	3.646782
6537	Akwa Ibom	Esit Eket	Akpautong	4.660366	8.087551
6538	Anambra	Ogbaru	Okpoko VI	6.042291	6.748764
6539	Katsina	Zango	Kawarin Kudi	12.887980	8.670800
6540	Akwa Ibom	Itu	West Itam II	5.048697	7.875540
6541	Ebonyi	Afikpo North	Ezeke Amasiri	5.929463	7.882361
6542	Osun	Ayedire	Ileogbo  I	7.602812	4.250237
6543	Kwara	Moro	Shao	8.586761	4.582993
6544	Niger	Magama	Auna East Central	10.357487	4.948468
6545	Zamfara	Maru	Dan Gulbi	11.610910	6.207887
6546	Kogi	Ibaji	Analo	6.816708	6.865609
6547	Kaduna	Zaria	Tudun Wada	11.068287	7.705478
6548	Plateau	Shendam	Shimankar	8.665406	9.579591
6549	Edo	Igueben	Afuda/Idumuoka	6.566911	6.256842
6550	Lagos	Surulere	Coker	6.488297	3.317317
6551	Lagos	Ikorodu	Ijede II	6.580673	3.580590
6552	Katsina	Funtua	Goya	11.445310	7.356700
6553	Ogun	Egbado South	Oke Odan	6.659008	2.884977
6554	Katsina	Daura	Ubandawaki A	13.031266	8.308977
6555	Imo	Ezinihitte Mbaise	Onicha III	5.519164	7.325971
6556	Niger	Agwara	Adehe	10.797202	4.486462
6557	Lagos	Ojo	Ojo Town	6.463263	3.205004
6558	Taraba	Gassol	Wurojam	8.349516	10.203711
6559	Rivers	Okrika	Okrika  II	4.681845	7.139417
6560	Akwa Ibom	Ikot Abasi	Ikpa Nung Asang I	4.648645	7.682093
6561	Kogi	Ofu	Ugwolawo II	7.263599	6.835094
6562	Kebbi	Fakai	Bajida	11.420298	5.006284
6563	Delta	Warri South	Okumagba I	5.611978	5.648334
6564	Delta	Okpe	Oha  I	5.625888	5.856893
6565	Kaduna	Soba	Richifa	11.137239	7.867111
6566	Taraba	Zing	Bubong	8.989353	11.907509
6567	Lagos	Epe	Ibonwon	6.645365	4.017808
6568	Cross River	Yala	Gabu	6.828619	8.793260
6569	Niger	Edati	Etsu Tasha	9.079743	5.671834
6570	Federal Capital Territory	Municipal	Gwagwa	9.110374	7.354081
6571	Oyo	Surulere	Ilajue	7.917052	4.425541
6572	Ogun	Shagamu	Oko/Epe/Itula I	6.850445	3.660014
6573	Bauchi	Gamjuwa	Miya  East	10.681638	10.360790
6574	Ogun	Remo North	Ilara	7.029592	3.684764
6575	Kogi	Ogori Magongo	Ileteju	7.445270	6.125294
6576	Kebbi	Danko Wasagu	Bena	11.268671	5.944920
6577	Katsina	Malumfashi	Malum Fashi 'B'	11.787839	7.599932
6578	Kaduna	Kaduna North	Unguwan Sarki	10.535667	7.450900
6579	Osun	Obokun	Eesun/Idooko	7.692954	4.749428
6580	Nassarawa	Akwanga	Moroa	9.036945	8.232762
6581	Oyo	Saki West	Iya	8.575069	3.252739
6582	Oyo	Ibadan South West	Ward 11 SW9(1)	7.339484	3.862234
6583	Ondo	Akoko South-East	Isua IV	7.485403	5.908357
6584	Katsina	Daura	Sabon Gari	13.011006	8.329346
6585	Ekiti	Ikole	Ikole West II	7.771100	5.448905
6586	Kwara	Ilorin East	Magaji Are II	8.436956	4.627684
6587	Lagos	Ajeromi/Ifelodun	Wilmer	6.454801	3.318880
6588	Sokoto	Goronyo	Rimawa	13.434452	5.923283
6589	Rivers	Port Harcourt	Rumuwoji (Two)	4.771228	7.004650
6590	Anambra	Orumba North	Nanka  I	6.052313	7.049775
6591	Rivers	Omumma	Umuogba II Community	5.061625	7.170755
6592	Kwara	Irepodun	Ajase Ipo I	8.341071	4.854001
6593	Kano	Dawakin Kudu	Dabar Kwari	11.712221	8.651512
6594	Kano	Madobi	Kafin Agur	11.871465	8.373683
6595	Delta	Okpe	Oviri - Okpe	5.709797	5.829142
6596	Adamawa	Girie	Gereng	9.446636	12.466842
6597	Ondo	Akure North	Oke Iju	7.398571	5.307987
6598	Kano	Takai	Falali	11.477975	9.028256
6599	Niger	Edati	Gonagi	8.968942	5.636833
6600	Enugu	Igbo-eze South	Itchi/Uwani I	6.964295	7.344466
6601	Kebbi	Danko Wasagu	Dan Umaru/Mairairai	11.278111	5.986723
6602	Edo	Uhunmwonde	Ohuan	6.377314	5.899917
6603	Taraba	Gassol	Mutum Biyu I	8.680758	10.742199
6604	Cross River	Calabar South	Eleven (11)	4.866389	8.235277
6605	Plateau	Mikang	Koenoem 'A'	9.023710	9.370868
6606	Kogi	Yagba East	Makutu I	8.354953	5.716075
6607	Jigawa	Gwaram	Tsangarwa	11.422734	9.791429
6608	Akwa Ibom	Ibiono Ibom	Ibiono Eastern II	5.159845	7.922615
6609	Bayelsa	Ekeremor	Oporomor V	5.015722	5.512423
6610	Adamawa	Mayo-Belwa	Gengle	9.125548	12.007497
6611	Plateau	Qua'anpa	Kwande	8.598769	9.225656
6612	Niger	Katcha	Bisanti	9.343808	6.196650
6613	Katsina	Faskari	Yarmalamai	11.852046	7.225631
6614	Lagos	Ajeromi/Ifelodun	Alaba Oro	6.478906	3.318128
6615	Imo	Mbaitoli	Orodo 'A'	5.578593	7.035628
6616	Jigawa	Miga	Zareku	12.183829	9.802280
6617	Osun	Obokun	Otan-Ile	7.834634	4.788175
6618	Ekiti	Emure	Oke Emure II	7.369743	5.502586
6619	Kwara	Kaiama	Gwaria	9.252901	4.035887
6620	Ogun	Ado Odo-Ota	Ijoko	6.721099	3.201384
6621	Benue	Agatu	Ogwule-Kaduna	7.937059	7.745002
6622	Akwa Ibom	Oruk Anam	Ibesit/Nung Ikot II	4.725522	7.579823
6623	Imo	Obowo	Amanze/Umungwa	5.544445	7.397791
6624	Katsina	Kusada	Kofa	12.435613	7.914219
6625	Sokoto	Tureta	Tureta Gari	12.594144	5.537366
6626	Kaduna	Jema'a	Kagoma	9.463023	8.165409
6627	Ondo	Akoko South-East	Ipe I	7.412190	5.875212
6628	Zamfara	Kaura-Namoda	Yankaba	12.649077	6.591238
6629	Edo	Ovia North East	Ofunmwegbe	6.509915	5.526177
6630	Niger	Mashegu	Kaboji	10.057223	5.369890
6631	Zamfara	Gusau	Sabon Gari	12.165050	6.669920
6632	Ondo	Akoko South-West	Oka III B Owase /Ikese/Iwonrin/Ebinrin/Idorin	7.460474	5.793474
6633	Oyo	Ibadan North	Ward V, N5B	7.409595	3.923400
6634	Kebbi	Jega	Gindi/Nassarawa/Kyarmi/Galbi	12.164401	4.385814
6635	Taraba	Kurmi	Akwento/Boko	7.015816	10.826144
6636	Taraba	Gashaka	Serti "B"	7.532181	11.403559
6637	Plateau	Mikang	Garkawa North	8.940330	9.697021
6638	Kwara	Asa	Budo-Egba	8.304716	4.451492
6639	Niger	Paikoro	Kwakuti	9.434653	6.909349
6640	Nassarawa	Awe	Galadima	8.067957	9.290669
6641	Delta	Warri North	Ebrohimi	5.994628	5.158656
6642	Imo	Ideato South	Umuobom	5.827946	7.159701
6643	Ondo	Akure South	Gbogi/Isikan I	7.236226	5.150432
6644	Anambra	Awka North	Achalla  III	6.325542	7.012907
6645	Zamfara	Bungudu	Tofa	12.267414	6.795470
6646	Katsina	Mai'Adua	Koza	13.075866	8.335259
6647	Nassarawa	Obi	Gwadenye	8.379064	8.622219
6648	Kano	Kura	Dan Hassan	11.782827	8.535584
8394	Kano	Bebeji	Wak	11.582315	8.332463
6650	Akwa Ibom	Etim Ekpo	Etim Ekpo I	4.960555	7.663003
6651	Kogi	Ankpa	Enjema II	7.528219	7.673771
6652	Kebbi	Jega	Kimba	11.987545	4.448841
6653	Akwa Ibom	Urue Offong|Oruko	Oruko III	4.699977	8.194866
6654	Zamfara	Bakura	Rini	12.720293	6.067400
6655	Katsina	Ingawa	Agayawa	12.781032	8.103762
6656	Kogi	Ankpa	Ankpa I	7.419559	7.519225
6657	Abia	Umu-Nneochi	Obinolu/Obiagu/La	5.918084	7.326712
6658	Borno	Gwoza	Ngoshe	11.132747	13.796639
6659	Bauchi	Gamawa	Kubdiya	12.217643	10.416055
6660	Anambra	Ogbaru	Okpoko IV	6.039503	6.765739
6661	Kwara	Moro	Okemi	8.748035	4.703037
6662	Abia	Ugwunagbo	Ward Ten	4.978294	7.353535
6663	Niger	Paikoro	Nikuchi T/Mallam	9.304949	6.622984
6664	Delta	Bomadi	Akugbene II	5.299543	5.808101
6665	Ebonyi	Ebonyi	Ndiagu	6.367534	8.135883
6666	Enugu	Igbo-eze North	Umuozzi II	7.016392	7.488584
6667	Oyo	Iseyin	Isalu I	8.016499	3.574249
6668	Niger	Bida	Dokodza	9.072236	5.969216
6669	Kano	Bichi	Muntsira	12.156432	8.218865
6670	Gombe	Funakaye	Jillahi	10.794873	11.463321
6671	Kano	Bagwai	Gogori	12.140217	8.061386
6672	Ondo	Ondo West	Okelisa Okedoko/Ogbodu	7.047139	4.868629
6673	Adamawa	Maiha	Maiha Gari	9.991219	13.237679
6674	Ogun	Ogun Waterside	Ode-Omi	6.535722	4.334001
6675	Jigawa	Hadejia	Rumfa	12.450048	10.045012
6676	Bayelsa	Southern Ijaw	Amassoma II	5.017232	6.058302
6677	Abia	Osisioma	Okpor - Umuobo	5.185265	7.354189
6678	Yobe	Borsari	Guba	12.782722	11.399988
6679	Niger	Gbako	Batako	9.336570	6.005996
6680	Anambra	Anaocha	Nri  I	6.139549	7.004468
6681	Kwara	Offa	Igboidun	8.148112	4.670345
6682	Akwa Ibom	Eastern Obolo	Eastern Obolo IV	4.509735	7.716428
6683	Federal Capital Territory	Bwari	Shere	9.201107	7.508954
6684	Nassarawa	Awe	Tunga	8.236524	9.060793
6685	Cross River	Calabar Municipality	Five	4.972894	8.278280
6686	Plateau	Jos East	Jarawan Kogi	9.961235	9.118670
6687	Nassarawa	Nassarawa Egon	Ikka Wangibi	8.626338	8.286128
6688	Rivers	Opobo/Nkoro	Jaja	4.509957	7.533907
6689	Gombe	Funakaye	Bajoga East	10.869818	11.455445
6690	Anambra	Idemili North	Abatete	6.112467	6.937333
6691	Enugu	Nkanu East	Nara I	6.239196	7.663101
6692	Katsina	Kurfi	Kurfi 'B'	12.694951	7.450556
6693	Niger	Bosso	Maikunkele	9.700234	6.454743
6694	Kebbi	Birnin Kebbi	Birnin Kebbi Dangaladima	12.463567	4.187264
6695	Katsina	Danja	Danja B	11.397466	7.511517
6696	Rivers	Ahoada West	Igbuduya IV	5.065643	6.563411
6697	Ondo	Owo	Ehinogbe	7.190210	5.578453
6698	Bauchi	Gamjuwa	Ganjuwa	10.665808	9.695797
6699	Katsina	Faskari	Sheme	11.704764	7.119230
6700	Borno	Kwaya Kusar	Gondi	10.540046	12.039380
6701	Kano	Tarauni	Gyadi-Gyadi Arewa	11.976077	8.511654
6702	Taraba	Gassol	Yarima	8.388077	10.664085
6703	Abia	Umu-Nneochi	Eziama - Ugwu	5.973143	7.315334
6704	Delta	EthiopeE	Abraka  II	5.769054	6.107713
6705	Sokoto	Sokoto South	Sarkin Adar Kwanni	13.023005	5.247957
6706	Kaduna	Kachia	Kwaturu	9.674929	7.965495
6707	Oyo	Ibadan South East	S 7B	7.324234	3.887531
6708	Oyo	Ibadan North	Ward VIII, N6A PART III	7.423426	3.891447
6709	Ekiti	Ilejemeje	Iludun I	7.942096	5.245482
6710	Ekiti	Gboyin	Ode I	7.628417	5.605482
6711	Jigawa	Biriniwa	Fagi	12.715577	10.137095
6712	Benue	Ogbadibo	Orokam II	6.953418	7.613406
6713	Katsina	Sandamu	Rade 'A'	12.901006	8.334153
6714	Imo	Ezinihitte Mbaise	Onicha II	5.506198	7.343951
6715	Edo	Esan West	Emaudo/ Eguare/ Ekpoma	6.752040	6.137896
6716	Lagos	Oshodi/Isolo	Sogunle/Alasia	6.584533	3.333065
6717	Lagos	Ikeja	Ipodo/Seriki Aro	6.612939	3.332405
6718	Oyo	Atiba	Ashipa II	7.959211	3.955062
6719	Anambra	Onitsha South	Fegge II	6.066949	6.749238
6720	Osun	Obokun	Ilare	7.790125	4.790556
6721	Cross River	Ikom	Olulumo	5.921230	8.670690
6722	Katsina	Matazu	Karaduwa	12.290292	7.721889
6723	Anambra	Ihiala	Amamu  II	5.797465	6.816898
6724	Enugu	Isi-Uzo	Ehamufu I	6.780159	7.788898
6725	Rivers	Abua/Odu	Okpeden	4.767437	6.675156
6726	Kano	Bebeji	Gargai	11.552707	8.369506
6727	Katsina	Bindawa	Jibawa/R,Bade	12.721220	7.846546
6728	Plateau	Barkin Ladi	Rafan	9.582587	8.972997
6729	Sokoto	Goronyo	S/gari Dole/Dan/Tasakko	13.202742	5.902730
6730	Plateau	Wase	Yola Wakat	9.225712	10.046784
6731	Ekiti	Ikole	Odo/Ayebode	7.860311	5.546228
6732	Delta	AniochaN	Idumuje - Unor	6.373082	6.408960
6733	Adamawa	Hong	Hong	10.232206	12.930834
6734	Osun	Ifelodun	Eesa Ikirun	7.913517	4.685417
6735	Bayelsa	Yenagoa	Biseni I	5.337118	6.574494
6736	Borno	Hawul	Bilingwi	10.498899	12.250669
6737	Enugu	Oji-River	Ugwuoba II	6.243307	7.150315
6738	Sokoto	Tureta	Lofa	12.614021	5.430594
6739	Cross River	Biase	Erei South	5.706976	7.936256
6740	Akwa Ibom	Ikono	Itak	5.086870	7.826185
6741	Cross River	Odukpani	Odot	5.196655	8.166022
6742	Ebonyi	Afikpo North	Poperi Amasiri	5.900550	7.874076
6743	Katsina	Daura	Sarkin Yara B	13.021559	8.308950
6744	Bauchi	Bauchi	Kangyare/Turwun	10.338433	10.075829
6745	Kano	Gwale	Gwale	11.966330	8.495782
6746	Kano	Ajingi	Dabin Kanawa	11.930028	8.892242
6747	Taraba	Takum	Dutse	7.515568	10.122737
6748	Cross River	Obubra	Ovonum	6.002384	8.265033
6749	Cross River	Obudu	Ukpe	6.501493	9.060296
6750	Ogun	Imeko-Afon	Oke Agbede/Moriwi/Matale	7.795791	2.815714
6751	Bauchi	Toro	Rauta / Geji	10.583815	9.525903
6752	Delta	Ughelli North	Ogor	5.442263	6.018085
6753	Katsina	Mashi	Karau	13.035841	8.038144
6754	Gombe	Yalmatu / Deba	Gwani / Shinga / Wade	10.497727	11.598966
6755	Kebbi	Ngaski	Garin Baka/Makarin	10.580717	4.767279
6756	Anambra	Anambra West	Ezi-anam	6.270248	6.754635
6757	Lagos	Ikeja	Oke-ira/Aguda	6.648138	3.337322
6758	Plateau	Riyom	Ra-Hoss	9.620609	8.714023
6759	Niger	Suleja	Kurmin Sarki	9.194522	7.133437
6760	Katsina	Dandume	Nasarawa	11.468497	7.179823
6761	Abia	Umuahia South	Ahiaukwu  I	5.429795	7.497884
6762	Adamawa	Teungo	Toungo III	8.186362	12.152969
6763	Katsina	Jibia	Mazanya/Magama	13.088632	7.293640
6764	Gombe	Shomgom	Kushi	9.626051	11.254769
6765	Zamfara	Shinkafi	Katuru	12.917872	6.609716
6766	Kwara	Asa	Onire/Odegiwa/Alapa	8.653400	4.357591
6767	Jigawa	Sule Tankarkar	Takatsaba	12.476535	9.284018
6768	Borno	Kaga	Karagawaru	11.884421	12.450985
6769	Benue	Obi	Okwutungbe	6.995320	8.362827
6770	Kano	Kabo	Gude	11.938286	8.065967
6771	Lagos	Badagary	Ajido	6.410606	2.987262
6772	Lagos	Ajeromi/Ifelodun	Tolu	6.460247	3.338222
6773	Ondo	Okitipupa	Aye II	6.598867	4.718902
6774	Ogun	Ijebu East	Itele	6.939339	4.464049
6775	Kano	Kiru	Yalwa	11.471558	8.158347
6776	Ebonyi	Ohaozara	Mgbom Okposi	5.964916	7.811185
6777	Kwara	Asa	Yowere II/Okeweru	8.658522	4.257368
6778	Enugu	Uzo-Uwani	Ugbene I	6.794484	7.224778
6779	Kano	Bichi	Waire	12.276359	8.242476
6780	Edo	Esan North East	Ubierumu	6.681302	6.264465
6781	Ekiti	Irepodun-Ifelodun	Igede I	7.702590	5.132525
6782	Federal Capital Territory	Kuje	Yenche	8.609193	7.160020
6783	Katsina	Malumfashi	Karfi	11.702702	7.526855
6784	Imo	Njaba	umuaka I	5.674536	7.023542
6785	Katsina	Mani	Mani	12.838451	7.886775
6786	Ondo	AkokoNorthWest	Arigidi  II	7.589427	5.790771
6787	Jigawa	Dutse	Karnaya	11.826574	9.336015
6788	Edo	Esan Centtral	Otoruwo I	6.746338	6.224876
6789	Delta	Sapele	Sapele  Urban  VIII	5.915019	5.632938
6790	Katsina	Baure	Agala	12.757482	8.653203
6791	Oyo	Akinyele	Ojoo/Ajibode/Laniba	7.479361	3.899753
6792	Niger	Mariga	Bobi	10.288510	5.912715
6793	Ondo	Idanre	Idale-Logbosere	6.972064	5.248879
6794	Lagos	Shomolu	Lad-Lak/Bariga	6.551792	3.382718
6795	Kano	Kumbotso	Kureken Sani	11.905550	8.571539
6796	Ogun	Ogun Waterside	Ibiade	6.594651	4.319156
6797	Kogi	Ijumu	Ileteju/Origa	7.732390	6.027526
6798	Benue	Ukum	Azendeshi	7.715300	9.644618
6799	Kebbi	Danko Wasagu	Waje	11.539694	5.637886
6800	Niger	Gurara	Kwaka	9.329540	7.112833
6801	Bayelsa	Nembe	Bassambiri IV	4.458348	6.479731
6802	Bauchi	Misau	Kukadi/Gundari	11.286803	10.478818
6803	Lagos	Ikorodu	Ibeshe	6.567179	3.479261
6804	Oyo	Oyo East	Alaodi/Modeke	7.864680	3.953306
6805	Oyo	Atisbo	Tede I	8.550888	3.433556
6806	Kebbi	Bunza	Gwade	12.087116	3.873454
6807	Delta	IsokoSou	Igbide	5.337956	6.160661
6808	Oyo	Ibadan North West	Ward 11 NW7	7.425935	3.872967
6809	Sokoto	Tureta	Barayar Giwa	12.623109	5.465559
6810	Abia	Aba South	Igwebuike	5.056749	7.323534
6811	Katsina	Katsina (K)	Wakilin Gabas I	13.003162	7.619226
6812	Kaduna	Kaduna North	Maiburji	10.494384	7.438564
6813	Kaduna	Jema'a	Godogodo	9.355946	8.335083
6814	Rivers	Omumma	Umuajuloke Community	5.002532	7.151205
6815	Taraba	Ussa	Lumbu	7.082547	10.109638
6816	Jigawa	Biriniwa	Diginsa	12.852117	9.981505
6817	Ondo	Idanre	Isalu Ehinpeti	7.007249	5.056204
6818	Rivers	Omumma	Eberi-Dikeomuuo Community	5.084071	7.234329
6819	Rivers	Abua/Odu	Emelego	4.842533	6.524805
6820	Kaduna	Kaduna North	Kabala Costain/Doki	10.496838	7.464698
6821	Kano	Doguwa	Dogon Kawo	11.172728	8.566436
6822	Ekiti	Efon	Efon II	7.599014	4.936871
6823	Benue	Oturkpo	Otobi	7.080264	8.069599
6824	Cross River	Yala	Wanakom	6.784550	8.698478
6825	Niger	Magama	Ibelu Central	10.462892	5.173456
6826	Borno	Shani	Bargu / Burashika	10.113823	12.077544
6827	Bauchi	Dass	Durr	9.962440	9.384011
6828	Kano	Nasarawa	Hotoro South	11.989664	8.510229
6829	Kogi	Ajaokuta	Ogigiri	7.523996	6.591137
6830	Imo	Oru-East	Amagu	5.778843	6.965943
6831	Rivers	Ikwerre	Apani	5.186303	6.896722
6832	Enugu	Udi	Nsude	6.393690	7.389104
6833	Ekiti	Emure	Odo Emure II	7.446906	5.530758
6834	Osun	Ayedaade	Balogun	7.470383	4.348642
6835	Kano	Ajingi	Ajingi	11.978190	9.028078
6836	Kogi	Ogori Magongo	Aiyeromi	7.454702	6.155570
6837	Rivers	Ogu/Bolo	Wakama	4.672432	7.233151
6838	Borno	Kukawa	Kauwa	12.931257	13.659896
6839	Adamawa	Mubi South	Lamorde	10.199639	13.352747
6840	Benue	Oturkpo	Allan	7.011760	8.118510
6841	Gombe	Akko	Kumo West	10.041972	11.143898
6842	Zamfara	Gusau	Magami	11.647172	6.694760
6843	Enugu	Udi	Ebe	6.492040	7.365325
6844	Kano	Tofa	Langel	11.972947	8.371831
6845	Katsina	Kafur	Mahuta	11.670137	7.821873
6846	Sokoto	Gada	Kadadin Buda (Kaddi)	13.827240	5.569104
6847	Jigawa	Garki	Doko	12.354249	9.078790
6848	Enugu	Nkanu West	Akpugo III	6.323950	7.543962
6849	Borno	Konduga	Kawuri	11.458958	13.445557
6850	Ogun	Ado Odo-Ota	Ado Odo I	6.582327	2.913151
6851	Benue	Ohimini	Oglewu Ehaje	7.156041	8.064503
6852	Katsina	Kankara	Hurya	11.896655	7.582567
6853	Jigawa	Malam Mado	Dunari	12.577803	9.872616
6854	Federal Capital Territory	Kwali	Wako	8.573457	6.979763
6855	Ondo	Ondo East	Oboto	7.159386	4.908281
6856	Rivers	Omumma	Ofeh Community	5.176183	7.208453
6857	Sokoto	Gudu	Tulun Doya	13.463468	4.432452
6858	Anambra	Ogbaru	Okpoko II	6.048700	6.762617
6859	Sokoto	Sabon Birni	S/birni West	13.540919	6.346697
6860	Nassarawa	Wamba	Kwara	8.963812	8.717944
6861	Yobe	Gulani	Garin Tuwo	10.790257	11.661070
6862	Ekiti	Ekiti East	Obadore III	7.691392	5.675217
6863	Borno	Askira/Uba	Uba	10.472682	13.223019
6864	Gombe	Balanga	Swa / Ref / W. Waja	10.044670	11.787785
6865	Osun	Ife South	Ayesan	7.210001	4.650199
6866	Imo	Ideato North	Ndimoko	5.858890	7.225942
6867	Rivers	Ikwerre	Omademe/Ipo	5.067309	6.949243
6868	Ebonyi	Ivo	Umobo	5.866924	7.669788
6869	Akwa Ibom	Oruk Anam	Abak Midim IV	4.671844	7.552722
6870	Jigawa	Kirika Samma	Doleri	12.634798	10.262328
6871	Niger	Katcha	Dzwafu	8.997263	6.190521
6872	Enugu	Igbo-eze South	Ovoko (Umuelo/Ovoko Agu ward)	6.899446	7.467269
6873	Akwa Ibom	Ibesikpo Asutan	Ibesikpo III	4.921782	7.968488
6874	Benue	Vandeikya	Mbanyumangbagh	6.670652	9.093369
6875	Delta	Oshimili South	Anala-Amakom	6.110591	6.715360
6876	Sokoto	Kebbe	Nasagudu	11.678743	4.574687
6877	Oyo	Ori-Ire	Ori Ire I	8.215257	4.173426
6878	Jigawa	Hadejia	Yankoli	12.443740	10.057095
6879	Niger	Shiroro	Pina	9.749287	6.669614
6880	Yobe	Nguru	Garbi/Bambori	12.830184	10.444261
6881	Rivers	Ikwerre	Igwuruta	4.984075	6.984864
6882	Sokoto	Tambawal	Saida/Goshe	12.642906	4.864961
6883	Kaduna	Kauru	Kamaru	9.783223	8.598734
6884	Jigawa	Kiyawa	Kiyawa	11.787331	9.610280
6885	Anambra	Nnewi North	Umudim  II	5.984941	6.880722
6886	Sokoto	Shagari	Kajiji	12.491481	4.975092
6887	Jigawa	Ringim	Dabi	12.089490	9.004342
6888	Jigawa	Gumel	Kofar Arewa	12.637971	9.393144
6889	Enugu	Igbo-eze South	Ovoko (Umulolo Ward)	6.885323	7.431187
6890	Imo	Ahiazu-Mbaise	Mpam	5.591385	7.290991
6891	Imo	Isu	Umundugba II	5.669982	7.085142
6892	Kano	Kunchi	Ridawa	12.458895	8.325993
6893	Imo	Obowo	Ehume	5.539154	7.373987
6894	Katsina	Mai'Adua	Bumbum 'a'	13.249042	8.093671
6895	Federal Capital Territory	Abaji	Gurdi	8.869949	6.795372
6896	Cross River	Ikom	Abanyum	6.242183	8.659150
6897	Ekiti	Efon	Efon VIII	7.722219	4.973116
6898	Osun	Ifelodun	Ekoende/Eko Ajala	7.921211	4.596731
6899	Katsina	Kaita	Abdallawa	13.184195	7.831741
6900	Ondo	Ondo East	Owena Bridge	7.026155	4.956690
6901	Kebbi	Bunza	Maidahini	12.020604	4.050952
6902	Oyo	Ibadan South West	Ward 2  SW1	7.372346	3.890963
6903	Borno	Chibok	Mbalala	10.753542	12.836812
6904	Oyo	Ibarapa Central	Idere I (Molete)	7.485116	3.230071
6905	Imo	Obowo	Alike	5.539432	7.331947
6906	Gombe	Billiri	Baganje South	9.869814	11.160036
6907	Sokoto	Wurno	Marafa	13.292887	5.441302
6908	Zamfara	Anka	Barayar-Zaki	12.224022	5.868497
6909	Sokoto	Yabo	Yabo 'A'	12.679709	5.029206
6910	Anambra	Aguata	Igbo - Ukwu II	6.004522	7.022601
6911	Akwa Ibom	Ikot Ekpene	Ikot Ekpene V	5.186810	7.702347
6912	Imo	Isiala Mbano	Obollo	5.678963	7.211100
6913	Benue	Gwer East	Mbasombo	7.530820	8.493409
6914	Kogi	Omala	Abejukolo I	7.755081	7.551274
6915	Akwa Ibom	Nsit Atai	Eastern Nsit X	4.827460	7.990950
6916	Gombe	Gombe	Dawaki	10.317207	11.243547
6917	Taraba	Takum	Tikari	7.519703	9.980455
6918	Oyo	Saki West	Ogidigbo/Kinnikinni	8.495349	2.981720
6919	Ekiti	Emure	Odo Emure I	7.460290	5.474393
6920	Lagos	Epe	Ise/Igbogun	6.411606	4.278281
6921	Akwa Ibom	Etinan	Etinan Urban V	4.881320	7.838963
6922	Abia	Osisioma	Urtta	5.184498	7.297450
6923	Rivers	Degema	Bakana  II	4.714920	6.885031
6924	Yobe	Yunusari	Ngirabo	13.270288	11.427921
6925	Bauchi	Alkaleri	Gar	10.046740	10.343953
6926	Anambra	Awka North	Ugbenu	6.367102	7.072798
6927	Edo	Etsako East	Agenebode	7.091783	6.676092
6928	Lagos	Ikorodu	Imota I	6.614816	3.658468
6929	Anambra	Orumba North	Nanka  II	6.066481	7.079052
6930	Jigawa	Garki	Kore	12.330900	9.411199
6931	Nassarawa	Nasarawa	Udenin Gida	8.180568	8.018333
6932	Ebonyi	Onicha	Ebia Oshiri	6.125211	7.882414
6933	Imo	Nwangele	Amano/Umudurumba Ward (Amaigbo I)	5.728482	7.173579
6934	Niger	Borgu	Dugga	10.483659	4.357080
6935	Borno	Jere	Ngudaa/Addamari	11.913911	13.346763
6936	Ogun	Ijebu North	Osun	7.010919	4.132069
6937	Borno	Hawul	Kwaya-Bur/Tanga Rumta	10.497076	12.129904
6938	Anambra	Ihiala	Azia	5.881599	6.898750
6939	Anambra	Ihiala	Uli  II	5.792669	6.872754
6940	Katsina	Kafur	Dutsin Kura/Kanya	11.462554	7.652380
6941	Osun	Ejigbo	Ola/Aye/Agurodo	7.936489	4.271329
6942	Osun	Ife North	Oyere I	7.209633	4.448489
6943	Adamawa	Yola South	Mbamoi	9.172610	12.627691
6944	Kebbi	Maiyama	Gumbin Kure	12.195951	4.239261
6945	Taraba	Lau	Garin Magaji	9.166515	11.436166
6946	Sokoto	Silame	Katami North	12.923751	4.796730
6947	Ondo	Akoko South-East	Isua II	7.432214	5.899205
6948	Ondo	AkokoNorthWest	Oyin/Oge	7.685391	5.767662
6949	Kebbi	Zuru	Bedi	11.427945	5.320857
6950	Cross River	Ikom	Ofutop II	5.889031	8.502428
6951	Katsina	Rimi	Kadandani	12.744191	7.674912
6952	Anambra	Anambra West	Olumbanasa-inoma	6.587926	6.830315
6953	Lagos	Epe	Odoragunsin	6.657526	3.967914
6954	Adamawa	Fufore	Wuro Bokki	9.496567	12.851450
6955	Ogun	Odeda	Opeji	7.439064	3.406434
6956	Ogun	Abeokuta South	Sodeke/Sale-Ijeun II	7.173777	3.333219
6957	Niger	Mariga	Galma/Wamba	10.645024	5.919458
6958	Kogi	Kabba-Bunu	Okebukun	8.054646	6.377254
6959	Benue	Ado	Igumale I	6.778199	7.955059
6960	Kwara	Asa	Yowere/Sosoki	8.588921	4.440932
6961	Jigawa	Miga	Hantsu	12.211516	9.560805
6962	Kano	Tofa	Doka	11.998991	8.267688
6963	Enugu	Nkanu East	Owo	6.488686	7.684792
6964	Ogun	Abeokuta North	Ika	7.221188	3.229527
6965	Kogi	Igalamela-Odolu	Akpanya	7.084470	7.236212
6966	Lagos	Ifako/Ijaye	Old Ifako/Karaole	6.667941	3.327231
6967	Federal Capital Territory	Bwari	Dutse Alhaji	9.130630	7.483515
6968	Katsina	Mani	Bujawa/Gewayau	12.894380	8.045222
6969	Delta	IsokoSou	Oleh  I	5.494744	6.209433
6970	Oyo	Saki East	Ago Amodu I	8.618944	3.623840
6971	Imo	Ideato South	Ogboko I	5.788280	7.128105
6972	Imo	Orsu	Amaruru	5.905472	7.027001
6973	Yobe	Karasuwa	Wachakal	12.806477	10.549030
6974	Ondo	Akoko North-East	Ilepa I	7.525367	5.753911
6975	Niger	Bosso	Bosso Central  I	9.654239	6.517362
6976	Katsina	Charanchi	Charanchi	12.676252	7.700236
6977	Abia	Isiala Ngwa North	Umuoha	5.336676	7.327699
6978	Borno	Gwoza	Guduf Nagadiyo	11.090298	13.734407
6979	Ogun	Abeokuta North	Gbagura	7.241022	3.187191
6980	Abia	Umu-Nneochi	Ubahu/Akawa/Arokpa	5.924811	7.482536
6981	Kaduna	Kaduna North	Badarawa	10.553955	7.461398
6982	Lagos	Alimosho	Ipaja South	6.609766	3.267787
6983	Kano	Garum Mallam	Yad Akwari	11.677394	8.365075
6984	Gombe	Kwami	Daban Fulani	10.490424	11.419696
6985	Imo	Njaba	Atta II	5.742199	6.989237
6986	Kano	Makoda	Maitsidau	12.345381	8.495789
6987	Rivers	Khana	Zaakpori	4.648366	7.379295
6988	Rivers	Degema	Ke/Old Bakana	4.497330	6.870950
6989	Oyo	Ona-Ara	Oremeji/Agugu	7.361580	3.946180
6990	Adamawa	Shelleng	Bakta	9.848735	12.259734
6991	Oyo	Akinyele	Olanla/Oboda/laBode	7.620798	4.007785
6992	Osun	Ila	Ejigbo  I	8.032730	4.838761
6993	Kogi	Lokoja	Lokoja-C	7.855506	6.408822
6994	Benue	Gboko	Gboko North West	7.335558	8.988000
6995	Adamawa	Mayo-Belwa	Gorobi	9.138661	11.866155
6996	Enugu	Uzo-Uwani	Nkpologu	6.759753	7.239688
6997	Ekiti	Efon	Efon X	7.701551	4.933292
6998	Ogun	Ado Odo-Ota	Agbara I	6.542158	3.037990
6999	Kano	Bagwai	Bagwai	12.161308	8.146918
7000	Imo	Obowo	Amuzi	5.560237	7.327109
7001	Ebonyi	Ebonyi	Ndiebor	6.706499	8.133486
7002	Abia	Aba South	Ohazu I	5.078486	7.371547
7003	Niger	Rafi	Kongoma West	10.341194	6.341308
7004	Jigawa	Malam Mado	Tagwaro	12.593094	10.136156
7005	Ebonyi	Afikpo South	Amoso	5.828423	7.826813
7006	Lagos	Ikeja	Onigbongbon	6.591762	3.306243
7007	Borno	Chibok	Pemi	10.784975	12.935069
7008	Kano	Dawakin Kudu	Yankatsari	11.898596	8.611707
7009	Rivers	Opobo/Nkoro	Nkoro III	4.530071	7.452500
7010	Imo	Orlu	Umudioka	5.746074	7.070235
7011	Ebonyi	Onicha	Amanator-Isu	6.154392	7.755659
7012	Benue	Makurdi	Wailomayo	7.721174	8.533235
7013	Akwa Ibom	Mbo	Udesi	4.703339	8.228575
7014	Oyo	Egbeda	Olodan/Ajinogbo	7.431428	4.033936
7015	Niger	Edati	Guzan	9.010617	5.546915
7016	Federal Capital Territory	Kuje	Gudun Karya	8.533422	7.340733
7017	Enugu	Oji-River	Achiagu III	6.146290	7.334138
7018	Rivers	Eleme	Ebubu	4.778832	7.166042
7019	Kano	Wudil	Indabo	11.721398	8.766713
7020	Kebbi	Gwandu	Gwandu Sarkin Fawa	12.481588	4.623842
7021	Rivers	Ogba/Egbema/Andoni	Egi III (Erema)	5.184463	6.672143
7022	Akwa Ibom	Mbo	Efiat I	4.599169	8.276248
7023	Federal Capital Territory	Gwagwalada	Kutunku	8.975394	7.089480
7024	Delta	Oshimili North	Ibusa  I	6.143490	6.662831
7025	Adamawa	Numan	Numan II	9.464801	12.103378
7026	Kano	Doguwa	Ragada	10.661256	8.635442
7027	Abia	Isiala Ngwa North	Mbawsi / Umuomainta	5.387286	7.425956
7028	Benue	Ohimini	Awume Icho	7.239360	7.857972
7029	Kaduna	Kaura	Kadarko	9.585653	8.499394
7030	Oyo	Kajola	Kajola	8.137007	3.327904
7031	Niger	Shiroro	Galkogo	10.132972	6.845947
7032	Zamfara	Bukkuyum	Adabka	11.789731	5.744514
7033	Adamawa	Teungo	Toungo I	8.096413	12.128137
7034	Nassarawa	Doma	Sabon Gari	8.426426	8.412948
7035	Benue	Gwer West	Sengev	7.784369	8.163316
7036	Benue	Agatu	Enungba	7.823558	7.810397
7037	Imo	Ideato North	Izuogu I	5.820440	7.203169
7038	Osun	Iwo	Isale Oba  II	7.631710	4.181581
7039	Katsina	Funtua	Dukke	11.521465	7.213022
7040	Bayelsa	Kolokuma-Opokuma	Opokuma South	5.045074	6.207181
7041	Niger	Kontogur	Nagwamatse	10.373025	5.560940
7042	Kogi	Omala	Okpatala	7.854897	7.554870
7043	Kwara	Oyun	Irra	8.110813	4.595124
7044	Bauchi	Misau	Jarkasa	11.455158	10.460797
7045	Taraba	Gashaka	Jamtari	7.729654	11.611141
7046	Kogi	Ijumu	Iyah/Ayeh	8.006752	6.012695
7047	Enugu	Udenu	Ogbodu-Aba	6.851497	7.611931
7048	Delta	Ughelli North	Ughelli  I	5.513356	5.978661
7049	Kogi	Yagba West	Oke Egbe III	8.249253	5.459734
7050	Bauchi	Giade	Chinkani	11.285574	10.237352
7051	Benue	Logo	Mbayam	7.514624	9.336501
7052	Bauchi	Damban	Yanda	11.543121	10.767891
7053	Kwara	Offa	Essa-B	8.112909	4.737785
7054	Kebbi	Aleiro	Rafin Bauna	12.288292	4.406151
7055	Imo	Oguta	Ndeuloukwu/Umuowere	5.642218	6.891263
7056	Anambra	Anambra West	Umueze-anam  I	6.368244	6.825733
7057	Enugu	Nsukka	Akalite	6.767830	7.379151
7058	Niger	Bosso	Kampala	9.653286	6.380761
7059	Zamfara	Anka	Wuya	12.016323	6.123380
7060	Cross River	Obudu	Utugwang South	6.620550	8.974521
7061	Katsina	Kafur	Dantutture	11.750684	7.790558
7062	Katsina	Matazu	Rinjin idi	12.202121	7.637689
7063	Abia	Arochukwu	Arochukwu III	5.412677	7.874054
7064	Sokoto	Shagari	Sanyinnawal	12.540002	4.976998
7065	Lagos	Ifako/Ijaye	Pamada/Abule-Egba	6.665076	3.306280
7066	Adamawa	Song	Kilange Funa	9.873607	12.805279
7067	Anambra	Nnewi North	Otolo  I	5.991697	6.909142
7068	Rivers	Eleme	Eteo	4.754554	7.195598
7069	Kano	Fagge	Fagge A	11.967044	8.560596
7070	Borno	Gubio	Gubio Town II	12.512915	12.754391
7071	Kano	Karaye	Unguwar Hajji	11.753722	7.995340
7072	Rivers	Asari-Toru	Isia Group II	4.751900	6.844265
7073	Niger	Bosso	Garatu	9.486001	6.408798
7074	Anambra	Ekwusigo	Ozubulu  V	5.962840	6.846322
7075	Anambra	Idemili North	Nkpor  II	6.112070	6.844847
7076	Adamawa	Hong	Uba	10.375064	13.258602
7077	Abia	Osisioma	Oso - Okwa	5.169586	7.319473
7078	Osun	Atakumosa East	Forest Reserve  I	7.185374	4.823595
7079	Enugu	Udi	Nachi	6.263353	7.297799
7080	Ondo	Owo	Uso/Emure Ile	7.265488	5.472843
7081	Oyo	Egbeda	Owobaale/Kasumu	7.416902	4.066331
7082	Edo	Uhunmwonde	Uhi	6.540635	6.029801
7083	Oyo	Ogbomosho North	Osupa	8.165071	4.220443
7084	Delta	IsokoNor	Oyede	5.438126	6.271577
7085	Anambra	Anaocha	Nri  II	6.108499	6.992920
7086	Oyo	Ogbomosho North	Isale Afon	8.132240	4.247439
7087	Bayelsa	Ekeremor	Tarakiri	5.145207	5.946208
7088	Anambra	Idemili South	Awka-etiti  I	6.026332	6.931803
7089	Benue	Apa	Akpete/Ojantelle	7.730353	7.831427
7090	Federal Capital Territory	Bwari	Bwari Central	9.263581	7.420766
7091	Borno	Askira/Uba	Chul / Rumirgo	10.616944	13.093294
7092	Anambra	Orumba South	Ogbunka  II	6.019696	7.259739
7093	Niger	Shiroro	Ubandoma	9.828038	6.669321
7094	Ondo	AkokoNorthWest	Odo-Irun/Oyinmo	7.606898	5.646949
7095	Yobe	Machina	Dole	12.897591	9.826426
7096	Katsina	Batsari	Dan. Alh/Yangaiya	12.848173	7.328292
7097	Taraba	Gashaka	Gayam	7.744342	11.243970
7098	Ondo	Akoko South-East	Ipesi	7.358236	5.931316
7099	Jigawa	Kaugama	Dakaiyawa	12.348667	9.870931
7100	Nassarawa	Akwanga	Nunku	9.109114	8.363096
7101	Niger	Chanchaga	Minna Central	9.601503	6.511768
7102	Niger	Shiroro	Bassa/Kukoki	10.171618	6.523703
7103	Katsina	Dutsi	Kayawa	12.953495	8.155541
7104	Ogun	Egbado South	Owode I	6.762888	2.958760
7105	Enugu	Igbo-eze North	Umuitodo II	6.985068	7.504042
7106	Akwa Ibom	Abak	Abak Urban II	4.913413	7.790458
7107	Enugu	Enugu East	Umuchigbo	6.499918	7.536870
7108	Edo	Uhunmwonde	Egbede	6.291996	5.844154
7109	Plateau	Qua'anpa	Doemak-Goechim	8.986080	9.133394
7110	Rivers	Bonny	Ward VI Abalamabie	4.419005	7.247229
7111	Delta	Bomadi	Kpakiama	5.134091	5.907461
7112	Cross River	Akamkpa	Ikpai	5.591962	8.689205
7113	Oyo	Lagelu	Ogunjana/Olowode/Ogburo	7.584526	4.073417
7114	Anambra	Orumba South	Akpu	6.020556	7.192098
7115	Kaduna	Giwa	Giwa	11.305663	7.490097
7116	Benue	Ohimini	Awume Ehaje	7.182837	7.842678
7117	Lagos	Lagos Mainland	Oko-Baba	6.489130	3.381070
7118	Katsina	Sandamu	Fago 'B'	12.848496	8.416762
7119	Kwara	Ilorin South	Akanbi IV	8.434475	4.723705
7120	Kano	Kano Municipal	Tudun Nufawa	11.946677	8.460788
7121	Plateau	Kanam	Garga	9.498247	10.419618
7122	Bauchi	Itas/Gadau	Gwarai	11.780497	9.837017
7123	Sokoto	Sabon Birni	Tsamaye	13.555859	5.988530
7124	Sokoto	Sokoto South	Gagi 'A'	13.004713	5.291029
7125	Enugu	Nkanu West	Ozalla	6.283046	7.456269
7126	Sokoto	Wamakko	K/kimba/Gedewa	13.085614	5.095868
7127	Kano	Minjibir	Kwarkiya	12.219411	8.617748
7128	Osun	IfeCentral	Iremo V	7.422131	4.607292
7129	Kogi	Ijumu	Odokoro	7.944630	6.010224
7130	Imo	Owerri West	Umuguma	5.467019	6.992208
7131	Abia	Umu-Nneochi	Eziama - Agbo	5.934374	7.286514
7132	Kano	Kibiya	Unguwar Gai	11.592095	8.677886
7133	Ekiti	Ido-Osi	Osi	7.773880	5.141527
7134	Borno	Abadam	Fuguwa	13.401274	12.976986
7135	Katsina	Musawa	Kurkujan 'A'	12.104372	7.779775
7136	Osun	Irewole	Ikire 'F'	7.339784	4.205799
7137	Imo	Ohaji-Egbema	Egbema 'A'	5.508050	6.691822
7138	Taraba	Ardo-Kola	Iware	8.816292	11.165482
7139	Katsina	Kusada	Kusada	12.460988	7.964798
7140	Delta	Ukwuani	Eziokpor	5.808153	6.195849
7141	Jigawa	Gwaram	Kila	11.307996	9.786341
7142	Anambra	Ihiala	Ubuluisiuzor	5.839813	6.888153
7143	Plateau	Jos South	Zawan 'A'	9.703670	8.811590
7144	Sokoto	Sabon Birni	Unguwar Lalle	13.505889	6.084075
7145	Yobe	Karasuwa	Gasma	12.909919	10.960181
7146	Lagos	Oshodi/Isolo	Okota	6.529490	3.291224
7147	Ebonyi	Izzi	Ndieze Inyimagu Mgbabeluzor	6.556907	8.295924
7148	Yobe	Fika	Janga / Boza / Fa. Sawa / T. Nanai	11.530971	11.248961
7149	Osun	Ejigbo	Elejigbo 'A'	7.919323	4.303798
7150	Akwa Ibom	Itu	East Itam II	5.108885	7.959623
7151	Edo	Owan East	Ihievbe  II	7.098892	6.104543
7152	Kano	Ajingi	Balare	11.991481	8.920602
7153	Federal Capital Territory	Municipal	City Centre	9.026572	7.474604
7154	Akwa Ibom	Ini	Ikono North I	5.356267	7.694005
7155	Benue	Logo	Ukembergya/Iswarev	7.815314	9.337391
7156	Osun	Atakumosa East	Ayegunle	7.468939	4.794851
7157	Adamawa	Demsa	Gwamba	9.593622	12.314639
7158	Borno	Kukawa	Alagarno	13.198990	13.450916
7159	Niger	Lavun	Dabban	9.362913	5.677711
7160	Plateau	Mikang	Tunkus	9.040062	9.620335
7161	Delta	Warri South-West	Akpikpa	5.608715	5.432641
8498	Benue	Apa	Igoro	7.686530	7.836298
7162	Benue	Vandeikya	Vandeikya Township	6.789674	9.063931
7163	Osun	Odo Otin	Jagun Osi Bale Ode	7.972454	4.623237
7164	Ondo	Okitipupa	Ode aye I	6.624263	4.763082
7165	Enugu	Uzo-Uwani	Nrobo	6.841207	7.268016
7166	Ebonyi	Ezza North	Umuezeoka	6.259595	7.943027
7167	Borno	Gubio	Zowo	12.710947	12.816119
7168	Borno	Bama	Mbuliya / Goniri / Siraja	11.477598	13.642119
7169	Osun	Olorunda	Ilie	7.937036	4.554254
7170	Anambra	Ogbaru	Ogwuaniocha	5.756479	6.709187
7171	Imo	Obowo	Okenalogho	5.569340	7.383949
7172	Ekiti	Ido-Osi	Usi	7.873330	5.188125
7173	Kogi	Ijumu	Iffe/Ikoyi/Okejumu	7.838289	5.922648
7174	Sokoto	Yabo	Bakale	12.855418	4.972843
7175	Enugu	Ezeagu	Aguobu-Owa II	6.368612	7.249056
7176	Zamfara	Gummi	Shiyar Rafi	12.054734	5.231848
7177	Kano	Kabo	Godiya	11.921746	8.164578
7178	Plateau	Wase	Mavo	9.062750	10.144098
7179	Kebbi	Suru	Bakuwai	11.906948	4.056834
7180	Oyo	Ogbomosho North	Jagun	8.122193	4.240622
7181	Kano	Kiru	Bauda	11.557852	8.183752
7182	Taraba	Donga	Asibiti	7.710783	10.218651
7183	Lagos	Kosofe	Ikosi Ketu/Mile 12/Agiliti/Maidan	6.629123	3.398077
7184	Yobe	Bade	Tagali/Sugum	12.756398	10.617504
7185	Kano	Kiru	Ba'awa	11.618706	8.034578
7186	Sokoto	Binji	Bakale	13.153762	4.786845
7187	Sokoto	Kebbe	Sangi	11.796820	4.905372
7188	Benue	Ushongo	Atikyese	7.026204	9.009971
7189	Yobe	Fune	Gaba Tasha/Aigada/Dumbulwa	11.724260	11.379850
7190	Lagos	Amuwo Odofin	Festac II	6.491144	3.281197
7191	Ekiti	Ekiti East	Isinbode	7.693310	5.599387
7192	Edo	Ovia North East	Okada west	6.728506	5.398508
7193	Kebbi	Kalgo	Wurogauri	12.256277	4.015263
7194	Osun	Ayedaade	Ijegbe/Oke-Eso/Oke-Owu Ijugbe	7.525504	4.396442
7195	Osun	Ayedire	Oluponna  I	7.578956	4.219582
7196	Osun	Obokun	Esa - Odo	7.767276	4.833672
7197	Kwara	Pategi	Kpada III	8.532845	5.674284
7198	Ekiti	Efon	Efon I	7.603930	4.967043
7199	Yobe	Nangere	Dawasa/G.Baba	11.960324	10.982346
7200	Ondo	Akure South	Oshodi/Isolo	7.281974	5.182423
7201	Sokoto	Gudu	Maraken Bori	13.690991	4.658296
7202	Plateau	Qua'anpa	Kwang	9.020263	9.275275
7203	Adamawa	Madagali	K/wuro Ngayandi	10.834454	13.430194
7204	Ogun	Abeokuta South	Igbore/Ago Oba	7.147961	3.311368
7205	Lagos	Agege	oniwaya/Papa-Uku	6.634449	3.306987
7206	Zamfara	Kaura-Namoda	Kyam Barawa	12.433720	6.635882
7207	Akwa Ibom	Ibeno	Ibeno V	4.544206	8.002366
7208	Rivers	Ogba/Egbema/Andoni	Egbema I	5.440127	6.709647
7209	Ogun	Ifo	Ifo II	6.822261	3.231646
7210	Cross River	Calabar South	One (1)	4.929050	8.275623
7211	Rivers	Akukutor	Georgewill II	4.713854	6.748052
7212	Osun	Ilesha East	Ifosan/Oke-Eso	7.597951	4.765471
7213	Katsina	Mashi	Bamble	13.275078	7.996897
7214	Kaduna	Kaduna South	Unguwan Sanusi	10.534363	7.425346
7215	Oyo	Ibadan North West	Ward 3 NW1	7.378201	3.892141
7216	Ondo	Akoko South-West	Oba I	7.340120	5.686922
7217	Borno	Nganzai	Sugundure	12.425012	13.258154
7218	Zamfara	Kaura-Namoda	Gladima Dan Galadima	12.549378	6.622358
7219	Kaduna	Kaduna North	Unguwan Shanu	10.553590	7.432676
7220	Benue	Gwer East	Aliade Town	7.302841	8.510141
7221	Imo	Ezinihitte Mbaise	Okpofe/Ezeagbogu	5.469269	7.305682
7222	Sokoto	Sokoto South	R/Dorowa 'A'	13.022686	5.264857
7223	Niger	Mokwa	Rabba/Ndayako	9.285951	5.109368
7224	Adamawa	Yola North	Luggere	9.253837	12.495930
7225	Akwa Ibom	Okobo	Okopedi II	4.865083	8.121723
7226	Ondo	Ondo East	Orisunmibare	7.183756	5.015009
7227	Akwa Ibom	Ibeno	Ibeno III	4.553161	8.003456
7228	Osun	Orolu	Olufon Orolu 'C'	7.841968	4.462937
7229	Rivers	Ahoada West	Igbuduya III	5.045594	6.469032
7230	Sokoto	Sokoto South	S/A/K/Atiku	13.025472	5.256025
7231	Anambra	Idemili South	Ojoto	6.065724	6.880355
7232	Delta	Ndokwa East	Onyia/Adiai/Otuoku/Umuolu	5.377842	6.454143
7233	Bayelsa	Southern Ijaw	Olodiama II	4.689309	5.968882
7234	Adamawa	Fufore	Beti	9.022640	12.743887
7235	Kebbi	Dandi	Maihausawa	11.835338	3.659640
7236	Gombe	Nafada	Barwo Winde	11.127627	11.182552
7237	Kano	Kano Municipal	Kankarofi	11.938789	8.498474
7238	Ekiti	Irepodun-Ifelodun	Iropora / Esure / Eyio	7.727635	5.188831
7239	Adamawa	Hong	Garaha	10.407872	12.812016
7240	Akwa Ibom	Abak	Otoro III	5.081790	7.779135
7241	Abia	Aba North	Old Aba Gra	5.120386	7.361824
7242	Abia	Bende	Item B	5.761035	7.639727
7243	Gombe	Balanga	Gelengu / Balanga	10.003485	11.640430
7244	Kaduna	Sabon Gari	Jushi Waje	11.104356	7.755900
7245	Enugu	Igbo-eze South	Iheakpu (Ajuona Ogbagu ward)	6.924568	7.394448
7246	Anambra	Onitsha North	Inland Town VI	6.112366	6.790584
7247	Delta	Burutu	Ogbolubiri	5.345060	5.578593
7248	Plateau	Bassa	Jengre	10.213155	8.821360
7249	Bayelsa	Yenagoa	Okordia	5.156838	6.432962
7250	Abia	Aba South	Asa	5.083633	7.333813
7251	Ondo	Ondo West	Litaye/Obunkekere/Igbindo	6.930916	4.649076
7252	Kano	Gwarzo	Getso	11.884614	7.970806
7253	Anambra	Anambra East	Eziagulu-otu	6.389757	6.895957
7254	Akwa Ibom	Ibeno	Ibeno VI	4.556077	7.945445
7255	Kaduna	Kachia	Sabon Sarki	9.630210	8.050692
7256	Nassarawa	Awe	Ribi	8.141313	9.080635
7257	Anambra	Anambra East	Nando  II	6.353697	6.909184
7258	Sokoto	Shagari	Mandera	12.445310	4.969416
7259	Kaduna	Jaba	Fada	9.445759	8.003061
7260	Ekiti	Oye	Ilupeju I	7.787634	5.279250
7261	Bauchi	Darazo	Papa	11.206048	10.794912
7262	Rivers	Degema	Degema  I	4.699863	6.786603
7263	Akwa Ibom	Ukanafun	Northern Afaha II	4.904794	7.635196
7264	Osun	Ife East	Modakeke  III	7.392774	4.584749
7265	Kano	Gaya	Maimakawa	11.725134	9.105909
7266	Nassarawa	Keffi	Ang.Rimi	8.853986	7.882081
7267	Delta	Patani	Abari	5.257100	6.278229
7268	Bayelsa	Nembe	Okoroma II	4.508251	6.188576
7269	Plateau	Kanke	Kabwir Pada	9.392935	9.624998
7270	Kogi	Dekina	Ogbabede	7.538951	6.879611
7271	Imo	Ohaji-Egbema	Egbema 'E'	5.573553	6.674511
7272	Kano	Rogo	Beli	11.452514	7.840408
7273	Rivers	Gokana	Bodo II	4.625724	7.279349
7274	Katsina	Baure	Muduri	12.795441	8.746665
7275	Osun	Boripe	College/Egbada Road	7.804080	4.647213
7276	Ondo	Ondo East	Epe	7.081382	4.954476
7277	Oyo	Oluyole	Onipe	7.127365	3.886356
7278	Kano	Karaye	Yammedi	11.829786	8.069230
7279	Jigawa	Roni	Sankau	12.648154	8.229610
7280	Akwa Ibom	Etim Ekpo	Etim Ekpo VI	5.014666	7.666364
7281	Sokoto	Shagari	Lambara	12.431540	5.235505
7282	Katsina	Kusada	Bauranya 'A'	12.387276	7.992856
7283	Kano	Garum Mallam	Garun Malam	11.670998	8.325301
7284	Ebonyi	Ebonyi	Urban New Layout	6.329078	8.122506
7285	Ekiti	Gboyin	Ijan	7.645100	5.406253
7286	Taraba	Gassol	Sabon Gida	8.176946	10.454982
7287	Niger	Agwara	Busuru	10.744430	4.554666
7288	Katsina	Sabuwa	Gamji	11.344647	7.114503
7289	Jigawa	Yankwashi	Kuda	12.757812	8.471822
7290	Kano	Garko	Sarina	11.569381	8.918185
7291	Delta	AniochaN	Ezi	6.437581	6.545793
7292	Jigawa	Jahun	Gangawa	11.978592	9.728430
7293	Zamfara	Tsafe	Chediya	12.013776	6.955280
7294	Jigawa	Malam Mado	Shaiya	12.430231	9.850954
7295	Bayelsa	Brass	Cafe Farmosa	4.405239	6.169241
7296	Anambra	Orumba North	Ndiukwuenu/Okpeze	6.184980	7.161561
7297	Imo	Owerri North	Ihitta-Oha	5.517943	7.033778
7298	Ogun	Ijebu-Ode	Porogun I	6.848340	3.904312
7299	Abia	Isiala Ngwa South	Ehina Guru Osokwa	5.297145	7.447108
7300	Enugu	Uzo-Uwani	Abbi	6.853810	7.223699
7301	Rivers	Bonny	Ward XII Kalaibiama	4.520140	7.087403
7302	Osun	Isokan	Asalu (Mogimogi)	7.305593	4.185886
7303	Anambra	Ihiala	Okija  IV	5.864253	6.812377
7304	Imo	Orlu	Eziachi/Amike	5.756840	7.098581
7305	Kebbi	Birnin Kebbi	Makera	12.462812	4.078212
7306	Delta	IsokoNor	Ozoro  I	5.539979	6.210783
7307	Plateau	Bassa	Kasuru	10.164113	8.712641
7308	Delta	Burutu	Ogulagha	5.265621	5.391455
7309	Ogun	Ado Odo-Ota	Sango	6.741900	3.148068
7310	Gombe	Shomgom	Filiya	9.649781	11.184316
7311	Ondo	Akure North	Ayede/Ogbese	7.221424	5.375481
7312	Kogi	Okene	Abuga/Ozuja	7.533816	6.109878
7313	Akwa Ibom	Udung Uko	Udung Uko IX	4.721214	8.231893
7314	Kaduna	Jaba	Chori	9.493565	8.103573
7315	Enugu	Udenu	Imilike	6.853421	7.537363
7316	Katsina	Faskari	Ruwan Godiya	11.771357	7.209890
7317	Abia	Arochukwu	Ohafor I	5.594034	7.725632
7318	Lagos	Ifako/Ijaye	Fagba/Akute road	6.676248	3.317693
7319	Taraba	Gassol	Tutare	8.637077	10.644440
7320	Kogi	Adavi	Idanuhua	7.526585	6.364485
7321	Yobe	Jakusko	Lafiya Loi-Loi	12.135377	10.955530
7322	Katsina	Daura	Kusugu	13.025350	8.308430
7323	Borno	Guzamala	Guworam	12.690599	13.540746
7324	Kogi	Igalamela-Odolu	Oji-Aji	6.967682	7.171523
7325	Anambra	Anambra West	Umueze-anam  II	6.329431	6.787486
7326	Nassarawa	Karu	Karu	8.993478	7.613144
7327	Oyo	Iwajowa	Iwere-Ile II	8.100293	2.893643
7328	Federal Capital Territory	Municipal	Nyanya	9.030400	7.533006
7329	Kaduna	Chikun	Kujama	10.472399	7.680392
7330	Adamawa	Yola South	Makama 'A'	9.197647	12.642227
7331	Kano	Kibiya	Durba	11.558683	8.679331
7332	Kwara	Ifelodun	Omupo	8.246142	4.769887
7333	Abia	Arochukwu	Ikwun Ihechiowa	5.458607	7.855081
7334	Kebbi	Argungu	Tungar Zazzagawa/Rumbuki/Sarkawa	12.721046	4.404841
7335	Adamawa	Hong	Kwarhi	10.340359	13.105531
7336	Imo	Ohaji-Egbema	Obitti/Mgbishi	5.275338	6.818832
7337	Oyo	Ibadan South West	Ward 1 C2	7.375213	3.891910
7338	Borno	Mafa	Koshebe	12.036606	13.417479
7339	Anambra	Nnewi North	Otolo  III	5.979188	6.902700
7340	Kwara	Isin	Owu Isin	8.286312	5.013074
7341	Sokoto	Kebbe	Margai - A	12.170343	4.983319
7342	Kano	Karaye	Turawa	11.722180	8.029706
7343	Osun	Osogbo	Alagba	7.740934	4.581904
7344	Imo	Oru-West	Nempi/Elem	5.782492	6.916340
7345	Kebbi	Bagudo	Zagga/Kwasara	11.529483	4.139499
7346	Ondo	Akure North	Iluabo/Eleyewo/Bolorunduro	7.257259	5.329351
7347	Cross River	Yala	Wanikade	6.709656	8.776880
7348	Katsina	Batagarawa	Kayauki	12.988750	7.693588
7349	Borno	Marte	Alla  Lawanti	12.158396	14.006062
7350	Bauchi	Zaki	Alangawari / Kafin / Larabawa	11.928340	10.348479
7351	Kano	Gwale	Dandago	11.980658	8.504235
7352	Ondo	AkokoNorthWest	Erusu/Karamu/Ibaramu	7.604315	5.840863
7353	Akwa Ibom	Obot Akara	Ikot Abia II	5.195270	7.602185
7354	Rivers	Khana	Kaani	4.711036	7.353845
7355	Kogi	Ankpa	Ankpa Suburb I	7.349382	7.598761
7356	Osun	Boripe	Oke Aree	7.913226	4.735724
7357	Sokoto	Kware	Kware	13.208280	5.284293
7358	Osun	Ila	Oke Ede	7.996311	4.905010
7359	Kogi	Ogori Magongo	Eni	7.457270	6.188364
7360	Kano	Kunchi	Kunchi	12.499016	8.288601
7361	Imo	Oru-East	Amiri I	5.684414	6.939209
7362	Katsina	Sabuwa	Rafin Iwa	11.241264	7.037340
7363	Anambra	Orumba North	Ndiowu	6.057223	7.153576
7364	Kogi	Ofu	Ogbonicha	7.239692	7.239007
7365	Kaduna	Kajuru	Idon	10.137588	7.979071
7366	Osun	Ife North	Asipa/Akinlalu	7.319873	4.419720
7367	Benue	Ushongo	Mbagwaza	6.999300	9.180535
7368	Ogun	Ifo	Ifo I	6.811807	3.178151
7369	Kaduna	Zaria	Kufena	11.088720	7.663881
7370	Anambra	Ogbaru	Akili Ogidi/Obeagwe	5.754917	6.654826
7371	Kogi	Okene	Onyukoko	7.387728	6.416830
7372	Kebbi	Danko Wasagu	Yalmo/Shindi	11.614833	5.291813
7373	Gombe	Nafada	Birin Fulani East	11.056360	11.377725
7374	Edo	Owan East	Warrake	6.997434	6.177049
7375	Gombe	Kwami	Doho	10.473865	11.319577
7376	Rivers	Obio/Akpor	Rumueme (7A)	4.831979	6.970096
7377	Kano	Nasarawa	Gama	12.018423	8.498041
7378	Kogi	Lokoja	Eggan	8.578125	6.215310
7379	Kogi	Idah	Ede	7.066983	6.699451
7380	Kebbi	Suru	Giro	11.776240	4.211631
7381	Ebonyi	Ezza North	Omege Umuezeokoha	6.285036	7.985061
7382	Adamawa	Mayo-Belwa	Ribadu	9.064582	12.075515
7383	Rivers	Ahoada East	Ahoada III	5.061696	6.662158
7384	Osun	Ilesha East	Okesa	7.592289	4.763794
7385	Imo	Owerri North	Obibi-Uratta I	5.517100	7.067262
7386	Imo	Oguta	Mbala/Uba	5.570786	6.879367
7387	Ekiti	Oye	Ayegbaju	7.874809	5.341171
7388	Lagos	Ifako/Ijaye	Iju Isaga	6.685543	3.309548
7389	Lagos	Apapa	Gaskiya & Environs	6.471892	3.358749
7390	Bayelsa	Brass	Ewoama/Fantuo	4.367585	6.502175
7391	Osun	Ife North	Moro	7.415603	4.527348
7392	Zamfara	Talata-Mafara	Shiyar Kayaye/Matusgi	12.564287	6.132389
7393	Kano	Kumbotso	Kumbotso	11.876504	8.481639
7394	Imo	Obowo	Odenkume/Umuosochie	5.580142	7.334130
7395	Jigawa	Auyo	Gamsarka	12.319605	9.896504
7396	Akwa Ibom	Uyo	Oku I	5.017072	7.863865
7397	Rivers	Akukutor	Briggs I	4.711176	6.745721
7398	Ondo	Idanre	Irowo	7.143960	5.132911
7399	Federal Capital Territory	Kwali	Kwali Ward	8.827103	6.999258
7400	Kebbi	Ngaski	Kwakwaran	10.279524	4.650444
7401	Ebonyi	Afikpo South	Owutu	5.834246	7.843448
7402	Cross River	Yala	Ntrigom/Mfuma	6.553244	8.441304
7403	Katsina	Dutsin-M	Kutawa	12.398205	7.500131
7404	Cross River	Bakassi	Amoto	4.832782	8.617922
7405	Abia	Bende	Uzuakoli	5.590370	7.553736
7406	Ondo	Owo	Isuada/Ipenmen/Idasan/Obasooto	7.266952	5.596887
7407	Gombe	Nafada	Barwo / Nasarawo	11.193571	11.171027
7408	Borno	Mafa	Tamsu Ngamdua	11.814396	13.395101
7409	Bauchi	Kirfi	Beni "B"	10.434601	10.318654
7410	Federal Capital Territory	Kwali	Ashara	8.637784	6.838160
7411	Bauchi	Toro	Ribina	10.119801	9.081713
7412	Sokoto	Bodinga	Badau/Darhela	12.760419	5.197069
7413	Oyo	Oyo West	Pakoyi/Idode	7.860007	3.897611
7414	Kebbi	Maiyama	Maiyama	12.070563	4.366805
7415	Kano	Doguwa	Zainabi	10.879032	8.697134
7416	Anambra	Idemili South	Nnobi  III	6.065464	6.911528
7417	Benue	Katsina- Ala	Michihe	7.127353	9.468806
7418	Sokoto	Rabah	Yar Tsakuwa	12.817621	5.850535
7419	Lagos	Alimosho	Igando/Egan	6.555466	3.215004
7420	Katsina	Matazu	Sayaya	12.310185	7.614062
7421	Bauchi	Zaki	Bursali	12.405697	10.625100
7422	Ondo	Odigbo	Ajue	6.892514	4.825874
7423	Ebonyi	Ikwo	Inyimagu I	6.065891	8.157550
7424	Edo	Etsako West	Aviele	6.923832	6.253316
7425	Kogi	Ankpa	Enjema III	7.576137	7.609912
7426	Anambra	Dunukofia	Umunnachi  I	6.157739	6.907872
7427	Yobe	Borsari	Masaba	12.889719	11.211207
7428	Akwa Ibom	Oruk Anam	Ndot/Ikot Okoro III	4.863061	7.689665
7429	Jigawa	Kafin Hausa	Kazalewa	12.164637	9.859531
7430	Imo	Oru-East	Amiri II	5.673835	6.913544
7431	Plateau	Qua'anpa	Kurgwi	8.769661	9.245357
7432	Kano	Ajingi	Kunkurawa	11.924595	9.080328
7433	Ebonyi	Ishielu	Ezillo I	6.485756	7.861027
7434	Kano	Dala	Kofar Ruwa	12.012483	8.461717
7435	Benue	Vandeikya	Mbayongo	6.702059	9.037653
7436	Borno	Biu	Gur	10.843859	12.313506
7437	Kano	Takai	Kachako	11.531888	9.293753
7438	Kano	Nasarawa	Tudun Murtala	12.010606	8.510768
7439	Niger	Agaie	Ekossa	9.022893	6.281012
7440	Adamawa	Yola North	Jambutu	9.257687	12.460127
7441	Ogun	Obafemi-Owode	Obafemi	6.978383	3.484357
7442	Nassarawa	Karu	Gurku/Kabusu	9.172306	7.654612
7443	Akwa Ibom	Esit Eket	Ebighi Okpono	4.669797	8.064338
7444	Kaduna	Jaba	Nok	9.480081	8.019684
7445	Jigawa	Hadejia	Matsaro	12.451082	10.017571
7446	Jigawa	Ringim	Sintilmawa	12.060289	9.134421
7447	Plateau	Jos South	Kuru 'A'	9.653230	8.808795
7448	Sokoto	Bodinga	Bagarawa	12.868659	5.243636
7449	Kano	Minjibir	Sarbi	12.259766	8.663387
7450	Oyo	Kajola	Isia	8.019990	3.408551
7451	Jigawa	Kafin Hausa	Balangu	12.071409	10.121171
7452	Edo	Etsako West	Uzairue South East	7.084562	6.353217
7453	Ebonyi	Ohaukwu	Effium  II	6.616045	8.030149
7454	Katsina	Zango	Kanda	12.958913	8.565195
7455	Ogun	Abeokuta North	Imala-Idiemi	7.371417	3.062857
7456	Imo	Ngor-Okpala	Ngor/Ihitte/Umukabia	5.351469	7.190864
7457	Niger	Agwara	Rofia	10.722524	4.696343
7458	Taraba	Karim-Lamido	Jen Kaigama	9.516130	11.433077
7459	Enugu	Oji-River	Inyi I	6.104752	7.298642
7460	Imo	Isiala Mbano	Ugiri/Oka	5.631523	7.162910
7461	Lagos	Surulere	Ijeshatedo	6.506103	3.316356
7462	Benue	Ushongo	Mbayegh	6.941305	9.239325
7463	Osun	Ifelodun	Isale/Oke Afo	7.910929	4.638031
7464	Sokoto	Kware	G/ Modibbo/ G. Akwara	13.144555	5.314098
7465	Federal Capital Territory	Municipal	Karu	9.004322	7.518129
7466	Enugu	Nkanu West	Akugbo IV	6.362840	7.556936
7467	Taraba	Bali	Suntai	7.750778	10.604951
7468	Kaduna	Giwa	Kadage	11.069916	7.507459
7469	Gombe	Funakaye	Bajoga  West	10.849765	11.334789
7470	Taraba	Wukari	Tsokundi	7.900562	9.948658
7471	Imo	Owerri West	Eziobodo	5.341241	7.006007
7472	Nassarawa	Nasarawa	Tunga/Bakono	8.134988	7.497586
7473	Oyo	Ibarapa Central	Iberekodo/Agbooro/Ita Baale	7.480726	3.325870
7474	Abia	Bende	Item C	5.805716	7.656796
7475	Borno	Kukawa	Dogoshi	12.841141	13.694483
7476	Edo	Etsako East	Okpekpe	7.208683	6.568692
7477	Osun	Atakumosa East	Iperindo	7.455711	4.827820
7478	Katsina	Zango	Gwamba	12.934153	8.619037
7479	Sokoto	Kware	Bankanu/ R, Kade	13.198082	5.215915
7480	Kebbi	Maiyama	Mungadi/Botoro	12.088371	4.175738
7481	Plateau	Barkin Ladi	Heipang	9.645350	8.883099
7482	Zamfara	Talata-Mafara	Jangebe	12.216685	6.081185
7483	Jigawa	Sule Tankarkar	Jeke	12.789493	9.073044
7484	Anambra	Njikoka	Nimo  II	6.165411	6.963609
7485	Jigawa	Gwiwa	Dabi	12.702232	8.175217
7486	Kano	Gabasawa	Tarauni	12.088290	8.917188
7487	Kano	Tundun Wada	Baburi	11.158693	8.692086
7488	Akwa Ibom	Onna	Nung idem II	4.640321	7.837230
7489	Kano	Nasarawa	Hotoro North	11.990104	8.523283
7490	Kebbi	Yauri	Chulu/Koma	10.718644	4.757533
7491	Ogun	Odogbolu	Ala/Igbile	6.709751	3.886463
7492	Borno	Guzamala	Kingarwa	12.618559	13.479672
7493	Yobe	Jakusko	Gorgoram	12.584078	10.661106
7494	Enugu	Nkanu East	Akpawfu/Isienu/Amangunze	6.354409	7.627109
7495	Anambra	Njikoka	Abagana  II	6.188194	6.959593
7496	Kogi	Adavi	Ogaminana	7.564094	6.301694
7497	Ogun	Ijebu North-East	Atan/Imuku	6.882521	4.010212
7498	Delta	Okpe	Oha  II	5.638244	5.813393
7499	Imo	Nwangele	Kara-Na-Orlu	5.712722	7.151566
7500	Borno	Maiduguri	Gamboru Liberty	11.859081	13.234522
7501	Akwa Ibom	Mbo	Enwang I	4.641450	8.242280
7502	Niger	Gurara	Tufa	9.270612	6.878255
7503	Ogun	Ifo	Ajuwon/Akute	6.663703	3.410668
7504	Niger	Bida	Ceniyan	9.105655	6.000589
7505	Osun	Osogbo	Jagun 'A'	7.743077	4.585387
7506	Adamawa	Jada	Leko	8.689054	12.566426
7507	Kano	Dala	Kantudu	11.994080	8.465976
7508	Imo	Oru-East	Awo-Omamma II	5.640330	6.961474
7509	Jigawa	Gagarawa	Garin Chiroma	12.381555	9.530820
7510	Delta	Patani	Bolou - Angiama	5.192038	6.121468
7511	Lagos	Eti-Osa	Ikoyi I	6.456312	3.423069
7512	Kogi	Dekina	Dekina Town	7.607888	7.000715
7513	Delta	Okpe	Mereje  I	5.672988	5.702951
7514	Akwa Ibom	Essien Udim	Afaha	5.121273	7.640003
7515	Bauchi	Warji	Baima  South/East	11.061491	9.692063
7516	Kaduna	Kajuru	Tantatu	10.220744	7.670119
7517	Federal Capital Territory	Kuje	Rubochi	8.475723	7.093437
7518	Oyo	Orelope	Igi Isubu	8.858050	3.707886
7519	Kebbi	Birnin Kebbi	Nassarawa II	12.428172	4.182849
7520	Rivers	Tai	Ward II (Kpite)	4.714316	7.296206
7521	Katsina	Bindawa	Kamri	12.649730	7.837494
7522	Rivers	Okrika	Okrika  I	4.705996	7.129898
7523	Nassarawa	Wamba	Nakere	8.967268	8.536406
7524	Kebbi	Argungu	Galadima	12.756491	4.504217
7525	Zamfara	Birnin Magaji	Danfami Sabon Birini	12.584319	6.969234
7526	Benue	Obi	Obarike	6.980265	8.300153
7527	Kaduna	Zangon Kataf	Zaman Dabo	9.768248	8.467314
7528	Enugu	Nkanu West	Akpugo II	6.333080	7.571715
7529	Kano	Warawa	'Yangizo	11.940544	8.776956
7531	Bauchi	Ningi	Tiffi / Guda	11.037267	9.587785
7532	Plateau	Pankshin	Pankshin Central	9.328002	9.388280
7533	Ebonyi	Ezza North	Amuda / Amawula	6.308526	7.923272
7534	Edo	Owan West	Ozalla	6.799660	5.976574
7535	Kwara	Moro	Jebba	9.073631	4.792062
7536	Federal Capital Territory	Kuje	Gwargwada	8.531565	7.074269
7537	Kaduna	Sanga	Ayu	9.188286	8.571272
7538	Kano	Bebeji	Damau	11.685084	8.275122
7539	Kaduna	Kachia	Bishini	9.603720	7.368414
7540	Edo	Etsako East	Wanno I	7.144667	6.597797
7541	Benue	Makurdi	Central/South Mission	7.734612	8.522706
7542	Ogun	Egbado North	Ibese	6.971329	2.978393
7543	Gombe	Dukku	Jamari	11.029228	10.965503
7544	Akwa Ibom	Ibiono Ibom	Ibiono Southern I	5.087812	7.861355
7545	Osun	Ife North	Yakoyo	7.408442	4.458130
7546	Benue	Oju	Adokpa	6.723008	8.296611
7547	Borno	Maiduguri	Bulablin	11.840390	13.220367
7548	Delta	Ughelli South	Ewu I	5.341952	5.953680
7549	Adamawa	Numan	Bolki	9.351241	11.790416
7550	Sokoto	Gada	Kaffe	13.691838	5.722958
7551	Jigawa	Buji	Madabe	11.700521	9.738407
7552	Delta	EthiopeE	Agbon  I	5.662428	5.968011
7553	Jigawa	Buji	Falageri	11.531134	9.718311
7554	Kano	Bebeji	Bebeji	11.665954	8.255354
7555	Borno	Chibok	Chibok Garu	10.849803	12.859191
7556	Taraba	Gassol	Sendirde	8.536666	10.299350
7557	Edo	Etsako Central	South Uneme I	6.832474	6.545162
7558	Taraba	Jalingo	Barade	8.884124	11.419512
7559	Anambra	Njikoka	Enugwu Ukwu  III	6.179073	6.982079
7560	Kaduna	Kubau	Zabi	10.725961	8.098067
7561	Anambra	Ekwusigo	Ihembosi/Anaubahu	5.915525	6.820731
7562	Akwa Ibom	Etinan	Northern Iman I	4.943383	7.832839
7563	Taraba	Sardauna	Magu	6.906538	10.977369
7564	Benue	Vandeikya	Mbakyaha	6.831652	9.139068
7565	Oyo	Itesiwaju	Otu I	8.204865	3.419543
7566	Lagos	Mushin	Ilupeju Industrial Estate	6.570786	3.352364
7567	Adamawa	Mubi North	Mijilu	10.434483	13.445848
7568	Plateau	Mangu	Mangun	9.211401	9.157189
7569	Gombe	Nafada	Birin Bolewa	10.944903	11.206657
7570	Ondo	Akure North	Moferere	7.411787	5.237331
7571	Plateau	Jos North	Naraguta 'A'	9.923704	8.899621
7572	Enugu	Igbo-eze North	Ette Central	7.102492	7.442324
7573	Bauchi	Shira	Shira	11.425535	10.124253
7574	Kano	Gabasawa	Gabasawa	12.164172	8.888192
7575	Plateau	Kanam	Dugub	9.742695	9.946832
7576	Ondo	Akoko South-East	Ipe II	7.416958	5.839234
7577	Borno	Monguno	Mofio	12.537846	13.446454
7578	Kebbi	Arewa	Sarka/Dantsoho	12.952340	4.405262
7579	Sokoto	Yabo	Binji	12.813668	4.867938
7580	Ogun	Odogbolu	Ososa	6.711384	3.820220
7581	Gombe	Shomgom	Boh	9.775690	11.282895
7582	Rivers	Etche	Egbu	5.167030	6.933972
7583	Cross River	Calabar South	Five (5)	4.908642	8.253355
7584	Osun	Irewole	Ikire 'B'	7.369900	4.184433
7585	Niger	Katcha	Gbakogi	8.875771	6.169343
7586	Kebbi	Kalgo	Kuka	12.332024	3.987150
7587	Anambra	Idemili North	Ogidi  I	6.116018	6.877128
7588	Kwara	Ilorin South	Akanbi III	8.399693	4.713647
7589	Yobe	Karasuwa	Jaji Maji	12.914105	10.816857
7590	Lagos	Agege	Keke	6.639992	3.323360
7591	Benue	Katsina- Ala	Yooyo	7.195242	9.640256
7592	Cross River	Calabar Municipality	One	4.942556	8.303267
7593	Lagos	Amuwo Odofin	Ibeshe	6.417800	3.272976
7594	Kaduna	Kaura	Fada	9.619394	8.391417
7595	Lagos	Epe	Agbowa	6.649523	3.712063
7596	Ekiti	Emure	Odo Emure III	7.480247	5.520807
7597	Oyo	Ibadan North West	Ward 6 NW3 (Part I)	7.388166	3.890796
7598	Yobe	Gujba	Dadingel	11.577848	12.227034
7599	Ekiti	Ekiti East	Ilasa I	7.709653	5.627069
7600	Osun	IfeCentral	Ilare IV	7.439156	4.610399
7601	Rivers	Gokana	Bodo I	4.637549	7.270035
7602	Edo	Esan West	Illeh/Eko-Ine	6.757106	6.170164
7603	Zamfara	Shinkafi	Badarawa	13.023301	6.502598
7604	Ebonyi	Afikpo North	Amata-Akpoha	5.949613	7.946504
7605	Ekiti	Ijero	Ijero Ward 'A'	7.813404	5.098099
7606	Benue	Gwer West	Mbachohon	7.726296	8.184670
7607	Rivers	Emuoha	Odegu  I	4.937392	6.779468
7608	Delta	Ukwuani	Ezionum	5.779502	6.246739
7609	Ondo	Akure South	Oke aro/Uro I	7.201261	5.152716
7610	Katsina	Safana	Runka 'A'	12.465422	7.214039
7611	Sokoto	Tambawal	Sanyinna	12.658772	4.908700
7612	Adamawa	Madagali	Gulak	10.875983	13.456946
7613	Yobe	Yunusari	Mairari	13.079563	11.989502
7614	Katsina	Faskari	Tafoki	11.668579	7.288980
7615	Lagos	Surulere	Adeniran/Ogunsanya	6.506417	3.346292
7616	Nassarawa	Keana	Obene	8.107989	8.869693
7617	Plateau	Shendam	Kurungbau (A)	8.867360	9.623561
7618	Kwara	Ifelodun	Oke-Ode II	8.601263	5.359393
7619	Taraba	Ussa	Jenuwa	6.974432	9.934415
7620	Kebbi	Sakaba	Adai	11.122457	5.506576
7621	Gombe	Gombe	Pantami	10.299117	11.240329
7622	Ondo	Akoko North-East	Isowopo II	7.587401	5.946415
7623	Niger	Agwara	Mago	10.922679	4.489441
7624	Jigawa	Sule Tankarkar	Danladi	12.501763	9.224935
7625	Ogun	Abeokuta South	Sodeke/Sale-Ijeun I	7.153004	3.338732
7626	Akwa Ibom	Oron	Oron Urban V	4.800051	8.252313
7627	Delta	IkaNorth	Idumuesah	6.172747	6.240092
7628	Abia	Isuikwuato	Ikeagha II	5.816915	7.441274
7629	Osun	Ayedaade	Gbongan Rural	7.449404	4.331000
7630	Federal Capital Territory	Municipal	Kabusa	8.900497	7.366883
7631	Enugu	Uzo-Uwani	Ojo	6.756913	6.949316
7632	Osun	Orolu	Olufon Orolu 'F'	7.865062	4.445993
7633	Imo	Ideato South	Amanator/Umueshi	5.769264	7.186372
7634	Taraba	Bali	Takalafiya	8.003253	10.584932
7635	Jigawa	Kiyawa	Katuka\r\nKiyawa\r\n	11.824875	9.589707
7636	Abia	Isuikwuato	Umuanyi / Absu	5.820024	7.407182
7637	Rivers	Bonny	Ward II Court/ Ada Allison	4.449125	7.169968
7638	Bayelsa	Nembe	Bassambiri II	4.568737	6.390535
7639	Ogun	Ijebu North	Oru/Awa/Ilaporu	6.938336	3.956759
7640	Kebbi	Koko/Bes	Takware	11.305023	4.489971
7641	Enugu	Nkanu East	Ugbawka II	6.272821	7.639691
7642	Rivers	Opobo/Nkoro	Nkoro I	4.577090	7.444349
7643	Zamfara	Anka	Waramu	12.224749	5.929206
7644	Rivers	Opobo/Nkoro	Ukonu	4.527964	7.529612
7645	Adamawa	Madagali	Pallam	10.753342	13.540742
7646	Niger	Bosso	Shata	9.737496	6.526378
7647	Osun	Irepodun	Olobu 'D'	7.826863	4.489244
7648	Anambra	Anambra East	Nsugbe I	6.269455	6.836778
7649	Yobe	Potiskum	Dogo Tebo	11.681901	11.109252
7650	Anambra	Orumba North	Amaetiti	6.138005	7.132476
7651	Osun	Odo Otin	Osolo/Oparin/Ola	8.046449	4.761514
7652	Niger	Lapai	Gurdi/Zago	8.780752	6.637258
7653	Niger	Lavun	Gaba	8.923541	6.081587
7654	Kano	Tarauni	Unguwar Gano	11.936661	8.524037
7655	Borno	Kaga	Wassaram	11.624156	12.408289
7656	Lagos	Ibeju/Lekki	Ibeju i	6.520882	3.842522
7657	Oyo	Surulere	Iwofin	8.158193	4.433270
7658	Lagos	Shomolu	Gbagada Phase I Obanikoro/Pedro	6.566560	3.369574
7659	Akwa Ibom	Mkpat Enin	Ukpum Minya I	4.708124	7.700042
7660	Taraba	Ibi	Ibi Rimi Uku II	8.100526	9.771362
7661	Benue	Gboko	Igyorov	7.303707	9.145049
7662	Akwa Ibom	Oron	Oron Urban III	4.820401	8.238051
7663	Oyo	Egbeda	Olodo III	7.406424	3.995115
7664	Gombe	Yalmatu / Deba	Jagali South	10.222231	11.634318
7665	Bauchi	Alkaleri	Birin/ Gigara/ Yankari	9.924446	10.051375
7666	Oyo	Saki West	Ajegunle	8.487533	3.333367
7667	Katsina	Baure	Babban Mutum	12.824257	8.956806
7668	Cross River	Calabar Municipality	Seven	5.001649	8.284232
7669	Yobe	Gulani	Bularafa	11.111445	11.815676
7670	Delta	IkaSouth	Boji - Boji II	6.262646	6.198564
7671	Bauchi	Gamawa	Raga	11.781350	10.589327
7672	Cross River	Yakurr	Ijiman	5.793423	8.104991
7673	Sokoto	Tambawal	Jabo/Kagara	12.362427	5.105126
7674	Anambra	Orumba South	Ogbunka  I	5.999353	7.282083
7675	Osun	Obokun	Imesi-Ile	7.827095	4.839134
7676	Nassarawa	Nassarawa Egon	Lambaga/Arikpa	8.652581	8.430682
7677	Enugu	Aninri	Nnenwe II	6.108310	7.548137
7678	Jigawa	Miga	Tsakuwawa	12.158460	9.603704
7679	Enugu	Aninri	Oduma III	6.090586	7.618022
7680	Federal Capital Territory	Kuje	Chibiri	8.886010	7.090009
7681	Plateau	Bokkos	Manguna	9.276173	8.747677
7682	Ogun	Abeokuta South	Erunbe/Oke Ijeun	7.142496	3.355019
7683	Borno	Jere	Gomari	11.784008	13.162729
7684	Borno	Mobbar	Bogum	13.156272	12.699890
7685	Yobe	Fune	Abakire / Ngenlshengele / Shamka	11.509815	11.634515
7686	Akwa Ibom	Ikot Ekpene	Ikot Ekpene XI	5.238984	7.682093
7687	Lagos	Kosofe	Agboyi I	6.599093	3.437596
7688	Anambra	Aguata	Umuchu II	5.924782	7.109869
7689	Anambra	Awka South	Awka  III	6.215049	7.075311
7690	Osun	Ife East	Moore	7.416222	4.633164
7691	Kaduna	Jaba	Dura/Bitaro	9.402513	7.956846
7692	Osun	Iwo	Oke-adan  III	7.664085	4.176141
7693	Lagos	Oshodi/Isolo	Oke-Afa/Ejigbo	6.557639	3.291087
7694	Akwa Ibom	Mkpat Enin	Ikpa Ibom II	4.657336	7.779840
7695	Rivers	Degema	Bakana  IV	4.646795	6.965329
7696	Plateau	Jos East	Fobur    'B'	9.882609	8.986177
7697	Lagos	Lagos Island	Epetedo	6.463258	3.405755
7698	Katsina	Dandume	Tumburkai A	11.294073	7.229975
7699	Sokoto	Rabah	Kurya	13.067032	5.685492
7700	Delta	Ukwuani	Umutu	5.913741	6.231957
7701	Nassarawa	Toto	Katakpa	8.434760	7.372248
7702	Edo	Esan South East	Ugboha	6.736770	6.458870
7703	Kaduna	Lere	Abadawa	10.354542	8.736872
7704	Oyo	Ogbomosho South	Ijeru II	8.096475	4.241108
7705	Enugu	Isi-Uzo	Ehamufu III	6.711793	7.816487
7706	Nassarawa	Keffi	Sabon Gari	8.823383	7.813144
7707	Jigawa	Hadejia	Gagulmari	12.455815	10.041087
7708	Imo	Ngor-Okpala	Eziama/Okpala	5.262359	7.218207
7709	Ekiti	Ekiti West	Erijiyan I	7.569928	5.010943
7710	Lagos	Ajeromi/Ifelodun	Mosafejo	6.478289	3.329858
7711	Taraba	Bali	Gang Mata	8.512318	11.316114
7712	Osun	Irewole	Ikire 'K'	7.358437	4.290782
7713	Bauchi	Alkaleri	Dan kungibar	9.901802	10.189186
7714	Enugu	Isi-Uzo	Ikem II	6.815289	7.752681
7715	Anambra	Dunukofia	Ifitedunu  I	6.178337	6.925547
7716	Sokoto	Illela	Darne/ Tsolawo	13.532284	5.486021
7717	Delta	Ughelli North	Ughelli  II	5.505631	6.013393
7718	Kebbi	Ngaski	Birnin Yauri	10.799571	4.852535
7719	Yobe	Yunusari	Daratoshia	13.190351	11.817225
7720	Delta	Ndokwa East	Okpai/Utchi/Beneku	5.766205	6.579355
7721	Ebonyi	Abakalik	Amagu Unuhu	6.248739	8.134808
7722	Bauchi	Toro	Tama	10.658189	8.961182
7723	Bauchi	Katagum	Nasarawa Bakin Kasuwa	11.671478	10.192659
7724	Katsina	Faskari	Yankara	11.758055	7.082518
7725	Kebbi	Dandi	Dolekaina	11.698548	3.636280
7726	Anambra	Idemili North	Ogidi  II	6.127639	6.899795
7727	Kaduna	Kachia	Katari	9.654553	7.432040
7728	Katsina	Jibia	Riko	13.130185	7.500090
7729	Akwa Ibom	Udung Uko	Udung Uko VIII	4.725848	8.210418
7730	Bauchi	Shira	Kilbori	11.493940	10.186457
7731	Ebonyi	Ebonyi	Agalegu	6.328166	8.099169
7732	Imo	Ahiazu-Mbaise	Obohia/Ekwereazu	5.537364	7.242940
7733	Delta	IkaNorth	Owa IV	6.230552	6.193863
7734	Borno	Mafa	Mujigine	12.083512	13.897047
7735	Kwara	Oyun	Erin-Ile North	8.078207	4.716754
7736	Enugu	Oji-River	Ugwuoba III	6.245223	7.201248
7737	Anambra	Awka South	Amawbia  II	6.194517	7.048760
7738	Adamawa	Yola South	Namtari	9.160842	12.573373
7739	Kano	Gwale	Dorayi	11.957556	8.453274
7740	Oyo	Ogo-Oluwa	Lagbedu	7.912847	4.170332
7741	Kano	Sumaila	Gani	11.346769	8.803783
7742	Jigawa	Gagarawa	Maiaduwa	12.455160	9.589104
7743	Lagos	Epe	Odomola	6.598239	4.024295
7744	Sokoto	Shagari	Gangam	12.555423	5.092302
7745	Ogun	Odogbolu	Ilado	6.783316	3.921704
7746	Rivers	Ogba/Egbema/Andoni	Omoku Town IV (Usomini)	5.335212	6.635763
7747	Bauchi	Gamawa	Tumbi	12.297078	10.588656
7748	Taraba	Ardo-Kola	Jauro Yinu	8.926056	11.255851
7749	Kebbi	Fakai	Mahuta	11.558787	4.937490
7750	Kaduna	Kauru	Dawaki	10.458541	8.069735
7751	Akwa Ibom	Onna	Awa III	4.664173	7.854792
7752	Zamfara	Gusau	Mayana	12.131334	6.630020
7753	Borno	Kaga	Dogoma / Jalori	11.473727	12.467381
7754	Niger	Rijau	Genu	10.838173	5.161478
7755	Ekiti	Ekiti South West	Ilawe VII	7.494242	5.133534
7756	Nassarawa	Nasarawa	Akum	8.162197	7.826751
7757	Yobe	Karasuwa	Karauswa Garu Guna	13.058795	10.752807
7758	Taraba	Donga	Bikadarko	7.899570	10.228845
7759	Kano	Bebeji	Anadariya	11.460024	8.247799
7760	Enugu	Udi	Affa/Oghu/Ikono	6.567262	7.230638
7761	Abia	Umuahia South	Ubakala  'A'	5.443940	7.398363
7762	Anambra	Anambra West	Olumbanasa -ode	6.443912	6.702959
7763	Ogun	Remo North	Akaka	7.039357	3.740028
7764	Ogun	Abeokuta North	Ilugun/Iberekodo	7.306160	3.162744
7765	Abia	Osisioma	Umunneise	5.169600	7.353443
7766	Bauchi	Jama'are	Jama'are "B"	11.671565	9.972091
7767	Ebonyi	Ivo	Akaeze Ishiagu	5.901434	7.711107
7768	Taraba	Gashaka	Gulumjina	7.566397	11.286713
7769	Borno	Askira/Uba	Ngulde	10.689928	12.582075
7770	Abia	Ukwa West	Asa North	5.064949	7.260037
7771	Sokoto	Gudu	Karfen Sarki	13.201539	4.643422
7772	Imo	Ideato North	Izuogu II	5.792750	7.201948
7773	Benue	Konshisha	Mbavoa	6.930071	8.749085
7774	Yobe	Damaturu	Murfa Kalam	11.673225	11.874929
7775	Kebbi	Maiyama	Sambawa/Mayalo	12.210987	4.284407
7776	Taraba	Karim-Lamido	Karim "A"	9.255171	11.156166
7777	Plateau	Langtang North	Kuffen	9.080193	9.772376
7778	Benue	Kwande	Mbadura	6.611207	9.604075
7779	Niger	Katcha	Bakeko	8.942978	6.221076
7780	Kwara	Pategi	Pategi I	8.663582	5.792653
7781	Lagos	Ifako/Ijaye	Ijaiye/Ojokoro	6.683330	3.291541
7782	Kaduna	Makarfi	Makarfi	11.363820	7.900723
7783	Abia	Arochukwu	Ovukwu	5.478669	7.792576
7784	Delta	IkaNorth	Mbiri	6.328040	6.277153
7785	Gombe	Kwami	Kwami	10.404071	11.244552
7786	Benue	Oturkpo	Adoka-Haje	7.457136	8.056309
7787	Sokoto	Tambawal	Bakaya/Sabon Birni	12.131251	4.632532
7788	Akwa Ibom	Nsit Ibom	Asang III	4.922332	7.876632
7789	Benue	Guma	Mbabai	7.896140	8.690082
7790	Rivers	Asari-Toru	Buguma  North East	4.739478	6.862643
7791	Kwara	Ifelodun	Igbaja I	8.397882	4.845219
7792	Lagos	Lagos Mainland	Olaleye Village	6.493013	3.361604
7793	Anambra	Nnewi South	Ukpor VI	5.906580	6.899231
7794	Sokoto	Tureta	Kwarare	12.324231	5.454946
7795	Katsina	Danmusa	Dan Musa B	12.289649	7.326957
7796	Benue	Buruku	Mbayaka	7.268203	9.263410
7797	Anambra	Orumba North	Ndikelionwu	6.091701	7.131957
7798	Kogi	Koton-Karfe	Chikara North	8.375197	6.905958
7799	Anambra	Orumba South	Eziagu	5.999048	7.237176
7800	Katsina	Bindawa	Baure	12.781729	7.859098
7801	Bauchi	Tafawa-Balewa	Lere North	9.674952	9.333216
7802	Rivers	Etche	Mba	5.101887	7.062883
7803	Edo	Etsako East	Okpella I	7.247126	6.310706
7804	Delta	Burutu	Tamigbe	5.177491	5.726012
7805	Plateau	Shendam	Poeship	8.811849	9.425545
7806	Anambra	Oyi	Awkuzu  I	6.214464	6.912876
7807	Rivers	Ahoada East	Ahoada I	5.071653	6.669961
7808	Sokoto	Illela	Darna/ Sabon Gari	13.591062	5.425794
7809	Oyo	Oyo West	Iyaji	7.849126	3.933996
7810	Imo	Isu	Amandugba II	5.641745	7.064147
7811	Osun	Ife North	Ipetumodu  II	7.364797	4.469841
7812	Enugu	Enugu East	Mbuluowehe	6.539994	7.472818
7813	Zamfara	Anka	Galadima	12.247603	5.984058
7814	Rivers	Abua/Odu	Akani	4.761724	6.471557
7815	Niger	Agwara	Papiri	10.595199	4.432747
7816	Anambra	Aguata	Oraeri	6.021409	7.011214
7817	Taraba	Kurmi	Nyido/Tosso	7.474172	10.754572
7818	Kebbi	Koko/Bes	Illela/S/Gari	11.443783	4.529569
7819	Akwa Ibom	Nsit Ibom	Asang II	4.949445	7.851699
7820	Ebonyi	Abakalik	Izzi Unuhu	6.294335	8.101589
7821	Oyo	Ona-Ara	Ojoku/Ajia	7.334060	4.038231
7822	Kogi	Ofu	Iboko/Efakwu	7.285384	7.097031
7823	Rivers	Eleme	Onne	4.724443	7.168636
7824	Kaduna	Kachia	Gumel	9.792387	7.967607
7825	Oyo	Iseyin	Isalu II	8.020187	3.612364
7826	Katsina	Safana	Baure 'B'	12.575410	7.156262
7827	Katsina	Ingawa	Bareruwa/Ruruma	12.587983	8.198623
7828	Niger	Chanchaga	Tudun Wada North	9.594019	6.549814
7829	Katsina	Kankara	Pauwa A&B	12.018161	7.368461
7830	Kwara	Oyun	Ipee	8.165043	4.747924
7831	Taraba	Kurmi	Njuwande	7.167051	10.902166
7832	Katsina	Mani	Bagiwa	12.889663	7.880810
7833	Rivers	Gokana	Bodo III	4.624050	7.264962
7834	Nassarawa	Akwanga	Andaha	9.070395	8.394064
7835	Nassarawa	Toto	Dausu	8.421401	7.177245
7836	Imo	Ehime-Mbano	Umueze II/Umueleke	5.608767	7.250287
7837	Oyo	Ido	Apete/Ayegun/Awotan	7.452541	3.840407
7838	Edo	Igueben	Idigun/ Idumedo	6.623189	6.266957
7839	Kogi	Olamaboro	Olamaboro V	7.231930	7.403132
7840	Adamawa	Fufore	Fufore	9.241196	12.745709
7841	Abia	Arochukwu	Ohafor II	5.606860	7.680463
7842	Kano	Kura	Kura	11.740042	8.412020
7843	Benue	Gwer West	Mbapa	7.668152	8.096315
7844	Kano	Sumaila	Rimi	11.340493	8.978116
7845	Ondo	Akoko South-West	Oka iv/Owake/Ebo/Ayegunle	7.422028	5.756019
7846	Kogi	Omala	Ogodu	7.610152	7.456714
7847	Yobe	Machina	Machina-Kwari	13.154788	10.034213
7848	Plateau	Kanam	Gumsher	9.322373	9.798230
7849	Niger	Chanchaga	Nassarawa 'A'	9.612514	6.527531
7850	Jigawa	Birnin Kudu	Lafiya	11.368681	9.404507
7851	Osun	Irepodun	Elerin 'D'	7.822056	4.494885
7852	Katsina	Kaita	Yandaki	13.083861	7.599628
7853	Rivers	Ogba/Egbema/Andoni	Egbema II	5.429453	6.734756
7854	Cross River	Yakurr	Ajere	5.872934	8.080840
7855	Akwa Ibom	Ibiono Ibom	Ibiono Western II	5.141745	7.853236
7856	Plateau	Riyom	Riyom	9.612866	8.809888
7857	Kwara	Irepodun	Oro II	8.233129	4.864962
7858	Benue	Ushongo	Mbaaka	7.117894	8.887197
7859	Zamfara	Maradun	Faru / Magami	12.857205	6.332601
7860	Borno	Marte	Mawulli	12.403389	14.065774
7861	Kano	Dambatta	Sansan	12.436137	8.657707
7862	Katsina	Bindawa	Gaiwa	12.627591	7.876890
7863	Delta	Oshimili North	Ebu	6.481030	6.626563
7864	Taraba	Yorro	Pupule II	8.989230	11.616323
7865	Ogun	Ipokia	Ajegunle	6.820444	2.753342
7866	Enugu	Igbo-eze North	Essodo II	7.047625	7.428910
7867	Akwa Ibom	Ibeno	Ibeno VII	4.563941	7.966376
7868	Delta	AniochaS	Ejeme	6.054908	6.353293
7869	Benue	Gwer West	Mbanyamshi	7.661294	8.373431
7870	Bauchi	Dass	Bundot	10.007664	9.537728
7871	Abia	Bende	Itumbauzo	5.468661	7.615860
7872	Akwa Ibom	Nsit Ubium	Ubium North II	4.762616	7.983725
7873	Akwa Ibom	Ukanafun	Southern Ukanafun II	4.905974	7.568025
7874	Taraba	Donga	Akate	7.689489	9.947386
7875	Sokoto	Kebbe	Ungushi	11.997391	4.782915
7876	Benue	Gboko	Mbatser	7.330691	8.916052
7877	Benue	Kwande	Mbagba/Mbaikyan	6.661098	9.415878
7878	Ondo	Ifedore	Ijare II	7.402540	5.166918
7879	Borno	Gwoza	Hambagda/ Liman Kara/ New Settlement	11.008016	13.591322
7880	Kano	Tofa	Dindere	12.077930	8.231896
7881	Edo	Orhionmw	Evboesi	5.954897	6.076784
7882	Yobe	Geidam	Dejina/Fukurti	12.888021	12.299021
7883	Abia	Umuahia South	Ohiaocha	5.453017	7.493387
7884	Kano	Shanono	Shakogi	12.028633	8.030779
7885	Oyo	Irepo	Laha/Ajana	8.954177	4.016704
7886	Anambra	Onitsha South	Fegge VI	6.070386	6.749486
7887	Anambra	Ekwusigo	Oraifite  II	6.022986	6.839600
7888	Taraba	Karim-Lamido	Bachama	9.501585	10.935276
7889	Plateau	Bassa	Buhit	9.979462	8.771133
7890	Jigawa	Roni	Dansure	12.616318	8.322805
7891	Oyo	Kajola	Iba-Ogan	8.057151	3.391539
7892	Borno	Konduga	Dalori / Wanori	11.791974	13.330721
7893	Osun	Iwo	Oke-Adan  II	7.637278	4.179852
7894	Osun	Atakumosa West	Ifewara I	7.353915	4.717859
7895	Borno	Dikwa	Mudu / Kaza	11.924638	14.290852
7896	Imo	Okigwe	Okigwe I	5.797724	7.341534
7897	Katsina	Katsina (K)	Kangiwa	13.038283	7.614367
7898	Oyo	Irepo	Ajagunna	8.993271	3.850968
7899	Lagos	Oshodi/Isolo	Oshodi/Bolade	6.577144	3.326299
7900	Ogun	Ikenne	Iperu	6.885106	3.670165
7901	Ekiti	Ijero	Ipoti Ward 'B'	7.886209	5.064202
7902	Delta	IkaSouth	Ihuiyase II	6.206877	6.131263
7903	Anambra	Njikoka	Enugwu Ukwu  II	6.167927	6.978895
7904	Oyo	Oyo West	Akeetan	7.838120	3.933748
7905	Ondo	AkokoNorthWest	Oke-irun/Surulere	7.565406	5.659908
7906	Ebonyi	Izzi	Ezza Inyimagu Ndiagu	6.572533	8.246039
7907	Benue	Okpokwu	Ichama II	6.911390	7.784750
7908	Plateau	Bassa	Kimakpa	9.769594	8.676785
7909	Taraba	Wukari	Bantaje	8.088109	10.153725
7910	Kano	Tarauni	Unguwa  Uku	11.950408	8.525398
7911	Lagos	Lagos Island	Oko-faji	6.454788	3.393628
7912	Rivers	Etche	Ozuzu	5.088610	6.961973
7913	Ondo	Akoko South-West	Oka I Ibaka / Sabo	7.448545	5.806191
7914	Akwa Ibom	Udung Uko	Udung Uko VII	4.728182	8.231118
7915	Ogun	Imeko-Afon	Idi Ayin	7.620838	2.777069
7916	Niger	Borgu	New Bussa	9.876336	4.536081
7917	Kebbi	Augie	Augie North	12.887596	4.592589
7918	Ogun	Shagamu	Agbowa	6.870906	3.544705
7919	Kebbi	Birnin Kebbi	Ambursa	12.474445	4.353537
7920	Ebonyi	Ebonyi	Onuenyim	6.317085	8.115684
7921	Rivers	Degema	Tomble  III	4.489608	7.023692
7922	Kebbi	Augie	Tiggi/Awade	12.762516	4.615474
7923	Gombe	Kaltungo	Tula Wange	9.821610	11.591383
7924	Katsina	Kusada	Dudunni	12.550318	7.972080
7925	Adamawa	Mubi South	Mujara	10.218401	13.412130
7926	Kaduna	Lere	Dan Alhaji	10.487559	8.672185
7927	Enugu	Igbo-Eti	Aku V (Idueme)	6.702143	7.343400
7928	Delta	Ndokwa East	Ase	5.320319	6.335907
7929	Yobe	Machina	Kom-Komma	13.093089	10.008835
7930	Benue	Gboko	Ukpekpe	7.419458	8.997563
7931	Abia	Ukwa West	Ipu  East	4.905399	7.177240
7932	Kano	Takai	Karfi	11.451061	9.155288
7933	Kano	Tarauni	Tarauni	11.970976	8.526740
7934	Anambra	Onitsha North	Trans Nkisi	6.124874	6.770198
7935	Federal Capital Territory	Kwali	Dafa	8.769438	6.890697
7936	Imo	Oguta	Oru	5.680781	6.855105
7937	Plateau	Wase	Gudus	9.414591	10.224711
7938	Imo	Isiala Mbano	Osu-Achara	5.715721	7.213372
7939	Kebbi	Suru	Barbarejo	11.549062	4.031153
7940	Lagos	Apapa	Apapa i (Marine rd. & Environs)	6.446011	3.342539
7941	Benue	Gboko	Mbakwen	7.494561	8.785863
7942	Imo	Ngor-Okpala	Elelem/Obike	5.289760	7.086628
7943	Cross River	Calabar South	Twelve (12)	4.828923	8.297548
7944	Lagos	Surulere	Akinhanmi/Cole	6.528518	3.349608
7945	Kebbi	Birnin Kebbi	Kola /Tarasa	12.428353	4.124239
7946	Oyo	Ibadan North	Ward IV, N5A	7.395130	3.913701
7947	Osun	Osogbo	Eketa	7.746017	4.585083
7948	Lagos	Mushin	Babalosa/Idi-Araba	6.543178	3.343589
7949	Kano	Kura	Tanawa	11.778668	8.444075
7950	Katsina	Sandamu	Daneji 'B'	12.849444	8.264470
7951	Kano	Tundun Wada	Sabon Gari	11.244721	8.374816
7952	Katsina	Dutsin-M	Dutsin-Ma A	12.446495	7.507162
7953	Kano	Makoda	Satame	12.266779	8.549840
7954	Sokoto	Yabo	Fakka	12.619826	4.941027
7955	Yobe	Damaturu	Sasawa/Kabaru	11.946205	12.145436
7956	Ondo	Ose	Imoru/Arimogija	6.787950	5.661169
7957	Kano	Kibiya	Fammar	11.490104	8.702055
7958	Lagos	Amuwo Odofin	Festac III	6.493836	3.291808
7959	Katsina	Malumfashi	Dansarai	11.959401	7.740670
7960	Katsina	Dutsin-M	Shema	12.503696	7.529178
7961	Rivers	Ogu/Bolo	Bolo II	4.659184	7.217476
7962	Katsina	Mashi	Mashi	12.966299	7.951715
7963	Anambra	Nnewi South	Utuh	5.958244	6.914705
7964	Rivers	Obio/Akpor	Rumuomasi	4.828307	7.019124
7965	Oyo	Akinyele	Ikereku	7.630430	3.979636
7966	Kano	Ungogo	Tudun Fulani	12.017326	8.435323
7967	Benue	Vandeikya	Mbajor	6.921906	9.143879
7968	Ogun	Ado Odo-Ota	Ota II	6.620505	3.105986
7969	Rivers	Omumma	Ohimogho Community	5.119824	7.182396
7970	Imo	Ideato North	Uzii/Umualoma	5.839671	7.127897
7971	Ebonyi	Afikpo North	Ibii/Oziza Afikpo	5.923658	7.950550
7972	Benue	Tarka	Mbaayo	7.652320	8.926209
7973	Anambra	Ihiala	Okija  I	5.875643	6.810418
7974	Sokoto	Binji	Yabo 'B'	13.169575	4.916279
7975	Ekiti	Ise-Orun	Orun I	7.440896	5.387436
7976	Enugu	Udenu	Orba II	6.822727	7.542130
7977	Anambra	Dunukofia	Ukpo  III	6.210107	6.941369
7978	Delta	Udu	Aladja	5.478111	5.759281
7979	Plateau	Bassa	Zobwo	9.877903	8.722372
7980	Oyo	Oyo East	Balogun	7.858586	3.953518
7981	Rivers	Ahoada West	Joinkrama	5.153485	6.479180
7982	Jigawa	Miga	Dangyatin	12.195259	9.726828
7983	Federal Capital Territory	Kwali	Kilankwa	8.825288	7.089527
7984	Oyo	Egbeda	Ayede/Alugbo/Koloko	7.431743	4.118584
7985	Adamawa	Michika	Garta / Ghunchi	10.709011	13.486437
7986	Osun	Boluwaduro	Oke Ode Otan	7.949171	4.790706
7987	Enugu	Igbo-Eti	Ukehe V	6.648338	7.465416
7988	Abia	Isiala Ngwa North	Ngwa Ukwu II	5.367390	7.344123
7989	Edo	Ikpoba-Okha	Ogbeson	6.344549	5.677812
7990	Borno	Bayo	Jara Gol	10.270502	11.716614
7991	Kogi	Ajaokuta	Odonu/Unosi	7.614485	6.632614
7992	Ebonyi	Ikwo	Ndiagu Amagu II	5.978657	8.086507
7993	Kano	Tundun Wada	Tsoho Gari	11.227493	8.401780
7994	Kebbi	Augie	Bubuce	12.845754	4.647204
7995	Jigawa	Ringim	Chai-Chai	12.049134	9.248900
7996	Borno	Dikwa	Magarta / Sheffri	11.989817	14.133260
7997	Akwa Ibom	Onna	Awa IV	4.691778	7.862244
7998	Katsina	Batagarawa	Batagarawa B	12.873365	7.560763
7999	Benue	Makurdi	Mbalagh	7.804138	8.485819
8000	Kano	Wudil	Utai	11.731229	8.876170
8001	Niger	Lavun	Kutigi	9.196237	5.542659
8002	Oyo	Saki East	Ago Amodu II	8.576043	3.594102
8003	Edo	Orhionmw	Iyoba	6.115035	6.058661
8004	Rivers	Asari-Toru	Isia Group I	4.779891	6.817651
8005	Kogi	Koton-Karfe	Tawari	8.023280	6.921043
8006	Cross River	Obanliku	Bendi II	6.536892	9.133048
8007	Akwa Ibom	Urue Offong|Oruko	Oruko II	4.706243	8.170945
8008	Anambra	Idemili North	Ideani	6.094377	6.923348
8009	Edo	Oredo	Urubi/Evbiemwen/Iwehen	6.289332	5.573045
8010	Kano	Kabo	Gammo	11.880895	8.128376
8011	Kano	Tsanyawa	Zarogi	12.205454	7.969526
8012	Edo	Akoko Edo	Enwan/Atte/Ikpeshi/Egbigele	7.204682	6.180136
8013	Taraba	Gashaka	Gangami	7.940850	11.270395
8014	Plateau	Jos North	Vanderpuye	9.920980	8.886486
8015	Nassarawa	Lafia	Assakio	8.502452	8.865515
8016	Borno	Abadam	Banowa	13.206395	13.228449
8017	Bauchi	Toro	Jama'a / Zaranda	10.321225	9.461594
8018	Kano	Dawakin Tofa	Tattarawa	12.200475	8.410894
8019	Zamfara	Kaura-Namoda	Sakajiki	12.528054	6.509174
8020	Adamawa	Madagali	Madagali	10.887788	13.655286
8021	Cross River	Obanliku	Bebi	6.615193	9.298568
8022	Ondo	Idanre	Alade/Atosin	7.165349	5.093900
8023	Osun	Ayedire	Kuta  II	7.614210	4.296333
8024	Borno	Biu	Buratai	10.949132	12.196116
8025	Borno	Askira/Uba	Askira East	10.640252	12.964775
8026	Kwara	Offa	Ojomu South East	8.144031	4.731779
8027	Akwa Ibom	Urue Offong|Oruko	Urue Offong IV	4.717428	8.124717
8028	Kano	Rimin Gado	Dugurawa	11.983879	8.240085
8029	Sokoto	Kware	H/ Ali/ Marabawa	13.190492	5.331578
8030	Plateau	Kanam	Jarmai	9.344398	10.029584
8031	Oyo	Oyo West	Ajokidero/Akewugberu	7.979075	3.827107
8032	Enugu	Uzo-Uwani	Adani	6.739837	7.032011
8033	Kebbi	Jega	Jega Firchin	12.167030	4.416570
8034	Kano	Makoda	Jibga	12.471792	8.485733
8035	Katsina	Katsina (K)	Wakilin Yamma II	12.972693	7.570738
8036	Kaduna	Sabon Gari	Dogarawa	11.191650	7.732966
8037	Ekiti	Moba	Erinmope II	8.005207	5.168332
8038	Plateau	Mikang	Baltep	9.011705	9.553292
8039	Ekiti	Ekiti West	Aramoko I	7.680812	5.063731
8040	Delta	Oshimili South	Ogbele/Akpako	6.041655	6.657073
8041	Kebbi	Argungu	Kokani North	12.752707	4.529673
8042	Katsina	Charanchi	Majen wayya	12.511424	7.690539
8043	Imo	Owerri Municipal	Azuzi I	5.478780	7.022932
8044	Oyo	Kajola	Isemi-Ile/Imia/Ilua	7.947896	3.363601
8045	Ebonyi	Ikwo	Ekpelu	6.080531	8.071876
8046	Borno	Biu	Miringa	10.724435	12.157232
8047	Delta	Ughelli North	Orogun   II	5.698061	6.087307
8048	Borno	Jere	Dala lawanti	11.737663	13.167047
8049	Kaduna	Jaba	Nduyah	9.351323	7.997812
8050	Oyo	Egbeda	Olodo/Kumapayi I	7.414707	4.019666
8051	Oyo	Afijio	Akinmorin/Jobele	7.768215	3.941059
8052	Abia	Umuahia North	Ibeku West	5.530776	7.514442
8053	Ekiti	Ise-Orun	Oraye II	7.487549	5.365161
8054	Plateau	Pankshin	Lankan	9.299753	9.313919
8055	Sokoto	Kebbe	Girkau	12.020421	4.994365
8056	Borno	Marte	Zaga	12.274766	13.870081
8057	Borno	Abadam	Kudokurgu	13.626519	13.342010
8058	Lagos	Lagos Island	Lafiaji/Ebute	6.459983	3.409824
8059	Kebbi	Argungu	Lailaba	12.776325	4.407052
8060	Ondo	Odigbo	Koseru	6.673854	4.534693
8061	Plateau	Bokkos	Kwatas	9.370897	8.992314
8062	Jigawa	Buji	Kukuma	11.417622	9.673978
8063	Delta	Patani	Uduophori	5.147150	6.058065
8064	Borno	Abadam	Yituwa	13.556950	13.312454
8065	Kogi	Ajaokuta	Achagana	7.698045	6.685164
8066	Delta	Warri South-West	Aja - Udaibo	5.542833	5.343202
8067	Lagos	Lagos Island	Popo-Aguda	6.449814	3.395390
8068	Benue	Tarka	Mbaajir Akaa	7.627951	8.837601
8069	Lagos	Agege	Okekoto	6.643279	3.309409
8070	Edo	Esan West	Ogwa	6.523352	6.165582
8071	Ogun	Shagamu	Latawa	6.716015	3.437764
8072	Jigawa	Taura	Maje	12.199770	9.385362
8073	Abia	Umuahia South	Ezeleke/Ogbodiukwu	5.514239	7.421824
8074	Ebonyi	Onicha	Umudomi-Onicha	6.129800	7.848324
8075	Ekiti	Ikere	Atiba/Aafin	7.443833	5.192778
8076	Enugu	Enugu North	Ihewuzi	6.444510	7.506614
8077	Ondo	Ese-Odo	Ukparama I	6.079095	5.050680
8078	Borno	Jere	Mashamari	11.811370	13.282657
8079	Osun	Ayedire	Ileogbo  II	7.593432	4.257667
8080	Bauchi	Misau	Gwaram	11.463339	10.544365
8081	Adamawa	Shelleng	Gundo	9.669119	12.143599
8082	Ondo	Akoko North-East	Ikado I	7.538795	5.674603
8083	Benue	Gboko	Yandev South	7.402183	9.077597
8084	Kogi	Igalamela-Odolu	Ubele	7.170959	7.112543
8085	Borno	Kaga	Galangi	11.536774	12.444414
8086	Delta	Oshimili North	Ibusa V	6.142347	6.627260
8087	Niger	Mokwa	Jebba North	9.151436	4.804938
8088	Adamawa	Girie	Jera Bonyo	9.523751	12.593595
8089	Katsina	Dutsin-M	Kuki B	12.367052	7.563307
8090	Taraba	Sardauna	Titong	6.904722	11.339070
8091	Lagos	Ojo	Sabo	6.455621	3.178069
8092	Kogi	Okene	Obessa	7.494048	6.240380
8093	Sokoto	Binji	Binji	13.222038	4.926998
8094	Rivers	Port Harcourt	Oroabali	4.775997	7.021297
8095	Kwara	Ifelodun	Agunjin	8.408347	5.034877
8096	Oyo	Olorunsogo	Opa/Ogunniyi	8.863269	4.158249
8097	Kebbi	Zuru	Isgogo /Dago	11.520665	5.195418
8098	Jigawa	Miga	Sabon Gari Takanebu	12.285779	9.608799
8099	Federal Capital Territory	Bwari	Kubwa	9.141964	7.230670
8100	Akwa Ibom	Okobo	Akai/Mbukpo/Udung	4.714873	8.088771
8101	Katsina	Danja	Yakaji A	11.349686	7.617606
8102	Benue	Ukum	Ityuluv	7.636652	9.520597
8103	Rivers	Ogu/Bolo	Ogu  III	4.707920	7.208842
8104	Ebonyi	Ezza South	Amudo/Okoffia	6.066485	7.976337
8105	Taraba	Donga	Gayama	7.471661	10.507117
8106	Bayelsa	Nembe	Bassambiri I	4.543972	6.366133
8107	Benue	Gwer East	Mbaikyu	7.457532	8.616234
8108	Delta	Uvwie	Effurun II	5.547347	5.781603
8109	Anambra	Njikoka	Enugwu Ukwu  IV	6.161234	6.994766
8110	Zamfara	Bakura	Yar Geda	12.604925	5.986292
8111	Osun	Orolu	Olufon Orolu 'G'	7.862659	4.496724
8112	Edo	Ikpoba-Okha	Ologbo	6.053816	5.558447
8113	Ondo	Akure South	Lisa	7.212690	5.206810
8114	Ogun	Shagamu	Ayegbami/Ijokun	6.796464	3.674401
8115	Lagos	Ibeju/Lekki	Iwerekun II	6.444772	3.691846
8116	Imo	Ohaji-Egbema	Ohoba	5.401640	6.897541
8117	Anambra	Anambra East	Umuoba-anam	6.336180	6.830175
8118	Oyo	Ibarapa East	Sango	7.535703	3.516766
8119	Enugu	Uzo-Uwani	Akpogu	6.722372	7.282387
8120	Kebbi	Bagudo	Sharabi/Kwanguwai	11.579633	4.209550
8121	Oyo	Afijio	Awe I	7.785252	3.970092
8122	Enugu	Nsukka	Ede-Nta	6.803339	7.430930
8123	Bauchi	Misau	Hardawa	11.412776	10.479016
8124	Kano	Bunkure	Gwamma	11.684987	8.593601
8125	Kogi	Ibaji	Ojila	6.633803	6.725912
8126	Sokoto	Sokoto South	R/Dorowa 'B'	13.006831	5.260624
8127	Ogun	Abeokuta South	Ake III	7.161826	3.382829
8128	Imo	Njaba	Umuaka II	5.654593	7.041704
8129	Edo	Egor	Oliha	6.344159	5.578996
8130	Nassarawa	Lafia	Wakwa	8.487848	8.586179
8131	Katsina	Sandamu	Rade 'B'	12.850786	8.363111
8132	Delta	Ethiope West	Jesse  II	5.868500	5.853769
8133	Lagos	Amuwo Odofin	Satellite	6.445738	3.225496
8134	Zamfara	Bukkuyum	Yashi	12.168288	5.758254
8135	Bauchi	Darazo	Tauya	10.882703	10.482582
8136	Oyo	Oluyole	Ayegun	7.237071	3.950995
8138	Nassarawa	Nasarawa	Laminga	8.623908	7.788860
8139	Imo	Ikeduru	Atta I	5.591927	7.127852
8140	Sokoto	Wamakko	Bado/Kasarawa	12.961276	5.214864
8141	Ogun	Odogbolu	Aiyepe	6.801888	3.850582
8142	Edo	Ovia South West	Usen	6.798154	5.294946
8143	Anambra	Awka South	Nibo  II	6.183617	7.059585
8144	Niger	Lavun	Mambe	8.838519	5.885334
8145	Imo	Ikeduru	Akabo	5.548153	7.103746
8146	Ondo	Owo	Ijebu I	7.206913	5.616342
8147	Rivers	Ahoada East	Uppata  VI	5.018339	6.652953
8148	Borno	Kala/Balge	Moholo	12.107021	14.572982
8149	Sokoto	Gwadabaw	Gidan Kaya	13.279894	5.358171
8150	Kogi	Idah	Sabon Gari	7.048426	6.710444
8151	Abia	Umu-Nneochi	Umuchieze  II	5.909135	7.404863
8152	Benue	Katsina- Ala	Ikurav Tiev II	7.322771	9.319115
8153	Ondo	Ese-Odo	Apoi III	6.366662	4.925858
8154	Osun	Boluwaduro	Iresi  II	7.950507	4.836051
8155	Anambra	Orumba South	Ezira	5.993389	7.204388
8156	Akwa Ibom	Nsit Ibom	Asang V	4.891906	7.880566
8157	Osun	Ifedayo	Aworo/Oke-Ila Rural	7.953657	4.999222
8158	Kano	Kabo	Garo	11.931197	8.124993
8159	Osun	Osogbo	Ataoja  'D'	7.745751	4.561822
8160	Ogun	Imeko-Afon	Olorunda/Gbomo	7.520272	2.970038
8161	Lagos	Mushin	Alakara	6.545713	3.356608
8162	Kebbi	Maiyama	Karaye/Dogondaji	11.970850	4.325892
8163	Yobe	Potiskum	Dogo Nini	11.691791	11.122125
8164	Ogun	Shagamu	Sabo I	6.769930	3.621646
8165	Adamawa	Maiha	Sorau 'A'	9.879060	13.202309
8166	Sokoto	Rabah	Gwaddodi/Gidan Bu Wai	13.041828	5.575965
8167	Katsina	Mai'Adua	Natsalle	13.139434	8.159982
8168	Rivers	Port Harcourt	Ogbunabali	4.768309	7.017823
8169	Enugu	Ezeagu	Iwollo	6.431927	7.267578
8170	Bauchi	Damban	Yame	11.596261	10.675310
8171	Imo	Aboh-Mbaise	Nguru-Nweke	5.489382	7.274221
8172	Borno	Shani	Shani	10.221608	12.125590
8173	Zamfara	Bungudu	Bingi North	12.065316	6.489621
8174	Ogun	Odogbolu	Idowa	6.699679	3.705769
8175	Kano	Tsanyawa	Tsanyawa	12.247165	7.995662
8176	Katsina	Kafur	Yartalata/Rigoji	11.715819	7.735924
8177	Imo	Owerri Municipal	Azuzi III	5.451628	7.032927
8178	Adamawa	Demsa	Borrong	9.508809	12.335168
8179	Federal Capital Territory	Municipal	Gui	8.959334	7.198956
8180	Delta	Ukwuani	Umukwata	5.851585	6.198068
8181	Adamawa	Gombi	Guyaku	10.290365	12.697740
8182	Borno	Magumeri	Magumeri	12.088734	12.795340
8183	Lagos	Epe	lagbade	6.547353	3.980869
8184	Bayelsa	Southern Ijaw	Koluama	4.514009	5.866344
8185	Enugu	Aninri	Nnenwe i	6.086135	7.530822
8186	Sokoto	Illela	Damba	13.580452	5.245515
8187	Rivers	Etche	Igbo I	4.919586	7.072543
8188	Nassarawa	Nassarawa Egon	Lizzin Keffi/Ezzen	8.747856	8.263998
8189	Sokoto	Isa	Gebe 'A'	13.160568	6.643827
8190	Ondo	IleOluji/Okeigbo	Ileoluji VI	7.328396	4.948726
8191	Anambra	Orumba North	Ufuma  I	6.056120	7.236991
8192	Sokoto	Gwadabaw	Mammande	13.472037	5.520056
8193	Lagos	Alimosho	Abule-Egba/Aboru/Meiran/Alagbado	6.655544	3.255237
8194	Kaduna	Birnin Gwari	MagajinG3	11.006767	6.663422
8195	Ebonyi	Ikwo	Ndiagu Echara I	6.106415	8.218001
8196	Sokoto	Isa	Isa North	13.217706	6.410841
8197	Lagos	Eti-Osa	Ajah/Sangotedo	6.473069	3.607251
8198	Kwara	Kaiama	Bani	9.045518	4.176637
8199	Bauchi	Shira	Tsafi	11.336124	10.131978
8200	Kano	Bunkure	Kulluwa	11.624832	8.589830
8201	Jigawa	Kafin Hausa	Mezan	12.259332	10.133614
8202	Kwara	Asa	Gambari/Aiyekale	8.479688	4.429225
8203	Kano	Bichi	Kaukau	12.230674	8.231312
8204	Ebonyi	Ishielu	Ezzagu I (Ogboji)	6.252384	7.753991
8205	Zamfara	Zurmi	Dole	12.883130	6.450055
8206	Benue	Katsina- Ala	Tiir(Tongov II)	7.405610	9.529231
8207	Adamawa	Song	Suktu	9.637458	12.424821
8208	Oyo	Ibarapa Central	Okeserin I & II	7.477668	3.294341
8209	Osun	Ifelodun	Station Road, Ikirun	7.926108	4.640082
8210	Borno	Monguno	Yele	12.540479	13.522951
8211	Borno	Kwaya Kusar	Kwaya Kusar	10.542598	11.909040
8212	Imo	Orlu	Umuna	5.792877	7.045650
8213	Oyo	Ogbomosho South	Akata	8.092044	4.233536
8214	Federal Capital Territory	Municipal	Wuse	9.071276	7.471116
8215	Rivers	Tai	Ward X (Ban-Ogoi)	4.785954	7.221786
8216	Gombe	Dukku	Waziri South / Central	10.732598	10.889664
8217	Osun	Atakumosa West	Isa Obi	7.620422	4.652331
8218	Oyo	Ibadan North	Ward VI, N6A PART I	7.404732	3.888615
8219	Cross River	Odukpani	Oniman-Kiong	5.171621	8.260658
8220	Nassarawa	Keana	Kwara	8.197178	8.513588
8221	Sokoto	Sokoto North	Waziri 'A'	13.081531	5.287562
8222	Ogun	Ijebu-Ode	Odo-Esa	6.804666	3.953042
8223	Delta	Burutu	Obotebe	5.418410	5.357348
8224	Jigawa	Ringim	Sankara	12.245661	9.068956
8225	Delta	AniochaS	Ubulu - Uku I	6.222686	6.460696
8226	Ekiti	Ikere	Okeruku	7.457236	5.144905
8227	Kano	Minjibir	Wasai	12.152108	8.678015
8228	Osun	Oriade	Ijebu-Jesa	7.674489	4.847093
8229	Ekiti	Oye	Isan/Ilafon/Ilemeso	7.962993	5.355491
8230	Anambra	Anaocha	Ichida II	6.021117	6.969920
8231	Kano	Kibiya	Kahu	11.446959	8.614875
8232	Delta	Udu	Ekete	5.505439	5.799239
8233	Niger	Mashegu	Mashegu	9.931218	5.652333
8234	Benue	Okpokwu	Eke	7.101450	7.913156
8235	Benue	Gwer West	Merkyen	7.576065	8.316783
8236	Rivers	Etche	Odufor	5.076990	7.009652
8237	Taraba	Karim-Lamido	Amar	8.853635	10.712588
8238	Jigawa	Kaugama	Unguwar Jibrin	12.399728	9.652114
8239	Kebbi	Shanga	Sawashi	11.097077	4.763306
8240	Plateau	Riyom	Sopp	9.505701	8.614204
8241	Oyo	Ogo-Oluwa	Idewure	7.866307	4.166952
8242	Osun	Boluwaduro	Obala Iloro	7.896492	4.852883
8243	Ondo	IleOluji/Okeigbo	Oke-igbo IV	7.294089	4.900050
8244	Taraba	Donga	Gyatta Aure	7.639203	10.109793
8245	Osun	Ejigbo	Elejigbo 'C'/Mapo	7.912130	4.319582
8246	Ekiti	Ikole	Oke Ayedun	7.883629	5.451876
8247	Zamfara	Maradun	Maradun South	12.534260	6.326240
8248	Yobe	Yusufari	Gumshi	13.184122	10.340162
8249	Yobe	Gulani	Kushimaga	10.749359	11.605255
8250	Delta	Udu	Udu  IV	5.441662	5.810940
8251	Akwa Ibom	Ibiono Ibom	Ibiono Central II	5.218036	7.873509
8252	Kebbi	Bagudo	Kaoje/Gwamba	11.233740	4.017062
8253	Borno	Jere	Maimusari	11.785745	13.285230
8254	Oyo	Iwajowa	Sabi Gana II	7.874426	3.299798
8255	Gombe	Dukku	Lafiya	10.984350	10.678501
8256	Benue	Apa	Igah-Okpaya	7.518920	7.890246
8257	Akwa Ibom	Etim Ekpo	Etim Ekpo VIII	4.918453	7.511568
8258	Yobe	Potiskum	Hausawa	11.701560	11.097855
8259	Kebbi	Yauri	Jijima	10.771499	4.764898
8260	Katsina	Sabuwa	Damari	11.391290	7.068289
8261	Lagos	Ifako/Ijaye	Ijaiye/Agbado/Kollington	6.691876	3.274116
8262	Delta	Okpe	Aghalokpe	5.768870	5.874433
8263	Kano	Garko	Dal	11.460662	8.767251
8264	Benue	Oturkpo	Entekpa	7.533268	8.033511
8265	Anambra	Oyi	Nteje  V	6.256204	6.914677
8266	Rivers	Khana	Kono/Kwawa	4.596381	7.502353
8267	Niger	Mariga	Maburya	10.949851	5.549468
8268	Akwa Ibom	Uruan	Central Uruan I	5.022644	8.016948
8269	Ekiti	Ikere	Ugele/Aroku	7.469118	5.204051
8270	Jigawa	Kirika Samma	Marma	12.656531	10.317365
8271	Jigawa	Gumel	Zango	12.618453	9.412599
8272	Akwa Ibom	Eastern Obolo	Eastern Obolo VII	4.526569	7.614693
8273	Akwa Ibom	Ikono	Nkwot I	5.246025	7.806710
8274	Oyo	Oyo East	Apinni	7.886384	4.040906
8275	Yobe	Yusufari	Kumagannam	13.110289	10.671320
8276	Edo	Etsako Central	Ekperi II	6.968911	6.444477
8277	Kebbi	Arewa	Biu	12.715046	4.111269
8278	Enugu	Enugu North	Ogbette East	6.431836	7.481120
8279	Osun	Ife East	Okerewe  I	7.376723	4.616807
8280	Sokoto	Rabah	Tursa	13.194407	5.667785
8281	Katsina	Mai'Adua	Mai Koni 'A'	13.060608	8.287418
8282	Nassarawa	Toto	Umaisha	8.022250	7.084693
8283	Kano	Kumbotso	Danbare	11.931287	8.418570
8284	Cross River	Bakassi	Abana	4.710144	8.471652
8285	Kano	Warawa	Jigawa	11.856195	8.814303
8286	Anambra	Ogbaru	Okpoko I	6.048651	6.768737
8287	Abia	Ukwa East	Ikwueke  West	4.943858	7.362387
8288	Osun	Ilesha West	Itakogun/Upper Egbe-Idi	7.631323	4.744261
8289	Edo	Esan North East	Idumu-Okojie	6.714816	6.321615
8290	Delta	Oshimili South	West End	6.227030	6.712804
8291	Rivers	Abua/Odu	Abua II	4.861759	6.601615
8292	Niger	Bosso	Bosso central  II	9.680646	6.555674
8293	Benue	Gwer East	Ikyogbajir	7.197415	8.372278
8294	Borno	Damboa	Bego/Yerwa/Ngurna	11.154975	12.952618
8295	Kebbi	Shanga	Binuwa/Gebe/Bunkuji	11.043621	4.718590
8296	Lagos	Ikorodu	Agura/Iponmi	6.612767	3.601607
8297	Adamawa	Hong	Daksiri	10.097614	12.966515
8298	Imo	Orsu	Umuhu Okabia	5.815447	7.010035
8299	Akwa Ibom	Mkpat Enin	Ikpa Ibom I	4.687152	7.787843
8300	Anambra	Onitsha North	Inland Town VII	6.093512	6.797903
8301	Bayelsa	Ogbia	Okodi	4.666017	6.220727
8302	Ogun	Shagamu	Ijagba	6.702852	3.519915
8303	Delta	IkaNorth	Umunede	6.286376	6.308196
8304	Adamawa	Teungo	Kiri II	8.221628	11.952066
8305	Borno	Nganzai	Kurnawa	12.328154	13.160848
8306	Osun	Oriade	Apoti Dagbaja	7.393933	4.867635
8307	Yobe	Fune	Damagum Town	11.656576	11.349111
8308	Niger	Gurara	Lefu	9.258904	6.747013
8309	Cross River	Obudu	Obudu Urban II	6.638597	9.116635
8310	Oyo	Ori-Ire	Ori Ire II	8.325066	4.189490
8311	Akwa Ibom	Ibesikpo Asutan	Ibesikpo I	4.973618	7.900082
8312	Enugu	Oji-River	Akpugoeze	6.126720	7.238566
8313	Niger	Suleja	Hashimi 'B'	9.194766	7.146613
8314	Enugu	Ezeagu	Obinofia	6.293307	7.210414
8315	Cross River	Calabar South	Six (6)	4.911952	8.264340
8316	Rivers	Emuoha	Odegu  II	4.868249	6.765118
8317	Kano	Takai	Zuga	11.536903	9.147540
8318	Ogun	Imeko-Afon	Iwoye/Jabata	7.614676	2.893064
8319	Benue	Konshisha	Mbake	6.899554	8.897353
8320	Yobe	Jakusko	Gidgid / Bayam	12.496191	10.950039
8321	Anambra	Oyi	Umunya  II	6.194118	6.885941
8322	Delta	Warri South	Ogunu/Ekurede-Urhobo	5.538515	5.729423
8323	Delta	Ndokwa West	Utagba  Uno  I	5.960129	6.382054
8324	Adamawa	Jada	Koma II	8.808856	12.769114
8325	Kwara	Pategi	Pategi II	8.689153	5.648131
8326	Akwa Ibom	Ibesikpo Asutan	Ibesikpo II	4.953672	7.926585
8327	Jigawa	Biriniwa	Karanka	12.787622	9.846315
8328	Rivers	Obio/Akpor	Rumueme (7C)	4.823879	6.970486
8329	Rivers	Degema	Bille	4.584276	6.872930
8330	Imo	Aboh-Mbaise	Uvuru I	5.383541	7.242959
8331	Imo	Ezinihitte Mbaise	Amumara	5.434782	7.331486
8332	Katsina	Dandume	Mahuta C	11.422212	7.265991
8333	Benue	Oturkpo	Otukpo Town Central	7.189454	8.118299
8334	Plateau	Bassa	Zabolo	10.156905	8.914233
8335	Bauchi	Tafawa-Balewa	Dajin	10.078419	9.613065
8336	Anambra	Orumba South	Nkerehi	6.006761	7.307581
8337	Kwara	Kaiama	Wajibe	10.020613	3.960658
8338	Abia	Ugwunagbo	Ward Six	5.033009	7.330859
8339	Enugu	Nsukka	Ihe	6.861299	7.413069
8340	Kaduna	Kaduna South	Kakuri Hausa	10.456046	7.409425
8341	Delta	Ughelli South	Ewu III	5.253783	5.847754
8342	Benue	Oju	Owo	6.772786	8.474542
8343	Kaduna	Birnin Gwari	Kakangi	10.752324	6.244411
8344	Niger	Mariga	Kakihum	10.788783	5.647178
8345	Gombe	Funakaye	Bage	10.948318	11.452110
8346	Borno	Bama	Zangeri/Kash  Kash	11.710975	14.211239
8347	Katsina	Batagarawa	Dandagoro	12.916308	7.651684
8348	Kebbi	Dandi	Maigwaza	11.813154	3.952993
8349	Kaduna	Kaura	Kaura	9.638465	8.496963
8350	Sokoto	Gada	Tsitse	13.535209	5.754247
8351	Kogi	Idah	Igalaogba	7.093631	6.708508
8352	Bayelsa	Ekeremor	Oyiakiri III	5.078070	5.917684
8353	Adamawa	Maiha	Humbutudi	10.140049	13.246836
8354	Oyo	Saki East	Agbonle	8.852398	3.512480
8355	Imo	Ezinihitte Mbaise	Itu	5.458316	7.345735
8356	Abia	Bende	Ozuitem	5.610921	7.613669
8357	Oyo	Orelope	Igbope/Iyeye II	8.775144	3.860085
8358	Yobe	Tarmuwa	Mandadawa	12.374364	11.425862
8359	Akwa Ibom	Nsit Ubium	Ubium South III	4.728691	7.994020
8360	Jigawa	Gwaram	Sara	11.306577	9.699825
8361	Ondo	Idanre	Isalu Jigbokin	7.049202	5.129440
8362	Kwara	Offa	Essa-C	8.107175	4.697877
8363	Bauchi	Giade	Doguwa  South	11.339116	10.189564
8364	Niger	Tafa	Dogon Kurmi	9.291018	7.286591
8365	Imo	Owerri Municipal	Azuzi II	5.464353	7.051580
8366	Kano	Bichi	Danzabuwa	12.307565	8.096165
8367	Ondo	Okitipupa	Erinje	6.431053	4.713130
8368	Adamawa	Michika	Futudou / Futules	10.588190	13.475159
8369	Cross River	Akpabuyo	Ikang South	4.790292	8.444765
8370	Cross River	Calabar Municipality	Ten	5.056805	8.320900
8371	Osun	Ede North	Sabo/Agbongbe II	7.728702	4.472637
8372	Borno	Bayo	Zara	10.668670	11.875463
8373	Plateau	Wase	Kuyambana	9.086339	9.951808
8374	Benue	Okpokwu	Okonobo	7.096293	7.834427
8375	Kwara	Ekiti	Oke-Opin/Etan	8.024513	5.221439
8376	Osun	Ede North	Apaso	7.710771	4.462705
8377	Ebonyi	Ohaozara	Amaechi okposi	5.961148	7.869548
8378	Anambra	Awka South	Okpuno	6.237425	7.048957
8379	Sokoto	Kware	Kabanga	13.019615	5.430283
8380	Anambra	Aguata	Achina I	5.957062	7.115945
8381	Anambra	Njikoka	Enugwu-agidi  I	6.222148	6.973515
8382	Sokoto	Gada	Kwarma	13.631606	5.665265
8383	Nassarawa	Lafia	Zanwa	8.493779	8.506676
8384	Jigawa	Ringim	Yandutse	12.133943	9.197976
8385	Cross River	Boki	Abo	6.096786	8.957184
8386	Sokoto	Tambawal	Bagida/Lukkingo	12.213671	4.852535
8387	Ondo	IleOluji/Okeigbo	Ileoluji III	7.241398	4.989075
8388	Akwa Ibom	Obot Akara	Nto Edino I	5.224698	7.565450
8389	Jigawa	Gwiwa	Gwiwa	12.766859	8.324560
8390	Bauchi	Toro	Zalau / Rishi	10.441509	8.967607
8391	Katsina	Batagarawa	Jino	12.928055	7.555655
8392	Lagos	Surulere	Itire	6.519831	3.321252
8395	Kaduna	Kubau	Anchau	10.944740	8.288994
8396	Edo	Etsako Central	Iraokhor	7.134346	6.438368
8397	Ogun	Abeokuta North	Lafenwa	7.176269	3.259943
8398	Kano	Dawakin Tofa	Jalli	12.185285	8.471655
8399	Kwara	Ekiti	Obbo-Aiyeggunle II	8.042188	5.318109
8400	Gombe	Akko	Kashere	9.910919	11.016882
8401	Niger	Gurara	Diko	9.314002	7.212249
8402	Anambra	Ogbaru	Okpoko V	6.027168	6.769641
8403	Niger	Bida	Wadata	9.097931	5.975642
8404	Rivers	Etche	Okehi	5.111826	7.101850
8405	Ebonyi	Ohaozara	Obiozara	6.010071	7.757318
8406	Federal Capital Territory	Municipal	Garki	9.051905	7.489527
8407	Plateau	Bokkos	Mangor	9.331170	8.873109
8408	Kogi	Ankpa	Ankpa II	7.336013	7.743711
8409	Imo	Oguta	Awa	5.599906	6.933609
8410	Rivers	Omumma	Obiohia Community	5.114893	7.256009
8411	Bauchi	Alkaleri	Alkaleri	10.241542	10.393893
8412	Yobe	Jakusko	Jakusko	12.376083	10.796979
8413	Ogun	Ijebu East	Ijebu Mushin I	6.808330	4.000875
8414	Edo	Esan South East	Ewohimi II	6.515543	6.296136
8415	Plateau	Jos North	Ali Kazaure	9.938246	8.885213
8416	Adamawa	Mubi North	Mayo Bani	10.411257	13.343213
8417	Kano	Nasarawa	Giginyu	11.994980	8.502526
8418	Kebbi	Arewa	Chibike	12.438064	3.899378
8419	Delta	Sapele	Sapele Urban  II	5.891939	5.681525
8420	Kano	Fagge	Fagge C	11.969281	8.546642
8421	Ekiti	Emure	Odo Emure IV	7.498451	5.554516
8422	Kano	Tsanyawa	Yankamaye	12.286020	7.915706
8423	Katsina	Matazu	Dissi	12.177648	7.672495
8424	Ondo	Ilaje	Ugbo IV	6.047814	4.919497
8425	Ogun	Ijebu North-East	Oke-Eri/Ogbogbo	6.868447	3.958487
8426	Yobe	Gujba	Mutai	11.284731	11.702132
8427	Ondo	Irele	Akotogbo I	6.403208	5.020491
8428	Delta	AniochaS	Isheagu-Ewulu	6.042992	6.549317
8429	Kebbi	Jega	Jandutsi/Birnin Malam	11.939749	4.578492
8430	Borno	Askira/Uba	Uda / Uvu	10.520578	13.164902
8431	Abia	Aba South	Mosque	5.089368	7.360489
8432	Akwa Ibom	Ikono	Ikono South	5.227014	7.762648
8433	Adamawa	Guyuk	Banjiram	9.783495	12.045627
8434	Niger	Kontogur	Masuga	10.556747	5.477430
8435	Kogi	Ijumu	Aiyegunle	8.066317	5.979266
8436	Borno	Mafa	Ma'afa	12.118778	13.816716
8437	Anambra	Nnewi South	Unubi	5.928074	7.003020
8438	Ebonyi	Afikpo South	Ndioke Ekoli	5.765107	7.854127
8439	Cross River	Calabar South	Four (4)	4.914419	8.241854
8440	Kano	Sumaila	Garfa	11.524664	8.897383
8441	Abia	Bende	Igbere 'A'	5.707206	7.647242
8442	Delta	IkaSouth	Abavo I	6.070418	6.197549
8443	Kano	Minjibir	Azore	12.090747	8.587216
8444	Kogi	Kabba-Bunu	Akutupa-Kiri	8.350265	6.102828
8445	Ondo	Ondo East	Obada	7.165443	4.949987
8446	Delta	Patani	Toru-Angiama	5.169525	6.098132
8447	Abia	Umuahia North	Afugiri	5.603151	7.454542
8448	Edo	Ovia South West	Iguobazuwa West	6.603418	5.358898
8449	Borno	Askira/Uba	Wamdeo / Giwi	10.561615	13.122904
8450	Akwa Ibom	Abak	Afaha Obong I	5.049103	7.734855
8451	Kaduna	Kaura	Kpak	9.562994	8.436871
8452	Anambra	Oyi	Nteje  I	6.255571	6.898878
8453	Kaduna	Kaura	Bondon	9.683236	8.567240
8454	Delta	Ethiope West	Oghara V	5.992538	5.689737
8455	Bayelsa	Ogbia	Anyama	4.733749	6.241590
8456	Lagos	Ikeja	Airport/Onipetesi/Inilekere	6.607358	3.310058
8457	Niger	Mashegu	Kulho	9.892240	4.976553
8458	Jigawa	Buji	Ahoto	11.638536	9.791243
8459	Anambra	Anambra East	Aguleri  II	6.333302	6.903581
8460	Rivers	Ahoada West	Okarki	4.957333	6.469418
8461	Bayelsa	Southern Ijaw	East Bomo II	4.733669	6.113910
8462	Kogi	Dekina	Okura Olafia	7.484277	7.409383
8463	Benue	Kwande	Liev II	6.782934	9.637459
8464	Kano	Kura	Kurunsumau	11.773280	8.425909
8465	Ogun	Ewekoro	Wasimi	7.032820	3.147025
8466	Katsina	Baure	Baure	12.849467	8.747793
8467	Akwa Ibom	Eastern Obolo	Eastern Obolo IX	4.480861	7.621247
8468	Kebbi	Aleiro	Aliero S/Fada I	12.294266	4.478475
8469	Kaduna	Zaria	Wucicciri	10.980375	7.766714
8470	Cross River	Odukpani	Ekori/Anaku	5.140692	8.207967
8471	Rivers	Gokana	K-Dere II	4.649162	7.247636
8472	Kano	Dawakin Kudu	Dawaki	11.843412	8.588567
8473	Rivers	Tai	Ward V (Kira/Borobara)	4.710860	7.249714
8474	Oyo	Ibadan South West	Ward 10 SW8 II	7.368974	3.869293
8475	Abia	Ukwa West	Asa South	4.894768	7.223641
8476	Rivers	Ahoada East	Ahoada  IV	5.082949	6.647204
8477	Kogi	Ibaji	Unale	6.915082	6.883589
8478	Taraba	Zing	Zing B	9.019153	11.792131
8479	Kano	Bebeji	Rahama	11.380095	8.265501
8480	Rivers	Khana	Beeri	4.692593	7.438893
8481	Oyo	Itesiwaju	Okaka II	8.185660	3.473656
8482	Enugu	Isi-Uzo	Ehamufu II	6.641209	7.773831
8483	Plateau	Kanam	Namaran	9.273887	9.896836
8484	Imo	Ideato North	Ezemazu/Ozu	5.844688	7.097272
8485	Enugu	Igbo-eze North	Umuozzi VI	6.955769	7.422655
8486	Taraba	Karim-Lamido	Andamin	9.240748	10.766471
8487	Borno	Kukawa	Kekeno	12.730667	13.691235
8488	Akwa Ibom	Ika	Ito I	5.002464	7.541612
8489	Osun	Atakumosa East	Iwara	7.533128	4.788925
8490	Osun	Ife North	Oyere - II	7.063595	4.452427
8491	Kano	Doguwa	Tagwaye	10.862237	8.604048
8492	Lagos	Shomolu	Abule-Okuta/Ilaje/Bariga	6.550107	3.394505
8493	Osun	Atakumosa West	Ibodi	7.583254	4.667742
8494	Katsina	Charanchi	Safana	12.659750	7.733720
8495	Ondo	Ese-Odo	Apoi V	6.396672	4.882678
8496	Enugu	EnuguSou	Achara layout West	6.410504	7.499327
8497	Adamawa	Teungo	Dawo II	8.049511	11.788702
8499	Akwa Ibom	Essien Udim	Okon	5.076655	7.596292
8500	Ogun	Odeda	Alabata	7.313608	3.230858
8501	Bayelsa	Yenagoa	Epie III	4.908065	6.297332
8502	Kwara	Asa	Okesho	8.251424	4.595485
8503	Kogi	Adavi	Okunchi/Ozuri/Onieka	7.563585	6.198994
8504	Lagos	Ajeromi/Ifelodun	Olodi	6.460368	3.322790
8505	Ogun	Ado Odo-Ota	Ota III	6.692240	3.096175
8506	Imo	Nkwerre	Eziama Obaire	5.736721	7.090636
8507	Ebonyi	Ivo	Ndiokoro Ukwu	5.863831	7.538844
8508	Cross River	Akpabuyo	Ikot Eyo	4.905753	8.560116
8509	Enugu	EnuguSou	Maryland	6.410951	7.522176
8510	Akwa Ibom	Itu	Oku Iboku	5.181884	8.017896
8511	Kwara	Irepodun	Omu-Aran III (Ifaja)	8.102041	5.135092
8512	Rivers	Asari-Toru	Buguma  South  West	4.733923	6.862946
8513	Kogi	Koton-Karfe	Gegu-Beki North	8.232170	6.836598
8514	Jigawa	Taura	Chakwaikwaiwa	12.250678	9.312333
8515	Niger	Chanchaga	Limawa 'A'	9.614977	6.514010
8516	Bauchi	Zaki	Murmur North	12.088884	10.201816
8517	Ekiti	Ikole	Ikole North	7.760993	5.601647
8518	Ebonyi	Abakalik	Okpoitumo Ndiegu	6.235257	8.321798
8519	Niger	Edati	Enagi	9.109942	5.547536
8520	Benue	Makurdi	Bar	7.630043	8.493393
8521	Anambra	Anaocha	Adazi Nnukwu  I	6.092236	6.980609
8522	Kano	Tofa	Wangara	11.977509	8.289181
8523	Bayelsa	Brass	Brass ward II	4.355998	6.416855
8524	Kwara	Pategi	Pategi III	8.578384	5.919146
8525	Kwara	Ifelodun	Share I	8.692825	5.050235
8526	Rivers	Bonny	Ward I Oro-Igwe	4.453393	7.172526
8527	Kaduna	Jema'a	Atuku	9.479378	8.467097
8528	Enugu	Isi-Uzo	Neke I	6.690543	7.618865
8529	Abia	Ikwuano	Usaka	5.340678	7.641880
8530	Osun	Ede North	Sabo/Agbongbe I	7.715670	4.465533
8531	Benue	Gboko	Mbakper	7.273187	9.069528
8532	Rivers	Tai	Ward III (Korokoro)	4.717641	7.315590
8533	Katsina	Batagarawa	Tsanni	12.789023	7.567528
8534	Akwa Ibom	Oruk Anam	Abak Midim I	4.715170	7.649656
8535	Kano	Shanono	Kadamu	12.150036	7.962566
8536	Katsina	Kankiya	Kafinsoli	12.493531	7.758418
8537	Akwa Ibom	Uyo	Offot II	5.038662	7.964369
8538	Yobe	Nguru	Mirba-Kabir/Mirba Sagir	13.015718	10.288448
8539	Jigawa	Sule Tankarkar	Danzomo	12.444192	9.345050
8540	Akwa Ibom	Esit Eket	Uquo	4.649073	8.063379
8541	Kogi	Ofu	Aloma	7.313874	7.296324
8542	Plateau	Barkin Ladi	Gindin Akwati	9.457760	8.853480
8543	Oyo	Ibadan North	Ward I N2	7.384041	3.915813
8544	Delta	IsokoNor	Ellu/Radheo/Ovrode	5.598725	6.291461
8545	Abia	Bende	Bende	5.533204	7.594668
8546	Plateau	Langtang South	Fajul	8.579098	9.970993
8547	Ondo	Odigbo	Ago-Alaye	6.648251	4.407567
8548	Katsina	Funtua	Dandutse	11.517640	7.317378
8549	Delta	Patani	Patani  I	5.235344	6.243753
8550	Kebbi	Danko Wasagu	Wasagu	11.461962	5.819252
8551	Benue	Gwer West	Sagher/Ukusu	7.637852	8.287127
8552	Edo	Ovia South West	Ofunama	6.185904	5.178132
8553	Bayelsa	Nembe	Okoroma I	4.614446	6.259584
8554	Akwa Ibom	Ini	Ikono North II	5.328001	7.723110
8555	Enugu	Igbo-eze South	Itchi/uwani II	6.964612	7.311891
8556	Delta	Oshimili South	Ugbomanta Quarters	6.203302	6.729127
8557	Edo	Esan Centtral	Opoji	6.687990	6.185403
8558	Kano	Ungogo	Rijiyar Zaki	11.981127	8.420605
8559	Abia	Aba South	Ekeoha	5.087334	7.355884
8560	Cross River	Ogoja	Ogoja Urban ii	6.605529	8.782276
8561	Ekiti	Oye	Oye II	7.847313	5.269707
8562	Niger	Lapai	Takuti/Shaku	9.194146	6.649348
8563	Kano	Kiru	Kiru	11.699558	8.154704
8564	Zamfara	Zurmi	Yan Buki/ Dutsi	12.825882	6.618035
8565	Oyo	Ibarapa East	Isale Togun	7.646610	3.429459
8566	Enugu	Oji-River	Oji-river I	6.236985	7.267841
8567	Borno	Hawul	Sakwa/Hema	10.526284	12.187963
8568	Akwa Ibom	Oruk Anam	Ikot Ibritam I	4.779945	7.565407
8569	Jigawa	Birnin Kudu	Sundimina	11.607858	9.578586
8571	Delta	Sapele	Sapele  Urban  VI	5.897794	5.671535
8572	Ogun	Odogbolu	Ibefun	6.699224	3.770967
8573	Ebonyi	Ohaozara	Ugbogologo Ugwulangwu	6.001109	7.855474
8574	Katsina	Sabuwa	Sabuwa 'B'	11.199364	7.096433
8575	Ekiti	Ado-Ekiti	Ado 'F' Okeyinmi	7.628965	5.306132
8576	Abia	Arochukwu	Ututu	5.430486	7.912897
8577	Plateau	Langtang North	Funyalang	9.139774	9.687141
8578	Yobe	Bade	Katuzu	12.819756	10.995746
8579	Sokoto	Wurno	Magarya	13.288525	5.423634
8580	Ondo	Okitipupa	Ilutitun II	6.530171	4.655711
8581	Plateau	Langtang North	Pajat	9.164116	9.756164
8582	Edo	Akoko Edo	Igarra II	7.240084	6.099235
8583	Bauchi	Gamawa	Gadiya	11.960614	10.508740
8584	Cross River	Boki	Beebo/Bumaji	6.473683	9.215657
8585	Kano	Bagwai	Wuro Bagga	12.140542	8.109078
8586	Osun	Ede North	Asunmo	7.695677	4.464724
8587	Benue	Guma	Mbayer/Yandev	7.972799	8.452776
8588	Yobe	Fune	Gudugurka/Marmar  I	12.252488	11.217940
8589	Delta	AniochaS	Ogwashi - Uku I	6.158157	6.506299
8590	Ekiti	Emure	Ogbontioro II	7.324528	5.473601
8591	Adamawa	Teungo	Toungo II	7.967400	12.095967
8592	Rivers	Port Harcourt	Diobu	4.774424	6.994498
8593	Akwa Ibom	Ibiono Ibom	Ibiono Northern II	5.244052	7.895045
8594	Benue	Kwande	Mbaketsa	6.525831	9.497315
8595	Delta	EthiopeE	Abraka  III	5.754107	6.078134
8596	Taraba	Lau	Lau II	9.085929	11.226389
8597	Yobe	Jakusko	Jaba	12.407687	11.148451
8598	Cross River	Yala	Yache	6.501494	8.449706
8599	Akwa Ibom	Abak	Otoro II	5.044663	7.794168
8600	Kaduna	Zaria	Limancin-Kona	11.027381	7.697300
8601	Osun	Ila	Ajaba/Edemosi/Aba Orangun	7.920292	4.902856
8602	Bauchi	Gamawa	Tarmasuwa	11.778800	10.774123
8603	Cross River	Odukpani	Ito/idere/Ukwa	5.437656	7.959022
8604	Katsina	Dutsi	Sirika A	12.998003	8.135957
8605	Rivers	Port Harcourt	Rumuwoji (One)	4.754896	6.993465
8606	Oyo	Ibadan North East	Ward VI E5B	7.372306	3.914158
8607	Sokoto	Gwadabaw	Salame	13.450396	5.389009
8608	Yobe	Fika	Shoye/Garin Aba	11.347683	11.161267
8609	Benue	Kwande	tondov II	6.753715	9.526259
8610	Osun	Ifedayo	Balogun	7.916940	4.985087
8611	Katsina	Kankiya	Galadima 'A'	12.548134	7.809954
8612	Gombe	Yalmatu / Deba	Hinna	10.310731	11.570884
8613	Imo	Ihitte-Uboma Isinweke	Dimneze	5.684951	7.373954
8614	Lagos	Lagos Island	Oju-Oto	6.469315	3.388244
8615	Jigawa	Sule Tankarkar	Sule-Tankarkar	12.675290	9.240167
8616	Benue	Buruku	Mbaade	7.142839	9.189426
8617	Katsina	Kankiya	Tafashiya/Nasarawa	12.490825	7.824627
8618	Ondo	Ifedore	Ipogun/Ibule	7.292468	5.067231
8619	Akwa Ibom	Oron	Oron Urban  IX	4.790265	8.220346
8620	Bauchi	Gamjuwa	Kariya	10.774073	9.865011
8621	Oyo	Ibarapa East	Anko	7.547069	3.419934
8622	Edo	Etsako East	Okpella III	7.322288	6.412882
8623	Abia	Isiala Ngwa South	Ngwaobi	5.276392	7.325417
8624	Taraba	Sardauna	Nguroje	7.140933	11.144636
8625	Cross River	Akpabuyo	Ikot Nakanda	4.838166	8.414384
8626	Benue	Gwer West	Ityoughatee/Injaha	7.744577	8.336753
8627	Oyo	Iseyin	Ladogan/Oke Eyin	8.000583	3.508427
8628	Oyo	Ibadan North West	Ward 7 NW4	7.385810	3.881333
8629	Kogi	Kabba-Bunu	Iluke	8.180864	6.169798
8630	Rivers	Oyigbo	Oyigba west	4.888279	7.121722
8631	Niger	Gbako	Gbadafu	9.162989	5.871215
8632	Kano	Albasu	Bataiya	11.653625	9.029961
8633	Rivers	Akukutor	Alise Group	4.698298	6.745789
8634	Oyo	Ibadan South East	S. 2B	7.350218	3.906200
8635	Oyo	Ibadan North East	Ward III. E3	7.364051	3.915399
8636	Edo	Ovia North East	Okokhuo	6.651917	5.582915
8637	Adamawa	Mayo-Belwa	Bajama	9.078639	11.916382
8638	Sokoto	Gwadabaw	Gwadabawa	13.367661	5.247690
8639	Sokoto	Tangazar	Gidan Madi	13.301759	4.869320
8640	Taraba	Donga	Nyita	7.442115	10.322172
8641	Katsina	Malumfashi	Yarmama	11.872725	7.678773
8642	Akwa Ibom	Mkpat Enin	Ukpum Minya II	4.645760	7.722024
8643	Niger	Suleja	Bagmama 'A'	9.179969	7.152996
8644	Enugu	Nsukka	Ibeku	6.773078	7.419611
8645	Katsina	Kankara	Dan'maidaki	11.854624	7.443993
8646	Ebonyi	Ohaozara	Uhuotaru Ugwulangwu	5.991284	7.886402
8647	Ondo	Akoko South-West	Oka V A Owalusin/Ayepe	7.450322	5.754103
8648	Bauchi	Kirfi	Dewu Central	10.511084	10.495558
8649	Nassarawa	Karu	Karshi I	8.884594	7.600316
8650	Delta	Ethiope West	Jesse IV	5.801545	5.854383
8651	Akwa Ibom	Essien Udim	Ukana West II	5.119407	7.695851
8652	Sokoto	Dange-Shuni	Tuntube/Tsehe	12.946604	5.304355
8653	Anambra	Awka South	Nise  II	6.165806	7.035133
8654	Rivers	Ikwerre	Elele I	5.092879	6.842653
8655	Anambra	Onitsha North	Inland Town I	6.106943	6.777454
8656	Kogi	Mopa-Muro	Odole I	7.914150	5.814186
8657	Nassarawa	Doma	Alagye	8.401857	8.205112
8658	Imo	Oru-East	Akata	5.750527	6.972730
8659	Adamawa	Hong	Thilbang	10.184704	12.941996
8660	Niger	Paikoro	Adunu	9.540233	7.221693
8661	Jigawa	Roni	Zugai	12.529529	8.332629
8662	Kebbi	Bagudo	Bani/Tsamiya/Kali	11.330529	3.706169
8663	Plateau	Kanam	Jom	9.436165	10.087339
8664	Kaduna	Kauru	Kwassam	10.421968	8.268084
8665	Delta	Warri South	G.R.A.	5.525359	5.750679
8666	Cross River	Etung	Nsofang	5.769332	8.641556
8667	Kano	Tofa	Yalwa Karama	12.039796	8.309015
8668	Benue	Apa	Auke	7.477879	7.824345
8669	Kogi	Okene	Obehira Uvetta	7.524846	6.160528
8670	Ebonyi	Ebonyi	Enyibichiri I	6.669521	8.141179
8671	Lagos	Lagos Island	Sandgrouse	6.450101	3.401067
8672	Borno	Bayo	Teli	10.440779	11.747240
8673	Lagos	Ikorodu	Aga/Ijimu	6.612490	3.514834
8674	Kano	Gwarzo	Gwarzo	11.914107	7.927827
8675	Bauchi	Jama'are	Hanafari	11.589892	9.890916
8676	Niger	Agaie	Boku	9.019971	6.451867
8677	Anambra	Nnewi South	Amichi  II	5.957143	6.958867
8678	Cross River	Abi	Afafanyi/Igonigoni	5.874033	7.974741
8679	Kano	Bunkure	Gurjiya	11.740911	8.529756
8680	Ondo	Akure South	Ijomu/Obanla	7.256176	5.193390
8681	Oyo	Ibadan South West	Ward 6  SW5	7.376853	3.884612
8682	Anambra	Awka South	Mba-ukwu	6.121911	7.058106
8683	Plateau	Jos North	Jos Jarawa	9.889590	8.931791
8684	Kaduna	Kaura	Agban	9.546306	8.353746
8685	Cross River	Etung	Bendeghe Ekiem	6.002793	8.846873
8686	Akwa Ibom	Ikono	Ikono Middle IV	5.302434	7.762449
8687	Oyo	Iwajowa	Sabi Gana III	7.956393	3.235375
8688	Ogun	Ijebu-Ode	Porogun II	6.853296	3.924168
8689	Katsina	Baure	Garki	12.811234	8.818616
8690	Enugu	Nsukka	Okpuje/Okutu/Anuka	6.912772	7.240287
8691	Niger	Paikoro	Kwagana	9.567651	7.111630
8692	Niger	Rafi	Kakuri	9.995520	6.423931
8693	Kebbi	Bagudo	Illo/Sabon/Gari/Yantau	11.524163	3.738484
8695	Anambra	Awka North	Ebenebe  III	6.310502	7.137876
8696	Jigawa	Kirika Samma	Tarabu	12.500543	10.128555
8697	Bauchi	Misau	Sarma/Akuyam	11.456179	10.685191
8698	Plateau	Mangu	Kadun	9.692824	9.134952
8699	Bauchi	Tafawa-Balewa	Bula	9.819637	9.572334
8700	Akwa Ibom	Ibiono Ibom	Ibiono Central I	5.193728	7.873296
8701	Delta	Warri South-West	Ogbe - Ijoh	5.438874	5.704222
8702	Jigawa	Gagarawa	Gagarawa Gari	12.408967	9.546035
8703	Jigawa	Biriniwa	Birniwa	12.785760	10.227805
8704	Ekiti	Ekiti West	Erijiyan II	7.611949	5.043080
8705	Osun	Irewole	Ikire 'D'	7.389881	4.192808
8706	Kano	Madobi	Burji	11.898478	8.390765
8707	Adamawa	Mayo-Belwa	Mayo Farang	8.873025	12.153922
8708	Kaduna	Sabon Gari	Jama'a	11.139759	7.655106
8709	Nassarawa	Doma	Madaki	8.357630	8.423825
8710	Imo	Ikeduru	Amakohia	5.503189	7.197079
8711	Katsina	Danmusa	Yan-Tumaki B	12.201956	7.441031
8712	Jigawa	Hadejia	Atafi	12.432015	10.059973
8713	Osun	Boripe	Ororuwo	7.857116	4.701468
8714	Kano	Gwale	Mandawari	11.977362	8.493069
8715	Kwara	Kaiama	Kaiama I	9.663755	4.013179
8716	Kaduna	Chikun	Chikun	10.120923	7.058980
8717	Ogun	Odogbolu	Imosan	6.866894	3.860363
8718	Kano	Kiru	Yako	11.630075	8.190825
8719	Kwara	Ifelodun	Ile-Ire	8.510960	5.109049
8720	Kaduna	Giwa	Galadimawa	11.061226	7.353575
8721	Ondo	Ose	Imeri	7.318931	5.938506
8722	Kwara	Edu	Tsaragi I	8.919984	4.969965
8723	Ekiti	Ekiti East	Kota II	7.782933	5.664085
8724	Anambra	Ogbaru	Okpoko III	6.028609	6.760964
8725	Lagos	Ikorodu	Baiyeku/Oreta	6.558595	3.520798
8726	Borno	Kukawa	Bundur	12.866856	13.588362
8727	Kogi	Okene	Obehira Eba	7.507976	6.149407
8728	Edo	Egor	Uselu I	6.363856	5.602069
8729	Zamfara	Zurmi	Galadima/Yanruwa	12.854897	6.483534
8730	Niger	Lapai	Kudu/Gabas	9.060987	6.610719
8731	Katsina	Kurfi	Tsauri 'A'	12.809134	7.502768
8732	Benue	Apa	Ugbokpo	7.678141	7.924203
8733	Ondo	Akoko South-East	Sosan	7.418850	5.926896
8734	Sokoto	Dange-Shuni	Rikina	12.970938	5.353262
8735	Katsina	Baure	Taramnawa/Bare	12.814363	8.911402
8736	Ogun	Abeokuta North	Ago Oko	7.184299	3.307576
8737	Enugu	Nkanu East	Mburubu	6.183802	7.626975
8738	Taraba	Wukari	Avyi	7.893898	9.767275
8739	Sokoto	Gada	Kyadawa/Holai	13.751204	5.562362
8740	Kano	Tundun Wada	Nata'ala	11.281458	8.543867
8741	Edo	Igueben	Okalo/ Okpujie	6.522137	6.223307
8742	Katsina	Ingawa	Jobe/Kandawa	12.603601	8.000210
8743	Sokoto	Bodinga	Kwacciyar Lalle	12.843799	5.277937
8744	Kebbi	Shanga	Takware	11.341512	4.694515
8745	Nassarawa	Kokona	Kokona	8.796224	8.015140
8746	Kebbi	Zuru	Rumu/Daben/Seme	11.443893	5.205237
8747	Bauchi	Katagum	Tsakuwa Kofar Gabas/ Kofar Kuka	11.688999	10.197209
8748	Borno	Guzamala	Guzamala East	12.691672	13.366803
8749	Ekiti	Ilejemeje	Ipere	7.889984	5.244407
8750	Borno	Gubio	Gamowo	12.585565	12.470244
8751	Kwara	Ifelodun	Idofian I	8.332893	4.751890
8752	Anambra	Ayamelum	Omor II	6.530465	6.935467
8753	Borno	Kala/Balge	Kala	11.960965	14.474314
8754	Edo	Owan East	Emai II	6.955622	6.002903
8755	Adamawa	Yola South	Mbamba	9.181071	12.690257
8756	Lagos	Eti-Osa	Lekki/Ikate and Environs	6.453945	3.508642
8757	Katsina	Danmusa	Yan-Tumaki A	12.215698	7.491724
8758	Anambra	Idemili North	Obosi	6.095142	6.824342
8759	Zamfara	Bukkuyum	Kyaram	11.790779	5.570888
8760	Kebbi	Gwandu	Gwandu Marafa	12.518036	4.661021
8761	Cross River	Bakassi	Akpankanya	4.751470	8.484195
8762	Kano	Kumbotso	Chiranchi	11.907672	8.456935
8763	Imo	Ehime-Mbano	Umueze I	5.650625	7.271619
8764	Akwa Ibom	Etinan	Etinan Urban IV	4.862830	7.818264
8765	Kaduna	Zangon Kataf	Gora	9.916464	8.296669
8766	Delta	Ndokwa East	Ibedeni	5.382831	6.370728
8767	Osun	Boripe	Isale Asa Iree	7.902176	4.734881
8768	Anambra	Ogbaru	Iyiowa/Odekpe/Ohita	5.990768	6.758237
8769	Ogun	Remo North	Igan/Ajina	6.957041	3.748270
8770	Imo	Aboh-Mbaise	Ibeku	5.460492	7.256579
8771	Borno	Chibok	Kuburmbula	10.905351	12.965642
8772	Imo	Ikeduru	Iho	5.567169	7.120326
8773	Anambra	Ihiala	Uzoakwa	5.839125	6.841443
8774	Imo	Nkwerre	Nkwerre V	5.746068	7.148626
8775	Osun	Odo Otin	Igbaye	8.026255	4.646494
8776	Oyo	Iseyin	Ekunle II	7.837403	3.658576
8777	Imo	Njaba	Nkume	5.727806	7.004849
8778	Jigawa	Kirika Samma	Madachi	12.563727	10.238283
8779	Jigawa	Sule Tankarkar	Amanga	12.639600	9.115606
8780	Borno	Hawul	Hizhi	10.511419	12.304568
8781	Kogi	Kabba-Bunu	Olle/Oke-Ofin	8.063600	6.107233
8782	Bauchi	Tafawa-Balewa	Kardam "B"	9.754907	9.247177
8783	Cross River	Ikom	Nta/Nselle	6.170698	8.492770
8784	Delta	Uvwie	Army Barracks Area	5.591492	5.768917
8785	Borno	Kaga	Benisheikh	11.810916	12.496072
8786	Abia	Ukwa East	Ikwuorie	4.938443	7.321919
8787	Ogun	Imeko-Afon	Idofa	7.901019	2.766887
8788	Oyo	Atiba	Agunpopo II	8.016979	4.017612
8789	Imo	Ihitte-Uboma Isinweke	Atonerim	5.599940	7.314827
8790	Delta	Ukwuani	Obiaruku  I	5.838558	6.135042
8791	Kaduna	Ikara	Kuya	11.449415	8.090527
8792	Jigawa	Kaugama	Yalo	12.337994	9.628023
8793	Lagos	Badagary	Awhanjigoh	6.410077	2.923594
8794	Federal Capital Territory	Kwali	Kundu	8.862017	6.894744
8795	Lagos	Ikorodu	Agbala	6.644657	3.507818
8796	Akwa Ibom	Uyo	Offot I	5.007738	7.884391
8797	Borno	Mobbar	Kareto	13.215955	12.846679
8798	Bauchi	Giade	Zabi	11.509971	10.305177
8799	Lagos	Apapa	Afolabi Alasia str. And Environs	6.463308	3.352278
8800	Kebbi	Yauri	Gungun Sarki	10.897701	4.792542
8801	Bauchi	Gamawa	Alagarno/Jadori	12.206105	10.615329
8802	Bauchi	Itas/Gadau	Mashema	11.810177	9.930362
8803	Enugu	Udi	Abia	6.340190	7.404896
8804	Ebonyi	Ikwo	Ndufu Alike	6.144467	8.166958
8805	Rivers	Etche	Egwi/Opiro	5.005624	7.025737
8806	Bauchi	Ningi	Dingis	11.140202	9.508557
8807	Plateau	Mikang	Lalin	9.037257	9.690506
8808	Jigawa	Babura	Kyambo	12.509437	8.723797
8809	Sokoto	Wamakko	G/Bubu/G/Yaro	13.073589	5.175986
8810	Kaduna	Lere	Kayarda	10.559718	8.575667
8811	Anambra	Anaocha	Agulu  I	6.082069	7.039347
8812	Akwa Ibom	Urue Offong|Oruko	Urue Offong I	4.769547	8.191966
8813	Ogun	Ipokia	Mauni II	6.678741	2.792384
8814	Rivers	Bonny	Ward III Orosiriri	4.439190	7.173933
8815	Yobe	Nangere	Tikau	11.774649	11.115698
8816	Benue	Guma	Uvir	7.971513	8.844309
8817	Taraba	Takum	Bikashibila	7.267550	10.029165
8818	Akwa Ibom	Nsit Atai	Eastern Nsit II	4.801868	8.048444
8819	Taraba	Ardo-Kola	Sunkani	9.012257	11.077864
8820	Niger	Agaie	Ekowuna	9.003337	6.335803
8821	Anambra	Anaocha	Neni  II	6.071513	6.980846
8822	Borno	Dikwa	Mallam Maja	12.054857	14.072767
8823	Borno	Ngala	Gamboru 'C'	12.277636	14.280536
8824	Benue	Konshisha	Tse-Agberagba	7.043624	8.705192
8825	Enugu	Awgu	Obeagu	6.132444	7.404261
8826	Zamfara	Bungudu	Gada / Karakkai	12.267545	6.457970
8827	Ogun	Ijebu East	Owu	6.832517	4.352922
8828	Jigawa	Sule Tankarkar	Albasu	12.554635	9.053723
8829	Federal Capital Territory	Bwari	Kurudu	9.262012	7.334193
8830	Jigawa	Gagarawa	Yalawa	12.456698	9.513259
8831	Akwa Ibom	Abak	Abak Urban III	4.955080	7.772569
8832	Kwara	Oyun	Inaja/Ahogbada	8.070339	4.553919
8833	Kebbi	Argungu	Gwazange/Kisawa/Ugyaga	12.712901	4.563740
8834	Osun	Atakumosa West	Oke Bode	7.683350	4.608362
8835	Oyo	Ibadan South East	S 6A	7.343660	3.907615
8836	Adamawa	Ganye	Timdore	8.429076	11.990437
8837	Borno	Kwaya Kusar	Peta	10.385749	11.954381
8838	Imo	Ikeduru	Avuvu	5.505696	7.156414
8839	Oyo	Ido	Batake/Idi-Iya	7.630742	3.665824
8840	Kebbi	Birnin Kebbi	Kardi/Yamama	12.344014	4.251378
8841	Jigawa	Yankwashi	Ringim	12.659241	8.549264
8842	Federal Capital Territory	Abaji	Abaji South East	8.456669	6.949097
8843	Plateau	Mangu	Gindiri  II	9.615205	9.244302
8844	Osun	Orolu	Olufon Orolu  'B'	7.856160	4.478788
8845	Oyo	Ibadan South East	S 2A	7.356726	3.912121
8846	Katsina	Kaita	Kaita	13.115812	7.746607
8847	Sokoto	Sokoto South	T/Wada 'A'	13.039326	5.292211
8848	Niger	Bosso	Beji	9.625123	6.310162
8849	Katsina	Baure	Unguwar Rai	12.729906	8.815985
8850	Anambra	Dunukofia	Ukwulu  I	6.273547	6.947530
8851	Delta	Oshimili North	Ibusa  II	6.173229	6.621913
8852	Akwa Ibom	Etim Ekpo	Etim Ekpo II	5.007621	7.639926
8853	Ekiti	Ekiti East	Araromi Omuo	7.757511	5.727614
8854	Ogun	Abeokuta North	Ibara Orile/Onisasa	7.159251	3.216294
8855	Kebbi	Shanga	Atuwo	11.389607	4.764691
8856	Yobe	Nguru	Kanuri	12.877135	10.471175
8857	Imo	Ahiazu-Mbaise	Ogbe	5.513325	7.303353
8858	Bauchi	Jama'are	Jama'are "C"	11.652515	9.910759
8859	Benue	Ado	Igumale II	6.819231	7.987115
8860	Edo	Akoko Edo	Igarra I	7.299464	6.079932
8861	Ekiti	Ado-Ekiti	Ado 'M' Farm Settlement	7.601360	5.142124
8862	Edo	Egor	Ogida/Use	6.360821	5.563019
8863	Benue	Ohimini	Oglewu Icho	7.203241	8.041576
8864	Kwara	Edu	Lafiagi IV	8.926731	5.355549
8865	Bauchi	Alkaleri	Gwana / Mansur	9.605601	10.638898
8866	Ekiti	Irepodun-Ifelodun	Iyin II	7.628039	5.117951
8867	Imo	Okigwe	Agbobu	5.866801	7.271535
8868	Kaduna	Sabon Gari	Unguwan Gabas	11.095066	7.718121
8869	Kano	Rano	Rurum Tsohon-Gari	11.412481	8.418972
8870	Gombe	Dukku	Zaune	11.105410	10.864525
8871	Adamawa	Mubi North	Yelwa	10.185237	13.285506
8872	Rivers	Andoni/Odual	Asarama	4.578281	7.406402
8873	Adamawa	Mubi North	Bahuli	10.289702	13.429193
8874	Benue	Ohimini	Ehatokpe	7.243005	7.988836
8875	Ondo	Ifedore	Isarun/ Erigi	7.391862	5.044363
8876	Enugu	Nkanu East	Amechi/Idodo/Oruku	6.421394	7.680478
8877	Bauchi	Dass	Bununu South	9.938430	9.516649
8878	Kogi	Olamaboro	Olamaboro i	7.278808	7.610942
8879	Adamawa	Demsa	Nassarawo Demsa	9.296248	12.150069
8880	Zamfara	Bakura	Birnin Tudu	12.639138	6.066051
8881	Delta	Ndokwa West	Utagba  Uno  II	5.966391	6.295539
8882	Imo	Mbaitoli	Umunoha/Azara	5.598317	6.977839
8883	Benue	Ogbadibo	Ehaje I	6.919229	7.678523
8884	Yobe	Fune	Jajere/Banellewa/Babbare	12.006486	11.421408
8885	Katsina	Kusada	Bauranya 'B'	12.417619	8.039090
8886	Edo	Oredo	Ibiwe/ Iwegie/ Ugbague	6.285372	5.579909
8887	Abia	Ukwa West	Ipu West	4.953593	7.254344
8888	Oyo	Oluyole	Odo-Ona Nla	7.248426	3.876459
8889	Niger	Muya	Beni	9.648293	7.114174
8890	Yobe	Karasuwa	Garin Gawo	12.892648	10.723636
8891	Edo	Etsako East	Okpella II	7.267435	6.264872
8892	Federal Capital Territory	Gwagwalada	Ikwa	9.127375	7.042442
8893	Gombe	Dukku	Zange	10.571596	10.832449
8894	Imo	Isu	Isu-Njaba II	5.709544	7.075313
8895	Kwara	Irepodun	Oko	8.169289	5.173520
8896	Ondo	Irele	Akotogbo II	6.355872	4.991148
8897	Sokoto	Wurno	Chacho/Marnona	13.247435	5.622963
8898	Enugu	Awgu	Ihe	6.226274	7.460818
8899	Ondo	Akure North	Agamo/Oke-Oore/Akomowa	7.378093	5.203926
8900	Kaduna	Kajuru	Maro	10.105798	7.733648
8901	Borno	Damboa	Kafa / Mafi	11.331958	12.442709
8902	Anambra	Awka South	Awka  V	6.199698	7.085239
8903	Oyo	Ona-Ara	Akanran/Olorunda	7.275554	4.034829
8904	Kogi	Ofu	Aloji	7.347178	6.876867
8905	Lagos	Eti-Osa	Ilasan Housing Estate	6.430858	3.520123
8906	Kano	Tofa	Unguwar Rimi	11.958163	8.317831
8907	Adamawa	Gombi	Gombi North	10.209925	12.807300
8908	Niger	Rijau	Warari	10.858225	5.313652
8909	Kaduna	Igabi	Rigachiku	10.568141	7.531768
8910	Adamawa	Numan	Numan III	9.464541	12.128575
8911	Rivers	Andoni/Odual	Ataba  II	4.589254	7.322993
8912	Rivers	Ahoada East	Akoh  II	5.152957	6.678478
8913	Katsina	Dutsi	Dan Aunai	12.860394	8.189303
8914	Osun	Osogbo	Baba Kekere	7.747734	4.609081
8915	Cross River	Bekwarra	Gakem	6.779335	8.947693
8916	Osun	Atakumosa West	Muroko	7.669075	4.653454
8917	Ondo	Irele	Irele IV	6.492934	4.902298
8918	Benue	Oju	Okwudu	6.792773	8.302104
8919	Zamfara	Kaura-Namoda	Gabake	12.604238	6.678253
8920	Ebonyi	Ikwo	Ndiagu Amagu I	6.005459	8.107525
8921	Taraba	Wukari	Hospital	7.853773	9.763620
8922	Jigawa	Dutse	Sakwaya	11.732352	9.225847
8923	Jigawa	Jahun	Kanwa	11.951509	9.426261
8924	Kwara	Ilorin West	Oko-Erin	8.448982	4.559456
8925	Kano	Tarauni	Kauyen  Alu	11.951648	8.534865
8926	Rivers	Bonny	Ward IV New Layout	4.426117	7.169648
8927	Kwara	Asa	Ogele	8.408607	4.501192
8928	Anambra	Ekwusigo	Amakwa  II	5.959655	6.828757
8929	Delta	Ndokwa West	Ogume  II	5.733560	6.352383
8930	Enugu	Ezeagu	Imezi Owa I	6.371311	7.341649
8931	Kaduna	Chikun	GwaGwada	10.211210	7.342871
8932	Sokoto	Gwadabaw	Asara Kudu	13.463992	5.293247
8933	Rivers	Andoni/Odual	Ngo Town	4.462683	7.419069
8934	Niger	Paikoro	Kafin Koro	9.520421	7.047595
8935	Bauchi	Warji	Dagu West	11.115123	9.658896
8936	Kaduna	Birnin Gwari	Kutemesi	11.151696	7.036626
8937	Osun	Ifelodun	Amola Ikirun	7.904427	4.687514
8938	Lagos	Ikeja	Alausa/Oregun/Olusosun	6.614981	3.354280
8939	Plateau	Wase	Bashar	9.238654	10.185704
8940	Benue	Vandeikya	Mbagbam	6.881572	9.163868
8941	Oyo	Oluyole	Muslim/Ogbere	7.323427	3.936729
8942	Plateau	Qua'anpa	Bwall	8.889346	9.123527
8943	Osun	Ede South	Alajue II	7.646352	4.528094
8944	Jigawa	Ringim	Kafin babushe	12.249577	9.010422
8945	Akwa Ibom	Nsit Ibom	Mbaiso III	4.869115	7.886405
8946	Edo	Esan West	Egoro/Idoa/Ukhun	6.791650	6.136599
8947	Lagos	Mushin	Idi-Araba	6.537658	3.348620
8948	Yobe	Jakusko	Muguram	12.316387	11.060485
8949	Abia	Ikwuano	Oboro IV	5.410085	7.572096
8950	Katsina	Kankara	Kankara A&B	11.940793	7.434046
8951	Benue	Obi	Itogo	7.030249	8.325437
8952	Plateau	Langtang North	Kwande	9.186911	9.793312
8953	Cross River	Ikom	Ofutop I	5.880040	8.589228
8954	Kaduna	Chikun	Rido	10.396244	7.582479
8955	Delta	Oshimili South	Umuaji	6.172980	6.711586
8956	Adamawa	Jada	Jada II	8.767084	12.376424
8957	Sokoto	Tureta	Gidan Kare/Bimasa	12.626877	5.621750
8958	Rivers	Abua/Odu	Otapha	4.828862	6.677883
8959	Taraba	Ardo-Kola	Lamido Borno	8.856258	11.332455
8960	Rivers	Tai	Ward IV Koroma/Horo	4.761668	7.282915
8961	Oyo	Lagelu	Lalupon I	7.463370	4.106928
8962	Bauchi	Dass	Polchi	10.073922	9.435590
8963	Ebonyi	Ohaukwu	Wigbeke III	6.636111	8.063112
8964	Anambra	Idemili North	Uke	6.103070	6.915366
8965	Enugu	Oji-River	Awlaw	6.063868	7.309747
8966	Ogun	Ado Odo-Ota	Ketu-Adie-Owe	6.589367	2.990694
8967	Kebbi	Aleiro	Jiga Makera	12.204779	4.546170
8968	Yobe	Gujba	Buniyadi North / South	11.271965	12.028347
8969	Abia	Aba South	Gloucester	5.094715	7.370499
8970	Kano	Gaya	Gamarya	11.864353	8.924332
8971	Kaduna	Kagarko	Kushe	9.471206	7.769574
8972	Enugu	Igbo-eze North	Ette II	7.088867	7.430295
8973	Delta	IkaSouth	Abavo III	6.138196	6.177009
8974	Kano	Kiru	Maraku	11.663773	8.103637
8975	Zamfara	Gummi	Gyalange	12.085870	5.163364
8976	Lagos	Ikorodu	Isele II	6.615257	3.505561
8977	Edo	Etsako Central	South Uneme II	6.892776	6.630481
8978	Borno	Jere	Dusuman	11.859913	13.357174
8979	Osun	Egbedore	Ojo/Aro	7.820168	4.440432
8980	Nassarawa	Keffi	Gangare Tudu	8.835764	7.877530
8981	Ogun	Remo North	Ode II	7.001368	3.759092
8982	Nassarawa	Obi	Adudu	8.345263	8.983722
8983	Anambra	Anaocha	Adazi Ani II	6.052965	6.965291
8984	Delta	Ethiope West	Oghara IV	5.983770	5.605569
8985	Akwa Ibom	Onna	Oniong west I	4.613144	7.828120
8986	Borno	Kaga	Marguba	11.743017	12.624077
8987	Ekiti	Ekiti South West	Ilawe IV	7.452108	5.055825
8988	Bauchi	Tafawa-Balewa	Kardam "A"	9.825342	9.362359
8989	Sokoto	Illela	Kalmalo	13.701349	5.225719
8990	Enugu	Enugu North	Independence Layout	6.432412	7.571266
8991	Abia	Umuahia North	Ndume	5.508506	7.539760
8992	Ekiti	Oye	Ayede South Itaji	7.918438	5.284309
8993	Kano	Ajingi	Gurduba	12.034535	8.987778
8994	Plateau	Wase	Kumbur	8.858808	9.917641
8995	Osun	Olorunda	Balogun	7.774623	4.545884
8996	Katsina	Kankiya	Gachi	12.563036	7.887818
8997	Jigawa	Kirika Samma	Bulunchai	12.619666	10.210445
8998	Katsina	Rimi	Rimi	12.852414	7.704110
8999	Jigawa	Garki	Buduru	12.374768	9.281703
9000	Niger	Mokwa	Bokani	9.433948	5.230949
9001	Abia	Isiala Ngwa North	Umunna Nsulu	5.398380	7.479024
9002	Kano	Kabo	Hauwade	11.881692	8.249748
9003	Niger	Tafa	Iku	9.225526	7.213531
9004	Anambra	Dunukofia	Akwa	6.207548	6.929336
9005	Lagos	Epe	Itoikin	6.659553	3.881711
9006	Edo	Owan West	Okpuje	7.016919	5.834309
9007	Niger	Mariga	Kontokoro	10.949466	5.997304
9008	Anambra	Ihiala	Mbosi	5.856989	6.899824
9009	Benue	Obi	Okpokwu	6.955033	8.324615
9010	Kebbi	Suru	Kwaifa	11.677072	4.215023
9011	Katsina	Kusada	Mawashi	12.523515	8.023185
9012	Lagos	Alimosho	Shasha/Akowonjo	6.600740	3.288293
9013	Kogi	Mopa-Muro	Aiyede/Okagi	8.266325	6.013558
9014	Kwara	Ilorin South	Akanbi I	8.381954	4.737933
9015	Katsina	Faskari	Maigora	11.524005	7.034463
9016	Osun	Egbedore	Ikotun	7.813401	4.383217
9017	Ogun	Ifo	Ifo III	6.763247	3.279287
9018	Kano	Dawakin Tofa	Tumfafi	12.129894	8.455901
9019	Katsina	Charanchi	Koda	12.618803	7.711769
9020	Ebonyi	Ezza North	Nkomoro	6.244036	7.918908
9021	Ebonyi	Abakalik	Okpoitumo Ndebor	6.266360	8.226795
9022	Yobe	Karasuwa	Fajiganari	12.995367	10.782605
9023	Edo	Esan West	Ujiogba	6.523690	6.102204
9024	Kano	Madobi	Kaura Mata	11.851335	8.466010
9025	Bauchi	Darazo	Wahu	11.380618	10.690204
9026	Rivers	Khana	Lorre/Luebe/Kpaa	4.773530	7.480024
9027	Jigawa	Auyo	Ayama	12.267715	9.827448
9028	Imo	Aboh-Mbaise	Uvuru II	5.343413	7.272074
9029	Bayelsa	Yenagoa	Gbarain II	5.066964	6.339631
9030	Ogun	Ewekoro	Arigbajo	6.876943	3.284147
9031	Imo	Nwangele	Abajah ward I	5.663275	7.099014
9032	Akwa Ibom	Onna	Oniong east III	4.561541	7.862682
9033	Sokoto	Gudu	Awulkiti	13.618191	4.438716
9034	Osun	Ede North	Isibo/Buari-Isola	7.706464	4.465456
9035	Taraba	Ussa	Lissam I	7.215315	10.080781
9036	Abia	Ugwunagbo	Ward Nine	4.990323	7.301807
9037	Rivers	Ogu/Bolo	Ogu  II	4.684517	7.212354
9038	Sokoto	Isa	Tozai	13.262610	6.438580
9039	Oyo	Kajola	Olele	8.036876	3.410674
9040	Kano	Garum Mallam	Makwaro	11.715498	8.356558
9041	Adamawa	Yola South	Bako	9.173948	12.616431
9042	Osun	Atakumosa East	Ajebandele	7.415295	4.755429
9043	Delta	Okpe	Orerokpe	5.636160	5.893510
9044	Ekiti	Ise-Orun	Erinwa II	7.422757	5.345743
9045	Borno	Abadam	Malam Kaunari	13.693794	13.341149
9046	Akwa Ibom	Ini	Usuk  Ukwok	5.307368	7.807616
9047	Bauchi	Itas/Gadau	Kashuri	11.830556	10.341321
9048	Kaduna	Sanga	Fadan Karshi	9.370363	8.556217
9049	Ekiti	Ekiti South West	Igbara Odo II	7.462237	4.992942
9050	Zamfara	Tsafe	Yankuzo "A"	11.878052	7.093519
9051	Lagos	Lagos Mainland	Otto/Iddo	6.474244	3.374633
9052	Ondo	Ondo West	Enuowa/Obalalu	7.055456	4.804421
9053	Katsina	Dutsi	Dutsi B	12.830319	8.101134
9054	Akwa Ibom	Essien Udim	Ekpeyong I	5.069107	7.652980
9055	Osun	Boluwaduro	Gbeleru Obaala II	7.877745	4.807715
9056	Sokoto	Sokoto South	T/Wada 'B'	13.012783	5.272753
9057	Cross River	Obubra	Ofat	5.908074	8.230872
9058	Kano	Dawakin Kudu	Danbagiwa	11.790252	8.767721
9059	Ogun	Abeokuta South	Ijaye/Idi-Aba	7.161596	3.396991
9060	Lagos	Epe	Poka	6.618096	3.985497
9061	Osun	Orolu	Olufon Orolu 'I'	7.914755	4.513666
9062	Osun	Atakumosa West	Ifelodun	7.534726	4.716487
9063	Abia	Oboma Ngwa	Ndiarata / Amairinabua	5.133615	7.504387
9064	Ekiti	Ilejemeje	Ewu	7.930867	5.158372
9065	Imo	Isu	Amurie Omanze I	5.651930	7.070430
9066	Bayelsa	Ekeremor	Oyiakiri II	5.043632	5.842474
9067	Adamawa	Teungo	Kongin Baba I	7.952510	11.589178
9068	Adamawa	Maiha	Konkol	9.637611	13.207995
9069	Oyo	Ona-Ara	Gbada Efon	7.278679	4.080732
9070	Rivers	Okrika	Okrika VI	4.625735	7.102653
9071	Ekiti	Ekiti South West	Ogotun I	7.523089	4.960366
9072	Ekiti	Moba	Osan	8.006577	5.067152
9073	Borno	Biu	Garubula	10.692214	12.013163
9074	Akwa Ibom	Essien Udim	Ekpeyong II	5.055111	7.677503
9075	Bauchi	Warji	Ranga	11.180104	9.741588
9076	Sokoto	Kware	G. Rugga	13.108258	5.260853
9077	Ekiti	Ekiti South West	Igbara Odo I	7.498173	5.036062
9078	Cross River	Bekwarra	Ugboro	6.701692	8.858685
9079	Enugu	Igbo-eze North	Umuozzi Iv	6.970171	7.527591
9080	Sokoto	Binji	Bingaje	13.151132	5.019729
9081	Kogi	Lokoja	Lokoja-D	7.865999	6.615383
9082	Sokoto	Sabon Birni	Gangara	13.365522	6.515118
9083	Katsina	Kankara	Dan Murabu	11.986743	7.436597
9084	Imo	Ikeduru	Amaimo	5.570146	7.217759
9085	Rivers	Emuoha	Egbeda	5.213292	6.745337
9086	Edo	Esan Centtral	Ugbegun	6.617041	6.184490
9087	Federal Capital Territory	Kuje	Kuje	8.841697	7.161110
9088	Osun	Boluwaduro	Iresi  I	7.924416	4.842061
9089	Katsina	Mani	Hamcheta	12.908874	7.949246
9090	Osun	Ifedayo	Akesin	7.992011	5.029162
9091	Oyo	Saki West	Sepeteri/Bapon	8.545651	3.263150
9092	Oyo	Saki East	Sepeteri IV	8.550765	3.641864
9093	Kwara	Pategi	Lade III	8.857370	5.537402
9094	Zamfara	Tsafe	Keta/Kizara	11.800507	6.751071
9095	Imo	Orlu	Amaifeke	5.818650	7.070148
9096	Bayelsa	Southern Ijaw	Olodiama I	4.778271	6.006396
9097	Ondo	Ose	Ifon I	6.936773	5.754837
9098	Kwara	Irepodun	Arandun	8.101861	4.935315
9099	Ondo	Ifedore	Ero/Ibuji/Mariwo	7.385841	5.104641
9100	Ekiti	Ado-Ekiti	Ado 'H' Ereguru	7.603399	5.234743
9101	Zamfara	Tsafe	Yandoton Daji	12.066055	6.851814
9102	Kano	Rogo	Rogo Ruma	11.579322	7.800606
9103	Kwara	Ifelodun	Share II	8.763161	4.942234
9104	Ogun	Obafemi-Owode	Egbeda	7.090502	3.313951
9105	Sokoto	Gada	Gilbadi	13.639087	5.890702
9106	Nassarawa	Kokona	Kofar Gwari	8.702527	8.008563
9107	Borno	Marte	Ngeleiwa	12.264277	14.023379
9108	Plateau	Shendam	Pangshom	8.936212	9.358087
9109	Katsina	Mani	Magami	12.838850	7.960136
9110	Rivers	Etche	Nihi	5.039073	7.010704
9111	Bauchi	Bogoro	Bogoro "D"	9.666874	9.554226
9112	Kogi	Ankpa	Ankpa Township	7.446082	7.613689
9113	Kogi	Okehi	Ohuepe/Omavi Uboro	7.649769	6.216949
9114	Enugu	Nsukka	Akpa/Ozzi	6.871082	7.303969
9115	Katsina	Kaita	Baawa	13.215187	7.884710
9116	Kaduna	Sanga	Aboro	9.393355	8.611462
9117	Bayelsa	Ogbia	Otuokpoti	4.804412	6.258409
9118	Anambra	Njikoka	Abagana  III	6.180354	6.968486
9119	Jigawa	Garki	Muku	12.470362	8.923545
9120	Akwa Ibom	Ikot Ekpene	Ikot Ekpene IV	5.138190	7.733884
9121	Kebbi	Suru	Bandan	11.770679	4.094864
9122	Kogi	Ogori Magongo	Okibo	7.439016	6.172554
9123	Jigawa	Buji	Churbun	11.613046	9.707389
9124	Kogi	Bassa	Ayede/Akakana	7.801876	7.038705
9125	Enugu	Igbo-eze North	Essodo III	7.007947	7.462302
9126	Benue	Oturkpo	Okete	7.286383	8.082636
9127	Anambra	Idemili South	Nnobi II	6.067299	6.925372
9128	Edo	Ovia North East	Iguoshodin	6.438893	5.492647
9129	Abia	Ugwunagbo	Ward Four	5.002259	7.373460
9130	Kogi	Igalamela-Odolu	Avrugo	6.973505	7.007755
9131	Jigawa	Babura	Batali	12.639033	8.773137
9132	Oyo	Lagelu	Ogunremi/Ogunsina	7.577867	4.046711
9133	Kebbi	Koko/Bes	Besse	11.264976	4.403254
9134	Ebonyi	Onicha	Enuagu-Onicha	6.070837	7.835315
9135	Adamawa	Numan	Gamadio	9.432276	11.735082
9136	Osun	Ife East	Modakeke I	7.349898	4.592768
9137	Borno	Konduga	Auno / Chabbol	11.889695	13.050852
9138	Kebbi	Aleiro	Aliero S/Fada II	12.318078	4.433693
9139	Yobe	Gulani	Gulani	10.716943	11.663187
9140	Enugu	Udenu	Ezimo	6.873288	7.552094
9141	Kebbi	Dandi	Bani Zumbu	11.624352	3.849093
9142	Taraba	Ibi	Dampar I	8.536561	10.128386
9143	Ekiti	Ekiti South West	Ilawe III	7.564311	5.100686
9144	Cross River	Ogoja	Ekajuk II	6.450368	8.691770
9145	Kogi	Dekina	Anyigba	7.474919	7.134244
9146	Kaduna	Kaduna South	Badiko	10.546999	7.434481
9147	Abia	Ukwa West	Ozaa  West	4.928559	7.273537
9148	Kogi	Lokoja	Oworo	7.986310	6.529550
9149	Nassarawa	Keffi	Angwan Iya I	8.857751	7.854653
9150	Lagos	Amuwo Odofin	Irede	6.417629	3.215067
9151	Rivers	Opobo/Nkoro	Kalaibiama II	4.493705	7.531342
9152	Enugu	Igbo-eze South	Amebo /Hausa/ Yoruba	6.928358	7.358130
9153	Bauchi	Jama'are	Jama'are "A"	11.666574	9.923839
9154	Osun	Iwo	Isale Oba  III	7.614725	4.214557
9155	Borno	Nganzai	Sabsabuwa	12.416331	13.179131
9156	Zamfara	Birnin Magaji	Kiyawa	12.435759	6.812481
9157	Ondo	Ondo East	Asantan Oja	7.178262	4.974043
9158	Edo	Owan West	Ukhuse -Osi	7.020845	5.931338
9159	Niger	Kontogur	Arewa	10.428310	5.468904
9160	Kaduna	Lere	Sabon Birni	10.360812	8.659681
9161	Oyo	Saki East	Sepeteri III	8.628527	3.643284
9162	Anambra	Awka North	Amansea	6.250092	7.106877
9163	Osun	Iwo	Gidigbo  III	7.638146	4.157364
9164	Borno	Kaga	Borgozo	11.666043	12.647914
9165	Akwa Ibom	Ukanafun	Ukanafun Urban	4.881175	7.542421
9166	Kaduna	Igabi	Sabon Birnin Daji	10.805827	7.367546
9167	Plateau	Pankshin	Kangshu	9.521112	9.308702
9168	Kwara	Ifelodun	Share V	8.952487	4.862480
9169	Adamawa	Lamurde	Gyawana	9.582381	11.989307
9170	Bauchi	Damban	Jalam Central	11.585669	10.888232
9171	Anambra	Ihiala	Uli  III	5.774245	6.836449
9172	Anambra	Onitsha South	Odoakpu  I	6.074916	6.763391
9173	Plateau	Jos East	Shere West	9.967276	8.998026
9174	Osun	Odo Otin	Okua/Ekusa	8.009806	4.638685
9175	Oyo	Iwajowa	Iwere-Ile III	7.896312	3.056906
9176	Delta	Uvwie	Ugboroke	5.551700	5.756943
9177	Ogun	Imeko-Afon	Afon	7.450924	2.929266
9178	Rivers	Abua/Odu	Abua I	4.800882	6.595126
9179	Lagos	Mushin	Olateju	6.553196	3.351059
9180	Kano	Bebeji	Durmawa	11.614999	8.236864
9181	Kano	Warawa	Tamburawar Gabas	11.923917	8.653602
9182	Kebbi	Bunza	Tilli/Hilema	12.231445	3.932324
9183	Osun	Ayedire	Oluponna  II	7.536242	4.154498
9184	Bauchi	Ningi	Burra / Kyata	10.909599	8.880378
9185	Plateau	Shendam	Derteng	8.867824	9.705803
9186	Plateau	Jos North	Ibrahim Katsina	9.928465	8.893221
9187	Oyo	Ibadan North East	Ward VIII E7 I	7.369120	3.923557
9188	Akwa Ibom	Eket	Urban III	4.634452	7.898818
9189	Bauchi	Shira	Faggo	11.374128	10.059191
9190	Ogun	Ogun Waterside	Lukogbe/Ilusin	6.471808	4.519879
9191	Katsina	Kurfi	Wurma 'B'	12.615429	7.419645
9192	Benue	Konshisha	Ikyurav/Mbatwer	6.940568	8.603860
9193	Imo	Ohaji-Egbema	Umuagwo	5.243751	6.967563
9194	Taraba	Bali	Bali B	7.926880	10.879423
9195	Kaduna	Kubau	Karreh	10.745223	8.350391
9196	Cross River	Akamkpa	Ojuk South	5.165487	8.587003
9197	Adamawa	Gombi	Duwa	10.076840	12.531468
9198	Imo	Mbaitoli	Ezinihitie Mbieri	5.544114	7.056178
9199	Ekiti	Ikere	Idemo	7.522788	5.205129
9200	Osun	Odo Otin	Esa Otun Baale Ode	7.995898	4.648980
9201	Kebbi	Arewa	Gorun Dikko	12.546917	4.043594
9202	Kano	Kano Municipal	Sharada	11.926413	8.468863
9203	Yobe	Fika	Ngalda/Dumbulwa	11.149199	11.506443
9204	Ogun	Odeda	Obantoko	7.378129	3.605650
9205	Kano	Rano	Rano	11.534624	8.551242
9206	Anambra	Onitsha South	Odoakpu VI	6.090563	6.748404
9207	Kogi	Igalamela-Odolu	Oforachi II	7.093006	6.951654
9208	Adamawa	Guyuk	Lokoro	9.834898	11.987383
9209	Anambra	Aguata	Igbo-Ukwu I	5.986754	6.987656
9210	Kano	Dala	Yalwa	11.998308	8.445966
9211	Adamawa	Gombi	Yang	10.106946	12.379858
9212	Kogi	Ankpa	Enjema I	7.512812	7.560549
9213	Anambra	Ihiala	Isseke	5.828976	6.915126
9214	Lagos	Epe	Etita/Ebode	6.586771	3.980439
9215	Cross River	Obanliku	Bishiri South	6.650488	9.237870
9216	Plateau	Kanke	Nemel	9.476583	9.471614
9217	Kaduna	Kajuru	Kallah	10.442825	7.931044
9218	Jigawa	Malam Mado	Maka Ddari	12.514383	9.842945
9219	Osun	Egbedore	Ira Gberi II	7.777751	4.380877
9220	Delta	Ethiope West	Oghara I	5.946254	5.715826
9221	Osun	Obokun	Ilahun/Ikinyinwa	7.747460	4.763377
9222	Rivers	Eleme	Aleto	4.797702	7.109137
9223	Lagos	Kosofe	Ifako/Soluyi	6.580051	3.395183
9224	Edo	Owan East	Ivbiadaobi	6.899790	6.118743
9225	Kebbi	Gwandu	Malisa	12.417202	4.770251
9226	Borno	Gubio	Gubio Town I	12.446918	12.854383
9227	Sokoto	Dange-Shuni	Shuni	12.891069	5.341415
9228	Kogi	Idah	Igecheba	7.081421	6.704466
9229	Delta	Oshimili South	Umuezei	6.194632	6.740135
9231	Benue	Tarka	Mbanyagber	7.647842	8.934378
9232	Imo	Ngor-Okpala	Umuhu	5.319046	7.243854
9233	Enugu	Nsukka	Obimo/Ikwoka	6.801773	7.316746
9234	Niger	Rijau	Danrangi	11.247750	5.312393
9235	Cross River	Boki	Alankwu	6.423282	9.184892
9236	Delta	Warri South-West	Orere	5.526371	5.431096
9237	Nassarawa	Nasarawa	Odu	8.399832	7.867056
9238	Kogi	Omala	Icheke Ajopachi	7.738736	7.688484
9239	Niger	Kontogur	Central	10.403048	5.474129
9240	Bauchi	Jama'are	Jurara	11.657222	9.843681
9241	Akwa Ibom	Uruan	Southern Uruan V	4.907144	8.011646
9242	Abia	Arochukwu	Eleoha Ihechiowa	5.513332	7.886216
9243	Niger	Rafi	Kagara Gari	10.216342	6.216785
9244	Taraba	Takum	Gahweton	7.452841	10.115736
9245	Akwa Ibom	Ukanafun	Southern Ukanafun I	4.850714	7.520829
9246	Benue	Tarka	Mbakwakem	7.600623	8.911818
9247	Kogi	Okene	Idoji	7.436052	6.332521
9248	Ekiti	Moba	Otun II	7.993041	5.094025
9249	Kaduna	Sabon Gari	Samaru	11.164114	7.649180
9250	Ondo	Ondo East	Fagbo	7.125586	4.975214
9251	Jigawa	Kaugama	Kaugama	12.460642	9.769691
9252	Edo	Owan East	Emai I	6.942809	6.076568
9253	Kaduna	Kaduna South	Tudun Wada West	10.495074	7.411365
9254	Niger	Rafi	Tegina West	10.189801	6.084622
9255	Delta	Udu	Ovwian I	5.493260	5.787047
9256	Ogun	Obafemi-Owode	Kaloja	7.071557	3.418373
9257	Katsina	Daura	Unbadawaki b	13.041673	8.252578
9258	Kwara	Isin	Isanlu	8.242600	5.099480
9259	Anambra	Anambra East	Nsugbe II	6.202073	6.797413
9260	Kwara	Offa	Shawo South East	8.131208	4.698460
9261	Borno	Kwaya Kusar	Guwal	10.527290	11.981280
9262	Osun	Ede South	Babanla/Agate	7.688351	4.459392
9263	Osun	IfeCentral	Ilare II	7.449190	4.616346
9264	Borno	Kukawa	Moduari / Barwari	12.804462	13.554742
9265	Federal Capital Territory	Kwali	Gumbo	8.702510	6.993865
9266	Kogi	Yagba West	Odo Egbe I	8.327446	5.584307
9267	Kano	Gaya	Balan	11.752085	9.031498
9268	Benue	Ukum	Aterayange	7.768933	9.582078
9269	Akwa Ibom	Obot Akara	Ikot Abia III	5.177618	7.554260
9270	Akwa Ibom	Mbo	Ebughu II	4.683923	8.270905
9271	Taraba	Karim-Lamido	Karim "B"	9.273393	11.282091
9272	Akwa Ibom	Ikot Abasi	Ikpa Nung Asang II	4.674985	7.673385
9273	Katsina	Rimi	Abukur	12.879505	7.671485
9274	Katsina	Katsina (K)	Shinkafi 'B'	13.002019	7.654217
9275	Ogun	Ijebu North	Ago Iwoye I	6.916970	3.920552
9276	Lagos	Apapa	Sari and Environs	6.472032	3.344591
9277	Imo	Ezinihitte Mbaise	Ihitte	5.452444	7.295670
9278	Ondo	Odigbo	Oniparaga	6.780925	4.556959
9279	Borno	Chibok	Gatamarwa	10.728830	13.004642
9280	Rivers	Ahoada West	Ubie III	5.144063	6.575716
9281	Plateau	Langtang South	Timbol	8.513103	9.835350
9282	Bauchi	Tafawa-Balewa	Wai	9.800367	9.470721
9283	Oyo	Ibadan North East	Ward X  E8	7.375737	3.918264
9284	Osun	Ife North	Edunabon  II	7.473339	4.440523
9285	Kano	Makoda	Kadandani	12.547902	8.481751
9286	Gombe	Kaltungo	Bule / Kaltin	9.923419	11.569264
9287	Anambra	Anambra West	Ifite-anam	6.410840	6.788228
9288	Ebonyi	Ohaukwu	Umu Ogudu Akpu I	6.489762	7.930929
9289	Federal Capital Territory	Municipal	Gwarimpa	9.051402	7.418944
9290	Osun	Ejigbo	Elejigbo/Ayegbogbo	7.901014	4.296679
9291	Katsina	Rimi	Remawa/Iyatawa	12.793889	7.737031
9292	Nassarawa	Akwanga	Ningo / Bohar	8.996775	8.411887
9293	Kebbi	Augie	Yola	12.863937	4.487839
9294	Zamfara	Gummi	Falale	12.095621	5.391934
9295	Abia	Isiala Ngwa South	Ovungwu	5.232383	7.438359
9296	Yobe	Nangere	Dazigau	11.734053	10.968429
9297	Ebonyi	Afikpo North	Ugwuegu Afikpo	5.882829	7.946276
9298	Anambra	Ayamelum	Umueje	6.671355	6.946534
9299	Rivers	Khana	Sogho	4.757963	7.356440
9300	Yobe	Yunusari	Dilala/Kalgi	13.115824	11.506920
9301	Abia	Umu-Nneochi	Mbala/Achara	5.961148	7.361665
9302	Bayelsa	Southern Ijaw	Foropa	4.690234	5.666896
9303	Osun	Atakumosa East	Ipole	7.547095	4.814970
9304	Jigawa	Auyo	Auyakayi	12.361374	9.998319
9305	Jigawa	Kafin Hausa	Kafin Hausa	12.192769	9.931081
9306	Kwara	Oyun	Ijagbo	8.232592	4.704416
9307	Cross River	Ikom	Ikom Urban II	5.998247	8.753830
9308	Oyo	Ibarapa Central	Idere II (Ominigbo/Oke - Oba)	7.500063	3.244222
9309	Delta	Burutu	Ngbilebiri II	5.254067	5.447145
9310	Borno	Konduga	Konduga	11.596400	13.435257
9311	Niger	Muya	Dandaudu	9.607456	6.861428
9312	Kwara	Oke-Ero	Aiyedun	8.061825	5.128498
9313	Kaduna	Kubau	Kargi	11.090927	8.433793
9314	Delta	IkaNorth	Owa II	6.208877	6.227617
9315	Osun	Atakumosa West	Ifewara II	7.484391	4.696599
9316	Adamawa	Michika	Michika  II	10.653258	13.386290
9317	Adamawa	Mubi North	Betso	10.477293	13.338120
9318	Enugu	Igbo-Eti	Aku I	6.712568	7.317419
9319	Sokoto	Illela	Tozai	13.698419	5.443842
9320	Ondo	Ilaje	Ugbo III	6.104285	4.871418
9321	Sokoto	Yabo	Ruggar Iya	12.715014	5.080087
9322	Anambra	Awka North	Amanuke	6.309714	7.010591
9323	Katsina	Sandamu	Katsayal	12.924365	8.418466
9324	Imo	Ideato South	Obiohia	5.806108	7.126906
9325	Borno	Dikwa	Boboshe	11.863735	13.930220
9326	Benue	Buruku	Etulo	7.186043	9.270331
9327	Taraba	Karim-Lamido	Darofai	9.341698	10.960967
9328	Sokoto	Tambawal	Barkeji/Nabaguda	12.322092	4.912225
9329	Kano	Kura	Gundutse	11.802064	8.502106
9330	Ogun	Ijebu North-East	Odesenlu	6.902236	4.053355
9331	Borno	Kaga	Shettimari	11.520972	12.402908
9332	Oyo	Oyo East	Apaara	7.853370	3.961643
9333	Bauchi	Katagum	Gambaki/Bidir	11.545762	10.053385
9334	Lagos	Amuwo Odofin	Ijegun	6.437929	3.260806
9335	Kogi	Ofu	Ofoke	7.378959	6.759890
9336	Cross River	Obudu	Begiading	6.618644	9.067982
9337	Akwa Ibom	Esit Eket	Etebi Idung Assan	4.644939	8.128242
9338	Kaduna	Soba	Gamagira	10.738744	7.890514
9339	Borno	Monguno	Zulum	12.442673	13.495374
9340	Bauchi	Warji	Gabanga	11.232856	9.783331
9341	Imo	Ehime-Mbano	Umunumo	5.648538	7.298331
9342	Edo	Egor	Uwelu	6.380826	5.566220
9343	Benue	Gwer East	Mbalom	7.479111	8.420282
9344	Rivers	Emuoha	Elele Alimini	5.047942	6.718096
9345	Ondo	Ose	Idoani II	7.318225	5.839163
9346	Enugu	EnuguSou	Uwani West	6.413693	7.501945
9347	Benue	Apa	Oiji	7.554843	7.928192
9348	Osun	Ifelodun	Okeba Ikirun	7.932173	4.657865
9349	Benue	Guma	Saghev	7.689091	8.998126
9350	Adamawa	Ganye	Sugu	8.283687	12.111231
9351	Kaduna	Kaduna South	Tudun Wada North	10.506549	7.421353
9352	Katsina	Malumfashi	Borin Dawa	11.820805	7.640980
9353	Borno	Kwaya Kusar	Wawa	10.483435	12.031621
9354	Ogun	Ado Odo-Ota	Ota I	6.659250	3.191123
9355	Imo	Ezinihitte Mbaise	Onicha IV	5.517561	7.337364
9356	Osun	Egbedore	Ara II	7.849516	4.416943
9357	Ondo	Akure North	Oba-Ile	7.250059	5.247630
9358	Kano	Tsanyawa	Daddarawa	12.230155	8.058506
9359	Rivers	Port Harcourt	Nkpolu Oroworukwo Two	4.768915	6.965664
9360	Federal Capital Territory	Kwali	Yebu	8.634277	6.973587
9361	Kano	Tundun Wada	Karefa	11.339706	8.434462
9362	Bayelsa	Ogbia	Otakeme	4.733138	6.355103
9363	Enugu	Oji-River	Achiuno III	6.144057	7.355021
9364	Benue	Ukum	Mbazun	7.618527	9.759847
9365	Osun	Ejigbo	Elejigbo 'B'/Osolo	7.888980	4.314727
9366	Abia	Ukwa East	Ikwuriator West	4.961355	7.449985
9367	Katsina	Baure	Yanduna	12.794779	8.592994
9368	Oyo	Lagelu	Ofa-Igbo	7.505437	4.115433
9369	Edo	Orhionmw	Ugbeka	6.203352	6.047710
9370	Kano	Kunchi	Garin Sheme	12.350366	8.208315
9371	Ekiti	Oye	Itapa/Osin	7.824567	5.400733
9372	Ebonyi	Izzi	Mgbalaukwu Inyimagu II	6.517130	8.351541
9373	Sokoto	Silame	Marafa West	12.970017	4.797251
9374	Adamawa	Mubi South	Gella	10.161295	13.367850
9375	Kogi	Igalamela-Odolu	Ajaka I	7.156606	6.746164
9376	Jigawa	Dutse	Kachi	11.719855	9.343472
9377	Kano	Gabasawa	Yantar Arewa	12.234804	8.739329
9378	Bayelsa	Ogbia	Oloibiri	4.645383	6.311101
9379	Katsina	Safana	Baure 'A'	12.610635	7.261569
9380	Benue	Ado	Apa	6.729729	7.908462
9381	Kano	Tofa	Tofa	12.050460	8.241120
9382	Kano	Albasu	Tsangaya	11.633532	9.214031
9383	Taraba	Yorro	Bikassa II	8.726928	11.694859
9384	Jigawa	Buji	Kawaya	11.581380	9.752825
9385	Osun	Iwo	Isale Oba  IV	7.600425	4.168627
9386	Nassarawa	Obi	Obi	8.349238	8.799010
9387	Imo	Isu	Isu-Njaba III	5.692733	7.077592
9388	Oyo	Afijio	Ilora I	7.810879	3.898855
9389	Benue	Buruku	Mbaatirkyaa	7.422851	9.254435
9390	Taraba	Donga	Fada	7.788385	10.040652
9391	Enugu	Igbo-Eti	Ekwegbe I	6.699076	7.445535
9392	Oyo	Ori-Ire	Ori Ire X	8.131925	4.111819
9393	Sokoto	Rabah	Rara	12.943580	5.603522
9394	Jigawa	Hadejia	Kasuwar Kuda	12.425083	10.056007
9395	Kaduna	Ikara	Ikara	11.181081	8.244892
9396	Ebonyi	Afikpo North	Ohaisu Afikpo 'B'	5.888657	7.944337
9397	Kaduna	Makarfi	Mayere	11.344067	7.990755
9398	Kogi	Mopa-Muro	Takete Idde/Otafun	8.190539	5.999455
9399	Benue	Katsina- Ala	Iwar(Tongov I)	7.438341	9.411462
9400	Oyo	Ona-Ara	Ogbere	7.360361	3.986643
9401	Bauchi	Gamjuwa	Kubi West	10.571469	10.218338
9402	Yobe	Tarmuwa	Shekau	12.184713	11.707676
9403	Sokoto	Sokoto North	Magajin Rafi 'B'	13.046146	5.279560
9404	Jigawa	Hadejia	Yayari	12.416374	10.029449
9405	Plateau	Langtang South	Sabon Gida	8.716531	9.697856
9406	Jigawa	Kirika Samma	Baturiya	12.500173	10.292424
9407	Delta	Ethiope West	Mosogar I	5.891183	5.730369
9408	Cross River	Yala	Echumofana	6.764980	8.842630
9409	Borno	Damboa	Damboa	11.204499	12.798158
9410	Plateau	Riyom	Sharubutu	9.451049	8.704979
9411	Zamfara	Maradun	Janbako	12.884555	6.210471
9412	Jigawa	Gagarawa	Zarada	12.500644	9.498762
9413	Bauchi	Bogoro	Lusa  "C"	9.590259	9.688348
9414	Akwa Ibom	Esit Eket	Ebe Ekpi	4.623817	8.006546
9415	Ondo	Okitipupa	Okitipupa II	6.477857	4.709489
9416	Taraba	Jalingo	Turaki 'A'	8.867097	11.435771
9417	Kaduna	Kagarko	Iddah	9.384154	7.300775
9418	Rivers	Akukutor	North/South Group	4.571084	6.742008
9419	Oyo	Oyo East	Owode/Araromi	7.823657	3.949615
9420	Osun	Ede North	Ologun/Agbaakin	7.705291	4.469561
9421	Akwa Ibom	Ika	Ito III	5.004172	7.556477
9422	Abia	Aba North	St. Eugenes by Okigwe Rd.	5.114135	7.353316
9423	Imo	Njaba	umuaka III	5.657878	7.017972
9424	Osun	Odo Otin	Oba Ojomu	8.015724	4.679829
9425	Ondo	Owo	Iloro	7.183016	5.596351
9426	Enugu	Nsukka	Alor-Uno	6.875762	7.382618
9427	Akwa Ibom	Ini	Nkari	5.397123	7.658164
9428	Rivers	Akukutor	Manuel  III	4.720204	6.721010
9429	Taraba	Wukari	Rafin Kada	7.745263	9.845988
9430	Adamawa	Shelleng	Shelleng	9.892218	12.104070
9431	Imo	Orsu	Ihitenansa	5.878977	6.979579
9432	Borno	Nganzai	Miye	12.210762	13.200037
9433	Taraba	Wukari	Chonku	7.904956	9.698311
9434	Federal Capital Territory	Gwagwalada	Zuba	9.101857	7.107771
9435	Jigawa	Jahun	Harbo Sabuwa	12.111612	9.500970
9436	Taraba	Ussa	Kpambo	7.188271	9.928221
9437	Sokoto	Kware	S/Birni/ G. Karma	13.273583	5.297605
9438	Rivers	Opobo/Nkoro	Dappaye Ama-Kiri II	4.520519	7.526650
9439	Delta	Oshimili South	Umuonaje	6.187474	6.705757
9440	Akwa Ibom	Onna	Nung idem I	4.639931	7.867414
9441	Kebbi	Arewa	Kangiwa	12.531619	3.791886
9442	Jigawa	Babura	Insharuwa	12.709689	8.924277
9443	Benue	Gboko	Mbadim	7.215464	8.757054
9444	Katsina	Mani	Kwatta	12.896050	7.815322
9445	Gombe	Akko	Pindiga	10.065399	10.878284
9446	Adamawa	Guyuk	Dukul	9.879869	11.950070
9447	Ondo	Idanre	Ijomu/Isurin	7.093296	5.033829
9448	Gombe	Kaltungo	Tula - Yiri	9.778766	11.608271
9449	Zamfara	Bakura	Dakko	12.332376	5.698865
9450	Enugu	Nkanu West	Obinagu Uwani (Akpugo I)	6.294832	7.579225
9451	Delta	Burutu	Bulou - Ndoro	5.247981	5.583765
9452	Abia	Ugwunagbo	Ward Eight	5.018453	7.304703
9453	Jigawa	Kazaure	Dabaza	12.603989	8.593718
9454	Gombe	Kwami	Komfulata	10.420860	11.102893
9455	Lagos	Lagos Island	Oko-awo	6.458885	3.388518
9456	Sokoto	Gudu	Karfen Chana	13.202278	4.458608
9457	Adamawa	Yola South	Ngurore	9.209220	12.455452
9458	Kaduna	Kubau	Dutsen Wai	10.848656	8.235949
9459	Adamawa	Shelleng	Gwapopolok	9.899652	12.177973
9460	Oyo	Ibarapa North	Igangan IV	7.680748	3.184453
9461	Yobe	Fika	Gudi / Dozi / Godo Woli	11.396684	11.090399
9462	Oyo	Saki East	Oje Owode I	8.562109	3.527274
9463	Kano	Shanono	Goron Dutse	12.139570	7.887550
9464	Cross River	Obudu	Alege/Ubang	6.510642	8.993227
9465	Borno	Kwaya Kusar	Wada	10.359657	12.013784
9466	Delta	Warri South-West	Isaba	5.447352	5.582286
9467	Kogi	Yagba West	Odo Eri Okoto	8.416725	5.463872
9468	Katsina	Danmusa	Mara	12.259445	7.268863
9469	Ebonyi	Abakalik	Amachi (Ndegu)	6.282485	8.351911
9470	Nassarawa	Awe	Madaki	8.196611	9.234636
9471	Bauchi	Alkaleri	Yalo	9.707564	10.847688
9472	Kogi	Mopa-Muro	Aiyedayo/Aiyedaro	8.127408	5.961098
9473	Abia	Aba North	Ariaria Market	5.114319	7.343426
9474	Katsina	Ingawa	Dugul	12.709150	8.063168
9475	Ogun	Ifo	Ososun	6.805612	3.319706
9476	Anambra	Awka South	Nise  I	6.148944	7.043731
9477	Taraba	Zing	Yakoko	8.927359	11.743108
9478	Imo	Njaba	Atta III	5.723342	6.987897
9479	Bauchi	Katagum	Chinade	11.534569	10.412708
9480	Delta	Oshimili South	Okwe	6.152321	6.723855
9481	Taraba	Ardo-Kola	Tau	8.688654	11.276091
9482	Kano	Dambatta	Danbatta West	12.389503	8.497267
9483	Katsina	Mai'Adua	Bumbum 'B'	13.201417	8.135907
9484	Rivers	Degema	Bakana  III	4.735643	6.918256
9485	Jigawa	Dutse	Abaya	11.937656	9.347167
9486	Kogi	Idah	Ugwoda	7.030497	6.714881
9487	Lagos	Ibeju/Lekki	S,2a (Siriwon/Igbekodo II)	6.513852	3.771219
9488	Ekiti	Moba	Otun I	7.984609	5.128454
9489	Cross River	Calabar South	Ten (10)	4.907114	8.264995
9490	Zamfara	Maradun	Gidan Goga	12.663759	6.402054
9491	Abia	Isiala Ngwa South	Omoba	5.241072	7.412966
9492	Niger	Shiroro	Bangajiya	9.898501	6.675594
9493	Benue	Kwande	Mbayoo	6.950414	9.419293
9494	Benue	Okpokwu	Ojoga	6.960231	7.763891
9495	Sokoto	Bodinga	Danchadi	12.789440	5.272277
9496	Ekiti	Ido-Osi	Orin/Ora	7.827159	5.235093
9497	Adamawa	Yola South	Makama 'B'	9.181487	12.622183
9498	Jigawa	Roni	Gora	12.479630	8.362154
9499	Anambra	Orumba South	Isulo	6.008597	7.219439
9500	Benue	Ogbadibo	Olachagbaha	7.064908	7.677395
9501	Akwa Ibom	Esit Eket	Ntak Inyang	4.617221	8.087992
9502	Kaduna	Kudan	Doka	11.335261	7.786302
9503	Rivers	Ogba/Egbema/Andoni	Egi IV	5.229388	6.679430
9504	Rivers	Port Harcourt	Oroworukwo	4.791134	7.015096
9505	Akwa Ibom	Uyo	Uyo Urban I	5.021053	7.922419
9506	Oyo	Akinyele	Ijaye/Ojedeji	7.624942	3.844816
9507	Imo	Isu	Amandugba I	5.642276	7.079113
9508	Niger	Tafa	New Bwari	9.278109	7.269867
9509	Bauchi	Giade	U.  Zum "A"	11.518412	10.237231
9510	Adamawa	Shelleng	Tallum	9.761557	12.178325
9511	Rivers	Etche	Afara	5.048088	7.059867
9512	Abia	Ohafia	Ndi Agbo Nkporo	5.805415	7.723403
9513	Jigawa	Buji	Buji	11.526139	9.675928
9514	Kogi	Dekina	Abocho	7.461145	6.980324
9515	Delta	EthiopeE	Agbon  VIII	5.604015	6.007210
9516	Niger	Muya	Sarkin Pawa	9.983260	7.199626
9517	Delta	Ndokwa East	Abarra/Inyi/Onuaboh	5.918373	6.599980
9518	Imo	Aboh-Mbaise	Lagwa	5.454940	7.226811
9519	Niger	Kontogur	Kudu	10.393310	5.472772
9520	Akwa Ibom	Ukanafun	Southern Afaha, Adat Ifang III	4.843748	7.627621
9521	Ondo	Akoko South-West	Oba II	7.388746	5.720256
9522	Anambra	Nnewi South	Akwa-ihedi	5.914483	6.965650
9523	Kogi	Ijumu	Iyara	7.845397	5.997092
9524	Kano	Bagwai	Romo	12.075277	8.140984
9525	Niger	Kontogur	Yamma	10.412538	5.451504
9526	Kwara	Ekiti	Koro	8.101768	5.503341
9527	Zamfara	Shinkafi	Shanawa	13.088231	6.542314
9528	Kaduna	Kaduna South	Sabon Gari South	10.515700	7.423625
9529	Kano	Kano Municipal	Gandun Albasa	11.930047	8.498566
9530	Rivers	Ogba/Egbema/Andoni	Omuku Town  (Obieti)	5.334308	6.653039
9531	Lagos	Eti-Osa	Victoria Island I	6.422756	3.400788
9532	Katsina	Kankiya	Kunduru/Gyaza	12.393184	7.677868
9533	Niger	Paikoro	Tutungo Jedna	9.422388	6.538945
9534	Edo	Esan South East	Illushi II	6.724683	6.600093
9535	Gombe	Akko	Kumo North	10.120548	11.153953
9536	Rivers	Khana	Gwara/Kaa/Eeken	4.616810	7.396609
9537	Plateau	Shendam	Shendam Central (B)	8.850282	9.539996
9538	Kebbi	Kalgo	Nayilwa	12.380933	4.041824
9539	Akwa Ibom	Uyo	Etoi I	4.998059	7.943771
9540	Oyo	Ibadan North	Ward XII, NW8	7.433927	3.910228
9541	Ogun	Abeokuta North	Sabo	7.188427	3.171122
9542	Lagos	Ibeju/Lekki	P1, (Iwerekun I)	6.487642	3.777278
9543	Bauchi	Damban	Zaura	11.741798	10.874510
9544	Zamfara	Shinkafi	Shinkafi North	13.075323	6.541159
9545	Enugu	Udi	Amokwe	6.323967	7.368139
9546	Kano	Dawakin Tofa	Kwa	12.153931	8.393245
9547	Kano	Dawakin Tofa	Gargari	12.155232	8.330801
9548	Plateau	Wase	Wase Tofa	9.140687	9.913909
9549	Yobe	Gujba	Ngurbuwa	11.552091	12.124835
9550	Lagos	Amuwo Odofin	Kirikiri	6.441810	3.297037
9551	Kaduna	Zangon Kataf	Gidan Jatau	9.710972	8.130888
9552	Borno	Ngala	Tunokalia	12.139453	14.304772
9553	Kebbi	Bunza	Bunza Dangaladima	11.979425	4.016745
9554	Akwa Ibom	Nsit Ubium	Itreto	4.750379	7.896755
9555	Kaduna	Makarfi	Dandamisa	11.247428	7.895662
9556	Abia	Umuahia North	Nkwoachara	5.575699	7.454883
9557	Borno	Dikwa	Muliye / Jemuri	11.816096	14.087654
9558	Nassarawa	Lafia	Ashige	8.671318	8.794720
9559	Osun	Osogbo	Otun Balogun 'A'	7.760117	4.601438
9560	Benue	Katsina- Ala	Mbacher	7.272454	9.544625
9561	Kogi	Yagba East	Alu/Igbagun/Okanre	7.826802	5.758784
9562	Akwa Ibom	Ikono	Ediene II	5.208119	7.813755
9563	Cross River	Biase	Ikun/Etono	5.591814	7.979603
9564	Ogun	Odogbolu	Okun-Owa	6.837010	3.766843
9565	Cross River	Bekwarra	Ukpah	6.633435	8.883077
9566	Anambra	Orumba South	Owerre-ezukala  I	6.013590	7.320565
9567	Borno	Marte	Kabulawa	12.513038	13.877083
9568	Ekiti	Ijero	Ipoti Ward 'A'	7.856292	5.051613
9569	Yobe	Geidam	Balle/Gallaba/Meleri	12.827437	11.809927
9570	Oyo	Atisbo	Ago Are II	8.450729	3.482334
9571	Kano	Wudil	Dagumawa	11.764986	8.816832
9572	Oyo	Ogbomosho South	Alapata	8.081555	4.222597
9573	Rivers	Omumma	Umuogba I Community	5.067653	7.226157
9574	Katsina	Danja	Yakaji B	11.304530	7.649637
9575	Benue	Gwer West	Sengev/Yengev	7.537132	8.265904
9576	Ebonyi	Onicha	Obeagu-Isu	6.219260	7.741173
9577	Jigawa	Maigatari	Maigatari Kudu	12.787952	9.455050
9578	Yobe	Yusufari	Kajimaram/Sumbar	13.212471	10.639727
9579	Taraba	Lau	Kunini	9.231130	11.419416
9580	Lagos	Ojo	Idoluwo	6.441548	3.128126
9581	Imo	Orlu	Ebenese/Umueze/Nnachi Ihioma	5.797571	7.024340
9582	Ebonyi	Ishielu	Okpoto	6.362208	7.836228
9583	Imo	Mbaitoli	Afara/Eziama	5.624706	6.971457
9584	Gombe	Balanga	Bambam	9.670123	11.531317
9585	Osun	Oriade	Ikeji-Ile	7.462858	4.947595
9586	Ebonyi	Ishielu	Iyonu	6.412217	7.763059
9588	Enugu	Uzo-Uwani	Nimbo I	6.807401	7.117731
9589	Bauchi	Darazo	Darazo	11.021430	10.369858
9590	Kogi	Ijumu	Aiyere/Arimah	7.675024	6.007860
9591	Kaduna	Zangon Kataf	Zonzon	9.857786	8.408178
9592	Enugu	Igbo-Eti	Ukehe III	6.626058	7.467483
9593	Cross River	Yakurr	Biko biko	5.826208	8.064847
9594	Sokoto	Tangazar	Sutti	13.335026	5.073617
9595	Benue	Oturkpo	Otukpo Town East	7.172862	8.136421
9596	Adamawa	Yola South	Toungo	9.170283	12.635155
9597	Borno	Mafa	Mafa	11.962054	13.623373
9598	Sokoto	Tambawal	Bashire/Maikada	12.267330	4.739279
9599	Ogun	Shagamu	Sabo II	6.774900	3.543186
9600	Plateau	Langtang South	Turaki	8.603509	9.682239
9601	Adamawa	Mubi North	Digil	10.280471	13.318096
9602	Federal Capital Territory	Gwagwalada	Staff Quarters	8.980650	7.043027
9603	Yobe	Gujba	Bunigari/Lawanti	11.150029	12.095768
9604	Kaduna	Zaria	Gyallesu	11.032144	7.747701
9605	Anambra	Awka South	Umuawulu	6.155423	7.099061
9606	Adamawa	Michika	Jigalambu	10.582349	13.358689
9607	Plateau	Riyom	Attakar	9.611254	8.586130
9608	Jigawa	Gwiwa	Zaumar Sainawa	12.674607	8.316728
9609	Anambra	Anambra East	Aguleri	6.331480	6.887905
9610	Kwara	Isin	Iwo	8.293155	5.064442
9611	Enugu	Oji-River	Inyi III	6.154524	7.263759
9612	Jigawa	Gumel	Baikarya	12.661253	9.380149
9613	Borno	Kala/Balge	Mada	12.163571	14.457884
9614	Osun	Ejigbo	Ifeodan 'B'/Masifa	7.851132	4.210720
9615	Cross River	Biase	Akpet/Abini	5.598040	8.091354
9616	Bauchi	Dass	Zumbul/Lukshi	10.032671	9.409059
9617	Enugu	Isi-Uzo	Mbu II	6.720816	7.549938
9618	Benue	Katsina- Ala	Ikurav Tiev I	7.248257	9.389394
9619	Ekiti	Ado-Ekiti	Ado 'B' Inisa	7.550120	5.310985
9620	Kogi	Idah	Ichala	7.036351	6.688552
9621	Akwa Ibom	Etim Ekpo	Etim Ekpo V	4.989395	7.682100
9622	Ebonyi	Izzi	Agbaja Mgbo	6.472227	8.174588
9623	Jigawa	Auyo	Gatafa	12.392857	9.998398
9624	Anambra	Ogbaru	Umunankwo/Mputu	5.809199	6.728488
9625	Taraba	Takum	Chanchanji	7.585644	9.981759
9626	Ekiti	Ilejemeje	Iye II	7.907251	5.215243
9627	Oyo	Ibadan South West	Ward 9 SW8 (1)	7.356130	3.883658
9628	Osun	Ola-Oluwa	Ogbaagba  I	7.681455	4.228689
9629	Borno	Gubio	Dabira	12.595449	12.522932
9630	Niger	Katcha	Edotsu	8.815284	6.225183
9631	Katsina	Dutsin-M	Makera	12.297353	7.484842
9632	Lagos	Ifako/Ijaye	New Ifako/Oyemekun	6.651662	3.320605
9633	Sokoto	Gwadabaw	Chimmola/Kudu	13.318523	5.358069
9634	Imo	Isiala Mbano	Ogbor	5.604395	7.209082
9635	Kano	Warawa	Katarkawa	11.937645	8.815257
9636	Kaduna	Zangon Kataf	Madakiya	9.672181	8.329335
9637	Kano	Dawakin Kudu	Unguwar Duniya	11.873759	8.605563
9638	Kano	Doguwa	Unguwar Natsohuwa	10.678426	8.550090
9639	Edo	Etsako West	South Ibie	7.025364	6.330286
9640	Borno	Hawul	Puba/Vidau/Lokoja	10.379744	12.400150
9641	Bauchi	Zaki	Maiwa	12.384043	10.301642
9642	Kaduna	Kajuru	Afogo	10.296915	7.957147
9643	Kebbi	Argungu	Sauwa/Kaurar Sani	12.585721	4.277782
9644	Borno	Mobbar	Damasak	12.966942	12.459608
9645	Ondo	Okitipupa	Igbotako I	6.643071	4.616640
9646	Kebbi	Fakai	Marafa	11.519621	4.741555
9647	Kaduna	Lere	Garu	10.054095	8.564939
9648	Rivers	Andoni/Odual	Ekede	4.469646	7.448646
9649	Katsina	Matazu	Gwarjo	12.157157	7.573447
9650	Jigawa	Malam Mado	Garin Gabas	12.640743	10.093749
9651	Abia	Ukwa East	Umuigube Achara	4.893229	7.343289
9652	Ebonyi	Ikwo	Ama Inyima	6.023951	8.032011
9653	Adamawa	Mubi South	Nduku	10.130627	13.329613
9654	Nassarawa	Lafia	Arikya	8.879965	8.888291
9655	Imo	Oru-East	Akuma	5.794950	6.968098
9656	Abia	Ikwuano	Oloko I	5.352821	7.534928
9657	Sokoto	Silame	Marafa East	12.980796	4.832703
9658	Benue	Gwer East	Shough	7.545046	8.666400
9659	Ondo	Akoko South-West	Oka III A  Agba	7.471003	5.803352
9660	Anambra	Oyi	Ogbunike  I	6.186775	6.902916
9661	Sokoto	Wamakko	Gumbi/Wajake	12.997735	5.160303
9662	Borno	Monguno	Mandala	12.311880	13.474238
9663	Plateau	Bassa	Gabia	9.813314	8.692085
9664	Gombe	Yalmatu / Deba	Difa / Lubo / Kinafa	10.419558	11.463964
9665	Adamawa	Numan	Numan I	9.436342	12.096471
9666	Jigawa	Malam Mado	Maira Kumi-Bara Musa	12.580243	9.993266
9667	Rivers	Port Harcourt	Elekahia	4.792324	7.035788
9668	Lagos	Ajeromi/Ifelodun	Ojo Road	6.469942	3.319154
9669	Oyo	Ido	Akufo/Idigba/Araromi	7.514850	3.800247
9670	Abia	Umuahia South	Amakama	5.458689	7.448960
9671	Niger	Borgu	Riverine	9.665149	4.508740
9672	Jigawa	Roni	Tunas	12.643722	8.162526
9673	Rivers	Emuoha	Emohua  II	4.823434	6.855177
9674	Niger	Magama	Auna South East	10.149141	4.817255
9675	Oyo	Afijio	Fiditi I	7.699953	3.933164
9676	Enugu	Nsukka	Mkpunano	6.825093	7.374636
9677	Kano	Kano Municipal	Tudun Wazirchi	11.936615	8.466017
9678	Edo	Orhionmw	Igbanke East	6.348024	6.218887
9679	Bayelsa	Ekeremor	Oporomor II	5.002458	5.728015
9680	Ogun	Ijebu North	Oke Agbo	7.013364	4.039699
9681	Adamawa	Maiha	Tambajam	9.967901	13.207570
9682	Anambra	Onitsha North	Inland Town III	6.099672	6.783267
9683	Bauchi	Toro	Lame	10.553648	9.245615
9684	Niger	Agwara	Agwata	10.839749	4.677651
9685	Bayelsa	Yenagoa	Gbarain III	5.025137	6.284969
9686	Gombe	Akko	Kumo Central	10.075236	11.194456
9687	Kebbi	Birnin Kebbi	Zauro	12.479154	4.297034
9688	Delta	IkaNorth	Ute - Okpu	6.155277	6.293207
9689	Sokoto	Gada	Kiri	13.621678	5.582937
9690	Niger	Borgu	Wawa	9.938285	4.333122
9691	Anambra	Onitsha North	Water-side Central  II	6.109024	6.769344
9692	Plateau	Mikang	Garkawa Central	8.919841	9.741205
9693	Imo	Mbaitoli	Ogwa I	5.600069	7.007261
9694	Lagos	Alimosho	Idimu/Isheri Olofin	6.579596	3.257988
9695	Akwa Ibom	Abak	Afaha Obong II	5.033666	7.761042
9696	Rivers	Emuoha	Rundele	4.930516	6.719880
9697	Imo	Ahiazu-Mbaise	Amuzi/Ihenworie	5.510299	7.229051
9698	Jigawa	Dutse	Madobi	11.609754	9.383044
9699	Sokoto	Tambawal	Romon Sarki	12.146880	4.685307
9700	Benue	Gwer East	Ikyonov	7.312800	8.432010
9701	Ondo	Owo	Isaipen	7.172442	5.495924
9702	Sokoto	Gudu	Bachaka	13.391016	4.185257
9703	Ogun	Ado Odo-Ota	Agbara/Ejila Awori	6.747016	3.063009
9704	Katsina	Kaita	Matsai	13.185960	7.630810
9705	Enugu	Awgu	Anikenano/Ugwueme	6.057804	7.405533
9706	Taraba	Wukari	Puje	7.868338	9.815864
9707	Edo	Orhionmw	Urhonigbe South	5.955030	6.159512
9708	Taraba	Lau	Donadda	9.232788	11.521913
9709	Katsina	Mai'Adua	Mai Koni 'B'	13.108106	8.248222
9710	Jigawa	Roni	Fara	12.606657	8.275687
9711	Kogi	Yagba East	Jege/Oke/Agi Ogbom/Isao	8.042983	5.675406
9712	Katsina	Kurfi	Barkiyya	12.661293	7.531330
9713	Kano	Gaya	Gamoji	11.826260	9.128729
9714	Imo	Ngor-Okpala	Amala/Alulu/Oburu/Obokwe/Ntu	5.218764	7.163530
9715	Ondo	Irele	Irele I	6.611992	4.909338
9716	Edo	Esan North East	Obeidu	6.723843	6.248226
9717	Adamawa	Gombi	Garkida	10.377667	12.699513
9718	Kogi	Ibaji	Iyano	6.825266	6.667376
9719	Adamawa	Song	Dirma	9.862128	12.352160
9720	Kano	Kano Municipal	Chedi	11.953700	8.497690
9721	Benue	Ukum	Kendev	7.575965	9.602120
9722	Kano	Garko	Zakarawa	11.571814	8.849882
9723	Lagos	Lagos Mainland	Alagomeji	6.500219	3.372532
9724	Ogun	Ijebu East	Ogbere	6.686436	4.313457
9725	Jigawa	Gwiwa	Yola	12.809564	8.350227
9726	Ogun	Abeokuta South	Ake I	7.155569	3.359902
9727	Bayelsa	Ekeremor	Oyiakiri IV	4.952245	5.924959
9728	Anambra	Ekwusigo	Ozubulu  IV	5.977270	6.809784
9729	Kogi	Okehi	Obangede/Uhuodo	7.739344	6.321564
9730	Imo	Mbaitoli	Umunwoha/Mbieri/Umuawu	5.624786	7.046968
9731	Ondo	Ilaje	Mahin IV	6.453285	4.572621
9732	Niger	Magama	Ibelu East	10.472263	5.273747
9733	Imo	Orlu	Ihite Owerre	5.861165	7.061247
9734	Oyo	Ido	Erinwusi/Koguo/Odetola	7.464927	3.705242
9735	Bayelsa	Sagbama	Odoni	5.211237	6.248547
9736	Kwara	Pategi	Pategi IV	8.766249	5.740112
9737	Edo	Ovia South West	Ora	6.494488	5.415678
9738	Lagos	Ibeju/Lekki	02, (Orimedu II)	6.451175	3.776788
9739	Sokoto	Silame	Silame	13.006566	4.913259
9740	Kogi	Ajaokuta	Ebiya North	7.504563	6.437963
9741	Katsina	Bakori	Kabomo	11.602324	7.438865
9742	Osun	Atakumosa West	Ita Gunmodi	7.528814	4.630234
9743	Kogi	Ibaji	Ejule	6.951825	6.755095
9744	Osun	Ife South	Kere	7.227413	4.503907
9745	Lagos	Ibeju/Lekki	03, (Orimedu III)	6.474905	3.781877
9746	Cross River	Obubra	Obubra Urban	6.055980	8.309727
9747	Niger	Kontogur	Madara	10.327958	5.443226
9748	Plateau	Langtang South	Lashel	8.762707	9.847031
9749	Lagos	Lagos Mainland	Oyadiran Estate/Abule-Oja	6.521023	3.382583
9750	Ebonyi	Ivo	Obinagu	5.866451	7.567743
9751	Imo	Ideato South	Ugbelle	5.767546	7.137557
9752	Kebbi	Augie	Dundaye/Kwaido/Zagi/Illela	13.015374	4.673870
9753	Bauchi	Damban	Dagauda	11.664099	10.878478
9754	Osun	Ila	Eyindi	8.018895	4.903130
9755	Zamfara	Talata-Mafara	Morai	12.381710	6.199536
9756	Zamfara	Birnin Magaji	Nasarawa Godal East	12.494010	6.968571
9757	Nassarawa	Doma	Ungwan Sarki Dawaki	8.372760	8.315027
9758	Benue	Konshisha	Mbaiwarnyam	7.232010	8.539320
9759	Plateau	Mangu	Kerang	9.330536	9.137743
9760	Kano	Kiru	Kogo	11.618258	8.143653
9761	Oyo	Iseyin	Akinwumi/Osoogun	7.815799	3.535128
9762	Borno	Maiduguri	Bolori II	11.899613	13.190380
9763	Adamawa	Lamurde	Mgbebongun	9.507955	11.786017
9764	Edo	Owan West	Uhonmora	6.859048	5.960219
9765	Yobe	Machina	Bogo	12.829183	9.742480
9766	Kogi	Yagba West	Odo Egbe II	8.321008	5.475844
9767	Ebonyi	Ishielu	Azuinyaba "B"	6.358611	7.741848
9768	Delta	Sapele	Okokporo/Ugborhen	5.806035	5.610802
9769	Cross River	Akpabuyo	Atimbo West	4.968737	8.427857
9770	Oyo	Atiba	Agunpopo III	7.891162	3.969834
9771	Niger	Lavun	Kusotachi	9.047788	6.061074
9772	Plateau	Jos North	Naraguta 'B'	9.976014	8.903351
9773	Ogun	Ogun Waterside	Ayila/Itebu	6.473863	4.280119
9774	Katsina	Katsina (K)	Wakilin Yamma I	13.004616	7.570320
9775	Abia	Oboma Ngwa	Maboko Amairi	5.177999	7.411602
9776	Osun	Ifedayo	Obaale	7.927924	5.007021
9777	Ogun	Obafemi-Owode	Mokoloki	6.742079	3.397578
9779	Kano	Doguwa	Duguwa	10.744235	8.606166
9780	Sokoto	Shagari	Kambama	12.566338	5.279304
9781	Adamawa	Guyuk	Chikila	9.767177	11.959024
9782	Katsina	Batagarawa	Bakiyawa	12.866965	7.425700
9783	Cross River	Obudu	Ipong	6.612172	9.111222
9784	Benue	Ado	Ijigban	6.767766	8.094401
9785	Bauchi	Giade	Doguwa Central	11.362713	10.180149
9786	Kebbi	Suru	Aljannare	11.519681	3.953044
9787	Plateau	Bassa	Buji	10.065667	8.911739
9788	Kaduna	Chikun	Unguwan Yelwa	10.420290	7.454102
9789	Ondo	Ose	Afo	7.291639	5.749573
9790	Gombe	Nafada	Birin Fulani West	11.052583	11.134693
9791	Delta	Uvwie	Effurun I	5.558898	5.785827
9792	Adamawa	Jada	Mayokalaye	8.771808	12.239379
9793	Bauchi	Zaki	Makawa	12.183069	10.272085
9794	Oyo	Saki West	Oke-Oro	8.542898	3.272634
9795	Kogi	Ogori Magongo	Obatgben	7.470472	6.175732
9796	Kano	Dala	Bakin Ruwa	11.986315	8.473614
9797	Imo	Ideato North	Akwu Owerre	5.887745	7.207517
9798	Rivers	Bonny	Ward III Dan Jumbo/ Beresiri	4.460027	7.233769
9799	Enugu	Uzo-Uwani	Ugbene II	6.811019	7.245622
9800	Delta	Bomadi	Akugbene I	5.222049	5.788817
9801	Oyo	Lagelu	Apatere/Kuffi/Ogunbode/Ogo	7.526403	4.063685
9802	Adamawa	Michika	Vi / boka	10.524022	13.441289
9803	Bayelsa	Kolokuma-Opokuma	Kaiama	5.086821	6.226866
9804	Imo	Nkwerre	Owerre Nkworji II	5.742340	7.108223
9805	Niger	Agaie	Baro	8.699602	6.402687
9806	Delta	IkaSouth	Abavo II	6.132025	6.130514
9807	Anambra	Onitsha North	Inland Town IV	6.106142	6.788386
9808	Ogun	Ewekoro	Obada-Oko	6.883733	3.164075
9809	Akwa Ibom	Urue Offong|Oruko	Urue offOng V	4.739237	8.134673
\.


--
-- Data for Name: merchants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchants (id, email, password, role, "businessName", category, latitude, longitude, "isVerified", "verificationCode", "verificationExpiresAt", "isActive", "createdAt", "updatedAt", "businessLGA", "outstandingBalance", "lastInvoicedAt", "dailySpendThisDay", "dailyResetAt", "dailyPromoLimit", "maxActivePromos") FROM stdin;
53e4de5c-aff4-40cd-914c-65cecafbbd19	prodybymoss@gmail.com	$2b$10$pOl5o.qZ2N6giD9.DdkxT.CVhK2fXZ0mcNUfRT5S2DTopRuvd5yk6	MERCHANT	SuperMart	Retail	6.655544	3.255237	t	\N	\N	t	2026-04-12 10:51:45.847458	2026-04-18 14:10:52.663793	Alimosho	135.01	\N	0.00	2026-04-18 14:10:51.977	5	3
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1776417554200	AddMerchantDailyCaps1776417554200
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (id, "merchantId", type, fee, price, "originalPrice", title, description, "photoUrl", "radiusKm", expiry, "quantityLimit", "redeemedCount", views, "popularityScore", "isActive", "idempotencyKey", "createdAt", "updatedAt") FROM stdin;
7c7ca541-1972-43fb-bd64-c94f4bf8ed73	53e4de5c-aff4-40cd-914c-65cecafbbd19	STANDARD	25.00	3000.00	6000	50% Off Bucket of chicken wings	\N	\N	3.00	2026-04-21 00:59:59	10	0	0	0	t	promo-53e4de5c-aff4-40cd-914c-65cecafbbd19-b624fed1-3828-4a2a-8a1f-0ac3aafadbdb	2026-04-18 14:11:03.795315	2026-04-18 14:23:37.964425
\.


--
-- Data for Name: redemptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redemptions (id, "promotionId", "customerId", "qrCode", "isRedeemed", "redeemedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, role, "isActive", "createdAt", "updatedAt") FROM stdin;
47ab1c16-49cc-49b3-b40f-755546b34f42	lamarssom1@gmail.com	$2b$10$G1ssXH/KCXAnuC1NXUAfPu5UltgmTu9Ioe79X2zb.3ttSSUlsJZ8q	CUSTOMER	t	2026-04-12 10:51:24.557985	2026-04-12 10:51:24.557985
\.


--
-- Name: lgas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lgas_id_seq', 9809, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 1, true);


--
-- Name: promotions PK_380cecbbe3ac11f0e5a7c452c34; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "PK_380cecbbe3ac11f0e5a7c452c34" PRIMARY KEY (id);


--
-- Name: merchants PK_4fd312ef25f8e05ad47bfe7ed25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT "PK_4fd312ef25f8e05ad47bfe7ed25" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: redemptions PK_def143ab94376fea5985bb04219; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT "PK_def143ab94376fea5985bb04219" PRIMARY KEY (id);


--
-- Name: lgas UQ_46517a9e75d33d70e187f1f93c7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lgas
    ADD CONSTRAINT "UQ_46517a9e75d33d70e187f1f93c7" UNIQUE (lga, ward);


--
-- Name: merchants UQ_7682193bcf281285d0a459c4b1e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchants
    ADD CONSTRAINT "UQ_7682193bcf281285d0a459c4b1e" UNIQUE (email);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: redemptions UQ_98d246f2f675007db94ccbd1554; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT "UQ_98d246f2f675007db94ccbd1554" UNIQUE ("qrCode");


--
-- Name: lgas lgas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lgas
    ADD CONSTRAINT lgas_pkey PRIMARY KEY (id);


--
-- Name: redemptions FK_28dccf838a0afcfd0c1668c43e4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT "FK_28dccf838a0afcfd0c1668c43e4" FOREIGN KEY ("customerId") REFERENCES public.users(id);


--
-- Name: redemptions FK_95b4e6755d3701c6f98368eaa83; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redemptions
    ADD CONSTRAINT "FK_95b4e6755d3701c6f98368eaa83" FOREIGN KEY ("promotionId") REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotions FK_a16feb2e1e6fdbb7adfc8987ad0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT "FK_a16feb2e1e6fdbb7adfc8987ad0" FOREIGN KEY ("merchantId") REFERENCES public.merchants(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict h5iTooealNd1hl7F17bfXjE1JESrPDePj85Ciabg1omZ0DhJENdDucDlNrllgCc

