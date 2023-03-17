# https://www.jiakaobo.com/leetcode/182.%20Duplicate%20Emails.html
from dependencies import spark_db_ops

so = spark_db_ops.SparkDbOps()

# pyspark code

from pyspark.sql.functions import col

person_df = so.read_query_as_df("SELECT * FROM person_182")
result_df = person_df\
    .groupBy('email').count()\
    .filter(col('count') > 1)\
    .select(col('email'))

result_df.show()

so.stop()
