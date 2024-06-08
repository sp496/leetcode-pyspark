from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    w_spec = W.partitionBy('product_id').orderBy(F.desc('order_date'))

    o_df = spark.read_table_as_df("orders_1549")
    o_df.show()

    p_df = spark.read_table_as_df("products_1549")
    p_df.show()

    result_df = p_df \
                .join(o_df, on='product_id') \
                .withColumn('rnk', F.rank().over(w_spec)) \
                .filter(F.col('rnk') == 1) \
                .select('product_name', 'product_id', 'order_id', 'order_date')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
