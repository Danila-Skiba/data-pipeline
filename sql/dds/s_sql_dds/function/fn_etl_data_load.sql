create or replace function s_psql_dds.fn_etl_data_load(start_date date, end_date date)
returns void as $$
begin
    truncate s_psql_dds.t_sql_source_structured;

    insert into s_psql_dds.t_sql_source_structured (
        vendor_id, 
        tpep_pickup_datetime, 
        tpep_dropoff_datetime, 
        passenger_count,
        trip_distance,
        ratecode_id,
        pu_location_id,
        do_location_id,
        payment_type,
        tip_amount, 
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee,
        cbd_congestion_fee  
    )
    select distinct
        --Vendor_ID(Поставщик)--
        case 
            when vendor_id is null or vendor_id = '' then 0
            when vendor_id in ('1', '2') then vendor_id::INTEGER
            else 0
        end as vendor_id,

        --tpep_pickup_datetime--
        case 
            when tpep_pickup_datetime::TIMESTAMP >= tpep_dropoff_datetime::TIMESTAMP then null
            when tpep_pickup_datetime::TIMESTAMP > CURRENT_TIMESTAMP then null
            else tpep_pickup_datetime::TIMESTAMP
        end as tpep_pickup_datetime,

        --tpep_dropoff_datetime--
        case 
            when tpep_dropoff_datetime::TIMESTAMP > CURRENT_TIMESTAMP then null
            else tpep_dropoff_datetime::TIMESTAMP
        end as tpep_dropoff_datetime,

        --passenger_count--
        case 
            when passenger_count is null or passenger_count = '' then null
            when passenger_count ~ '^-?\d+(\.\d+)?$' then
                case
                    -- Сначала в DECIMAL, потом в INTEGER (отбрасывает дробную часть)
                    when passenger_count::DECIMAL < 0 then null
                    when passenger_count::DECIMAL > 9 then 9
                    else passenger_count::DECIMAL::INTEGER
                end
            else null
        end as passenger_count,

        --TRIP_DISTANCE--
        case 
            when trip_distance is null or trip_distance ='' then 0.0
            when trip_distance ~ '^-?\d+(\.\d+)?$' then 
                case 
                    when trip_distance::DECIMAL < 0 THEN 0.0
                    when trip_distance::DECIMAL > 500 then 500.0
                    else ROUND(trip_distance::DECIMAL, 2)
                end
            else 0.0
        end as trip_distance,

        --RATECODE_ID--
        case 
            when ratecode_id is null or ratecode_id = '' then 1
            when ratecode_id ~ '^-?\d+(\.\d+)?$' then 
                case 
                    when ratecode_id::DECIMAL::INTEGER between 1 and 6 
                        then ratecode_id::DECIMAL::INTEGER
                    else 1
                end
            else 1
        end as ratecode_id,

        --pu_location--
        case
            when pu_location_id IS NULL OR pu_location_id = '' then NULL
            when pu_location_id ~ '^\d+$' then
                case
                    when pu_location_id::INTEGER BETWEEN 1 AND 263 then pu_location_id::INTEGER
                    when pu_location_id::INTEGER IN (264, 265) then pu_location_id::INTEGER
                    else NULL
                end
            else NULL
        end as pu_location_id,

        -- DO_LOCATION_ID--
        case 
            when do_location_id is null or do_location_id = '' then NULL
            when do_location_id ~ '^-?\d+(\.\d+)?$' then
                case 
                    when do_location_id::DECIMAL::INTEGER between 1 and 263 
                        then do_location_id::DECIMAL::INTEGER
                    when do_location_id::DECIMAL::INTEGER in (264, 265) 
                        then do_location_id::DECIMAL::INTEGER
                    else NULL
                end
            else NULL
        end as do_location_id,

        --payment_type--
        case 
            when upper(payment_type) = 'CASH' then 'Cash'
            when upper(payment_type) = 'CREDIT' then 'Credit'
            when upper(payment_type) = 'CREDIT CARD' then 'Credit'
            when upper(payment_type) = 'NO CHARGE' then 'No charge'
            when upper(payment_type) = 'DISPUTE' then 'Dispute'
            when upper(payment_type) = 'UNKNOWN' then 'Unknown'

            when payment_type ilike '%cash%' then 'Cash'
            when payment_type ilike '%credit%' then 'Credit'
            when payment_type ilike '%card%' then 'Credit'
            when payment_type ilike '%no charge%' then 'No charge'
            when payment_type ilike '%dispute%' then 'Dispute'
            else 'Unknown'
        end as payment_type,

        --TIP_AMOUNT--
        case 
            when tip_amount ~ '^-?\d+(\.\d+)?$' then
                case 
                    when tip_amount::DECIMAL < 0 then NULL
                    when tip_amount::DECIMAL > 1000 then 1000.0
                    else ROUND(tip_amount::DECIMAL, 2)
                end
            else NULL
        end as tip_amount,

        --IMPROVEMENT_SURCHARGE--
        case 
            when improvement_surcharge ~ '^\d+(\.\d+)?$' 
                and improvement_surcharge::DECIMAL BETWEEN 0 AND 1
                then ROUND(improvement_surcharge::DECIMAL, 2)
            else NULL
        end as improvement_surcharge,

        --total_amount--
        case 
            when total_amount ~ '^-?\d+(\.\d+)?$' then
                case  
                    when total_amount::DECIMAL < 0 then NULL
                    when total_amount::DECIMAL > 10000 then NULL
                    else ROUND(total_amount::DECIMAL, 2)
                end
            else NULL
        end as total_amount,

        --CONGESTION_SURCHARGE--
        case 
            when congestion_surcharge ~ '^-?\d+(\.\d+)?$' then
                case 
                    when congestion_surcharge::DECIMAL < 0 then NULL
                    when congestion_surcharge::DECIMAL > 2.5 then NULL
                    else ROUND(congestion_surcharge::DECIMAL, 2)
                end
            else NULL
        end as congestion_surcharge,

        --AIRPORT_FEE--
        case 
            when airport_fee ~ '^-?\d+(\.\d+)?$' then
                case 
                    when airport_fee::DECIMAL < 0 then NULL
                    when airport_fee::DECIMAL < 10.0 then airport_fee::DECIMAL
                    else NULL
                end
            else NULL
        end as airport_fee,

        --CBD_CONGESTION_FEE--
        case 
            when cbd_congestion_fee ~ '^-?\d+(\.\d+)?$' then
                case 
                    when cbd_congestion_fee::DECIMAL < 0 then NULL
                    when cbd_congestion_fee::DECIMAL > 0.8 then NULL
                    else ROUND(cbd_congestion_fee::DECIMAL, 2)
                end
            else NULL
        end as cbd_congestion_fee

    FROM s_psql_dds.t_sql_source_unstructured
    where 
        tpep_pickup_datetime is not null
        and vendor_id is not null
        and total_amount is not null
        and tpep_pickup_datetime::DATE BETWEEN start_date AND end_date and tpep_pickup_datetime::DATE is not null
    ORDER BY  tpep_pickup_datetime;
    
    RAISE NOTICE 'ETL завершен для периода % - %', start_date, end_date;
END;
$$ LANGUAGE plpgsql;