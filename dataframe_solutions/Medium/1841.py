from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    t_df = spark.read_table_as_df("teams_1841")
    t_df.show()

    m_df = spark.read_table_as_df("matches_1841")
    m_df.show()

    is_home_team = (F.col('team_id') == F.col('home_team_id'))
    is_away_team = (F.col('team_id') == F.col('away_team_id'))

    win = ((is_home_team & (F.col('home_team_goals') > F.col('away_team_goals')))
            | (is_away_team & (F.col('away_team_goals') > F.col('home_team_goals'))))
    draw = (F.col('home_team_goals') == F.col('away_team_goals'))



    result_df = t_df \
                .join(m_df, on=(F.col('team_id') == F.col('home_team_id'))
                                | (F.col('team_id') == F.col('away_team_id'))) \
                .groupby('team_name') \
                .agg(F.count('*').alias('matches_played'),
                     F.sum(F.when(win, 3).when(draw, 1).otherwise(0)).alias('points'),
                     F.sum((F.when(is_home_team, F.col('home_team_goals'))
                            .when(is_away_team, F.col('away_team_goals')))).alias('goal_for'),
                     F.sum((F.when(is_home_team, F.col('away_team_goals'))
                            .when(is_away_team, F.col('home_team_goals')))).alias('goal_against'),
                     ) \
                .withColumn('goal_diff', F.col('goal_for') - F.col('goal_against')) \
                .orderBy(F.desc('goal_diff'))


    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
