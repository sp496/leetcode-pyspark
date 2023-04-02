from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    employee_df = spark.read_table_as_df("employee_181")
    result_df = employee_df.alias('emp') \
        .join(employee_df.alias('mgr'), on=F.col('emp.manager_id') == F.col('mgr.id'), how='inner') \
        .where(F.col('emp.salary') > F.col('mgr.salary')) \
        .select(F.col('emp.name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
