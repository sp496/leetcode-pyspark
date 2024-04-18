from dependencies import spark_pg_utils


def solution_1(spark):
    import pyspark.sql.functions as F

    fol_df = spark.read_table_as_df("follow_614")
    fol_df.show()

    result_df = fol_df.alias('f1') \
        .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='left_semi') \
        .groupby('followee').agg(F.count('follower').alias('num'))

    result_df.show()


def solution_2(spark):
    import pyspark.sql.functions as F

    fol_df = spark.read_table_as_df("follow_614")
    fol_df.show()


    result_df = fol_df.alias('f1') \
        .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='inner') \
        .groupby('f1.followee').agg(F.count('f1.follower').alias('num'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_2)
