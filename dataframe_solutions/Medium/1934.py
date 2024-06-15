from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    s_df = spark.read_table_as_df("signups_1934")
    s_df.show()

    c_df = spark.read_table_as_df("confirmations_1934")
    c_df.show()

    result_df = s_df \
                .join(c_df, on='user_id', how='left') \
                .groupby('user_id') \
                .agg((F.round(F.sum(F.when(F.col('action') == 'confirmed', 1).otherwise(0))/F.count('*'), 2))
                     .alias('confirmation_rate'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
