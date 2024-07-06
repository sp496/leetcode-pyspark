from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("team_points_2175")
    t_df.show()

    p_df = spark.read_table_as_df("points_change_2175")
    p_df.show()

    a_df = t_df \
            .join(p_df, on='team_id') \
            .withColumn('rank_diff', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name'))) -
                                    F.row_number().over(W.orderBy(F.desc(F.col('points') + F.col('points_change')),
                                                                  F.asc('name')))) \
            .select('team_id', 'name', 'rank_diff')

    a_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    t_df = spark.read_table_as_df("team_points_2175")
    t_df.show()

    p_df = spark.read_table_as_df("points_change_2175")
    p_df.show()

    a_df = t_df \
            .withColumn('rank1', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name')))) \
            .join(p_df, on='team_id') \
            .withColumn('points', F.col('points') + F.col('points_change')) \
            .withColumn('rank2', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name')))) \
            .withColumn('rank_diff', F.col('rank2') - F.col('rank1')) \
            .select('team_id', 'name', 'rank_diff')

    a_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
