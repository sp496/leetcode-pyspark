from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/175.%20Combine%20Two%20Tables.html

    # pyspark code
    from pyspark.sql.functions import col

    person_df = spark.read_table_as_df("person_175")
    address_df = spark.read_table_as_df("address_175")

    result_df = person_df \
        .join(address_df, on='personid') \
        .select(col("firstname").alias("FirstName"), col("lastname").alias("LastName"), col("city").alias("City"),
                col("state").alias("State"))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
