from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    sales_df = spark.read_table_as_df("sales_1068")
    sales_df.show()

    prod_df = spark.read_table_as_df("product_1068")
    prod_df.show()

    wspec = W.partitionBy('product_id').orderBy('year')

    result_df = sales_df \
        .withColumn('n_year', F.rank().over(wspec)) \
        .filter(F.col('n_year') == 1)

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
