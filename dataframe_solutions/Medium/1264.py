from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    f_df = spark.read_table_as_df("friendship_1264")
    f_df.show()

    l_df = spark.read_table_as_df("likes_1264")
    l_df.show()

    result_df = f_df.select('user_id1', 'user_id2') \
                .union(f_df.select(F.col('user_id2').alias('user_id1'), F.col('user_id1').alias('user_id2'))) \
                .alias('f') \
                .filter(F.col('user_id1') == 1) \
                .join(l_df.alias('l1'), on=F.col('f.user_id2') == F.col('l1.user_id'), how='inner') \
                .join(l_df.alias('l2'), on=(F.col('f.user_id1') == F.col('l2.user_id')) &
                                           (F.col('l1.page_id') == F.col('l2.page_id')), how='left_anti') \
                .select(F.col('page_id').alias('recommended_page')) \
                .distinct()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
