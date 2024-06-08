from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    c_df = spark.read_table_as_df("customers_1532")
    c_df.show()

    o_df = spark.read_table_as_df("orders_1532")
    o_df.show()

    w_spec = W.partitionBy('customer_id').orderBy(F.desc('order_date'))

    result_df = o_df \
                .join(c_df, on='customer_id') \
                .withColumn('rnk', F.rank().over(w_spec)) \
                .filter(F.col('rnk') <= 3) \
                .orderBy(F.asc('name'), F.asc('customer_id'), F.desc('order_date')) \
                .select(F.col('name').alias('customer_name'), 'customer_id', 'order_id', 'order_date')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
