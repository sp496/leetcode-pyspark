from dependencies import spark_pg_utils


def solution_1(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code

    from pyspark.sql.functions import col, when

    tree_df = spark_pg.read_table_as_df("tree_608")
    tree_df.show()

    # result_df = tree_df.select(col("id").isin(tree_df["p_id"]).alias("match"))
    result_df = tree_df.alias('t1') \
        .join(tree_df.alias('t2'), on=col('t1.id') == col('t2.p_id'), how='left')\
        .withColumn('type', when(col('t1.p_id').isNull(), 'Root')
                    .otherwise(when(col('t2.p_id').isNull(), 'Leaf').otherwise('Inner')))\
        .select([col('t1.id'), col('type')])\
        .dropDuplicates()\
        .orderBy('id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
