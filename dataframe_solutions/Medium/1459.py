from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    df = spark.read_table_as_df("scores_178")
    df.show()

    result_df = df

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
