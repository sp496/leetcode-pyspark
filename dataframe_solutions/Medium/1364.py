from dependencies import spark_pg_utils


def solution_1(spark):

    from pyspark.sql import functions as F

    c_df = spark.read_table_as_df("customers_1364")
    c_df.show()

    co_df = spark.read_table_as_df("contacts_1364")
    co_df.show()

    i_df = spark.read_table_as_df("invoices_1364")
    i_df.show()

    result_df = df

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
