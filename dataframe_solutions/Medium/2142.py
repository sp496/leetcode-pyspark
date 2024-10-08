from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    b_df = spark.read_table_as_df("buses_2142")
    b_df.show()

    p_df = spark.read_table_as_df("passengers_2142")
    p_df.show()

    w_spec = W.partitionBy('passenger_id').orderBy('b.arrival_time')

    result_df = p_df.alias('p') \
                .join(b_df.alias('b'), on=F.col('p.arrival_time') <= F.col('b.arrival_time')) \
                .withColumn('rnk', F.rank().over(w_spec)) \
                .filter(F.col('rnk') == 1) \
                .join(b_df, on='bus_id', how='right') \
                .groupby('bus_id').agg(F.count('passenger_id').alias('passengers_cnt')) \
                .orderBy('bus_id')

    result_df.show()



def solution_2(spark):

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
