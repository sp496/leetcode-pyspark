from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/614.%20Second%20Degree%20Follower.html

    # pyspark code
    import pyspark.sql.functions as F

    fol_df = spark.read_table_as_df("follow_614")
    fol_df.show()

    result_df = fol_df.alias('f1')\
        .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='semi') \
        .groupby('followee').agg(F.count('follower').alias('num'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
