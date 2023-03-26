from dependencies import spark_pg_utils


def solution_1(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code

    from pyspark.sql.functions import col, count

    can_df = spark_pg.read_table_as_df("candidate_574")
    can_df.show()
    vote_df = spark_pg.read_table_as_df("vote_574")
    vote_df.show()

    result_df = vote_df.alias('v')\
        .join(can_df.alias('c'), on=col('v.candidate_id') == col('c.id'))\
        .groupby([col('v.candidate_id'), col('c.name')]).agg(count('v.id').alias('votes'))\
        .orderBy(col('votes').desc())\
        .limit(1)\
        .select(col('name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
