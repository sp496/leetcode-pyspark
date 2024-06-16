from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    r_df = spark.read_table_as_df("relations_1951")
    r_df.show()

    w_spec = W.orderBy(F.desc('common'))

    result_df = r_df.alias('r1') \
                .join(r_df.alias('r2'), on=(F.col('r1.follower_id') == F.col('r2.follower_id'))
                                            & (F.col('r1.user_id') != F.col('r2.user_id'))
                                            & (F.col('r1.user_id') < F.col('r2.user_id'))) \
                .groupby('r1.user_id', 'r2.user_id').agg(F.count('*').alias('common')) \
                .withColumn('rank', F.rank().over(w_spec)) \
                .filter(F.col('rank') == 1) \
                .select(F.col('r1.user_id').alias('user1_id'), F.col('r2.user_id').alias('user2_id'))


    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
