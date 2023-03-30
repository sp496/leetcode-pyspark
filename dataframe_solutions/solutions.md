# Solutions

## Easy

## Medium

### [176. Second Highest Salary](https://www.jiakaobo.com/leetcode/176.%20Second%20Highest%20Salary.html)

```python
from pyspark.sql.window import Window
from pyspark.sql.functions import F.col, dense_rank, desc

window_spec = Window.orderBy(desc("salary"))
employee_df = spark.read_table_as_df("employee_181")
employee_df.show()

result_df = employee_df\
    .withColumn('dense_rank', dense_rank().over(window_spec))\
    .where(F.col('dense_rank') == 2)\
    .select(F.col('salary').alias('SecondHighestSalary'))
result_df.show()
```

### [178. Rank Scores](https://www.jiakaobo.com/leetcode/178.%20Rank%20Scores.html)

```python
from pyspark.sql.functions import F.col, desc, dense_rank
from pyspark.sql.window import Window

rank_spec = Window.orderBy(desc(F.col('score')))

scores_df = spark.read_table_as_df("scores_178")
result_df = scores_df.\
    withColumn('dense_rank', dense_rank().over(rank_spec))
result_df.show()
```

### [180. Consecutive Numbers](https://www.jiakaobo.com/leetcode/180.%20Consecutive%20Numbers.html)

```python
from pyspark.sql.functions import F.col, asc, lead
from pyspark.sql.window import Window

window_spec = Window.orderBy(asc(F.col('id')))

logs_df = spark.read_table_as_df("Logs_180")
logs_df.show()

result_df = logs_df\
    .withColumn('second_num', lead(F.col('num')).over(window_spec))\
    .withColumn('third_num', lead(F.col('second_num')).over(window_spec))\
    .where((F.col('second_num') == F.col('num')) & (F.col('third_num') == F.col('second_num')))\
    .select(F.col('num').alias('ConsecutiveNums'))

result_df.show()
```

### [184. Department Highest Salary](https://www.jiakaobo.com/leetcode/184.%20Department%20Highest%20Salary.html)

```python
from pyspark.sql.functions import F.col, desc, rank
from pyspark.sql.window import Window

emp_df = spark.read_table_as_df("employee_184")
emp_df.show()

dep_df = spark.read_table_as_df("department_184")
dep_df.show()

w = Window.partitionBy(F.col('dep.id')).orderBy(desc(F.col('emp.salary')))

result_df = \
    emp_df.alias('emp') \
    .join(dep_df.alias('dep'), on=F.col('emp.department_id') == F.col('dep.id'), how='inner')\
    .withColumn('rank', rank().over(w))\
    .where(F.col('rank') == 1)\
    .select([F.col('dep.name').alias('Department'), F.col('emp.name').alias('Employee'), 'salary'])

result_df.show()
```



### [534. Game Play Analysis III](https://www.jiakaobo.com/leetcode/534.%20Game%20Play%20Analysis%20III.html)

```python
from pyspark.sql.functions import F.col, sum

act_df = spark.read_table_as_df("activity_534")
act_df.show()

result_df = act_df.alias('a1') \
    .join(act_df.alias('a2'),
          on=(F.col('a1.player_id') == F.col('a2.player_id')) & (F.col('a2.event_date') <= F.col('a1.event_date')),
          how='inner')\
    .groupby([F.col('a1.player_id'), F.col('a1.event_date')])\
    .agg(sum('a2.games_played').alias('games_played_so_far'))

result_df.show()
```


### [550. Game Play Analysis IV](https://www.jiakaobo.com/leetcode/550.%20Game%20Play%20Analysis%20IV.html)

```python
from pyspark.sql.functions import F.col, rank, when, count, countDistinct, round
from pyspark.sql.window import Window

act_df = spark.read_table_as_df("activity_550")
act_df.show()

w = Window.partitionBy(F.col('a1.player_id')).orderBy('a1.event_date')

result_df = act_df.alias('a1') \
    .withColumn('day', rank().over(w)) \
    .join(act_df.alias('a2'),
          on=(F.col('a1.player_id') == F.col('a2.player_id')) & (F.col('a2.event_date') == F.col('a1.event_date') + 1),
          how='left') \
    .select(round((count(when((F.col('day') == 1) & (F.col('a2.player_id').isNotNull()), F.col('a1.player_id'))
                         .otherwise(None)) / countDistinct(F.col("a1.player_id"))), 2).alias('fraction'))

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
from pyspark.sql.functions import F.col, sum

inv_df = spark.read_table_as_df("insurance_585")
inv_df.show()

result_df = inv_df.alias('i1') \
    .join(inv_df.alias('i2'), on=(F.col('i1.lat') == F.col('i2.lat')) &
                                 (F.col('i1.lon') == F.col('i2.lon')) &
                                 (F.col('i1.tiv_2015') != F.col('i2.tiv_2015')) &
                                 (F.col('i1.pid') != F.col('i2.pid')),
          how='left_anti') \
    .agg(sum(F.col('tiv_2016')).alias('tiv_2016'))

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

### 

```python

```

### [614. Second Degree Follower](https://www.jiakaobo.com/leetcode/614.%20Second%20Degree%20Follower.html)

comments: perfect example for where a semi join is optimal

```python
import pyspark.sql.functions as F

fol_df = spark.read_table_as_df("follow_614")
fol_df.show()

result_df = fol_df.alias('f1')\
    .join(fol_df.alias('f2'), on=F.col('f1.followee') == F.col('f2.follower'), how='semi') \
    .groupby('followee').agg(F.count('follower').alias('num'))

result_df.show()
```

### [626. Exchange Seats](https://www.jiakaobo.com/leetcode/626.%20Exchange%20Seats.html)

```python
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
import pyspark.sql.functions as F
from pyspark.sql.window import Window

w = Window.partitionBy(F.col('product_id')).orderBy(F.col('year'))

sales_df = spark.read_table_as_df("sales_1068")
sales_df.show()

prod_df = spark.read_table_as_df("product_1068")
prod_df.show()

result_df = sales_df \
    .withColumn('n_year', F.rank().over(w)) \
    .filter(F.col('n_year') == 1)

result_df.show()
```

### [1077. Project Employees III](https://www.jiakaobo.com/leetcode/1077.%20Project%20Employees%20III.html)

```python
import pyspark.sql.functions as F
from pyspark.sql.window import Window

project_df = spark.read_table_as_df("project_1077")
project_df.show()

emp_df = spark.read_table_as_df("employee_1077")
emp_df.show()

w = Window.partitionBy('project_id').orderBy(F.desc('experience_years'))

result_df = project_df \
    .join(emp_df, on='employee_id', how='inner') \
    .withColumn('exp_rank', F.rank().over(w)) \
    .filter(F.col('exp_rank') == 1) \
    .select(['project_id', 'employee_id'])

result_df.show()
```

### [1098. Unpopular Books](https://www.jiakaobo.com/leetcode/1098.%20Unpopular%20Books.html)

```python
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
```

### (https://www.jiakaobo.com/leetcode/1107.%20New%20Users%20Daily%20Count.html)

```python

```

### [1112. Highest Grade For Each Student](https://www.jiakaobo.com/leetcode/1112.%20Highest%20Grade%20For%20Each%20Student.html)

```python
import pyspark.sql.functions as F
from pyspark.sql.window import Window

w = Window.partitionBy('student_id').orderBy(F.desc('grade'), F.asc('course_id'))

enrol_df = spark.read_table_as_df("enrollments_1112")
enrol_df.show()

result_df = enrol_df \
    .withColumn('rank', F.rank().over(w)) \
    .filter(F.col('rank') == 1) \

result_df.show()
```

### [1126. Active Businesses](https://www.jiakaobo.com/leetcode/1126.%20Active%20Businesses.html)

```python
import pyspark.sql.functions as F
from pyspark.sql.window import Window

events_df = spark.read_table_as_df("events_1126")
events_df.show()

w = Window.partitionBy('event_type')

result_df = events_df \
    .withColumn('avg_event_occurence', F.avg('occurences').over(w)) \
    .filter(F.col('occurences') > F.col('avg_event_occurence')) \
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
    .join(removals_df, on='post_id', how='left') \
    .filter(F.col('extra') == 'spam') \
    .groupby('action_date') \
    .agg(((F.count(F.when((F.col('remove_date').isNotNull()), True))) * 100 /
         (F.count(F.col('post_id')))).alias('percentage')) \
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

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```

### 

```python

```


