from dependencies import spark_pg_utils


def main(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/180.%20Consecutive%20Numbers.html

    # pyspark code
    from pyspark.sql.functions import col, asc, lead
    from pyspark.sql.window import Window

    window_spec = Window.orderBy(asc(col('id')))

    logs_df = spark_pg.read_table_as_df("Logs_180")
    logs_df.show()

    result_df = logs_df\
        .withColumn('second_num', lead(col('num')).over(window_spec))\
        .withColumn('third_num', lead(col('second_num')).over(window_spec))\
        .where((col('second_num') == col('num')) & (col('third_num') == col('second_num')))\
        .select(col('num').alias('ConsecutiveNums'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(main)
