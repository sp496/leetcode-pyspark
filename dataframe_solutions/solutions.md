# Solutions

## Easy

## Medium

### 176. Second Highest Salary
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

### 184

```text
Problem
The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
The Department table holds all departments of the company.

+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).

+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
Explanation:

Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
```

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



### 534

```text
SQL Schema Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
Write an SQL query to report for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.

Return the result table in any order.

The query result format is in the following example.

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 1         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |
+-----------+------------+---------------------+
Explanation: 
For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games played by 2017-06-25.
For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
Note that for each player we only care about the days when the player logged in.
```

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


### 550. Game Play Analysis IV

```text
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 
Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example.

Example 1:

Input: 
Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Output: 
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Explanation: 
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
```

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


### 570. Managers with at Least 5 Direct Reports

```text
Problem
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 
Write an SQL query to report the managers with at least five direct reports.

Return the result table in any order.

The query result format is in the following example.

Example 1:

Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | None      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+
```

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


### 574. Winning Candidate

```text
Table: Candidate

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| id          | int      |
| name        | varchar  |
+-------------+----------+
id is the primary key column for this table.
Each row of this table contains information about the id and the name of a candidate.
Table: Vote

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| candidateId | int  |
+-------------+------+
id is an auto-increment primary key.
candidateId is a foreign key to id from the Candidate table.
Each row of this table determines the candidate who got the ith vote in the elections.
Write an SQL query to report the name of the winning candidate (i.e., the candidate who got the largest number of votes).

The test cases are generated so that exactly one candidate wins the elections.

The query result format is in the following example.

Example 1:

Input: 
Candidate table:
+----+------+
| id | name |
+----+------+
| 1  | A    |
| 2  | B    |
| 3  | C    |
| 4  | D    |
| 5  | E    |
+----+------+
Vote table:
+----+-------------+
| id | candidateId |
+----+-------------+
| 1  | 2           |
| 2  | 4           |
| 3  | 3           |
| 4  | 2           |
| 5  | 5           |
+----+-------------+
Output: 
+------+
| name |
+------+
| B    |
+------+
Explanation: 
Candidate B has 2 votes. Candidates C, D, and E have 1 vote each.
The winner is candidate B.
```

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


## Hard








