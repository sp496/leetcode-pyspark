from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    e_df = spark.read_table_as_df("employees_1875")
    e_df.show()

    w_spec = W.orderBy('salary')

    result_df = e_df.alias('e1') \
                .join(e_df.alias('e2'), on=(F.col('e1.salary') == F.col('e2.salary'))
                                            & (F.col('e1.employee_id') != F.col('e2.employee_id')), how='semi') \
                .withColumn('team_id', F.dense_rank().over(w_spec)) \
                .orderBy('team_id', 'employee_id')


    result_df.show()

def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    e_df = spark.read_table_as_df("employees_1875")
    e_df.show()

    e_agg_df = e_df \
            .groupby('salary').agg(F.count('*').alias('salary_count')) \
            .filter(F.count('*') > 1)

    e_agg_df.show()

    w_spec = W.orderBy('salary')

    result_df = e_df \
                .join(e_agg_df, on='salary', how='semi') \
                .withColumn('team_id', F.dense_rank().over(w_spec)) \
                .select('employee_id', 'name', 'salary', 'team_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
