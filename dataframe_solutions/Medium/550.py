from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    act_df = spark.read_table_as_df("activity_550")
    act_df.show()

    w = Window.partitionBy(F.col('a1.player_id')).orderBy('a1.event_date')

    result_df = act_df.alias('a1') \
        .withColumn('day', F.rank().over(w)) \
        .filter(F.col('day') == 1) \
        .join(act_df.alias('a2'),
              on=(F.col('a1.player_id') == F.col('a2.player_id')) &
                 (F.col('a2.event_date') == F.col('a1.event_date') + 1),
              how='left') \
        .select(F.round(F.count(F.col('a2.player_id'))/F.count(F.col('a1.player_id')), 2).alias('fraction'))

    result_df.show()

def solution_2(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    act_df = spark.read_table_as_df("activity_550")
    act_df.show()

    w = Window.partitionBy(F.col('a1.player_id')).orderBy('a1.event_date')

    result_df = act_df.alias('a1') \
        .withColumn('day', F.rank().over(w)) \
        .join(act_df.alias('a2'),
              on=(F.col('a1.player_id') == F.col('a2.player_id')) &
                 (F.col('a2.event_date') == F.col('a1.event_date') + 1),
              how='left') \
        .select(F.round((F.count(F.when((F.col('day') == 1)
                                        & (F.col('a2.player_id').isNotNull()), F.col('a1.player_id'))
                                 .otherwise(None)) / F.countDistinct(F.col("a1.player_id"))), 2).alias('fraction'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
