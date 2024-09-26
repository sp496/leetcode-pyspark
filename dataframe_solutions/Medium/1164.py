from dependencies import spark_pg_utils


def solution_1(spark):
    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    prod_df = spark.read_table_as_df("products_1164")
    prod_df.show()

    w = Window.partitionBy('product_id').orderBy(F.desc('change_date_'))

    result_df = prod_df \
        .withColumn('change_date_', F.when(F.col('change_date') <= '2019-08-16', F.col('change_date'))) \
        .withColumn('new_price', F.when(F.col('change_date_') <= '2019-08-16', F.col('new_price')).otherwise(10)) \
        .withColumn('price', F.first('new_price').over(w)) \
        .dropDuplicates(['product_id', 'price']) \
        .select(['product_id', 'price'])

    result_df.show()

# select product_id, max(change_date) as recent_date
# from Products
# where change_date <= "2019-08-16"
# group by product_id
def solution_2(spark):
    import pyspark.sql.functions as F
    from pyspark.sql.window import Window

    prod_df = spark.read_table_as_df("products_1164")
    prod_df.show()

    w = Window.partitionBy('product_id').orderBy(F.desc('change_date'))

    result_df = prod_df \
        .filter(F.col('change_date') <= '2019-08-16') \
        .withColumn('number', F.row_number().over(w)) \
        .filter(F.col('number') == 1) \
        .select(['product_id', 'new_price'])


    result_df.show()

    result_df = prod_df \
        .dropDuplicates(['product_id']) \
        .select(['product_id']) \
        .join(result_df, on='product_id', how='left') \
        .fillna({"new_price": 10}, subset=["new_price"])

    result_df.show()

def solution_3(spark):

    from pyspark.sql import functions as F, Window as W

    prod_df = spark.read_table_as_df("products_1164")
    prod_df.show()

    wspec = W.partitionBy('product_id').orderBy(F.desc('change_date')).rowsBetween(-1, W.currentRow)

    result_df = prod_df \
        .withColumn('price', F.when(F.col('change_date') <= '2019-08-16', F.col('new_price'))
                    .otherwise(F.first('new_price').over(wspec))) \

    result_df.show()


def solution_4(spark):

    from pyspark.sql import functions as F, Window as W

    prod_df = spark.read_table_as_df("products_1164")
    prod_df.show()

    wspec = W.partitionBy('product_id').orderBy(F.desc('change_date')).rowsBetween(W.unboundedPreceding, W.currentRow)

    ranked_prod_df = prod_df \
                .filter(F.col('change_date') <= '2019-08-16') \
                .withColumn('ranking', F.rank().over(wspec)) \
                .filter(F.col('ranking') == 1)

    ranked_prod_df.show()

    result_df = prod_df \
                .select('product_id').distinct() \
                .join(ranked_prod_df, on='product_id', how='left') \
                .select(['product_id', F.ifnull(F.col('new_price'), F.lit(10)).alias('price')])

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
