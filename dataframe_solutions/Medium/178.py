from dependencies import spark_pg_utils


def solution_1(spark):
    from pyspark.sql import functions as F, Window as W

    wspec = W.orderBy(F.desc(F.col('score'))).rowsBetween(W.unboundedPreceding, W.currentRow)

    scores_df = spark.read_table_as_df("scores_178")

    result_df = scores_df \
        .select('score', F.dense_rank().over(wspec).alias('Rank'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
