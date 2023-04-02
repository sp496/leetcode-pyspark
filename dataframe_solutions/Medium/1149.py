from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    views_df = spark.read_table_as_df("views_1149")
    views_df.show()

    result_df = views_df \
        .groupby(['viewer_id', 'view_date']).agg(F.countDistinct(F.col('article_id')).alias('articles')) \
        .filter(F.col('articles') > 1) \
        .select('viewer_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
