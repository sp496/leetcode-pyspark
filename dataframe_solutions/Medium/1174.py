from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    del_df = spark.read_table_as_df("delivery_1174")
    del_df.show()

    w = Window.partitionBy('customer_id').orderBy('order_date')

    immediate_order = (F.col('customer_pref_delivery_date') == F.col('order_date'))
    first_order = (F.col('order_number') == 1)

    result_df = del_df \
        .withColumn('order_number', F.rank().over(w)) \
        .select(((F.count(F.when(first_order & immediate_order, True)) /
                  F.count(F.when(first_order, True))) * 100).alias('immediate_percentage'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
