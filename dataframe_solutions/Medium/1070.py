from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    w = Window.partitionBy(F.col('product_id')).orderBy(F.col('year'))

    sales_df = spark.read_table_as_df("sales_1068")
    sales_df.show()

    prod_df = spark.read_table_as_df("product_1068")
    prod_df.show()

    result_df = sales_df \
        .withColumn('n_year', F.rank().over(w)) \
        .filter(F.col('n_year') == 1)

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
