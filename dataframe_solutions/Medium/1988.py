from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    s_df = spark.read_table_as_df("school_1988")
    s_df.show()

    e_df = spark.read_table_as_df("exam_1988")
    e_df.show()

    result_df = s_df \
                .join(e_df, on=F.col('capacity') > F.col('student_count'), how='left') \
                .groupby('school_id').agg(F.ifnull(F.min('score'), F.lit(-1)).alias('score'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
