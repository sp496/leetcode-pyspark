from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    p_df = spark.read_table_as_df("person_1501")
    p_df.show()

    ct_df = spark.read_table_as_df("country_1501")
    ct_df.show()

    c_df = spark.read_table_as_df("calls_1501")
    c_df.show()

    global_avg_duration = c_df.agg(F.avg("duration").alias("global_avg")).collect()[0]["global_avg"]

    print(global_avg_duration)
    result_df = c_df.select(F.col('caller_id').alias('caller'), 'duration') \
                .unionAll(c_df.select(F.col('callee_id').alias('caller'), 'duration')) \
                .join(p_df, on=F.col('caller') == F.col('id')) \
                .join(ct_df.alias('ct'), on=F.substring(F.col('phone_number'),1, 3)==F.col('country_code')) \
                .groupby('ct.name').agg(F.avg('duration').alias('avg')) \
                .filter(F.col('avg') > global_avg_duration) \
                .select(F.col('name').alias('country'))

    result_df.show()




if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
