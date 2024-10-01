# Solutions

## Easy

## Medium

### [176. Second Highest Salary](https://www.jiakaobo.com/leetcode/176.%20Second%20Highest%20Salary.html)

```python
from pyspark.sql import functions as F, Window as W

employee_df = spark.read_table_as_df("employee_181")
employee_df.show()

wspec = W.orderBy(F.desc("salary")).rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = employee_df \
    .withColumn('dense_rank', F.dense_rank().over(wspec)) \
    .where(F.col('dense_rank') == 2) \
    .select(F.col('salary').alias('SecondHighestSalary')).distinct()

result_df.show()
```

### [177. Nth Highest Salary](https://www.jiakaobo.com/leetcode/177.%20Nth%20Highest%20Salary.html)

```python
from pyspark.sql import functions as F, Window as W

n = 2
employee_df = spark.read_table_as_df("employee_181")
employee_df.show()

wspec = W.orderBy(F.desc("salary")).rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = employee_df \
    .withColumn('dense_rank', F.dense_rank().over(wspec)) \
    .where(F.col('dense_rank') == n) \
    .select(F.col('salary').alias('nthHighestSalary')).distinct()

result_df.show()
```

### [178. Rank Scores](https://www.jiakaobo.com/leetcode/178.%20Rank%20Scores.html)

```python
from pyspark.sql import functions as F, Window as W

wspec = W.orderBy(F.desc(F.col('score'))).rowsBetween(W.unboundedPreceding, W.currentRow)

scores_df = spark.read_table_as_df("scores_178")

result_df = scores_df \
    .select('score', F.dense_rank().over(wspec).alias('Rank'))

result_df.show()
```

### [180. Consecutive Numbers](https://www.jiakaobo.com/leetcode/180.%20Consecutive%20Numbers.html)

```python
# solution 1
# using distinct() makes sure we don't pick the same number when there are more than 3 consecutive numbers
from pyspark.sql import functions as F, Window as W

wspec = W.orderBy(F.asc('id'))

logs_df = spark.read_table_as_df("Logs_180")
logs_df.show()

result_df = logs_df \
    .withColumn('second_num', F.lead(F.col('num')).over(wspec)) \
    .withColumn('third_num', F.lead(F.col('second_num')).over(wspec)) \
    .where((F.col('second_num') == F.col('num')) & (F.col('third_num') == F.col('second_num'))) \
    .select(F.col('num').alias('ConsecutiveNums')).distinct()

result_df.show()

#solution 2
# pyspark equivalent of sql selecting from a table t1, table t2, table t3
#better to add morecondiditons to the join instead of using a where clause later
import pyspark.sql.functions as F

logs_df = spark.read_table_as_df("Logs_180")
logs_df.show()

result_df = logs_df.alias("l1") \
    .join(logs_df.alias("l2"), on=(F.col("l2.Id") == F.col("l1.Id") + 1) & (F.col("l2.num") == F.col("l1.num"))) \
    .join(logs_df.alias("l3"), on=(F.col("l3.Id") == F.col("l1.Id") + 2) & (F.col("l3.num") == F.col("l1.num"))) \
    .select(F.col("l1.num").alias('ConsecutiveNums')).distinct()

result_df.show()
```

### [184. Department Highest Salary](https://www.jiakaobo.com/leetcode/184.%20Department%20Highest%20Salary.html)

```python
from pyspark.sql import functions as F, Window as W

emp_df = spark.read_table_as_df("employee_184")
emp_df.show()

dep_df = spark.read_table_as_df("department_184")
dep_df.show()

wspec = W.partitionBy('dep.id').orderBy(F.desc('emp.salary')).rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = emp_df.alias('emp') \
    .join(dep_df.alias('dep'), on=F.col('emp.department_id') == F.col('dep.id'), how='inner') \
    .withColumn('rank', F.rank().over(wspec)) \
    .where(F.col('rank') == 1) \
    .select([F.col('dep.name').alias('Department'), F.col('emp.name').alias('Employee'), 'salary'])

result_df.show()
```



### [534. Game Play Analysis III](https://www.jiakaobo.com/leetcode/534.%20Game%20Play%20Analysis%20III.html)

```python
#solution 1
from pyspark.sql import functions as F, Window as W

act_df = spark.read_table_as_df("activity_534")
act_df.show()

wspec = W.partitionBy('player_id').orderBy('event_date').rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = act_df \
            .select('player_id', 'event_date', F.sum('games_played').over(wspec).alias('games_played_so_far'))

result_df.show()

#solution 2
import pyspark.sql.functions as F

act_df = spark.read_table_as_df("activity_534")
act_df.show()

result_df = act_df.alias('a1') \
    .join(act_df.alias('a2'),
          on=(F.col('a1.player_id') == F.col('a2.player_id')) & (F.col('a2.event_date') <= F.col('a1.event_date')),
          how='inner') \
    .groupby([F.col('a1.player_id'), F.col('a1.event_date')]) \
    .agg(F.sum('a2.games_played').alias('games_played_so_far'))

result_df.show()
```


### [550. Game Play Analysis IV](https://www.jiakaobo.com/leetcode/550.%20Game%20Play%20Analysis%20IV.html)

```python
#solution 1

from pyspark.sql import functions as F, Window as W

act_df = spark.read_table_as_df("activity_550")
act_df.show()

wspec = W.partitionBy(F.col('a1.player_id')).orderBy('a1.event_date')

result_df = act_df.alias('a1') \
    .withColumn('day', F.rank().over(wspec)) \
    .filter(F.col('day') == 1) \
    .join(act_df.alias('a2'),
          on=(F.col('a1.player_id') == F.col('a2.player_id')) &
             (F.col('a2.event_date') == F.col('a1.event_date') + 1),
          how='left') \
    .select(F.round(F.count(F.col('a2.player_id'))/F.count(F.col('a1.player_id')), 2).alias('fraction'))

result_df.show()

#solution 2

from pyspark.sql import functions as F, Window as W

act_df = spark.read_table_as_df("activity_550")
act_df.show()

wspec = W.partitionBy('a1.player_id').orderBy('a1.event_date')

result_df = act_df.alias('a1') \
    .withColumn('day', F.rank().over(wspec)) \
    .join(act_df.alias('a2'),
          on=(F.col('a1.player_id') == F.col('a2.player_id')) &
             (F.col('a2.event_date') == F.col('a1.event_date') + 1),
          how='left') \
    .select(F.round((F.count(F.when((F.col('day') == 1) & (F.col('a2.player_id').isNotNull()), F.col('a1.player_id')))
                     / F.countDistinct(F.col("a1.player_id"))), 2).alias('fraction'))

result_df.show()
```


### [570. Managers with at Least 5 Direct Reports](https://www.jiakaobo.com/leetcode/570.%20Managers%20with%20at%20Least%205%20Direct%20Reports.html)

```python
import pyspark.sql.functions as F

emp_df = spark.read_table_as_df("employee_570")
emp_df.show()

result_df = emp_df.alias('emp') \
    .join(emp_df.alias('mgr'), on=F.col('emp.manager_id') == F.col('mgr.id')) \
    .groupby([F.col('emp.manager_id'), F.col('mgr.name')]).agg(F.count('emp.id').alias('reports')) \
    .filter(F.col('reports') >= 5) \
    .select(F.col('mgr.name'))

result_df.show()
```


### [574. Winning Candidate](https://www.jiakaobo.com/leetcode/574.%20Winning%20Candidate.html)

```python
import pyspark.sql.functions as F

can_df = spark.read_table_as_df("candidate_574")
can_df.show()
vote_df = spark.read_table_as_df("vote_574")
vote_df.show()

result_df = vote_df.alias('v') \
    .join(can_df.alias('c'), on=F.col('v.candidate_id') == F.col('c.id')) \
    .groupby([F.col('v.candidate_id'), F.col('c.name')]).agg(F.count('v.id').alias('votes')) \
    .orderBy(F.col('votes').desc()) \
    .limit(1) \
    .select(F.col('name'))

result_df.show()
```


### [578. Get Highest Answer Rate Question](https://www.jiakaobo.com/leetcode/578.%20Get%20Highest%20Answer%20Rate%20Question.html)

```python
import pyspark.sql.functions as F

df = spark.read_table_as_df("surveylog_578")
df.show()

result_df = df \
    .groupby('question_id') \
    .agg((F.count(F.when(F.col('action') == 'answer', True)) /
          F.count(F.when(F.col('action') == 'show', True))).alias('answer_rate')) \
    .orderBy('question_id') \
    .limit(1) \
    .select('question_id').alias('survey_log')

result_df.show()
```


### [580. Count Student Number in Departments](https://www.jiakaobo.com/leetcode/580.%20Count%20Student%20Number%20in%20Departments.html)

```python
import pyspark.sql.functions as F

stud_df = spark.read_table_as_df("student_580")
stud_df.show()

dep_df = spark.read_table_as_df("department_580")
dep_df.show()

result_df = dep_df\
    .join(stud_df, on='dept_id', how='left')\
    .groupby('dept_name')\
    .agg(F.count('student_id').alias('student_number'))\
    .orderBy(F.desc('student_number'))

result_df.show()
```

### [585. Investments in 2016](https://www.jiakaobo.com/leetcode/585.%20Investments%20in%202016.html)

```python
#solution 1
import pyspark.sql.functions as F

inv_df = spark.read_table_as_df("insurance_585")
inv_df.show()
result_df = inv_df.alias('i1') \
    .join(inv_df.alias('i2'), on=(F.col('i1.lat') == F.col('i2.lat')) &
                                 (F.col('i1.lon') == F.col('i2.lon')) &
                                 (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')), how='left_anti') \
    .agg(F.sum(F.col('tiv_2016')).alias('tiv_2016'))

result_df.show()

#solution 2
import pyspark.sql.functions as F

inv_df = spark.read_table_as_df("insurance_585")
inv_df.show()

result_df = inv_df.alias('i1') \
    .join(inv_df.alias('i2'), on=(F.col('i1.lat') == F.col('i2.lat')) &
                                 (F.col('i1.lon') == F.col('i2.lon')) &
                                 (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')), how='left') \
    .filter(F.col('i2.pid').isNull()) \
    .agg(F.sum(F.col('i1.tiv_2016')).alias('tiv_2016'))

result_df.show()

#solution 3 WRONG
#cannot use this because lat and long must not be repeated 

import pyspark.sql.functions as F

inv_df = spark.read_table_as_df("insurance_585")
inv_df.show()

result_df = inv_df.alias('i1') \
    .join(inv_df.alias('i2'), on=(F.col('i1.lat') != F.col('i2.lat')) &
                                 (F.col('i1.lon') != F.col('i2.lon')) &
                                 (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')), how='inner')


result_df.show()

```

### [602. Friend Requests II: Who Has the Most Friends](https://www.jiakaobo.com/leetcode/602.%20Friend%20Requests%20II:%20Who%20Has%20the%20Most%20Friends.html)

```python

#solution 1

import pyspark.sql.functions as F

req_df = spark.read_table_as_df("request_accepted_602")
req_df.show()

#can use unionAll too
result_df = req_df.select([F.col('requester_id').alias('id'), F.col('accepter_id').alias('friend_id')]) \
    .union(req_df.select([F.col('accepter_id').alias('id'), F.col('requester_id').alias('friend_id')])) \
    .groupby('id').agg(F.count('friend_id').alias('num')) \
    .orderBy(F.desc('num')) \
    .limit(1)

result_df.show()

#solution 2

from pyspark.sql import functions as F, Window as W

req_df = spark.read_table_as_df("request_accepted_602")
req_df.show()

w_spec = W.orderBy(F.desc('num'))

result_df = req_df.select([F.col('requester_id').alias('id'), F.col('accepter_id').alias('friend_id')]) \
    .union(req_df.select([F.col('accepter_id').alias('id'), F.col('requester_id').alias('friend_id')])) \
    .groupby('id').agg(F.count('friend_id').alias('num')) \
    .withColumn('rnk', F.rank().over(w_spec)) \
    .filter(F.col('rnk') == 1) \
    .select('id', 'num')

result_df.show()
```

### [608. Tree Node](https://www.jiakaobo.com/leetcode/608.%20Tree%20Node.html) 

```python
#solution 1
import pyspark.sql.functions as F

tree_df = spark.read_table_as_df("tree_608")
tree_df.show()

result_df = tree_df.alias('t1') \
    .join(tree_df.alias('t2'), on=F.col('t1.id') == F.col('t2.p_id'), how='left') \
    .withColumn('type', F.when(F.col('t1.p_id').isNull(), 'Root')
                        .when(F.col('t2.p_id').isNull(), 'Leaf')
                        .otherwise('Inner')) \
    .select([F.col('t1.id'), F.col('type')]) \
    .dropDuplicates() \
    .orderBy('id')

result_df.show()

#solution 2
import pyspark.sql.functions as F

tree_df = spark.read_table_as_df("tree_608")
tree_df.show()

result_df = tree_df.alias('t1') \
            .join(tree_df.alias('t2'), on=(F.col('t1.id') == F.col('t2.p_id')), how='left_anti') \
            .withColumn('type', F.lit("Leaf")) \
            .union(tree_df.alias('t1') \
            .join(tree_df.alias('t2'), on=(F.col('t1.id') == F.col('t2.p_id')), how='left_semi') \
            .withColumn('type', F.when(F.col('t1.p_id').isNull(), 'Root').otherwise('Inner'))) \
            .select('id', 'type') \
            .orderBy('id')

result_df.show()
```

### [612. Shortest Distance in a Plane](https://www.jiakaobo.com/leetcode/612.%20Shortest%20Distance%20in%20a%20Plane.html)

```python
import pyspark.sql.functions as F

points_df = spark.read_table_as_df("point_2d_612")
points_df.show()

# could use cross join too
result_df = points_df.alias('p1') \
    .join(points_df.alias('p2'),
          on=(F.col('p1.x') != F.col('p2.x')) | (F.col('p1.y') != F.col('p2.y')),
          how='inner') \
    .withColumn('distance', F.sqrt(F.pow(F.col('p2.x') - F.col('p1.x'), 2) +
                                   F.pow(F.col('p2.y') - F.col('p1.y'), 2))) \
    .select(F.min('distance').alias('shortest'))

result_df.show()
```

### [614. Second Degree Follower](https://www.jiakaobo.com/leetcode/614.%20Second%20Degree%20Follower.html)

comments: perfect example for where a semi join is optimal

```python
import pyspark.sql.functions as F

fol_df = spark.read_table_as_df("follow_614")
fol_df.show()

result_df = fol_df.alias('f1')\
    .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='left_semi') \
    .groupby('followee').agg(F.count('follower').alias('num'))

result_df.show()

#solution 2

import pyspark.sql.functions as F

fol_df = spark.read_table_as_df("follow_614")
fol_df.show()


result_df = fol_df.alias('f1') \
    .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='inner') \
    .groupby('f1.followee').agg(F.count('f1.follower').alias('num'))

result_df.show()

```

### [626. Exchange Seats](https://www.jiakaobo.com/leetcode/626.%20Exchange%20Seats.html)

```python
#solution_i
from pyspark.sql import functions as F, Window as W

seat_df = spark.read_table_as_df("seat_626")
seat_df.show()

wspec = W.orderBy('id').rowsBetween(-1, 1)
result_df = seat_df \
            .withColumn("id", F.when(F.col('id') % 2 == 0,  F.first('id').over(wspec))
                                .otherwise(F.last('id').over(wspec))) \
            .orderBy('id')

result_df.show()

#solution 2
import pyspark.sql.functions as F

seat_df = spark.read_table_as_df("seat_626")
seat_df.show()

result_df = seat_df.alias('s1') \
            .join(seat_df.alias('s2'), on=((F.col('s1.id') % 2 == 0) & (F.col('s2.id') == F.col('s1.id')-1)) |
                                          ((F.col('s1.id') % 2 == 1) & (F.col('s2.id') == F.col('s1.id')+1 ))
                                        ,how='left') \
            .select([F.col('s1.id'), F.ifnull(F.col('s2.student'), F.col('s1.student')).alias('student')])

result_df.show()

#solution 3
import pyspark.sql.functions as F
from pyspark.sql.window import Window

seat_df = spark.read_table_as_df("seat_626")
seat_df.show()

result_df = seat_df.alias('s1') \
    .withColumn('order', F.when(F.col('id') % 2 == 0, F.col('id') - 1).otherwise(F.col('id') + 1)) \
    .withColumn("id", F.row_number().over(Window.orderBy("order")))\
    .orderBy('id') \
    .select([F.col('id'), F.col('student')])

result_df.show()
```

### [1045. Customers Who Bought All Products](https://www.jiakaobo.com/leetcode/1045.%20Customers%20Who%20Bought%20All%20Products.html)

```python
import pyspark.sql.functions as F

cust_df = spark.read_table_as_df("customer_1045")
cust_df.show()

prod_df = spark.read_table_as_df("product_1045")
prod_df.show()

unique_product_count = prod_df.count()

print(unique_product_count)

result_df = cust_df \
    .groupby('customer_id').agg(F.countDistinct('product_key').alias('products')) \
    .filter(F.col('products') == unique_product_count) \
    .select('customer_id')

result_df.show()
```

### [1070. Product Sales Analysis III](https://www.jiakaobo.com/leetcode/1070.%20Product%20Sales%20Analysis%20III.html)

```python
from pyspark.sql import functions as F, Window as W

sales_df = spark.read_table_as_df("sales_1068")
sales_df.show()

prod_df = spark.read_table_as_df("product_1068")
prod_df.show()

wspec = W.partitionBy('product_id').orderBy('year')

result_df = sales_df \
    .withColumn('n_year', F.rank().over(wspec)) \
    .filter(F.col('n_year') == 1)

result_df.show()
```

### [1077. Project Employees III](https://www.jiakaobo.com/leetcode/1077.%20Project%20Employees%20III.html)

```python
from pyspark.sql import functions as F, Window as W

project_df = spark.read_table_as_df("project_1077")
project_df.show()

emp_df = spark.read_table_as_df("employee_1077")
emp_df.show()

wspec = W.partitionBy('project_id').orderBy(F.desc('experience_years'))

result_df = project_df \
    .join(emp_df, on='employee_id', how='inner') \
    .withColumn('exp_rank', F.dense_rank().over(wspec)) \
    .filter(F.col('exp_rank') == 1) \
    .select(['project_id', 'employee_id'])

result_df.show()
```

### [1098. Unpopular Books](https://www.jiakaobo.com/leetcode/1098.%20Unpopular%20Books.html)

```python
#solution_1
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

#solution_2
import pyspark.sql.functions as F

books_df = spark.read_table_as_df("books_1098")
books_df.show()

orders_df = spark.read_table_as_df("orders_1098")
orders_df.show()

result_df = books_df.alias('b') \
    .join(orders_df.alias('o'), on=(F.col('o.book_id') == F.col('b.book_id'))
                                   & (F.col('o.dispatch_date') > F.to_date(F.lit('2018-06-23'))), how='left') \
    .filter(F.col('b.available_from') < F.to_date(F.lit('2019-05-23'))) \
    .groupby([F.col('b.book_id'), 'name']).agg(F.sum('quantity')) \
    .select(['book_id', 'name'])

result_df.show()

#solution_3
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
```

### [1107. New Users Daily Count](https://www.jiakaobo.com/leetcode/1107.%20New%20Users%20Daily%20Count.html)

```python
#solution 1
from pyspark.sql import functions as F, Window as W

traffic_df = spark.read_table_as_df("traffic_1107")
traffic_df.show()

wspec = W.partitionBy(['user_id', 'activity']).orderBy('activity_date')

result_df = traffic_df \
            .filter(F.col('activity') == 'login') \
            .withColumn('rnk', F.rank().over(wspec)) \
            .filter(F.col('rnk') == 1) \
            .filter(F.col('activity_date') >= F.date_sub(F.to_date(F.lit('2019-06-30')), 90)) \
            .groupby('activity_date').agg(F.count('*').alias('user_count'))

result_df.show()

#solution 2
from pyspark.sql import functions as F, Window as W

traffic_df = spark.read_table_as_df("traffic_1107")
traffic_df.show()

wspec = W.partitionBy(['user_id', 'activity']).orderBy('activity_date')

result_df = traffic_df \
            .filter(F.col('activity') == 'login') \
            .withColumn('rnk', F.rank().over(wspec)) \
            .filter(F.col('rnk') == 1) \
            .filter(F.col('activity_date') >= F.date_sub(F.lit('2019-06-30'), 90)) \
            .groupby('activity_date').agg(F.count('*').alias('user_count'))

result_df.show()
```

### [1112. Highest Grade For Each Student](https://www.jiakaobo.com/leetcode/1112.%20Highest%20Grade%20For%20Each%20Student.html)

```python
from pyspark.sql import functions as F, Window as W

enrol_df = spark.read_table_as_df("enrollments_1112")
enrol_df.show()

wspec = W.partitionBy('student_id').orderBy(F.desc('grade'), F.asc('course_id'))

result_df = enrol_df \
    .withColumn('rank', F.rank().over(wspec)) \
    .filter(F.col('rank') == 1) \
    .select('student_id', 'course_id', 'grade')

result_df.show()
```

### [1126. Active Businesses](https://www.jiakaobo.com/leetcode/1126.%20Active%20Businesses.html)

```python
# solution 1
from pyspark.sql import functions as F, Window as W

events_df = spark.read_table_as_df("events_1126")
events_df.show()

wspec = W.partitionBy('event_type')

result_df = events_df \
    .withColumn('avg_event_occurence', F.avg('occurences').over(wspec)) \
    .filter(F.col('occurences') > F.col('avg_event_occurence')) \
    .groupby('business_id').agg(F.count('event_type').alias('event_types')) \
    .filter(F.col('event_types') > 1) \
    .select('business_id')

result_df.show()

#solution 2
from pyspark.sql import functions as F

events_df = spark.read_table_as_df("events_1126")
events_df.show()

result_df = events_df \
    .groupby('event_type').agg(F.avg('occurences').alias('avg_occurences')) \
    .join(events_df, on='event_type') \
    .filter(F.col('occurences') > F.col('avg_occurences')) \
    .groupby('business_id').agg(F.count('event_type').alias('event_types')) \
    .filter(F.col('event_types') > 1) \
    .select('business_id')

result_df.show()
```

### [1132. Reported Posts II](https://www.jiakaobo.com/leetcode/1132.%20Reported%20Posts%20II.html)

```python
import pyspark.sql.functions as F

actions_df = spark.read_table_as_df("actions_1132")
actions_df.show()

removals_df = spark.read_table_as_df("removals_1132")
removals_df.show()

result_df = actions_df \
    .filter(F.col('extra') == 'spam') \
    .join(removals_df, on='post_id', how='left') \
    .groupby('action_date') \
    .agg((F.count('remove_date') * 100 / (F.count('post_id'))).alias('percentage')) \
    .select(F.avg('percentage').alias('average_daily_percent'))

result_df.show()
```

### [1149. Article Views II](https://www.jiakaobo.com/leetcode/1149.%20Article%20Views%20II.html)

```python
import pyspark.sql.functions as F

views_df = spark.read_table_as_df("views_1149")
views_df.show()

result_df = views_df \
    .groupby(['viewer_id', 'view_date']).agg(F.countDistinct(F.col('article_id')).alias('articles')) \
    .filter(F.col('articles') > 1) \
    .select('viewer_id')

result_df.show()
```

### [1158. Market Analysis I](https://www.jiakaobo.com/leetcode/1158.%20Market%20Analysis%20I.html)

```python
#solution 1
import pyspark.sql.functions as F

o_df = spark.read_table_as_df("orders_1158")
o_df.show()

u_df = spark.read_table_as_df("users_1158")
u_df.show()

result_df = u_df \
    .join(o_df, on=(F.col('user_id') == F.col('buyer_id'))
                   & (F.date_format('order_date', 'yyyy') == '2019'), how='left') \
    .groupby(['user_id', 'join_date']) \
    .agg(F.count('order_id').alias('orders_in_2019'))

result_df.show()
```

```python
#solution 2
import pyspark.sql.functions as F

o_df = spark.read_table_as_df("orders_1158")
o_df.show()

u_df = spark.read_table_as_df("users_1158")
u_df.show()

result_df = u_df \
    .join(o_df,
          on=(F.col('user_id') == F.col('buyer_id')) &
             (F.col('order_date').between('2019-01-01', '2019-12-31')),
          how='left') \
    .groupby(['user_id', 'join_date']) \
    .agg(F.count('order_id').alias('orders_in_2019'))

result_df.show()
```

### [1164. Product Price at a Given Date](https://www.jiakaobo.com/leetcode/1164.%20Product%20Price%20at%20a%20Given%20Date.html)

```python
#solution 1
from pyspark.sql import functions as F, Window as W

prod_df = spark.read_table_as_df("products_1164")
prod_df.show()

wspec = W.partitionBy('product_id').orderBy(F.desc('change_date')).rowsBetween(W.unboundedPreceding, W.currentRow)

ranked_prod_df = prod_df \
            .filter(F.col('change_date') <= '2019-08-16') \
            .withColumn('ranking', F.rank().over(wspec)) \
            .filter(F.col('ranking') == 1)

result_df = prod_df \
            .select('product_id').distinct() \
            .join(ranked_prod_df, on='product_id', how='left') \
            .select(['product_id', F.ifnull(F.col('new_price'), F.lit(10)).alias('price')])

result_df.show()

#solution 2
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
```

### [1174. Immediate Food Delivery II](https://www.jiakaobo.com/leetcode/1174.%20Immediate%20Food%20Delivery%20II.html)

```python
import pyspark.sql.functions as F
from pyspark.sql.window import Window

del_df = spark.read_table_as_df("delivery_1174")
del_df.show()

w = Window.partitionBy('customer_id').orderBy('order_date')

immediate_order = (F.col('customer_pref_delivery_date') == F.col('order_date'))
first_order = (F.col('order_number') == 1)

result_df = del_df \
    .withColumn('order_number', F.rank().over(w)) \
    .select(((F.count(F.when(first_order & immediate_order, True)) /
              F.count(F.when(first_order, True))) * 100).alias('immediate_percentage'))

result_df.show()
```

### [1193. Monthly Transactions I](https://www.jiakaobo.com/leetcode/1193.%20Monthly%20Transactions%20I.html)

```python
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("transactions_1193")
t_df.show()

result_df = t_df \
    .groupby([F.date_format('trans_date', 'yyyy-MM').alias('month'), 'country']) \
    .agg(F.count('id').alias('trans_count'),
         F.count(F.when(F.col('state') == 'approved', True)).alias('approved_count'),
         F.sum('amount').alias('trans_total_amount'),
         F.sum(F.when(F.col('state') == 'approved', F.col('amount'))).alias('approved_total_amount'))

result_df.show()
```

### [1204. Last Person to Fit in the Bus](https://www.jiakaobo.com/leetcode/1204.%20Last%20Person%20to%20Fit%20in%20the%20Bus.html)

```python
#solution 1
from pyspark.sql import functions as F, Window as W

q_df = spark.read_table_as_df("queue_1204")
q_df.show()

wspec = W.orderBy('Turn').rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = q_df \
        .withColumn('Total Weight', F.sum('weight').over(wspec)) \
        .filter(F.col('Total Weight') <= 1000) \
        .orderBy(F.desc('turn')) \
        .limit(1) \
        .select('person_name')

result_df.show()

#solution 2
from pyspark.sql import functions as F, Window as W

q_df = spark.read_table_as_df("queue_1204")
q_df.show()

result_df = q_df.alias('q1') \
        .join(q_df.alias('q2'), on=F.col('q2.turn') <= F.col('q1.turn')) \
        .groupby('q1.turn', 'q1.person_name').agg(F.sum('q2.weight').alias('Total Weight')) \
        .filter(F.col('Total Weight') <= 1000) \
        .orderBy(F.desc('q1.turn')) \
        .limit(1) \
        .select('person_name')

result_df.show()
```

### [1205. Monthly Transactions II](https://www.jiakaobo.com/leetcode/1205.%20Monthly%20Transactions%20II.html)

```python
#solution 1
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("transactions_1205")
t_df.show()

c_df = spark.read_table_as_df("chargebacks_1205")
c_df.show()

result_df = c_df.alias('c') \
    .join(t_df.alias('t'), on=F.col('c.trans_id') == F.col('t.id')) \
    .select(F.date_format('charge_date', 'yyyy-MM').alias('month'), 'country', 'amount',
            F.lit('chargeback').alias('state')) \
    .unionAll(t_df.select(F.date_format('trans_date', 'yyyy-MM').alias('month'), 'country', 'amount',
                       'state')) \
    .groupby('month', 'country') \
    .agg(F.count(F.when(F.col('state') == 'approved', 1)).alias('approved_count'),
         F.sum(F.when(F.col('state') == 'approved', F.col('amount')).otherwise(0)).alias('approved_amount'),
         F.count(F.when(F.col('state') == 'chargeback', 1)).alias('chargeback_count'),
         F.sum(F.when(F.col('state') == 'chargeback', F.col('amount')).otherwise(0)).alias('chargeback_amount'))

result_df.show()

#solution 2
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("transactions_1205")
t_df.show()

c_df = spark.read_table_as_df("chargebacks_1205")
c_df.show()

result_df = c_df.alias('c') \
    .join(t_df.alias('t'), on=F.col('c.trans_id') == F.col('t.id')) \
    .select(F.substring(F.col('charge_date'), 1, 7).alias('month'), 'country', 'amount',
            F.lit('chargeback').alias('state')) \
    .unionAll(t_df.select(F.substring(F.col('trans_date'), 1, 7).alias('month'), 'country', 'amount',
                       'state')) \
    .groupby('month', 'country') \
    .agg(F.count(F.when(F.col('state') == 'approved', 1)).alias('approved_count'),
         F.sum(F.when(F.col('state') == 'approved', F.col('amount')).otherwise(0)).alias('approved_amount'),
         F.count(F.when(F.col('state') == 'chargeback', 1)).alias('chargeback_count'),
         F.sum(F.when(F.col('state') == 'chargeback', F.col('amount')).otherwise(0)).alias('chargeback_amount'))

result_df.show()
```

### [1212. Team Scores in Football Tournament](https://www.jiakaobo.com/leetcode/1212.%20Team%20Scores%20in%20Football%20Tournament.html)

```python
#solution 1
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("teams_1212")
t_df.show()

m_df = spark.read_table_as_df("matches_1212")
m_df.show()
win = (((F.col('team_id') == F.col('host_team')) & (F.col('host_goals') > F.col('guest_goals')))
       | ((F.col('team_id') == F.col('guest_team')) & (F.col('guest_goals') > F.col('host_goals'))))
draw = (F.col('host_goals') == F.col('guest_goals'))

result_df = t_df.alias('t') \
            .join(m_df.alias('m'), on=(F.col('t.team_id')==F.col('m.host_team')) |
                                      (F.col('t.team_id')==F.col('m.guest_team')), how='left') \
            .groupby('team_id', 'team_name') \
            .agg(F.sum(F.when(win, 3).when(draw, 1).otherwise(0)).alias('num_points')) \
            .orderBy(F.desc('num_points'), F.asc('team_name'))

result_df.show()

#solution 2
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("teams_1212")
t_df.show()

m_df = spark.read_table_as_df("matches_1212")
m_df.show()

result_df = t_df.alias('t') \
            .join(m_df.alias('m'), on=(F.col('t.team_id')==F.col('m.host_team')) |
                                      (F.col('t.team_id')==F.col('m.guest_team')), how='left') \
            .groupby('team_id', 'team_name') \
            .agg(F.sum(F.when((F.col('team_id') == F.col('host_team')) &
                              (F.col('host_goals') > F.col('guest_goals')), 3)
                        .when((F.col('team_id') == F.col('guest_team')) &
                              (F.col('guest_goals') > F.col('host_goals')), 3)
                        .when((F.col('host_goals') == F.col('guest_goals')), 1)
                        .otherwise(0)).alias('num_points')) \
            .orderBy(F.desc('num_points'), F.asc('team_name'))

result_df.show()

#solution 3
import pyspark.sql.functions as F

t_df = spark.read_table_as_df("teams_1212")
t_df.show()

m_df = spark.read_table_as_df("matches_1212")
m_df.show()

result_df = t_df.alias('t') \
            .join(m_df.alias('m'), on=(F.col('t.team_id')==F.col('m.host_team')) |
                                      (F.col('t.team_id')==F.col('m.guest_team')), how='left') \
            .groupby('team_id', 'team_name') \
            .agg(F.sum(F.when((F.col('team_id') == F.col('host_team')) &
                              (F.col('host_goals') > F.col('guest_goals')), 3)
                        .when((F.col('team_id') == F.col('guest_team')) &
                              (F.col('guest_goals') > F.col('host_goals')), 3)
                        .when((F.col('team_id') == F.col('host_team'))
                              & (F.col('host_goals') == F.col('guest_goals')), 1)
                        .when((F.col('team_id') == F.col('guest_team'))
                              & (F.col('guest_goals') == F.col('host_goals')), 1)
                        .otherwise(0)).alias('num_points')) \
            .orderBy(F.desc('num_points'), F.asc('team_name'))

result_df.show()
```

### [1264. Page Recommendations](https://www.jiakaobo.com/leetcode/1264.%20Page%20Recommendations.html)

```python
from pyspark.sql import functions as F

f_df = spark.read_table_as_df("friendship_1264")
f_df.show()

l_df = spark.read_table_as_df("likes_1264")
l_df.show()

result_df = f_df.select('user_id1', 'user_id2') \
            .union(f_df.select(F.col('user_id2').alias('user_id1'), F.col('user_id1').alias('user_id2'))) \
            .alias('f') \
            .filter(F.col('user_id1') == 1) \
            .join(l_df.alias('l1'), on=F.col('f.user_id2') == F.col('l1.user_id'), how='inner') \
            .join(l_df.alias('l2'), on=(F.col('f.user_id1') == F.col('l2.user_id')) &
                                       (F.col('l1.page_id') == F.col('l2.page_id')), how='left_anti') \
            .select(F.col('page_id').alias('recommended_page')) \
            .distinct()

result_df.show()
```

### [1270. All People Report to the Given Manager](https://www.jiakaobo.com/leetcode/1270.%20All%20People%20Report%20to%20the%20Given%20Manager.html)

```python
from pyspark.sql import functions as F

e_df = spark.read_table_as_df("employees_1270")
e_df.show()

result_df = e_df.alias('e1') \
            .join(e_df.alias('e2'), on=F.col('e1.manager_id') == F.col('e2.employee_id')) \
            .join(e_df.alias('e3'), on=F.col('e2.manager_id') == F.col('e3.employee_id')) \
            .filter(((F.col('e1.manager_id') == 1) | (F.col('e2.manager_id') == 1) | (F.col('e3.manager_id') == 1)) &
                    (F.col('e1.employee_id') != 1)) \
            .select('e1.employee_id')

result_df.show()
```

### [1285. Find the Start and End Number of Continuous Ranges](https://www.jiakaobo.com/leetcode/1285.%20Find%20the%20Start%20and%20End%20Number%20of%20Continuous%20Ranges.html)

```python
from pyspark.sql import functions as F, Window as W

l_df = spark.read_table_as_df("logs_1285")
l_df.show()

wspec = W.orderBy('log_id')

result_df = l_df \
            .withColumn('num', F.row_number().over(wspec)) \
            .groupby(F.col('log_id') - F.col('num')) \
            .agg(F.min('log_id').alias('start_id'), F.max('log_id').alias('end_id')) \
            .select('start_id', 'end_id')

result_df.show()
```

### [1308. Running Total for Different Genders](https://www.jiakaobo.com/leetcode/1308.%20Running%20Total%20for%20Different%20Genders.html)

```python
from pyspark.sql import functions as F, Window as W

s_df = spark.read_table_as_df("scores_1308")
s_df.show()

wspec = W.partitionBy('gender').orderBy('day').rowsBetween(W.unboundedPreceding, W.currentRow)

result_df = s_df \
            .withColumn('total', F.sum('score_points').over(wspec)) \
            .orderBy('gender', 'day') \
            .select('gender', 'day', 'total')

result_df.show()
```

### [1321. Restaurant Growth](https://www.jiakaobo.com/leetcode/1321.%20Restaurant%20Growth.html)

```python
from pyspark.sql import functions as F, Window as W

c_df = spark.read_table_as_df("customer_1321")
c_df.show()

wspec = W.orderBy('visited_on').rowsBetween(-6, W.currentRow)

result_df = c_df \
            .groupby('visited_on').agg(F.sum('amount').alias('amount')) \
            .select('visited_on', F.sum('amount').over(wspec).alias('amount'),
                    F.round(F.avg('amount').over(wspec), 2).alias('average_amount'),
                    F.count('*').over(wspec).alias('count')) \
            .filter(F.col('count') == 7) \
            .select('visited_on', 'amount', 'average_amount')

result_df.show()
```

### [1341. Movie Rating](https://www.jiakaobo.com/leetcode/1341.%20Movie%20Rating.html)

```python
from pyspark.sql import functions as F

m_df = spark.read_table_as_df("movies_1341")
m_df.show()

u_df = spark.read_table_as_df("users_1341")
u_df.show()

mr_df = spark.read_table_as_df("movie_rating_1341")
mr_df.show()

result_df = u_df.alias('u') \
            .join(mr_df.alias('mr'), on=F.col('u.user_id') == F.col('mr.user_id')) \
            .groupby('name').agg(F.count('*').alias('ratings')) \
            .orderBy(F.desc('ratings'), F.asc('name')) \
            .select(F.col('name').alias('results')) \
            .limit(1) \
            .union(
             m_df.alias('m') \
            .join(mr_df.alias('mr'), on=F.col('m.movie_id') == F.col('mr.movie_id')) \
            .groupby('title').agg(F.avg('rating').alias('avg_rating')) \
            .orderBy(F.desc('avg_rating'), F.asc('title')) \
            .select(F.col('title').alias('results')) \
            .limit(1)
            )

result_df.show()
```

### [1355. Activity Participants](https://www.jiakaobo.com/leetcode/1355.%20Activity%20Participants.html)

```python
from pyspark.sql import functions as F, Window as W

a_df = spark.read_table_as_df("activities_1355")
a_df.show()

f_df = spark.read_table_as_df("friends_1355")
f_df.show()

wspec = W.orderBy('count').rowsBetween(W.unboundedPreceding, W.unboundedFollowing)

result_df = f_df \
    .groupby('activity') \
    .agg(F.count('*').alias('count')) \
    .withColumn('rank1', F.first('count').over(wspec)) \
    .withColumn('rank2', F.last('count').over(wspec)) \
    .filter((F.col('count') != F.col('rank1')) & (F.col('count') != F.col('rank2'))) \
    .select('activity')

result_df.show()
```

### [1364. Number of Trusted Contacts of a Customer](https://www.jiakaobo.com/leetcode/1364.%20Number%20of%20Trusted%20Contacts%20of%20a%20Customer.html)

```python
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
```

### [1393. Capital Gain/Loss](https://www.jiakaobo.com/leetcode/1393.%20Capital%20Gain%20Loss.html)

```python
from pyspark.sql import functions as F

s_df = spark.read_table_as_df("stocks_1393")
s_df.show()

result_df = s_df \
            .withColumn('price', F.when(F.col('operation')=='Buy', -F.col('price')).otherwise(F.col('price'))) \
            .groupby('stock_name').agg(F.sum('price'))

result_df.show()
```

### [1398. Customers Who Bought Products A and B but Not C](https://www.jiakaobo.com/leetcode/1398.%20Customers%20Who%20Bought%20Products%20A%20and%20B%20but%20Not%20C.html)

```python

#solution 1
from pyspark.sql import functions as F

o_df = spark.read_table_as_df("orders_1398")
o_df.show()

c_df = spark.read_table_as_df("customers_1398")
c_df.show()

result_df = o_df \
            .join(c_df, on='customer_id') \
            .groupby('customer_id', 'customer_name') \
            .agg(F.count(F.when(F.col('product_name')=='A', True)).alias('A_count'),
                 F.count(F.when(F.col('product_name')=='B', True)).alias('B_count'),
                 F.count(F.when(F.col('product_name')=='C', True)).alias('C_count')) \
            .filter((F.col('A_count')>0) & (F.col('B_count')>0) & (F.col('C_count')==0)) \
            .select('customer_id', 'customer_name')

result_df.show()

#solution 2
from pyspark.sql import functions as F

o_df = spark.read_table_as_df("orders_1398")
o_df.show()

c_df = spark.read_table_as_df("customers_1398")
c_df.show()

result_df = o_df.alias('o1') \
            .join(o_df.alias('o2'), on=((F.col('o1.customer_id') == F.col('o2.customer_id')) &
                                        (F.col('o2.product_name') == 'C')), how='left_anti') \
            .select('customer_id') \
            .intersect(
                o_df.filter(F.col('product_name') == 'A').select('customer_id') \
                    .intersect(o_df.filter(F.col('product_name') == 'B').select('customer_id'))
                        ) \
            .join(c_df, on='customer_id')

result_df.show()
```

### [1440. Evaluate Boolean Expression](https://www.jiakaobo.com/leetcode/1440.%20Evaluate%20Boolean%20Expression.html)

```python
from pyspark.sql import functions as F

e_df = spark.read_table_as_df("expressions_1440")
e_df.show()

result_df = e_df \
    .withColumn('value', F.when(F.col('operator') == '>', F.col('left_operand') > F.col('right_operand'))
                        .when(F.col('operator') == '<', F.col('left_operand') < F.col('right_operand'))
                        .when(F.col('operator') == '=', F.col('left_operand') == F.col('right_operand')))

result_df.show()
```

### [1445. Apples & Oranges](https://www.jiakaobo.com/leetcode/1445.%20Apples%20&%20Oranges.html)

```python
from pyspark.sql import functions as F

s_df = spark.read_table_as_df("sales_1445")
s_df.show()

result_df = s_df \
            .groupby('sale_date') \
            .agg((F.count(F.when(F.col('fruit')=='apples', True)) - F.count(F.when(F.col('fruit')=='oranges', True))).alias('diff'))

result_df.show()
\
```

### [1454. Active Users](https://www.jiakaobo.com/leetcode/1454.%20Active%20Users.html)

```python
#solution 1
from pyspark.sql import functions as F, Window as W

a_df = spark.read_table_as_df("accounts_1454")
a_df.show()

l_df = spark.read_table_as_df("logins_1454")
l_df.show()

wspec = W.partitionBy('id').orderBy('login_date')

result_df = l_df \
    .dropDuplicates() \
    .withColumn('rnk', F.row_number().over(wspec)) \
    .groupby('id', F.col('login_date') - F.col('rnk')).agg(F.count('*').alias('consecutive_logins')) \
    .filter(F.col('consecutive_logins') >= 5) \
    .join(a_df, on='id') \
    .select('id', 'name')

result_df.show()
```

```python
#solution 2
from pyspark.sql import functions as F, Window as W

a_df = spark.read_table_as_df("accounts_1454")
a_df.show()

l_df = spark.read_table_as_df("logins_1454")
l_df.show()

wspec = W.partitionBy('id').orderBy('login_date')

result_df = l_df \
        .withColumn('days_since_last_login', (F.col('login_date') - F.lag('login_date', 1).over(wspec))
                            .cast('int')) \
        .fillna(1, 'days_since_last_login') \
        .groupby('id').agg(F.count(F.when(F.col('days_since_last_login') == 1, True)).alias('consecutive_logins')) \
        .filter(F.col('consecutive_logins') >= 5) \
        .join(a_df, on='id') \
        .select('id', 'name')

result_df.show()
```

### [1459. Rectangles Area](https://www.jiakaobo.com/leetcode/1459.%20Rectangles%20Area.html)

```python
from pyspark.sql import functions as F

p_df = spark.read_table_as_df("points_1459")
p_df.show()

result_df = p_df.alias('p1') \
            .join(p_df.alias('p2'), on=(F.col('p1.id') < F.col('p2.id')) &
                                       (F.col('p1.x_value') != F.col('p2.x_value')) &
                                       (F.col('p1.y_value') != F.col('p2.y_value'))) \
            .withColumn('area', F.abs(F.col('p1.x_value') - F.col('p2.x_value')) *
                        F.abs(F.col('p1.y_value') - F.col('p2.y_value'))) \
            .select(F.col('p1.id').alias('p1'), F.col('p2.id').alias('p2'), 'area')

result_df.show()
```

### [1468. Calculate Salaries](https://www.jiakaobo.com/leetcode/1468.%20Calculate%20Salaries.html)

```python
from pyspark.sql import functions as F, Window as W

w_spec = W.partitionBy('company_id')

s_df = spark.read_table_as_df("salaries_1468")
s_df.show()

result_df = s_df \
    .withColumn('max_salary', F.max('salary').over(w_spec)) \
    .withColumn('salary', F.when(F.col('max_salary') > 10000, F.round(F.col('salary') - F.col('salary')*0.49,0))
                .when(F.col('max_salary') >= 1000, F.round(F.col('salary') - F.col('salary')*0.24, 0))
                .otherwise(F.col('salary'))) \
                .select('company_id', 'employee_id', 'employee_name', 'salary')

result_df.show()
```

### [1501. Countries You Can Safely Invest In](https://www.jiakaobo.com/leetcode/1501.%20Countries%20You%20Can%20Safely%20Invest%20In.html)

```python
#solution 1
from pyspark.sql import functions as F

p_df = spark.read_table_as_df("person_1501")
p_df.show()

ct_df = spark.read_table_as_df("country_1501")
ct_df.show()

c_df = spark.read_table_as_df("calls_1501")
c_df.show()

global_avg_duration = c_df.agg(F.avg("duration").alias("global_avg")).collect()[0]["global_avg"]
print(global_avg_duration)

result_df = ct_df.alias('ct') \
            .join(p_df.alias('p'), on=F.col('country_code')==F.substring(F.col('phone_number'),1, 3)) \
            .join(c_df.alias('c'), on=(F.col('caller_id')==F.col('p.id')) | (F.col('callee_id')==F.col('p.id'))) \
            .groupby('ct.name').agg(F.avg('duration').alias('total_duration')) \
            .filter(F.col('total_duration') > global_avg_duration) \
            .select(F.col('name').alias('country'))

result_df.show()

#solution 2
from pyspark.sql import functions as F

p_df = spark.read_table_as_df("person_1501")
p_df.show()

ct_df = spark.read_table_as_df("country_1501")
ct_df.show()

c_df = spark.read_table_as_df("calls_1501")
c_df.show()

global_avg_duration = c_df.agg(F.avg("duration").alias("global_avg")).collect()[0]["global_avg"]

print(global_avg_duration)
result_df = c_df.select(F.col('caller_id').alias('caller'), 'duration') \
            .unionAll(c_df.select(F.col('callee_id').alias('caller'), 'duration')) \
            .join(p_df, on=F.col('caller') == F.col('id')) \
            .join(ct_df.alias('ct'), on=F.substring(F.col('phone_number'),1, 3)==F.col('country_code')) \
            .groupby('ct.name').agg(F.avg('duration').alias('avg')) \
            .filter(F.col('avg') > global_avg_duration) \
            .select(F.col('name').alias('country'))

result_df.show()
```

### [1532. The Most Recent Three Orders](https://www.jiakaobo.com/leetcode/1532.%20The%20Most%20Recent%20Three%20Orders.html)

```python
from pyspark.sql import functions as F, Window as W

c_df = spark.read_table_as_df("customers_1532")
c_df.show()

o_df = spark.read_table_as_df("orders_1532")
o_df.show()

w_spec = W.partitionBy('customer_id').orderBy(F.desc('order_date'))

result_df = o_df \
            .join(c_df, on='customer_id') \
            .withColumn('rnk', F.rank().over(w_spec)) \
            .filter(F.col('rnk') <= 3) \
            .orderBy(F.asc('name'), F.asc('customer_id'), F.desc('order_date')) \
            .select(F.col('name').alias('customer_name'), 'customer_id', 'order_id', 'order_date')

result_df.show()
```

### [1549. The Most Recent Orders for Each Product](https://www.jiakaobo.com/leetcode/1549.%20The%20Most%20Recent%20Orders%20for%20Each%20Product.html)

```python
from pyspark.sql import functions as F, Window as W

w_spec = W.partitionBy('product_id').orderBy(F.desc('order_date'))

o_df = spark.read_table_as_df("orders_1549")
o_df.show()

p_df = spark.read_table_as_df("products_1549")
p_df.show()

result_df = p_df \
            .join(o_df, on='product_id') \
            .withColumn('rnk', F.rank().over(w_spec)) \
            .filter(F.col('rnk') == 1) \
            .select('product_name', 'product_id', 'order_id', 'order_date')

result_df.show()
```

### [1555. Bank Account Summary](https://www.jiakaobo.com/leetcode/1555.%20Bank%20Account%20Summary.html)

```python
from pyspark.sql import functions as F

u_df = spark.read_table_as_df("users_1555")
u_df.show()

t_df = spark.read_table_as_df("transactions_1555")
t_df.show()

result_df = u_df \
            .join(t_df, on=(F.col('user_id')==F.col('paid_by')) | (F.col('user_id')==F.col('paid_to')), how='left') \
            .groupby('user_id', 'credit', 'user_name') \
            .agg((F.sum(F.when(F.col('user_id') == F.col('paid_by'),
                              -F.col('amount')).otherwise(F.col('amount'))) + F.col('credit')).alias('balance')) \
            .withColumn('credit', F.ifnull(F.col('balance'), F.col('credit'))) \
            .withColumn('credit_limit_breached', F.when(F.col('credit') < 0, 'Yes').otherwise('No')) \
            .select('user_id', 'user_name', 'credit', 'credit_limit_breached')

result_df.show()
```

### [1596. The Most Frequently Ordered Products for Each Customer](https://www.jiakaobo.com/leetcode/1596.%20The%20Most%20Frequently%20Ordered%20Products%20for%20Each%20Customer.html) 

```python
#solution 1
from pyspark.sql import functions as F, Window as W

w_spec = W.partitionBy('customer_id').orderBy(F.desc(F.count('*')))

o_df = spark.read_table_as_df("orders_1596")
o_df.show()

p_df = spark.read_table_as_df("products_1596")
p_df.show()

result_df = o_df \
            .groupBy('customer_id', 'product_id') \
            .agg((F.rank().over(w_spec)).alias('rank')) \
            .filter(F.col('rank') == 1) \
            .join(p_df, on='product_id') \
            .select('customer_id', 'product_id', 'product_name') \
            .orderBy('customer_id')

result_df.show()

#solution 2
from pyspark.sql import functions as F, Window as W

w_spec = W.partitionBy('customer_id').orderBy(F.desc('prod_count'))

o_df = spark.read_table_as_df("orders_1596")
o_df.show()

p_df = spark.read_table_as_df("products_1596")
p_df.show()

result_df = o_df \
            .groupBy('customer_id', 'product_id') \
            .agg(F.count('*').alias('prod_count')) \
            .withColumn('rank', F.rank().over(w_spec)) \
            .filter(F.col('rank') == 1) \
            .join(p_df, on='product_id') \
            .select('customer_id', 'product_id', 'product_name') \
            .orderBy('customer_id')

result_df.show()
```

### [1613. Find the Missing IDs](https://www.jiakaobo.com/leetcode/1613.%20Find%20the%20Missing%20IDs.html) 

```python

```

### [1699. Number of Calls Between Two Persons](https://www.jiakaobo.com/leetcode/1699.%20Number%20of%20Calls%20Between%20Two%20Persons.html) 

```python
#solution1
from pyspark.sql import functions as F

c_df = spark.read_table_as_df("calls_1699")
c_df.show()

result_df = c_df \
            .groupby(F.least('from_id', 'to_id').alias('person1'),
                     F.greatest('from_id', 'to_id').alias('person2')) \
            .agg(F.count('*').alias('call_count'), F.sum('duration').alias('total_duration'))

result_df.show()

#solution 2
from pyspark.sql import functions as F

c_df = spark.read_table_as_df("calls_1699")
c_df.show()

result_df = c_df \
            .unionAll(c_df.select(F.col('to_id').alias('from_id'), F.col('from_id').alias('to_id'), 'duration')) \
            .filter(F.col('from_id') < F.col('to_id')) \
            .groupby('from_id', 'to_id') \
            .agg(F.count('*').alias('call_count'), F.sum('duration').alias('total_duration')) \
            .select([F.col('from_id').alias('person1'), F.col('from_id').alias('person2'), 'call_count', 'total_duration'])

result_df.show()

```

### [1709. Biggest Window Between Visits](https://www.jiakaobo.com/leetcode/1709.%20Biggest%20Window%20Between%20Visits.html) 

```python
from pyspark.sql import functions as F, Window as W

uv_df = spark.read_table_as_df("user_visits_1709")
uv_df.show()

w_spec = W.partitionBy('user_id').orderBy('visit_date')
result_df = uv_df \
            .withColumn('window',
                        F.lead('visit_date', 1, '2021-01-01').over(w_spec) - F.col('visit_date')) \
            .groupby('user_id').agg(F.max('window').cast('int').alias('biggest_window'))

result_df.show()
```

### [1715. Count Apples and Oranges](https://www.jiakaobo.com/leetcode/1715.%20Count%20Apples%20and%20Oranges.html) 

```python
from pyspark.sql import functions as F

b_df = spark.read_table_as_df("boxes_1715")
b_df.show()

c_df = spark.read_table_as_df("chests_1715")
c_df.show()

result_df = b_df.alias('b') \
            .join(c_df.alias('c'), on='chest_id', how='left') \
            .select((F.sum('b.apple_count') + F.sum('c.apple_count')).alias('apple_count'),
                    (F.sum('b.orange_count') + F.sum('c.orange_count')).alias('orange_count'))

result_df.show()
```

### [1747. Leetflex Banned Accounts](https://www.jiakaobo.com/leetcode/1747.%20Leetflex%20Banned%20Accounts.html) 

```python
from pyspark.sql import functions as F

l_df = spark.read_table_as_df("log_info_1747")
l_df.show()

result_df = l_df.alias('l1') \
            .join(l_df.alias('l2'), on=(F.col('l1.account_id') == F.col('l2.account_id'))
                                        & (F.col('l1.ip_address') != F.col('l2.ip_address'))
                                        & (F.col('l2.login').between(F.col('l1.login'), F.col('l1.logout')))) \
            .select('account_id')

result_df.show()
```

### [1783. Grand Slam Titles](https://www.jiakaobo.com/leetcode/1783.%20Grand%20Slam%20Titles.html) 

```python
from pyspark.sql import functions as F

p_df = spark.read_table_as_df("players_1783")
p_df.show()

c_df = spark.read_table_as_df("championships_1783")
c_df.show()

result_df = p_df \
            .join(c_df, on=(F.col('player_id') == F.col('Wimbledon')) | (F.col('player_id') == F.col('Fr_open'))
                            | (F.col('player_id') == F.col('US_open')) | (F.col('player_id') == F.col('Au_open'))) \
            .groupby('player_id', 'player_name') \
            .agg((F.sum(F.when(F.col('player_id') == F.col('wimbledon'), 1).otherwise(0)
                        + F.when(F.col('player_id') == F.col('fr_open'), 1).otherwise(0)
                        + F.when(F.col('player_id') == F.col('us_open'), 1).otherwise(0)
                        + F.when(F.col('player_id') == F.col('au_open'), 1).otherwise(0)))
                 .alias('grand_slams_count'))
```

### [1811. Find Interview Candidates](https://www.jiakaobo.com/leetcode/1811.%20Find%20Interview%20Candidates.html) 

```python

```

### [1831. Maximum Transaction Each Day](https://www.jiakaobo.com/leetcode/1831.%20Maximum%20Transaction%20Each%20Day.html) 

```python
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("transactions_1831")
t_df.show()

w_spec = W.partitionBy(F.date_format('day', 'yyyy-MM-dd')).orderBy(F.desc('amount'))

result_df = t_df \
            .withColumn('rnk', F.rank().over(w_spec)) \
            .filter(F.col('rnk') == 1) \
            .select('transactions_id') \
            .orderBy('transactions_id')

result_df.show()
```

### [1841. League Statistics](https://www.jiakaobo.com/leetcode/1841.%20League%20Statistics.html) 

```python
from pyspark.sql import functions as F

t_df = spark.read_table_as_df("teams_1841")
t_df.show()

m_df = spark.read_table_as_df("matches_1841")
m_df.show()

is_home_team = (F.col('team_id') == F.col('home_team_id'))
is_away_team = (F.col('team_id') == F.col('away_team_id'))

win = ((is_home_team & (F.col('home_team_goals') > F.col('away_team_goals')))
        | (is_away_team & (F.col('away_team_goals') > F.col('home_team_goals'))))
draw = (F.col('home_team_goals') == F.col('away_team_goals'))



result_df = t_df \
            .join(m_df, on=(F.col('team_id') == F.col('home_team_id'))
                            | (F.col('team_id') == F.col('away_team_id'))) \
            .groupby('team_name') \
            .agg(F.count('*').alias('matches_played'),
                 F.sum(F.when(win, 3).when(draw, 1).otherwise(0)).alias('points'),
                 F.sum((F.when(is_home_team, F.col('home_team_goals'))
                        .when(is_away_team, F.col('away_team_goals')))).alias('goal_for'),
                 F.sum((F.when(is_home_team, F.col('away_team_goals'))
                        .when(is_away_team, F.col('home_team_goals')))).alias('goal_against'),
                 ) \
            .withColumn('goal_diff', F.col('goal_for') - F.col('goal_against')) \
            .orderBy(F.desc('goal_diff'))


result_df.show()

```

### [1843. Suspicious Bank Accounts](https://www.jiakaobo.com/leetcode/1843.%20Suspicious%20Bank%20Accounts.html) 

```python
#solution 1

from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("transactions_1843")
t_df.show()

a_df = spark.read_table_as_df("accounts_1843")
a_df.show()

df = t_df \
    .groupby('account_id', F.date_format('day', 'yyyy-MM').alias('month')) \
    .agg(F.sum('amount').alias('spent')) \
    .join(a_df, on='account_id') \
    .filter(F.col('spent') > F.col('max_income')) \

result_df = df.alias('d1').join(df.alias('d2'),
                                on=(F.col('d1.account_id')==F.col('d2.account_id'))
                                    & (F.col('d2.month') == F.add_months(F.col('d1.month'), 1))) \
            .select('d1.account_id').dropDuplicates()

result_df.show()
```

```python
#solution 2
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("transactions_1843")
t_df.show()

a_df = spark.read_table_as_df("accounts_1843")
a_df.show()

w_spec = W.partitionBy('account_id').orderBy('month')

result_df = t_df \
            .groupby('account_id', F.date_format('day', 'yyyy-MM').alias('month')) \
            .agg(F.sum(F.when(F.col('type')=='Creditor', F.col('amount')).otherwise(0)).alias('spent')) \
            .join(a_df, on='account_id') \
            .filter(F.col('spent') > F.col('max_income')) \
            .withColumn('rank', F.row_number().over(w_spec)) \
            .groupby('account_id', F.add_months('month', -F.col('rank'))) \
            .agg(F.count('*').alias('consecutive_months')) \
            .filter(F.col('consecutive_months') >= 2) \
            .select('account_id').dropDuplicates()

result_df.show()
```

### [1867. Orders With Maximum Quantity Above Average](https://www.jiakaobo.com/leetcode/1867.%20Orders%20With%20Maximum%20Quantity%20Above%20Average.html) 

```python
from pyspark.sql import functions as F

o_df = spark.read_table_as_df("orders_details_1867")
o_df.show()

aggregated_df = o_df.groupby('order_id') \
                .agg((F.sum('quantity') / F.countDistinct('product_id')).alias('average_quantity'),
                        F.max('quantity').alias('max_quantity'))

max_avg_quantity = aggregated_df \
                    .select(F.max('average_quantity').alias('max_avg_quantity')).collect()[0]['max_avg_quantity']

result_df = aggregated_df \
            .filter(F.col('max_quantity') > max_avg_quantity) \
            .select('order_id')

result_df.show()
```

### [1875. Group Employees of the Same Salary](https://www.jiakaobo.com/leetcode/1875.%20Group%20Employees%20of%20the%20Same%20Salary.html) 

```python
#solution 1
from pyspark.sql import functions as F, Window as W

e_df = spark.read_table_as_df("employees_1875")
e_df.show()

w_spec = W.orderBy('salary')

result_df = e_df.alias('e1') \
            .join(e_df.alias('e2'), on=(F.col('e1.salary') == F.col('e2.salary'))
                                        & (F.col('e1.employee_id') != F.col('e2.employee_id')), how='semi') \
            .withColumn('team_id', F.dense_rank().over(w_spec)) \
            .orderBy('team_id', 'employee_id')


result_df.show()


#solution 2
from pyspark.sql import functions as F, Window as W

e_df = spark.read_table_as_df("employees_1875")
e_df.show()

e_agg_df = e_df \
        .groupby('salary').agg(F.count('*').alias('salary_count')) \
        .filter(F.count('*') > 1)

e_agg_df.show()

w_spec = W.orderBy('salary')

result_df = e_df \
            .join(e_agg_df, on='salary', how='semi') \
            .withColumn('team_id', F.dense_rank().over(w_spec)) \
            .select('employee_id', 'name', 'salary', 'team_id')

result_df.show()
```

### [1907. Count Salary Categories](https://www.jiakaobo.com/leetcode/1907.%20Count%20Salary%20Categories.html) 

```python
from pyspark.sql import functions as F

a_df = spark.read_table_as_df("accounts_1907")
a_df.show()

c_df = spark.spark.createDataFrame([("Low Salary",), ("Average Salary",), ("High Salary",)], ["category"])

c_df.show()

result_df = a_df \
            .withColumn('category', F.when(F.col('income') > 50000, 'High Salary') \
                                    .when(F.col('income') >= 20000, 'Average Salary') \
                                    .otherwise('Low Salary')) \
            .join(c_df, on='category', how='right') \
            .groupby('category').agg(F.count('account_id').alias('accounts_count'))

result_df.show()
```

### [1934. Confirmation Rate](https://www.jiakaobo.com/leetcode/1934.%20Confirmation%20Rate.html) 

```python
from pyspark.sql import functions as F

s_df = spark.read_table_as_df("signups_1934")
s_df.show()

c_df = spark.read_table_as_df("confirmations_1934")
c_df.show()

result_df = s_df \
            .join(c_df, on='user_id', how='left') \
            .groupby('user_id') \
            .agg((F.round(F.sum(F.when(F.col('action') == 'confirmed', 1).otherwise(0))/F.count('*'), 2))
                 .alias('confirmation_rate'))

result_df.show()
```

### [1949. Strong Friendship](https://www.jiakaobo.com/leetcode/1949.%20Strong%20Friendship.html) 

```python
from pyspark.sql import functions as F

f_df = spark.read_table_as_df("friendship_1949")
f_df.show()

"""we are doing a self join f1.u2 = f2.u1. so any matches we get are mutual friends of f1.u1 and f1.u2.
but this is only accurate if the table has all possible friend combos. so if the table has an entry for 2,3
but no entry for 3,2 then you can't find mutual friends accurately, that's why we do the join"""

f_df = f_df \
        .union(f_df.select(F.col('user2_id').alias('user1_id'), F.col('user1_id').alias('user2_id')))

f_df.show()

result_df = f_df.alias('f1') \
            .join(f_df.alias('f2'), on=(F.col('f1.user2_id') == F.col('f2.user1_id'))
                                        & (F.col('f2.user2_id') != F.col('f1.user1_id'))) \
            .join(f_df.alias('f3'), on=(F.col('f1.user1_id') == F.col('f3.user1_id'))
                                        & (F.col('f2.user2_id') == F.col('f3.user2_id'))) \
            .filter(F.col('f1.user1_id') < F.col('f1.user2_id')) \
            .groupby(F.col('f1.user1_id'), F.col('f1.user2_id')) \
            .agg(F.count('*').alias('common_friend')) \
            .filter(F.col('common_friend') >= 3)

result_df.show()
```

### [1951. All the Pairs With the Maximum Number of Common Followers](https://www.jiakaobo.com/leetcode/1951.%20All%20the%20Pairs%20With%20the%20Maximum%20Number%20of%20Common%20Followers.html) 

```python
from pyspark.sql import functions as F, Window as W

r_df = spark.read_table_as_df("relations_1951")
r_df.show()

w_spec = W.orderBy(F.desc('common'))

result_df = r_df.alias('r1') \
            .join(r_df.alias('r2'), on=(F.col('r1.follower_id') == F.col('r2.follower_id'))
                                        & (F.col('r1.user_id') != F.col('r2.user_id'))
                                        & (F.col('r1.user_id') < F.col('r2.user_id'))) \
            .groupby('r1.user_id', 'r2.user_id').agg(F.count('*').alias('common')) \
            .withColumn('rank', F.rank().over(w_spec)) \
            .filter(F.col('rank') == 1) \
            .select(F.col('r1.user_id').alias('user1_id'), F.col('r2.user_id').alias('user2_id'))
```

### [1988. Find Cutoff Score for Each School](https://www.jiakaobo.com/leetcode/1988.%20Find%20Cutoff%20Score%20for%20Each%20School.html) 

```python
from pyspark.sql import functions as F

s_df = spark.read_table_as_df("school_1988")
s_df.show()

e_df = spark.read_table_as_df("exam_1988")
e_df.show()

result_df = s_df \
            .join(e_df, on=F.col('capacity') > F.col('student_count'), how='left') \
            .groupby('school_id').agg(F.ifnull(F.min('score'), F.lit(-1)).alias('score'))

result_df.show()
```

### [1990. Count the Number of Experiments](https://www.jiakaobo.com/leetcode/1990.%20Count%20the%20Number%20of%20Experiments.html) 

```python
from pyspark.sql import functions as F

e_df = spark.read_table_as_df("experiments_1990")
e_df.show()

cross_df = e_df.select('platform').distinct().crossJoin(e_df.select('experiment_name').distinct())

result_df = cross_df.alias('c') \
            .join(e_df.alias('e'), on=(F.col('c.platform') == F.col('e.platform'))
                                        & (F.col('c.experiment_name') == F.col('e.experiment_name')), how='left') \
            .groupby(F.col('c.platform'), F.col('c.experiment_name')) \
             .agg(F.count('e.experiment_name').alias('num_experiments')) \
            .orderBy('platform')

    result_df.show()
```

### [2020. Number of Accounts That Did Not Stream](https://www.jiakaobo.com/leetcode/2020.%20Number%20of%20Accounts%20That%20Did%20Not%20Stream.html) 

```python
from pyspark.sql import functions as F

su_df = spark.read_table_as_df("subscriptions_2020")
su_df.show()

s_df = spark.read_table_as_df("streams_2020")
s_df.show()

result_df = su_df.alias('su') \
            .filter((F.date_format('start_date', 'yyyy') <= 2021)
                    & (F.date_format('end_date', 'yyyy') >= 2021)) \
            .join(s_df.alias('s'), on=(F.col('su.account_id') == F.col('s.account_id'))
                                        & (F.date_format('stream_date', 'yyyy') == 2021), how='left') \
            .filter(F.col('session_id').isNull()) \
            .select('su.account_id')

result_df.show()
```

### [2041. Accepted Candidates From the Interviews](https://www.jiakaobo.com/leetcode/2041.%20Accepted%20Candidates%20From%20the%20Interviews.html) 

```python
from pyspark.sql import functions as F

c_df = spark.read_table_as_df("candidates_2041")
c_df.show()

r_df = spark.read_table_as_df("rounds_2041")
r_df.show()

result_df = c_df \
            .filter(F.col('years_of_exp') >= 2) \
            .join(r_df, on='interview_id') \
            .groupby('candidate_id').agg(F.sum('score').alias('total_score')) \
            .filter(F.col('total_score') > 15) \
            .select('candidate_id')

result_df.show()
```

### [2051. The Category of Each Member in the Store](https://www.jiakaobo.com/leetcode/2051.%20The%20Category%20of%20Each%20Member%20in%20the%20Store.html) 

```python
from pyspark.sql import functions as F

m_df = spark.read_table_as_df("members_2051")
m_df.show()

v_df = spark.read_table_as_df("visits_2051")
v_df.show()

p_df = spark.read_table_as_df("purchases_2051")
p_df.show()

result_df = m_df \
            .join(v_df, on='member_id', how='left') \
            .join(p_df, on='visit_id', how='left') \
            .groupby('member_id', 'name') \
            .agg((100*F.count('charged_amount')/F.count('visit_id')).alias('conversion_rate')) \
            .select('member_id', 'name', (F.when(F.col('conversion_rate') >= 80, 'Diamond')
                                            .when(F.col('conversion_rate') >= 50, 'Gold')
                                            .when(F.col('conversion_rate') < 50, 'Silver')
                                            .otherwise('Bronze')).alias('category'))

result_df.show()
```

### [2066. Account Balance](https://www.jiakaobo.com/leetcode/2066.%20Account%20Balance.html) 

```python
#solution 1
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("transactions_2066")
t_df.show()

w_spec = W.partitionBy('account_id').orderBy('day')

result_df = t_df \
            .withColumn('balance',  F.sum(F.when(F.col('type') == 'Withdraw', -F.col('amount'))
                                          .otherwise(F.col('amount'))).over(w_spec)) \
            .select('account_id', 'day', 'balance')

result_df.show()

#solution 2
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("transactions_2066")
t_df.show()

w_spec = W.partitionBy('account_id').orderBy('day')

result_df = t_df \
            .withColumn('amount', F.when(F.col('type') == 'Withdraw', -F.col('amount')).otherwise(F.col('amount')))\
            .withColumn('balance',  F.sum('amount').over(w_spec)) \
            .select('account_id', 'day', 'balance')

result_df.show()
```

### [2084. Drop Type 1 Orders for Customers With Type 0 Orders](https://www.jiakaobo.com/leetcode/2084.%20Drop%20Type%201%20Orders%20for%20Customers%20With%20Type%200%20Orders.html) 

```python
#solution 1
from pyspark.sql import functions as F

o_df = spark.read_table_as_df("orders_2084")
o_df.show()

result_df = o_df.alias('o1') \
            .join(o_df.alias('o2'), on=(F.col('o1.customer_id') == F.col('o2.customer_id'))
                                    & (F.col('o1.order_type') != F.col('o2.order_type')), how='left') \
            .filter((F.col('o2.order_type').isNull()) | (F.col('o2.order_type') == 1)) \
            .select('o1.order_id', 'o1.customer_id', 'o1.order_type')

result_df.show()

#solution 2
from pyspark.sql import functions as F

o_df = spark.read_table_as_df("orders_2084")
o_df.show()

result_df = o_df.alias('o1') \
            .groupby('customer_id') \
            .agg(F.min('order_type').alias('min_order')) \
            .join(o_df.alias('o2'), on=(F.col('o1.customer_id')==F.col('o2.customer_id'))
                                        & (F.col('min_order')==F.col('o2.order_type'))) \
            .select('o2.order_id', 'o2.customer_id', 'o2.order_type')

result_df.show()
```

### [2112. The Airport With the Most Traffic](https://www.jiakaobo.com/leetcode/2112.%20The%20Airport%20With%20the%20Most%20Traffic.html) 

```python
from pyspark.sql import functions as F, Window as W

f_df = spark.read_table_as_df("flights_2112")
f_df.show()

w_spec = W.orderBy(F.desc('total_flights_count'))

result_df = f_df \
            .select(F.col('departure_airport').alias('airport_id'), 'flights_count') \
            .unionAll(f_df.select(F.col('departure_airport').alias('airport_id'), 'flights_count')) \
            .groupby('airport_id').agg(F.sum(F.col('flights_count')).alias('total_flights_count')) \
            .withColumn('rank', F.rank().over(w_spec)) \
            .filter(F.col('rank') == 1) \
            .select('airport_id')

result_df.show()
```

### [2142. The Number of Passengers in Each Bus I](https://www.jiakaobo.com/leetcode/2142.%20The%20Number%20of%20Passengers%20in%20Each%20Bus%20I.html) 

```python
from pyspark.sql import functions as F, Window as W

b_df = spark.read_table_as_df("buses_2142")
b_df.show()

p_df = spark.read_table_as_df("passengers_2142")
p_df.show()

w_spec = W.partitionBy('passenger_id').orderBy('b.arrival_time')

result_df = p_df.alias('p') \
            .join(b_df.alias('b'), on=F.col('p.arrival_time') <= F.col('b.arrival_time')) \
            .withColumn('rnk', F.rank().over(w_spec)) \
            .filter(F.col('rnk') == 1) \
            .join(b_df, on='bus_id', how='right') \
            .groupby('bus_id').agg(F.count('passenger_id').alias('passengers_cnt')) \
            .orderBy('bus_id')

result_df.show()
```

```python
from pyspark.sql import functions as F

b_df = spark.read_table_as_df("buses_2142")
b_df.show()

p_df = spark.read_table_as_df("passengers_2142")
p_df.show()

first_bus_df = p_df.alias('p') \
            .join(b_df.alias('b'), on=F.col('p.arrival_time') <= F.col('b.arrival_time')) \
            .groupby('passenger_id').agg(F.min('b.arrival_time').alias('arrival_time'))

result_df = b_df.join(first_bus_df, on='arrival_time', how='left') \
            .groupby('bus_id').agg(F.count('passenger_id').alias('passengers_cnt'))

result_df.show()
```

### [2159. Order Two Columns Independently](https://www.jiakaobo.com/leetcode/2159.%20Order%20Two%20Columns%20Independently.html) 

```python
from pyspark.sql import functions as F, Window as W

d_df = spark.read_table_as_df("data_2159")
d_df.show()

d1_df = d_df \
        .select('first_col') \
        .withColumn('order', F.row_number().over(W.orderBy('first_col')))

d2_df = d_df \
        .select('second_col') \
        .withColumn('order', F.row_number().over(W.orderBy(F.desc('second_col'))))

result_df = d1_df \
            .join(d2_df, on='order') \
            .select('first_col', 'second_col')

result_df.show()
```

### [2175. The Change in Global Rankings](https://www.jiakaobo.com/leetcode/2175.%20The%20Change%20in%20Global%20Rankings.html) 

```python
#solution 1
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("team_points_2175")
t_df.show()

p_df = spark.read_table_as_df("points_change_2175")
p_df.show()

a_df = t_df \
        .join(p_df, on='team_id') \
        .withColumn('rank_diff', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name'))) -
                                F.row_number().over(W.orderBy(F.desc(F.col('points') + F.col('points_change')),
                                                              F.asc('name')))) \
        .select('team_id', 'name', 'rank_diff')

a_df.show()

#solution 2
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("team_points_2175")
t_df.show()

p_df = spark.read_table_as_df("points_change_2175")
p_df.show()

a_df = t_df \
        .withColumn('rank1', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name')))) \
        .join(p_df, on='team_id') \
        .withColumn('points', F.col('points') + F.col('points_change')) \
        .withColumn('rank2', F.row_number().over(W.orderBy(F.desc('points'), F.asc('name')))) \
        .withColumn('rank_diff', F.col('rank2') - F.col('rank1')) \
        .select('team_id', 'name', 'rank_diff')

a_df.show()
```

### [2228. Users With Two Purchases Within Seven Days](https://www.jiakaobo.com/leetcode/2228.%20Users%20With%20Two%20Purchases%20Within%20Seven%20Days.html) 

```python

#solution 1
from pyspark.sql import functions as F, Window as W

p_df = spark.read_table_as_df("purchases_2228")
p_df.show()

result_df = p_df.alias('p1') \
            .join(p_df.alias('p2'), on=(F.col('p1.user_id') == F.col('p2.user_id'))
                                        & (F.col('p1.purchase_id') != F.col('p2.purchase_id'))
                                        & (F.datediff(F.col('p2.purchase_date'), F.col('p1.purchase_date')) <= 7)) \
            .select(F.col('p1.user_id')).distinct()

result_df.show()
```

```python
#solution 2
from pyspark.sql import functions as F, Window as W

p_df = spark.read_table_as_df("purchases_2228")
p_df.show()

w_spec = W.partitionBy('user_id').orderBy('purchase_date')

result_df = p_df \
            .withColumn('days_since_last_purchase', (F.col('purchase_date') - F.lag('purchase_date').over(w_spec))
                                                    .cast('int')) \
            .filter(F.col('days_since_last_purchase') <= 7) \
            .select('user_id').distinct()

result_df.show()
```

### [2238. Number of Times a Driver Was a Passenger](https://www.jiakaobo.com/leetcode/2238.%20Number%20of%20Times%20a%20Driver%20Was%20a%20Passenger.html)

```python
from pyspark.sql import functions as F

r_df = spark.read_table_as_df("rides_2238")
r_df.show()

result_df = r_df.alias('r1') \
            .join(r_df.alias('r2'), on=F.col('r1.driver_id')==F.col('r2.passenger_id'), how='left') \
            .groupby('r1.driver_id').agg(F.countDistinct('r2.ride_id').alias('cnt'))

result_df.show()
```

### [2292. Products With Three or More Orders in Two Consecutive Years](https://www.jiakaobo.com/leetcode/2292.%20Products%20With%20Three%20or%20More%20Orders%20in%20Two%20Consecutive%20Years.html) 

```python
from pyspark.sql import functions as F, Window as W

o_df = spark.read_table_as_df("orders_2292")
o_df.show()

agg_df = o_df \
            .groupby('product_id', F.date_format(F.col('purchase_date'), 'yyyy').alias('year')) \
            .agg(F.count('*').alias('count'))

result_df = agg_df.alias('a1') \
            .join(agg_df.alias('a2'), on=(F.col('a1.product_id') == F.col('a2.product_id'))
                                            &(F.col('a2.year') == F.col('a1.year') + 1)) \
            .select('a1.product_id')

result_df.show()
```

### [2298. Tasks Count in the Weekend](https://www.jiakaobo.com/leetcode/2298.%20Tasks%20Count%20in%20the%20Weekend.html) 

```python
from pyspark.sql import functions as F, Window as W

t_df = spark.read_table_as_df("tasks_2298")
t_df.show()

result_df = t_df \
            .withColumn('day_of_week', F.dayofweek('submit_date')) \
            .select(F.count(F.when(F.col('day_of_week').isin([7, 1]), True)).alias('weekend_count'),
                    F.count(F.when(~F.col('day_of_week').isin([7, 1]), True)).alias('working_cnt'))

result_df.show()
```

### [2308. Arrange Table by Gender](https://www.jiakaobo.com/leetcode/2308.%20Arrange%20Table%20by%20Gender.html) 

```python
from pyspark.sql import functions as F, Window as W

g_df = spark.read_table_as_df("genders_2308")
g_df.show()

w_spec = W.partitionBy('gender').orderBy('user_id')

result_df = g_df \
            .withColumn('rnk1', F.row_number().over(w_spec)) \
            .withColumn('rnk2', F.when(F.col('gender') == 'female', 1)
                                .when(F.col('gender') == 'other', 2).otherwise(3)) \
            .orderBy('rnk1', 'rnk2') \
            .select('user_id', 'gender')

result_df.show()
```

### [2314. The First Day of the Maximum Recorded Degree in Each City](https://www.jiakaobo.com/leetcode/2314.%20The%20First%20Day%20of%20the%20Maximum%20Recorded%20Degree%20in%20Each%20City.html) 

```python
from pyspark.sql import functions as F, Window as W

w_df = spark.read_table_as_df("weather_2314")
w_df.show()

w_spec = W.partitionBy('city_id').orderBy(F.desc('degree'))

result_df = w_df \
            .withColumn('rnk', F.row_number().over(w_spec)) \
            .filter(F.col('rnk') == 1) \
            .select('city_id', 'day', 'degree') \
            .orderBy('city_id')

result_df.show()
```

### [2324. Product Sales Analysis IV](https://www.jiakaobo.com/leetcode/2324.%20Product%20Sales%20Analysis%20IV.html) 

```python
from pyspark.sql import functions as F, Window as W

p_df = spark.read_table_as_df("product_2324")
p_df.show()

s_df = spark.read_table_as_df("sales_2324")
s_df.show()

w_spec = W.partitionBy('user_id').orderBy(F.desc('spent'))

result_df = s_df \
            .join(p_df, on='product_id') \
            .withColumn('spent', F.col('quantity') * F.col('price')) \
            .groupby('user_id', 'product_id').agg(F.sum('spent').alias('spent')) \
            .withColumn('rnk', F.rank().over(w_spec)) \
            .filter(F.col('rnk') == 1) \
            .select('user_id', 'product_id')

result_df.show()
```

### [2346. Compute the Rank as a Percentage](https://www.jiakaobo.com/leetcode/2346.%20Compute%20the%20Rank%20as%20a%20Percentage.html) 

```python
from pyspark.sql import functions as F, Window as W

s_df = spark.read_table_as_df("students_2346")
s_df.show()

w_spec1 = W.partitionBy('department_id').orderBy(F.desc('mark'))
w_spec2 = W.partitionBy('department_id')

result_df = s_df \
            .withColumn('rnk', F.dense_rank().over(w_spec1)) \
            .withColumn('student_count', F.count('*').over(w_spec2)) \
            .withColumn('percentage', ((F.col('rnk') - 1) * 100)/(F.col('student_count') - 1)) \
            .select('student_id', 'department_id', 'percentage')

result_df.show()
```

### [2372. Calculate the Influence of Each Salesperson](https://www.jiakaobo.com/leetcode/2372.%20Calculate%20the%20Influence%20of%20Each%20Salesperson.html) 

```python
from pyspark.sql import functions as F, Window as W

sp_df = spark.read_table_as_df("salesperson_2372")
sp_df.show()

c_df = spark.read_table_as_df("customer_2372")
c_df.show()

s_df = spark.read_table_as_df("sales_2372")
s_df.show()

result_df = sp_df \
            .join(c_df, on='salesperson_id', how='left') \
            .join(s_df, on='customer_id', how='left') \
            .groupby('salesperson_id', 'name').agg(F.ifnull(F.sum(F.col('price')), F.lit(0)).alias('total'))

result_df.show()
```

### [2388. Change Null Values in a Table to the Previous Value](https://www.jiakaobo.com/leetcode/2388.%20Change%20Null%20Values%20in%20a%20Table%20to%20the%20Previous%20Value.html) 

```python
from pyspark.sql import functions as F, Window as W

c_df = spark.read_table_as_df("coffee_shop_2388")
c_df.show()

result_df = c_df \
            .withColumn('row_num', F.row_number().over(W.orderBy(F.lit('A')))) \
            .withColumn('group_id', F.sum(F.when(F.col('drink').isNotNull(),1)).over(W.orderBy(F.col('row_num')))) \
            .withColumn('drink', F.first('drink').over(W.partitionBy('group_id').orderBy(F.col('row_num')))) \
            .select('id', 'drink')

result_df.show()
```

### [2394. Employees With Deductions](https://www.jiakaobo.com/leetcode/2394.%20Employees%20With%20Deductions.html) 

```python
from pyspark.sql import functions as F, Window as W

e_df = spark.read_table_as_df("employees_2394")
e_df.show()

l_df = spark.read_table_as_df("logs_2394")
l_df.show()

result_df = e_df \
            .join(l_df, on='employee_id', how='left') \
            .groupby('employee_id', 'needed_hours') \
            .agg((F.sum(F.ceiling(F.ifnull(F.col('out_time').cast('long')
                                        - F.col('in_time').cast('long'), F.lit(0))/60))/60).alias('total_hours')) \
            .filter(F.col('total_hours') < F.col('needed_hours')) \
            .select('employee_id')

result_df.show()
```


### [2686. Immediate Food Delivery III](https://leetcode.ca/2023-04-08-2686-Immediate-Food-Delivery-III/) 

```python
from pyspark.sql import functions as F, Window as W

df = spark.read_table_as_df("delivery_2686")
df.show()

result_df = df \
            .groupby('order_date') \
            .agg(F.round(100 * F.count(F.when(F.col('customer_pref_delivery_date') == F.col('order_date'), True))
                 / F.count('*'), 2).alias('immediate_percentage ')) \
            .orderBy('order_date')

result_df.show()
```

### [2688. Find Active Users](https://leetcode.ca/2023-04-10-2688-Find-Active-Users/) 

```python

```

### [2738. Count Occurrences in Text](https://leetcode.ca/2023-05-30-2738-Count-Occurrences-in-Text/) 

```python

```

### [2783. Flight Occupancy and Waitlist An](https://leetcode.ca/2023-07-14-2783-Flight-Occupancy-and-Waitlist-Analysis/) 

```python

```

### [2820. Election Results](https://leetcode.ca/2023-08-20-2820-Election-Results/) 

```python

```

### [2854. Rolling Average Steps](https://leetcode.ca/2023-09-23-2854-Rolling-Average-Steps/) 

```python

```

### [2893. Calculate Orders Within Each Interval](https://leetcode.ca/2023-11-01-2893-Calculate-Orders-Within-Each-Interval/) 

```python

```

### [2922. Market Analysis III](https://leetcode.ca/2023-11-30-2922-Market-Analysis-III/) 

```python

```

### [2978. Symmetric Coordinates](https://leetcode.ca/2024-01-09-2978-Symmetric-Coordinates/) 

```python

```

### [2984. Find Peak Calling Hours for Each City](https://leetcode.ca/2024-01-15-2984-Find-Peak-Calling-Hours-for-Each-City/) 

```python

```

### [2986. Find Third Transaction](https://leetcode.ca/2024-01-01-2986-Find-Third-Transaction/) 

```python

```

### [2988. Manager of the Largest Departme](https://leetcode.ca/2024-01-03-2988-Manager-of-the-Largest-Department/) 

```python

```

### [2989. Class Performance](https://leetcode.ca/2024-01-04-2989-Class-Performance/) 

```python

```

### [2993. Friday Purchases I](https://leetcode.ca/2024-01-08-2993-Friday-Purchases-I/) 

```python

```

### [3050. Pizza Toppings Cost Analysis](https://leetcode.ca/2024-03-01-3050-Pizza-Toppings-Cost-Analysis/) 

```python

```

### [3054. Binary Tree Nodes](https://leetcode.ca/2024-03-05-3054-Binary-Tree-Nodes/) 

```python

```

### [3055. Top Percentile Fraud](https://leetcode.ca/2024-03-06-3055-Top-Percentile-Fraud/) 

```python

```

### [3056. Snaps Analysis](https://leetcode.ca/2024-03-07-3056-Snaps-Analysis/) 

```python

```

### [3058. Friends With No Mutual Friends](https://leetcode.ca/2024-03-09-3058-Friends-With-No-Mutual-Friends/) 

```python

```

### [3087. Find Trending Hashtags](https://leetcode.ca/2024-04-07-3087-Find-Trending-Hashtags/) 

```python

```

### [3089. Find Bursty Behavior](https://leetcode.ca/2024-04-09-3089-Find-Bursty-Behavior/) 

```python

```

### [3118. Friday Purchase III](https://leetcode.ca/2024-05-08-3118-Friday-Purchase-III/) 

```python

```

### [3124. Find Longest Calls](https://leetcode.ca/2024-05-14-3124-Find-Longest-Calls/) 

```python

```

### [3126. Server Utilization Time](https://leetcode.ca/2024-05-16-3126-Server-Utilization-Time/) 

```python

```

### [3140. Consecutive Available Seats II](https://leetcode.ca/2024-05-24-3140-Consecutive-Available-Seats-II/) 

```python

```

### [3166. Calculate Parking Fees and Dura](https://leetcode.ca/2024-06-10-3166-Calculate-Parking-Fees-and-Duration/) 

```python

```

### [3182. Find Top Scoring Students](https://leetcode.ca/2024-06-21-3182-Find-Top-Scoring-Students/) 

```python

```

### [3204. Bitwise User Permissions Analysis](https://leetcode.ca/2024-07-13-3204-Bitwise-User-Permissions-Analysis/) 

```python

```

### [3220. Odd and Even Transactions](https://leetcode.ca/2024-07-29-3220-Odd-and-Even-Transactions/) 

```python

```

### [3230. Customer Purchasing Behavior Analysis](https://leetcode.ca/2024-08-08-3230-Customer-Purchasing-Behavior-Analysis/) 

```python

```

### [3252. Premier League Table Ranking II](https://leetcode.ca/2024-08-30-3252-Premier-League-Table-Ranking-II/) 

```python

```

### [3262. Find Overlapping Shifts](https://leetcode.ca/2024-09-09-3262-Find-Overlapping-Shifts/) 

```python

```

### [3278. Find Candidates for Data Scientist Position II](https://leetcode.ca/2024-09-25-3278-Find-Candidates-for-Data-Scientist-Position-II/) 

```python

```


