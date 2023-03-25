from pyspark.sql import SparkSession


class SparkPgOps:

    def __init__(self, config):
        self.database_name = config.get('database', 'name')
        self.user = config.get('database', 'username')
        self.password = config.get('database', 'password')
        self.host = config.get('database', 'host')
        self.port = config.get('database', 'port')
        self.app_name = config.get("SparkConf", "app_name")
        self.jar_file_path = config.get("SparkConf", "jar_file_path")
        self.spark = SparkSession.builder \
            .appName(self.app_name) \
            .config("spark.driver.extraClassPath", self.jar_file_path) \
            .getOrCreate()

    def build_spark_session(self):
        if self.spark is None:
            self.spark = SparkSession.builder \
                .appName(self.app_name) \
                .config("spark.driver.extraClassPath", self.jar_file_path) \
                .getOrCreate()

    def get_spark_session(self):
        if self.spark is None:
            self.spark = SparkSession.builder \
                .appName(self.app_name) \
                .config("spark.driver.extraClassPath", self.jar_file_path) \
                .getOrCreate()
        return self.spark

    def read_query_as_df(self, query):
        database_url = f"postgresql://{self.host}:{self.port}/{self.database_name}"
        self.build_spark_session()
        df = self.spark.read \
            .format("jdbc") \
            .option("driver", "org.postgresql.Driver") \
            .option("url", f"jdbc:{database_url}") \
            .option("user", self.user) \
            .option("password", self.password) \
            .option("query", query) \
            .load()
        return df

    def read_table_as_df(self, table):
        database_url = f"postgresql://{self.host}:{self.port}/{self.database_name}"
        self.build_spark_session()
        df = self.spark.read \
            .format("jdbc") \
            .option("driver", "org.postgresql.Driver") \
            .option("url", f"jdbc:{database_url}") \
            .option("user", self.user) \
            .option("password", self.password) \
            .option("dbtable", table) \
            .load()
        return df

    def stop(self):
        if self.spark is not None:
            self.spark.stop()
