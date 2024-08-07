PGDMP             
            z            postgres "   12.12 (Ubuntu 12.12-1.pgdg20.04+1) "   12.12 (Ubuntu 12.12-1.pgdg20.04+1) �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    13461    postgres    DATABASE     n   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_IN' LC_CTYPE = 'en_IN';
    DROP DATABASE postgres;
                postgres    false            �           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4757                       1255    36209    pivot_products()    FUNCTION     �  CREATE FUNCTION public.pivot_products() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	store_name_array TEXT[];
	store_name TEXT;
	query_text TEXT;
BEGIN
	SELECT ARRAY_AGG(DISTINCT store ORDER BY store)
	INTO store_name_array
	FROM products_2252;
	
	query_text := 'SELECT product_id, ';
	
	FOREACH store_name IN ARRAY store_name_array
	LOOP
		query_text := query_text || 'SUM(CASE WHEN store = ''' || store_name || ''' THEN price ELSE NULL END) AS "' || store_name || '",';
	END LOOP;
	
	query_text := LEFT(query_text,LENGTH(query_text)-1);
	query_text := query_text || ' FROM products_2252 GROUP BY product_id ORDER BY product_id';
	
	RETURN query_text;
END $$;
 '   DROP FUNCTION public.pivot_products();
       public          postgres    false                       1255    36679    pivot_products_1777()    FUNCTION     �  CREATE FUNCTION public.pivot_products_1777() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	stores_array TEXT[];
	store_name TEXT;
	query_text TEXT := '';
BEGIN
	SELECT ARRAY_AGG(DISTINCT store ORDER BY store ASC)
	INTO stores_array
	FROM products_1777;
	
	query_text := query_text || 'SELECT product_id, ';
	FOREACH store_name IN ARRAY stores_array
	LOOP
		query_text := query_text || 'SUM(CASE WHEN store = ''' || store_name || ''' THEN price ELSE NULL END) AS "' || store_name || '",';
	END LOOP;
	query_text := LEFT(query_text,LENGTH(query_text)-1);
	
	query_text := query_text || ' FROM products_1777 GROUP BY product_id ORDER BY product_id;';
	
	RETURN query_text;
END
$$;
 ,   DROP FUNCTION public.pivot_products_1777();
       public          postgres    false                       1255    36221    unpivot_products_2253()    FUNCTION       CREATE FUNCTION public.unpivot_products_2253() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	stores_array TEXT[];
	query_text TEXT := '';
	store_name TEXT;
BEGIN

	SELECT ARRAY_AGG(column_name)
	INTO stores_array
	FROM information_schema.columns
	WHERE table_name = 'products_2253' AND column_name <> 'product_id';

	RAISE NOTICE '%',stores_array;
	FOREACH store_name IN ARRAY stores_array
	LOOP
		query_text := query_text || 'SELECT product_id, ''' || store_name || ''' AS store, "' || store_name ||'" FROM products_2253 WHERE "' || store_name || '" IS NOT NULL';
		query_text := query_text || ' UNION ';
	END LOOP;
	
	query_text := LEFT(query_text,LENGTH(query_text)-6);
	query_text := query_text || ' ORDER BY product_id,store';
	
	RAISE NOTICE '%',query_text;
	RETURN query_text;
END
$$;
 .   DROP FUNCTION public.unpivot_products_2253();
       public          postgres    false            c           1259    27535    accepted_rides_1635    TABLE     �   CREATE TABLE public.accepted_rides_1635 (
    ride_id integer,
    driver_id integer,
    ride_distance integer,
    ride_duration integer
);
 '   DROP TABLE public.accepted_rides_1635;
       public         heap    postgres    false            j           1259    27565    accepted_rides_1645    TABLE     �   CREATE TABLE public.accepted_rides_1645 (
    ride_id integer,
    driver_id integer,
    ride_distance integer,
    ride_duration integer
);
 '   DROP TABLE public.accepted_rides_1645;
       public         heap    postgres    false            r           1259    27590    accepted_rides_1651    TABLE     �   CREATE TABLE public.accepted_rides_1651 (
    ride_id integer,
    driver_id integer,
    ride_distance integer,
    ride_duration integer
);
 '   DROP TABLE public.accepted_rides_1651;
       public         heap    postgres    false            N           1259    27418    accounts_1454    TABLE     R   CREATE TABLE public.accounts_1454 (
    id integer,
    name character varying
);
 !   DROP TABLE public.accounts_1454;
       public         heap    postgres    false            ~           1259    34268    accounts_1843    TABLE     V   CREATE TABLE public.accounts_1843 (
    account_id integer,
    max_income integer
);
 !   DROP TABLE public.accounts_1843;
       public         heap    postgres    false            �           1259    35987    accounts_1907    TABLE     R   CREATE TABLE public.accounts_1907 (
    account_id integer,
    income integer
);
 !   DROP TABLE public.accounts_1907;
       public         heap    postgres    false                       1259    25055    actions_1113    TABLE     �   CREATE TABLE public.actions_1113 (
    user_id integer,
    post_id integer,
    action_date date,
    action character varying,
    extra character varying
);
     DROP TABLE public.actions_1113;
       public         heap    postgres    false                       1259    25073    actions_1132    TABLE     �   CREATE TABLE public.actions_1132 (
    user_id integer,
    post_id integer,
    action_date date,
    action character varying,
    extra character varying
);
     DROP TABLE public.actions_1132;
       public         heap    postgres    false            ?           1259    27304    activities_1355    TABLE     T   CREATE TABLE public.activities_1355 (
    id integer,
    name character varying
);
 #   DROP TABLE public.activities_1355;
       public         heap    postgres    false            �           1259    36369    activities_1484    TABLE     [   CREATE TABLE public.activities_1484 (
    sell_date date,
    product character varying
);
 #   DROP TABLE public.activities_1484;
       public         heap    postgres    false                       1259    25018    activity_1097    TABLE     �   CREATE TABLE public.activity_1097 (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);
 !   DROP TABLE public.activity_1097;
       public         heap    postgres    false                       1259    25085    activity_1141    TABLE     �   CREATE TABLE public.activity_1141 (
    user_id integer,
    session_id integer,
    activity_date date,
    activity_type character varying
);
 !   DROP TABLE public.activity_1141;
       public         heap    postgres    false                       1259    25091    activity_1142    TABLE     �   CREATE TABLE public.activity_1142 (
    user_id integer,
    session_id integer,
    activity_date date,
    activity_type character varying
);
 !   DROP TABLE public.activity_1142;
       public         heap    postgres    false            �           1259    36493    activity_1661    TABLE     �   CREATE TABLE public.activity_1661 (
    machine_id integer,
    process_id integer,
    activity_type character varying,
    "timestamp" double precision
);
 !   DROP TABLE public.activity_1661;
       public         heap    postgres    false                       1259    25015    activity_511    TABLE     �   CREATE TABLE public.activity_511 (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);
     DROP TABLE public.activity_511;
       public         heap    postgres    false            �            1259    16582    activity_534    TABLE     �   CREATE TABLE public.activity_534 (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);
     DROP TABLE public.activity_534;
       public         heap    postgres    false            �            1259    16678    activity_550    TABLE     �   CREATE TABLE public.activity_550 (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);
     DROP TABLE public.activity_550;
       public         heap    postgres    false            �            1259    16684    activity_550_tc_2    TABLE     �   CREATE TABLE public.activity_550_tc_2 (
    player_id integer,
    device_id integer,
    event_date date,
    games_played integer
);
 %   DROP TABLE public.activity_550_tc_2;
       public         heap    postgres    false                       1259    24969    actor_director_1050    TABLE     t   CREATE TABLE public.actor_director_1050 (
    actor_id integer,
    director_id integer,
    "timestamp" integer
);
 '   DROP TABLE public.actor_director_1050;
       public         heap    postgres    false                       1259    36698    address_175    TABLE     �   CREATE TABLE public.address_175 (
    addressid integer,
    personid integer,
    city character varying,
    state character varying
);
    DROP TABLE public.address_175;
       public         heap    postgres    false            �           1259    36315    ads_1322    TABLE     g   CREATE TABLE public.ads_1322 (
    ad_id integer,
    user_id integer,
    action character varying
);
    DROP TABLE public.ads_1322;
       public         heap    postgres    false            �           1259    36562    ads_1809    TABLE     f   CREATE TABLE public.ads_1809 (
    ad_id integer,
    customer_id integer,
    "timestamp" integer
);
    DROP TABLE public.ads_1809;
       public         heap    postgres    false                       1259    25030    amz    TABLE     d   CREATE TABLE public.amz (
    oid character varying,
    item character varying,
    qty integer
);
    DROP TABLE public.amz;
       public         heap    postgres    false            �            1259    16540 	   bonus_577    TABLE     S   CREATE TABLE public.bonus_577 (
    "empId" integer NOT NULL,
    bonus integer
);
    DROP TABLE public.bonus_577;
       public         heap    postgres    false                       1259    25021 
   books_1098    TABLE     m   CREATE TABLE public.books_1098 (
    book_id integer,
    name character varying,
    available_from date
);
    DROP TABLE public.books_1098;
       public         heap    postgres    false            m           1259    27575 
   boxes_1715    TABLE     �   CREATE TABLE public.boxes_1715 (
    box_id integer,
    chest_id integer,
    apple_count integer,
    orange_count integer
);
    DROP TABLE public.boxes_1715;
       public         heap    postgres    false            �           1259    36137 
   buses_2142    TABLE     Q   CREATE TABLE public.buses_2142 (
    bus_id integer,
    arrival_time integer
);
    DROP TABLE public.buses_2142;
       public         heap    postgres    false            �           1259    36131 
   buses_2153    TABLE     g   CREATE TABLE public.buses_2153 (
    bus_id integer,
    arrival_time integer,
    capacity integer
);
    DROP TABLE public.buses_2153;
       public         heap    postgres    false                        1259    36610    california_2072    TABLE     S   CREATE TABLE public.california_2072 (
    student_id integer,
    score integer
);
 #   DROP TABLE public.california_2072;
       public         heap    postgres    false            X           1259    27477 
   calls_1501    TABLE     g   CREATE TABLE public.calls_1501 (
    caller_id integer,
    callee_id integer,
    duration integer
);
    DROP TABLE public.calls_1501;
       public         heap    postgres    false            k           1259    27569 
   calls_1699    TABLE     a   CREATE TABLE public.calls_1699 (
    from_id integer,
    to_id integer,
    duration integer
);
    DROP TABLE public.calls_1699;
       public         heap    postgres    false            �           1259    36023 
   calls_1972    TABLE        CREATE TABLE public.calls_1972 (
    caller_id integer,
    recipient_id integer,
    call_time timestamp without time zone
);
    DROP TABLE public.calls_1972;
       public         heap    postgres    false            �            1259    24864    candidate_574    TABLE     R   CREATE TABLE public.candidate_574 (
    id integer,
    name character varying
);
 !   DROP TABLE public.candidate_574;
       public         heap    postgres    false            �           1259    36050    candidates_2004    TABLE     w   CREATE TABLE public.candidates_2004 (
    employee_id integer,
    experience character varying,
    salary integer
);
 #   DROP TABLE public.candidates_2004;
       public         heap    postgres    false            �           1259    36062    candidates_2004_tc_2    TABLE     |   CREATE TABLE public.candidates_2004_tc_2 (
    employee_id integer,
    experience character varying,
    salary integer
);
 (   DROP TABLE public.candidates_2004_tc_2;
       public         heap    postgres    false            �           1259    36068    candidates_2010    TABLE     w   CREATE TABLE public.candidates_2010 (
    employee_id integer,
    experience character varying,
    salary integer
);
 #   DROP TABLE public.candidates_2010;
       public         heap    postgres    false            �           1259    36074    candidates_2010_tc_2    TABLE     |   CREATE TABLE public.candidates_2010_tc_2 (
    employee_id integer,
    experience character varying,
    salary integer
);
 (   DROP TABLE public.candidates_2010_tc_2;
       public         heap    postgres    false            �           1259    36086    candidates_2041    TABLE     �   CREATE TABLE public.candidates_2041 (
    candidate_id integer,
    name character varying,
    years_of_exp integer,
    interview_id integer
);
 #   DROP TABLE public.candidates_2041;
       public         heap    postgres    false            v           1259    27605    championships_1783    TABLE     �   CREATE TABLE public.championships_1783 (
    year integer,
    wimbledon integer,
    fr_open integer,
    us_open integer,
    au_open integer
);
 &   DROP TABLE public.championships_1783;
       public         heap    postgres    false            -           1259    25196    chargebacks_1205    TABLE     U   CREATE TABLE public.chargebacks_1205 (
    trans_id integer,
    charge_date date
);
 $   DROP TABLE public.chargebacks_1205;
       public         heap    postgres    false            n           1259    27578    chests_1715    TABLE     m   CREATE TABLE public.chests_1715 (
    chest_id integer,
    apple_count integer,
    orange_count integer
);
    DROP TABLE public.chests_1715;
       public         heap    postgres    false            �            1259    16613 
   cinema_603    TABLE     S   CREATE TABLE public.cinema_603 (
    seat_id integer NOT NULL,
    free integer
);
    DROP TABLE public.cinema_603;
       public         heap    postgres    false            �            1259    24939 
   cinema_620    TABLE     �   CREATE TABLE public.cinema_620 (
    id integer,
    movie character varying,
    description character varying,
    rating numeric(2,1)
);
    DROP TABLE public.cinema_620;
       public         heap    postgres    false            �           1259    36264    coffee_shop_2388    TABLE     V   CREATE TABLE public.coffee_shop_2388 (
    id integer,
    drink character varying
);
 $   DROP TABLE public.coffee_shop_2388;
       public         heap    postgres    false            �            1259    16621    company_607    TABLE     x   CREATE TABLE public.company_607 (
    com_id integer,
    name character varying(20),
    city character varying(20)
);
    DROP TABLE public.company_607;
       public         heap    postgres    false            �           1259    36011    confirmations_1934    TABLE     �   CREATE TABLE public.confirmations_1934 (
    user_id integer,
    time_stamp timestamp without time zone,
    action character varying
);
 &   DROP TABLE public.confirmations_1934;
       public         heap    postgres    false            �           1259    36583    confirmations_1939    TABLE     �   CREATE TABLE public.confirmations_1939 (
    user_id integer,
    time_stamp timestamp without time zone,
    action character varying
);
 &   DROP TABLE public.confirmations_1939;
       public         heap    postgres    false            D           1259    27349    contacts_1364    TABLE     �   CREATE TABLE public.contacts_1364 (
    user_id integer,
    contact_name character varying,
    contact_email character varying
);
 !   DROP TABLE public.contacts_1364;
       public         heap    postgres    false            �           1259    36381    content_1495    TABLE     �   CREATE TABLE public.content_1495 (
    content_id integer,
    title character varying,
    kids_content character varying,
    content_type character varying
);
     DROP TABLE public.content_1495;
       public         heap    postgres    false            w           1259    27614    contests_1811    TABLE     �   CREATE TABLE public.contests_1811 (
    contest_id integer,
    gold_medal integer,
    silver_medal integer,
    bronz_medal integer
);
 !   DROP TABLE public.contests_1811;
       public         heap    postgres    false            �           1259    36303    countries_1294    TABLE     c   CREATE TABLE public.countries_1294 (
    country_id integer,
    country_name character varying
);
 "   DROP TABLE public.countries_1294;
       public         heap    postgres    false            W           1259    27471    country_1501    TABLE     e   CREATE TABLE public.country_1501 (
    name character varying,
    country_code character varying
);
     DROP TABLE public.country_1501;
       public         heap    postgres    false            �            1259    16601    courses_596    TABLE     h   CREATE TABLE public.courses_596 (
    student character varying(15),
    class character varying(15)
);
    DROP TABLE public.courses_596;
       public         heap    postgres    false                        1259    24963    customer_1045    TABLE     X   CREATE TABLE public.customer_1045 (
    customer_id integer,
    product_key integer
);
 !   DROP TABLE public.customer_1045;
       public         heap    postgres    false            :           1259    27266    customer_1321    TABLE     �   CREATE TABLE public.customer_1321 (
    customer_id integer,
    name character varying,
    visited_on date,
    amount integer
);
 !   DROP TABLE public.customer_1321;
       public         heap    postgres    false            �           1259    36258    customer_2372    TABLE     [   CREATE TABLE public.customer_2372 (
    customer_id integer,
    salesperson_id integer
);
 !   DROP TABLE public.customer_2372;
       public         heap    postgres    false            �            1259    16585    customer_584    TABLE     t   CREATE TABLE public.customer_584 (
    id integer NOT NULL,
    name character varying,
    reference_id integer
);
     DROP TABLE public.customer_584;
       public         heap    postgres    false            C           1259    27343    customers_1364    TABLE     �   CREATE TABLE public.customers_1364 (
    customer_id integer,
    customer_name character varying,
    email character varying
);
 "   DROP TABLE public.customers_1364;
       public         heap    postgres    false            H           1259    27379    customers_1398    TABLE     e   CREATE TABLE public.customers_1398 (
    customer_id integer,
    customer_name character varying
);
 "   DROP TABLE public.customers_1398;
       public         heap    postgres    false            �           1259    36388    customers_1511    TABLE     {   CREATE TABLE public.customers_1511 (
    customer_id integer,
    name character varying,
    country character varying
);
 "   DROP TABLE public.customers_1511;
       public         heap    postgres    false            Y           1259    27480    customers_1532    TABLE     \   CREATE TABLE public.customers_1532 (
    customer_id integer,
    name character varying
);
 "   DROP TABLE public.customers_1532;
       public         heap    postgres    false            \           1259    27493    customers_1549    TABLE     \   CREATE TABLE public.customers_1549 (
    customer_id integer,
    name character varying
);
 "   DROP TABLE public.customers_1549;
       public         heap    postgres    false            d           1259    27538    customers_1596    TABLE     \   CREATE TABLE public.customers_1596 (
    customer_id integer,
    name character varying
);
 "   DROP TABLE public.customers_1596;
       public         heap    postgres    false            �           1259    36451    customers_1607    TABLE     e   CREATE TABLE public.customers_1607 (
    customer_id integer,
    customer_name character varying
);
 "   DROP TABLE public.customers_1607;
       public         heap    postgres    false            g           1259    27553    customers_1613    TABLE     e   CREATE TABLE public.customers_1613 (
    customer_id integer,
    customer_name character varying
);
 "   DROP TABLE public.customers_1613;
       public         heap    postgres    false            �           1259    36565    customers_1821    TABLE     g   CREATE TABLE public.customers_1821 (
    customer_id integer,
    year integer,
    revenue integer
);
 "   DROP TABLE public.customers_1821;
       public         heap    postgres    false            �            1259    16450    customers_183    TABLE     [   CREATE TABLE public.customers_183 (
    id integer NOT NULL,
    name character varying
);
 !   DROP TABLE public.customers_183;
       public         heap    postgres    false            �           1259    36523    daily_sales_1693    TABLE     �   CREATE TABLE public.daily_sales_1693 (
    date_id date,
    make_name character varying,
    lead_id integer,
    partner_id integer
);
 $   DROP TABLE public.daily_sales_1693;
       public         heap    postgres    false            �           1259    36144 	   data_2159    TABLE     Q   CREATE TABLE public.data_2159 (
    first_col integer,
    second_col integer
);
    DROP TABLE public.data_2159;
       public         heap    postgres    false            �           1259    36568 	   days_1853    TABLE     0   CREATE TABLE public.days_1853 (
    day date
);
    DROP TABLE public.days_1853;
       public         heap    postgres    false            $           1259    25149    delivery_1173    TABLE     �   CREATE TABLE public.delivery_1173 (
    delivery_id integer,
    customer_id integer,
    order_date date,
    customer_pref_delivery_date date
);
 !   DROP TABLE public.delivery_1173;
       public         heap    postgres    false            %           1259    25152    delivery_1174    TABLE     �   CREATE TABLE public.delivery_1174 (
    delivery_id integer,
    customer_id integer,
    order_date date,
    customer_pref_delivery_date date
);
 !   DROP TABLE public.delivery_1174;
       public         heap    postgres    false            '           1259    25166    department_1179    TABLE     j   CREATE TABLE public.department_1179 (
    id integer,
    revenue integer,
    month character varying
);
 #   DROP TABLE public.department_1179;
       public         heap    postgres    false            �            1259    16639    department_184    TABLE     S   CREATE TABLE public.department_184 (
    id integer,
    name character varying
);
 "   DROP TABLE public.department_184;
       public         heap    postgres    false            �            1259    16654    department_185    TABLE     S   CREATE TABLE public.department_185 (
    id integer,
    name character varying
);
 "   DROP TABLE public.department_185;
       public         heap    postgres    false            �            1259    24888    department_580    TABLE     ]   CREATE TABLE public.department_580 (
    dept_id integer,
    dept_name character varying
);
 "   DROP TABLE public.department_580;
       public         heap    postgres    false            �           1259    36342    departments_1350    TABLE     U   CREATE TABLE public.departments_1350 (
    id integer,
    name character varying
);
 $   DROP TABLE public.departments_1350;
       public         heap    postgres    false            a           1259    27529    drivers_1635    TABLE     P   CREATE TABLE public.drivers_1635 (
    driver_id integer,
    join_date date
);
     DROP TABLE public.drivers_1635;
       public         heap    postgres    false            h           1259    27559    drivers_1645    TABLE     P   CREATE TABLE public.drivers_1645 (
    driver_id integer,
    join_date date
);
     DROP TABLE public.drivers_1645;
       public         heap    postgres    false            p           1259    27584    drivers_1651    TABLE     P   CREATE TABLE public.drivers_1651 (
    driver_id integer,
    join_date date
);
     DROP TABLE public.drivers_1651;
       public         heap    postgres    false            &           1259    25156    emp_name    TABLE     =   CREATE TABLE public.emp_name (
    name character varying
);
    DROP TABLE public.emp_name;
       public         heap    postgres    false                       1259    24985    employee_1075    TABLE     y   CREATE TABLE public.employee_1075 (
    employee_id integer,
    name character varying,
    experience_years integer
);
 !   DROP TABLE public.employee_1075;
       public         heap    postgres    false                       1259    24994    employee_1077    TABLE     y   CREATE TABLE public.employee_1077 (
    employee_id integer,
    name character varying,
    experience_years integer
);
 !   DROP TABLE public.employee_1077;
       public         heap    postgres    false            �           1259    36312    employee_1303    TABLE     T   CREATE TABLE public.employee_1303 (
    employee_id integer,
    team_id integer
);
 !   DROP TABLE public.employee_1303;
       public         heap    postgres    false            �           1259    36348    employee_1378    TABLE     R   CREATE TABLE public.employee_1378 (
    id integer,
    name character varying
);
 !   DROP TABLE public.employee_1378;
       public         heap    postgres    false            �           1259    36553    employee_1789    TABLE     ~   CREATE TABLE public.employee_1789 (
    employee_id integer,
    department_id integer,
    primary_flag character varying
);
 !   DROP TABLE public.employee_1789;
       public         heap    postgres    false            �            1259    16425    employee_181    TABLE     �   CREATE TABLE public.employee_181 (
    id integer NOT NULL,
    name character varying,
    salary numeric,
    manager_id integer
);
     DROP TABLE public.employee_181;
       public         heap    postgres    false            �            1259    16633    employee_184    TABLE     �   CREATE TABLE public.employee_184 (
    id integer,
    name character varying,
    salary integer,
    department_id integer
);
     DROP TABLE public.employee_184;
       public         heap    postgres    false            �            1259    16645    employee_185    TABLE     �   CREATE TABLE public.employee_185 (
    id integer,
    name character varying,
    salary integer,
    department_id integer
);
     DROP TABLE public.employee_185;
       public         heap    postgres    false            �            1259    16687    employee_569    TABLE     h   CREATE TABLE public.employee_569 (
    id integer,
    company character varying,
    salary integer
);
     DROP TABLE public.employee_569;
       public         heap    postgres    false            �            1259    16506    employee_570    TABLE     �   CREATE TABLE public.employee_570 (
    id integer NOT NULL,
    name character varying,
    department character varying,
    manager_id integer
);
     DROP TABLE public.employee_570;
       public         heap    postgres    false            �            1259    16527    employee_577    TABLE     �   CREATE TABLE public.employee_577 (
    "empId" integer NOT NULL,
    name character varying,
    supervisor integer,
    salary integer
);
     DROP TABLE public.employee_577;
       public         heap    postgres    false            �            1259    24879    employee_579    TABLE     \   CREATE TABLE public.employee_579 (
    id integer,
    month integer,
    salary integer
);
     DROP TABLE public.employee_579;
       public         heap    postgres    false            �            1259    24918    employee_615    TABLE     Y   CREATE TABLE public.employee_615 (
    employee_id integer,
    department_id integer
);
     DROP TABLE public.employee_615;
       public         heap    postgres    false            �           1259    36354    employee_uni_1378    TABLE     Q   CREATE TABLE public.employee_uni_1378 (
    id integer,
    unique_id integer
);
 %   DROP TABLE public.employee_uni_1378;
       public         heap    postgres    false            7           1259    26181    employees_1270    TABLE     }   CREATE TABLE public.employees_1270 (
    employee_id integer,
    employee_name character varying,
    manager_id integer
);
 "   DROP TABLE public.employees_1270;
       public         heap    postgres    false            �           1259    36532    employees_1731    TABLE     �   CREATE TABLE public.employees_1731 (
    employee_id integer,
    name character varying,
    reports_to integer,
    age integer
);
 "   DROP TABLE public.employees_1731;
       public         heap    postgres    false            �           1259    36538    employees_1741    TABLE     z   CREATE TABLE public.employees_1741 (
    emp_id integer,
    event_day date,
    in_time integer,
    out_time integer
);
 "   DROP TABLE public.employees_1741;
       public         heap    postgres    false            �           1259    36571    employees_1873    TABLE     p   CREATE TABLE public.employees_1873 (
    employee_id integer,
    name character varying,
    salary integer
);
 "   DROP TABLE public.employees_1873;
       public         heap    postgres    false            �           1259    35981    employees_1875    TABLE     p   CREATE TABLE public.employees_1875 (
    employee_id integer,
    name character varying,
    salary integer
);
 "   DROP TABLE public.employees_1875;
       public         heap    postgres    false            �           1259    36589    employees_1965    TABLE     \   CREATE TABLE public.employees_1965 (
    employee_id integer,
    name character varying
);
 "   DROP TABLE public.employees_1965;
       public         heap    postgres    false            �           1259    36598    employees_1978    TABLE     �   CREATE TABLE public.employees_1978 (
    employee_id integer,
    name character varying,
    manager_id integer,
    salary integer
);
 "   DROP TABLE public.employees_1978;
       public         heap    postgres    false            �           1259    36270    employees_2394    TABLE     Z   CREATE TABLE public.employees_2394 (
    employee_id integer,
    needed_hours integer
);
 "   DROP TABLE public.employees_2394;
       public         heap    postgres    false                       1259    25051    enrollments_1112    TABLE     k   CREATE TABLE public.enrollments_1112 (
    student_id integer,
    course_id integer,
    grade integer
);
 $   DROP TABLE public.enrollments_1112;
       public         heap    postgres    false                       1259    25061    events_1126    TABLE     w   CREATE TABLE public.events_1126 (
    business_id integer,
    event_type character varying,
    occurences integer
);
    DROP TABLE public.events_1126;
       public         heap    postgres    false            �           1259    36029 	   exam_1988    TABLE     P   CREATE TABLE public.exam_1988 (
    score integer,
    student_count integer
);
    DROP TABLE public.exam_1988;
       public         heap    postgres    false            �           1259    36297    examinations_1280    TABLE     f   CREATE TABLE public.examinations_1280 (
    student_id integer,
    subject_name character varying
);
 %   DROP TABLE public.examinations_1280;
       public         heap    postgres    false            K           1259    27397 
   exams_1412    TABLE     c   CREATE TABLE public.exams_1412 (
    exam_id integer,
    student_id integer,
    score integer
);
    DROP TABLE public.exams_1412;
       public         heap    postgres    false            t           1259    27596    executed_1767    TABLE     S   CREATE TABLE public.executed_1767 (
    task_id integer,
    subtask_id integer
);
 !   DROP TABLE public.executed_1767;
       public         heap    postgres    false            �           1259    36038    experiments_1990    TABLE     �   CREATE TABLE public.experiments_1990 (
    experiment_id integer,
    platform character varying,
    experiment_name character varying
);
 $   DROP TABLE public.experiments_1990;
       public         heap    postgres    false            G           1259    27373    expressions_1440    TABLE     �   CREATE TABLE public.expressions_1440 (
    left_operand character varying,
    operator character varying,
    right_operand character varying
);
 $   DROP TABLE public.expressions_1440;
       public         heap    postgres    false            .           1259    25199    failed_1225    TABLE     8   CREATE TABLE public.failed_1225 (
    fail_date date
);
    DROP TABLE public.failed_1225;
       public         heap    postgres    false            �           1259    36125    flights_2112    TABLE     |   CREATE TABLE public.flights_2112 (
    departure_airport integer,
    arrival_airport integer,
    flights_count integer
);
     DROP TABLE public.flights_2112;
       public         heap    postgres    false            �           1259    36128    flights_2112_tc_2    TABLE     �   CREATE TABLE public.flights_2112_tc_2 (
    departure_airport integer,
    arrival_airport integer,
    flights_count integer
);
 %   DROP TABLE public.flights_2112_tc_2;
       public         heap    postgres    false            �            1259    24912 
   follow_614    TABLE     Y   CREATE TABLE public.follow_614 (
    followee character(1),
    follower character(1)
);
    DROP TABLE public.follow_614;
       public         heap    postgres    false            �           1259    36529    followers_1729    TABLE     U   CREATE TABLE public.followers_1729 (
    user_id integer,
    follower_id integer
);
 "   DROP TABLE public.followers_1729;
       public         heap    postgres    false            �            1259    16604    friend_request_597    TABLE     q   CREATE TABLE public.friend_request_597 (
    sender_id integer,
    send_to_id integer,
    request_date date
);
 &   DROP TABLE public.friend_request_597;
       public         heap    postgres    false            >           1259    27298    friends_1355    TABLE     q   CREATE TABLE public.friends_1355 (
    id integer,
    name character varying,
    activity character varying
);
     DROP TABLE public.friends_1355;
       public         heap    postgres    false            5           1259    26172    friendship_1264    TABLE     T   CREATE TABLE public.friendship_1264 (
    user_id1 integer,
    user_id2 integer
);
 #   DROP TABLE public.friendship_1264;
       public         heap    postgres    false            z           1259    27630    friendship_1892    TABLE     T   CREATE TABLE public.friendship_1892 (
    user1_id integer,
    user2_id integer
);
 #   DROP TABLE public.friendship_1892;
       public         heap    postgres    false            �           1259    35999    friendship_1917    TABLE     T   CREATE TABLE public.friendship_1917 (
    user1_id integer,
    user2_id integer
);
 #   DROP TABLE public.friendship_1917;
       public         heap    postgres    false            �           1259    36005    friendship_1919    TABLE     T   CREATE TABLE public.friendship_1919 (
    user1_id integer,
    user2_id integer
);
 #   DROP TABLE public.friendship_1919;
       public         heap    postgres    false            �           1259    36017    friendship_1949    TABLE     T   CREATE TABLE public.friendship_1949 (
    user1_id integer,
    user2_id integer
);
 #   DROP TABLE public.friendship_1949;
       public         heap    postgres    false            �           1259    36228    genders_2308    TABLE     X   CREATE TABLE public.genders_2308 (
    user_id integer,
    gender character varying
);
     DROP TABLE public.genders_2308;
       public         heap    postgres    false            [           1259    27490    groups    TABLE     H   CREATE TABLE public.groups (
    group_id integer,
    value integer
);
    DROP TABLE public.groups;
       public         heap    postgres    false            �            1259    24894    insurance_585    TABLE     �   CREATE TABLE public.insurance_585 (
    pid bigint,
    tiv_2015 numeric(15,2),
    tiv_2016 numeric(15,2),
    lat numeric(5,2),
    lon numeric(5,2)
);
 !   DROP TABLE public.insurance_585;
       public         heap    postgres    false            �           1259    36514    invoice_1677    TABLE     �   CREATE TABLE public.invoice_1677 (
    invoice_id integer,
    product_id integer,
    rest integer,
    paid integer,
    canceled integer,
    refunded integer
);
     DROP TABLE public.invoice_1677;
       public         heap    postgres    false            L           1259    27400    invoices_1364    TABLE     f   CREATE TABLE public.invoices_1364 (
    invoice_id integer,
    price integer,
    user_id integer
);
 !   DROP TABLE public.invoices_1364;
       public         heap    postgres    false                       1259    25113 
   items_1158    TABLE     Z   CREATE TABLE public.items_1158 (
    item_id integer,
    item_brand character varying
);
    DROP TABLE public.items_1158;
       public         heap    postgres    false                        1259    25128 
   items_1159    TABLE     Z   CREATE TABLE public.items_1159 (
    item_id integer,
    item_brand character varying
);
    DROP TABLE public.items_1159;
       public         heap    postgres    false            U           1259    27459 
   items_1479    TABLE     �   CREATE TABLE public.items_1479 (
    item_id character varying,
    item_name character varying,
    item_category character varying
);
    DROP TABLE public.items_1479;
       public         heap    postgres    false            �           1259    36169    keywords_2199    TABLE     X   CREATE TABLE public.keywords_2199 (
    topic_id integer,
    word character varying
);
 !   DROP TABLE public.keywords_2199;
       public         heap    postgres    false            6           1259    26175 
   likes_1264    TABLE     M   CREATE TABLE public.likes_1264 (
    user_id integer,
    page_id integer
);
    DROP TABLE public.likes_1264;
       public         heap    postgres    false            {           1259    27633 
   likes_1892    TABLE     M   CREATE TABLE public.likes_1892 (
    user_id integer,
    page_id integer
);
    DROP TABLE public.likes_1892;
       public         heap    postgres    false            �           1259    35996    listens_1917    TABLE     ]   CREATE TABLE public.listens_1917 (
    user_id integer,
    song_id integer,
    day date
);
     DROP TABLE public.listens_1917;
       public         heap    postgres    false            �           1259    36002    listens_1919    TABLE     ]   CREATE TABLE public.listens_1919 (
    user_id integer,
    song_id integer,
    day date
);
     DROP TABLE public.listens_1919;
       public         heap    postgres    false            o           1259    27581    log_info_1747    TABLE     �   CREATE TABLE public.log_info_1747 (
    account_id integer,
    ip_address integer,
    login timestamp without time zone,
    logout timestamp without time zone
);
 !   DROP TABLE public.log_info_1747;
       public         heap    postgres    false            O           1259    27424    logins_1454    TABLE     I   CREATE TABLE public.logins_1454 (
    id integer,
    login_date date
);
    DROP TABLE public.logins_1454;
       public         heap    postgres    false            �           1259    36577    logins_1890    TABLE     e   CREATE TABLE public.logins_1890 (
    user_id integer,
    time_stamp timestamp without time zone
);
    DROP TABLE public.logins_1890;
       public         heap    postgres    false            8           1259    26187 	   logs_1285    TABLE     6   CREATE TABLE public.logs_1285 (
    log_id integer
);
    DROP TABLE public.logs_1285;
       public         heap    postgres    false                       1259    36704    logs_180    TABLE     B   CREATE TABLE public.logs_180 (
    id integer,
    num integer
);
    DROP TABLE public.logs_180;
       public         heap    postgres    false            �           1259    36273 	   logs_2394    TABLE     �   CREATE TABLE public.logs_2394 (
    employee_id integer,
    in_time timestamp without time zone,
    out_time timestamp without time zone
);
    DROP TABLE public.logs_2394;
       public         heap    postgres    false            *           1259    25181    matches_1194    TABLE     �   CREATE TABLE public.matches_1194 (
    match_id integer,
    first_player integer,
    second_player integer,
    first_score integer,
    second_score integer
);
     DROP TABLE public.matches_1194;
       public         heap    postgres    false            2           1259    26163    matches_1212    TABLE     �   CREATE TABLE public.matches_1212 (
    match_id integer,
    host_team integer,
    guest_team integer,
    host_goals integer,
    guest_goals integer
);
     DROP TABLE public.matches_1212;
       public         heap    postgres    false            }           1259    34265    matches_1841    TABLE     �   CREATE TABLE public.matches_1841 (
    home_team_id integer,
    away_team_id integer,
    home_team_goals integer,
    away_team_goals integer
);
     DROP TABLE public.matches_1841;
       public         heap    postgres    false            �           1259    36148    matches_2173    TABLE     n   CREATE TABLE public.matches_2173 (
    player_id integer,
    match_day date,
    result character varying
);
     DROP TABLE public.matches_2173;
       public         heap    postgres    false            �           1259    36154    matches_2173_tc_2    TABLE     s   CREATE TABLE public.matches_2173_tc_2 (
    player_id integer,
    match_day date,
    result character varying
);
 %   DROP TABLE public.matches_2173_tc_2;
       public         heap    postgres    false            �           1259    36095    members_2051    TABLE     X   CREATE TABLE public.members_2051 (
    member_id integer,
    name character varying
);
     DROP TABLE public.members_2051;
       public         heap    postgres    false            =           1259    27295    movie_rating_1341    TABLE     ~   CREATE TABLE public.movie_rating_1341 (
    movie_id integer,
    user_id integer,
    rating integer,
    created_at date
);
 %   DROP TABLE public.movie_rating_1341;
       public         heap    postgres    false            ;           1259    27283    movies_1341    TABLE     W   CREATE TABLE public.movies_1341 (
    movie_id integer,
    title character varying
);
    DROP TABLE public.movies_1341;
       public         heap    postgres    false            �           1259    36607    newyork_2072    TABLE     P   CREATE TABLE public.newyork_2072 (
    student_id integer,
    score integer
);
     DROP TABLE public.newyork_2072;
       public         heap    postgres    false            P           1259    27428    npv_1421    TABLE     T   CREATE TABLE public.npv_1421 (
    id integer,
    year integer,
    npv integer
);
    DROP TABLE public.npv_1421;
       public         heap    postgres    false            �            1259    24933 
   number_619    TABLE     4   CREATE TABLE public.number_619 (
    num integer
);
    DROP TABLE public.number_619;
       public         heap    postgres    false            �            1259    24936    number_619_tc_2    TABLE     9   CREATE TABLE public.number_619_tc_2 (
    num integer
);
 #   DROP TABLE public.number_619_tc_2;
       public         heap    postgres    false            �            1259    16694    numbers_571    TABLE     O   CREATE TABLE public.numbers_571 (
    number integer,
    frequency integer
);
    DROP TABLE public.numbers_571;
       public         heap    postgres    false            �            1259    16697    numbers_571_tc_2    TABLE     T   CREATE TABLE public.numbers_571_tc_2 (
    number integer,
    frequency integer
);
 $   DROP TABLE public.numbers_571_tc_2;
       public         heap    postgres    false                       1259    36641    olympic_2377    TABLE     �   CREATE TABLE public.olympic_2377 (
    country character varying,
    gold_medals integer,
    silver_medals integer,
    bronze_medals integer
);
     DROP TABLE public.olympic_2377;
       public         heap    postgres    false                       1259    25027    orders_1098    TABLE     }   CREATE TABLE public.orders_1098 (
    order_id integer,
    book_id integer,
    quantity integer,
    dispatch_date date
);
    DROP TABLE public.orders_1098;
       public         heap    postgres    false                       1259    25110    orders_1158    TABLE     �   CREATE TABLE public.orders_1158 (
    order_id integer,
    order_date date,
    item_id integer,
    buyer_id integer,
    seller_id integer
);
    DROP TABLE public.orders_1158;
       public         heap    postgres    false                       1259    25125    orders_1159    TABLE     �   CREATE TABLE public.orders_1159 (
    order_id integer,
    order_date date,
    item_id integer,
    buyer_id integer,
    seller_id integer
);
    DROP TABLE public.orders_1159;
       public         heap    postgres    false            
           1259    36659    orders_1327    TABLE     c   CREATE TABLE public.orders_1327 (
    product_id integer,
    order_date date,
    unit integer
);
    DROP TABLE public.orders_1327;
       public         heap    postgres    false            I           1259    27385    orders_1398    TABLE     w   CREATE TABLE public.orders_1398 (
    order_id integer,
    customer_id integer,
    product_name character varying
);
    DROP TABLE public.orders_1398;
       public         heap    postgres    false            T           1259    27456    orders_1479    TABLE     �   CREATE TABLE public.orders_1479 (
    order_id integer,
    customer_id integer,
    order_date date,
    item_id integer,
    quantity integer
);
    DROP TABLE public.orders_1479;
       public         heap    postgres    false            �           1259    36400    orders_1511    TABLE     �   CREATE TABLE public.orders_1511 (
    order_id integer,
    customer_id integer,
    product_id integer,
    order_date date,
    quantity integer
);
    DROP TABLE public.orders_1511;
       public         heap    postgres    false            Z           1259    27486    orders_1532    TABLE     z   CREATE TABLE public.orders_1532 (
    order_id integer,
    order_date date,
    customer_id integer,
    cost integer
);
    DROP TABLE public.orders_1532;
       public         heap    postgres    false            ]           1259    27499    orders_1549    TABLE     �   CREATE TABLE public.orders_1549 (
    order_id integer,
    order_date date,
    customer_id integer,
    product_id integer
);
    DROP TABLE public.orders_1549;
       public         heap    postgres    false            �           1259    36421    orders_1565    TABLE     }   CREATE TABLE public.orders_1565 (
    order_id integer,
    order_date date,
    customer_id integer,
    invoice integer
);
    DROP TABLE public.orders_1565;
       public         heap    postgres    false            e           1259    27544    orders_1596    TABLE     �   CREATE TABLE public.orders_1596 (
    order_id integer,
    order_date date,
    customer_id integer,
    product_id integer
);
    DROP TABLE public.orders_1596;
       public         heap    postgres    false            �           1259    36457    orders_1607    TABLE     �   CREATE TABLE public.orders_1607 (
    order_id integer,
    sale_date date,
    order_cost integer,
    customer_id integer,
    seller_id integer
);
    DROP TABLE public.orders_1607;
       public         heap    postgres    false            �            1259    16473 
   orders_183    TABLE     U   CREATE TABLE public.orders_183 (
    id integer NOT NULL,
    customer_id integer
);
    DROP TABLE public.orders_183;
       public         heap    postgres    false            �           1259    36122    orders_2084    TABLE     k   CREATE TABLE public.orders_2084 (
    order_id integer,
    customer_id integer,
    order_type integer
);
    DROP TABLE public.orders_2084;
       public         heap    postgres    false            �           1259    36222    orders_2292    TABLE        CREATE TABLE public.orders_2292 (
    order_id integer,
    product_id integer,
    quatity integer,
    purchase_date date
);
    DROP TABLE public.orders_2292;
       public         heap    postgres    false            �            1259    16593 
   orders_586    TABLE     �   CREATE TABLE public.orders_586 (
    order_number integer NOT NULL,
    customer_number integer,
    order_date date,
    required_date date,
    shipped_date date,
    status character varying(15),
    comment character varying(200)
);
    DROP TABLE public.orders_586;
       public         heap    postgres    false            �            1259    16624 
   orders_607    TABLE     �   CREATE TABLE public.orders_607 (
    order_id integer,
    order_date date,
    com_id integer,
    sales_id integer,
    amount integer
);
    DROP TABLE public.orders_607;
       public         heap    postgres    false            �           1259    34280    orders_details_1867    TABLE     p   CREATE TABLE public.orders_details_1867 (
    order_id integer,
    product_id integer,
    quantity integer
);
 '   DROP TABLE public.orders_details_1867;
       public         heap    postgres    false            �           1259    36140    passengers_2142    TABLE     \   CREATE TABLE public.passengers_2142 (
    passenger_id integer,
    arrival_time integer
);
 #   DROP TABLE public.passengers_2142;
       public         heap    postgres    false            �           1259    36134    passengers_2153    TABLE     \   CREATE TABLE public.passengers_2153 (
    passenger_id integer,
    arrival_time integer
);
 #   DROP TABLE public.passengers_2153;
       public         heap    postgres    false            �           1259    36409    patients_1527    TABLE     �   CREATE TABLE public.patients_1527 (
    patient_id integer,
    patient_name character varying,
    conditions character varying
);
 !   DROP TABLE public.patients_1527;
       public         heap    postgres    false            V           1259    27465    person_1501    TABLE     t   CREATE TABLE public.person_1501 (
    id integer,
    name character varying,
    phone_number character varying
);
    DROP TABLE public.person_1501;
       public         heap    postgres    false                       1259    36692 
   person_175    TABLE     z   CREATE TABLE public.person_175 (
    personid integer,
    firstname character varying,
    lastname character varying
);
    DROP TABLE public.person_175;
       public         heap    postgres    false            �            1259    16438 
   person_182    TABLE     Y   CREATE TABLE public.person_182 (
    id integer NOT NULL,
    email character varying
);
    DROP TABLE public.person_182;
       public         heap    postgres    false            �            1259    16483 
   person_196    TABLE     Y   CREATE TABLE public.person_196 (
    id integer NOT NULL,
    email character varying
);
    DROP TABLE public.person_196;
       public         heap    postgres    false            �            1259    16562    person_196_ans    TABLE     T   CREATE TABLE public.person_196_ans (
    id integer,
    email character varying
);
 "   DROP TABLE public.person_196_ans;
       public         heap    postgres    false            "           1259    25143 
   pivot_test    TABLE     L   CREATE TABLE public.pivot_test (
    year integer,
    rain_days integer
);
    DROP TABLE public.pivot_test;
       public         heap    postgres    false            !           1259    25137    pivot_test_rainfall    TABLE     w   CREATE TABLE public.pivot_test_rainfall (
    city text,
    year integer,
    month integer,
    rain_days integer
);
 '   DROP TABLE public.pivot_test_rainfall;
       public         heap    postgres    false            �           1259    36559    playback_1809    TABLE     �   CREATE TABLE public.playback_1809 (
    session_id integer,
    customer_id integer,
    start_time integer,
    end_time integer
);
 !   DROP TABLE public.playback_1809;
       public         heap    postgres    false            )           1259    25178    players_1194    TABLE     R   CREATE TABLE public.players_1194 (
    player_id integer,
    group_id integer
);
     DROP TABLE public.players_1194;
       public         heap    postgres    false            u           1259    27599    players_1783    TABLE     _   CREATE TABLE public.players_1783 (
    player_id integer,
    player_name character varying
);
     DROP TABLE public.players_1783;
       public         heap    postgres    false            �            1259    24906    point_2d_612    TABLE     C   CREATE TABLE public.point_2d_612 (
    x integer,
    y integer
);
     DROP TABLE public.point_2d_612;
       public         heap    postgres    false            �            1259    24909 	   point_613    TABLE     1   CREATE TABLE public.point_613 (
    x integer
);
    DROP TABLE public.point_613;
       public         heap    postgres    false            R           1259    27446    points_1459    TABLE     ^   CREATE TABLE public.points_1459 (
    id integer,
    x_value integer,
    y_value integer
);
    DROP TABLE public.points_1459;
       public         heap    postgres    false            �           1259    36166    points_change_2175    TABLE     [   CREATE TABLE public.points_change_2175 (
    team_id integer,
    points_change integer
);
 &   DROP TABLE public.points_change_2175;
       public         heap    postgres    false            �           1259    36175 
   posts_2199    TABLE     W   CREATE TABLE public.posts_2199 (
    post_id integer,
    content character varying
);
    DROP TABLE public.posts_2199;
       public         heap    postgres    false            �           1259    36279    prices_1251    TABLE     w   CREATE TABLE public.prices_1251 (
    product_id integer,
    start_date date,
    end_date date,
    price integer
);
    DROP TABLE public.prices_1251;
       public         heap    postgres    false            �           1259    36604    problems_2026    TABLE     g   CREATE TABLE public.problems_2026 (
    problem_id integer,
    likes integer,
    dislikes integer
);
 !   DROP TABLE public.problems_2026;
       public         heap    postgres    false                       1259    24966    product_1045    TABLE     >   CREATE TABLE public.product_1045 (
    product_key integer
);
     DROP TABLE public.product_1045;
       public         heap    postgres    false                       1259    24975    product_1068    TABLE     a   CREATE TABLE public.product_1068 (
    product_id integer,
    product_name character varying
);
     DROP TABLE public.product_1068;
       public         heap    postgres    false            	           1259    25000    product_1082    TABLE     y   CREATE TABLE public.product_1082 (
    product_id integer,
    product_name character varying,
    unit_price integer
);
     DROP TABLE public.product_1082;
       public         heap    postgres    false            A           1259    27328    product_1384    TABLE     a   CREATE TABLE public.product_1384 (
    product_id integer,
    product_name character varying
);
     DROP TABLE public.product_1384;
       public         heap    postgres    false            �           1259    36394    product_1511    TABLE     s   CREATE TABLE public.product_1511 (
    product_id integer,
    description character varying,
    price integer
);
     DROP TABLE public.product_1511;
       public         heap    postgres    false            �           1259    36508    product_1677    TABLE     Y   CREATE TABLE public.product_1677 (
    product_id integer,
    name character varying
);
     DROP TABLE public.product_1677;
       public         heap    postgres    false            �           1259    36240    product_2324    TABLE     P   CREATE TABLE public.product_2324 (
    product_id integer,
    price integer
);
     DROP TABLE public.product_2324;
       public         heap    postgres    false                       1259    36629    product_2329    TABLE     P   CREATE TABLE public.product_2329 (
    product_id integer,
    price integer
);
     DROP TABLE public.product_2329;
       public         heap    postgres    false            #           1259    25146    products_1164    TABLE     k   CREATE TABLE public.products_1164 (
    product_id integer,
    new_price integer,
    change_date date
);
 !   DROP TABLE public.products_1164;
       public         heap    postgres    false            	           1259    36653    products_1327    TABLE     �   CREATE TABLE public.products_1327 (
    product_id integer,
    product_name character varying,
    product_category character varying
);
 !   DROP TABLE public.products_1327;
       public         heap    postgres    false            ^           1259    27514    products_1549    TABLE     u   CREATE TABLE public.products_1549 (
    product_id integer,
    product_name character varying,
    price integer
);
 !   DROP TABLE public.products_1549;
       public         heap    postgres    false            �           1259    36430    products_1571    TABLE     �   CREATE TABLE public.products_1571 (
    product_id integer,
    product_name character varying,
    width integer,
    length integer,
    height integer
);
 !   DROP TABLE public.products_1571;
       public         heap    postgres    false            f           1259    27547    products_1596    TABLE     u   CREATE TABLE public.products_1596 (
    product_id integer,
    product_name character varying,
    price integer
);
 !   DROP TABLE public.products_1596;
       public         heap    postgres    false            �           1259    36541    products_1757    TABLE     �   CREATE TABLE public.products_1757 (
    product_id integer,
    low_fats character varying,
    recyclable character varying
);
 !   DROP TABLE public.products_1757;
       public         heap    postgres    false            �           1259    36547    products_1777    TABLE     n   CREATE TABLE public.products_1777 (
    product_id integer,
    store character varying,
    price integer
);
 !   DROP TABLE public.products_1777;
       public         heap    postgres    false            �           1259    36190    products_2252    TABLE     n   CREATE TABLE public.products_2252 (
    product_id integer,
    store character varying,
    price integer
);
 !   DROP TABLE public.products_2252;
       public         heap    postgres    false            �           1259    36216    products_2253    TABLE     �   CREATE TABLE public.products_2253 (
    product_id integer,
    "LC_Store" integer,
    "Nozama" integer,
    "Shop" integer,
    "Souq" integer
);
 !   DROP TABLE public.products_2253;
       public         heap    postgres    false            �           1259    36246    products_2362    TABLE     Q   CREATE TABLE public.products_2362 (
    product_id integer,
    price integer
);
 !   DROP TABLE public.products_2362;
       public         heap    postgres    false                       1259    24982    project_1075    TABLE     V   CREATE TABLE public.project_1075 (
    project_id integer,
    employee_id integer
);
     DROP TABLE public.project_1075;
       public         heap    postgres    false                       1259    24991    project_1077    TABLE     V   CREATE TABLE public.project_1077 (
    project_id integer,
    employee_id integer
);
     DROP TABLE public.project_1077;
       public         heap    postgres    false            �           1259    36104    purchases_2051    TABLE     Y   CREATE TABLE public.purchases_2051 (
    visit_id integer,
    charged_amount integer
);
 "   DROP TABLE public.purchases_2051;
       public         heap    postgres    false                       1259    36620    purchases_2205    TABLE     |   CREATE TABLE public.purchases_2205 (
    user_id integer,
    time_stamp timestamp without time zone,
    amount integer
);
 "   DROP TABLE public.purchases_2205;
       public         heap    postgres    false            �           1259    36184    purchases_2228    TABLE     m   CREATE TABLE public.purchases_2228 (
    purchase_id integer,
    user_id integer,
    purchase_date date
);
 "   DROP TABLE public.purchases_2228;
       public         heap    postgres    false                       1259    36623    purchases_2230    TABLE     |   CREATE TABLE public.purchases_2230 (
    user_id integer,
    time_stamp timestamp without time zone,
    amount integer
);
 "   DROP TABLE public.purchases_2230;
       public         heap    postgres    false            �           1259    36249    purchases_2362    TABLE     m   CREATE TABLE public.purchases_2362 (
    invoice_id integer,
    product_id integer,
    quantity integer
);
 "   DROP TABLE public.purchases_2362;
       public         heap    postgres    false            0           1259    26151    queries_1211    TABLE     �   CREATE TABLE public.queries_1211 (
    query_name character varying,
    result character varying,
    "position" integer,
    rating integer
);
     DROP TABLE public.queries_1211;
       public         heap    postgres    false            Q           1259    27431    queries_1421    TABLE     G   CREATE TABLE public.queries_1421 (
    id integer,
    year integer
);
     DROP TABLE public.queries_1421;
       public         heap    postgres    false            +           1259    25184 
   queue_1204    TABLE     �   CREATE TABLE public.queue_1204 (
    person_id integer,
    person_name character varying,
    weight integer,
    turn integer
);
    DROP TABLE public.queue_1204;
       public         heap    postgres    false            �           1259    36490    register_1633    TABLE     S   CREATE TABLE public.register_1633 (
    contest_id integer,
    user_id integer
);
 !   DROP TABLE public.register_1633;
       public         heap    postgres    false            �           1259    36020    relations_1951    TABLE     U   CREATE TABLE public.relations_1951 (
    user_id integer,
    follower_id integer
);
 "   DROP TABLE public.relations_1951;
       public         heap    postgres    false                       1259    25079    removals_1132    TABLE     Q   CREATE TABLE public.removals_1132 (
    post_id integer,
    remove_date date
);
 !   DROP TABLE public.removals_1132;
       public         heap    postgres    false            �            1259    16610    request_accepted_597    TABLE     x   CREATE TABLE public.request_accepted_597 (
    requester_id integer,
    accepter_id integer,
    accepted_date date
);
 (   DROP TABLE public.request_accepted_597;
       public         heap    postgres    false            �            1259    24900    request_accepted_602    TABLE     x   CREATE TABLE public.request_accepted_602 (
    requester_id integer,
    accepter_id integer,
    accepted_date date
);
 (   DROP TABLE public.request_accepted_602;
       public         heap    postgres    false            �           1259    36363 
   rides_1407    TABLE     ^   CREATE TABLE public.rides_1407 (
    id integer,
    user_id integer,
    distance integer
);
    DROP TABLE public.rides_1407;
       public         heap    postgres    false            b           1259    27532 
   rides_1635    TABLE     d   CREATE TABLE public.rides_1635 (
    ride_id integer,
    user_id integer,
    requested_at date
);
    DROP TABLE public.rides_1635;
       public         heap    postgres    false            i           1259    27562 
   rides_1645    TABLE     d   CREATE TABLE public.rides_1645 (
    ride_id integer,
    user_id integer,
    requested_at date
);
    DROP TABLE public.rides_1645;
       public         heap    postgres    false            q           1259    27587 
   rides_1651    TABLE     d   CREATE TABLE public.rides_1651 (
    ride_id integer,
    user_id integer,
    requested_at date
);
    DROP TABLE public.rides_1651;
       public         heap    postgres    false            �           1259    36187 
   rides_2238    TABLE     i   CREATE TABLE public.rides_2238 (
    ride_id integer,
    driver_id integer,
    passenger_id integer
);
    DROP TABLE public.rides_2238;
       public         heap    postgres    false            �           1259    36092    rounds_2041    TABLE     g   CREATE TABLE public.rounds_2041 (
    interview_id integer,
    round_id integer,
    score integer
);
    DROP TABLE public.rounds_2041;
       public         heap    postgres    false            S           1259    27449    salaries_1468    TABLE     �   CREATE TABLE public.salaries_1468 (
    company_id integer,
    employee_id integer,
    employee_name character varying,
    salary integer
);
 !   DROP TABLE public.salaries_1468;
       public         heap    postgres    false            �           1259    36595    salaries_1965    TABLE     S   CREATE TABLE public.salaries_1965 (
    employee_id integer,
    salary integer
);
 !   DROP TABLE public.salaries_1965;
       public         heap    postgres    false            �            1259    24915 
   salary_615    TABLE     s   CREATE TABLE public.salary_615 (
    id integer,
    employee_id integer,
    amount integer,
    pay_date date
);
    DROP TABLE public.salary_615;
       public         heap    postgres    false            �            1259    24957 
   salary_627    TABLE     y   CREATE TABLE public.salary_627 (
    id integer,
    name character varying,
    sex character(1),
    salary integer
);
    DROP TABLE public.salary_627;
       public         heap    postgres    false                       1259    24972 
   sales_1068    TABLE     �   CREATE TABLE public.sales_1068 (
    sale_id integer,
    product_id integer,
    year integer,
    quantity integer,
    price integer
);
    DROP TABLE public.sales_1068;
       public         heap    postgres    false            
           1259    25006 
   sales_1082    TABLE     �   CREATE TABLE public.sales_1082 (
    seller_id integer,
    product_id integer,
    buyer_id integer,
    sale_date date,
    quantity integer,
    price integer
);
    DROP TABLE public.sales_1082;
       public         heap    postgres    false            B           1259    27334 
   sales_1384    TABLE     �   CREATE TABLE public.sales_1384 (
    product_id integer,
    period_start date,
    period_end date,
    average_daily_sales integer
);
    DROP TABLE public.sales_1384;
       public         heap    postgres    false            M           1259    27412 
   sales_1445    TABLE     j   CREATE TABLE public.sales_1445 (
    sale_date date,
    fruit character varying,
    sold_num integer
);
    DROP TABLE public.sales_1445;
       public         heap    postgres    false            �           1259    36415 
   sales_1543    TABLE     p   CREATE TABLE public.sales_1543 (
    sale_id integer,
    product_name character varying,
    sale_date date
);
    DROP TABLE public.sales_1543;
       public         heap    postgres    false            �           1259    36237 
   sales_2324    TABLE     {   CREATE TABLE public.sales_2324 (
    sale_id integer,
    product_id integer,
    user_id integer,
    quantity integer
);
    DROP TABLE public.sales_2324;
       public         heap    postgres    false                       1259    36626 
   sales_2329    TABLE     {   CREATE TABLE public.sales_2329 (
    sale_id integer,
    product_id integer,
    user_id integer,
    quantity integer
);
    DROP TABLE public.sales_2329;
       public         heap    postgres    false            �           1259    36261 
   sales_2372    TABLE     d   CREATE TABLE public.sales_2372 (
    sale_id integer,
    customer_id integer,
    price integer
);
    DROP TABLE public.sales_2372;
       public         heap    postgres    false            �           1259    36252    salesperson_2372    TABLE     a   CREATE TABLE public.salesperson_2372 (
    salesperson_id integer,
    name character varying
);
 $   DROP TABLE public.salesperson_2372;
       public         heap    postgres    false            �            1259    16618    salesperson_607    TABLE     �   CREATE TABLE public.salesperson_607 (
    sales_id integer,
    name character varying(20),
    salary integer,
    commission_rate double precision,
    hire_date date
);
 #   DROP TABLE public.salesperson_607;
       public         heap    postgres    false            �           1259    36026    school_1988    TABLE     Q   CREATE TABLE public.school_1988 (
    school_id integer,
    capacity integer
);
    DROP TABLE public.school_1988;
       public         heap    postgres    false            �           1259    36466    school_a_1623    TABLE     b   CREATE TABLE public.school_a_1623 (
    student_id integer,
    student_name character varying
);
 !   DROP TABLE public.school_a_1623;
       public         heap    postgres    false            �           1259    36472    school_b_1623    TABLE     b   CREATE TABLE public.school_b_1623 (
    student_id integer,
    student_name character varying
);
 !   DROP TABLE public.school_b_1623;
       public         heap    postgres    false            �           1259    36478    school_c_1623    TABLE     b   CREATE TABLE public.school_c_1623 (
    student_id integer,
    student_name character varying
);
 !   DROP TABLE public.school_c_1623;
       public         heap    postgres    false            9           1259    27260    scores_1308    TABLE     �   CREATE TABLE public.scores_1308 (
    player_name character varying,
    gender character varying,
    day date,
    score_points integer
);
    DROP TABLE public.scores_1308;
       public         heap    postgres    false            �            1259    24945    seat_626    TABLE     P   CREATE TABLE public.seat_626 (
    id integer,
    student character varying
);
    DROP TABLE public.seat_626;
       public         heap    postgres    false            �           1259    36460    seller_1607    TABLE     ^   CREATE TABLE public.seller_1607 (
    seller_id integer,
    seller_name character varying
);
    DROP TABLE public.seller_1607;
       public         heap    postgres    false            �           1259    36366    sessions_1435    TABLE     T   CREATE TABLE public.sessions_1435 (
    session_id integer,
    duration integer
);
 !   DROP TABLE public.sessions_1435;
       public         heap    postgres    false            �           1259    36008    signups_1934    TABLE     f   CREATE TABLE public.signups_1934 (
    user_id integer,
    time_stamp timestamp without time zone
);
     DROP TABLE public.signups_1934;
       public         heap    postgres    false            �           1259    36580    signups_1939    TABLE     f   CREATE TABLE public.signups_1939 (
    user_id integer,
    time_stamp timestamp without time zone
);
     DROP TABLE public.signups_1939;
       public         heap    postgres    false                       1259    25067    spending_1127    TABLE     �   CREATE TABLE public.spending_1127 (
    user_id integer,
    spend_date date,
    platform character varying,
    amount integer
);
 !   DROP TABLE public.spending_1127;
       public         heap    postgres    false            �            1259    24897    stadium_601    TABLE     ]   CREATE TABLE public.stadium_601 (
    id integer,
    visit_date date,
    people integer
);
    DROP TABLE public.stadium_601;
       public         heap    postgres    false            E           1259    27361    stocks_1393    TABLE     �   CREATE TABLE public.stocks_1393 (
    stock_name character varying,
    operation character varying,
    operation_day integer,
    price integer
);
    DROP TABLE public.stocks_1393;
       public         heap    postgres    false                       1259    36614 
   store_2082    TABLE     e   CREATE TABLE public.store_2082 (
    bill_id integer,
    customer_id integer,
    amount integer
);
    DROP TABLE public.store_2082;
       public         heap    postgres    false            �           1259    36083    streams_2020    TABLE     k   CREATE TABLE public.streams_2020 (
    session_id integer,
    account_id integer,
    stream_date date
);
     DROP TABLE public.streams_2020;
       public         heap    postgres    false            �            1259    24882    student_580    TABLE     �   CREATE TABLE public.student_580 (
    student_id integer,
    student_name character varying,
    gender character(1),
    dept_id integer
);
    DROP TABLE public.student_580;
       public         heap    postgres    false            �            1259    24921    student_618    TABLE     a   CREATE TABLE public.student_618 (
    name character varying,
    continent character varying
);
    DROP TABLE public.student_618;
       public         heap    postgres    false            �           1259    36285    students_1280    TABLE     b   CREATE TABLE public.students_1280 (
    student_id integer,
    student_name character varying
);
 !   DROP TABLE public.students_1280;
       public         heap    postgres    false            �           1259    36336    students_1350    TABLE     m   CREATE TABLE public.students_1350 (
    id integer,
    name character varying,
    department_id integer
);
 !   DROP TABLE public.students_1350;
       public         heap    postgres    false            J           1259    27391    students_1412    TABLE     b   CREATE TABLE public.students_1412 (
    student_id integer,
    student_name character varying
);
 !   DROP TABLE public.students_1412;
       public         heap    postgres    false            �           1259    36243    students_2346    TABLE     k   CREATE TABLE public.students_2346 (
    student_id integer,
    department_id integer,
    mark integer
);
 !   DROP TABLE public.students_2346;
       public         heap    postgres    false            �           1259    36291    subjects_1280    TABLE     J   CREATE TABLE public.subjects_1280 (
    subject_name character varying
);
 !   DROP TABLE public.subjects_1280;
       public         heap    postgres    false            �           1259    36276    submissions_1241    TABLE     T   CREATE TABLE public.submissions_1241 (
    sub_id integer,
    parent_id integer
);
 $   DROP TABLE public.submissions_1241;
       public         heap    postgres    false            �           1259    36080    subscriptions_2020    TABLE     k   CREATE TABLE public.subscriptions_2020 (
    account_id integer,
    start_date date,
    end_date date
);
 &   DROP TABLE public.subscriptions_2020;
       public         heap    postgres    false            /           1259    25202    succeeded_1225    TABLE     >   CREATE TABLE public.succeeded_1225 (
    success_date date
);
 "   DROP TABLE public.succeeded_1225;
       public         heap    postgres    false            �            1259    24873    surveylog_578    TABLE     �   CREATE TABLE public.surveylog_578 (
    uid integer,
    action character varying,
    question_id integer,
    answer_id integer,
    q_num integer,
    "timestamp" integer
);
 !   DROP TABLE public.surveylog_578;
       public         heap    postgres    false            s           1259    27593 
   tasks_1767    TABLE     T   CREATE TABLE public.tasks_1767 (
    task_id integer,
    subtasks_count integer
);
    DROP TABLE public.tasks_1767;
       public         heap    postgres    false            �           1259    36225 
   tasks_2298    TABLE     g   CREATE TABLE public.tasks_2298 (
    task_id integer,
    assignee_id integer,
    submit_date date
);
    DROP TABLE public.tasks_2298;
       public         heap    postgres    false                       1259    36638    teacher_2356    TABLE     j   CREATE TABLE public.teacher_2356 (
    teacher_id integer,
    subject_id integer,
    dept_id integer
);
     DROP TABLE public.teacher_2356;
       public         heap    postgres    false            �           1259    36160    team_points_2175    TABLE     n   CREATE TABLE public.team_points_2175 (
    team_id integer,
    name character varying,
    points integer
);
 $   DROP TABLE public.team_points_2175;
       public         heap    postgres    false            1           1259    26157 
   teams_1212    TABLE     Y   CREATE TABLE public.teams_1212 (
    team_id integer,
    team_name character varying
);
    DROP TABLE public.teams_1212;
       public         heap    postgres    false            |           1259    34259 
   teams_1841    TABLE     Y   CREATE TABLE public.teams_1841 (
    team_id integer,
    team_name character varying
);
    DROP TABLE public.teams_1841;
       public         heap    postgres    false                       1259    36632 
   teams_2339    TABLE     D   CREATE TABLE public.teams_2339 (
    team_name character varying
);
    DROP TABLE public.teams_2339;
       public         heap    postgres    false            �           1259    36113 
   terms_2118    TABLE     J   CREATE TABLE public.terms_2118 (
    power integer,
    factor integer
);
    DROP TABLE public.terms_2118;
       public         heap    postgres    false            �           1259    36116    terms_2118_tc_2    TABLE     O   CREATE TABLE public.terms_2118_tc_2 (
    power integer,
    factor integer
);
 #   DROP TABLE public.terms_2118_tc_2;
       public         heap    postgres    false            �           1259    36119    terms_2118_tc_3    TABLE     O   CREATE TABLE public.terms_2118_tc_3 (
    power integer,
    factor integer
);
 #   DROP TABLE public.terms_2118_tc_3;
       public         heap    postgres    false                       1259    25042    traffic_1107    TABLE     r   CREATE TABLE public.traffic_1107 (
    user_id integer,
    activity character varying,
    activity_date date
);
     DROP TABLE public.traffic_1107;
       public         heap    postgres    false            (           1259    25172    transactions_1193    TABLE     �   CREATE TABLE public.transactions_1193 (
    id integer,
    country character varying,
    state character varying,
    amount integer,
    trans_date date
);
 %   DROP TABLE public.transactions_1193;
       public         heap    postgres    false            ,           1259    25190    transactions_1205    TABLE     �   CREATE TABLE public.transactions_1205 (
    id integer,
    country character varying,
    state character varying,
    amount integer,
    trans_date date
);
 %   DROP TABLE public.transactions_1205;
       public         heap    postgres    false            4           1259    26169    transactions_1336    TABLE     n   CREATE TABLE public.transactions_1336 (
    user_id integer,
    transaction_date date,
    amount integer
);
 %   DROP TABLE public.transactions_1336;
       public         heap    postgres    false            `           1259    27526    transactions_1555    TABLE     �   CREATE TABLE public.transactions_1555 (
    trans_id integer,
    paid_by integer,
    paid_to integer,
    amount integer,
    transacted_on date
);
 %   DROP TABLE public.transactions_1555;
       public         heap    postgres    false            �           1259    36439    transactions_1581    TABLE     p   CREATE TABLE public.transactions_1581 (
    transaction_id integer,
    visit_id integer,
    amount integer
);
 %   DROP TABLE public.transactions_1581;
       public         heap    postgres    false            �           1259    36448    transactions_1587    TABLE     �   CREATE TABLE public.transactions_1587 (
    trans_id integer,
    account integer,
    amount integer,
    transacted_on date
);
 %   DROP TABLE public.transactions_1587;
       public         heap    postgres    false            y           1259    27627    transactions_1831    TABLE     �   CREATE TABLE public.transactions_1831 (
    transactions_id integer,
    day timestamp without time zone,
    amount integer
);
 %   DROP TABLE public.transactions_1831;
       public         heap    postgres    false                       1259    34271    transactions_1843    TABLE     �   CREATE TABLE public.transactions_1843 (
    transaction_id integer,
    account_id integer,
    type character varying,
    amount integer,
    day timestamp without time zone
);
 %   DROP TABLE public.transactions_1843;
       public         heap    postgres    false            �           1259    36107    transactions_2066    TABLE     �   CREATE TABLE public.transactions_2066 (
    account_id integer,
    day date,
    type character varying,
    amount integer
);
 %   DROP TABLE public.transactions_2066;
       public         heap    postgres    false            �            1259    16630    tree_608    TABLE     C   CREATE TABLE public.tree_608 (
    id integer,
    p_id integer
);
    DROP TABLE public.tree_608;
       public         heap    postgres    false            �            1259    24903    triangle_610    TABLE     R   CREATE TABLE public.triangle_610 (
    x integer,
    y integer,
    z integer
);
     DROP TABLE public.triangle_610;
       public         heap    postgres    false            �            1259    16660 	   trips_262    TABLE     �   CREATE TABLE public.trips_262 (
    id integer,
    client_id integer,
    driver_id integer,
    city_id integer,
    status character varying,
    request_at date
);
    DROP TABLE public.trips_262;
       public         heap    postgres    false            �           1259    36375    tv_program_1495    TABLE     v   CREATE TABLE public.tv_program_1495 (
    program_date date,
    content_id integer,
    channel character varying
);
 #   DROP TABLE public.tv_program_1495;
       public         heap    postgres    false            �           1259    36517    tweets_1683    TABLE     Y   CREATE TABLE public.tweets_1683 (
    tweet_id integer,
    content character varying
);
    DROP TABLE public.tweets_1683;
       public         heap    postgres    false            �           1259    36282    unit_sold_1251    TABLE     j   CREATE TABLE public.unit_sold_1251 (
    product_id integer,
    purchase_date date,
    units integer
);
 "   DROP TABLE public.unit_sold_1251;
       public         heap    postgres    false            @           1259    27322    user_activity_1369    TABLE     �   CREATE TABLE public.user_activity_1369 (
    username character varying,
    activity character varying,
    start_date date,
    end_date date
);
 &   DROP TABLE public.user_activity_1369;
       public         heap    postgres    false            l           1259    27572    user_visits_1709    TABLE     S   CREATE TABLE public.user_visits_1709 (
    user_id integer,
    visit_date date
);
 $   DROP TABLE public.user_visits_1709;
       public         heap    postgres    false                       1259    25103 
   users_1158    TABLE     r   CREATE TABLE public.users_1158 (
    user_id integer,
    join_date date,
    favorite_brand character varying
);
    DROP TABLE public.users_1158;
       public         heap    postgres    false                       1259    25119 
   users_1159    TABLE     r   CREATE TABLE public.users_1159 (
    user_id integer,
    join_date date,
    favorite_brand character varying
);
    DROP TABLE public.users_1159;
       public         heap    postgres    false            <           1259    27289 
   users_1341    TABLE     T   CREATE TABLE public.users_1341 (
    user_id integer,
    name character varying
);
    DROP TABLE public.users_1341;
       public         heap    postgres    false            �           1259    36357 
   users_1407    TABLE     O   CREATE TABLE public.users_1407 (
    id integer,
    name character varying
);
    DROP TABLE public.users_1407;
       public         heap    postgres    false                       1259    36662 
   users_1517    TABLE     p   CREATE TABLE public.users_1517 (
    user_id integer,
    name character varying,
    mail character varying
);
    DROP TABLE public.users_1517;
       public         heap    postgres    false            _           1259    27520 
   users_1555    TABLE     m   CREATE TABLE public.users_1555 (
    user_id integer,
    user_name character varying,
    credit integer
);
    DROP TABLE public.users_1555;
       public         heap    postgres    false            �           1259    36442 
   users_1587    TABLE     T   CREATE TABLE public.users_1587 (
    account integer,
    name character varying
);
    DROP TABLE public.users_1587;
       public         heap    postgres    false            �           1259    36484 
   users_1633    TABLE     Y   CREATE TABLE public.users_1633 (
    user_id integer,
    user_name character varying
);
    DROP TABLE public.users_1633;
       public         heap    postgres    false            �           1259    36499 
   users_1667    TABLE     T   CREATE TABLE public.users_1667 (
    user_id integer,
    name character varying
);
    DROP TABLE public.users_1667;
       public         heap    postgres    false            x           1259    27617 
   users_1811    TABLE     p   CREATE TABLE public.users_1811 (
    user_id integer,
    mail character varying,
    name character varying
);
    DROP TABLE public.users_1811;
       public         heap    postgres    false            �            1259    16666 	   users_262    TABLE     q   CREATE TABLE public.users_262 (
    user_id integer,
    banned character varying,
    role character varying
);
    DROP TABLE public.users_262;
       public         heap    postgres    false            F           1259    27367    variables_1440    TABLE     V   CREATE TABLE public.variables_1440 (
    name character varying,
    value integer
);
 "   DROP TABLE public.variables_1440;
       public         heap    postgres    false                       1259    25097 
   views_1148    TABLE     }   CREATE TABLE public.views_1148 (
    article_id integer,
    author_id integer,
    viewer_id integer,
    view_date date
);
    DROP TABLE public.views_1148;
       public         heap    postgres    false                       1259    25100 
   views_1149    TABLE     }   CREATE TABLE public.views_1149 (
    article_id integer,
    author_id integer,
    viewer_id integer,
    view_date date
);
    DROP TABLE public.views_1149;
       public         heap    postgres    false            3           1259    26166    visits_1336    TABLE     N   CREATE TABLE public.visits_1336 (
    user_id integer,
    visit_date date
);
    DROP TABLE public.visits_1336;
       public         heap    postgres    false            �           1259    36436    visits_1581    TABLE     S   CREATE TABLE public.visits_1581 (
    visit_id integer,
    customer_id integer
);
    DROP TABLE public.visits_1581;
       public         heap    postgres    false            �           1259    36101    visits_2051    TABLE     f   CREATE TABLE public.visits_2051 (
    visit_id integer,
    member_id integer,
    visit_date date
);
    DROP TABLE public.visits_2051;
       public         heap    postgres    false            �            1259    24870    vote_574    TABLE     K   CREATE TABLE public.vote_574 (
    id integer,
    candidate_id integer
);
    DROP TABLE public.vote_574;
       public         heap    postgres    false            �           1259    36424    warehouse_1571    TABLE     n   CREATE TABLE public.warehouse_1571 (
    name character varying,
    product_id integer,
    units integer
);
 "   DROP TABLE public.warehouse_1571;
       public         heap    postgres    false            �           1259    36309    weather_1294    TABLE     f   CREATE TABLE public.weather_1294 (
    country_id integer,
    weather_state integer,
    day date
);
     DROP TABLE public.weather_1294;
       public         heap    postgres    false            �            1259    16496    weather_197    TABLE     l   CREATE TABLE public.weather_197 (
    id integer NOT NULL,
    record_date date,
    temperature integer
);
    DROP TABLE public.weather_197;
       public         heap    postgres    false            �           1259    36234    weather_2314    TABLE     \   CREATE TABLE public.weather_2314 (
    city_id integer,
    day date,
    degree integer
);
     DROP TABLE public.weather_2314;
       public         heap    postgres    false            �            1259    16598 	   world_595    TABLE     �   CREATE TABLE public.world_595 (
    name character varying(20),
    continent character varying(20),
    area bigint,
    population bigint,
    gdp bigint
);
    DROP TABLE public.world_595;
       public         heap    postgres    false            �          0    27535    accepted_rides_1635 
   TABLE DATA           _   COPY public.accepted_rides_1635 (ride_id, driver_id, ride_distance, ride_duration) FROM stdin;
    public          postgres    false    355   �      �          0    27565    accepted_rides_1645 
   TABLE DATA           _   COPY public.accepted_rides_1645 (ride_id, driver_id, ride_distance, ride_duration) FROM stdin;
    public          postgres    false    362   x�      �          0    27590    accepted_rides_1651 
   TABLE DATA           _   COPY public.accepted_rides_1651 (ride_id, driver_id, ride_distance, ride_duration) FROM stdin;
    public          postgres    false    370   ��      �          0    27418    accounts_1454 
   TABLE DATA           1   COPY public.accounts_1454 (id, name) FROM stdin;
    public          postgres    false    334   H�      �          0    34268    accounts_1843 
   TABLE DATA           ?   COPY public.accounts_1843 (account_id, max_income) FROM stdin;
    public          postgres    false    382   z�                0    35987    accounts_1907 
   TABLE DATA           ;   COPY public.accounts_1907 (account_id, income) FROM stdin;
    public          postgres    false    386   ��      �          0    25055    actions_1113 
   TABLE DATA           T   COPY public.actions_1113 (user_id, post_id, action_date, action, extra) FROM stdin;
    public          postgres    false    274   �      �          0    25073    actions_1132 
   TABLE DATA           T   COPY public.actions_1132 (user_id, post_id, action_date, action, extra) FROM stdin;
    public          postgres    false    277   a�      �          0    27304    activities_1355 
   TABLE DATA           3   COPY public.activities_1355 (id, name) FROM stdin;
    public          postgres    false    319   �      Q          0    36369    activities_1484 
   TABLE DATA           =   COPY public.activities_1484 (sell_date, product) FROM stdin;
    public          postgres    false    464   �      �          0    25018    activity_1097 
   TABLE DATA           W   COPY public.activity_1097 (player_id, device_id, event_date, games_played) FROM stdin;
    public          postgres    false    268   ��      �          0    25085    activity_1141 
   TABLE DATA           Z   COPY public.activity_1141 (user_id, session_id, activity_date, activity_type) FROM stdin;
    public          postgres    false    279   К      �          0    25091    activity_1142 
   TABLE DATA           Z   COPY public.activity_1142 (user_id, session_id, activity_date, activity_type) FROM stdin;
    public          postgres    false    280   L�      h          0    36493    activity_1661 
   TABLE DATA           [   COPY public.activity_1661 (machine_id, process_id, activity_type, "timestamp") FROM stdin;
    public          postgres    false    487   ֛      �          0    25015    activity_511 
   TABLE DATA           V   COPY public.activity_511 (player_id, device_id, event_date, games_played) FROM stdin;
    public          postgres    false    267   A�      U          0    16582    activity_534 
   TABLE DATA           V   COPY public.activity_534 (player_id, device_id, event_date, games_played) FROM stdin;
    public          postgres    false    212   ��      g          0    16678    activity_550 
   TABLE DATA           V   COPY public.activity_550 (player_id, device_id, event_date, games_played) FROM stdin;
    public          postgres    false    230   �      h          0    16684    activity_550_tc_2 
   TABLE DATA           [   COPY public.activity_550_tc_2 (player_id, device_id, event_date, games_played) FROM stdin;
    public          postgres    false    231   5�      �          0    24969    actor_director_1050 
   TABLE DATA           Q   COPY public.actor_director_1050 (actor_id, director_id, "timestamp") FROM stdin;
    public          postgres    false    258   ��      �          0    36698    address_175 
   TABLE DATA           G   COPY public.address_175 (addressid, personid, city, state) FROM stdin;
    public          postgres    false    525   Ý      I          0    36315    ads_1322 
   TABLE DATA           :   COPY public.ads_1322 (ad_id, user_id, action) FROM stdin;
    public          postgres    false    456   ��      u          0    36562    ads_1809 
   TABLE DATA           C   COPY public.ads_1809 (ad_id, customer_id, "timestamp") FROM stdin;
    public          postgres    false    500   >�      �          0    25030    amz 
   TABLE DATA           -   COPY public.amz (oid, item, qty) FROM stdin;
    public          postgres    false    271   m�      S          0    16540 	   bonus_577 
   TABLE DATA           3   COPY public.bonus_577 ("empId", bonus) FROM stdin;
    public          postgres    false    210   ��      �          0    25021 
   books_1098 
   TABLE DATA           C   COPY public.books_1098 (book_id, name, available_from) FROM stdin;
    public          postgres    false    269   ˞      �          0    27575 
   boxes_1715 
   TABLE DATA           Q   COPY public.boxes_1715 (box_id, chest_id, apple_count, orange_count) FROM stdin;
    public          postgres    false    365   Z�      $          0    36137 
   buses_2142 
   TABLE DATA           :   COPY public.buses_2142 (bus_id, arrival_time) FROM stdin;
    public          postgres    false    419   ��      "          0    36131 
   buses_2153 
   TABLE DATA           D   COPY public.buses_2153 (bus_id, arrival_time, capacity) FROM stdin;
    public          postgres    false    417   ҟ      �          0    36610    california_2072 
   TABLE DATA           <   COPY public.california_2072 (student_id, score) FROM stdin;
    public          postgres    false    512   �      �          0    27477 
   calls_1501 
   TABLE DATA           D   COPY public.calls_1501 (caller_id, callee_id, duration) FROM stdin;
    public          postgres    false    344   )�      �          0    27569 
   calls_1699 
   TABLE DATA           >   COPY public.calls_1699 (from_id, to_id, duration) FROM stdin;
    public          postgres    false    363   v�                0    36023 
   calls_1972 
   TABLE DATA           H   COPY public.calls_1972 (caller_id, recipient_id, call_time) FROM stdin;
    public          postgres    false    395   ��      l          0    24864    candidate_574 
   TABLE DATA           1   COPY public.candidate_574 (id, name) FROM stdin;
    public          postgres    false    235   !�                0    36050    candidates_2004 
   TABLE DATA           J   COPY public.candidates_2004 (employee_id, experience, salary) FROM stdin;
    public          postgres    false    399   R�                0    36062    candidates_2004_tc_2 
   TABLE DATA           O   COPY public.candidates_2004_tc_2 (employee_id, experience, salary) FROM stdin;
    public          postgres    false    400   ��                0    36068    candidates_2010 
   TABLE DATA           J   COPY public.candidates_2010 (employee_id, experience, salary) FROM stdin;
    public          postgres    false    401   ١                0    36074    candidates_2010_tc_2 
   TABLE DATA           O   COPY public.candidates_2010_tc_2 (employee_id, experience, salary) FROM stdin;
    public          postgres    false    402   $�                0    36086    candidates_2041 
   TABLE DATA           Y   COPY public.candidates_2041 (candidate_id, name, years_of_exp, interview_id) FROM stdin;
    public          postgres    false    405   q�      �          0    27605    championships_1783 
   TABLE DATA           X   COPY public.championships_1783 (year, wimbledon, fr_open, us_open, au_open) FROM stdin;
    public          postgres    false    374   Ģ      �          0    25196    chargebacks_1205 
   TABLE DATA           A   COPY public.chargebacks_1205 (trans_id, charge_date) FROM stdin;
    public          postgres    false    301   ��      �          0    27578    chests_1715 
   TABLE DATA           J   COPY public.chests_1715 (chest_id, apple_count, orange_count) FROM stdin;
    public          postgres    false    366   7�      \          0    16613 
   cinema_603 
   TABLE DATA           3   COPY public.cinema_603 (seat_id, free) FROM stdin;
    public          postgres    false    219   v�      ~          0    24939 
   cinema_620 
   TABLE DATA           D   COPY public.cinema_620 (id, movie, description, rating) FROM stdin;
    public          postgres    false    253   ��      =          0    36264    coffee_shop_2388 
   TABLE DATA           5   COPY public.coffee_shop_2388 (id, drink) FROM stdin;
    public          postgres    false    444   "�      ^          0    16621    company_607 
   TABLE DATA           9   COPY public.company_607 (com_id, name, city) FROM stdin;
    public          postgres    false    221   s�      	          0    36011    confirmations_1934 
   TABLE DATA           I   COPY public.confirmations_1934 (user_id, time_stamp, action) FROM stdin;
    public          postgres    false    392   Ȥ      {          0    36583    confirmations_1939 
   TABLE DATA           I   COPY public.confirmations_1939 (user_id, time_stamp, action) FROM stdin;
    public          postgres    false    506   R�      �          0    27349    contacts_1364 
   TABLE DATA           M   COPY public.contacts_1364 (user_id, contact_name, contact_email) FROM stdin;
    public          postgres    false    324   ԥ      S          0    36381    content_1495 
   TABLE DATA           U   COPY public.content_1495 (content_id, title, kids_content, content_type) FROM stdin;
    public          postgres    false    466   =�      �          0    27614    contests_1811 
   TABLE DATA           Z   COPY public.contests_1811 (contest_id, gold_medal, silver_medal, bronz_medal) FROM stdin;
    public          postgres    false    375   ��      F          0    36303    countries_1294 
   TABLE DATA           B   COPY public.countries_1294 (country_id, country_name) FROM stdin;
    public          postgres    false    453   ��      �          0    27471    country_1501 
   TABLE DATA           :   COPY public.country_1501 (name, country_code) FROM stdin;
    public          postgres    false    343   N�      Y          0    16601    courses_596 
   TABLE DATA           5   COPY public.courses_596 (student, class) FROM stdin;
    public          postgres    false    216   ��      �          0    24963    customer_1045 
   TABLE DATA           A   COPY public.customer_1045 (customer_id, product_key) FROM stdin;
    public          postgres    false    256   ��      �          0    27266    customer_1321 
   TABLE DATA           N   COPY public.customer_1321 (customer_id, name, visited_on, amount) FROM stdin;
    public          postgres    false    314    �      ;          0    36258    customer_2372 
   TABLE DATA           D   COPY public.customer_2372 (customer_id, salesperson_id) FROM stdin;
    public          postgres    false    442   ��      V          0    16585    customer_584 
   TABLE DATA           >   COPY public.customer_584 (id, name, reference_id) FROM stdin;
    public          postgres    false    213   �      �          0    27343    customers_1364 
   TABLE DATA           K   COPY public.customers_1364 (customer_id, customer_name, email) FROM stdin;
    public          postgres    false    323   3�      �          0    27379    customers_1398 
   TABLE DATA           D   COPY public.customers_1398 (customer_id, customer_name) FROM stdin;
    public          postgres    false    328   ��      T          0    36388    customers_1511 
   TABLE DATA           D   COPY public.customers_1511 (customer_id, name, country) FROM stdin;
    public          postgres    false    467   ̩      �          0    27480    customers_1532 
   TABLE DATA           ;   COPY public.customers_1532 (customer_id, name) FROM stdin;
    public          postgres    false    345   �      �          0    27493    customers_1549 
   TABLE DATA           ;   COPY public.customers_1549 (customer_id, name) FROM stdin;
    public          postgres    false    348   g�      �          0    27538    customers_1596 
   TABLE DATA           ;   COPY public.customers_1596 (customer_id, name) FROM stdin;
    public          postgres    false    356   ��      `          0    36451    customers_1607 
   TABLE DATA           D   COPY public.customers_1607 (customer_id, customer_name) FROM stdin;
    public          postgres    false    479   ��      �          0    27553    customers_1613 
   TABLE DATA           D   COPY public.customers_1613 (customer_id, customer_name) FROM stdin;
    public          postgres    false    359   /�      v          0    36565    customers_1821 
   TABLE DATA           D   COPY public.customers_1821 (customer_id, year, revenue) FROM stdin;
    public          postgres    false    501   d�      M          0    16450    customers_183 
   TABLE DATA           1   COPY public.customers_183 (id, name) FROM stdin;
    public          postgres    false    204   ��      m          0    36523    daily_sales_1693 
   TABLE DATA           S   COPY public.daily_sales_1693 (date_id, make_name, lead_id, partner_id) FROM stdin;
    public          postgres    false    492   �      &          0    36144 	   data_2159 
   TABLE DATA           :   COPY public.data_2159 (first_col, second_col) FROM stdin;
    public          postgres    false    421   >�      w          0    36568 	   days_1853 
   TABLE DATA           (   COPY public.days_1853 (day) FROM stdin;
    public          postgres    false    502   k�      �          0    25149    delivery_1173 
   TABLE DATA           j   COPY public.delivery_1173 (delivery_id, customer_id, order_date, customer_pref_delivery_date) FROM stdin;
    public          postgres    false    292   ��      �          0    25152    delivery_1174 
   TABLE DATA           j   COPY public.delivery_1174 (delivery_id, customer_id, order_date, customer_pref_delivery_date) FROM stdin;
    public          postgres    false    293   ��      �          0    25166    department_1179 
   TABLE DATA           =   COPY public.department_1179 (id, revenue, month) FROM stdin;
    public          postgres    false    295   O�      b          0    16639    department_184 
   TABLE DATA           2   COPY public.department_184 (id, name) FROM stdin;
    public          postgres    false    225   ��      d          0    16654    department_185 
   TABLE DATA           2   COPY public.department_185 (id, name) FROM stdin;
    public          postgres    false    227   ��      q          0    24888    department_580 
   TABLE DATA           <   COPY public.department_580 (dept_id, dept_name) FROM stdin;
    public          postgres    false    240   �      K          0    36342    departments_1350 
   TABLE DATA           4   COPY public.departments_1350 (id, name) FROM stdin;
    public          postgres    false    458    �      �          0    27529    drivers_1635 
   TABLE DATA           <   COPY public.drivers_1635 (driver_id, join_date) FROM stdin;
    public          postgres    false    353   {�      �          0    27559    drivers_1645 
   TABLE DATA           <   COPY public.drivers_1645 (driver_id, join_date) FROM stdin;
    public          postgres    false    360   Ϯ      �          0    27584    drivers_1651 
   TABLE DATA           <   COPY public.drivers_1651 (driver_id, join_date) FROM stdin;
    public          postgres    false    368   #�      �          0    25156    emp_name 
   TABLE DATA           (   COPY public.emp_name (name) FROM stdin;
    public          postgres    false    294   w�      �          0    24985    employee_1075 
   TABLE DATA           L   COPY public.employee_1075 (employee_id, name, experience_years) FROM stdin;
    public          postgres    false    262   ��      �          0    24994    employee_1077 
   TABLE DATA           L   COPY public.employee_1077 (employee_id, name, experience_years) FROM stdin;
    public          postgres    false    264   �      H          0    36312    employee_1303 
   TABLE DATA           =   COPY public.employee_1303 (employee_id, team_id) FROM stdin;
    public          postgres    false    455   &�      L          0    36348    employee_1378 
   TABLE DATA           1   COPY public.employee_1378 (id, name) FROM stdin;
    public          postgres    false    459   V�      s          0    36553    employee_1789 
   TABLE DATA           Q   COPY public.employee_1789 (employee_id, department_id, primary_flag) FROM stdin;
    public          postgres    false    498   ��      K          0    16425    employee_181 
   TABLE DATA           D   COPY public.employee_181 (id, name, salary, manager_id) FROM stdin;
    public          postgres    false    202   ٰ      a          0    16633    employee_184 
   TABLE DATA           G   COPY public.employee_184 (id, name, salary, department_id) FROM stdin;
    public          postgres    false    224   "�      c          0    16645    employee_185 
   TABLE DATA           G   COPY public.employee_185 (id, name, salary, department_id) FROM stdin;
    public          postgres    false    226   p�      i          0    16687    employee_569 
   TABLE DATA           ;   COPY public.employee_569 (id, company, salary) FROM stdin;
    public          postgres    false    232   ڱ      Q          0    16506    employee_570 
   TABLE DATA           H   COPY public.employee_570 (id, name, department, manager_id) FROM stdin;
    public          postgres    false    208   E�      R          0    16527    employee_577 
   TABLE DATA           I   COPY public.employee_577 ("empId", name, supervisor, salary) FROM stdin;
    public          postgres    false    209   ��      o          0    24879    employee_579 
   TABLE DATA           9   COPY public.employee_579 (id, month, salary) FROM stdin;
    public          postgres    false    238   �      z          0    24918    employee_615 
   TABLE DATA           B   COPY public.employee_615 (employee_id, department_id) FROM stdin;
    public          postgres    false    249   +�      M          0    36354    employee_uni_1378 
   TABLE DATA           :   COPY public.employee_uni_1378 (id, unique_id) FROM stdin;
    public          postgres    false    460   R�      �          0    26181    employees_1270 
   TABLE DATA           P   COPY public.employees_1270 (employee_id, employee_name, manager_id) FROM stdin;
    public          postgres    false    311   }�      o          0    36532    employees_1731 
   TABLE DATA           L   COPY public.employees_1731 (employee_id, name, reports_to, age) FROM stdin;
    public          postgres    false    494   �      p          0    36538    employees_1741 
   TABLE DATA           N   COPY public.employees_1741 (emp_id, event_day, in_time, out_time) FROM stdin;
    public          postgres    false    495   2�      x          0    36571    employees_1873 
   TABLE DATA           C   COPY public.employees_1873 (employee_id, name, salary) FROM stdin;
    public          postgres    false    503   ��                0    35981    employees_1875 
   TABLE DATA           C   COPY public.employees_1875 (employee_id, name, salary) FROM stdin;
    public          postgres    false    385   ܴ      |          0    36589    employees_1965 
   TABLE DATA           ;   COPY public.employees_1965 (employee_id, name) FROM stdin;
    public          postgres    false    507   1�      ~          0    36598    employees_1978 
   TABLE DATA           O   COPY public.employees_1978 (employee_id, name, manager_id, salary) FROM stdin;
    public          postgres    false    509   h�      >          0    36270    employees_2394 
   TABLE DATA           C   COPY public.employees_2394 (employee_id, needed_hours) FROM stdin;
    public          postgres    false    445   �      �          0    25051    enrollments_1112 
   TABLE DATA           H   COPY public.enrollments_1112 (student_id, course_id, grade) FROM stdin;
    public          postgres    false    273   �      �          0    25061    events_1126 
   TABLE DATA           J   COPY public.events_1126 (business_id, event_type, occurences) FROM stdin;
    public          postgres    false    275   Q�                0    36029 	   exam_1988 
   TABLE DATA           9   COPY public.exam_1988 (score, student_count) FROM stdin;
    public          postgres    false    397   ��      E          0    36297    examinations_1280 
   TABLE DATA           E   COPY public.examinations_1280 (student_id, subject_name) FROM stdin;
    public          postgres    false    452   ض      �          0    27397 
   exams_1412 
   TABLE DATA           @   COPY public.exams_1412 (exam_id, student_id, score) FROM stdin;
    public          postgres    false    331   %�      �          0    27596    executed_1767 
   TABLE DATA           <   COPY public.executed_1767 (task_id, subtask_id) FROM stdin;
    public          postgres    false    372   p�                0    36038    experiments_1990 
   TABLE DATA           T   COPY public.experiments_1990 (experiment_id, platform, experiment_name) FROM stdin;
    public          postgres    false    398   ��      �          0    27373    expressions_1440 
   TABLE DATA           Q   COPY public.expressions_1440 (left_operand, operator, right_operand) FROM stdin;
    public          postgres    false    327   ��      �          0    25199    failed_1225 
   TABLE DATA           0   COPY public.failed_1225 (fail_date) FROM stdin;
    public          postgres    false    302   *�                 0    36125    flights_2112 
   TABLE DATA           Y   COPY public.flights_2112 (departure_airport, arrival_airport, flights_count) FROM stdin;
    public          postgres    false    415   b�      !          0    36128    flights_2112_tc_2 
   TABLE DATA           ^   COPY public.flights_2112_tc_2 (departure_airport, arrival_airport, flights_count) FROM stdin;
    public          postgres    false    416   ��      x          0    24912 
   follow_614 
   TABLE DATA           8   COPY public.follow_614 (followee, follower) FROM stdin;
    public          postgres    false    247   Ƹ      n          0    36529    followers_1729 
   TABLE DATA           >   COPY public.followers_1729 (user_id, follower_id) FROM stdin;
    public          postgres    false    493   �      Z          0    16604    friend_request_597 
   TABLE DATA           Q   COPY public.friend_request_597 (sender_id, send_to_id, request_date) FROM stdin;
    public          postgres    false    217   �      �          0    27298    friends_1355 
   TABLE DATA           :   COPY public.friends_1355 (id, name, activity) FROM stdin;
    public          postgres    false    318   V�      �          0    26172    friendship_1264 
   TABLE DATA           =   COPY public.friendship_1264 (user_id1, user_id2) FROM stdin;
    public          postgres    false    309   ͹      �          0    27630    friendship_1892 
   TABLE DATA           =   COPY public.friendship_1892 (user1_id, user2_id) FROM stdin;
    public          postgres    false    378   ��                0    35999    friendship_1917 
   TABLE DATA           =   COPY public.friendship_1917 (user1_id, user2_id) FROM stdin;
    public          postgres    false    388   1�                0    36005    friendship_1919 
   TABLE DATA           =   COPY public.friendship_1919 (user1_id, user2_id) FROM stdin;
    public          postgres    false    390   R�      
          0    36017    friendship_1949 
   TABLE DATA           =   COPY public.friendship_1949 (user1_id, user2_id) FROM stdin;
    public          postgres    false    393   y�      3          0    36228    genders_2308 
   TABLE DATA           7   COPY public.genders_2308 (user_id, gender) FROM stdin;
    public          postgres    false    434   ��      �          0    27490    groups 
   TABLE DATA           1   COPY public.groups (group_id, value) FROM stdin;
    public          postgres    false    347   ��      r          0    24894    insurance_585 
   TABLE DATA           J   COPY public.insurance_585 (pid, tiv_2015, tiv_2016, lat, lon) FROM stdin;
    public          postgres    false    241   2�      k          0    36514    invoice_1677 
   TABLE DATA           ^   COPY public.invoice_1677 (invoice_id, product_id, rest, paid, canceled, refunded) FROM stdin;
    public          postgres    false    490   r�      �          0    27400    invoices_1364 
   TABLE DATA           C   COPY public.invoices_1364 (invoice_id, price, user_id) FROM stdin;
    public          postgres    false    332   ��      �          0    25113 
   items_1158 
   TABLE DATA           9   COPY public.items_1158 (item_id, item_brand) FROM stdin;
    public          postgres    false    285   ��      �          0    25128 
   items_1159 
   TABLE DATA           9   COPY public.items_1159 (item_id, item_brand) FROM stdin;
    public          postgres    false    288   8�      �          0    27459 
   items_1479 
   TABLE DATA           G   COPY public.items_1479 (item_id, item_name, item_category) FROM stdin;
    public          postgres    false    341   r�      +          0    36169    keywords_2199 
   TABLE DATA           7   COPY public.keywords_2199 (topic_id, word) FROM stdin;
    public          postgres    false    426   �      �          0    26175 
   likes_1264 
   TABLE DATA           6   COPY public.likes_1264 (user_id, page_id) FROM stdin;
    public          postgres    false    310    �      �          0    27633 
   likes_1892 
   TABLE DATA           6   COPY public.likes_1892 (user_id, page_id) FROM stdin;
    public          postgres    false    379   c�                0    35996    listens_1917 
   TABLE DATA           =   COPY public.listens_1917 (user_id, song_id, day) FROM stdin;
    public          postgres    false    387   ��                0    36002    listens_1919 
   TABLE DATA           =   COPY public.listens_1919 (user_id, song_id, day) FROM stdin;
    public          postgres    false    389   ��      �          0    27581    log_info_1747 
   TABLE DATA           N   COPY public.log_info_1747 (account_id, ip_address, login, logout) FROM stdin;
    public          postgres    false    367   L�      �          0    27424    logins_1454 
   TABLE DATA           5   COPY public.logins_1454 (id, login_date) FROM stdin;
    public          postgres    false    335   Ⱦ      y          0    36577    logins_1890 
   TABLE DATA           :   COPY public.logins_1890 (user_id, time_stamp) FROM stdin;
    public          postgres    false    504   �      �          0    26187 	   logs_1285 
   TABLE DATA           +   COPY public.logs_1285 (log_id) FROM stdin;
    public          postgres    false    312   ��      �          0    36704    logs_180 
   TABLE DATA           +   COPY public.logs_180 (id, num) FROM stdin;
    public          postgres    false    526   ��      ?          0    36273 	   logs_2394 
   TABLE DATA           C   COPY public.logs_2394 (employee_id, in_time, out_time) FROM stdin;
    public          postgres    false    446   �      �          0    25181    matches_1194 
   TABLE DATA           h   COPY public.matches_1194 (match_id, first_player, second_player, first_score, second_score) FROM stdin;
    public          postgres    false    298   T�      �          0    26163    matches_1212 
   TABLE DATA           `   COPY public.matches_1212 (match_id, host_team, guest_team, host_goals, guest_goals) FROM stdin;
    public          postgres    false    306   ��      �          0    34265    matches_1841 
   TABLE DATA           d   COPY public.matches_1841 (home_team_id, away_team_id, home_team_goals, away_team_goals) FROM stdin;
    public          postgres    false    381   ��      '          0    36148    matches_2173 
   TABLE DATA           D   COPY public.matches_2173 (player_id, match_day, result) FROM stdin;
    public          postgres    false    422   �      (          0    36154    matches_2173_tc_2 
   TABLE DATA           I   COPY public.matches_2173_tc_2 (player_id, match_day, result) FROM stdin;
    public          postgres    false    423   r�                0    36095    members_2051 
   TABLE DATA           7   COPY public.members_2051 (member_id, name) FROM stdin;
    public          postgres    false    407   ��      �          0    27295    movie_rating_1341 
   TABLE DATA           R   COPY public.movie_rating_1341 (movie_id, user_id, rating, created_at) FROM stdin;
    public          postgres    false    317   7�      �          0    27283    movies_1341 
   TABLE DATA           6   COPY public.movies_1341 (movie_id, title) FROM stdin;
    public          postgres    false    315   ��      �          0    36607    newyork_2072 
   TABLE DATA           9   COPY public.newyork_2072 (student_id, score) FROM stdin;
    public          postgres    false    511   ��      �          0    27428    npv_1421 
   TABLE DATA           1   COPY public.npv_1421 (id, year, npv) FROM stdin;
    public          postgres    false    336   ��      |          0    24933 
   number_619 
   TABLE DATA           )   COPY public.number_619 (num) FROM stdin;
    public          postgres    false    251   G�      }          0    24936    number_619_tc_2 
   TABLE DATA           .   COPY public.number_619_tc_2 (num) FROM stdin;
    public          postgres    false    252   r�      j          0    16694    numbers_571 
   TABLE DATA           8   COPY public.numbers_571 (number, frequency) FROM stdin;
    public          postgres    false    233   ��      k          0    16697    numbers_571_tc_2 
   TABLE DATA           =   COPY public.numbers_571_tc_2 (number, frequency) FROM stdin;
    public          postgres    false    234   ��      �          0    36641    olympic_2377 
   TABLE DATA           Z   COPY public.olympic_2377 (country, gold_medals, silver_medals, bronze_medals) FROM stdin;
    public          postgres    false    520   ��      �          0    25027    orders_1098 
   TABLE DATA           Q   COPY public.orders_1098 (order_id, book_id, quantity, dispatch_date) FROM stdin;
    public          postgres    false    270   >�      �          0    25110    orders_1158 
   TABLE DATA           Y   COPY public.orders_1158 (order_id, order_date, item_id, buyer_id, seller_id) FROM stdin;
    public          postgres    false    284   ��      �          0    25125    orders_1159 
   TABLE DATA           Y   COPY public.orders_1159 (order_id, order_date, item_id, buyer_id, seller_id) FROM stdin;
    public          postgres    false    287   ��      �          0    36659    orders_1327 
   TABLE DATA           C   COPY public.orders_1327 (product_id, order_date, unit) FROM stdin;
    public          postgres    false    522   H�      �          0    27385    orders_1398 
   TABLE DATA           J   COPY public.orders_1398 (order_id, customer_id, product_name) FROM stdin;
    public          postgres    false    329   ��      �          0    27456    orders_1479 
   TABLE DATA           [   COPY public.orders_1479 (order_id, customer_id, order_date, item_id, quantity) FROM stdin;
    public          postgres    false    340   ��      V          0    36400    orders_1511 
   TABLE DATA           ^   COPY public.orders_1511 (order_id, customer_id, product_id, order_date, quantity) FROM stdin;
    public          postgres    false    469   ^�      �          0    27486    orders_1532 
   TABLE DATA           N   COPY public.orders_1532 (order_id, order_date, customer_id, cost) FROM stdin;
    public          postgres    false    346   ��      �          0    27499    orders_1549 
   TABLE DATA           T   COPY public.orders_1549 (order_id, order_date, customer_id, product_id) FROM stdin;
    public          postgres    false    349   2�      Y          0    36421    orders_1565 
   TABLE DATA           Q   COPY public.orders_1565 (order_id, order_date, customer_id, invoice) FROM stdin;
    public          postgres    false    472   ��      �          0    27544    orders_1596 
   TABLE DATA           T   COPY public.orders_1596 (order_id, order_date, customer_id, product_id) FROM stdin;
    public          postgres    false    357   �      a          0    36457    orders_1607 
   TABLE DATA           ^   COPY public.orders_1607 (order_id, sale_date, order_cost, customer_id, seller_id) FROM stdin;
    public          postgres    false    480   x�      N          0    16473 
   orders_183 
   TABLE DATA           5   COPY public.orders_183 (id, customer_id) FROM stdin;
    public          postgres    false    205   ��                0    36122    orders_2084 
   TABLE DATA           H   COPY public.orders_2084 (order_id, customer_id, order_type) FROM stdin;
    public          postgres    false    414   ��      1          0    36222    orders_2292 
   TABLE DATA           S   COPY public.orders_2292 (order_id, product_id, quatity, purchase_date) FROM stdin;
    public          postgres    false    432   7�      W          0    16593 
   orders_586 
   TABLE DATA           }   COPY public.orders_586 (order_number, customer_number, order_date, required_date, shipped_date, status, comment) FROM stdin;
    public          postgres    false    214   ��      _          0    16624 
   orders_607 
   TABLE DATA           T   COPY public.orders_607 (order_id, order_date, com_id, sales_id, amount) FROM stdin;
    public          postgres    false    222   ��                0    34280    orders_details_1867 
   TABLE DATA           M   COPY public.orders_details_1867 (order_id, product_id, quantity) FROM stdin;
    public          postgres    false    384   =�      %          0    36140    passengers_2142 
   TABLE DATA           E   COPY public.passengers_2142 (passenger_id, arrival_time) FROM stdin;
    public          postgres    false    420   ��      #          0    36134    passengers_2153 
   TABLE DATA           E   COPY public.passengers_2153 (passenger_id, arrival_time) FROM stdin;
    public          postgres    false    418   ��      W          0    36409    patients_1527 
   TABLE DATA           M   COPY public.patients_1527 (patient_id, patient_name, conditions) FROM stdin;
    public          postgres    false    470   ��      �          0    27465    person_1501 
   TABLE DATA           =   COPY public.person_1501 (id, name, phone_number) FROM stdin;
    public          postgres    false    342   a�      �          0    36692 
   person_175 
   TABLE DATA           C   COPY public.person_175 (personid, firstname, lastname) FROM stdin;
    public          postgres    false    524   ��      L          0    16438 
   person_182 
   TABLE DATA           /   COPY public.person_182 (id, email) FROM stdin;
    public          postgres    false    203   ��      O          0    16483 
   person_196 
   TABLE DATA           /   COPY public.person_196 (id, email) FROM stdin;
    public          postgres    false    206   *�      T          0    16562    person_196_ans 
   TABLE DATA           3   COPY public.person_196_ans (id, email) FROM stdin;
    public          postgres    false    211   d�      �          0    25143 
   pivot_test 
   TABLE DATA           5   COPY public.pivot_test (year, rain_days) FROM stdin;
    public          postgres    false    290   ��      �          0    25137    pivot_test_rainfall 
   TABLE DATA           K   COPY public.pivot_test_rainfall (city, year, month, rain_days) FROM stdin;
    public          postgres    false    289   ��      t          0    36559    playback_1809 
   TABLE DATA           V   COPY public.playback_1809 (session_id, customer_id, start_time, end_time) FROM stdin;
    public          postgres    false    499   ��      �          0    25178    players_1194 
   TABLE DATA           ;   COPY public.players_1194 (player_id, group_id) FROM stdin;
    public          postgres    false    297   '�      �          0    27599    players_1783 
   TABLE DATA           >   COPY public.players_1783 (player_id, player_name) FROM stdin;
    public          postgres    false    373   d�      v          0    24906    point_2d_612 
   TABLE DATA           ,   COPY public.point_2d_612 (x, y) FROM stdin;
    public          postgres    false    245   ��      w          0    24909 	   point_613 
   TABLE DATA           &   COPY public.point_613 (x) FROM stdin;
    public          postgres    false    246   ��      �          0    27446    points_1459 
   TABLE DATA           ;   COPY public.points_1459 (id, x_value, y_value) FROM stdin;
    public          postgres    false    338   ��      *          0    36166    points_change_2175 
   TABLE DATA           D   COPY public.points_change_2175 (team_id, points_change) FROM stdin;
    public          postgres    false    425   �      ,          0    36175 
   posts_2199 
   TABLE DATA           6   COPY public.posts_2199 (post_id, content) FROM stdin;
    public          postgres    false    427   J�      A          0    36279    prices_1251 
   TABLE DATA           N   COPY public.prices_1251 (product_id, start_date, end_date, price) FROM stdin;
    public          postgres    false    448   ��                0    36604    problems_2026 
   TABLE DATA           D   COPY public.problems_2026 (problem_id, likes, dislikes) FROM stdin;
    public          postgres    false    510   M�      �          0    24966    product_1045 
   TABLE DATA           3   COPY public.product_1045 (product_key) FROM stdin;
    public          postgres    false    257   ��      �          0    24975    product_1068 
   TABLE DATA           @   COPY public.product_1068 (product_id, product_name) FROM stdin;
    public          postgres    false    260   ��      �          0    25000    product_1082 
   TABLE DATA           L   COPY public.product_1082 (product_id, product_name, unit_price) FROM stdin;
    public          postgres    false    265   ��      �          0    27328    product_1384 
   TABLE DATA           @   COPY public.product_1384 (product_id, product_name) FROM stdin;
    public          postgres    false    321   5�      U          0    36394    product_1511 
   TABLE DATA           F   COPY public.product_1511 (product_id, description, price) FROM stdin;
    public          postgres    false    468   s�      j          0    36508    product_1677 
   TABLE DATA           8   COPY public.product_1677 (product_id, name) FROM stdin;
    public          postgres    false    489   ��      6          0    36240    product_2324 
   TABLE DATA           9   COPY public.product_2324 (product_id, price) FROM stdin;
    public          postgres    false    437   ��      �          0    36629    product_2329 
   TABLE DATA           9   COPY public.product_2329 (product_id, price) FROM stdin;
    public          postgres    false    517   �      �          0    25146    products_1164 
   TABLE DATA           K   COPY public.products_1164 (product_id, new_price, change_date) FROM stdin;
    public          postgres    false    291   I�      �          0    36653    products_1327 
   TABLE DATA           S   COPY public.products_1327 (product_id, product_name, product_category) FROM stdin;
    public          postgres    false    521   ��      �          0    27514    products_1549 
   TABLE DATA           H   COPY public.products_1549 (product_id, product_name, price) FROM stdin;
    public          postgres    false    350   �      [          0    36430    products_1571 
   TABLE DATA           X   COPY public.products_1571 (product_id, product_name, width, length, height) FROM stdin;
    public          postgres    false    474   X�      �          0    27547    products_1596 
   TABLE DATA           H   COPY public.products_1596 (product_id, product_name, price) FROM stdin;
    public          postgres    false    358   ��      q          0    36541    products_1757 
   TABLE DATA           I   COPY public.products_1757 (product_id, low_fats, recyclable) FROM stdin;
    public          postgres    false    496   �      r          0    36547    products_1777 
   TABLE DATA           A   COPY public.products_1777 (product_id, store, price) FROM stdin;
    public          postgres    false    497   :�      /          0    36190    products_2252 
   TABLE DATA           A   COPY public.products_2252 (product_id, store, price) FROM stdin;
    public          postgres    false    430   {�      0          0    36216    products_2253 
   TABLE DATA           Y   COPY public.products_2253 (product_id, "LC_Store", "Nozama", "Shop", "Souq") FROM stdin;
    public          postgres    false    431   ��      8          0    36246    products_2362 
   TABLE DATA           :   COPY public.products_2362 (product_id, price) FROM stdin;
    public          postgres    false    439   �      �          0    24982    project_1075 
   TABLE DATA           ?   COPY public.project_1075 (project_id, employee_id) FROM stdin;
    public          postgres    false    261   6�      �          0    24991    project_1077 
   TABLE DATA           ?   COPY public.project_1077 (project_id, employee_id) FROM stdin;
    public          postgres    false    263   d�                0    36104    purchases_2051 
   TABLE DATA           B   COPY public.purchases_2051 (visit_id, charged_amount) FROM stdin;
    public          postgres    false    409   ��      �          0    36620    purchases_2205 
   TABLE DATA           E   COPY public.purchases_2205 (user_id, time_stamp, amount) FROM stdin;
    public          postgres    false    514   ��      -          0    36184    purchases_2228 
   TABLE DATA           M   COPY public.purchases_2228 (purchase_id, user_id, purchase_date) FROM stdin;
    public          postgres    false    428    �      �          0    36623    purchases_2230 
   TABLE DATA           E   COPY public.purchases_2230 (user_id, time_stamp, amount) FROM stdin;
    public          postgres    false    515   n�      9          0    36249    purchases_2362 
   TABLE DATA           J   COPY public.purchases_2362 (invoice_id, product_id, quantity) FROM stdin;
    public          postgres    false    440   ��      �          0    26151    queries_1211 
   TABLE DATA           N   COPY public.queries_1211 (query_name, result, "position", rating) FROM stdin;
    public          postgres    false    304   �      �          0    27431    queries_1421 
   TABLE DATA           0   COPY public.queries_1421 (id, year) FROM stdin;
    public          postgres    false    337   �      �          0    25184 
   queue_1204 
   TABLE DATA           J   COPY public.queue_1204 (person_id, person_name, weight, turn) FROM stdin;
    public          postgres    false    299   ��      g          0    36490    register_1633 
   TABLE DATA           <   COPY public.register_1633 (contest_id, user_id) FROM stdin;
    public          postgres    false    486   D�                0    36020    relations_1951 
   TABLE DATA           >   COPY public.relations_1951 (user_id, follower_id) FROM stdin;
    public          postgres    false    394   ��      �          0    25079    removals_1132 
   TABLE DATA           =   COPY public.removals_1132 (post_id, remove_date) FROM stdin;
    public          postgres    false    278   ��      [          0    16610    request_accepted_597 
   TABLE DATA           X   COPY public.request_accepted_597 (requester_id, accepter_id, accepted_date) FROM stdin;
    public          postgres    false    218   ��      t          0    24900    request_accepted_602 
   TABLE DATA           X   COPY public.request_accepted_602 (requester_id, accepter_id, accepted_date) FROM stdin;
    public          postgres    false    243   .�      O          0    36363 
   rides_1407 
   TABLE DATA           ;   COPY public.rides_1407 (id, user_id, distance) FROM stdin;
    public          postgres    false    462   i�      �          0    27532 
   rides_1635 
   TABLE DATA           D   COPY public.rides_1635 (ride_id, user_id, requested_at) FROM stdin;
    public          postgres    false    354   ��      �          0    27562 
   rides_1645 
   TABLE DATA           D   COPY public.rides_1645 (ride_id, user_id, requested_at) FROM stdin;
    public          postgres    false    361   C�      �          0    27587 
   rides_1651 
   TABLE DATA           D   COPY public.rides_1651 (ride_id, user_id, requested_at) FROM stdin;
    public          postgres    false    369   ��      .          0    36187 
   rides_2238 
   TABLE DATA           F   COPY public.rides_2238 (ride_id, driver_id, passenger_id) FROM stdin;
    public          postgres    false    429   Y�                0    36092    rounds_2041 
   TABLE DATA           D   COPY public.rounds_2041 (interview_id, round_id, score) FROM stdin;
    public          postgres    false    406   ��      �          0    27449    salaries_1468 
   TABLE DATA           W   COPY public.salaries_1468 (company_id, employee_id, employee_name, salary) FROM stdin;
    public          postgres    false    339   ��      }          0    36595    salaries_1965 
   TABLE DATA           <   COPY public.salaries_1965 (employee_id, salary) FROM stdin;
    public          postgres    false    508   z�      y          0    24915 
   salary_615 
   TABLE DATA           G   COPY public.salary_615 (id, employee_id, amount, pay_date) FROM stdin;
    public          postgres    false    248   ��      �          0    24957 
   salary_627 
   TABLE DATA           ;   COPY public.salary_627 (id, name, sex, salary) FROM stdin;
    public          postgres    false    255   �      �          0    24972 
   sales_1068 
   TABLE DATA           P   COPY public.sales_1068 (sale_id, product_id, year, quantity, price) FROM stdin;
    public          postgres    false    259   @�      �          0    25006 
   sales_1082 
   TABLE DATA           a   COPY public.sales_1082 (seller_id, product_id, buyer_id, sale_date, quantity, price) FROM stdin;
    public          postgres    false    266   ��      �          0    27334 
   sales_1384 
   TABLE DATA           _   COPY public.sales_1384 (product_id, period_start, period_end, average_daily_sales) FROM stdin;
    public          postgres    false    322   ��      �          0    27412 
   sales_1445 
   TABLE DATA           @   COPY public.sales_1445 (sale_date, fruit, sold_num) FROM stdin;
    public          postgres    false    333   !�      X          0    36415 
   sales_1543 
   TABLE DATA           F   COPY public.sales_1543 (sale_id, product_name, sale_date) FROM stdin;
    public          postgres    false    471   }�      5          0    36237 
   sales_2324 
   TABLE DATA           L   COPY public.sales_2324 (sale_id, product_id, user_id, quantity) FROM stdin;
    public          postgres    false    436   ��      �          0    36626 
   sales_2329 
   TABLE DATA           L   COPY public.sales_2329 (sale_id, product_id, user_id, quantity) FROM stdin;
    public          postgres    false    516   7�      <          0    36261 
   sales_2372 
   TABLE DATA           A   COPY public.sales_2372 (sale_id, customer_id, price) FROM stdin;
    public          postgres    false    443   u�      :          0    36252    salesperson_2372 
   TABLE DATA           @   COPY public.salesperson_2372 (salesperson_id, name) FROM stdin;
    public          postgres    false    441   ��      ]          0    16618    salesperson_607 
   TABLE DATA           ]   COPY public.salesperson_607 (sales_id, name, salary, commission_rate, hire_date) FROM stdin;
    public          postgres    false    220   ��                0    36026    school_1988 
   TABLE DATA           :   COPY public.school_1988 (school_id, capacity) FROM stdin;
    public          postgres    false    396   Z�      c          0    36466    school_a_1623 
   TABLE DATA           A   COPY public.school_a_1623 (student_id, student_name) FROM stdin;
    public          postgres    false    482   ��      d          0    36472    school_b_1623 
   TABLE DATA           A   COPY public.school_b_1623 (student_id, student_name) FROM stdin;
    public          postgres    false    483   ��      e          0    36478    school_c_1623 
   TABLE DATA           A   COPY public.school_c_1623 (student_id, student_name) FROM stdin;
    public          postgres    false    484   ��      �          0    27260    scores_1308 
   TABLE DATA           M   COPY public.scores_1308 (player_name, gender, day, score_points) FROM stdin;
    public          postgres    false    313   �                0    24945    seat_626 
   TABLE DATA           /   COPY public.seat_626 (id, student) FROM stdin;
    public          postgres    false    254   ��      b          0    36460    seller_1607 
   TABLE DATA           =   COPY public.seller_1607 (seller_id, seller_name) FROM stdin;
    public          postgres    false    481   ��      P          0    36366    sessions_1435 
   TABLE DATA           =   COPY public.sessions_1435 (session_id, duration) FROM stdin;
    public          postgres    false    463   �                0    36008    signups_1934 
   TABLE DATA           ;   COPY public.signups_1934 (user_id, time_stamp) FROM stdin;
    public          postgres    false    391   W�      z          0    36580    signups_1939 
   TABLE DATA           ;   COPY public.signups_1939 (user_id, time_stamp) FROM stdin;
    public          postgres    false    505   ��      �          0    25067    spending_1127 
   TABLE DATA           N   COPY public.spending_1127 (user_id, spend_date, platform, amount) FROM stdin;
    public          postgres    false    276   	�      s          0    24897    stadium_601 
   TABLE DATA           =   COPY public.stadium_601 (id, visit_date, people) FROM stdin;
    public          postgres    false    242   Z�      �          0    27361    stocks_1393 
   TABLE DATA           R   COPY public.stocks_1393 (stock_name, operation, operation_day, price) FROM stdin;
    public          postgres    false    325   ��      �          0    36614 
   store_2082 
   TABLE DATA           B   COPY public.store_2082 (bill_id, customer_id, amount) FROM stdin;
    public          postgres    false    513   8�                0    36083    streams_2020 
   TABLE DATA           K   COPY public.streams_2020 (session_id, account_id, stream_date) FROM stdin;
    public          postgres    false    404   x�      p          0    24882    student_580 
   TABLE DATA           P   COPY public.student_580 (student_id, student_name, gender, dept_id) FROM stdin;
    public          postgres    false    239   ��      {          0    24921    student_618 
   TABLE DATA           6   COPY public.student_618 (name, continent) FROM stdin;
    public          postgres    false    250   �      C          0    36285    students_1280 
   TABLE DATA           A   COPY public.students_1280 (student_id, student_name) FROM stdin;
    public          postgres    false    450   N�      J          0    36336    students_1350 
   TABLE DATA           @   COPY public.students_1350 (id, name, department_id) FROM stdin;
    public          postgres    false    457   ��      �          0    27391    students_1412 
   TABLE DATA           A   COPY public.students_1412 (student_id, student_name) FROM stdin;
    public          postgres    false    330   �      7          0    36243    students_2346 
   TABLE DATA           H   COPY public.students_2346 (student_id, department_id, mark) FROM stdin;
    public          postgres    false    438   N�      D          0    36291    subjects_1280 
   TABLE DATA           5   COPY public.subjects_1280 (subject_name) FROM stdin;
    public          postgres    false    451   ��      @          0    36276    submissions_1241 
   TABLE DATA           =   COPY public.submissions_1241 (sub_id, parent_id) FROM stdin;
    public          postgres    false    447   ��                0    36080    subscriptions_2020 
   TABLE DATA           N   COPY public.subscriptions_2020 (account_id, start_date, end_date) FROM stdin;
    public          postgres    false    403   ��      �          0    25202    succeeded_1225 
   TABLE DATA           6   COPY public.succeeded_1225 (success_date) FROM stdin;
    public          postgres    false    303   c�      n          0    24873    surveylog_578 
   TABLE DATA           `   COPY public.surveylog_578 (uid, action, question_id, answer_id, q_num, "timestamp") FROM stdin;
    public          postgres    false    237   ��      �          0    27593 
   tasks_1767 
   TABLE DATA           =   COPY public.tasks_1767 (task_id, subtasks_count) FROM stdin;
    public          postgres    false    371   ��      2          0    36225 
   tasks_2298 
   TABLE DATA           G   COPY public.tasks_2298 (task_id, assignee_id, submit_date) FROM stdin;
    public          postgres    false    433    �      �          0    36638    teacher_2356 
   TABLE DATA           G   COPY public.teacher_2356 (teacher_id, subject_id, dept_id) FROM stdin;
    public          postgres    false    519   f�      )          0    36160    team_points_2175 
   TABLE DATA           A   COPY public.team_points_2175 (team_id, name, points) FROM stdin;
    public          postgres    false    424   ��      �          0    26157 
   teams_1212 
   TABLE DATA           8   COPY public.teams_1212 (team_id, team_name) FROM stdin;
    public          postgres    false    305   ��      �          0    34259 
   teams_1841 
   TABLE DATA           8   COPY public.teams_1841 (team_id, team_name) FROM stdin;
    public          postgres    false    380   S�      �          0    36632 
   teams_2339 
   TABLE DATA           /   COPY public.teams_2339 (team_name) FROM stdin;
    public          postgres    false    518   ��                0    36113 
   terms_2118 
   TABLE DATA           3   COPY public.terms_2118 (power, factor) FROM stdin;
    public          postgres    false    411   ��                0    36116    terms_2118_tc_2 
   TABLE DATA           8   COPY public.terms_2118_tc_2 (power, factor) FROM stdin;
    public          postgres    false    412   ��                0    36119    terms_2118_tc_3 
   TABLE DATA           8   COPY public.terms_2118_tc_3 (power, factor) FROM stdin;
    public          postgres    false    413   �      �          0    25042    traffic_1107 
   TABLE DATA           H   COPY public.traffic_1107 (user_id, activity, activity_date) FROM stdin;
    public          postgres    false    272   M�      �          0    25172    transactions_1193 
   TABLE DATA           S   COPY public.transactions_1193 (id, country, state, amount, trans_date) FROM stdin;
    public          postgres    false    296   ��      �          0    25190    transactions_1205 
   TABLE DATA           S   COPY public.transactions_1205 (id, country, state, amount, trans_date) FROM stdin;
    public          postgres    false    300   .�      �          0    26169    transactions_1336 
   TABLE DATA           N   COPY public.transactions_1336 (user_id, transaction_date, amount) FROM stdin;
    public          postgres    false    308   ��      �          0    27526    transactions_1555 
   TABLE DATA           ^   COPY public.transactions_1555 (trans_id, paid_by, paid_to, amount, transacted_on) FROM stdin;
    public          postgres    false    352   ��      ]          0    36439    transactions_1581 
   TABLE DATA           M   COPY public.transactions_1581 (transaction_id, visit_id, amount) FROM stdin;
    public          postgres    false    476   ,�      _          0    36448    transactions_1587 
   TABLE DATA           U   COPY public.transactions_1587 (trans_id, account, amount, transacted_on) FROM stdin;
    public          postgres    false    478   l�      �          0    27627    transactions_1831 
   TABLE DATA           I   COPY public.transactions_1831 (transactions_id, day, amount) FROM stdin;
    public          postgres    false    377   ��                 0    34271    transactions_1843 
   TABLE DATA           Z   COPY public.transactions_1843 (transaction_id, account_id, type, amount, day) FROM stdin;
    public          postgres    false    383   0�                0    36107    transactions_2066 
   TABLE DATA           J   COPY public.transactions_2066 (account_id, day, type, amount) FROM stdin;
    public          postgres    false    410   ��      `          0    16630    tree_608 
   TABLE DATA           ,   COPY public.tree_608 (id, p_id) FROM stdin;
    public          postgres    false    223   P�      u          0    24903    triangle_610 
   TABLE DATA           /   COPY public.triangle_610 (x, y, z) FROM stdin;
    public          postgres    false    244   �      e          0    16660 	   trips_262 
   TABLE DATA           Z   COPY public.trips_262 (id, client_id, driver_id, city_id, status, request_at) FROM stdin;
    public          postgres    false    228   ��      R          0    36375    tv_program_1495 
   TABLE DATA           L   COPY public.tv_program_1495 (program_date, content_id, channel) FROM stdin;
    public          postgres    false    465   B�      l          0    36517    tweets_1683 
   TABLE DATA           8   COPY public.tweets_1683 (tweet_id, content) FROM stdin;
    public          postgres    false    491   ��      B          0    36282    unit_sold_1251 
   TABLE DATA           J   COPY public.unit_sold_1251 (product_id, purchase_date, units) FROM stdin;
    public          postgres    false    449   ��      �          0    27322    user_activity_1369 
   TABLE DATA           V   COPY public.user_activity_1369 (username, activity, start_date, end_date) FROM stdin;
    public          postgres    false    320   ;�      �          0    27572    user_visits_1709 
   TABLE DATA           ?   COPY public.user_visits_1709 (user_id, visit_date) FROM stdin;
    public          postgres    false    364   ��      �          0    25103 
   users_1158 
   TABLE DATA           H   COPY public.users_1158 (user_id, join_date, favorite_brand) FROM stdin;
    public          postgres    false    283   ��      �          0    25119 
   users_1159 
   TABLE DATA           H   COPY public.users_1159 (user_id, join_date, favorite_brand) FROM stdin;
    public          postgres    false    286   0�      �          0    27289 
   users_1341 
   TABLE DATA           3   COPY public.users_1341 (user_id, name) FROM stdin;
    public          postgres    false    316   ��      N          0    36357 
   users_1407 
   TABLE DATA           .   COPY public.users_1407 (id, name) FROM stdin;
    public          postgres    false    461   ��      �          0    36662 
   users_1517 
   TABLE DATA           9   COPY public.users_1517 (user_id, name, mail) FROM stdin;
    public          postgres    false    523   �      �          0    27520 
   users_1555 
   TABLE DATA           @   COPY public.users_1555 (user_id, user_name, credit) FROM stdin;
    public          postgres    false    351   ��      ^          0    36442 
   users_1587 
   TABLE DATA           3   COPY public.users_1587 (account, name) FROM stdin;
    public          postgres    false    477   �      f          0    36484 
   users_1633 
   TABLE DATA           8   COPY public.users_1633 (user_id, user_name) FROM stdin;
    public          postgres    false    485   C�      i          0    36499 
   users_1667 
   TABLE DATA           3   COPY public.users_1667 (user_id, name) FROM stdin;
    public          postgres    false    488   s�      �          0    27617 
   users_1811 
   TABLE DATA           9   COPY public.users_1811 (user_id, mail, name) FROM stdin;
    public          postgres    false    376   ��      f          0    16666 	   users_262 
   TABLE DATA           :   COPY public.users_262 (user_id, banned, role) FROM stdin;
    public          postgres    false    229   �      �          0    27367    variables_1440 
   TABLE DATA           5   COPY public.variables_1440 (name, value) FROM stdin;
    public          postgres    false    326   O�      �          0    25097 
   views_1148 
   TABLE DATA           Q   COPY public.views_1148 (article_id, author_id, viewer_id, view_date) FROM stdin;
    public          postgres    false    281   v�      �          0    25100 
   views_1149 
   TABLE DATA           Q   COPY public.views_1149 (article_id, author_id, viewer_id, view_date) FROM stdin;
    public          postgres    false    282   ��      �          0    26166    visits_1336 
   TABLE DATA           :   COPY public.visits_1336 (user_id, visit_date) FROM stdin;
    public          postgres    false    307           \          0    36436    visits_1581 
   TABLE DATA           <   COPY public.visits_1581 (visit_id, customer_id) FROM stdin;
    public          postgres    false    475   o                 0    36101    visits_2051 
   TABLE DATA           F   COPY public.visits_2051 (visit_id, member_id, visit_date) FROM stdin;
    public          postgres    false    408   �       m          0    24870    vote_574 
   TABLE DATA           4   COPY public.vote_574 (id, candidate_id) FROM stdin;
    public          postgres    false    236         Z          0    36424    warehouse_1571 
   TABLE DATA           A   COPY public.warehouse_1571 (name, product_id, units) FROM stdin;
    public          postgres    false    473   1      G          0    36309    weather_1294 
   TABLE DATA           F   COPY public.weather_1294 (country_id, weather_state, day) FROM stdin;
    public          postgres    false    454   t      P          0    16496    weather_197 
   TABLE DATA           C   COPY public.weather_197 (id, record_date, temperature) FROM stdin;
    public          postgres    false    207   �      4          0    36234    weather_2314 
   TABLE DATA           <   COPY public.weather_2314 (city_id, day, degree) FROM stdin;
    public          postgres    false    435   -      X          0    16598 	   world_595 
   TABLE DATA           K   COPY public.world_595 (name, continent, area, population, gdp) FROM stdin;
    public          postgres    false    215   ~      �           2606    16544    bonus_577 bonus_577_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.bonus_577
    ADD CONSTRAINT bonus_577_pkey PRIMARY KEY ("empId");
 B   ALTER TABLE ONLY public.bonus_577 DROP CONSTRAINT bonus_577_pkey;
       public            postgres    false    210            �           2606    16617    cinema_603 cinema_603_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.cinema_603
    ADD CONSTRAINT cinema_603_pkey PRIMARY KEY (seat_id);
 D   ALTER TABLE ONLY public.cinema_603 DROP CONSTRAINT cinema_603_pkey;
       public            postgres    false    219            �           2606    16592    customer_584 customer_584_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.customer_584
    ADD CONSTRAINT customer_584_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.customer_584 DROP CONSTRAINT customer_584_pkey;
       public            postgres    false    213            �           2606    16457     customers_183 customers_183_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.customers_183
    ADD CONSTRAINT customers_183_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.customers_183 DROP CONSTRAINT customers_183_pkey;
       public            postgres    false    204            �           2606    16432    employee_181 employee_181_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.employee_181
    ADD CONSTRAINT employee_181_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.employee_181 DROP CONSTRAINT employee_181_pkey;
       public            postgres    false    202            �           2606    16513    employee_570 employee_570_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.employee_570
    ADD CONSTRAINT employee_570_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.employee_570 DROP CONSTRAINT employee_570_pkey;
       public            postgres    false    208            �           2606    16534    employee_577 employee_577_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.employee_577
    ADD CONSTRAINT employee_577_pkey PRIMARY KEY ("empId");
 H   ALTER TABLE ONLY public.employee_577 DROP CONSTRAINT employee_577_pkey;
       public            postgres    false    209            �           2606    16477    orders_183 orders_183_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.orders_183
    ADD CONSTRAINT orders_183_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.orders_183 DROP CONSTRAINT orders_183_pkey;
       public            postgres    false    205            �           2606    16597    orders_586 orders_586_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.orders_586
    ADD CONSTRAINT orders_586_pkey PRIMARY KEY (order_number);
 D   ALTER TABLE ONLY public.orders_586 DROP CONSTRAINT orders_586_pkey;
       public            postgres    false    214            �           2606    16445    person_182 person_182_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.person_182
    ADD CONSTRAINT person_182_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.person_182 DROP CONSTRAINT person_182_pkey;
       public            postgres    false    203            �           2606    16490    person_196 person_196_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.person_196
    ADD CONSTRAINT person_196_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.person_196 DROP CONSTRAINT person_196_pkey;
       public            postgres    false    206            �           2606    16500    weather_197 weather_197_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.weather_197
    ADD CONSTRAINT weather_197_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.weather_197 DROP CONSTRAINT weather_197_pkey;
       public            postgres    false    207            �           2606    16478    orders_183 fk_cutomer_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders_183
    ADD CONSTRAINT fk_cutomer_id FOREIGN KEY (customer_id) REFERENCES public.customers_183(id);
 B   ALTER TABLE ONLY public.orders_183 DROP CONSTRAINT fk_cutomer_id;
       public          postgres    false    205    4277    204            �           2606    16545    bonus_577 fk_emp_id    FK CONSTRAINT     ~   ALTER TABLE ONLY public.bonus_577
    ADD CONSTRAINT fk_emp_id FOREIGN KEY ("empId") REFERENCES public.employee_577("empId");
 =   ALTER TABLE ONLY public.bonus_577 DROP CONSTRAINT fk_emp_id;
       public          postgres    false    210    209    4287            �           2606    16433    employee_181 fk_manager_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_181
    ADD CONSTRAINT fk_manager_id FOREIGN KEY (manager_id) REFERENCES public.employee_181(id);
 D   ALTER TABLE ONLY public.employee_181 DROP CONSTRAINT fk_manager_id;
       public          postgres    false    202    202    4273            �           2606    16514    employee_570 fk_manager_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_570
    ADD CONSTRAINT fk_manager_id FOREIGN KEY (manager_id) REFERENCES public.employee_570(id);
 D   ALTER TABLE ONLY public.employee_570 DROP CONSTRAINT fk_manager_id;
       public          postgres    false    4285    208    208            �           2606    16535    employee_577 fk_supervisor    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee_577
    ADD CONSTRAINT fk_supervisor FOREIGN KEY (supervisor) REFERENCES public.employee_577("empId");
 D   ALTER TABLE ONLY public.employee_577 DROP CONSTRAINT fk_supervisor;
       public          postgres    false    209    4287    209            �   X   x����0��0U4!�t�9�D�'sրf"�ʳ�Ğ\ha�� m�f8����q�Sb�0�B�K�ޫhtPq����a���=$�Rf      �   X   x����0��0U4!�t�9�D�'sրf"�ʳ�Ğ\ha�� m�f8����q�Sb�0�B�K�ޫhtPq����a���=$�Rf      �   X   x����0��0U4!�t�9�D�'sրf"�ʳ�Ğ\ha�� m�f8����q�Sb�0�B�K�ޫhtPq����a���=$�Rf      �   "   x�3���+.���2����K,�H������ lQ\      �      x�3�42400�2�440�1z\\\ $W         ,   x��� 0�7S�Bإ��Q���n���+.V
s�����|6*      �   p   x�u�M
� ����]
��Kt7BRQh����,��;<�pFmŚ����;���h39�ߝ��]�+I�v]�a53��e!A�E��B��H�#��]���U6�F�ZYK�      �   r   x�u�M
� ����]
��Kt�6BRQh���5��;<�pFmŚ�֜�wH�<����{:�+Yvf[�~�
�%��TH�ă�r*T�^��W8=XU6���5"^U�K�      �   )   x�3�tM,��K�2�R �1�G~Qq�BPf
����� �      Q   U   x�3202�50�56��HML)���K�2��r��%g� D�8}���|�6' ?�$)1'Y�SfRN*>m!���E%\1z\\\ ���      �   ?   x�M̱�@B�vqv�Y&�����ڧF"�U�X�	�f�6<��\0>'�����H~���      �   l   x�u�A
� @��x���.ADI��,�~����?l��5��{�9��x��tc<>���V��(��n���|n���$���ef�ҁ}��T�efi�J���Q%      �   z   x�}��
!����]gԢw	dY%�h.z�Z�r\����p��Y��&��J��|�E�4^�5��kG����M��x��?�\�h}��$����`2��$��߿��E�FGM^F�g��R�qch      h   [   x�M�1�0��C�B�������������σ��iGm���"w_�	B��%��C�ݓs�լ$G3E]��&5^�D�vJ���"�B�$      �   B   x�E���@B�3�C�Z���a���7�t,��@3>h9�������`!�I��[����9H��M�      U   B   x�E���@B�3��Z���a���7�Dʋ*���M%�@m���l8
�'	�nj���爈��      g   @   x�M̱�0���E)�J���sD��o$R�P��E��h&j���������MT��.�?���      h   E   x�M̱�0�vQ���0��ȕ]�<F"���1���Z��f�Y�Pý�������;~����      �   )   x�3�4�4�2��`�Hq�I.#��)�4����� �R�      �      x������ � �      I   N   x�3�4�t��L�NM�2�4���9�9�2SˁLSNSN����" ې��6��J��J`:9M`�F���0�!��1z\\\ �t�      u      x�3�4�4�2�4�44�2RF\1z\\\ )�'      �   &   x��7�t4�4��7�t4�4��7�t4�44����� M�      S      x�3�450�2�42 R1z\\\ ��      �      x�=�A
�@EדS��$��.AAW"�q�b��v
�q��� �>�I8�8����ăOт�0�����s�%��5�Bn��i�!��H�A*���9&��������/_�h��"7�-��c _�f"�      �   ?   x����0�޾aP���,��R^�%;�ea�,� ~-&I��ˇ|��)eK5��m�h_�>�J
@      $      x�3�4�2�4�2�4����� �      "       x�3�4�4�2�4�44�2�4�4����� %��      �      x�3ⴰ�2洰������        �   =   x�%˱�0B�����t�x�9L������
/��*h���6;+9� ��h���|N	�      �   3   x�3�4�4��2�4�44�2�4�42�2�4�44��FH�	P��Ғ+F��� ��         X   x�U���0ki
/�@��H�,��)� W݁,	qst��ѐ���R?p&1t
4��b����g��S��X�4[��y�禪�`      l   !   x�3�t�2�t�2�t�2�t�2�t����� ,�V         2   x�3��*���/�44 .KT�gp*�k���Q�&0�&`n� �DZ         5   x�3��*���/�44 .KT�gp*�k���a|S0���̍���� ��K         ;   x�3��*���/�44 .K8��5�Ns�����0���o㛂�M`�M��=... ��U         =   x�3��*���/�42500಄q@\#��T0�,kh烥�a|K0���̍���� �{e         C   x�34�t,)�L.-�4�440��*MJ��4�L��8s2��l �� rӊRS�9A|s�=... "�      �   %   x�320��4�@.#CK0ӈ��12 2 �=... �&�      �   .   x�340�420��50�5��240�r�t��\S(�R�Ђ+F��� ތz      �   /   x�3�4�4�24�42�44�2���2�4��4�24ц�\1z\\\ z��      \      x�3�4�2�4�2�&@l
�1z\\\ 't�      ~   p   x����0���DjK+�#DgcL�H��{�x��7v�i:�Wq�"��IX-��4�����Vv,y�6��j�3�`��r���i���������?k螉���!w      =   A   x����M�JN�Q�M,JO,�,I�2���2Ɯ���E�ɉy�\��.�����E�\F �=... A�0      ^   E   x�3�ru�t�/.���2��r�sw��K-W��/��2�t�����0�tru��t,-.������� o?      	   z   x�m�K
�0е}
]�E���tצ�E(���`-��!ͨC�db5e��m�2����%H$���3����D,Cs����_�t?���R5��޿��f('���^�m�uT�~��Xw�x�?�F4�      {   r   x�m��	�0��sREPfɂS�7����c�}�V��y,b�Z��M���A�Kn��A�*�Lc?̱ks��2�t�� �ٿ���w)¡h�,[gn紮K��'�;c      �   Y   x�3�t�O�L�Or�IM-I�OI�K���2��������9�Y�(�F����E��@�M�75��3H�J�q:�d&�r&�HT�=... ާ1�      S   f   x�3��IM-I�OIU��/�L-���0��8s�����3S�9#9�S�@Ɯ.�%�I�ũ
��9 P	��Ĕ��<�Z�!��Ιy)�E�99��=... \y%�      �   ;   x�-��� D��w1Q�Ƒ���`"�=͢�"�M�m�PV�=�`�][���~���
&      F   @   x�3�v�2�t,-.)J��L�2�H-*�2�t���K����/�ON���.H������� ��8      �   E   x�H-*�405��,.JL��47���/�ON��424�rO-�M̫�40��r-���/�L�4������ 1��      Y   A   x�s��M,��r�t�K��,��r��p:e���Wr�B�8��sJKR���!"�B��qqq ���      �      x�3�4�2�4�2��@��c���� (�      �   �   x�]�1�0�������%i���.g�@�V���,��M���`^����X�A�I��s�������TC��y�),�D3�Ƽ=���Ό8�W���4ᐳo:A&��Ď-,�+%���a��F�v�U����D��[4K      ;      x�3�4�2bcN#�=... /      V   =   x�3�������2��J�K��9sR+8��L8�����Q��ٜ�\f���E�@�=... ݊P      �   H   x�3�t��LN�L�9��%��)�z���\F�N�I�I�I�Ɯ^�y�Y@U�hVjШ�
T�=... Q�"r      �   1   x�3�tI��L��2�t�L�K�2�t�ɬJLJ-��2���������� �      T   <   x�3���+.���v�2����K,�H��H-*�2���/-.ILK�tM�,(����� ���      �   ?   x�3���+.���2����K,�H��2�t��KLJ��I�2��M,*
�rzg$椦p��qqq ��]      �   ?   x�3���+.���2����K,�H��2�t��KLJ��I�2��M,*
�rzg$椦p��qqq ��]      �   0   x�3�t��LN�2�t�O�2����2��J-*��2���������� �p	�      `   )   x�340�t��LN�240�t�O�Ɯ��E9��\1z\\\ ��D      �   %   x�3�t��LN�2�t�O�2�t�H,��L����� p%      v   8   x�-��  ���.���ð���;2��BA.k�h���J薡>�w驝8���'      M   '   x�3���O�2��H�+��2�N��2��M������� z�*      m   K   x�3202�54�5��,ɯ�/I�4�4�2�5�4�*j�5G��]�܌��4`�F�*͡����Gh����� q�0W      &      x�3�4�2�4�2�4�2�4����� ��      w   +   x�3202�50�54�2202�5��5�1t�t�̸b���� ��      �   B   x�m��� k{�? �%�ϑ\���uN$�[���0L})kґuT����m$N����>$?�\:      �   G   x�M���0�jq�$�y�K��#]�<Ȋ
g���H��0"��S@kF�����vl]��Z�=�������      �   2   x�3�000��J��2ⴄ1�9@l��$.CNs���M,����� l��      b      x�3���2�N�I-����� %��      d      x�3���2�N�I-����� %��      q   +   x�3�t�K��KM-��K�2�N�L�KN�2��I,����� �	�      K   K   x�3�t�IM.)�LN�Qp�K��KM-��K�2�t��-(-I-B64�t*-r��Sr3�2�K�K2��b���� h=      �   D   x�-��� �w܋#�������(�����C-��e�!��B�z!�	����g��{� "f       �   D   x�-��� �w܋#�������(�����C-��e�!��B�z!�	����g��{� "f       �   D   x�-��� �w܋#�������(�����C-��e�!��B�z!�	����g��{� "f       �   !   x���H�IM�r��������r�O����� f.�      �   0   x�3���H�IM�4�2�t���4�2������4�2�t�O
��qqq ��      �   .   x�3���H�IM�4�2�t���4�2�t�O�Ɯ^�y@�=... ��      H       x�3��2bc 6�4�2��2�=... 7e�      L   9   x�3�t��LN�2�t�O�24��M�,�4���+.���2����K,�H������ Ev      s   *   x�3�4���2��@��6�4�&`�	�	$M��=... �i      K   9   x�3�N��43 �?.N��
NKא�+?���5�2��H�+���6����� ��	      a   >   x�3���O�47 NC.#N��\NK(Ϙ�#5�����7�2�N��4��L9}+�jc���� W��      c   Z   x�3���O�0500�4�2��H�+��0 񍸌9�s9͠<N��
NK�ZSN�ļ�N3Kߌ3(1/�n�9gxfN�9Ty� �;      i   [   x�=̱�@D������Pm���.0�o����AX��U
���"�*:����8��!�-3�V��Q�heK�rI�R
���K      Q   G   x�340������t���240�tIq�<cN����b8߄�1��3�t��K�s�8���8���=... �ew      R   <   x�3�t*JL���4100�2������4�4�8]A#Ǆ3$#?7��+����� ���      o   3   x�3�4�42�2�P@���S�@�$h�����g��B��\1z\\\ +��      z      x�3�4�2�4�2�=... :      M      x�3�4�24�4�4�4����� �v      �   V   x�˱
� E��އ	�@��hjnѐD!���׏s��;|�g���"#�Ps*дؾ�1�a�[�h��W*��bo1=�<�@�M��      o   ?   x����H-J����41�2�t��LN��41�2�t�O2�͸�8�3�K��@�͹b���� �EU      p   ?   x�Mʱ�0���E�H�p�K��#��x��)|�Q���u*sdAh��*T�����E�K      x   K   x�3��M�,�4600�2���L�HL��4� r�9SR2s*�8�M�\N���<N3C ے�;1//(c���qqq ��(         E   x�3��M�,�4600�2���L�HĹp�9SR2s*�8�M�\N���<N3C ے�;1//*���� �T      |   '   x�3�t.J-�2��H,K��2��.�,.�L������ ��E      ~   k   x�%�1�0��D�>c�2EPx�K�8 Ei��8J;��s�	AM)t�o�}+��y�QU��ǻ|�	�F/Ęk� ��<%��+��i�^��s�\����&"EE      >      x�3�44�2�44�2�4����� �n      �   3   x�ȱ  ��G�.�?�:����llL�a�:�p�$Z�����      �   <   x�3�,J-�L-/�4�2����9S�9����$�6J$��*��!s��b���� �`!         +   x��47�44�43�43�01�47�27��P&@9�=... �{g      E   =   x�3��M,��2�Ȩ,�L.���Ӌss3�ҹ�PxȪ ڌ�4�:c�B#��`*F��� R"      �   ;   x�-�� !��I1h.q����ayY���F7�ebC�x��꿗~����/��Fr���      �      x�3�4�2�4bm�&\1z\\\ '�         I   x�3����(�O/J����K�24��s�p:��g�p�&��Xp��&�y�F�\�,��1z\\\ p*      �   &   x��������@�(R$m�$H��+F��� ��d      �   (   x�320��54�5��2�1-ALK]C]Ӕ+F��� ߀�             x�3�4�4�2�4�4�&@2F��� "�      !   (   x�3�4�4�2�4�4�2�4�&�@�˔ӌӜ+F��� L�=      x      x�s�t�r�tb.NW�=... #�      n      x�3�4�2�4�2cC�=... |      Z   ,   x�3�4�4204�5 "C.CNcT�	2�Yֈ�Y֒+F��� ��      �   g   x�3����K,�H�Sp��tM,��K�2��JLIU��rA"Ɯa��%�E
^1Nל��b�@�>SN�ļ��G���S~����G~Qq�BPf
H4F��� �w#�      �   "   x�3�4�2�4b.# m�M��8�b���� C��      �   "   x�3�4�2�4b.# m�M��8�b���� C��            x�3�4����� d            x�3�4�2�4bS�=... k      
   /   x�ȹ	 0�������f�V �H9JI������"���V�H���[      3   2   x�3��M�I�2�LK3�8�K2R��L!��0q�*m�-a�1z\\\ a��      �   (   x�3�4�2�4bc 6�2�4bs 6bc ������� gi�      r   0   x�3�44�30�4&��2�4�0H.c�:c��	:����� �C       k   6   x�=��	  �sR��/vc�u%�C� ���@hW�	�|���n�� �x�	C      �   6   x���  �w2*�t����g�s���s-�GƅSB|d"_F@q7���      �   *   x�3�N�-.�K�2��I��/��2��q�2�������� ��;      �   *   x�3�N�-.�K�2��I��/��2��q�2�������� ��;      �   _   x�3��qVp�I�Sp����\F 1'd!c�PpnbQI@F~^*'��2���
FFPQS�Z����bN0�Z�e���,*Q���2�b���� 7�&�      +   /   x�3��H�KIJ���2�L��/3�9����8���3�R�b���� �      �   3   x�ʹ 0��Z&�-�d�9�4l��:\<�bi�{aS�������      �   3   x�ʹ 0��Z&�-�d�9�4l��:\<�bi�{aS�������         C   x�]��� �w�UlC�a�9h�ϓ�
1J+��ݴO��/��/�����Y����o�ٽ��<y'�         C   x�]��� �w�UlC�a�9h�ϓ�
1J+��ݴO��/��/�����Y����o�ٽ��<y'�      �   l   x����� ��s;�`���0���a$X�`���RQ� X�T;���&]?��V)=�J�i{o6����F*�4�!ս�1��.��7�{��-���se��I?�      �   5   x�3�4202�50�56�2D�#8�p���
�'�n�c�$ch����� �TR      y   x   x�5���0�w5�PAʖlk��?G�4�:��p��Q�<JC7��ߚ�r�a(P�Ő�,���(���J?��۳�O��Tx���ٝ��0���a�m������J�v,��"�ړ$�      �      x�3�2�2�2��24������ �K      �   !   x�3�4�2bc 6�4�2�f@��c���� C��      ?   T   x�]���0C�3�"�.�Y�������O�R"���ƣ����-K�6�S硤\y����Fӧ�NMeX\�3f�jf7�      �   5   x���� ��XLf/�I�u��lڜYJ�c���;i⏋/B��8���H� @t      �   4   x�-�� 0��0LE�m��M�J<�`���
gT�\��vj����|�W      �   *   x�ű  ��=g��i�P�И(E�	����.ITOc      '   K   x�3�4202�50�54����2DX�	��	r�%��E���!`��_��,b1����5��qqq $��      (   m   x�e�+�0P�ޥ�;�S<�� H@p}�P�U/�?Q���b�Qòj��	P8Q�>�������0��ߎ�--E ���b�q*�%�O�m���P$mv	�q����Z_Q?�         8   x���t��LN�24�t�O�2���+.�����H-J��2��K,��H������ @n�      �   N   x�U���0�x*lu��?GI�*��l�hi
��M�������*�E�P�}w�i� �Y���ͪ� ���@      �   +   x�3�t,K�KO-*�2�t+ʯJ�S0�2����N-����� ��	t      �      x�3�4�2�0����� �
      �   @   x�%���0�f�
p�ֻt�9J���8T���;hV�m�V��p�I-읱�t^3�?)�^ >a5V      |      x����2BC..S.3�=... �      }      x����2�=... ��      j      x�3�4�2�4�2�4�2�1z\\\ ��      k      x�3�4�2�4�2�4�2�1z\\\ ��      �   C   x�s���K�44 !#���Ғ��Ҕ�<N 4�
vDH{%��p�1�kzeA	�m����� �x�      �   Q   x�=���0����v'٥��Q�J��pB���%c9�g!�C�s�Y���v�ݺ�-�`H�T���T0��ݣ� <��q      �   F   x�U���0Bk����9�d�9�Ӝ,x�#̟ak����F�G�B��UBA�z�o��'J�>����E�T"      �   C   x�U���0�3�ȿV�.����q1�����o���F�NQ2�*�j:3U>7%�o��JqM�T�%      �   U   x�U�A� D��p��z�����T��B�(��B+���D�ش����+:ŗl�U��I�@������q���z����s      �   ;   x�ʹ�0��xTo}`C�q�_;��*z�f�̦��3T��PK�Y\fs�z.��C	J      �   V   x�M�K� �5s�ڻ���(���3/|(SӦ�)3Paզ�2�����<C ���Q)$��Y�k2�2������?      V   U   x�U�K� ����]j� Իx�s8,�� i��/�@8��͇i�,?;͵���b���]����΁�K�<e�،������$_I�g      �   _   x�Mͱ�0C�Z�%�dBva�9p���?���FK�H1��.�I���?t4��,��cg�k�
�?%l�\T�99�T����轢൑�S.      �   Y   x�M���0kqz�e��?GñU<)��0����C`\`hܒ�(� (����q#�v�i�?H�q@��} e~�����T����e      Y   d   x�E���0Cѳ��R��z��?Gi4M�z>�H&�P�b�HG�"�Od<c8nIn��qޒrG��$GT��ȴtcm���)��'O���y�ȺA      �   Y   x�M���0������:�x�ᥝ�0ru�F8�J�IA�� ��ASl8�SQD�ލ� Ve&�S��K�/f~ ��g      a   J   x�-���@�7��C�����9�[���Px��a�/W���6d;��3{b;��t�W��r��م���7t      N      x�3�4�2�4����� ��         0   x�Ǳ 0����8��`7zA(z+���h��b7�^�!���Y      1   J   x�M̱�0C��B�6Y&��|�p��K4�k
��p&T0(a\�rfAn�.4�
VC"�*ꆨ}�|��7+      W   O   x�3�4�4204�50�5��3�L#N����N.#N#��)�id���+6�D2��EL�	�b�
d}0�1z\\\ �3#�      _   =   x�E�� 0�3��F�l���(�E��B �Y˩G�@g1�F?�����րF��6���%         E   x����@�3�Y�l���_G�<APP�x$�􎱅�����mA�r����b���"������-+�      %   !   x�34�4�24�4�24�4�24�4����� -9V      #   #   x�34�4�24Ɯ�\�&�f\����\1z\\\ ?�       W   [   x�3�tI��L��tsSp�u��2�t��LN��2�t�O�t�tt240P����2�tO�/JO�tt�sU�Jq�u$f恕*p��qqq >�!      �   l   x�E�1
�0�Y�K���� ]^:w�%�`C�����x��V�\��h-&��}�l�)�ʭ.�E
�M��G��c4���r����M��e-{G "��1���      �      x������ � �      L       x�3�LtH�K���2�LvH���b1z\\\ ���      O   *   x�3�����sH�H�-�I�K���2�L�OB1�T���� ��      T   '   x�3�����sH�H�-�I�K���2�L�OB����� 0�F      �   4   x�3204�444�2Bbf �	�ab�rZ�h3� �a�ih`����� n 
�      �   �  x�m[ˮ�\�~L`Q����	��2�F�"�Ac:��|}LJǪ*]�U�%�H�4%���������tli��~�ж�#�|�l�������!<��_[�����S�R%°A�����ڭ=ą�k�zn�x"�%#<^��[�����׍�WQ_]����7�-�D�2؉⪻>������F�Eq�b��(��a��J�/���zC|��v}q����O�]=4Ȯ~GL��o��°������n@�Y<�C{!��>����b�;�-� ,�;�1����������Z�ꍵ%����_>}��9g�n%Jy	U�Vu�~�:�]��NeB]k��¥��p����R����j@����TSe��L�S���̑��K:�Ĥ�'����hu�M�hU��6yf+J-�Y�1j13�ܢ�6s��Q�\�9C8�W��v-��3��j	[O�uj �x(U����8�4uo^'��)�J��������t\�k��uF�3�?����ik�\��Z������4�u�<��`���|�fF�]dD�����/?^��Dh���a
�r�ƍ��G�K�m ���qB����Q�%Ć7��"�
n^��E���E�F~D�d�x�\E}e���°rcO� ��IR=�Q��I�{�Ny.#�y��F��k���ƗrK���Tf���)��$rk�55`��3��+j]��ܸ����1�ݞ%�{YGRzY������ ��M��"�l4����B��kp�MC&��]����o��?y�n�D������D�A��~d	r����-iڥG$L"De��$�c�̖�bqeC#�p���/��!���-��l��*j<��ē�thr�c�;�2��vL�u��&���v"bA���&��u>ZEB�����m
�ڵE_�#��5���Iև$GvE\�G�x�C:pl�x�I���CbҢ�؁"b�رX@#.<d�W��68�P���b�$���W�"�V��~��������+s�x��LLS��0S�T[����0f.vE�~ϣPiљb�֟�"�1�׎emU�#�1u��+mf���b�+�	g�,2]*╩,�{��L���CK/O{�\ՀPI]7J1��:}� M��c�,����<c�X��k�kS	���	�Y�Ǐ�x
��`�F�ʦ��Cϐ�h��Z��K��T�
�~�p����`J#ٳf��gl	R[���%��W|�\ȯ�O��3�\�/���A��N�o���曨RG�����Yy�I�\|��+ &�۳���.���0�&���.����������
4�`�k9	ؠ�(�&4�ۗ��V	��k��&:A^�`p��.��WQ�k�쁆��ǉʖ Un�~�x��T^`K*`���̬8�-�eB��H68N���,���D߱�_ Nh]9�����2�����b%��
���[]��nԄ�a/|�|~v�+ މ2]��ԃ|�t"�4��w�':	��i�}����Ķ����Pj#�-�&�t�ѵ�����.0ql2Lt���{�������~Pq�����J^���&��Q��܄��t-=�Nh3�-0P�]ՉR�*�A'�r�(Q[�K��q�G:�$�:y��m���9J�.��r�D����@�0�T��p�K�UB�pI5�X�0��H��q���o���Ƚ>Q&T�_?�`��&<hԨU'���)`g��qO\/��A�e���	�����3�����4�������X7�ڳ�D�P��x1L���N��D����Dmcu󂅵��(�0�J�+MT�g�a�8���m/��[�-`?d<��'�8�#3LX�����h���_vv|d21�x�:&ħ��6&*(p|%�sӗ��C#�#? �`�����?�~���S,4a|��'�)?�b��c�e�c�\��E��
��VQ�"��^S��*��pb����J-��f���D)TZU�{��Af�I�})�T�}7��&��b]�B��k���Pw� ���Sq:�Tޔ)ꂲ�^Y³�K3s������Y�S8}���9�!��QQkr?e�-�;6ms.��_�ŧP��$��gl�.��0Y�7v���f}�5Ζ�Ÿ�2�Jk�H�����_��2������w*�5��%M[���S�K�D82�Y��(���1��%�mnQ��6��W�D�J\:F 3Q0e|��d#B'�F�Q�Oeu5jw"%d�jTA�lgG�ڍ�i,=[%21�=U� τҥ)q���TԠH�2H1elu�	��^��Nf���8�#���>HYî'>V��#�v�ƶ��f_(Q��&F�#Ӱ35�� ���F9˔��x������	V�By�*�T|�Ĕ�<����X[��Xת+"Q��_�!׷���/���+UTG��1��;+���F������T�Էu5��f�u6�gSL�u����
u��4�R��ڙ�pٖf%���ڪ�TU%2�P����^�P����T.i�f3�f�m	���p�-Q�ר��z�XU,әר���K�<>�D�֨�l1�Lg߈���3m�A��Q�����p���O����J�~j9q��q`8q�O�ϛ'n|�W7 }���/@�����+�Q�Cė�^g���� ׍��&���
�����h�f��n���m�{V����?����o|�0�A�j������W5��U��QĀ�n�"�$���o���)��{�3�'�/@�Nr#����?z�����`��<�e��h��a��B5;M�kɋ����q�Y��xCOK�#f��B�r��Oy_�� S��Y��_��� �� ����co����ǎ�&��2B�/C����;}��l}p\��c��i�B�Fq�8��x�=x�7����Q����;w j��||���X�بCl��(����F�p�v�ذx������r����_�B=D��[�z=.���D��s�'Cr|�7��D揓����[k ��&o}�p���7~^-6�Q�N�y�L"�M��������0�      t   1   x�3�4BS.#m�id�e�	dpq��X�F\@	 ������� �[�      �   -   x�ƹ 0��&�y�a�9��4�T�)��9��@��>���      �   '   x�3��KLI��2�tKMI-J-�2���/K������ ��      v      x��5��5�2�4�����b���� r�      w      x��5�2�2����� �      �      x�3�4��2�4�4�2��b���� %��      *   "   x�3�4���2�4�2�44�2��52����� 1��      ,   �   x�=�=
�0�g�:A�?�С{�K�QbS�2����WN h�x�{�͛�R�+��3���6�Ԯݎ����'��R,�2�wT��C����˒�Af�d�7W��WS�$��q��y)�z�p3�GG|6'V��Éq�p.�'ٙ�׮��T��ZI�9��VP�      A   @   x�M���0�f�����/���f(�n(*L��Sw�g蛕<ho���jG���JQ�sx7b�         B   x�˱�@�X*ƃ0���_�?��3��lJH�ทBU9��^8��}���F$�R~�g�      �      x�3�2����� �(      �   *   x�340�����L�2�
rR��������Ҽt�=... ��	Z      �   +   x�3���4400�2�t7� 2�932��R9M��=... �\      �   .   x�3��qV���K�21Ct�32�J��A������<�=... �:6      U   C   x�34��qV���K�460�2�Ct�32�J8���N��ٜ&�\&`�wjerFbf�W� A�J      j      x�3��H��2�LJL������� 0i      6      x�3�44�2�42�2�44����� ��      �      x�3�44�2�42�2�44����� ��      �   8   x�3�42 "CK]]C.#NS�!�1��7E�̀�͐��\�(�Yp��qqq R��      �   d   x�3��IM-I�OIU��)-���+�t����2��J-O�)V�OS.)��K���O��Hszp�$��p� ���/ˇ�MFzg�p��gd�p��qqq �#�      �   C   x�3��N�L�O,J�442�2���/-N�0�2�,N.JM��430�2�� *QH�,��415������ �q      [   L   x�3��q�	�4�45�41�2�S+�33�@���\� �����TN#NC �2k�-��,*�4	p��qqq ��      �   C   x�3��N�L�O,J�442�2���/-N�0�2�,N.JM��430�2�� *QH�,��415������ �q      q   #   x�3�����2��\F�~@��6���b���� f�}      r   1   x�3�,.�/J5�4�2���9�# ǀ����6�0������ Nf      /   F   x�3���/�444�2��q�.�/J�440�2��˯J�M�4s��K9-���:�l��W� .<      0   .   x�3�440����44Q\F �T�Ҁ�� ��b@�=... �	�      8      x�3�440�2�4�1z\\\ WU      �      x�3�4�2�4bc.# ۈӄ+F��� 'a�      �      x�3�4�2�4bc.# ۈӄ+F��� 'a�            x�34�4200�2����� :F��� E9h      �   O   x�M���0��]E:�M�]K��!�{�kB�щ�,xaC��w�fY�e\S��ٌ;J���#߿��'��u��Qz      -   >   x�U���0C�s���ءva�9�T���?�ᴙEs�)��\�ԍ��N�]�i3/<��=      �   O   x�M���0��]E:�M�]K��!�{�kB�щ�,xaC��w�fY�e\S��ٌ;J���#߿��'��u��Qz      9   (   x�3�4�4�2�4�4�2��@Ґӄ�Hp��qqq O�S      �   j   x�s�O�t��II�SJ-)�L-K-�4�4�rI��&�)g�d��pA�}KsR9�8���K8�32��29Ma������TNcNc� �2��Ӝӄ+F��� �! �      �   ,   x�3�420��2R\� ʒ�$h� <#.Cc7F��� ��U      �   y   x�e�9
�0E���UhF�S��7n�����c�N{9�����Y,��T��Uh'����X��J�IӌOl%t�y����Z)aHcI9�{���zdK�߫��#
w������p�ϴNDt(�      g   6   x�324�4�22��4� �� ,b7�@6P�9X�����ޜ+F��� �P*         '   x�3�4�2bs 6�4�M�l ��6�M�b���� h��      �      x�3�420��50�52�2�s-�b���� U      [   .   x�3�4�4204�5 "c.CNcׂ��k�i��Z�p�b���� W�      t   +   x�3�4�4204�5 "c.CNcׂ��k�i��Zr��qqq Z�
l      O   ?   x��� !�P�M j�����swA�a����m�	���������^����H���      �   {   x�E���C1�R/�!l໗�_G�o��8�:�e
�E!��p�v�8b�Oja�#�yq`�p�5��lԷЦ��G<�p<g���2�}y10���Pϟ�S��qES�]�ЭD��"��N)�      �   {   x�E���C1�R/�!l໗�_G�o��8�:�e
�E!��p�v�8b�Oja�#�yq`�p�5��lԷЦ��G<�p<g���2�}y10���Pϟ�S��qES�]�ЭD��"��N)�      �   {   x�E���C1�R/�!l໗�_G�o��8�:�e
�E!��p�v�8b�Oja�#�yq`�p�5��lԷЦ��G<�p<g���2�}y10���Pϟ�S��qES�]�ЭD��"��N)�      .   )   x�3�4�4�2�F\Ɯ��@�	�2�2�Pf ʘ+F��� ���         B   x����0�x�*8�Nv��s�:��.6T\D���Mٿٙ��'t���9�:�O}OU���      �   �   x�%���0��� �y�R�R��q"+
RΒ�{l����S���c�A?3��
��b_�����������qn
^p�q߂zt��҇��^�0��+#seܓ�Ž!�7�uS]���m��d���r'�      }   %   x�3�47307�2�42254�2�4365������ G+�      y   B   x�]˱� ������M���� �����n�c:�3LF�D"X��<?�k��ϯ��W����
�N      �   /   x�3�t���4250�2�t�L�41�9���� �	�PĊ���� ���      �   4   x�3�440�420� 28M��`B���F!s�9M9-AB1z\\\ *I	W      �   A   x�-�� 1�w�C��%���B|���qçuF.f�rWlrb/6�A�S��~��<��      �   <   x�U��	  ��v���"�.�?�'������A��C�G	1BΜh�-QD��Z&�
`}�G      �   L   x�3202�50�50�L,(�I-�44�2B�%�E-�Fp��Ȃ0�Ȣ�0�FȂ0�H�&�5Aj����� @�)I      X   f   x�3��q���s�4200�50�54�2	f��"͹����y0�F��\&@A��Jg�L?��%�)T<#13.nd�e��XRT�_���7�56����� �^�      5   4   x�3�4�44 a.#Nc0Ӝ�,h�i�e�if�q��eA<.3��W� 2��      �   .   x�3�4�44 a.#N#�˘��2�4�2����L��@�=... �Rd      <   +   x�3�4ⴰ4�2�4�465�2�4洴��2��f\1z\\\ dj7      :   #   x�3�t��LN�2�t�O�2��J-*������ _�u      ]   g   x�-�1
�P��z�.+;��z[!��XBb����tڏ��齽��C�"���A�� �$����*=n�灒U��D��ܗj��r����\�Ȗc\$�����~-o�         #   x�34�445�2�4����24ഴ����� 8$�      c      x�3�t��LN�2�t�O����� .�#      d      x�3�������� �      e   $   x�3����2��J-*��24�t��LN����� hA�      �   }   x�U�1�@��9�/'I�:���R(��)����9���� )dz�o[�r��lS|�V�ǳ���	z��OM�"���#0�-�G�aO��y�ư��7 8�����U�{����~@�g�+&         8   x�3�tLJ�/�2�t�/�,�2�t�M-*���2�t/JM��2��JM�M-����� K�      b   *   x�3�tI��L��2�t�ɬJLJ-��2�t+J������� ��	O      P   )   x�3�46�2�4���2�4�&��\���\1z\\\ \�         I   x�-̱�0���"��$���!�^qy����]�b���|�Vi5�hY􈔷����a�ߐ�,<7�C�      z   I   x�-̱�0���"��$���!�^qy����]�b���|�Vi5�hY􈔷����a�ߐ�,<7�C�      �   A   x�3�420��50�50���O��I�440�2DOI-�.�/ K�Ѐ$n�,n�� cd�1z\\\ "�"      s   I   x�E˱� C���%�88v��s@*Kn��,��zBwP�����n�P�a`o�;�����CrYt?e(���K� f')      �   u   x��IM-I�OI�t*��4�4400�r�/��KT�M,�.�Ź|`*�Ssr8M9-AJ=�R��!��9�0 +7�`��d,6B�7��3�z��`�F����M14 �7������ TAh      �   0   x�ƹ 0��&w�����T2�����G�|c�wH~�C�         G   x�-���0��~��2���?GR5T[���ќ.���q�s�ip���0�� �� ��S�퇦���tz�      p   )   x�3��JL����4�22�R9݀LcN��"��W� ��      {   6   x��JL��t�M-�LN�
H,NN��t--�/H���t,�L��J�K�+����� ��S      C   )   x�3�t��LN�2�t�O�24������2��Vp��qqq �`�      J   o   x�̱
�@E����6�����+�4��d N ���t���.�4�C��p��ܣ���tA����ё
��osE�̸m��,<����1V�m��"&.�9�<u�y8v$���      �   8   x�3�tI��L��2��JLI�2�.I��I�2����K,�H��2��������� H��      7   -   x�3�4�435ಀ�朆��F\�@��Ѐ�H�p��qqq �1      D   &   x��M,��
Ȩ,�L.�
(�O/J����K����� �|	�      @   .   x�3���2�`�4�4�2�4�&@l	Ć@3Ns�=... ��         T   x�E���@B�e��N�����ƪ	@��\L3�и�B�F�'p�U}�A� ��#Y�%z�?l��*�z�~K[�3T̅�
��o�      �   ,   x�320��54�56�2�1ALK]C B0�Lcӌ+F��� ˈd      n   H   x�3�,��/�4�0���4�442�2�L�+.O-�� X�(Vmlf	Rm3�eg ��q��qqq �8�      �      x�3�4�2�4�2�4����� f      2   6   x�MǱ  ��<A���簄tQ(l��LQ�!���\��a ��������R      �   )   x�3�4�4�2�&@��6�4�4�F`�L� �=... ���      )   J   x�3�t�IO-�L�4416�2�N�KMO��4246�2��K-W�JM�I�K�00�2�t.�O,i�04����� z�L      �   J   x�34��IM-I�OIUps�22��K-��/��8Kr�JA<N�����|�Ԁ3$�(?�̋���� 5�      �   )   x�3�t�J��2�t�/*�-�K�2�t,*N�K������ �	      �   -   x��IM-I�OIUps�r�ȩTv�
JM�Q�ML)�L����� �$
�            x�3�4�2��5�2�4����� 9            x�3��5�2�4�2��5����� Ei            x�3��5�2�4�2��5�2�4����� #��      �   m   x�m�I
�0ϓ�D2�����:���]��kQ��4J�g��Km�6��:��X��!ʶ������F�v1���A�������"[LȾ�Rw�y���g�ʔR;��E�      �   T   x�342��L,((�/KM�4400�420��54�5��242ɧ�&�d��P�-���(�a��@�7�tq�%o����� BS      �   X   x�U�1
�0�9�K�mD�!n.b;����'��x�y����zj!@2h����R�c?ͣ��<��~��<;�Γ�:W��K��/��%�      �   C   x�Uʹ�0B�z�gam���:�iG�� 8-�����9�%8M����:��۽s�'t�k�Hn�+�      �   3   x�Mȱ  �9��� q��A��с@bI���3t��{����e�N�fL
h      ]   0   x�3�4�464�2�\�@�HqrZ%�9�8-��b���� �:�      _   P   x�m��	�0г���?i\����hB�ty )��(�h21ayXv���؋�#���N���rBl�V����g      �   T   x�M��� CѳU���Z��K��鏂�U:������� ��h4��T ?d[�2&�Y�,����g��a�����          �   x�U�A
B1�us��/�4i�l��D���؂h�.��J����]�ǳ�;���`綳l@�PҢ�ib�$�ӝn��l���ԥaF�a���l��Z̳���>a�,������ ylG�F��`��vX�����@n�,�N#�m�9�-�֨g�친�����| �7lgT�         L   x�3�4202�54�50�tI-�/�,
p"d,9�3K2R��9Q�ᚌA2FP#d��Qe�Ɓ�b���� N��      `      x�3���2�4�2bN#.S ����� 3w      u      x�34�44�46�24�42 ��b���� (�7      e   �   x�}�A�0��/�e�$s�c�1�u���޶^z��������]j��xE;,@��npLs���-F��3�}}�^�
Lm�#X3�]|\m;jݹ�Eh�ei��t]�l�ք�,��*d�����DD_��Q�      R   Q   x�3202�50�54�4��q�u�H��K��2���ra7�4�*n�i��Y��Z���o�E�\�Д�I8F��� �S!�      l   A   x�3��/IUH�/Rp�LI��2��I-Q(-V�M�NUp�M-�LNTH/JM,QHLO��S����� 
bj      B   7   x�=ʱ  �:�%�v��]�(P����v���ЇJ*���KT�Q�Y .�`z      �   L   x�s��LN�)J,K��4202�50�54�3���J\�3����1T�1F&��S~�=3-�b���� �!      �   6   x�=̱	  ���I"����sh!�|�[�f�!F�P��Yxec���� .E��      �   C   x�3�420��50"N�Լ��|.#�����%gpbnqi^:�1\��%��;�	�o�kd������� �9      �   C   x�3�420��50"N�Լ��|.#�����%gpbnqi^:�1\��%��;�	�o�kd������� ��      �   /   x�3�tI��L��2�����LN�2��M,�L�2��J�M-����� �\
=      N   C   x�3�t��LN�2�t�O�2�R+�L8]��sR��9}RS��9������<.CKNל��b�=... ��      �   �   x�U��� ���k8K*j�[M�L�:��\ۛCAm��-���ݓ{~8i���2̱q-��B��,Ş,��C癢Xbg-]�F"���
5�BHL��5���i�� ���By�Ğ��E�Xn�n m��uO7�d���{g)�� �iIl      �   @   x�3���/-.ILK�440�2����K,�H��4r�9�3�K��@�@�	�Oif1������ ��      ^   ,   x��4 CNǜ��T.Kǈ�)?	�4�t�H,��L����� �
      f       x�3�t��LN�2�t�O�2�R+�b���� W_�      i      x�3�L��LN�2�L�w����� -�      �   W   x�3�,N,J�p�IM-I�OI�K���	qq&�'�J8�'qs&�d&��J8���L83R��+Q�<@B\�����EU�R� !�=... Vb-j      f   :   x�3����L��L�+�2�L-�q��$L�؆ NJQfYj��!2��c�ĉ���� |�e      �      x���43��47����� ��      �   C   x�e���@ѳ�KP�]X��� H���ܞFh����F�*X0�Q��>G/�#l6���a�HĎ      �   G   x�3�4�4�420��5��50�2�4A0�0Cqq�!�
� �
��!T�\��l�	B�S F��� )/      �   ?   x�3�4202�50".#ǈ��Y���3�2DVh�CƄ��14�B`d�e��Xp��qqq 'K�      \   *   x�3�42�2��2�46�2�45�2�4�2�,@D� j�J         I   x�E���0�f���6�/���zHґE�HS��p%��!z�VKP;`�8�b����o�	q�;�^ >���      m      x�3�4�2�4�2�4�2�M9M�b���� (      Z   3   x��q��/-N5�B.ǈ�� �3�4�q��F��c�i4!F��� u�      G   j   x�]�Q
�0�o�K��t�w���1[�| I���͠�5��C]�=,mE$�H킳�cy�g�ئkkM���6�ui+S����rT���N�zƓ�Ӓס�7�',�      P   /   x�3�4204�50"NC.#�4�2F�AL.߄�؀+F��� ��      4   A   x�M���0�w�#�0��ȉ�},�\2�y��Q��̢N���#�t�5�\�� >op      X   �   x�=�=� ����͟z�.�M(RD*�޿�HY,K�ӳ�?��mO�V8ˬ�ZD¾�ш����.�����,�H���! O���U�[y%`-#מ��D�А���v�'����O���j"6ΏwzI��㦔���0     