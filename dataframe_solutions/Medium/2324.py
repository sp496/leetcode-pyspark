from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    p_df = spark.read_table_as_df("product_2324")
    p_df.show()

    s_df = spark.read_table_as_df("sales_2324")
    s_df.show()

    w_spec = W.partitionBy('user_id').orderBy(F.desc('spent'))

    result_df = s_df \
                .join(p_df, on='product_id') \
                .withColumn('spent', F.col('quantity') * F.col('price')) \
                .groupby('user_id', 'product_id').agg(F.sum('spent').alias('spent')) \
                .withColumn('rnk', F.rank().over(w_spec)) \
                .filter(F.col('rnk') == 1) \
                .select('user_id', 'product_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
