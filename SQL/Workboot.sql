-- set 1 
USE CLASS;

-- M2
	-- Skill focus: Six-table join, derived table, and ROW_NUMBER
	-- Business requirement: Advisors need each trainee's most recent evaluated assessment across all enrolled Courses.
	-- Task: Join all six tables, rank evaluated Assessments within each trainee, and retain the latest row.
	-- How to understand this question: The final grain is one latest evaluated assessment per trainee. The window must rank attempts before the outer query filters them.
	-- Approach to solve it: Build the six-table detail inside a derived table, assign descending ROW_NUMBER per trainee, then filter Rn = 1 in the outer query.
	-- Rules and expected columns
	-- •	Ignore Assessments whose Result_status is not 'Evaluated'.
	-- •	For equal assessment dates, the larger Assessment_id is later.
	-- •	Return Trainee_name, Trainer_name, Course_name, Assessment_date, and Score.
	-- •	Exclude Trainees with no evaluated assessment and sort by Trainee_name.
	-- How to reach the expected output: For each trainee, remove Pending attempts, sort remaining attempts by Assessment_date and Assessment_id descending, and keep position 1.
	-- Mistake to avoid: MAX(Assessment_date) alone does not return the other columns from the same latest row.
   
    WITH CTE AS (SELECT TRAINEE_NAME ,TRAINER_NAME , COURSE_NAME , ASSESSMENT_DATE , SCORE , ROW_NUMBER() OVER (PARTITION  	 BY T.TRAINEE_NAME ,COURSE_NAME ORDER BY A.SCORE DESC , A.ASSESSMENT_DATE ASC) AS ROW_RANK
    FROM ENROLLMENTS E JOIN BATCHES B  ON E.BATCH_ID = B.BATCH_ID
    JOIN TRAINEES T ON T.TRAINEE_ID = E.TRAINEE_ID 
    JOIN COURSES C ON C.COURSE_ID = B.COURSE_ID
    JOIN TRAINERS TR ON TR.TRAINER_ID = C.TRAINER_ID 
    JOIN ASSESSMENTS A ON E.ENROLLMENT_ID = A.ENROLLMENT_ID
    WHERE A.RESULT_STATUS='EVALUATED') 
    SELECT TRAINEE_NAME ,TRAINER_NAME , COURSE_NAME , ASSESSMENT_DATE , SCORE 
    FROM CTE WHERE ROW_RANK  =1 ;

-- M2. Assessment Attempts Above the Course Average
	-- 	Skill focus: Six-table join and grouped derived-table comparison
	-- 	Business requirement: The learning team wants every evaluated attempt that performed above the evaluated average of its course.
	-- 	Task: Calculate one evaluated average per course, then compare each evaluated assessment attempt with its course average.
	-- 	How to understand this question: The benchmark grain is one course, while the final grain is one assessment attempt. Keep those two grains separate.
	-- 	Approach to solve it: Build course averages in a grouped derived table, join that result to the six-table assessment detail, and compare Score > average.
	-- 	Rules and expected columns
	-- 	•	Use all six business tables in the detail query.
	-- 	•	Both the average and detail rows must use Result_status = 'Evaluated'.
	-- 	•	Return Trainer_name, Course_name, Trainee_name, Score, and Course_average rounded to two decimals.
	-- 	•	Sort by Course_name, Score descending, then Trainee_name.
	-- 	How to reach the expected output: Compute the evaluated average for each course first, then compare every evaluated Score against the matching Course_id average.
	-- 	Mistake to avoid: The expected grain is an assessment attempt, so the same trainee can appear more than once.
	
    
