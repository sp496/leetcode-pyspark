from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    m_df = spark.read_table_as_df("movies_1341")
    m_df.show()

    u_df = spark.read_table_as_df("users_1341")
    u_df.show()

    mr_df = spark.read_table_as_df("movie_rating_1341")
    mr_df.show()

    result_df = u_df.alias('u') \
                .join(mr_df.alias('mr'), on=F.col('u.user_id') == F.col('mr.user_id')) \
                .groupby('name').agg(F.count('*').alias('ratings')) \
                .orderBy(F.desc('ratings'), F.asc('name')) \
                .select(F.col('name').alias('results')) \
                .limit(1) \
                .union(
                 m_df.alias('m') \
                .join(mr_df.alias('mr'), on=F.col('m.movie_id') == F.col('mr.movie_id')) \
                .groupby('title').agg(F.avg('rating').alias('avg_rating')) \
                .orderBy(F.desc('avg_rating'), F.asc('title')) \
                .select(F.col('title').alias('results')) \
                .limit(1)
                )

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
