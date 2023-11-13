from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    t_df = spark.read_table_as_df("teams_1212")
    t_df.show()
    m_df = spark.read_table_as_df("matches_1212")
    m_df.show()

    result_df = m_df.alias('m') \
                .join(t_df.alias('t'), on=(F.col('m.host_team')==F.col('t.team_id')) |
                                          (F.col('m.guest_team')==F.col('t.team_id')), how='left') \
                .groupby('team_id', 'team_name') \
                .agg(F.sum(F.when((F.col('team_id') == F.col('host_team')) &
                                  (F.col('host_goals') > F.col('guest_goals')), 3)
                            .when((F.col('team_id') == F.col('guest_team')) &
                                  (F.col('guest_goals') > F.col('host_goals')), 3)
                            .when((F.col('team_id') == F.col('host_team'))
                                  & (F.col('host_goals') == F.col('guest_goals')), 1)
                            .when((F.col('team_id') == F.col('guest_team'))
                                  & (F.col('guest_goals') == F.col('host_goals')), 1)
                            .otherwise(0)).alias('num_points')) \

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
