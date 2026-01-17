CREATE TABLE IF NOT EXISTS s_psql_dds.t_dm_task (
    id BIGSERIAL PRIMARY KEY,
    

    vendor_id_dim INTEGER NOT NULL,
    ratecode_id_dim INTEGER NOT NULL,
    pu_location_id_dim INTEGER NOT NULL,
    do_location_id_dim INTEGER NOT NULL,
    payment_type_dim INTEGER NOT NULL,
    

    tpep_pickup_datetime TIMESTAMP NOT NULL,
    tpep_dropoff_datetime TIMESTAMP NOT NULL,
    passenger_count INTEGER,
    trip_distance DECIMAL(8,2),
    tip_amount DECIMAL(8,2),
    improvement_surcharge DECIMAL(8,2),
    total_amount DECIMAL(8,2),
    congestion_surcharge DECIMAL(8,2),
    airport_fee DECIMAL(8,2),
    cbd_congestion_fee DECIMAL(8,2),
    
    FOREIGN KEY (vendor_id_dim) REFERENCES s_psql_dds.dim_vendor(id),
    FOREIGN KEY (ratecode_id_dim) REFERENCES s_psql_dds.dim_ratecode(id),
    FOREIGN KEY (pu_location_id_dim) REFERENCES s_psql_dds.dim_location(id),
    FOREIGN KEY (do_location_id_dim) REFERENCES s_psql_dds.dim_location(id),
    FOREIGN KEY (payment_type_dim) REFERENCES s_psql_dds.dim_payment(id)
);