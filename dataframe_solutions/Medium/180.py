from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    window_spec = Window.orderBy(F.asc(F.col('id')))

    logs_df = spark.read_table_as_df("Logs_180")
    logs_df.show()

    result_df = logs_df \
        .withColumn('second_num', F.lead(F.col('num')).over(window_spec)) \
        .withColumn('third_num', F.lead(F.col('second_num')).over(window_spec)) \
        .where((F.col('second_num') == F.col('num')) & (F.col('third_num') == F.col('second_num'))) \
        .select(F.col('num').alias('ConsecutiveNums'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
