from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    p_df = spark.read_table_as_df("points_1459")
    p_df.show()

    result_df = p_df.alias('p1') \
                .join(p_df.alias('p2'), on=(F.col('p1.id') < F.col('p2.id')) &
                                           (F.col('p1.x_value') != F.col('p2.x_value')) &
                                           (F.col('p1.y_value') != F.col('p2.y_value'))) \
                .withColumn('area', F.abs(F.col('p1.x_value') - F.col('p2.x_value')) *
                            F.abs(F.col('p1.y_value') - F.col('p2.y_value'))) \
                .select(F.col('p1.id').alias('p1'), F.col('p2.id').alias('p2'), 'area')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
