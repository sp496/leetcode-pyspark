# SQL Problem: Insurance Policy Investment Sum

## Problem Statement

Given an `Insurance` table with policyholder data, find the **sum of `tiv_2016`** for policyholders who satisfy both of these conditions:

1. Their `tiv_2015` value is shared with **at least one other** policyholder.
2. Their `(lat, lon)` location is **unique** — no other policyholder shares the same city.

Round the result to two decimal places.

**Schema:**

| Column     | Type  | Description                        |
|------------|-------|------------------------------------|
| pid        | int   | Primary key (policy ID)            |
| tiv_2015   | float | Total investment value in 2015     |
| tiv_2016   | float | Total investment value in 2016     |
| lat        | float | Latitude of policyholder's city    |
| lon        | float | Longitude of policyholder's city   |

**Example:**

| pid | tiv_2015 | tiv_2016 | lat | lon |
|-----|----------|----------|-----|-----|
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |

**Expected Output:** `45.00`

- Policyholders 1 and 4 qualify: both share `tiv_2015 = 10` with others, and both have unique locations.
- Policyholder 2 is excluded: unique `tiv_2015`, and shares location with policyholder 3.
- Policyholder 3 is excluded: shares location `(20, 20)` with policyholder 2.

---

## Solution 1: Using `IN` / `NOT IN`

```sql
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance i1
WHERE i1.tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance i2
    WHERE i2.pid != i1.pid
)
AND (i1.lat, i1.lon) NOT IN (
    SELECT lat, lon
    FROM Insurance i3
    WHERE i3.pid != i1.pid
);
```

- The `IN` subquery builds the **full list** of `tiv_2015` values from other policyholders, then checks membership.
- The `NOT IN` subquery builds the **full list** of `(lat, lon)` pairs from other policyholders, then excludes matches.

**Caveat:** If the subquery in `NOT IN` returns any `NULL` values, the entire condition evaluates to `UNKNOWN`, which can silently exclude all rows. This is a well-known SQL pitfall.

---

## Solution 2: Using `EXISTS` / `NOT EXISTS` ✅ Preferred

```sql
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance i1
WHERE EXISTS (
    SELECT 1
    FROM Insurance i2
    WHERE i2.pid != i1.pid
    AND i2.tiv_2015 = i1.tiv_2015
)
AND NOT EXISTS (
    SELECT 1
    FROM Insurance i3
    WHERE i3.pid != i1.pid
    AND i3.lat = i1.lat
    AND i3.lon = i1.lon
);
```

- `EXISTS` checks row by row whether a matching record exists, stopping as soon as it finds the first one.
- `NOT EXISTS` checks whether no matching record exists, and is safe against `NULL` values.

---

## Why `EXISTS` / `NOT EXISTS` is Better

### 1. Short-Circuit Evaluation

`EXISTS` stops scanning as soon as it finds the **first matching row**. It doesn't need to build or return a full result set.

`IN`, by contrast, executes the subquery and collects **all matching values** into a list before checking membership — even if the answer is obvious after the first match.

**Example:** If 1 million rows share `tiv_2015 = 10`:
- `IN` → scans all 1 million rows to build the list.
- `EXISTS` → stops at the first match found.

The `SELECT 1` inside `EXISTS` is intentional — you only care *whether* a row exists, not *what* it contains.

### 2. NULL Safety

`NOT IN` is unsafe when the subquery can return `NULL` values. In SQL, any comparison with `NULL` yields `UNKNOWN`, so:

```sql
-- If subquery returns NULL, this entire condition becomes UNKNOWN
WHERE (lat, lon) NOT IN (SELECT lat, lon FROM ...)
```

This can silently filter out **all rows**, returning an empty result with no error.

`NOT EXISTS` does not have this problem. It evaluates purely on whether a matching row is found, regardless of `NULL` values in other columns.

### 3. Readability

`EXISTS` more naturally expresses the intent: *"does at least one other row satisfy this condition?"* — which maps directly to the problem statement.

---

## Summary

| | `IN` / `NOT IN` | `EXISTS` / `NOT EXISTS` |
|---|---|---|
| Builds full result set | ✅ Yes | ❌ No (short-circuits) |
| Safe with NULLs | ❌ `NOT IN` is unsafe | ✅ Always safe |
| Performance on large data | Slower | Faster |
| Readability | Good | Better |

For this problem, both solutions produce the correct answer on clean data. But `EXISTS` / `NOT EXISTS` is the more robust and performant choice in production.
