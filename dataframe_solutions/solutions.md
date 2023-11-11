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
    .select(F.round((F.count(F.when((F.col('day') == 1)
                                    & (F.col('a2.player_id').isNotNull()), F.col('a1.player_id'))
                             .otherwise(None)) / F.countDistinct(F.col("a1.player_id"))), 2).alias('fraction'))

result_df.show()
```


### [570. Managers with at Least 5 Direct Reports](https://www.jiakaobo.com/leetcode/570.%20Managers%20with%20at%20Least%205%20Direct%20Reports.html)

```python
from pyspark.sql.functions import F.col, count

emp_df = spark.read_table_as_df("employee_570")
emp_df.show()

result_df = emp_df.alias('emp')\
    .join(emp_df.alias('mgr'), on=F.col('emp.manager_id') == F.col('mgr.id'))\
    .groupby([F.col('emp.manager_id'), F.col('mgr.name')]).agg(count('emp.id').alias('reports'))\
    .filter(F.col('reports') >= 5)\
    .select(F.col('mgr.name'))

result_df.show()
```


### [574. Winning Candidate](https://www.jiakaobo.com/leetcode/574.%20Winning%20Candidate.html)

```python
from pyspark.sql.functions import F.col, count

can_df = spark.read_table_as_df("candidate_574")
can_df.show()
vote_df = spark.read_table_as_df("vote_574")
vote_df.show()

result_df = vote_df.alias('v')\
    .join(can_df.alias('c'), on=F.col('v.candidate_id') == F.col('c.id'))\
    .groupby([F.col('v.candidate_id'), F.col('c.name')]).agg(count('v.id').alias('votes'))\
    .orderBy(F.col('votes').desc())\
    .limit(1)\
    .select(F.col('name'))

result_df.show()
```


### [578. Get Highest Answer Rate Question](https://www.jiakaobo.com/leetcode/578.%20Get%20Highest%20Answer%20Rate%20Question.html)

```python
from pyspark.sql.functions import F.col, count, when

df = spark.read_table_as_df("surveylog_578")
df.show()

result_df = df\
    .groupby('question_id')\
    .agg((count(when(F.col('action') == 'answer', True))/
          count(when(F.col('action') == 'show', True))).alias('answer_rate'))\
    .orderBy('question_id') \
    .limit(1)\
    .select('question_id').alias('survey_log')

result_df.show()
```


### [580. Count Student Number in Departments](https://www.jiakaobo.com/leetcode/580.%20Count%20Student%20Number%20in%20Departments.html)

```python
from pyspark.sql.functions import count, desc

stud_df = spark.read_table_as_df("student_580")
stud_df.show()

dep_df = spark.read_table_as_df("department_580")
dep_df.show()

result_df = dep_df\
    .join(stud_df, on='dept_id', how='left')\
    .groupby('dept_name')\
    .agg(count('student_id').alias('student_number'))\
    .orderBy(desc('student_number'))

result_df.show()
```

### [585. Investments in 2016](https://www.jiakaobo.com/leetcode/585.%20Investments%20in%202016.html)

```python
#solution 1
from pyspark.sql.functions import F.col, sum

inv_df = spark.read_table_as_df("insurance_585")
inv_df.show()

result_df = inv_df.alias('i1') \
    .join(inv_df.alias('i2'), on=(F.col('i1.lat') == F.col('i2.lat')) &
                                 (F.col('i1.lon') == F.col('i2.lon')) &
                                 (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')) &
                                 (F.col('i1.pid') != F.col('i2.pid')), how='left_anti') \
    .agg(sum(F.col('tiv_2016')).alias('tiv_2016'))

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

```

### [602. Friend Requests II: Who Has the Most Friends](https://www.jiakaobo.com/leetcode/602.%20Friend%20Requests%20II:%20Who%20Has%20the%20Most%20Friends.html)

```python
from pyspark.sql.functions import F.col, count, desc

req_df = spark.read_table_as_df("request_accepted_602")
req_df.show()

result_df = req_df.select([F.col('requester_id').alias('id'), F.col('accepter_id').alias('friend_id')])\
    .union(req_df.select([F.col('accepter_id').alias('id'), F.col('requester_id').alias('friend_id')]))\
    .groupby('id').agg(count('friend_id').alias('num'))\
    .orderBy(desc('num'))\
    .limit(1)

result_df.show()
```

### [608. Tree Node](https://www.jiakaobo.com/leetcode/608.%20Tree%20Node.html) 

```python
from pyspark.sql.functions import F.col, when

tree_df = spark.read_table_as_df("tree_608")
tree_df.show()

# result_df = tree_df.select(F.col("id").isin(tree_df["p_id"]).alias("match"))
result_df = tree_df.alias('t1') \
    .join(tree_df.alias('t2'), on=F.col('t1.id') == F.col('t2.p_id'), how='left')\
    .withColumn('type', when(F.col('t1.p_id').isNull(), 'Root')
                .otherwise(when(F.col('t2.p_id').isNull(), 'Leaf').otherwise('Inner')))\
    .select([F.col('t1.id'), F.col('type')])\
    .dropDuplicates()\
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
```

### [626. Exchange Seats](https://www.jiakaobo.com/leetcode/626.%20Exchange%20Seats.html)

```python
#solution_i
from pyspark.sql import functions as F, Window as W

seat_df = spark.read_table_as_df("seat_626")
seat_df.show()

wspec = W.orderBy('id').rowsBetween(-1, 1)
result_df = seat_df \
            .withColumn("id", F.when(F.col('id') % 2 == 0,  F.first('id').over(wspec)).otherwise(F.last('id').over(wspec))) \
            .orderBy('id')

result_df.show()

#solution_2
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

# .filter(F.col('activity_date').between(F.date_sub(F.to_date(F.lit('2019-06-30.')), 30),
#                                        F.date_add(F.to_date(F.lit('2019-06-30.')), 30))) \
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
    .filter(F.col('event_types') >= 2) \
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
    .filter(F.col('event_types') >= 2) \
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
import pyspark.sql.functions as F

o_df = spark.read_table_as_df("orders_1158")
o_df.show()

u_df = spark.read_table_as_df("users_1158")
u_df.show()

i_df = spark.read_table_as_df("items_1158")
i_df.show()

result_df = u_df \
    .join(o_df,
          on=(F.col('user_id') == F.col('buyer_id')) & (F.col('order_date') >= '2019-01-01'),
          how='left') \
    .groupby(['buyer_id', 'join_date']) \
    .agg(F.count('order_id').alias('orders_in_2019'))

result_df.show()
```

### [1164. Product Price at a Given Date](https://www.jiakaobo.com/leetcode/1164.%20Product%20Price%20at%20a%20Given%20Date.html)

```python
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

```

### [1205. Monthly Transactions II](https://www.jiakaobo.com/leetcode/1205.%20Monthly%20Transactions%20II.html)

```python

```

### [1212. Team Scores in Football Tournament](https://www.jiakaobo.com/leetcode/1212.%20Team%20Scores%20in%20Football%20Tournament.html)

```python

```

### [1264. Page Recommendations](https://www.jiakaobo.com/leetcode/1264.%20Page%20Recommendations.html)

```python

```

### [1270. All People Report to the Given Manager](https://www.jiakaobo.com/leetcode/1270.%20All%20People%20Report%20to%20the%20Given%20Manager.html)

```python

```

### [1285. Find the Start and End Number of Continuous Ranges](https://www.jiakaobo.com/leetcode/1285.%20Find%20the%20Start%20and%20End%20Number%20of%20Continuous%20Ranges.html)

```python

```

### [1308. Running Total for Different Genders](https://www.jiakaobo.com/leetcode/1308.%20Running%20Total%20for%20Different%20Genders.html)

```python

```

### [1321. Restaurant Growth](https://www.jiakaobo.com/leetcode/1321.%20Restaurant%20Growth.html)

```python

```

### [1341. Movie Rating](https://www.jiakaobo.com/leetcode/1341.%20Movie%20Rating.html)

```python

```

### [1355. Activity Participants](https://www.jiakaobo.com/leetcode/1355.%20Activity%20Participants.html)

```python

```

### [1364. Number of Trusted Contacts of a Customer](https://www.jiakaobo.com/leetcode/1364.%20Number%20of%20Trusted%20Contacts%20of%20a%20Customer.html)

```python

```

### [1393. Capital Gain/Loss](https://www.jiakaobo.com/leetcode/1393.%20Capital%20Gain%20Loss.html)

```python

```

### [1398. Customers Who Bought Products A and B but Not C](https://www.jiakaobo.com/leetcode/1398.%20Customers%20Who%20Bought%20Products%20A%20and%20B%20but%20Not%20C.html)

```python

```

### [1440. Evaluate Boolean Expression](https://www.jiakaobo.com/leetcode/1440.%20Evaluate%20Boolean%20Expression.html)

```python

```

### [1445. Apples & Oranges](https://www.jiakaobo.com/leetcode/1445.%20Apples%20&%20Oranges.html)

```python

```

### [1454. Active Users](https://www.jiakaobo.com/leetcode/1454.%20Active%20Users.html)

```python

```

### [1459. Rectangles Area](https://www.jiakaobo.com/leetcode/1459.%20Rectangles%20Area.html)

```python

```

### [1468. Calculate Salaries](https://www.jiakaobo.com/leetcode/1468.%20Calculate%20Salaries.html)

```python

```

### [1501. Countries You Can Safely Invest In](https://www.jiakaobo.com/leetcode/1501.%20Countries%20You%20Can%20Safely%20Invest%20In.html)

```python

```

### [1532. The Most Recent Three Orders](https://www.jiakaobo.com/leetcode/1532.%20The%20Most%20Recent%20Three%20Orders.html)

```python

```

### [1549. The Most Recent Orders for Each Product](https://www.jiakaobo.com/leetcode/1549.%20The%20Most%20Recent%20Orders%20for%20Each%20Product.html)

```python

```

### [1555. Bank Account Summary](https://www.jiakaobo.com/leetcode/1555.%20Bank%20Account%20Summary.html)

```python

```

### [1596. The Most Frequently Ordered Products for Each Customer](https://www.jiakaobo.com/leetcode/1596.%20The%20Most%20Frequently%20Ordered%20Products%20for%20Each%20Customer.html) 

```python

```

### [1613. Find the Missing IDs](https://www.jiakaobo.com/leetcode/1613.%20Find%20the%20Missing%20IDs.html) 

```python

```

### [1699. Number of Calls Between Two Persons](https://www.jiakaobo.com/leetcode/1699.%20Number%20of%20Calls%20Between%20Two%20Persons.html) 

```python

```

### [1709. Biggest Window Between Visits](https://www.jiakaobo.com/leetcode/1709.%20Biggest%20Window%20Between%20Visits.html) 

```python

```

### [1715. Count Apples and Oranges](https://www.jiakaobo.com/leetcode/1715.%20Count%20Apples%20and%20Oranges.html) 

```python

```

### [1747. Leetflex Banned Accounts](https://www.jiakaobo.com/leetcode/1747.%20Leetflex%20Banned%20Accounts.html) 

```python

```

### [1783. Grand Slam Titles](https://www.jiakaobo.com/leetcode/1783.%20Grand%20Slam%20Titles.html) 

```python

```

### [1811. Find Interview Candidates](https://www.jiakaobo.com/leetcode/1811.%20Find%20Interview%20Candidates.html) 

```python

```

### [1831. Maximum Transaction Each Day](https://www.jiakaobo.com/leetcode/1831.%20Maximum%20Transaction%20Each%20Day.html) 

```python

```

### [1841. League Statistics](https://www.jiakaobo.com/leetcode/1841.%20League%20Statistics.html) 

```python

```

### [1843. Suspicious Bank Accounts](https://www.jiakaobo.com/leetcode/1843.%20Suspicious%20Bank%20Accounts.html) 

```python

```

### [1867. Orders With Maximum Quantity Above Average](https://www.jiakaobo.com/leetcode/1867.%20Orders%20With%20Maximum%20Quantity%20Above%20Average.html) 

```python

```

### [1875. Group Employees of the Same Salary](https://www.jiakaobo.com/leetcode/1875.%20Group%20Employees%20of%20the%20Same%20Salary.html) 

```python

```

### [1907. Count Salary Categories](https://www.jiakaobo.com/leetcode/1907.%20Count%20Salary%20Categories.html) 

```python

```

### [1934. Confirmation Rate](https://www.jiakaobo.com/leetcode/1934.%20Confirmation%20Rate.html) 

```python

```

### [1949. Strong Friendship](https://www.jiakaobo.com/leetcode/1949.%20Strong%20Friendship.html) 

```python

```

### [1951. All the Pairs With the Maximum Number of Common Followers](https://www.jiakaobo.com/leetcode/1951.%20All%20the%20Pairs%20With%20the%20Maximum%20Number%20of%20Common%20Followers.html) 

```python

```

### [1988. Find Cutoff Score for Each School](https://www.jiakaobo.com/leetcode/1988.%20Find%20Cutoff%20Score%20for%20Each%20School.html) 

```python

```

### [1990. Count the Number of Experiments](https://www.jiakaobo.com/leetcode/1990.%20Count%20the%20Number%20of%20Experiments.html) 

```python

```

### [2020. Number of Accounts That Did Not Stream](https://www.jiakaobo.com/leetcode/2020.%20Number%20of%20Accounts%20That%20Did%20Not%20Stream.html) 

```python

```

### [2041. Accepted Candidates From the Interviews](https://www.jiakaobo.com/leetcode/2041.%20Accepted%20Candidates%20From%20the%20Interviews.html) 

```python

```

### [2051. The Category of Each Member in the Store](https://www.jiakaobo.com/leetcode/2051.%20The%20Category%20of%20Each%20Member%20in%20the%20Store.html) 

```python

```

### [2066. Account Balance](https://www.jiakaobo.com/leetcode/2066.%20Account%20Balance.html) 

```python

```

### [2084. Drop Type 1 Orders for Customers With Type 0 Orders](https://www.jiakaobo.com/leetcode/2084.%20Drop%20Type%201%20Orders%20for%20Customers%20With%20Type%200%20Orders.html) 

```python

```

### [2112. The Airport With the Most Traffic](https://www.jiakaobo.com/leetcode/2112.%20The%20Airport%20With%20the%20Most%20Traffic.html) 

```python

```

### [2142. The Number of Passengers in Each Bus I](https://www.jiakaobo.com/leetcode/2142.%20The%20Number%20of%20Passengers%20in%20Each%20Bus%20I.html) 

```python

```

### [2159. Order Two Columns Independently](https://www.jiakaobo.com/leetcode/2159.%20Order%20Two%20Columns%20Independently.html) 

```python

```

### [2175. The Change in Global Rankings](https://www.jiakaobo.com/leetcode/2175.%20The%20Change%20in%20Global%20Rankings.html) 

```python

```

### [2228. Users With Two Purchases Within Seven Days](https://www.jiakaobo.com/leetcode/2228.%20Users%20With%20Two%20Purchases%20Within%20Seven%20Days.html) 

```python

```

### [2238. Number of Times a Driver Was a Passenger](https://www.jiakaobo.com/leetcode/2238.%20Number%20of%20Times%20a%20Driver%20Was%20a%20Passenger.html)

```python

```

### [2292. Products With Three or More Orders in Two Consecutive Years](https://www.jiakaobo.com/leetcode/2292.%20Products%20With%20Three%20or%20More%20Orders%20in%20Two%20Consecutive%20Years.html) 

```python

```

### [2298. Tasks Count in the Weekend](https://www.jiakaobo.com/leetcode/2298.%20Tasks%20Count%20in%20the%20Weekend.html) 

```python

```

### [2308. Arrange Table by Gender](https://www.jiakaobo.com/leetcode/2308.%20Arrange%20Table%20by%20Gender.html) 

```python

```

### [2314. The First Day of the Maximum Recorded Degree in Each City](https://www.jiakaobo.com/leetcode/2314.%20The%20First%20Day%20of%20the%20Maximum%20Recorded%20Degree%20in%20Each%20City.html) 

```python

```

### [2324. Product Sales Analysis IV](https://www.jiakaobo.com/leetcode/2324.%20Product%20Sales%20Analysis%20IV.html) 

```python

```

### [2346. Compute the Rank as a Percentage](https://www.jiakaobo.com/leetcode/2346.%20Compute%20the%20Rank%20as%20a%20Percentage.html) 

```python

```

### [2372. Calculate the Influence of Each Salesperson](https://www.jiakaobo.com/leetcode/2372.%20Calculate%20the%20Influence%20of%20Each%20Salesperson.html) 

```python

```

### [2388. Change Null Values in a Table to the Previous Value](https://www.jiakaobo.com/leetcode/2388.%20Change%20Null%20Values%20in%20a%20Table%20to%20the%20Previous%20Value.html) 

```python

```

### [2394. Employees With Deductions](https://www.jiakaobo.com/leetcode/2394.%20Employees%20With%20Deductions.html) 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

```python

```

### []() 

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


