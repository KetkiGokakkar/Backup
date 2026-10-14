# driver.py

import importlib.util
import inspect
import ast
import os
import random
from datetime import datetime

# ------------------ CONFIG ------------------

ASSESSMENT_NAME = "Supply Chain Inventory Tracker"
LOG_FILE = "test_report.log"

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

# ------------------ LOGGING ------------------

def log_line(msg: str):
    print(msg, flush=True)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(msg + "\n")

def pass_msg(msg):
    log_line(f"{GREEN}{msg}{RESET}")

def fail_msg(msg):
    log_line(f"{RED}{msg}{RESET}")

def get_source(func):
    try:
        return inspect.getsource(func)
    except Exception:
        return ""

# ------------------ HARDCODE DETECTION ------------------

import textwrap

def detect_hardcoding(func_src: str) -> bool:
    """
    Detects:
    - return <literal>
    - x = <literal>; return x
    Allows empty {} and [].
    """
    try:
        tree = ast.parse(textwrap.dedent(func_src))
    except Exception:
        return False

    assigned_literals = set()

    for node in ast.walk(tree):

        if isinstance(node, ast.Assign):
            if isinstance(node.value, (ast.Dict, ast.List, ast.Tuple, ast.Constant)):
                for target in node.targets:
                    if isinstance(target, ast.Name):
                        assigned_literals.add(target.id)

        if isinstance(node, ast.Return):
            if isinstance(node.value, (ast.Dict, ast.List, ast.Tuple, ast.Constant)):
                if isinstance(node.value, ast.Dict) and not node.value.keys:
                    continue
                if isinstance(node.value, ast.List) and not node.value.elts:
                    continue
                return True

            if isinstance(node.value, ast.Name):
                if node.value.id in assigned_literals:
                    return True

    return False


# ------------------ DRIVER ------------------

def test_student_code(solution_path: str):

    if os.path.exists(LOG_FILE):
        os.remove(LOG_FILE)

    log_line(
        f"\n=== {ASSESSMENT_NAME} Test Run at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ==="
    )

    # Load solution
    spec = importlib.util.spec_from_file_location("student_solution", solution_path)
    student_module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(student_module)

    if not hasattr(student_module, "SupplyChainInventory"):
        fail_msg("SupplyChainInventory class not found")
        return

    Inventory = student_module.SupplyChainInventory

    # ------------------ TEST CASES ------------------

    tests = [
        (
            "add_product",
            lambda sc: sc.add_product("PRD101", 50),
            {"PRD101": 50},
            "Visible",
        ),
        (
            "fulfill_order",
            lambda sc: (sc.inv.update({"PRD101": 50}) or sc.fulfill_order("PRD101", 10)),
            {"PRD101": 40},
            "Visible",
        ),
        (
            "restock_return",
            lambda sc: (sc.inv.update({"PRD101": 40}) or sc.restock_return("PRD101", 5)),
            {"PRD101": 45},
            "Visible",
        ),
        (
            "list_available_products",
            lambda sc: (
                sc.inv.update({"PRD101": 10, "PRD102": 0})
                or sc.list_available_products()
            ),
            ["PRD101"],
            "Visible",
        ),
        (
            "fulfill_order_insufficient",
            lambda sc: (
                sc.inv.update({"PRD200": 5})
                or sc.fulfill_order("PRD200", 10)
            ),
            ValueError,
            "Hidden",
        ),
        (
            "restock_new_product",
            lambda sc: sc.restock_return("PRD999", random.randint(10, 50)),
            dict,
            "Hidden",
        ),
        (
            "fulfill_non_existent",
            lambda sc: sc.fulfill_order("PRD404", 5),
            ValueError,
            "Hidden",
        ),
    ]

    # ------------------ EXECUTION ------------------

    for idx, (method_name, action, expected, visibility) in enumerate(tests, 1):
        sc = Inventory()

        try:
            # ✅ Correct hardcode check (exact method)
            if hasattr(Inventory, method_name):
                src = get_source(getattr(Inventory, method_name))
                if src and detect_hardcoding(src):
                    fail_msg(
                        f"{visibility} Test Case {idx} Failed: {method_name} | "
                        f"Reason: Hardcoded literal return detected"
                    )
                    continue

            result = action(sc)

            if isinstance(expected, type) and issubclass(expected, Exception):
                fail_msg(
                    f"{visibility} Test Case {idx} Failed: {method_name} | "
                    f"Expected exception {expected.__name__}"
                )

            elif result == expected or (
                isinstance(expected, type) and isinstance(result, expected)
            ):
                pass_msg(f"{visibility} Test Case {idx} Passed: {method_name}")

            else:
                fail_msg(
                    f"{visibility} Test Case {idx} Failed: {method_name} | "
                    f"Expected={expected} | Got={result}"
                )

        except Exception as e:
            if isinstance(expected, type) and isinstance(e, expected):
                pass_msg(f"{visibility} Test Case {idx} Passed: {method_name}")
            else:
                fail_msg(
                    f"{visibility} Test Case {idx} Failed: {method_name} | Error={str(e)}"
                )

# ------------------ ENTRY POINT ------------------

if __name__ == "__main__":
    solution_file = os.path.join(os.path.dirname(__file__), "solution.py")
    test_student_code(solution_file)
