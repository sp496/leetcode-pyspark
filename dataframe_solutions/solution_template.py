from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code

    df = spark.read_table_as_df("scores_178")
    df.show()

    result_df = df
    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
