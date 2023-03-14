from pyspark.sql.functions import col
from spark_db_ops import SparkDbOps

so = SparkDbOps()

person_df = so.read_query_as_df("SELECT * FROM person_175")
address_df = so.read_query_as_df("SELECT * FROM address_175")

result_df = person_df\
    .join(address_df, on='personid')\
    .select(col("firstname").alias("FirstName"), col("lastname").alias("LastName"), col("city").alias("City"),
            col("state").alias("State"))

result_df.show()

so.stop()
