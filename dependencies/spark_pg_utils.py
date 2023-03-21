import os
from configparser import ConfigParser
from dependencies import spark_pg_ops


def execute(pyspark_code, config_file='config.ini'):
    dependencies_dir = os.path.dirname(os.path.abspath(__file__))
    config_file_path = os.path.join(dependencies_dir, '..', 'config', config_file)
    config = ConfigParser()
    config.read(config_file_path)

    spark_session = spark_pg_ops.SparkPgOps(config)
    pyspark_code(spark_session)
    spark_session.stop()
