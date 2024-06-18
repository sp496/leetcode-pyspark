from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    m_df = spark.read_table_as_df("members_2051")
    m_df.show()

    v_df = spark.read_table_as_df("visits_2051")
    v_df.show()

    p_df = spark.read_table_as_df("purchases_2051")
    p_df.show()

    result_df = m_df \
                .join(v_df, on='member_id', how='left') \
                .join(p_df, on='visit_id', how='left') \
                .groupby('member_id', 'name') \
                .agg((100*F.count('charged_amount')/F.count('visit_id')).alias('conversion_rate')) \
                .select('member_id', 'name', (F.when(F.col('conversion_rate') >= 80, 'Diamond')
                                                .when(F.col('conversion_rate') >= 50, 'Gold')
                                                .when(F.col('conversion_rate') < 50, 'Silver')
                                                .otherwise('Bronze')).alias('category'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
