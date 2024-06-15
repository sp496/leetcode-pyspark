from dependencies import spark_pg_utils

def solution_1(spark):

    from pyspark.sql import functions as F

    o_df = spark.read_table_as_df("orders_details_1867")
    o_df.show()

    aggregated_df = o_df.groupby('order_id') \
                    .agg((F.sum('quantity') / F.countDistinct('product_id')).alias('average_quantity'),
                            F.max('quantity').alias('max_quantity'))

    max_avg_quantity = aggregated_df \
                        .select(F.max('average_quantity').alias('max_avg_quantity')).collect()[0]['max_avg_quantity']

    result_df = aggregated_df \
                .filter(F.col('max_quantity') > max_avg_quantity) \
                .select('order_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
