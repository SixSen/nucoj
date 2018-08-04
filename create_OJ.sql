create database OJ;
use OJ;

set foreign_key_checks = 0;

create table Users
(
    userId int auto_increment primary key, #用户Id设为主键，设置自增
    email varchar(100) not null, #邮箱号，非空
    uPassword varchar(50) not null, #用户密码，非空
    nick varchar(25) unique not null  #昵称唯一，非空,注册是手动输入
);

create table TestType
(
    typeId varchar(2) primary key check(typeId in('a','b','c','d','e')), 
		#题目类型Id设为主键，其约束条件：判断类型是否属于('a','b','c','d','e')的其中一种，否则不能写进数据库
    typeName varchar(30) not null, #题目类型名，非空
    typeNumber smallint null, #本类型题目数量，可空
    updateTime datetime not NULL DEFAULT CURRENT_TIMESTAMP  #更新时间，自动获取本地时间，非空
);

create table TestProblem
(
    testId int auto_increment primary key, #题目Id设为主键，设置自增
    typeId varchar(2), #题目类型Id
    testName varchar(30) not null, #题目名称，非空
    updateTime datetime not NULL DEFAULT CURRENT_TIMESTAMP, #更新时间，自动获取本地时间，非空
    keyWord varchar(30) null, #关键字，可空
    tPrivate Boolean default false, #题目公布与否，true对外公布，false不对外公布，默认为对外公布
    description text not null, #题目描述，非空
    input text not null, #输入格式，非空
    output text not null, #输出格式，非空
    sampleInput text not null, #样例输入，非空
    sampleOutput text not null, #样例输出，非空
    javaTime varchar(15) not null, #JAVA语言的时间限制，非空
    javaMemory varchar(15) not null, #JAVA语言的内存限制，非空
    othersTime varchar(15) not null, #C/C++语言的时间限制，非空
    othersMemory varchar(15) not null, #C/C++语言的内存限制，非空
    answerPath varchar(100) not null, #本题答案的相对路径，非空（暂定命名格式为当前时间）
    tPassRate double,#本题的通过率
    foreign key(typeId) references TestType(typeId) #从TestType表中引入题目类型Id，设为外键
);

create table ResultSet
(
    rSubmitId int auto_increment primary key, #提交Id设为主键，设置自增
    userId int, #用户Id
    testId int, #题目Id
    rSubmitTime datetime not null DEFAULT CURRENT_TIMESTAMP, #提交时间，自动获取本地时间，非空 
    codeLength varchar(10), #代码长度
    rLanguage varchar(6) not null default 'JAVA' check(language in('C','C++','JAVA')), 
		#语言，非空，其约束条件：判断类型是否属于('C','C++','JAVA')的其中一种，否则不能写进数据库
    result tinyint, #本次提交的提交结果
    textCpu varchar(10), #消耗的cpu
    testMemory varchar(10), #消耗的内存
    sourceCode text not null, #本次提交的题目的源代码
    foreign key(testId) references TestProblem(testId), #从TestProblem表中引入题目Id，设为外键
    foreign key(userId) references Users(userId) #从Users表中引入用户Id，设为外键
);

create table CompileInfo
(
    rSubmitId int unique not null, #提交Id，为了防止恶意修改，设为非空且唯一
    errorText text, #编译错误的具体信息
    foreign key(rSubmitId) references ResultSet(rSubmitId) #从ResultSet表中引入提交Id，设为外键
);

create table Contest
(
    contestId smallint primary key, #考试Id，设为主键
    title varchar(200) not null, #考试名称，非空
    startTime datetime, #考试开始时间
    endTime datetime, #考试结束时间
    cPrivate boolean default false, #题目开放与否，true对外开放，false不对外开放，默认为不对外开放
    cLanguage varchar(6) not null default 'JAVA' check(language in('C','C++','JAVA')), 
		#语言，非空，其约束条件：判断类型是否属于('C','C++','JAVA')的其中一种，否则不能写进数据库
    rankRule varchar(2) default 'a' check(rankRule in('a','b','c')) 
		#排名规则（暂定有三种）
);

create table ContestProblem
(
    testId int, #题目Id
    contestId smallint, #考试Id
    problemNum tinyint not null, #该题目在本次考试中的序号，非空
    cPassRate double, #本题的通过率
    primary key(testId,contestId), #表级完整性约束，将（testId,contestId）设为主键
    foreign key(testId) references TestProblem(testId), #从TestProblem表中引入题目Id，设为外键
    foreign key(contestId) references Contest(contestId) #从ContestProblem表中引入考试Id，设为外键
);

create table ContestResultSet
(
    cSubmitId int auto_increment primary key, #考试提交Id，设为主键，自增
    userId int, #用户Id
    testId int, #题目Id
    contestId smallint, #考试Id
    result tinyint,
    cSubmitTime datetime not null DEFAULT CURRENT_TIMESTAMP, #提交时间，自动获取本地时间，非空 
    testCode text not null, #本次提交的题目的源代码
    foreign key(userId) references Users(userId), #从Users表中引入用户Id，设为外键
    foreign key(testId) references TestProblem(testId), #从TestProblem表中引入题目Id，设为外键
    foreign key(contestId) references Contest(contestId) #从ContestProblem表中引入考试Id，设为外键
);

create table ContestGoal
(
    userId int, #用户Id
    testId int, #题目Id
    contestId smallint, #考试Id
    submitNum int, #提交次数，默认为1,非空
    score int, #考试得分
    primary key(userId,testId,contestId), #表级完整性约束，将(userId,testId,contestId)设为主键
    foreign key(userId) references Users(userId), #从Users表中引入用户Id，设为外键
    foreign key(testId) references TestProblem(testId), #从TestProblem表中引入题目Id，设为外键
    foreign key(contestId) references Contest(contestId) #从ContestProblem表中引入考试Id，设为外键
);

set foreign_key_checks = 1;
