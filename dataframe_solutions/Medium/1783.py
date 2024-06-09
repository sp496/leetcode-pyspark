from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    p_df = spark.read_table_as_df("players_1783")
    p_df.show()

    c_df = spark.read_table_as_df("championships_1783")
    c_df.show()

    result_df = p_df \
                .join(c_df, on=(F.col('player_id') == F.col('Wimbledon')) | (F.col('player_id') == F.col('Fr_open'))
                                | (F.col('player_id') == F.col('US_open')) | (F.col('player_id') == F.col('Au_open'))) \
                .groupby('player_id', 'player_name') \
                .agg((F.sum(F.when(F.col('player_id') == F.col('wimbledon'), 1).otherwise(0))
                        + F.sum(F.when(F.col('player_id') == F.col('fr_open'), 1).otherwise(0))
                        + F.sum(F.when(F.col('player_id') == F.col('us_open'), 1).otherwise(0))
                        + F.sum(F.when(F.col('player_id') == F.col('au_open'), 1).otherwise(0))).alias('grand_slams_count'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
