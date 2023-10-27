-- zad 01 / 02
DECLARE
  numer_max DEPARTMENETS.department_id%TYPE;
BEGIN
  SELECT MAX(department_id) INTO numer_max FROM DEPARTMENETS;

  INSERT INTO DEPARTMENETS (department_id, department_name, LOCATION_ID)
  VALUES (numer_max + 10, 'EDUCATION', 3000);

  DBMS_OUTPUT.PUT_LINE('Nowy departament został dodany z numerem: ' || (numer_max + 10));
END;

SELECT * FROM DEPARTMENETS;

-- zad 03
CREATE TABLE NOWA (
    wartosc VARCHAR(60)
);

DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 10 LOOP
        IF i <> 4 AND i <> 6 THEN
            INSERT INTO NOWA(wartosc) VALUES (TO_CHAR(i));
        end if;
        i := i +1;
        end LOOP;
    COMMIT;
end;

-- zad 04
DECLARE
    country_row COUNTRIES%ROWTYPE;
    BEGIN
    SELECT * INTO country_row
    FROM COUNTRIES
        WHERE COUNTRY_ID = 'CA';

    DBMS_OUTPUT.PUT_LINE('Kraj: ' || country_row.COUNTRY_NAME);
    DBMS_OUTPUT.PUT_LINE('Region id: ' || country_row.REGION_ID);
end;

-- zad 05
DECLARE
TYPE departments_table IS TABLE OF DEPARTMENETS.department_name%TYPE
    INDEX BY PLS_INTEGER;
departments departments_table;
departments_id PLS_INTEGER := 10;
BEGIN
    WHILE departments_id <= 100 LOOP
        SELECT DEPARTMENT_NAME INTO departments(departments_id)
        FROM DEPARTMENETS WHERE DEPARTMENT_ID = departments_id;

        DBMS_OUTPUT.PUT_LINE('Departament  nr.' || departments_id || ': ' || departments(departments_id));

        departments_id := departments_id + 10;
    end LOOP;
end;

-- zad 06
DECLARE
TYPE departments_table IS TABLE OF DEPARTMENETS%ROWTYPE
    INDEX BY PLS_INTEGER;
departments departments_table;
departments_id PLS_INTEGER := 10;
BEGIN
    WHILE departments_id <= 100 LOOP
        SELECT * INTO departments(departments_id)
        FROM DEPARTMENETS WHERE DEPARTMENT_ID = departments_id;

        DBMS_OUTPUT.PUT_LINE('Departament nr.' || departments_id || ' nazwa: ' || departments(departments_id).DEPARTMENT_NAME || ' id lokalizacji: ' || departments(departments_id).LOCATION_ID || ' id managera: ' || departments(departments_id).MANAGER_ID);

        departments_id := departments_id + 10;
    end LOOP;
end;

-- zad 07
DECLARE
  CURSOR wynagrodzenie_cursor IS
    SELECT last_name, salary
    FROM employees
    WHERE department_id = 50;

  last_name employees.last_name%TYPE;
  salary employees.salary%TYPE;
BEGIN
  FOR employee_rec IN wynagrodzenie_cursor LOOP
    last_name := employee_rec.last_name;
    salary := employee_rec.salary;

    IF salary > 3100 THEN
      DBMS_OUTPUT.PUT_LINE(last_name || ' - nie dawać podwyżki');
    ELSE
      DBMS_OUTPUT.PUT_LINE(last_name || ' - dać podwyżkę');
    END IF;
  END LOOP;
END;

-- zad 08
DECLARE
  CURSOR zarobki_cursor (p_min_salary NUMBER, p_max_salary NUMBER, p_part_of_name VARCHAR2) IS
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary BETWEEN p_min_salary AND p_max_salary
      AND (LOWER(first_name) LIKE '%' || p_part_of_name || '%' OR UPPER(first_name) LIKE '%' || p_part_of_name || '%');

  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  -- Pracownicy z widełkami 1000-5000 i częścią imienia "a" lub "A"
  DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 1000-5000 i częścią imienia "a" lub "A":');
  FOR employee_rec IN zarobki_cursor(1000, 5000, 'a') LOOP
    v_first_name := employee_rec.first_name;
    v_last_name := employee_rec.last_name;
    v_salary := employee_rec.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ' - Zarobki: ' || v_salary);
  END LOOP;

  -- Pracownicy z widełkami 5000-20000 i częścią imienia "u" lub "U"
  DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 5000-20000 i częścią imienia "u" lub "U":');
  FOR employee_rec IN zarobki_cursor(5000, 20000, 'u') LOOP
    v_first_name := employee_rec.first_name;
    v_last_name := employee_rec.last_name;
    v_salary := employee_rec.salary;
    DBMS_OUTPUT.PUT_LINE(v_first_name || ' ' || v_last_name || ' - Zarobki: ' || v_salary);
  END LOOP;
END;
-- zad 09
-- a
CREATE OR REPLACE PROCEDURE AddJob(
    p_job_id IN Jobs.Job_id%TYPE,
    p_job_title IN Jobs.Job_title%TYPE
) AS
BEGIN
    INSERT INTO Jobs (Job_id, Job_title)
    VALUES (p_job_id, p_job_title);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas dodawania wiersza do tabeli Jobs.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END AddJob;

BEGIN
    ADDJOB('IT_PROG_JU', 'Programmer Junior');
    commit;
end;

-- b
CREATE OR REPLACE PROCEDURE ModifyJobTitle(
    p_job_id IN Jobs.Job_id%TYPE,
    p_new_job_title IN Jobs.Job_title%TYPE
) AS
BEGIN
    UPDATE Jobs
    SET Job_title = p_new_job_title
    WHERE Job_id = p_job_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No Jobs updated');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas modyfikacji tytułu pracy.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END ModifyJobTitle;

BEGIN
    MODIFYJOBTITLE('IT_PROG_', 'Junior programmer');
    commit;
end;

-- c
CREATE OR REPLACE PROCEDURE DeleteJob(
    p_job_id IN Jobs.Job_id%TYPE
) AS
BEGIN
    DELETE FROM Jobs
    WHERE Job_id = p_job_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No Jobs deleted');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas usuwania wiersza z tabeli Jobs.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END DeleteJob;

BEGIN
    DeleteJob('IT_PROG_JU');
    COMMIT;
end;

-- d
CREATE OR REPLACE PROCEDURE GetSalaryAndName(
    p_employee_id IN Employees.Employee_id%TYPE,
    p_salary OUT Employees.Salary%TYPE,
    p_last_name OUT Employees.Last_name%TYPE
) AS
BEGIN
    SELECT Salary, Last_name
    INTO p_salary, p_last_name
    FROM Employees
    WHERE Employee_id = p_employee_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Pracownik o podanym ID nie istnieje.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas pobierania danych pracownika.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END  GetSalaryAndName;

DECLARE
    v_salary Employees.Salary%TYPE;
    v_last_name Employees.Last_name%TYPE;
BEGIN
    GETSALARYANDNAME(101, v_salary, v_last_name);
    DBMS_OUTPUT.PUT_LINE('Zarobki pracownika: ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Nazwisko pracownika: ' || v_last_name);
END;

-- e
CREATE OR REPLACE PROCEDURE AddEmployee(
    p_first_name IN Employees.First_name%TYPE,
    p_salary IN NUMBER
) AS
    v_next_id NUMBER;
BEGIN
    IF p_salary > 20000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Wynagrodzenie nie może być wyższe niż 20000.');
    ELSE
        SELECT MAX(Employee_id) + 1 INTO v_next_id
        FROM Employees;
        DBMS_OUTPUT.PUT_LINE(v_next_id);

        INSERT INTO Employees (Employee_id, First_name, Salary, HIRE_DATE, EMAIL, JOB_ID, LAST_NAME)
        VALUES (v_next_id, p_first_name, p_salary, sysdate, 'M'||p_first_name, 'IT_PROG', 'Nowak');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas dodawania pracownika.');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END AddEmployee;

BEGIN
    ADDEMPLOYEE('Adam', 1000);
    commit;
end;
