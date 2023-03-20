from dependencies import spark_pg_utils


def main(spark_pg):
    # Question link
    # https://www.jiakaobo.com/leetcode.html

    # pyspark code
    df = spark_pg.read_table_as_df("scores_178")
    df.show()


if __name__ == '__main__':
    spark_pg_utils.execute(main)
