from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/580.%20Count%20Student%20Number%20in%20Departments.html

    # pyspark code

    import pyspark.sql.functions as F

    stud_df = spark.read_table_as_df("student_580")
    stud_df.show()

    dep_df = spark.read_table_as_df("department_580")
    dep_df.show()

    result_df = dep_df\
        .join(stud_df, on='dept_id', how='left')\
        .groupby('dept_name')\
        .agg(F.count('student_id').alias('student_number'))\
        .orderBy(F.desc('student_number'))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
