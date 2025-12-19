CREATE TABLE IF NOT EXISTS s_psql_dds.t_sql_source_structured (
    vendor_id INTEGER,
    tpep_pickup_datetime TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count INTEGER,
    trip_distance DECIMAL(8,2),
    ratecode_id INTEGER,
    pu_location_id INTEGER,
    do_location_id INTEGER,
    payment_type VARCHAR(20),
    tip_amount DECIMAL(8,2),
    improvement_surcharge DECIMAL(8,2),
    total_amount DECIMAL(8,2),
    congestion_surcharge DECIMAL(8,2),
    airport_fee DECIMAL(8,2),
    cbd_congestion_fee DECIMAL(8,2)
);
