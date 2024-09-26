from dependencies import spark_pg_utils


def solution_2(spark):

    import pyspark.sql.functions as F

    o_df = spark.read_table_as_df("orders_1158")
    o_df.show()

    u_df = spark.read_table_as_df("users_1158")
    u_df.show()

    result_df = u_df \
        .join(o_df,
              on=(F.col('user_id') == F.col('buyer_id')) &
                 (F.col('order_date').between('2019-01-01', '2019-12-31')),
              how='left') \
        .groupby(['user_id', 'join_date']) \
        .agg(F.count('order_id').alias('orders_in_2019'))

    result_df.show()


def solution_1(spark):

    import pyspark.sql.functions as F

    o_df = spark.read_table_as_df("orders_1158")
    o_df.show()

    u_df = spark.read_table_as_df("users_1158")
    u_df.show()

    result_df = u_df \
        .join(o_df, on=(F.col('user_id') == F.col('buyer_id'))
                       & (F.date_format('order_date', 'yyyy') == '2019'), how='left') \
        .groupby(['user_id', 'join_date']) \
        .agg(F.count('order_id').alias('orders_in_2019'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
