from dependencies import spark_pg_utils


def solution_1(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/570.%20Managers%20with%20at%20Least%205%20Direct%20Reports.html

    # pyspark code

    from pyspark.sql.functions import col, count

    emp_df = spark_pg.read_table_as_df("employee_570")
    emp_df.show()

    result_df = emp_df.alias('emp')\
        .join(emp_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'))\
        .groupby([col('emp.manager_id'), col('mgr.name')]).agg(count('emp.id').alias('reports'))\
        .filter(col('reports') >= 5)\
        .select(col('mgr.name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
