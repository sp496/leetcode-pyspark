from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    s_df = spark.read_table_as_df("stocks_1393")
    s_df.show()

    result_df = s_df \
                .withColumn('price', F.when(F.col('operation')=='Buy', -F.col('price')).otherwise(F.col('price'))) \
                .groupby('stock_name').agg(F.sum('price'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
