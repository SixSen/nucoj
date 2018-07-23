
/*************************************************
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

#define OFFSET_OLE 1024

int main(int argc, char *argv[]) {
	// argv is command, runId, cid, pno, language, hostname username passwd dbname

	return 0;
}

int compile(int lang, const char* ceFile, const char* runId){// return 0 means compile success

	updateSubmitStatus(runId, OJ_CL, nullptr);/// set compiling

	int time_limit = COMPILE_TIME;/// time limit of compile
	int memory_limit = COMPILE_MEM*MB;/// memory limit of compile

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
	else if (pid != 0) {
		// parent process .pid=child_pid
		int status;
		waitpid(pid, &status, 0);///wait for child process

		return status;
	}
	else {// child pid=0
		  // set rlimit for compile
		struct rlimit lim;
		lim.rlim_cur = lim.rlim_max = time_limit;
		setrlimit(RLIMIT_CPU, &lim);

		alarm(0);
		alarm(time_limit);

		//	lim.rlim_max =
		lim.rlim_cur = memory_limit;
		setrlimit(RLIMIT_AS, &lim);

		lim.rlim_cur = lim.rlim_max = FILE_SIZE*MB;
		setrlimit(RLIMIT_FSIZE, &lim);

		//  start compile 
		freopen(ceFile, "w", stderr);
		switch (lang) {
		case LAN_C: execvp(COMP_C[0], (char* const*)COMP_C); break;
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


void updateSubmitStatus(const char* runId, int result, const char* ceInfo){// connect to Mysql 提交错误信息 ！！！待修改！！！ 

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

	// get time limit and memory limit of this problem from sql
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
			timeLimit = rs->getInt(3); // ms
			memLimit = rs->getInt(4);  // MB
		}

		delete rs;
		delete ps;
		delete conn;
	}
	catch (sql::SQLException& e) {
		saveErrorLog(e);
		updateSubmitStatus(runId, OJ_SE, 0, 0);
	}

	if (atoi(lang) == 3) {// java
		timeLimit <<= 1;
		memLimit <<= 1;
	}

	/* start judge */
	try {
		/* get all input data and output data of this problem */
		sql::Driver* driver = get_driver_instance();
		sql::Connection* conn = driver->connect(hostname, username, passwd);
		conn->setSchema(dbname);

		const char* sql = "call getInputOutputData(?,?)";
		sql::PreparedStatement* ps = conn->prepareStatement(sql);
		ps->setString(1, cid);
		ps->setString(2, pno);
		sql::ResultSet* rs = ps->executeQuery();

		int result = OJ_AC;
		int maxTime = 0;
		int topMem = 0;

		initAllowSysCall(atoi(lang));
		while (rs->next() && OJ_AC == result) {
			std::string inputData = rs->getString(1);
			std::string outputData = rs->getString(2);

			saveFile(inputData.c_str(), dataIn);

			int usedTime = 0;

			pid_t pidRun = fork();
			if (pidRun == 0) {
				// run the submit program
				run(atoi(lang), timeLimit, memLimit, usedTime, dataIn, userOut, errOut);
				exit(0);
			}
			else if (pidRun != -1) {
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