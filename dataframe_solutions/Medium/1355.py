from dependencies import spark_pg_utils


def solution_1(spark):
    from pyspark.sql import functions as F, Window as W

    a_df = spark.read_table_as_df("activities_1355")
    a_df.show()

    f_df = spark.read_table_as_df("friends_1355")
    f_df.show()

    wspec = W.orderBy('count').rowsBetween(W.unboundedPreceding, W.unboundedFollowing)

    result_df = f_df \
        .groupby('activity') \
        .agg(F.count('*').alias('count')) \
        .withColumn('rank1', F.first('count').over(wspec)) \
        .withColumn('rank2', F.last('count').over(wspec)) \
        .filter((F.col('count') != F.col('rank1')) & (F.col('count') != F.col('rank2'))) \
        .select('activity')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
