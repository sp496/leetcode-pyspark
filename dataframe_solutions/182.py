# https://www.jiakaobo.com/leetcode/182.%20Duplicate%20Emails.html

def main(spark):
    from pyspark.sql.functions import col

    person_df = spark.read_table_as_df("person_182")
    result_df = person_df \
        .groupBy('email').count() \
        .filter(col('count') > 1) \
        .select(col('email'))

    result_df.show()


if __name__ == '__main__':
    from dependencies import spark_db_ops

    spark_session = spark_db_ops.SparkDbOps()
    main(spark_session)
    spark_session.stop()
