from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("tasks_2298")
    t_df.show()

    result_df = t_df \
                .withColumn('day_of_week', F.dayofweek('submit_date')) \
                .select(F.count(F.when(F.col('day_of_week').isin([7, 1]), True)).alias('weekend_count'),
                        F.count(F.when(~F.col('day_of_week').isin([7, 1]), True)).alias('working_cnt'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
