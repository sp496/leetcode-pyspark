from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/550.%20Game%20Play%20Analysis%20IV.html

    # pyspark code
    from pyspark.sql.functions import col, rank, when, count, countDistinct, round
    from pyspark.sql.window import Window

    act_df = spark.read_table_as_df("activity_550")
    act_df.show()

    w = Window.partitionBy(col('a1.player_id')).orderBy('a1.event_date')

    result_df = act_df.alias('a1') \
        .withColumn('day', rank().over(w)) \
        .join(act_df.alias('a2'),
              on=(col('a1.player_id') == col('a2.player_id')) & (col('a2.event_date') == col('a1.event_date') + 1),
              how='left') \
        .select(round((count(when((col('day') == 1) & (col('a2.player_id').isNotNull()), col('a1.player_id'))
                             .otherwise(None)) / countDistinct(col("a1.player_id"))), 2).alias('fraction'))

    result_df.show()




if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
