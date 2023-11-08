from dependencies import spark_pg_utils


def solution_1(spark):
    import pyspark.sql.functions as F

    tree_df = spark.read_table_as_df("tree_608")
    tree_df.show()

    result_df = tree_df.alias('t1') \
        .join(tree_df.alias('t2'), on=F.col('t1.id') == F.col('t2.p_id'), how='left') \
        .withColumn('type', F.when(F.col('t1.p_id').isNull(), 'Root')
                            .when(F.col('t2.p_id').isNull(), 'Leaf')
                            .otherwise('Inner')) \
        .select([F.col('t1.id'), F.col('type')]) \
        .dropDuplicates() \
        .orderBy('id')

    result_df.show()


def solution_2(spark):
    from pyspark.sql import functions as F, Window as W

    tree_df = spark.read_table_as_df("tree_608")
    tree_df.show()

    wspec = W.partitionBy('id').rowsBetween(W.unboundedPreceding, W.unboundedFollowing)

    result_df = tree_df \
        .withColumn('Type', F.count('p_id').over(wspec))
        # .withColumn('Type',F.when(F.col('p_id').isNull(), 'Root')
        #                          .when(F.count('p_id').over(wspec) > 0, 'Inner')
        #                          .otherwise('Leaf'))

    # result_df = tree_df.select('id', 'Type').distinct().orderBy('id')

    result_df.show()



if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
