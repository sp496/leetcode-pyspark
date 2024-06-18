from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("transactions_2066")
    t_df.show()

    w_spec = W.partitionBy('account_id').orderBy('day')

    result_df = t_df \
                .withColumn('balance',  F.sum(F.when(F.col('type') == 'Withdraw', -F.col('amount'))
                                              .otherwise(F.col('amount'))).over(w_spec)) \
                .select('account_id', 'day', 'balance')

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("transactions_2066")
    t_df.show()

    w_spec = W.partitionBy('account_id').orderBy('day')

    result_df = t_df \
                .withColumn('amount', F.when(F.col('type') == 'Withdraw', -F.col('amount')).otherwise(F.col('amount')))\
                .withColumn('balance',  F.sum('amount').over(w_spec)) \
                .select('account_id', 'day', 'balance')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
