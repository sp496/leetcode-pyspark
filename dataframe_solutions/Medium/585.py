from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code

    from pyspark.sql.functions import col, sum

    inv_df = spark.read_table_as_df("insurance_585")
    inv_df.show()

    result_df = inv_df.alias('i1') \
        .join(inv_df.alias('i2'), on=(col('i1.lat') == col('i2.lat')) &
                                     (col('i1.lon') == col('i2.lon')) &
                                     (col('i1.tiv_2015') != col('i2.tiv_2015')) &
                                     (col('i1.pid') != col('i2.pid')),
              how='left_anti') \
        .agg(sum(col('tiv_2016')).alias('tiv_2016'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
