--Deliverable 1
-- Retreive Employee Number, First Name, Last Name
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
From employees as e
Join titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no
;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
    rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

-- Retrieve number of employees about to retire by recent job title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Deliverable 2
--Mentorship Eligibility

SELECT DISTINCT ON (e.emp_no)e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e 
JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE de.to_date = '9999-01-01' AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Additional Tables and Queries

-- Create table with salaries of all eligible mentors
SELECT DISTINCT ON (e.emp_no)e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title,
	s.salary
INTO mentorship_eligibility_salary
FROM employees AS e 
JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
JOIN titles AS t
ON (e.emp_no = t.emp_no)
JOIN salaries AS s on (e.emp_no = s.emp_no)
WHERE de.to_date = '9999-01-01' AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Create table with Avg Salary by role
SELECT COUNT(title),title, Avg(salary)::numeric(10,2)
INTO mentorship_salary_avg
FROM mentorship_eligibility_salary
GROUP BY title
ORDER BY COUNT(title) DESC;

--Get Employee info for all Current employees
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	t.title,
	t.from_date,
	t.to_date
--into all_titles
From employees as e
Join titles as t
ON (e.emp_no = t.emp_no)
ORDER BY e.emp_no
;

-- Use Dictinct with Orderby to remove duplicate rows and calculate Age
SELECT DISTINCT ON (t.emp_no) t.emp_no,
    t.first_name,
    t.last_name,
	t.birth_date,
	AGE('2021-04-22',t.birth_date) as age,
    t.title
INTO all_unique_titles
FROM all_titles as t
ORDER BY t.emp_no, t.to_date DESC;

-- Create table of Age statistics by title
SELECT title, COUNT(title), avg(age), min(age), max(age)
INTO title_age_stats 
FROM all_unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Mentor title Count
select * from mentorship_eligibility;
SELECT DISTINCT ON (me.emp_no) me.emp_no,
    me.first_name,
    me.last_name,
    me.title
INTO unique_titles_mentors
FROM mentorship_eligibility as me
ORDER BY me.emp_no, me.to_date DESC;

-- Retrieve number of employees eligilbe for Mentor Program by recent job title
SELECT COUNT(title), title
INTO mentoring_titles
FROM unique_titles_mentors
GROUP BY title
ORDER BY COUNT(title) DESC;