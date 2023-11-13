from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    t_df = spark.read_table_as_df("transactions_1205")
    t_df.show()

    c_df = spark.read_table_as_df("chargebacks_1205")
    c_df.show()

    result_df = c_df.alias('c') \
        .join(t_df.alias('t'), on=F.col('c.trans_id') == F.col('t.id')) \
        .select(F.substring(F.col('charge_date'), 1, 7).alias('month'), 'country', 'amount',
                F.lit('chargeback').alias('state')) \
        .unionAll(t_df.select(F.substring(F.col('trans_date'), 1, 7).alias('month'), 'country', 'amount',
                           'state')) \
        .groupby('month', 'country') \
        .agg(F.count(F.when(F.col('state') == 'approved', 1)).alias('approved_count'),
             F.sum(F.when(F.col('state') == 'approved', F.col('amount')).otherwise(0)).alias('approved_amount'),
             F.count(F.when(F.col('state') == 'chargeback', 1)).alias('chargeback_count'),
             F.sum(F.when(F.col('state') == 'chargeback', F.col('amount')).otherwise(0)).alias('chargeback_amount'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
