from dependencies import spark_pg_ops


def execute(pyspark_code):
    spark_session = spark_pg_ops.SparkDbOps()
    pyspark_code(spark_session)
    spark_session.stop()



