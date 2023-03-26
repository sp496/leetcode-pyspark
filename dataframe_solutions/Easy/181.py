from dependencies import spark_pg_utils


def solution_1(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/181.%20Employees%20Earning%20More%20Than%20Their%20Managers.html

    # pyspark code
    from pyspark.sql.functions import col

    employee_df = spark_pg.read_table_as_df("employee_181")
    result_df = employee_df.alias('emp') \
        .join(employee_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'), how='inner') \
        .where(col('emp.salary') > col('mgr.salary')) \
        .select(col('emp.name'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
