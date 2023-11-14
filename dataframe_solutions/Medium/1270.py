from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    e_df = spark.read_table_as_df("employees_1270")
    e_df.show()

    result_df = e_df.alias('e1') \
                .join(e_df.alias('e2'), on=F.col('e1.manager_id') == F.col('e2.employee_id')) \
                .join(e_df.alias('e3'), on=F.col('e2.manager_id') == F.col('e3.employee_id')) \
                .filter(((F.col('e1.manager_id') == 1) | (F.col('e2.manager_id') == 1) | (F.col('e3.manager_id') == 1)) &
                        (F.col('e1.employee_id') != 1)) \
                .select('e1.employee_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
