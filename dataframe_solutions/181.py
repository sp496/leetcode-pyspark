# https://www.jiakaobo.com/leetcode/181.%20Employees%20Earning%20More%20Than%20Their%20Managers.html

def main(spark):
    from pyspark.sql.functions import col

    employee_df = spark.read_table_as_df("employee_181")
    result_df = employee_df.alias('emp') \
        .join(employee_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'), how='inner') \
        .where(col('emp.salary') > col('mgr.salary')) \
        .select(col('emp.name'))

    result_df.show()


if __name__ == '__main__':
    from dependencies import spark_db_ops

    spark_session = spark_db_ops.SparkDbOps()
    main(spark_session)
    spark_session.stop()
