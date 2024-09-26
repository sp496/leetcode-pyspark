from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    g_df = spark.read_table_as_df("genders_2308")
    g_df.show()

    w_spec = W.partitionBy('gender').orderBy('user_id')

    result_df = g_df \
                .withColumn('rnk1', F.row_number().over(w_spec)) \
                .withColumn('rnk2', F.when(F.col('gender') == 'female', 1)
                                    .when(F.col('gender') == 'other', 2).otherwise(3)) \
                .orderBy('rnk1', 'rnk2') \
                .select('user_id', 'gender')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
