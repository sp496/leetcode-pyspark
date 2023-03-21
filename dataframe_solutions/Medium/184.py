from dependencies import spark_pg_utils


def main(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode/184.%20Department%20Highest%20Salary.html

    # pyspark code

    from pyspark.sql.functions import col, desc, rank
    from pyspark.sql.window import Window

    emp_df = spark_pg.read_table_as_df("employee_184")
    emp_df.show()

    dep_df = spark_pg.read_table_as_df("department_184")
    dep_df.show()

    w = Window.partitionBy(col('dep.id')).orderBy(desc(col('emp.salary')))

    result_df = \
        emp_df.alias('emp') \
        .join(dep_df.alias('dep'), on=col('emp.department_id') == col('dep.id'), how='inner')\
        .withColumn('rank', rank().over(w))\
        .where(col('rank') == 1)\
        .select([col('dep.name').alias('Department'), col('emp.name').alias('Employee'), 'salary'])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(main)
