from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    a_df = spark.read_table_as_df("accounts_1907")
    a_df.show()

    c_df = spark.spark.createDataFrame([("Low Salary",), ("Average Salary",), ("High Salary",)], ["category"])

    c_df.show()

    result_df = a_df \
                .withColumn('category', F.when(F.col('income') > 50000, 'High Salary') \
                                        .when(F.col('income') >= 20000, 'Average Salary') \
                                        .otherwise('Low Salary')) \
                .join(c_df, on='category', how='right') \
                .groupby('category').agg(F.count('account_id').alias('accounts_count'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
