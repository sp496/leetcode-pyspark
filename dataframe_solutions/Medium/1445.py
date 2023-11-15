from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    s_df = spark.read_table_as_df("sales_1445")
    s_df.show()

    result_df = s_df

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
