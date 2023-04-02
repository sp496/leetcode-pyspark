from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/608.%20Tree%20Node.html

    # pyspark code

    import pyspark.sql.functions as F

    tree_df = spark.read_table_as_df("tree_608")
    tree_df.show()

    result_df = tree_df.alias('t1') \
        .join(tree_df.alias('t2'), on=F.col('t1.id') == F.col('t2.p_id'), how='left')\
        .withColumn('type', F.when(F.col('t1.p_id').isNull(), 'Root')
                    .otherwise(F.when(F.col('t2.p_id').isNull(), 'Leaf').otherwise('Inner')))\
        .select([F.col('t1.id'), F.col('type')])\
        .dropDuplicates()\
        .orderBy('id')

    result_df.show()


def solution_2(spark):

    import pyspark.sql.functions as F

    tree_df = spark.read_table_as_df("tree_608")
    tree_df.show()

    # result_df = tree_df.select(F.col("id").isin(tree_df["p_id"]).alias("match"))
    result_df = tree_df.alias('t1') \
        .join(tree_df.alias('t2'), on=F.col('t1.id') == F.col('t2.p_id'), how='left')\
        # .withColumn('type', F.when(F.col('t1.p_id').isNull(), 'Root')
        #             .otherwise(F.when(F.col('t2.p_id').isNull(), 'Leaf').otherwise('Inner')))\
        # .select([F.col('t1.id'), F.col('type')])\
        # .dropDuplicates()\
        # .orderBy('id')

    result_df.show()



if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
