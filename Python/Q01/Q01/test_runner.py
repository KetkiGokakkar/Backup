# run.py - run the driver tests
import importlib.util, os
driver_path = os.path.join(os.path.dirname(__file__), "driver.py")
spec = importlib.util.spec_from_file_location("driver", driver_path)
driver = importlib.util.module_from_spec(spec)
spec.loader.exec_module(driver)

if __name__ == "__main__":
    solution_path = os.path.join(os.path.dirname(__file__), "solution.py")
    driver.test_student_code(solution_path)
