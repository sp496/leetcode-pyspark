from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    f_df = spark.read_table_as_df("friendship_1949")
    f_df.show()

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
