from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    e_df = spark.read_table_as_df("expressions_1440")
    e_df.show()

    result_df = e_df \
        .withColumn('value', F.when(F.col('operator') == '>', F.col('left_operand') > F.col('right_operand'))
                            .when(F.col('operator') == '<', F.col('left_operand') < F.col('right_operand'))
                            .when(F.col('operator') == '=', F.col('left_operand') == F.col('right_operand')))

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
