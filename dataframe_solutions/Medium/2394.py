from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    e_df = spark.read_table_as_df("employees_2394")
    e_df.show()

    l_df = spark.read_table_as_df("logs_2394")
    l_df.show()

    result_df = e_df \
                .join(l_df, on='employee_id', how='left') \
                .groupby('employee_id', 'needed_hours') \
                .agg((F.sum(F.ceiling(F.ifnull(F.col('out_time').cast('long')
                                            - F.col('in_time').cast('long'), F.lit(0))/60))/60).alias('total_hours')) \
                .filter(F.col('total_hours') < F.col('needed_hours')) \
                .select('employee_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
