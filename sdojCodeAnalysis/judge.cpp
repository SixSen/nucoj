﻿/*************************************************
     Copyright (c) 2018 中北大学 North University of China
     All rights reserved.

 @file  judge.cpp
 @brief 完成判题过程的程序

 @note  judge.cpp为完成判题过程，通过传递的参数编译用户的源代码,
		如果编译出错，则向数据库写入系统错误或编译错误及错误信息;
		否则，开始判题。判题时，通过链接数据库获取题目限制的时间
		和内存,并读取所有的输入数据、输出数据。

 @version			0.8        
 @author             （）
 @date				2018.7.23


     修订说明：
**************************************************/


#include <stdlib.h>
#include <iostream>
#include <string>
#include <cstring>
#include <fstream>
#include <sys/ptrace.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/reg.h>
#include <unistd.h>

#include "mysql_connection.h"
#include "cppconn/driver.h"
#include "cppconn/resultset.h"
#include "cppconn/prepared_statement.h"

//constant
#define MB 1048576
#define COMPILE_TIME 6	// time limit of compile
#define COMPILE_MEM 128	// memory limit of compile(MB)
#define FILE_SIZE 10
//tag of Language
#define LAN_C 1
#define LAN_CPP 2
#define LAN_JAVA 3
#define TOTAL_LAN 3
//status
#define OJ_AC 1			// Accepted 通过
#define OJ_WA 2			// Wrong Answer 答案错误 
#define OJ_TLE 3		// Time Limit Exceeded  超时
#define OJ_MLE 4		// Memory Limit Exceeded 内存超过限制
#define OJ_RE 5			// Runtime Error 运行时错误
#define OJ_OLE 6		// Output Limit Exceeded 输出文件超限制
#define OJ_CE 7			// Compile Error  编译出错
#define OJ_SE 8			// System Error 系统错误
#define OJ_QU 9			// Queue 排队状态
#define OJ_CL 10		// Compiling 正在编译
#define OJ_RN 11		// Running 正在判断

#define OFFSET_OLE 1024	//允许误差超出的文件长

char* hostname = nullptr;
char* username = nullptr;
char* passwd = nullptr;
char* dbname = nullptr;

const char* MYSQL_ERROR_LOG = "mysqlError.log";
const char* SYSTEM_ERROR_LOG = "systemError.log";

int main(int argc, char *argv[]) {
	//             1      2     3    4      5         6         7      8
	// argvs are runId, cid, pno, language, hostname username passwd dbname
	if (argc != 8 + 1) {
		printf("argv num error:%d\n", argc);
		return 1;
	}

	//	freopen("debug.dat", "w", stdout);

	hostname = argv[5];
	username = argv[6];
	passwd = argv[7];
	dbname = argv[8];

	const char* ceFile = "ce.dat";
	int status = compile(atoi(argv[4]), ceFile, argv[1]);

	if (status == -1) {// system error
		updateSubmitStatus(argv[1], -1, 0, 0);
	}
	else if (status != 0) {// compile error
		updateCompileErrorInfo(argv[1], ceFile);
	}
	else {// compile success
		judge(argv[1], argv[2], argv[3], argv[4]);
	}

	return 0;
}

int compile(int lang, const char* ceFile, const char* runId){// return 0 means compile success

	updateSubmitStatus(runId, OJ_CL, nullptr);// set compiling

	int time_limit = COMPILE_TIME;// time limit of compile
	int memory_limit = COMPILE_MEM*MB;// memory limit of compile

	// compile commands
	// .需要使用静态编译 否则会增大内存使用量
	const char * COMP_C[] = { "gcc","-Wall","-lm", "--static","Main.c","-o","Main",nullptr };
	const char * COMP_CPP[] = { "g++","-Wall","-fno-asm","-lm", "--static", "-std=c++11"
		,"Main.cpp","-o","Main",nullptr };
	const char * COMP_JAVA[] = { "javac","-J-Xms32m","-J-Xmx64m","-encoding","UTF-8"
		,"Main.java",nullptr };

	pid_t pid = fork();// used to create processes

	if (-1 == pid) {
		// create process fail
		std::ofstream fout(SYSTEM_ERROR_LOG, std::ios_base::out | std::ios_base::app);
		fout << "Error: fork() file when compile.\n";
		fout << "In file " << __FILE__ << " function (" << __FUNCTION__ << ")"
			 << " , line: " << __LINE__ << "\n";
		fout.close();
		return -1;///error
	}
	else if (0 != pid) {// parent process .pid==child_pid
		int status;
		waitpid(pid, &status, 0);///wait for child process  .waitpid(pid_t pid,int *status,int options)

		return status;
	}
	else {// child process .pid == 0
		// set rlimit for compile
		struct rlimit lim;
		lim.rlim_cur = lim.rlim_max = time_limit;
		setrlimit(RLIMIT_CPU, &lim);// set cpu time limit

		alarm(0);//取消之前设置的定时器闹钟，并将剩下的时间返回
		alarm(time_limit); //经过time_limit后，子进程终止

		lim.rlim_cur = memory_limit;
		setrlimit(RLIMIT_AS, &lim);// set memory limit

		lim.rlim_cur = lim.rlim_max = FILE_SIZE*MB;
		setrlimit(RLIMIT_FSIZE, &lim);//set the max size of output file

		//  start compile 
		freopen(ceFile, "w", stderr);
		switch (lang) {
		case LAN_C: execvp(COMP_C[0], (char* const*)COMP_C); break;///execvp()第一个参数path无需完整路径，它会在环境变量PATH当中查找命令
		case LAN_CPP: execvp(COMP_CPP[0], (char* const*)COMP_CPP); break;
		case LAN_JAVA: execvp(COMP_JAVA[0], (char* const*)COMP_JAVA); break;
		default: std::cerr << "Nothing to do.\n";
		}

		exit(0);
	}
}


void updateCompileErrorInfo(const char* runId, const char* ceFile){//write CompileError in ceFile

	std::ifstream fin(ceFile);
	std::string ceStr = "";
	std::string line;
	while (getline(fin, line)) {
		ceStr += line;
	}
	fin.close();

	updateSubmitStatus(runId, OJ_CE, ceStr.c_str());
}


void updateSubmitStatus(const char* runId, int result, const char* ceInfo){// connect to Mysql 提交错误信息 ++++++++++++++++++++++++++++++待修改！！！ 

	sql::Driver* driver = nullptr;
	sql::Connection* conn = nullptr;
	sql::PreparedStatement* ps = nullptr; /// 预编译语句（PreparedStatement）

	try {
		driver = get_driver_instance();
		conn = driver->connect(hostname, username, passwd);
		conn->setSchema(dbname);

		const char* sql = "call updateSubmitResult(?,?,?)";

		ps = conn->prepareStatement(sql);
		ps->setString(1, runId);
		ps->setInt(2, result);
		if (nullptr == ceInfo) 
		{
			const char* tmp = "";
			ps->setString(3, tmp);
		}
		else 
		{
			ps->setString(3, ceInfo);
		}
		ps->execute();

		delete ps;
		delete conn;
	}
	catch (sql::SQLException& e) {
		saveErrorLog(e);
	}

}


void judge(char* runId, char* cid, char* pno, char* lang) {//judge main

	updateSubmitStatus(runId, OJ_RN, nullptr);/// set Running status

	const char* dataIn = "data.in";		//
	const char* userOut = "user.out";
	const char* errOut = "err.out";

	// get time limit and memory limit of problem from sql
	int timeLimit = 1, memLimit = 64;
	try {
		sql::Driver* driver = get_driver_instance();
		sql::Connection* conn = driver->connect(hostname, username, passwd);
		conn->setSchema(dbname);

		const char* sql = "call showProblem(?,?)";
		sql::PreparedStatement* ps = conn->prepareStatement(sql);
		ps->setString(1, cid);
		ps->setString(2, pno);

		sql::ResultSet* rs = ps->executeQuery();
		if (rs->next()) {
			timeLimit = rs->getInt(3); /// ms
			memLimit = rs->getInt(4);  /// MB
		}

		delete rs;
		delete ps;
		delete conn;
	}
	catch (sql::SQLException& e) {//system error
		saveErrorLog(e);
		updateSubmitStatus(runId, OJ_SE, 0, 0);
	}

	if (atoi(lang) == 3) {// in java
		timeLimit <<= 1; //对于java语言，时间和内存的限制为其他语言的两倍
		memLimit <<= 1;
	}

	// start judge
	try {
		// get all input data and output data of this problem 
		sql::Driver* driver = get_driver_instance();
		sql::Connection* conn = driver->connect(hostname, username, passwd);
		conn->setSchema(dbname);/// collection of database objects

		const char* sql = "call getInputOutputData(?,?)";
		sql::PreparedStatement* ps = conn->prepareStatement(sql);
		ps->setString(1, cid);
		ps->setString(2, pno);
		sql::ResultSet* rs = ps->executeQuery();

		int result = OJ_AC;
		int maxTime = 0;
		int topMem = 0;

		initAllowSysCall(atoi(lang)); //？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
		while (rs->next() && OJ_AC == result) {//从数据库中得到测试用数据 ++++++++++++++++++++++++++++++++++++++++++++++++待修改
			std::string inputData = rs->getString(1);// 输入样例
			std::string outputData = rs->getString(2);// 输出答案

			saveFile(inputData.c_str(), dataIn);

			int usedTime = 0;

			pid_t pidRun = fork();
			if (pidRun == 0) {// child process
				// run the submit program
				run(atoi(lang), timeLimit, memLimit, usedTime, dataIn, userOut, errOut);
				exit(0);
			}
			else if (pidRun != -1) {// parent process
				// watch the running process, and update the result, max memory and time
				watchRunningStatus(pidRun, errOut, atoi(lang), result, topMem, usedTime
					, memLimit, timeLimit, userOut, outputData.length());
				if (maxTime < usedTime) maxTime = usedTime;
			}
			else {// system error
				std::ofstream fout(SYSTEM_ERROR_LOG, std::ios_base::out | std::ios_base::app);
				fout << "# ERR fork in " << __FILE__;
				fout << "function is (" << __FUNCTION__ << ") in line " << __LINE__ << "\n";
				fout.close();

				result = OJ_SE;
			}

			if (OJ_AC == result) {
				result = checkResult(outputData, userOut);
			}
		}

		delete rs;
		delete ps;
		delete conn;
		updateSubmitStatus(runId, result, maxTime, topMem >> 20);
	}
	catch (sql::SQLException& e) {
		saveErrorLog(e);
		updateSubmitStatus(runId, OJ_SE, 0, 0);
	}
}


void saveFile(const char* data, const char* fileName) {// function for save the data in file
	std::ofstream fout(fileName);
	fout << data;
	fout.close();
}


int checkResult(std::string dataOut, const char* userOutFileName) {// check the result
	// get user output data 
	std::ifstream fin(userOutFileName);
	std::string line;
	std::string userOut = "";/// the output result

	while (getline(fin, line)) {
		userOut += line + "\n";
	}

	fin.close();

	// compare
	int dLen = dataOut.length();
	int uLen = userOut.length();

	int result = OJ_AC;
	if (uLen >= (dLen << 1) + OFFSET_OLE) result = OJ_OLE;	// output limit exceeded
	else if (uLen != dLen || dataOut.compare(userOut) != 0) result = OJ_WA;// userOut != dataOut 
	///		👆先比对长度以提高效率
	return result;
}


void saveErrorLog(const sql::SQLException& e) {// error record

	std::ofstream fout(MYSQL_ERROR_LOG, std::ios_base::out | std::ios_base::app);

	fout << "# ERR: SQLException in " << __FILE__;
	fout << "# ERR: " << e.what();
	fout << " (MySQL error code: " << e.getErrorCode();
	fout << ", SQLState: " << e.getSQLState() << " )" << "\n";

	fout.close();

}


void run(int lang, int timeLimit, int memLimit, int& usedTime
	,const char* dataIn, const char* userOut, const char* errOut) {// function for runing the code

	freopen(dataIn, "r", stdin);
	freopen(userOut, "w", stdout);
	freopen(errOut, "w", stderr);

	ptrace(PTRACE_TRACEME, 0, nullptr, nullptr);

	// setrlimit
	struct rlimit lim;

	lim.rlim_cur = lim.rlim_max = timeLimit / 1000.0 + 1;// the unit of timeLimit is ms
	setrlimit(RLIMIT_CPU, &lim);
	alarm(0);
	alarm(timeLimit / 1000.0 + 1);

	lim.rlim_max = (FILE_SIZE << 20) + MB;// the unit of FILE_SIZE is MB
	lim.rlim_cur = FILE_SIZE << 20;
	setrlimit(RLIMIT_FSIZE, &lim);

	switch (lang) {
	case 3: // java
		lim.rlim_cur = lim.rlim_max = 80; break;
	default:
		lim.rlim_cur = lim.rlim_max = 1;
	}
	setrlimit(RLIMIT_NPROC, &lim);

	lim.rlim_cur = lim.rlim_max = MB << 6;
	setrlimit(RLIMIT_STACK, &lim);

	if (lang < 3) {
		lim.rlim_cur = memLimit * MB / 2 * 3;// the unit of memLimit is MB
		lim.rlim_max = memLimit * MB;
		setrlimit(RLIMIT_AS, &lim);
	}

	switch (lang) {
	case 1: case 2:// c and c++
		execl("./Main", "./Main", nullptr); break;
	case 3:// java
		char javaXms[32];
		sprintf(javaXms, "-Xmx%dM", memLimit);
		execl("/usr/bin/java", "/usr/bin/java", javaXms, "-Djava.security.manager"
			, "-Djava.security.policy=/usr/lib/jvm/java-8-oracle/jre/lib/security/my.policy", "Main", nullptr);
		break;
	}
}