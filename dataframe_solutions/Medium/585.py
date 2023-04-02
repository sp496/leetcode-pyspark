from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    inv_df = spark.read_table_as_df("insurance_585")
    inv_df.show()

    result_df = inv_df.alias('i1') \
        .join(inv_df.alias('i2'), on=(F.col('i1.lat') == F.col('i2.lat')) &
                                     (F.col('i1.lon') == F.col('i2.lon')) &
                                     (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')) &
                                     (F.col('i1.pid') != F.col('i2.pid')),
              how='left_anti') \
        .agg(F.sum(F.col('tiv_2016')).alias('tiv_2016'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
