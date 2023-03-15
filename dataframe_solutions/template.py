# question-link
from dependencies import spark_db_ops

so = spark_db_ops.SparkDbOps()

# pyspark code

df = so.read_query_as_df("SELECT * FROM table")
df.show()

so.stop()
