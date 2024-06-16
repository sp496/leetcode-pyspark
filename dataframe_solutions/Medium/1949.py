from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    f_df = spark.read_table_as_df("friendship_1949")
    f_df.show()

    """we are doing a self join f1.u2 = f2.u1. so any matches we get are mutual friends of f1.u1 and f1.u2.
    but this is only accurate if the table has all possible friend combos. so if the table has an entry for 2,3
    but no entry for 3,2 then you can't find mutual friends accurately, that's why we do the join"""

    f_df = f_df \
            .union(f_df.select(F.col('user2_id').alias('user1_id'), F.col('user1_id').alias('user2_id')))

    f_df.show()

    result_df = f_df.alias('f1') \
                .join(f_df.alias('f2'), on=(F.col('f1.user2_id') == F.col('f2.user1_id'))
                                            & (F.col('f2.user2_id') != F.col('f1.user1_id'))) \
                .join(f_df.alias('f3'), on=(F.col('f1.user1_id') == F.col('f3.user1_id'))
                                            & (F.col('f2.user2_id') == F.col('f3.user2_id'))) \
                .filter(F.col('f1.user1_id') < F.col('f1.user2_id')) \
                .groupby(F.col('f1.user1_id'), F.col('f1.user2_id')) \
                .agg(F.count('*').alias('common_friend')) \
                .filter(F.col('common_friend') >= 3)

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
