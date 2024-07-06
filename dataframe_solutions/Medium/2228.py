from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    p_df = spark.read_table_as_df("purchases_2228")
    p_df.show()

    w_spec = W.partitionBy('user_id').orderBy('purchase_date')

    result_df = p_df \
                .withColumn('days_since_last_purchase', (F.col('purchase_date') - F.lag('purchase_date').over(w_spec))
                                                        .cast('int')) \
                .filter(F.col('days_since_last_purchase') <= 7) \
                .select('user_id').distinct()

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
