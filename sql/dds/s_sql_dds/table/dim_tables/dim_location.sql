--Таблица справочник
create table if not EXISTS s_psql_dds.dim_location(
    id serial PRIMARY KEY,
    name VARCHAR(50)
);