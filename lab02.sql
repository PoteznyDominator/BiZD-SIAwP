ALTER TABLE REGIONS ADD PRIMARY KEY(REGION_ID);

ALTER TABLE COUNTRIES
    ADD PRIMARY KEY(COUNTRY_ID)
    ADD FOREIGN KEY(REGION_ID) REFERENCES REGIONS(REGION_ID);

ALTER TABLE LOCATIONS
    ADD PRIMARY KEY(LOCATION_ID)
    ADD FOREIGN KEY(COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID);

ALTER TABLE EMPLOYEES
    ADD PRIMARY KEY(EMPLOYEE_ID);

ALTER TABLE DEPARTMENETS
    ADD PRIMARY KEY(DEPARTMENT_ID)
    ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID)
    ADD FOREIGN KEY(MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE JOBS
    ADD PRIMARY KEY(JOB_ID);

ALTER TABLE JOB_HISTORY
    ADD FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
    ADD FOREIGN KEY(DEPARTMENT_ID) REFERENCES DEPARTMENETS(DEPARTMENT_ID)
    ADD FOREIGN KEY(JOB_ID) REFERENCES JOBS(JOB_ID);

ALTER TABLE EMPLOYEES
    ADD FOREIGN KEY(JOB_ID) REFERENCES JOBS(JOB_ID)
    ADD FOREIGN KEY(MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);


-- zad01
SELECT last_name, (COALESCE(salary, 0) + COALESCE(COMMISSION_PCT, 0)) AS wynagrodzenie
FROM Employees
WHERE department_id IN (20, 50)
  AND (COALESCE(salary, 0) + COALESCE(COMMISSION_PCT, 0)) BETWEEN 2000 AND 7000
ORDER BY last_name;

-- zad02
SELECT HIRE_DATE, LAST_NAME FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL AND EXTRACT(YEAR FROM (HIRE_DATE)) = 2005;

-- zad03
SELECT CONCAT(FIRST_NAME, CONCAT(' ', LAST_NAME)) AS NAME, SALARY, PHONE_NUMBER
FROM EMPLOYEES
WHERE SUBSTR(LAST_NAME, 3, 1) = 'e'
AND SUBSTR(FIRST_NAME, 1, 2) = 'Da'
ORDER BY NAME DESC, SALARY;

-- zad04
SELECT FIRST_NAME, LAST_NAME, FLOOR(MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE)) AS MONTHS,
    CASE
        WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE)) <=150 THEN 0.1 * SALARY
	    WHEN ROUND(MONTHS_BETWEEN(CURRENT_DATE, HIRE_DATE)) <=200 THEN 0.2 * SALARY
	    ELSE 0.3 * SALARY
    END AS SUPPLEMENT
FROM EMPLOYEES
ORDER BY MONTHS;

-- zad05
SELECT DEPARTMENT_ID, SUM(SALARY) AS SALARY_SUM, ROUND(AVG(SALARY)) AS SALARY_MEAN FROM EMPLOYEES
GROUP BY DEPARTMENT_ID HAVING MIN(SALARY) > 5000;

-- zad06
SELECT E.LAST_NAME, E.DEPARTMENT_ID, D.DEPARTMENT_NAME, E.JOB_ID FROM EMPLOYEES E
INNER JOIN DEPARTMENETS D on e.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN LOCATIONS L on L.LOCATION_ID = D.LOCATION_ID
WHERE L.CITY = 'Toronto';

-- zad07
SELECT e1.FIRST_NAME AS jennifer_first_name, e1.LAST_NAME AS jennifer_last_name,
       e2.FIRST_NAME AS coworker_first_name, e2.LAST_NAME AS coworker_last_name
FROM Employees e1
JOIN Employees e2 ON e1.EMPLOYEE_ID <> e2.EMPLOYEE_ID
WHERE e1.FIRST_NAME = 'Jennifer';

-- zad08
SELECT D.DEPARTMENT_NAME FROM DEPARTMENETS D
LEFT JOIN EMPLOYEES E on D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.EMPLOYEE_ID IS NULL;

-- zad09
CREATE TABLE JOB_GRADES AS (SELECT * FROM "HR"."JOB_GRADES");

-- zad10
SELECT FIRST_NAME, LAST_NAME, JOB_ID, D.DEPARTMENT_NAME, SALARY, J.GRADE FROM EMPLOYEES
JOIN DEPARTMENETS D on EMPLOYEES.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN JOB_GRADES J on EMPLOYEES.SALARY > J.MIN_SALARY AND EMPLOYEES.SALARY < J.MAX_SALARY;

-- zad11
SELECT FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
ORDER BY SALARY DESC;

-- zad12
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN (
    SELECT DISTINCT DEPARTMENT_ID FROM EMPLOYEES WHERE E.LAST_NAME LIKE '%u%'
);