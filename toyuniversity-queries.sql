-- Name, major, and credits of every student from the student table

select distinct firstName, lastName, major, credits
from student;

-- Name, major, and credits of every student with 30
-- or greater credits

select distinct firstName, lastName, major, credits
from student
where credits >= 30;


-- Name, major, and credits of every student majoring in CSCI
select firstName, lastName, major, credits
from student
where major = 'CSCI'

-- Name of every student with a failing grade
select distinct firstName, lastName
from student
where stuId = (
	select stuId
	from enroll
	where grade = 'D' or 'F');
	
-- Name, class number, and grades of every student who took 
-- a class from a Computer Science faculty memeber
select distinct firstName, lastName, enroll.classNumber, grade
from student, enroll, faculty, class
where deptCode = 'CSCI'
and faculty.facId = class.facId
and enroll.classNumber = class.classNumber
and student.stuId = enroll.stuId;

-- Name, major, minor, and credits of every student with a Math
-- major and CSCI minor
select s.firstName, s.lastName, m.deptName as 'major', n.deptName as 'minor', s.credits
from student select
join department m on s.major = deptCode
join department n on s.minor = n.deptCode
where s.major = 'MATH' and s.minor = 'CSCI'; 

