from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/578.%20Get%20Highest%20Answer%20Rate%20Question.html

    # pyspark code

    from pyspark.sql.functions import col, count, when

    df = spark.read_table_as_df("surveylog_578")
    df.show()

    result_df = df \
        .groupby('question_id') \
        .agg((count(when(col('action') == 'answer', True)) /
              count(when(col('action') == 'show', True))).alias('answer_rate')) \
        .orderBy('question_id') \
        .limit(1) \
        .select('question_id').alias('survey_log')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
