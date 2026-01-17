USE taxi_dwh;

CREATE TABLE t_dm_task_mysql (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    vendor_id_dim INT NOT NULL,
    ratecode_id_dim INT NOT NULL,
    pu_location_id_dim INT NOT NULL,
    do_location_id_dim INT NOT NULL,
    payment_type_dim INT NOT NULL,
    tpep_pickup_datetime DATETIME NOT NULL,
    tpep_dropoff_datetime DATETIME NOT NULL,
    passenger_count INT,
    trip_distance DECIMAL(8,2),
    tip_amount DECIMAL(8,2),
    improvement_surcharge DECIMAL(8,2),
    total_amount DECIMAL(8,2),
    congestion_surcharge DECIMAL(8,2),
    airport_fee DECIMAL(8,2),
    cbd_congestion_fee DECIMAL(8,2)
);