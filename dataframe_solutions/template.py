# question-link from https://www.jiakaobo.com/leetcode.html

def main(spark):
    # pyspark code
    df = spark.read_table_as_df("employee_181")
    df.show()


if __name__ == '__main__':
    from dependencies import spark_db_ops

    spark_session = spark_db_ops.SparkDbOps()
    main(spark_session)
    spark_session.stop()
