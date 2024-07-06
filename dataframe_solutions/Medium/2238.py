from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    r_df = spark.read_table_as_df("rides_2238")
    r_df.show()

    result_df = r_df.alias('r1') \
                .join(r_df.alias('r2'), on=F.col('r1.driver_id')==F.col('r2.passenger_id'), how='left') \
                .groupby('r1.driver_id').agg(F.countDistinct('r2.ride_id').alias('cnt'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
