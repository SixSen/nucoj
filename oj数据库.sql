create database oj;
use oj;
create table Users
(
	userid varchar(20) primary key,
    email varchar(100) not null,
    uPassword varchar(50) not null,
    nick varchar(25) unique not null
);

create table TestSet
(
	setid char(2) primary key check(setid in('a','b','c','d','e')),
    setName varchar(30) not null,
    setNumusers smallint null,
    solvednum smallint null,
    updateTime datetime not NULL DEFAULT CURRENT_TIMESTAMP
);

create table TestProblem
(
	testid int primary key,
    setid char(2),
    testName varchar(30) not null,
    updateTime datetime not NULL DEFAULT CURRENT_TIMESTAMP,
    keyWord varchar(30) null,
    testStatus bit(1) default false,
    foreign key(setid) references testset(setid)
);
create table ProblemDetails
(
	testid int,
    description text not null,
    input text not null,
    output text not null,
    sampleinput text not null,
    sampleOutput text not null,
    datalimit text null,
    foreign key(testid) references testproblem(testid)
);
create table contest
(
	contestid smallint primary key,
    title varchar(200) not null,
    starttime datetime,
    endtime datetime,
    private bit(1) default 0,
    cLanguage varchar(6) not null default 'java' check(language in('c','c++','java'))
);
create table contestproblems
(
	testid int,
    contestid smallint,
    num tinyint,
    foreign key(testid) references testproblem(testid)
);
create table judgestatus
(
	submitid int auto_increment primary key, #自增
    userid varchar(20),
    testid int,
    submittime datetime,
    codelength varchar(10),
    jLanguage varchar(6) check(language in('c','c++','java')),
    result varchar(30),
    textCpu varchar(10),
    testMemory varchar(10),
    foreign key(testid) references testproblem(testid),
    foreign key(userid) references users(userid)
);
create table compileinfo
(
	submitid int,
    errortext text,
    foreign key(submitid) references judgestatus(submitid)
);
create table sourceinfo
(
	submitid int,
    sourceCode text not null,
    foreign key(submitid) references judgestatus(submitid)
);
