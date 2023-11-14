from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    a_df = spark.read_table_as_df("activities_1355")
    a_df.show()

    f_df = spark.read_table_as_df("friends_1355")
    f_df.show()

    result_df = f_df \
                .groupby()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
