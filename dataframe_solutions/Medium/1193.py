from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    t_df = spark.read_table_as_df("transactions_1193")
    t_df.show()

    result_df = t_df \
        .groupby([F.date_format('trans_date', 'yyyy-MM').alias('month'), 'country']) \
        .agg(F.count('id').alias('trans_count'),
             F.count(F.when(F.col('state') == 'approved', True)).alias('approved_count'),
             F.sum('amount').alias('trans_total_amount'),
             F.sum(F.when(F.col('state') == 'approved', F.col('amount'))).alias('approved_total_amount'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
