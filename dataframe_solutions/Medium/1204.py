from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    q_df = spark.read_table_as_df("queue_1204")
    q_df.show()

    wspec = W.orderBy('Turn').rowsBetween(W.unboundedPreceding, W.currentRow)

    result_df = q_df \
            .withColumn('Total Weight', F.sum('weight').over(wspec)) \
            .filter(F.col('Total Weight') <= 1000) \
            .orderBy(F.desc('turn')) \
            .limit(1) \
            .select('person_name')

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    q_df = spark.read_table_as_df("queue_1204")
    q_df.show()

    result_df = q_df.alias('q1') \
            .join(q_df.alias('q2'), on=F.col('q2.turn') <= F.col('q1.turn')) \
            .groupby('q1.turn', 'q1.person_name').agg(F.sum('q2.weight').alias('Total Weight')) \
            .filter(F.col('Total Weight') <= 1000) \
            .orderBy(F.desc('q1.turn')) \
            .limit(1) \
            .select('person_name')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
