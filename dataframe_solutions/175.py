# https://www.jiakaobo.com/leetcode/175.%20Combine%20Two%20Tables.html

def main(spark):
    from pyspark.sql.functions import col

    person_df = spark.read_table_as_df("person_175")
    address_df = spark.read_table_as_df("address_175")

    result_df = person_df \
        .join(address_df, on='personid') \
        .select(col("firstname").alias("FirstName"), col("lastname").alias("LastName"), col("city").alias("City"),
                col("state").alias("State"))

    result_df.show()


if __name__ == '__main__':
    from dependencies import spark_db_ops

    spark_session = spark_db_ops.SparkDbOps()
    main(spark_session)
    spark_session.stop()
