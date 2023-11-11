from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    traffic_df = spark.read_table_as_df("traffic_1107")
    traffic_df.show()

    wspec = W.partitionBy(['user_id', 'activity']).orderBy('activity_date')

    result_df = traffic_df \
                .filter(F.col('activity') == 'login') \
                .withColumn('rnk', F.rank().over(wspec)) \
                .filter(F.col('rnk') == 1) \
                .filter(F.col('activity_date') >= F.date_sub(F.to_date(F.lit('2019-06-30')), 90)) \
                .groupby('activity_date').agg(F.count('*').alias('user_count'))

    # .filter(F.col('activity_date').between(F.date_sub(F.to_date(F.lit('2019-06-30.')), 30),
    #                                        F.date_add(F.to_date(F.lit('2019-06-30.')), 30))) \
    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
