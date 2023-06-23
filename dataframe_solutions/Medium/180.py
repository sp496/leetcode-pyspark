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
        .select(F.col('num').alias('ConsecutiveNums')).distinct()

    result_df.show()


def solution_2(spark):

    import pyspark.sql.functions as F

    logs_df = spark.read_table_as_df("Logs_180")
    logs_df.show()

    result_df = logs_df.alias("l1") \
        .join(logs_df.alias("l2"), on=F.col("l1.Id") == F.col("l2.Id") - 1) \
        .join(logs_df.alias("l3"), on=F.col("l2.Id") == F.col("l3.Id") - 1) \
        .where((F.col("l1.num") == F.col("l2.num")) & (F.col("l2.num") == F.col("l3.num"))) \
        .select(F.col("l1.num").alias('ConsecutiveNums')).distinct()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_3)
