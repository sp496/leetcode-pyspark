from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    emp_df = spark.read_table_as_df("employee_184")
    emp_df.show()

    dep_df = spark.read_table_as_df("department_184")
    dep_df.show()

    wspec = W.partitionBy('dep.id').orderBy(F.desc('emp.salary')).rowsBetween(W.unboundedPreceding, W.currentRow)

    result_df = emp_df.alias('emp') \
        .join(dep_df.alias('dep'), on=F.col('emp.department_id') == F.col('dep.id'), how='inner') \
        .withColumn('rank', F.rank().over(wspec)) \
        .where(F.col('rank') == 1) \
        .select([F.col('dep.name').alias('Department'), F.col('emp.name').alias('Employee'), 'salary'])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
