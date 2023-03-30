from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/1112.%20Highest%20Grade%20For%20Each%20Student.html

    # pyspark code

    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    w = Window.partitionBy('student_id').orderBy(F.desc('grade'), F.asc('course_id'))

    enrol_df = spark.read_table_as_df("enrollments_1112")
    enrol_df.show()

    result_df = enrol_df \
        .withColumn('rank', F.rank().over(w)) \
        .filter(F.col('rank') == 1) \

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
