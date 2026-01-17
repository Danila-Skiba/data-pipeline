CREATE OR REPLACE VIEW s_psql_dds.v_dm_task AS
SELECT
    id,
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
FROM s_psql_dds.t_dm_task;