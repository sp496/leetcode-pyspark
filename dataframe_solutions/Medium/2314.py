from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    w_df = spark.read_table_as_df("weather_2314")
    w_df.show()

    w_spec = W.partitionBy('city_id').orderBy(F.desc('degree'))

    result_df = w_df \
                .withColumn('rnk', F.row_number().over(w_spec)) \
                .filter(F.col('rnk') == 1) \
                .select('city_id', 'day', 'degree') \
                .orderBy('city_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
