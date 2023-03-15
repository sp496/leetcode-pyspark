import os
from pyspark.sql import SparkSession
from configparser import ConfigParser


class SparkDbOps:

    def __init__(self, config_file='config.ini'):
        script_dir = os.path.dirname(os.path.abspath(__file__))
        self.config_path = os.path.join(script_dir, '..', 'config', config_file)
        config = ConfigParser()
        config.read(self.config_path)
        self.database_name = config.get('database', 'name')
        self.user = config.get('database', 'username')
        self.password = config.get('database', 'password')
        self.host = config.get('database', 'host')
        self.port = config.get('database', 'port')
        self.app_name = config.get("SparkConf", "app_name")
        self.jar_file_path = config.get("SparkConf", "jar_file_path")
        self.url = f"jdbc:postgresql://{self.host}:{self.port}/{self.database_name}?user={self.user}" \
                   f"&password={self.password}"
        self.spark = None

    def build_spark_session(self):
        if self.spark is None:
            self.spark = SparkSession.builder\
                .appName(self.app_name)\
                .config("spark.driver.extraClassPath", self.jar_file_path)\
                .getOrCreate()

    def get_spark_session(self):
        if self.spark is None:
            self.spark = SparkSession.builder\
                .appName(self.app_name)\
                .config("spark.driver.extraClassPath", self.jar_file_path)\
                .getOrCreate()
        return self.spark

    def read_query_as_df(self, query):
        self.build_spark_session()
        df = self.spark.read \
            .format("jdbc") \
            .option("url", self.url) \
            .option("query", query) \
            .option("driver", "org.postgresql.Driver") \
            .load()
        return df

    def get_table_as_df(self, table_name):
        database_url = f"postgresql://{self.host}:{self.port}/{self.database_name}"
        df = self.spark.read \
            .format("jdbc") \
            .option("url", f"jdbc:{database_url}") \
            .option("dbtable", table_name) \
            .option("user", self.user) \
            .option("password", self.password) \
            .load()
        return df

    def stop(self):
        if self.spark is not None:
            self.spark.stop()
