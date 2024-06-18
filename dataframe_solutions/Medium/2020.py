from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    su_df = spark.read_table_as_df("subscriptions_2020")
    su_df.show()

    s_df = spark.read_table_as_df("streams_2020")
    s_df.show()

    result_df = su_df.alias('su') \
                .filter((F.date_format('start_date', 'yyyy') <= 2021)
                        & (F.date_format('end_date', 'yyyy') >= 2021)) \
                .join(s_df.alias('s'), on=(F.col('su.account_id') == F.col('s.account_id'))
                                            & (F.date_format('stream_date', 'yyyy') == 2021), how='left') \
                .filter(F.col('session_id').isNull()) \
                .select('su.account_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
