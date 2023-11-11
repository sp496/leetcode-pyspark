from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    actions_df = spark.read_table_as_df("actions_1132")
    actions_df.show()

    removals_df = spark.read_table_as_df("removals_1132")
    removals_df.show()

    result_df = actions_df \
        .filter(F.col('extra') == 'spam') \
        .join(removals_df, on='post_id', how='left') \
        .groupby('action_date') \
        .agg((F.count('remove_date') * 100 / (F.count('post_id'))).alias('percentage')) \
        .select(F.avg('percentage').alias('average_daily_percent'))

    result_df.show()


def solution_2(spark):

    import pyspark.sql.functions as F

    actions_df = spark.read_table_as_df("actions_1132")
    actions_df.show()

    removals_df = spark.read_table_as_df("removals_1132")
    removals_df.show()

    spam = (F.col('extra') == 'spam')
    removed = (F.col('remove_date').isNotNull())

    result_df = actions_df \
        .join(removals_df, on='post_id', how='left') \
        .groupby('action_date') \
        .agg(((F.count(F.when(spam & removed, True))) * 100 /
              (F.count(F.when(spam, True)))).alias('percentage')) \
        .filter(F.col('percentage').isNotNull()) \
        .select(F.avg('percentage').alias('average_daily_percent'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
