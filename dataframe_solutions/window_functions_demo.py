from pyspark.sql import SparkSession
from pyspark.sql import functions as F, Window as W


spark = SparkSession.builder \
            .appName('test') \
            .getOrCreate()


df = spark.createDataFrame([('a', 1), ('a', 2), ('a', 3), ('a', 4)], ['key', 'num'])

df.show()

# bad
w1 = W.partitionBy('key')
w2 = W.partitionBy('key').orderBy('num')

df.select('key', 'num', F.sum('num').over(w1).alias('sum')).show()
df.select('key', 'num', F.sum('num').over(w2).alias('sum')).show()
df.select('key', 'num', F.first('num').over(w1).alias('first')).show()
df.select('key', 'num', F.first('num').over(w2).alias('first')).show()
df.select('key', 'num', F.last('num').over(w1).alias('last')).show()
df.select('key', 'num', F.last('num').over(w2).alias('last')).show()

w3 = W.partitionBy('key').orderBy('num').rowsBetween(W.unboundedPreceding, 0)
w4 = W.partitionBy('key').orderBy('num').rowsBetween(W.unboundedPreceding, W.unboundedFollowing)
print('--------------------------------------------------------')

df.select('key', 'num', F.sum('num').over(w3).alias('sum')).show()
df.select('key', 'num', F.sum('num').over(w4).alias('sum')).show()
df.select('key', 'num', F.first('num').over(w3).alias('first')).show()
df.select('key', 'num', F.first('num').over(w4).alias('first')).show()
df.select('key', 'num', F.last('num').over(w3).alias('last')).show()
df.select('key', 'num', F.last('num').over(w4).alias('last')).show()

