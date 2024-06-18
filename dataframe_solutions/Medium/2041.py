from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    c_df = spark.read_table_as_df("candidates_2041")
    c_df.show()

    r_df = spark.read_table_as_df("rounds_2041")
    r_df.show()

    result_df = c_df \
                .filter(F.col('years_of_exp') >= 2) \
                .join(r_df, on='interview_id') \
                .groupby('candidate_id').agg(F.sum('score').alias('total_score')) \
                .filter(F.col('total_score') > 15) \
                .select('candidate_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
