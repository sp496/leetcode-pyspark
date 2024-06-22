from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    o_df = spark.read_table_as_df("orders_2084")
    o_df.show()

    result_df = o_df.alias('o1') \
                .join(o_df.alias('o2'), on=(F.col('o1.customer_id') == F.col('o2.customer_id'))
                                        & (F.col('o1.order_type') != F.col('o2.order_type')), how='left') \
                .filter((F.col('o2.order_type').isNull()) | (F.col('o2.order_type') == 1)) \
                .select('o1.order_id', 'o1.customer_id', 'o1.order_type')

    result_df.show()



def solution_2(spark):

    from pyspark.sql import functions as F

    o_df = spark.read_table_as_df("orders_2084")
    o_df.show()

    result_df = o_df.alias('o1') \
                .groupby('customer_id') \
                .agg(F.min('order_type').alias('min_order')) \
                .join(o_df.alias('o2'), on=(F.col('o1.customer_id')==F.col('o2.customer_id'))
                                            & (F.col('min_order')==F.col('o2.order_type'))) \
                .select('o2.order_id', 'o2.customer_id', 'o2.order_type')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
