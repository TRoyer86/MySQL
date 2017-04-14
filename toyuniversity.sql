--
-- Create a very simplified university database 
-- modeled on Ricardo.
--
-- Drop tables for house-keeping if necessary
--

DROP TABLE IF EXISTS Enroll;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Class;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Department;
--
CREATE TABLE IF NOT EXISTS Department (
    deptCode    varchar(4),
	deptName	varchar(20),
	CONSTRAINT Department_deptCode_pk PRIMARY KEY (deptCode),
	CONSTRAINT Department_name_ck UNIQUE (deptName)
);

CREATE TABLE IF NOT EXISTS Faculty	(
	facId		varchar(6),
	name	 	varchar(20)  NOT NULL,
	deptCode	varchar(4),
	rank 		varchar(10),
	CONSTRAINT Faculty_facId_pk PRIMARY KEY (facId),
	CONSTRAINT Faculty_deptCode_fk FOREIGN KEY (deptCode) REFERENCES Department(deptCode));

CREATE TABLE IF NOT EXISTS Class	(
	classNumber	varchar(8),
	facId	 	varchar(6)  NOT NULL,
	schedule  	varchar(8),
	room		varchar(6),
	CONSTRAINT Class_classNumber_pk PRIMARY KEY (classNumber),
	CONSTRAINT Class_facId_fk FOREIGN KEY (facId) REFERENCES Faculty (facId) ON DELETE CASCADE,
	CONSTRAINT Class_schedule_room_uk UNIQUE (schedule, room));

CREATE TABLE IF NOT EXISTS Student	(
	stuId		varchar(6),
	lastName	varchar(20)  NOT NULL,
	firstName 	varchar(20)  NOT NULL,
	major		varchar(4),
	minor		varchar(4) NULL,
	credits  	integer(3) DEFAULT 0,
	advisor		varchar(6) NULL,
	CONSTRAINT Student_stuId_pk PRIMARY KEY (stuId),
	CONSTRAINT Student_credits_cc CHECK ((credits>=0) AND (credits < 150)),
	CONSTRAINT Student_major_fk FOREIGN KEY (major) REFERENCES Department(deptCode) ON DELETE CASCADE,
	CONSTRAINT Student_minor_fk FOREIGN KEY (minor) REFERENCES Department(deptCode) ON DELETE CASCADE,
	CONSTRAINT Student_advisor_fk FOREIGN KEY (advisor) REFERENCES Faculty(facId)
); 
	

CREATE TABLE IF NOT EXISTS Enroll	(
	stuId		varchar(6),	
	classNumber	varchar(8),
	grade		varchar(2),
	CONSTRAINT Enroll_classNumber_stuId_pk PRIMARY KEY (classNumber, stuId),
	CONSTRAINT Enroll_classNumber_fk FOREIGN KEY (classNumber) REFERENCES Class(classNumber) ON DELETE CASCADE,	
	CONSTRAINT Enroll_stuId_fk FOREIGN KEY (stuId) REFERENCES Student (stuId)
		ON DELETE CASCADE);

INSERT INTO DEPARTMENT VALUES('CSCI','Computer Science');
INSERT INTO DEPARTMENT VALUES('MATH','Mathematics');
INSERT INTO DEPARTMENT VALUES('HIST','History');
INSERT INTO DEPARTMENT VALUES('ARTS','Arts');
INSERT INTO DEPARTMENT VALUES('PHYS','Physics');
INSERT INTO DEPARTMENT VALUES('MARK','Marketing');

INSERT INTO FACULTY VALUES('F101','Adams','ARTS','Professor');
INSERT INTO FACULTY VALUES('F105','Tanaka','CSCI','Instructor');
INSERT INTO FACULTY VALUES('F110','Byrne','MATH','Assistant');
INSERT INTO FACULTY VALUES('F115','Smith','HIST','Associate');
INSERT INTO FACULTY VALUES('F221','Smith','CSCI','Professor');
INSERT INTO FACULTY VALUES('F230','Johnson','PHYS','Associate');
		
INSERT INTO CLASS VALUES('ART103A','F101','MWF9','H221');
INSERT INTO CLASS VALUES('CSC201A','F105','TuThF10','M110');
INSERT INTO CLASS VALUES('CSC203A','F105','MThF12','M110');
INSERT INTO CLASS VALUES('HST205A','F115','MWF11','H221');
INSERT INTO CLASS VALUES('MTH101B','F110','MTuTh9','H225');
INSERT INTO CLASS VALUES('MTH103C','F110','MWF11','H225');
INSERT INTO CLASS VALUES('PHY333A','F230','MWF3','H225');		

INSERT INTO STUDENT VALUES('S1001','Smith','Tom','HIST','MARK',90,'F115');
INSERT INTO STUDENT VALUES('S1002','Chin','Ann','MATH','PHYS',36,'F110');
INSERT INTO STUDENT VALUES('S1005','Lee','Perry','HIST','ARTS',3,'F115');
INSERT INTO STUDENT VALUES('S1010','Burns','Edward','ARTS','CSCI',63,'F101');
INSERT INTO STUDENT VALUES('S1013','McCarthy','Owen','MATH','CSCI',0,'F110');
INSERT INTO STUDENT VALUES('S1015','Jones','Mary','MATH','CSCI',42,'F110');
INSERT INTO STUDENT VALUES('S1020','Rivera','Jane','CSCI','MATH',15,'F105');

INSERT INTO ENROLL VALUES('S1001','ART103A','A');
INSERT INTO ENROLL VALUES('S1001','HST205A','C');
INSERT INTO ENROLL VALUES('S1002','ART103A','D');
INSERT INTO ENROLL VALUES('S1002','CSC201A','F');
INSERT INTO ENROLL VALUES('S1002','MTH101B','C');
INSERT INTO ENROLL VALUES('S1002','MTH103C','B');
INSERT INTO ENROLL(stuId,classNumber) VALUES('S1010','ART103A');
INSERT INTO ENROLL(stuId,classNumber) VALUES('S1010','MTH103C');	
INSERT INTO ENROLL VALUES('S1020','CSC201A','B');
INSERT INTO ENROLL VALUES('S1020','MTH101B','A');
INSERT INTO ENROLL VALUES('S1020','MTH103C','C');
INSERT INTO ENROLL VALUES('S1005','HST205A','A');
INSERT INTO ENROLL VALUES('S1005','ART103A','B');
INSERT INTO ENROLL VALUES('S1005','CSC201A','C');
INSERT INTO ENROLL VALUES('S1010','CSC201A','A');
INSERT INTO ENROLL VALUES('S1015','CSC201A','B');