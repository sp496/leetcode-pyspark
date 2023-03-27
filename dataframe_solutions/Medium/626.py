from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/626.%20Exchange%20Seats.html

    # pyspark code

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    seat_df = spark.read_table_as_df("seat_626")
    seat_df.show()

    result_df = seat_df.alias('s1') \
        .withColumn('order', F.when(F.col('id') % 2 == 0, F.col('id') - 1).otherwise(F.col('id') + 1)) \
        .withColumn("id", F.row_number().over(Window.orderBy("order")))\
        .orderBy('id') \
        .select([F.col('id'), F.col('student')])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
