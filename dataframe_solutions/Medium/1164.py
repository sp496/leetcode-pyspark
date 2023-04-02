from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    prod_df = spark.read_table_as_df("products_1164")
    prod_df.show()

    w = Window.partitionBy('product_id').orderBy(F.desc('change_date_'))

    result_df = prod_df \
        .withColumn('change_date_', F.when(F.col('change_date') <= '2019-08-16', F.col('change_date'))) \
        .withColumn('new_price', F.when(F.col('change_date_') <= '2019-08-16', F.col('new_price')).otherwise(10)) \
        .withColumn('price', F.first('new_price').over(w)) \
        .dropDuplicates(['product_id', 'price']) \
        .select(['product_id', 'price'])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
