/*
problem [1]
*/
select A from B;
select * from R where B=17;
select * from R,S;
select R.A,S.C from R,S where R.C=S.A;
select *from R union select *from S;
select R.A,R.B,R.C from R,S where R.A=S.A and R.B=S.B and R.C=S.C;
select R.A,R.B,R.C from R,S where R.A!=S.A or R.B!=S.B or R.C!=S.C;
select R.A, R.B, S.C from R,S where R.B=S.B

/*
problem [2] 
*/
create table EMP(
ENO int(10) primary key,
ENAME varchar(30) NOT NULL,
SEX ENUM('F','M'),
ECITY varchar(50)
);


create table PROJECT(
PNO int(4) primary key,
PNAME varchar(40),
STATUS enum('0','1'),
PCITY varchar(50),
PRINCIPAL varchar(100)
);

create table EMPPROJECT(
ENO int(10),
PNO int(4)
);

/*查询至少参与两个项目的职工编号和参与的项目数*/
select count(*) as cnt,EMP.ENO from EMPPROJECT,EMP where EMPPROJECT.ENO=EMP.ENO
	group by EMP.ENO having cnt>1; 
/*查询参与居住城市正在进行工程项目的职工编号和姓名*/
select distinct EMP.ENO,ENAME from EMP, PROJECT,EMPPROJECT where EMP.ECITY=PROJECT.PCITY	
	and EMP.ENO=EMPPROJECT.ENO and EMPPROJECT.PNO=PROJECT.PNO 
	and PROJECT.STATUS='0';
/*假设项目编号为“p001"的项目负责人李强其用户名为U1，有对参与该项目的职工进行查询的权限，
建立视图EMP好进行授权的SQL语句*/
create view emp as select EMP.ENO, ENAME,SEX,ECITY from EMP,EMPPROJECT where 
	EMPPROJECT.PNO='p001' and EMP.ENO=EMPPROJECT.ENO;
/*授权*/
grant select on emp to mo_user@'%' identified by 'U1';

/*
Problem [3]
*/

/*create tables*/
create table STUDENT(
Sno char(9) primary key,
SNAME varchar(30),
SAGE int(4),
SSEX enum('F','M')
);

create table COURSE(
Cno char(9) primary key,
CNAME varchar(30),
Tno char(9)
);

create table SC(
Sno char(9), 
Cno char(9), 
SCORE int,
primary key(Sno,Cno)
);

create table TEACHER(
Tno char(9),
TNAME varchar(30),
primary key(Tno)
);

/*查询平均成绩达到优秀以上的同学的姓名和课程名*/
select SNAME,CNAME from COURSE c1, STUDENT s1,SC sc where c1.Cno=SC.Cno and s1.Sno=SC.Sno

select SNAME,CNAME from COURSE,STUDENT where Sno in 
	(
	select Sno from SC 
	group by Sno
	having AVG(SCORE)>=90
	);

insert into STUDENT values('S9','WU','1993','M');
/*把王同学的选课和成绩全部删去*/
delete from SC where SC.Sno in (select Sno from STUDENT where SNAME='WANG');
/*查询学过编号001和编号002课程的同学的学号和姓名*/
select STUDENT.Sno,SNAME from STUDENT,SC sc1, SC sc2 
where sc1.Sno=sc2.Sno and sc1.Sno=STUDENT.Sno and sc1.Cno='001' and sc2.Cno='002';
/*查询所有课程成绩都不及格的同学的学号和姓名*/
select distinct STUDENT.Sno,SNAME from STUDENT,SC where SC.Sno=STUDENT.Sno and STUDENT.Sno not in 
( select SNO from SC where SC.score>=60);
/*查询各科成绩最高和最低的分数显示，课程ID，最高分，最低分*/
select Cno, MAX(score), MIN(score) from SC 
group by Cno;
/*查询不同老师所教的不同课程平均分从高到低显示*/
select SC.Cno,AVG(score) as avg_score ,COURSE.Tno from COURSE,SC where COURSE.Cno=SC.Cno
group by SC.Cno
order by avg_score desc;
/*查询学生平均成绩和排名*/
select Sno,AVG(score) as avg_score from SC
group by Sno
order by avg_score desc;
/*把低于平均成绩的女同学的成绩提高5%*/

/*update SC sc1 set sc1.score=sc1.score*1.05 where (sc1.Cno,sc1.Sno) in 
----------------------------------------
select sc.Cno,sc.Sno from   查询是对的
(select Cno,AVG(sc2.score) as avgs from SC  sc2 group by sc2.Cno) as avg_score, SC sc,STUDENT st
where sc.Cno=avg_score.Cno and st.Sno=sc.Sno and st.SSEX='F'  and sc.score<avg_score.avgs;*/

update SC sc1 inner join (select sc.Cno as cno,sc.Sno as sno from 
(select Cno,AVG(sc2.score) as avgs from SC  sc2 group by sc2.Cno) as avg_score, SC sc,STUDENT st
where sc.Cno=avg_score.Cno and st.Sno=sc.Sno and st.SSEX='F'  and sc.score<avg_score.avgs) T2
on sc1.Sno=T2.sno and sc1.Cno=T2.cno
set sc1.score=sc1.score*1.05;

/*查询两门以上课程不及格的同学的学号和平均成绩*/
select SC.Sno,AVG(SC.score)as avg_score from SC where SC.Sno in(
select sc2.Sno as sno from SC sc2 where sc2.score<60 group by sc2.Sno having count(*)>=2)
group by SC.Sno;

/*查询每门功课成绩最好的前两名*/
select sc.Sno,sc.Cno,sc.score from SC sc,
(select sc1.Sno, sc1.Cno  from SC sc1,SC sc2 where sc1.Cno=sc2.Cno and sc1.score<=sc2.score
group by sc1.Cno,sc1.Sno
having count(*)<=2)T2
where sc.Sno=T2.Sno and sc.Cno=T2.Cno;

/*查询1991年出生的学生名单*/
select * from STUDENT where STUDENT.SAGE='1991';S
/*
Problem [4]
*/
/*create tables*/
create table DEPT(
DEPTNO char(4) primary key,
DNAME varchar(30),
LOC varchar(30)
);

create table EMP4(
EMPNO char(4) primary key,
ENAME varchar(30),
JOB varchar(30),
MGR varchar(30),
HIREDATE date,
SAL int,
COMM int(30),
DEPTNO char(4)
);

create table SALGRADE(
GRADE int primary key,
LOSAL int,
HISAL int
);

/*薪水大于1200的雇员，按照部门编号进行分组，分组后的平均薪水必须大于1500，查询各个分组的平均工资，按照工资的倒序进行排列*/
select emp1.DEPTNO,AVG(emp1.SAL) as avg_sal from EMP4 emp1, DEPT dept 
where emp1.DEPTNO=dept.DEPTNO and emp1.SAL>1200 
group by emp1.DEPTNO 
having avg_sal>1500
order by avg_sal;

/*查询每个雇员和其经理的姓名*/
select  emp1.ENAME as employee_name, emp2.ENAME as manager_name from EMP4 emp1,EMP4 emp2
where emp1.MGR=emp2.EMPNO and emp1.MGR!=emp1.EMPNO;
/*查询每个雇员和经理的姓名（包括公司老板本身（他上面没有经理））*/
select  emp1.ENAME as employee_name, emp2.ENAME as manager_name from EMP4 emp1,EMP4 emp2
where emp1.MGR=emp2.EMPNO;
/*查询每个部门中工资最高的人的姓名，薪水和部门编号*/
select emp1.ENAME, MAX(emp1.SAL)as max_salary,emp1.DEPTNO from EMP4 emp1
group by emp1.DEPTNO;
/*查询每个部门平均工资所在的等级*/
select T1.DEPTNO,SALGRADE.GRADE from (select AVG(emp1.SAL) as avg_sal,DEPTNO from EMP4 emp1 group by emp1.DEPTNO)T1,SALGRADE 
where T1.avg_sal<SALGRADE.HISAL and avg_sal>=SALGRADE.LOSAL;
/*不准用库函数，求雇员表中薪水最高值*/
select emp1.SAL from EMP4 emp1
where emp1.EMPNO not in (
	select distinct emp2.EMPNO from EMP4 emp2,EMP4 emp3
	where emp2.SAL<emp3.SAL
);
/*平均薪水最高的部门的部门编号*/
select DEPTNO from (
select AVG(emp1.SAL)as avg_sal, emp1.DEPTNO from EMP4 emp1 
group by emp1.DEPTNO
order by avg_sal DESC)T1
limit 0,1;

/*查询平均薪水的等级最低的部门名称*/
select  MIN(GRADE) as min_grade,dept.DNAME from DEPT dept,(
	select T1.DEPTNO,SALGRADE.GRADE from (select AVG(emp1.SAL) as avg_sal,DEPTNO from EMP4 emp1 group by emp1.DEPTNO)T1,SALGRADE 
	where T1.avg_sal<SALGRADE.HISAL and avg_sal>=SALGRADE.LOSAL
)T2
where dept.DEPTNO=T2.DEPTNO;

/*
problem [5]
*/
/*create tables*/
create table MEMBER(
MID int(5) primary key,
USER varchar(40) unique,
PASSWORD varchar(40),
MNAME varchar(40),
ADDRESS varchar(40),
PHONE char(20),
CONSUMPTION float,
POINT int
);

create table BOOK(
BID varchar(40) primary key,
CLASS int,
BNAME varchar(50),
AUTHOR varchar(50),
PUBLISH varchar(50),
PUBLISHDATE date,
ISBN varchar(50),
PRICE float
);

create table ORDERS(
OID varchar(30) primary key,
USER varchar(40),
SALES float,
ORDERDATE date,
SHIPMENTDATE date
);

create table ORDERDETAIL(
ODID int primary key,
OID varchar(30),
BID varchar(40),
NUMBER int
);


/*查询名称中包含“数据库”的图书的图书名称，作者，出版社和出版日期*/
select BOOK.BNAME,BOOK.PUBLISH,BOOK.PUBLISHDATE from BOOK where BOOK.BNAME like '%数据库%';
/*查询提供销售（图书表中有）但没有销售过（没在订单明细中出现过）的图书名称和出版社*/
select leftbid,BNAME,PUBLISH from (
	select * from (select book.BID as leftbid,book.BNAME,book.PUBLISH from BOOK book)T1 left join 
	(select detail.BID as rightbid from ORDERDETAIL detail)T2 on leftbid=rightbid
	)T3
where T3.rightbid is null;
/*查询订购图书数量最多的会员名和订购的数量*/
select MAX(book_sum)as max_book_sum,USER from
(select sum(d1.NUMBER)as book_sum, o1.USER from ORDERS o1,ORDERDETAIL d1
where o1.OID=d1.OID
group by o1.OID)T1;
/*为了统计会员的购买行为信息，实施有意义的客户关怀策略，查询会员的平均订购时间，考虑多次够买图书和一次够买图书的情况*/
select T2.time_interval div T1.book_sum,T1.USER from
(select sum(d1.NUMBER) as book_sum,o1.USER from ORDERS o1,ORDERDETAIL d1
where o1.OID=d1.OID
group by o1.USER)T1,
(select datediff(MAX(o2.ORDERDATE),MIN(o2.ORDERDATE))as time_interval,o2.USER from ORDERS o2
group by o2.USER)T2
where T1.USER=T2.USER;
/*会员订购图书后，将本次订购的销售额累加到会员的消费额中，并按照本次订单的销售额计算积分累加到该会员的积分中（每20元增加1个积分，不足20元
的不计入积分，用触发器实现*/
delimiter |
create trigger update_member after insert on ORDERS
for each row
begin
	update MEMBER set MEMBER.CONSUMPTION=MEMBER.CONSUMPTION+NEW.SALES,MEMBER.POINT=MEMBER.POINT+(NEW.SALES div 20)
	where MEMBER.USER=NEW.USER;
end;|
delimiter ;