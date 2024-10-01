from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    df = spark.read_table_as_df("delivery_2686")
    df.show()

    result_df = df \
                .groupby('order_date') \
                .agg(F.round(100 * F.count(F.when(F.col('customer_pref_delivery_date') == F.col('order_date'), True))
                     / F.count('*'), 2).alias('immediate_percentage ')) \
                .orderBy('order_date')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
