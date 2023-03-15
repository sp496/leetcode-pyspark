#https://www.jiakaobo.com/leetcode/181.%20Employees%20Earning%20More%20Than%20Their%20Managers.html
from pyspark.sql.functions import col
from dependencies import spark_db_ops

so = spark_db_ops.SparkDbOps()

employee_df = so.read_query_as_df("SELECT * FROM employee_181")
result_df = employee_df.alias('emp')\
                .join(employee_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'), how='inner')\
                .where(col('emp.salary') > col('mgr.salary'))\
                .select(col('emp.name'))

result_df.show()

so.stop()
