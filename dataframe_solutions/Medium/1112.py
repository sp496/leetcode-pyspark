from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    enrol_df = spark.read_table_as_df("enrollments_1112")
    enrol_df.show()

    wspec = W.partitionBy('student_id').orderBy(F.desc('grade'), F.asc('course_id'))

    result_df = enrol_df \
        .withColumn('rank', F.rank().over(wspec)) \
        .filter(F.col('rank') == 1) \
        .select('student_id', 'course_id', 'grade')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
