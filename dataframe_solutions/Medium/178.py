from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code
    from pyspark.sql.functions import col, desc, dense_rank
    from pyspark.sql.window import Window

    rank_spec = Window.orderBy(desc(col('score')))

    scores_df = spark.read_table_as_df("scores_178")
    result_df = scores_df.\
        withColumn('dense_rank', dense_rank().over(rank_spec))
    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
