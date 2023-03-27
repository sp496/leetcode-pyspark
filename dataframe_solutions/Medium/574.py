from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/574.%20Winning%20Candidate.html

    # pyspark code

    import pyspark.sql.functions as F

    can_df = spark.read_table_as_df("candidate_574")
    can_df.show()
    vote_df = spark.read_table_as_df("vote_574")
    vote_df.show()

    result_df = vote_df.alias('v') \
        .join(can_df.alias('c'), on=F.col('v.candidate_id') == F.col('c.id')) \
        .groupby([F.col('v.candidate_id'), F.col('c.name')]).agg(F.count('v.id').alias('votes')) \
        .orderBy(F.col('votes').desc()) \
        .limit(1) \
        .select(F.col('name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
