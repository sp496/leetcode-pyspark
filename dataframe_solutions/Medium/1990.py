from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    e_df = spark.read_table_as_df("experiments_1990")
    e_df.show()

    cross_df = e_df.select('platform').distinct().crossJoin(e_df.select('experiment_name').distinct())

    result_df = cross_df.alias('c') \
                .join(e_df.alias('e'), on=(F.col('c.platform') == F.col('e.platform'))
                                            & (F.col('c.experiment_name') == F.col('e.experiment_name')), how='left') \
                .groupby(F.col('c.platform'), F.col('c.experiment_name')) \
                 .agg(F.count('e.experiment_name').alias('num_experiments')) \
                .orderBy('platform')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
