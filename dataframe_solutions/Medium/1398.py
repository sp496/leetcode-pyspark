from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    o_df = spark.read_table_as_df("orders_1398")
    o_df.show()

    c_df = spark.read_table_as_df("customers_1398")
    c_df.show()

    result_df = o_df \
                .join(c_df, on='customer_id') \
                .groupby('customer_id', 'customer_name') \
                .agg(F.count(F.when(F.col('product_name')=='A', True)).alias('A_count'),
                     F.count(F.when(F.col('product_name')=='B', True)).alias('B_count'),
                     F.count(F.when(F.col('product_name')=='C', True)).alias('C_count')) \
                .filter((F.col('A_count')>0) & (F.col('B_count')>0) & (F.col('C_count')==0)) \
                .select('customer_id', 'customer_name')

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F

    o_df = spark.read_table_as_df("orders_1398")
    o_df.show()

    c_df = spark.read_table_as_df("customers_1398")
    c_df.show()

    result_df = o_df.alias('o1') \
                .join(o_df.alias('o2'), on=((F.col('o1.customer_id') == F.col('o2.customer_id')) &
                                            (F.col('o2.product_name') == 'C')), how='left_anti') \
                .select('customer_id') \
                .intersect(
                    o_df.filter(F.col('product_name') == 'A').select('customer_id') \
                        .intersect(o_df.filter(F.col('product_name') == 'B').select('customer_id'))
                            ) \
                .join(c_df, on='customer_id')

    result_df.show()

if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
