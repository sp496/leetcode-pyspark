from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    act_df = spark.read_table_as_df("activity_534")
    act_df.show()

    wspec = W.partitionBy('player_id').orderBy('event_date').rowsBetween(W.unboundedPreceding, W.currentRow)

    result_df = act_df \
                .select('player_id', 'event_date', F.sum('games_played').over(wspec).alias('games_played_so_far'))

    result_df.show()


def solution_2(spark):

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
