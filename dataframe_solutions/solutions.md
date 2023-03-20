## Solutions

### 176
```text
Write a SQL query to get the second highest salary from the Employee table.
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

```python
from pyspark.sql.window import Window
from pyspark.sql.functions import col, dense_rank, desc

window_spec = Window.orderBy(desc("salary"))
employee_df = spark_pg.read_table_as_df("employee_181")
employee_df.show()

result_df = employee_df\
    .withColumn('dense_rank', dense_rank().over(window_spec))\
    .where(col('dense_rank') == 2)\
    .select(col('salary').alias('SecondHighestSalary'))
result_df.show()
```

### 178

```text
Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no “holes” between ranks.

+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
For example, given the above Scores table, your query should generate the following report (order by highest score):

+-------+---------+
| score | Rank    |
+-------+---------+
| 4.00  | 1       |
| 4.00  | 1       |
| 3.85  | 2       |
| 3.65  | 3       |
| 3.65  | 3       |
| 3.50  | 4       |
+-------+---------+
Important Note: For MySQL solutions, to escape reserved words used as column names, you can use an apostrophe before and after the keyword. For example Rank.
```
```python
from pyspark.sql.functions import col, desc, dense_rank
from pyspark.sql.window import Window

rank_spec = Window.orderBy(desc(col('score')))

scores_df = spark_pg.read_table_as_df("scores_178")
result_df = scores_df.\
    withColumn('dense_rank', dense_rank().over(rank_spec))
result_df.show()
```

### 180
```text
Write a SQL query to find all numbers that appear at least three times consecutively.

+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```

```python
from pyspark.sql.functions import col, asc, lead
from pyspark.sql.window import Window

window_spec = Window.orderBy(asc(col('id')))

logs_df = spark_pg.read_table_as_df("Logs_180")
logs_df.show()

result_df = logs_df\
    .withColumn('second_num', lead(col('num')).over(window_spec))\
    .withColumn('third_num', lead(col('second_num')).over(window_spec))\
    .where((col('second_num') == col('num')) & (col('third_num') == col('second_num')))\
    .select(col('num').alias('ConsecutiveNums'))

result_df.show()
```

### 

```text

```

```python

```



### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```

### 

```text

```

```python

```

### 

```text

```

```python

```

### 

```text

```

```python

```

### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```


### 

```text

```

```python

```

### 

```text

```

```python

```

### 

```text

```

```python

```

### 

```text

```

```python

```








