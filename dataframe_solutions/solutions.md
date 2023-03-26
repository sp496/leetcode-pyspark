# Solutions

## Easy

## Medium

### [176. Second Highest Salary](https://www.jiakaobo.com/leetcode/176.%20Second%20Highest%20Salary.html)

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

### [178. Rank Scores](https://www.jiakaobo.com/leetcode/178.%20Rank%20Scores.html)

```python
from pyspark.sql.functions import col, desc, dense_rank
from pyspark.sql.window import Window

rank_spec = Window.orderBy(desc(col('score')))

scores_df = spark_pg.read_table_as_df("scores_178")
result_df = scores_df.\
    withColumn('dense_rank', dense_rank().over(rank_spec))
result_df.show()
```

### [180. Consecutive Numbers](https://www.jiakaobo.com/leetcode/180.%20Consecutive%20Numbers.html)

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

### [184. Department Highest Salary](https://www.jiakaobo.com/leetcode/184.%20Department%20Highest%20Salary.html)

```python
from pyspark.sql.functions import col, desc, rank
from pyspark.sql.window import Window

emp_df = spark_pg.read_table_as_df("employee_184")
emp_df.show()

dep_df = spark_pg.read_table_as_df("department_184")
dep_df.show()

w = Window.partitionBy(col('dep.id')).orderBy(desc(col('emp.salary')))

result_df = \
    emp_df.alias('emp') \
    .join(dep_df.alias('dep'), on=col('emp.department_id') == col('dep.id'), how='inner')\
    .withColumn('rank', rank().over(w))\
    .where(col('rank') == 1)\
    .select([col('dep.name').alias('Department'), col('emp.name').alias('Employee'), 'salary'])

result_df.show()
```



### [534. Game Play Analysis III](https://www.jiakaobo.com/leetcode/534.%20Game%20Play%20Analysis%20III.html)

```python
from pyspark.sql.functions import col, sum

act_df = spark_pg.read_table_as_df("activity_534")
act_df.show()

result_df = act_df.alias('a1') \
    .join(act_df.alias('a2'),
          on=(col('a1.player_id') == col('a2.player_id')) & (col('a2.event_date') <= col('a1.event_date')),
          how='inner')\
    .groupby([col('a1.player_id'), col('a1.event_date')])\
    .agg(sum('a2.games_played').alias('games_played_so_far'))

result_df.show()
```


### [550. Game Play Analysis IV](https://www.jiakaobo.com/leetcode/550.%20Game%20Play%20Analysis%20IV.html)

```python
from pyspark.sql.functions import col, rank, when, count, countDistinct, round
from pyspark.sql.window import Window

act_df = spark_pg.read_table_as_df("activity_550")
act_df.show()

w = Window.partitionBy(col('a1.player_id')).orderBy('a1.event_date')

result_df = act_df.alias('a1') \
    .withColumn('day', rank().over(w)) \
    .join(act_df.alias('a2'),
          on=(col('a1.player_id') == col('a2.player_id')) & (col('a2.event_date') == col('a1.event_date') + 1),
          how='left') \
    .select(round((count(when((col('day') == 1) & (col('a2.player_id').isNotNull()), col('a1.player_id'))
                         .otherwise(None)) / countDistinct(col("a1.player_id"))), 2).alias('fraction'))

result_df.show()
```


### [570. Managers with at Least 5 Direct Reports](https://www.jiakaobo.com/leetcode/570.%20Managers%20with%20at%20Least%205%20Direct%20Reports.html)

```python
from pyspark.sql.functions import col, count

emp_df = spark_pg.read_table_as_df("employee_570")
emp_df.show()

result_df = emp_df.alias('emp')\
    .join(emp_df.alias('mgr'), on=col('emp.manager_id') == col('mgr.id'))\
    .groupby([col('emp.manager_id'), col('mgr.name')]).agg(count('emp.id').alias('reports'))\
    .filter(col('reports') >= 5)\
    .select(col('mgr.name'))

result_df.show()
```


### [574. Winning Candidate](https://www.jiakaobo.com/leetcode/574.%20Winning%20Candidate.html)

```python
from pyspark.sql.functions import col, count

can_df = spark_pg.read_table_as_df("candidate_574")
can_df.show()
vote_df = spark_pg.read_table_as_df("vote_574")
vote_df.show()

result_df = vote_df.alias('v')\
    .join(can_df.alias('c'), on=col('v.candidate_id') == col('c.id'))\
    .groupby([col('v.candidate_id'), col('c.name')]).agg(count('v.id').alias('votes'))\
    .orderBy(col('votes').desc())\
    .limit(1)\
    .select(col('name'))

result_df.show()
```


### [578. Get Highest Answer Rate Question](https://www.jiakaobo.com/leetcode/578.%20Get%20Highest%20Answer%20Rate%20Question.html)

```python
from pyspark.sql.functions import col, count, when

df = spark_pg.read_table_as_df("surveylog_578")
df.show()

result_df = df\
    .groupby('question_id')\
    .agg((count(when(col('action') == 'answer', True))/
          count(when(col('action') == 'show', True))).alias('answer_rate'))\
    .orderBy('question_id') \
    .limit(1)\
    .select('question_id').alias('survey_log')

result_df.show()
```


### [580. Count Student Number in Departments](https://www.jiakaobo.com/leetcode/580.%20Count%20Student%20Number%20in%20Departments.html)

```python
from pyspark.sql.functions import count, desc

stud_df = spark_pg.read_table_as_df("student_580")
stud_df.show()

dep_df = spark_pg.read_table_as_df("department_580")
dep_df.show()

result_df = dep_df\
    .join(stud_df, on='dept_id', how='left')\
    .groupby('dept_name')\
    .agg(count('student_id').alias('student_number'))\
    .orderBy(desc('student_number'))

result_df.show()
```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```


