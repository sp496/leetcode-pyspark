from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    uv_df = spark.read_table_as_df("user_visits_1709")
    uv_df.show()

    w_spec = W.partitionBy('user_id').orderBy('visit_date')
    result_df = uv_df \
                .withColumn('window',
                            F.lead('visit_date', 1, '2021-01-01').over(w_spec) - F.col('visit_date')) \
                .groupby('user_id').agg(F.max('window').cast('int').alias('biggest_window'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
