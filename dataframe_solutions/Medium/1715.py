from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    b_df = spark.read_table_as_df("boxes_1715")
    b_df.show()

    c_df = spark.read_table_as_df("chests_1715")
    c_df.show()

    result_df = b_df.alias('b') \
                .join(c_df.alias('c'), on='chest_id', how='left') \
                .select((F.sum('b.apple_count') + F.sum('c.apple_count')).alias('apple_count'),
                        (F.sum('b.orange_count') + F.sum('c.orange_count')).alias('orange_count'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
