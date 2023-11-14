from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    s_df = spark.read_table_as_df("scores_1308")
    s_df.show()

    wspec = W.partitionBy('gender').orderBy('day').rowsBetween(W.unboundedPreceding, W.currentRow)

    result_df = s_df \
                .withColumn('total', F.sum('score_points').over(wspec)) \
                .orderBy('gender', 'day') \
                .select('gender', 'day', 'total')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
