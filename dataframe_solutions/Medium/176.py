from dependencies import spark_pg_utils


def solution_1(spark):
    # Question link
    # https://www.jiakaobo.com/leetcode/176.%20Second%20Highest%20Salary.html

    # pyspark code
    from pyspark.sql.window import Window
    from pyspark.sql.functions import col, dense_rank, desc

    window_spec = Window.orderBy(desc("salary"))
    employee_df = spark.read_table_as_df("employee_181")
    employee_df.show()

    result_df = employee_df\
        .withColumn('dense_rank', dense_rank().over(window_spec))\
        .where(col('dense_rank') == 2)\
        .select(col('salary').alias('SecondHighestSalary'))
    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
