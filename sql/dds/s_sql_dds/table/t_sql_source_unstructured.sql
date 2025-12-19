CREATE TABLE IF NOT EXISTS s_psql_dds.t_sql_source_unstructured (
    vendor_id VARCHAR,
    tpep_pickup_datetime VARCHAR,
    tpep_dropoff_datetime VARCHAR,
    passenger_count VARCHAR,
    trip_distance VARCHAR,
    ratecode_id VARCHAR,
    pu_location_id VARCHAR,
    do_location_id VARCHAR,
    payment_type VARCHAR,
    tip_amount VARCHAR,
    improvement_surcharge VARCHAR,
    total_amount VARCHAR,
    congestion_surcharge VARCHAR,
    airport_fee VARCHAR,
    cbd_congestion_fee VARCHAR
);