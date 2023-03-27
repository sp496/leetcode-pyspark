from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/578.%20Get%20Highest%20Answer%20Rate%20Question.html

    # pyspark code

    import pyspark.sql.functions as F

    df = spark.read_table_as_df("surveylog_578")
    df.show()

    result_df = df \
        .groupby('question_id') \
        .agg((F.count(F.when(F.col('action') == 'answer', True)) /
              F.count(F.when(F.col('action') == 'show', True))).alias('answer_rate')) \
        .orderBy('question_id') \
        .limit(1) \
        .select('question_id').alias('survey_log')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
