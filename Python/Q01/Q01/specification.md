Question Code: Q01

## Assessment Instructions

* Open the **Learnlytica Assessment Tool**.
* Enter your **Email Address** and **Question ID**, then click **Start Assessment**.
* Once the assessment starts, click **VSCode**. The `solution.py` file will open automatically.
* Write your solution in the `solution.py` file.
* After completing your code, return to the assessment tool and click **Run Tests**.
* After the tests are executed, click **Validate**.
* Once you are satisfied with your solution, click **Submit**, and then click **End Assessment**.

---

# 📌 Employee Salary Analyzer – Dictionary Operations

**Difficulty Level:** Medium
**Total Marks:** 10
**Standards Followed:** 4 Functions | 3 Visible Test Cases | 2 Hidden Test Cases

---

## 📌 Concepts Tested

✅ Dictionary creation and parsing
✅ Aggregation and iteration over key/value pairs
✅ Sorting with custom keys
✅ Applying transformations to dictionary values

---

## 📌 Problem Statement

Implement an **Employee Salary Analyzer** that accepts employee salary records and performs dictionary-based operations.

The dictionary should store:

* **Keys:** Employee names (`str`)
* **Values:** Salary (`float`)

The salary records will be provided as newline-separated strings in the following format:

`"EmployeeName,Salary"`

For example:

`"Alice,50000\nBob,60000"`

Your implementation must be able to:

* Create a salary dictionary from the given records.
* Calculate the total salary of all employees.
* Apply a percentage raise to all employees.
* Return the top N highest-paid employees.

---

## 📌 Class Declaration

Use the following class:

```python
class EmployeeSalaryAnalyzer:
```

The `__init__` method is **not required**.

If you use it, keep it empty:

```python
def __init__(self):
    pass
```

---

# 📌 Operations

You must implement **exactly 4 functions**.

## 1. Build Salary Dictionary

Parse the newline-separated employee records and return a dictionary containing employee names and salaries.

### Function Prototype

```python
def build_salary_dict(self, records: str) -> dict:
```

### Example Input

```text
"Alice,50000\nBob,60000"
```

### Expected Output

```python
{'Alice': 50000.0, 'Bob': 60000.0}
```

### Requirements

* Split the input into separate lines.
* Each valid line contains an employee name and salary separated by a comma.
* Remove unnecessary whitespace.
* Convert the salary to `float`.
* Skip malformed or invalid records.

---

## 2. Compute Total Salary

Calculate and return the total salary of all employees in the dictionary.

### Function Prototype

```python
def total_salary(self, salary_dict: dict) -> float:
```

### Example Input

```python
{'Alice': 50000.0, 'Bob': 60000.0}
```

### Expected Output

```text
110000.0
```

---

## 3. Give Raise to All Employees

Return a **new dictionary** where each employee's salary is increased by the given percentage.

### Function Prototype

```python
def give_raise(self, salary_dict: dict, percent: float) -> dict:
```

### Example Input

```python
({'Alice': 50000.0, 'Bob': 60000.0}, 10)
```

### Expected Output

```python
{'Alice': 55000.0, 'Bob': 66000.0}
```

### Requirements

* `percent` represents the percentage increase. For example, `10` means a **10% raise**.

* Calculate the increased salary using:

  `salary × (1 + percent / 100)`

* Round the resulting salary to **2 decimal places**.

* Return a new dictionary without modifying the original dictionary.

---

## 4. Top N Earners

Return the top `n` highest-paid employees as a list of `(employee, salary)` tuples.

### Function Prototype

```python
def top_n_earners(self, salary_dict: dict, n: int) -> list:
```

### Example Input

```python
({'Alice': 55000.0, 'Bob': 66000.0}, 1)
```

### Expected Output

```python
[('Bob', 66000.0)]
```

### Requirements

* Sort employees by salary in **descending order**.
* If two employees have the same salary, sort their names in **ascending alphabetical order**.
* Return only the top `n` employees.
* If `n <= 0`, return an empty list `[]`.
