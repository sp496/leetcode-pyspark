from dependencies import spark_pg_utils


def solution_1(spark):
    from pyspark.sql import functions as F, Window as W

    employee_df = spark.read_table_as_df("employee_181")
    employee_df.show()

    wspec = W.orderBy(F.desc("salary")).rowsBetween(W.unboundedPreceding, W.currentRow)

    result_df = employee_df \
        .withColumn('dense_rank', F.dense_rank().over(wspec)) \
        .where(F.col('dense_rank') == 2) \
        .select(F.col('salary').alias('SecondHighestSalary')).distinct()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
