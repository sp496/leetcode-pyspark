from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    b_df = spark.read_table_as_df("buses_2142")
    b_df.show()

    p_df = spark.read_table_as_df("passengers_2142")
    p_df.show()

    first_bus_df = p_df.alias('p') \
                .join(b_df.alias('b'), on=F.col('p.arrival_time') <= F.col('b.arrival_time')) \
                .groupby('passenger_id').agg(F.min('b.arrival_time').alias('arrival_time'))

    result_df = b_df.join(first_bus_df, on='arrival_time', how='left') \
                .groupby('bus_id').agg(F.count('passenger_id').alias('passengers_cnt'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
