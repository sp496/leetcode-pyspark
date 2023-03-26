from dependencies import spark_pg_utils


def solution_1(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/182.%20Duplicate%20Emails.html

    # pyspark code
    from pyspark.sql.functions import col

    person_df = spark_pg.read_table_as_df("person_182")
    result_df = person_df \
        .groupBy('email').count() \
        .filter(col('count') > 1) \
        .select(col('email'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)

