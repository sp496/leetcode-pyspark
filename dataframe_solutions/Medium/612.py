from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    points_df = spark.read_table_as_df("point_2d_612")
    points_df.show()

    # could use cross join too
    result_df = points_df.alias('p1') \
        .join(points_df.alias('p2'),
              on=(F.col('p1.x') != F.col('p2.x')) | (F.col('p1.y') != F.col('p2.y')),
              how='inner') \
        .withColumn('distance', F.sqrt(F.pow(F.col('p2.x') - F.col('p1.x'), 2) +
                                       F.pow(F.col('p2.y') - F.col('p1.y'), 2))) \
        .select(F.min('distance').alias('shortest'))

    result_df.show()


def solution_2(spark):

    import pyspark.sql.functions as F

    points_df = spark.read_table_as_df("point_2d_612")
    points_df.show()

    result_df = points_df.alias('p1') \
        .join(points_df.alias('p2'),
              on=(((F.col('p1.x') <= F.col('p2.x')) & (F.col('p1.y') < F.col('p2.y'))) |
                  ((F.col('p1.x') <= F.col('p2.x')) & (F.col('p1.y') > F.col('p2.y'))) |
                  ((F.col('p1.x') < F.col('p2.x')) & (F.col('p1.y') == F.col('p2.y')))),
              how='inner') \
        .withColumn('distance',
                    F.sqrt(F.pow(F.col('p2.x') - F.col('p1.x'), 2) + F.pow(F.col('p2.y') - F.col('p1.y'), 2))) \
        .select(F.min('distance').alias('shortest'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
