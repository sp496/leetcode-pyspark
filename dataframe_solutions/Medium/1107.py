from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    traffic_df = spark.read_table_as_df("traffic_1107")
    traffic_df.show()

    w = Window.partitionBy('user_id').orderBy('activity_date')

    F.date_sub(F.to_date(F.lit('2019-06-30.')), 30)

    result_df = traffic_df \
        .withColumn('event_num', F.row_number().over(w)) \
        .filter(F.col('activity_date').between(F.date_sub(F.to_date(F.lit('2019-06-30.')), 30),
                                               F.date_add(F.to_date(F.lit('2019-06-30.')), 30))) \
        # .groupby('activity_date').count()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
