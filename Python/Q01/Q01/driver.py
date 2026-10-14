# driver.py - Attendance-style reporting for Employee Salary Analyzer
import importlib.util
import os
import datetime
import inspect
import random
import re

def _src_of(func):
    try:
        return inspect.getsource(func)
    except Exception:
        return ""

def _norm(s):
    return s.replace(" ", "").replace("\n", "").lower()

def test_student_code(solution_path):
    report_path = os.path.join(os.path.dirname(solution_path), "test_report.log")

    # Load solution.py as module
    spec = importlib.util.spec_from_file_location("student_module", solution_path)
    student = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(student)

    # Title for header (change if you want different)
    title = "Employee Salary Analyzer"

    # Build timestamp like Attendance example: YYYY-MM-DD HH:MM:SS
    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    header = f"=== {title} Test Run at {now_str} ==="

    # Ensure class exists
    if not hasattr(student, "EmployeeSalaryAnalyzer"):
        err = f"ERROR: EmployeeSalaryAnalyzer class not found"
        # Write minimal report and print
        with open(report_path, "w", encoding="utf-8") as f:
            f.write(header + "\n" + err + "\n")
        print(header)
        print(err)
        return

    analyzer = student.EmployeeSalaryAnalyzer()

    # Visible test cases
    visible = [
        {
            "desc": "Build salary dict basic",
            "func": "build_salary_dict",
            "input": "Alice,50000\nBob,60000",
            "expected": {"Alice": 50000.0, "Bob": 60000.0}
        },
        {
            "desc": "Total salary sum",
            "func": "total_salary",
            "input": {"Alice": 50000.0, "Bob": 60000.0},
            "expected": 110000.0
        },
        {
            "desc": "Top N earners tie handling",
            "func": "top_n_earners",
            "input": ({"A":50000.0, "B":70000.0, "C":70000.0}, 2),
            "expected": [("B",70000.0), ("C",70000.0)]
        }
    ]

    # Hidden test cases
    hidden = [
        {
            "desc": "Give raise correctness",
            "func": "give_raise",
            "input": ({"A":33333.33}, 10),
            "expected": {"A": 36666.66}
        },
        {
            "desc": "Large input total",
            "func": "total_salary",
            "input": {f"Emp{i}": float(random.randint(1000,10000)) for i in range(1000)},
            "expected_func": lambda res: isinstance(res, float) and res > 0
        }
    ]

    # Anti-cheat definitions
    checks = {
        "build_salary_dict": {
            "must_have": ["splitlines", "split"],
            "forbidden": ["return{'alice'"]
        },
        "total_salary": {
            "must_have": ["for", "values"],
            "forbidden": ["return110000"]
        },
        "give_raise": {
            "must_have": ["for", "*", "round"],
            "forbidden": ["return{'a':"]
        },
        "top_n_earners": {
            "must_have": ["sorted", "key="],
            "forbidden": ["return[('b'"]
        }
    }

    # Helper runs a single case and returns tuple (ok:bool, detail:str, expected_repr:str, got_repr:str)
    def run_case(case):
        func_name = case["func"]
        # get function reference from analyzer
        try:
            func = getattr(analyzer, func_name)
        except Exception as e:
            return False, f"Function {func_name} not found", str(case.get("expected", "")), "<missing>"

        src = _src_of(func)
        src_norm = _norm(src)

        # Detect trivial/pass-only implementation
        if "pass" in src_norm and len(src_norm) < 120:
            return False, f"EdgeFail: {func_name} contains only 'pass'", str(case.get("expected", "")), "<pass>"

        # Detect forbidden hardcoded patterns (simple heuristics)
        for patt in checks.get(func_name, {}).get("forbidden", []):
            if patt in src_norm:
                # show a helpful snippet (normalized) for debugging when writing log is needed
                snippet_idx = src_norm.find(patt)
                ctx = src_norm[max(0, snippet_idx-40):snippet_idx+len(patt)+40] if snippet_idx != -1 else patt
                return False, f"EdgeFail: suspected hardcoded return in {func_name} | ctx: {ctx}", str(case.get("expected", "")), "<hardcoded>"

        # Required keywords check (weak heuristic) - we'll not fail on missing keywords; only warn later
        missing_keywords = [k for k in checks.get(func_name, {}).get("must_have", []) if k not in src_norm]
        # Execute the function safely
        try:
            inp = case["input"]
            if isinstance(inp, tuple):
                got = func(*inp)
            else:
                got = func(inp)
        except Exception as e:
            return False, f"Exception when running {func_name}: {e}", str(case.get("expected", "")), "<exception>"

        # Determine pass/fail
        if "expected" in case:
            expected = case["expected"]
            ok = (got == expected)
            exp_repr = repr(expected)
            got_repr = repr(got)
        else:
            # Use expected_func for hidden large validation
            ok = case["expected_func"](got)
            exp_repr = "<lambda validation>"
            got_repr = repr(got)

        # If function passed but missing keywords exist, still treat as pass (but could be flagged elsewhere)
        if ok:
            return True, f"{case['desc']}", exp_repr, got_repr
        else:
            return False, f"{case['desc']} | Expected={exp_repr} | Got={got_repr}", exp_repr, got_repr

    # Collect report lines
    lines = [header]

    # Run visible tests
    for i, case in enumerate(visible, start=1):
        ok, detail, exp_repr, got_repr = run_case(case)
        if ok:
            line = f"Visible Test Case {i} Passed: {case['desc']}"
        else:
            # detail already includes expected/got when functional fail
            if detail.startswith("EdgeFail") or detail.startswith("Exception") or "hardcoded" in detail.lower():
                line = f"Visible Test Case {i} Failed: {detail}"
            else:
                # regular functional fail
                # detail already contains the description + expected/got as needed
                # But to match required format show "Visible Test Case X Failed: <desc> | Expected=... | Got=..."
                # Ensure we don't duplicate the expected/got strings
                if "Expected=" in detail and "Got=" in detail:
                    line = f"Visible Test Case {i} Failed: {detail}"
                else:
                    line = f"Visible Test Case {i} Failed: {case['desc']} | Expected={exp_repr} | Got={got_repr}"
        print(line)
        lines.append(line)

    # Run hidden tests
    for i, case in enumerate(hidden, start=1):
        ok, detail, exp_repr, got_repr = run_case(case)
        if ok:
            line = f"Hidden Test Case {i} Passed: {case['desc']}"
        else:
            if detail.startswith("EdgeFail") or detail.startswith("Exception") or "hardcoded" in detail.lower():
                line = f"Hidden Test Case {i} Failed: {detail}"
            else:
                if "Expected=" in detail and "Got=" in detail:
                    line = f"Hidden Test Case {i} Failed: {detail}"
                else:
                    line = f"Hidden Test Case {i} Failed: {case['desc']} | Expected={exp_repr} | Got={got_repr}"
        print(line)
        lines.append(line)

    # Write the test_report.log exactly in attendance format
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

if __name__ == "__main__":
    p = os.path.join(os.path.dirname(__file__), "solution.py")
    test_student_code(p)
