from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    events_df = spark.read_table_as_df("events_1126")
    events_df.show()

    wspec = W.partitionBy('event_type')

    result_df = events_df \
        .withColumn('avg_event_occurence', F.avg('occurences').over(wspec)) \
        .filter(F.col('occurences') > F.col('avg_event_occurence')) \
        .groupby('business_id').agg(F.count('event_type').alias('event_types')) \
        .filter(F.col('event_types') >= 2) \
        .select('business_id')

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F

    events_df = spark.read_table_as_df("events_1126")
    events_df.show()

    result_df = events_df \
        .groupby('event_type').agg(F.avg('occurences').alias('avg_occurences')) \
        .join(events_df, on='event_type') \
        .filter(F.col('occurences') > F.col('avg_occurences')) \
        .groupby('business_id').agg(F.count('event_type').alias('event_types')) \
        .filter(F.col('event_types') >= 2) \
        .select('business_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
