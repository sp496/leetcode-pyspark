from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    s_df = spark.read_table_as_df("sales_1445")
    s_df.show()

    result_df = s_df \
                .groupby('sale_date') \
                .agg((F.count(F.when(F.col('fruit')=='apples', True)) - F.count(F.when(F.col('fruit')=='oranges', True))).alias('diff'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
