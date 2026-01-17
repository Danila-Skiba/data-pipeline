--Таблица справочник
create table if not EXISTS s_psql_dds.dim_ratecode(
    id serial PRIMARY KEY,
    name VARCHAR
);