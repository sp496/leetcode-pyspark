from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    cust_df = spark.read_table_as_df("customer_1045")
    cust_df.show()

    prod_df = spark.read_table_as_df("product_1045")
    prod_df.show()

    unique_product_count = prod_df.count()

    print(unique_product_count)

    result_df = cust_df \
        .groupby('customer_id').agg(F.countDistinct('product_key').alias('products')) \
        .filter(F.col('products') == unique_product_count) \
        .select('customer_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
