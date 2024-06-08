from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F, Window as W

    w_spec = W.partitionBy('company_id')

    s_df = spark.read_table_as_df("salaries_1468")
    s_df.show()

    result_df = s_df \
        .withColumn('salary', F.when(F.max('salary').over(w_spec) < 1000, F.col('salary'))
                                .when((F.max('salary').over(w_spec) >= 1000) & (F.max('salary').over(w_spec) <= 10000),
                                      F.round(F.col('salary') - F.col('salary')*0.24, 0))
                                .when(F.max('salary').over(w_spec) > 10000,
                                      F.round(F.col('salary') - F.col('salary')*0.49, 0)))

    result_df.show()


def solution_2(spark):

    from pyspark.sql import functions as F, Window as W

    w_spec = W.partitionBy('company_id')

    s_df = spark.read_table_as_df("salaries_1468")
    s_df.show()

    result_df = s_df.withColumn('max_salary', F.max('salary').over(w_spec)) \
        .withColumn('salary', F.when(F.col('max_salary') < 1000, F.col('salary'))
                                .when((F.col('max_salary') >= 1000) & (F.col('max_salary') <= 10000),
                                      F.round(F.col('salary') - F.col('salary')*0.24, 0))
                                .when(F.col('max_salary') > 10000,
                                      F.round(F.col('salary') - F.col('salary')*0.49, 0))) \
        .select('company_id', 'employee_id', 'employee_name', 'salary')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_2)
