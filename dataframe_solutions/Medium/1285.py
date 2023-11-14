from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    l_df = spark.read_table_as_df("logs_1285")
    l_df.show()

    wspec = W.orderBy('log_id')

    result_df = l_df \
                .withColumn('num', F.row_number().over(wspec)) \
                .groupby(F.col('log_id') - F.col('num')) \
                .agg(F.min('log_id').alias('start_id'), F.max('log_id').alias('end_id')) \
                .select('start_id', 'end_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
