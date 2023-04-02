from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    events_df = spark.read_table_as_df("events_1126")
    events_df.show()

    w = Window.partitionBy('event_type')

    result_df = events_df \
        .withColumn('avg_event_occurence', F.avg('occurences').over(w)) \
        .filter(F.col('occurences') > F.col('avg_event_occurence')) \
        .groupby('business_id').agg(F.count('event_type').alias('event_types')) \
        .filter(F.col('event_types') >= 2) \
        .select('business_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
