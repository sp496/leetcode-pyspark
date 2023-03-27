from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/534.%20Game%20Play%20Analysis%20III.html

    # pyspark code
    import pyspark.sql.functions as F

    act_df = spark.read_table_as_df("activity_534")
    act_df.show()

    result_df = act_df.alias('a1') \
        .join(act_df.alias('a2'),
              on=(F.col('a1.player_id') == F.col('a2.player_id')) & (F.col('a2.event_date') <= F.col('a1.event_date')),
              how='inner') \
        .groupby([F.col('a1.player_id'), F.col('a1.event_date')]) \
        .agg(F.sum('a2.games_played').alias('games_played_so_far'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
