from pyspark.sql.functions import col
from spark_db_ops import SparkDbOps

so = SparkDbOps()

employee_df = so.read_query_as_df("SELECT * FROM employee_181")
result_df = employee_df.alias('emp')\
                .join(employee_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'), how='inner')\
                .where(col('emp.salary') > col('mgr.salary'))\
                .select(col('emp.name'))

result_df.show()

so.stop()
