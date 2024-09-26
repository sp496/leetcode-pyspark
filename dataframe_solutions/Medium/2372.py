from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    sp_df = spark.read_table_as_df("salesperson_2372")
    sp_df.show()

    c_df = spark.read_table_as_df("customer_2372")
    c_df.show()

    s_df = spark.read_table_as_df("sales_2372")
    s_df.show()

    result_df = sp_df \
                .join(c_df, on='salesperson_id', how='left') \
                .join(s_df, on='customer_id', how='left') \
                .groupby('salesperson_id', 'name').agg(F.ifnull(F.sum(F.col('price')), F.lit(0)).alias('total'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
