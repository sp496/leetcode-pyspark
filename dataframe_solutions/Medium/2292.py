from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    o_df = spark.read_table_as_df("orders_2292")
    o_df.show()

    agg_df = o_df \
                .groupby('product_id', F.date_format(F.col('purchase_date'), 'yyyy').alias('year')) \
                .agg(F.count('*').alias('count'))

    result_df = agg_df.alias('a1') \
                .join(agg_df.alias('a2'), on=(F.col('a1.product_id') == F.col('a2.product_id'))
                                                &(F.col('a2.year') == F.col('a1.year') + 1)) \
                .select('a1.product_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
