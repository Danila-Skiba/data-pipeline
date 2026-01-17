import psycopg2
import mysql.connector
from config import get_connection_string, MYSQL_CONFIG

def migrate_to_mysql():
    pg_conn = psycopg2.connect(get_connection_string())
    pg_cur = pg_conn.cursor()

    pg_cur.execute("""
        SELECT * FROM s_psql_dds.v_dm_task 
        order by tpep_pickup_datetime
    """)
    data = pg_cur.fetchall()
    pg_conn.close()


    if not data:
        print('Нет данных')
        return

    mysql_conn = mysql.connector.connect(**MYSQL_CONFIG)
    mysql_cur = mysql_conn.cursor()

    mysql_cur.execute("""
            truncate t_dm_task_mysql
    """)

    for row in data:
        mysql_cur.execute("""
        insert into t_dm_task_mysql
        (vendor_id_dim, ratecode_id_dim, pu_location_id_dim, 
        do_location_id_dim, payment_type_dim, tpep_pickup_datetime,
        tpep_dropoff_datetime, passenger_count, trip_distance,
        tip_amount, improvement_surcharge, total_amount,
        congestion_surcharge, airport_fee, cbd_congestion_fee)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, row[1:])
    

    mysql_conn.commit()
    mysql_conn.close()

    print('Успешно скопировано')


def main():
    migrate_to_mysql()

main() 