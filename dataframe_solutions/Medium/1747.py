from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    l_df = spark.read_table_as_df("log_info_1747")
    l_df.show()

    result_df = l_df.alias('l1') \
                .join(l_df.alias('l2'), on=(F.col('l1.account_id') == F.col('l2.account_id'))
                                            & (F.col('l1.ip_address') != F.col('l2.ip_address'))
                                            & (F.col('l2.login').between(F.col('l1.login'), F.col('l1.logout')))) \
                .select('account_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
