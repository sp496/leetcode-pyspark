from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code

    from pyspark.sql.functions import col, count, desc

    req_df = spark.read_table_as_df("request_accepted_602")
    req_df.show()

    result_df = req_df.select([col('requester_id').alias('id'), col('accepter_id').alias('friend_id')])\
        .union(req_df.select([col('accepter_id').alias('id'), col('requester_id').alias('friend_id')]))\
        .groupby('id').agg(count('friend_id').alias('num'))\
        .orderBy(desc('num'))\
        .limit(1)

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
