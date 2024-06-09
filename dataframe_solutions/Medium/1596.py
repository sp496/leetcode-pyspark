from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    w_spec = W.partitionBy('customer_id').orderBy(F.desc('prod_count'))

    o_df = spark.read_table_as_df("orders_1596")
    o_df.show()

    p_df = spark.read_table_as_df("products_1596")
    p_df.show()

    result_df = o_df \
                .groupBy('customer_id', 'product_id') \
                .agg(F.count('*').alias('prod_count')) \
                .withColumn('rank', F.rank().over(w_spec)) \
                .filter(F.col('rank') == 1) \
                .join(p_df, on='product_id') \
                .select('customer_id', 'product_id', 'product_name') \
                .orderBy('customer_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
