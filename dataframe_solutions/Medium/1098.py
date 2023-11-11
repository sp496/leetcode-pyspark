from dependencies import spark_pg_utils


def solution_1(spark):

    import pyspark.sql.functions as F

    books_df = spark.read_table_as_df("books_1098")
    books_df.show()

    orders_df = spark.read_table_as_df("orders_1098")
    orders_df.show()

    in_the_past_year = (F.col('o.dispatch_date') > F.date_sub(F.to_date(F.lit('2019-06-23')), 365))

    result_df = books_df.alias('b') \
        .join(orders_df.alias('o'),
              on=(F.col('o.book_id') == F.col('b.book_id')) & in_the_past_year,
              how='left') \
        .filter((F.col('b.available_from') < F.date_sub(F.to_date(F.lit('2019-06-23')), 30))) \
        .groupby([F.col('b.book_id'), 'name']).agg(F.sum('quantity')) \
        .select(['book_id', 'name'])

    result_df.show()


def solution_2(spark):

    import pyspark.sql.functions as F

    books_df = spark.read_table_as_df("books_1098")
    books_df.show()

    orders_df = spark.read_table_as_df("orders_1098")
    orders_df.show()

    books_df = books_df.filter((F.col('available_from') < F.date_sub(F.to_date(F.lit('2019-06-23')), 30)))

    in_the_past_year = (F.col('o.dispatch_date') > F.date_sub(F.to_date(F.lit('2019-06-23')), 365))

    result_df = books_df.alias('b') \
        .join(orders_df.alias('o'),
              on=(F.col('o.book_id') == F.col('b.book_id')) & in_the_past_year,
              how='left') \
        .groupby([F.col('b.book_id'), 'name']).agg(F.sum('quantity')) \
        .select(['book_id', 'name'])

    result_df.show()


def solution_3(spark):
    import pyspark.sql.functions as F

    books_df = spark.read_table_as_df("books_1098")
    books_df.show()

    orders_df = spark.read_table_as_df("orders_1098")
    orders_df.show()

    result_df = orders_df \
        .filter(F.col('dispatch_date') > F.date_sub(F.to_date(F.lit('2019-06-23')), 365)) \
        .join(books_df, on='book_id', how='outer') \
        .filter(F.col('available_from') < F.date_sub(F.to_date(F.lit('2019-06-23')), 30)) \
        .groupby(['book_id', 'name']).agg(F.sum('quantity')) \
        .select(['book_id', 'name'])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_2)
