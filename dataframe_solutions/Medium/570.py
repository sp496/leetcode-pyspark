from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/570.%20Managers%20with%20at%20Least%205%20Direct%20Reports.html

    # pyspark code

    import pyspark.sql.functions as F

    emp_df = spark.read_table_as_df("employee_570")
    emp_df.show()

    result_df = emp_df.alias('emp') \
        .join(emp_df.alias('mgr'), on=F.col('emp.manager_id') == F.col('mgr.id')) \
        .groupby([F.col('emp.manager_id'), F.col('mgr.name')]).agg(F.count('emp.id').alias('reports')) \
        .filter(F.col('reports') >= 5) \
        .select(F.col('mgr.name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
