from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    a_df = spark.read_table_as_df("accounts_1454")
    a_df.show()

    l_df = spark.read_table_as_df("logins_1454")
    l_df.show()

    wspec = W.partitionBy('id').orderBy('login_date')

    result_df = l_df \
                .dropDuplicates() \
                .withColumn('rnk', F.row_number().over(wspec)) \
                .withColumn('prev_date', F.col('login_date') - F.col('rnk')) \
                .groupby('id', 'prev_date').agg(F.count('*').alias('consecutive_logins')) \
                .filter(F.col('consecutive_logins') >= 5) \
                .join(a_df, on='id') \
                .select('id', 'name')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
