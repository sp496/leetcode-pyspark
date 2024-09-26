from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    s_df = spark.read_table_as_df("students_2346")
    s_df.show()

    w_spec1 = W.partitionBy('department_id').orderBy(F.desc('mark'))
    w_spec2 = W.partitionBy('department_id')

    result_df = s_df \
                .withColumn('rnk', F.dense_rank().over(w_spec1)) \
                .withColumn('student_count', F.count('*').over(w_spec2)) \
                .withColumn('percentage', ((F.col('rnk') - 1) * 100)/(F.col('student_count') - 1)) \
                .select('student_id', 'department_id', 'percentage')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
