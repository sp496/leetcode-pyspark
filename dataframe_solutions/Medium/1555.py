from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    u_df = spark.read_table_as_df("users_1555")
    u_df.show()

    t_df = spark.read_table_as_df("transactions_1555")
    t_df.show()

    result_df = u_df \
                .join(t_df, on=(F.col('user_id')==F.col('paid_by')) | (F.col('user_id')==F.col('paid_to')), how='left') \
                .groupby('user_id', 'credit', 'user_name') \
                .agg((F.sum(F.when(F.col('user_id') == F.col('paid_by'),
                                  -F.col('amount')).otherwise(F.col('amount'))) + F.col('credit')).alias('balance')) \
                .withColumn('credit', F.when(F.col('balance').isNull(), F.col('credit')).otherwise(F.col('balance'))) \
                .withColumn('credit_limit_breached', F.when(F.col('credit') < 0, 'Yes').otherwise('No')) \
                .select('user_id', 'user_name', 'credit', 'credit_limit_breached')


    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
