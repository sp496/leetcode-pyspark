from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    c_df = spark.read_table_as_df("calls_1699")
    c_df.show()

    result_df = c_df \
                .groupby(F.least('from_id', 'to_id').alias('person1'),
                         F.greatest('from_id', 'to_id').alias('person2')) \
                .agg(F.count('*').alias('call_count'), F.sum('duration').alias('total_duration'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
