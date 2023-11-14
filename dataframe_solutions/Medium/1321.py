from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    c_df = spark.read_table_as_df("customer_1321")
    c_df.show()

    wspec = W.orderBy('visited_on').rowsBetween(-6, W.currentRow)

    result_df = c_df \
                .groupby('visited_on').agg(F.sum('amount').alias('amount')) \
                .select('visited_on', F.sum('amount').over(wspec).alias('amount'),
                        F.round(F.avg('amount').over(wspec), 2).alias('average_amount'),
                        F.count('*').over(wspec).alias('count')) \
                .filter(F.col('count') == 7)

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    c_df = spark.read_table_as_df("customer_1321")
    c_df.show()

    result_df = c_df.alias('c1') \
                .join(c_df.alias('c2'), on=F.col('c1'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
