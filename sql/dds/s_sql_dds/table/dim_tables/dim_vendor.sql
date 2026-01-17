--Таблица справочник
create table if not EXISTS s_psql_dds.dim_vendor(
    id serial PRIMARY KEY,
    name VARCHAR
);