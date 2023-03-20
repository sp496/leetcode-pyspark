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