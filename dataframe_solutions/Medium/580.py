from dependencies import spark_pg_utils


def main(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/580.%20Count%20Student%20Number%20in%20Departments.html

    # pyspark code

    from pyspark.sql.functions import count

    stud_df = spark_pg.read_table_as_df("student_580")
    stud_df.show()

    dep_df = spark_pg.read_table_as_df("department_580")
    dep_df.show()

    result_df = dep_df\
        .join(stud_df, on='dept_id', how='left')\
        .groupby('dept_name')\
        .agg(count('student_id')).alias('student_number')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(main)
