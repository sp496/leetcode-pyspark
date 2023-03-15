#question-link
from pyspark.sql.functions import col
from spark_db_ops import SparkDbOps

so = SparkDbOps()

#pyspark code
df = so.read_query_as_df("SELECT * FROM table")
df.show()

so.stop()
