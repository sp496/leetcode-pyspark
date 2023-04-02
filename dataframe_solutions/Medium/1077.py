from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    project_df = spark.read_table_as_df("project_1077")
    project_df.show()

    emp_df = spark.read_table_as_df("employee_1077")
    emp_df.show()

    w = Window.partitionBy('project_id').orderBy(F.desc('experience_years'))

    result_df = project_df \
        .join(emp_df, on='employee_id', how='inner') \
        .withColumn('exp_rank', F.rank().over(w)) \
        .filter(F.col('exp_rank') == 1) \
        .select(['project_id', 'employee_id'])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
