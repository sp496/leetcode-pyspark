from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    f_df = spark.read_table_as_df("flights_2112")
    f_df.show()

    w_spec = W.orderBy(F.desc('total_flights_count'))

    result_df = f_df \
                .select(F.col('departure_airport').alias('airport_id'), 'flights_count') \
                .unionAll(f_df.select(F.col('departure_airport').alias('airport_id'), 'flights_count')) \
                .groupby('airport_id').agg(F.sum(F.col('flights_count')).alias('total_flights_count')) \
                .withColumn('rank', F.rank().over(w_spec)) \
                .filter(F.col('rank') == 1) \
                .select('airport_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
