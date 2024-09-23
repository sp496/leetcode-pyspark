from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("transactions_1831")
    t_df.show()

    w_spec = W.partitionBy(F.date_format('day', 'yyyy-MM-dd')).orderBy(F.desc('amount'))

    result_df = t_df \
                .withColumn('rnk', F.rank().over(w_spec)) \
                .filter(F.col('rnk') == 1) \
                .select('transactions_id') \
                .orderBy('transactions_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
