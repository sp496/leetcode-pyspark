from dependencies import spark_pg_utils

def solution_1(spark):

    from pyspark.sql import functions as F

    c_df = spark.read_table_as_df("customers_1364")
    c_df.show()

    co_df = spark.read_table_as_df("contacts_1364")
    co_df.show()

    i_df = spark.read_table_as_df("invoices_1364")
    i_df.show()

    result_df = i_df.alias('i') \
                .join(c_df.alias('c'), on=F.col('i.user_id')==F.col('c.customer_id'), how='left') \
                .join(co_df.alias('co'), on=F.col('i.user_id')==F.col('co.user_id'), how='left') \
                .join(c_df.alias('c1'), on=F.col('co.contact_email') == F.col('c1.email'), how='left') \
                .groupby('i.invoice_id', 'c.customer_name', 'i.price').agg(F.count('co.user_id').alias('contacts_cnt'),
                                           F.countDistinct('c1.email').alias('trusted_contacts_cnt')) \
                .orderBy('invoice_id')

    result_df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(solution_1)
