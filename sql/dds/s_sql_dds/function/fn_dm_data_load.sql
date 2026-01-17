CREATE OR REPLACE FUNCTION s_psql_dds.fn_dm_data_load(
    start_dt DATE,
    end_dt DATE
)
RETURNS VOID AS $$
BEGIN

    truncate s_psql_dds.t_dm_task;
    

    INSERT INTO s_psql_dds.dim_vendor (name)
    SELECT DISTINCT CAST(vendor_id AS VARCHAR)
    FROM s_psql_dds.t_sql_source_structured
    WHERE DATE(tpep_pickup_datetime) BETWEEN start_dt AND end_dt
      AND vendor_id IS NOT NULL
    ON CONFLICT (name) DO NOTHING;

    INSERT INTO s_psql_dds.dim_ratecode (name)
    SELECT DISTINCT CAST(ratecode_id AS VARCHAR)
    FROM s_psql_dds.t_sql_source_structured
    WHERE DATE(tpep_pickup_datetime) BETWEEN start_dt AND end_dt
      AND ratecode_id IS NOT NULL
    ON CONFLICT (name) DO NOTHING;
    

    INSERT INTO s_psql_dds.dim_location (name)
    SELECT DISTINCT location_name
    FROM (
        SELECT CAST(pu_location_id AS VARCHAR) AS location_name
        FROM s_psql_dds.t_sql_source_structured
        WHERE DATE(tpep_pickup_datetime) BETWEEN start_dt AND end_dt
          AND pu_location_id IS NOT NULL
        UNION
        SELECT CAST(do_location_id AS VARCHAR) AS location_name
        FROM s_psql_dds.t_sql_source_structured
        WHERE DATE(tpep_pickup_datetime) BETWEEN start_dt AND end_dt
          AND do_location_id IS NOT NULL
    ) AS locations
    ON CONFLICT (name) DO NOTHING;
    INSERT INTO s_psql_dds.dim_payment (name)
    SELECT DISTINCT payment_type
    FROM s_psql_dds.t_sql_source_structured
    WHERE DATE(tpep_pickup_datetime) BETWEEN start_dt AND end_dt
      AND payment_type IS NOT NULL
    ON CONFLICT (name) DO NOTHING;
    

    INSERT INTO s_psql_dds.t_dm_task (
        vendor_id_dim,
        ratecode_id_dim,
        pu_location_id_dim,
        do_location_id_dim,
        payment_type_dim,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        passenger_count,
        trip_distance,
        tip_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        cbd_congestion_fee
    )
    SELECT 
        v.id AS vendor_id_dim,
        r.id AS ratecode_id_dim,
        pl.id AS pu_location_id_dim,
        dl.id AS do_location_id_dim,
        p.id AS payment_type_dim,
        s.tpep_pickup_datetime,
        s.tpep_dropoff_datetime,
        s.passenger_count,
        s.trip_distance,
        s.tip_amount,
        s.improvement_surcharge,
        s.total_amount,
        s.congestion_surcharge,
        s.airport_fee,
        s.cbd_congestion_fee
    FROM s_psql_dds.t_sql_source_structured s
    LEFT JOIN s_psql_dds.dim_vendor v ON CAST(s.vendor_id AS VARCHAR) = v.name
    LEFT JOIN s_psql_dds.dim_ratecode r ON CAST(s.ratecode_id AS VARCHAR) = r.name
    LEFT JOIN s_psql_dds.dim_location pl ON CAST(s.pu_location_id AS VARCHAR) = pl.name
    LEFT JOIN s_psql_dds.dim_location dl ON CAST(s.do_location_id AS VARCHAR) = dl.name
    LEFT JOIN s_psql_dds.dim_payment p ON s.payment_type = p.name
    WHERE DATE(s.tpep_pickup_datetime) BETWEEN start_dt AND end_dt;
    
    RAISE NOTICE 'Загружено данных за период: % - %', start_dt, end_dt;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ошибка при загрузке данных: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;