from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/182.%20Duplicate%20Emails.html

    # pyspark code
    import pyspark.sql.functions as F

    person_df = spark.read_table_as_df("person_182")
    result_df = person_df \
        .groupBy('email').count() \
        .filter(F.col('count') > 1) \
        .select(F.col('email'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)

