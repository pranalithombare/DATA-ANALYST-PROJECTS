CREATE TABLE dept (
    deptno INT,
    dname VARCHAR(50),
    loc VARCHAR(40)
);

INSERT INTO dept (deptno, dname, loc)
VALUES (10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30,'SALES','CHICAGO'),
(40,'ACCOUNTING', 'NEW YORK');

ALTER TABLE dept ADD PRIMARY KEY (deptno);

CREATE TABLE employee (
empno INT NOT NULL UNIQUE,
ename VARCHAR(50),
job VARCHAR(50) DEFAULT 'Clerk',
mgr INT,
hiredate DATE,
sal FLOAT CHECK(sal>0),
comm FLOAT,
deptno INT,
FOREIGN KEY (deptno) REFERENCES dept(deptno)
);


INSERT INTO employee (empno, ename, job, mgr, hiredate, sal, comm, deptno)
VALUES (7369, 'SMITH','CLERK' ,7902, '1890-12-17', 800.00, NULL ,20 ),
(7499, 'ALLEN', 'SALESMAN' ,7698, '1981-02-20', 1600.00, 300.00 ,30 ),
(7521, 'WARD','SALESMAN' ,7698, '1981-02-22', 1250.00, 500.00 ,30 ),
(7566, 'JONES','MANAGER' ,7839, '1981-04-02', 2975.00, NULL ,20 ),
(7654, 'MARTIN','SALESMAN' ,7698, '1981-09-28', 1250.00, 1400.00 ,30 ),
(7698, 'BLAKE','MANAGER', 7839, '1981-05-01', 2850.00, NULL ,30 ),
(7782, 'CLARK','MANAGER' ,7839, '1981-06-09', 2450.00,NULL,10 ),
(7788, 'SCOTT','ANALYST' ,7566, '1987-04-19', 3000.00, NULL ,20 ),
(7839, 'KING','PRESIDENT',NULL , '1981-11-17', 5000.00, NULL,10),
(7844, 'TURNER','SALESMAN' ,7698, '1981-09-08', 1500.00,0.00 ,30 ),
(7876, 'ADAMS','CLERK', 7788, '1987-05-23', 1100.00, NULL,20),
(7900, 'JAMES','CLERK' , 7698, '1981-12-03', 950.00, NULL,30),
(7902, 'FORD','ANALYST' ,7566, '1981-12-03', 3000.00,NULL ,20),
(7934, 'MILLER','CLERK' ,7782, '1982-01-23', 1300.00, NULL,10 );

#Q3.	List the Names and salary of the employee whose salary is greater than 1000

SELECT 
    ename, sal
FROM
    employee
WHERE
    sal > 1000;

#Q 4.	List the details of the employees who have joined before end of September 81.

SELECT 
    *
FROM
    employee
WHERE
    hiredate < '1981-09-30';

#Q 5.	List Employee Names having I as second character.

SELECT 
    *
FROM
    employee
WHERE
    ename LIKE '_I%';

#Q 6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns

SELECT 
    ename,
    sal,
    0.4 * sal AS 'Allowances',
    0.1 * sal AS 'P.F.',
    1.5 * sal AS 'Net Salary'
FROM
    employee;

#Q 7. 	List Employee Names with designations who does not report to anybody

SELECT 
    ename, job
FROM
    employee
WHERE
    mgr IS NULL;

#Q8.	List Empno, Ename and Salary in the ascending order of salary.

SELECT 
    empno, ename, sal
FROM
    employee
ORDER BY sal ASC;

#Q 9.	How many jobs are available in the Organization ?
SELECT 
    COUNT(DISTINCT (job)) AS 'Jobs available'
FROM
    employee;

#Q 10.	Determine total payable salary of salesman category

SELECT 
    SUM(sal)
FROM
    employee
WHERE
    job = 'SALESMAN';

#Q 11.	List average monthly salary for each job within each department   

SELECT 
    AVG(sal) AS 'Average Monthly Sal', job
FROM
    employee
GROUP BY job;

#Q 12.	Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.

SELECT 
    ename, sal, dname
FROM
    employee
        LEFT JOIN
    dept ON employee.deptno = dept.deptno;
    
CREATE TABLE job_grade(
grade VARCHAR(20),
lowest_sal INT,
highest_sal INT);

INSERT INTO job_grade( grade, lowest_sal, highest_sal)
VALUES('A',0,999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

#Q 14.	Display the last name, salary and  Corresponding Grade.

SELECT 
    ename, sal, grade
FROM
    employee,
    job_grade
WHERE
    sal BETWEEN lowest_sal AND highest_sal;

#Q15.	Display the Emp name and the Manager name under whom the Employee works in the below format . Emp Report to Mgr.

SELECT 
    e.ename AS 'Emp', m.ename AS 'Report to Mgr'
FROM
    employee e
        LEFT OUTER JOIN
    employee m ON e.mgr = m.empno;

#Q16.	Display Empname and Total sal where Total Sal (sal + Comm)

SELECT 
    ename AS 'Empname',
    CASE
        WHEN comm > 0 THEN sal + comm
        ELSE sal
    END AS 'Total Sal'
FROM
    employee;

#Q 17.	Display Empname and Sal whose empno is a odd number

SELECT 
    ename AS Empname, Sal
FROM
    employee
WHERE
    empno % 2 = 1;

#Q 18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department

SELECT ename AS Empname, RANK() OVER (ORDER BY sal DESC) 'Rank of sal in Organisation', RANK() OVER ( PARTITION BY deptno ORDER BY sal DESC) 'Rank of Sal in their department' FROM  employee ORDER BY ename;

#Q 19.	Display Top 3 Empnames based on their Salary
 SELECT ename AS Empname, RANK() OVER (ORDER BY sal DESC) 'Rank' FROM  employee LIMIT 3;
 
#Q 20. Empname who has highest Salary in Each Department.

SELECT 
    ename
FROM
    employee e
WHERE
    e.sal IN (SELECT 
            MAX(sal)
        FROM
            employee
        GROUP BY deptno
        ORDER BY ename)
LIMIT 3;
