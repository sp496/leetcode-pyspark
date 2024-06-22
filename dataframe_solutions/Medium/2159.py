from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    d_df = spark.read_table_as_df("data_2159")
    d_df.show()

    d1_df = d_df \
            .select('first_col') \
            .withColumn('order', F.row_number().over(W.orderBy('first_col')))

    d2_df = d_df \
            .select('second_col') \
            .withColumn('order', F.row_number().over(W.orderBy(F.desc('second_col'))))

    result_df = d1_df \
                .join(d2_df, on='order') \
                .select('first_col', 'second_col')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
