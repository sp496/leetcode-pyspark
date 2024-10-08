from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    req_df = spark.read_table_as_df("request_accepted_602")
    req_df.show()

    #can use unionAll too
    result_df = req_df.select([F.col('requester_id').alias('id'), F.col('accepter_id').alias('friend_id')]) \
        .union(req_df.select([F.col('accepter_id').alias('id'), F.col('requester_id').alias('friend_id')])) \
        .groupby('id').agg(F.count('friend_id').alias('num')) \
        .orderBy(F.desc('num')) \
        .limit(1)

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    req_df = spark.read_table_as_df("request_accepted_602")
    req_df.show()

    w_spec = W.orderBy(F.desc('num'))

    result_df = req_df.select([F.col('requester_id').alias('id'), F.col('accepter_id').alias('friend_id')]) \
        .union(req_df.select([F.col('accepter_id').alias('id'), F.col('requester_id').alias('friend_id')])) \
        .groupby('id').agg(F.count('friend_id').alias('num')) \
        .withColumn('rnk', F.rank().over(w_spec)) \
        .filter(F.col('rnk') == 1) \
        .select('id', 'num')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_2)
