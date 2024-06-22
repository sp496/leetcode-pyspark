from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("transactions_1843")
    t_df.show()

    a_df = spark.read_table_as_df("accounts_1843")
    a_df.show()

    w_spec = W.partitionBy('account_id').orderBy('month')

    result_df = t_df \
                .groupby('account_id', F.date_format('day', 'yyyy-MM').alias('month')) \
                .agg(F.sum(F.when(F.col('type')=='Creditor', F.col('amount')).otherwise(0)).alias('spent')) \
                .join(a_df, on='account_id') \
                .filter(F.col('spent') > F.col('max_income')) \
                .withColumn('rank', F.row_number().over(w_spec)) \
                .groupby('account_id', F.add_months('month', -F.col('rank'))) \
                .agg(F.count('*').alias('consecutive_months')) \
                .filter(F.col('consecutive_months') >= 2) \
                .select('account_id').dropDuplicates()

    result_df.show()


def solution_2(spark):
    #interesting for 2 or more. You just need to prove 2, so no need to know exactly how many consecutive
    #just do one join for identifying 2

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("transactions_1843")
    t_df.show()

    a_df = spark.read_table_as_df("accounts_1843")
    a_df.show()

    df = t_df \
        .groupby('account_id', F.date_format('day', 'yyyy-MM').alias('month')) \
        .agg(F.sum('amount').alias('spent')) \
        .join(a_df, on='account_id') \
        .filter(F.col('spent') > F.col('max_income')) \

    result_df = df.alias('d1').join(df.alias('d2'),
                                    on=(F.col('d1.account_id')==F.col('d2.account_id'))
                                        & (F.col('d2.month') == F.add_months(F.col('d1.month'), 1))) \
                .select('d1.account_id').dropDuplicates()

    result_df.show()



if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
