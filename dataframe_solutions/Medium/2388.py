from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    c_df = spark.read_table_as_df("coffee_shop_2388")
    c_df.show()

    result_df = c_df \
                .withColumn('row_num', F.row_number().over(W.orderBy(F.lit('A')))) \
                .withColumn('group_id', F.sum(F.when(F.col('drink').isNotNull(),1)).over(W.orderBy(F.col('row_num')))) \
                .withColumn('drink', F.first('drink').over(W.partitionBy('group_id').orderBy(F.col('row_num')))) \
                .select('id', 'drink')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
