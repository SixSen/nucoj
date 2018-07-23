
/*************************************************
     Copyright (c) 2009, 华中科技大学      （版权声明）
     All rights reserved.

 @file  （judge.cpp）
 @brief （完成判题过程的程序）

（judge.cpp为完成判题过程，通过传递的参数编译用户的源代码,
  如果编译出错，则向数据库写入系统错误或编译错误及错误信息;
  否则，开始判题。判题时，通过链接数据库获取题目限制的时间
  和内存,并读取所有的输入数据、输出数据。）

 @version 1.1      （版本声明）
 @author             （）
 @date                 （2018.7.23）


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

#define MB 1048576
#define COMPILE_TIME 6
#define COMPILE_MEM 128
#define FILE_SIZE 10

#define LAN_C 1
#define LAN_CPP 2
#define LAN_JAVA 3
#define TOTAL_LAN 3

#define OJ_AC 1			// Accepted 通过
#define OJ_WA 2			// Wrong Answer 答案错误 
#define OJ_TLE 3		// Time Limit Exceeded  超时
#define OJ_MLE 4		// Memory Limit Exceeded 内存超过限制
#define OJ_RE 5			// Runtime Error 运行时错误（如数组访问越界）
#define OJ_OLE 6		// Output Limit Exceeded 输出文件超限制
#define OJ_CE 7			// Compile Error  编译出错
#define OJ_SE 8			// System Error 系统错误
#define OJ_QU 9			// Queue 排队状态
#define OJ_CL 10		//
#define OJ_RN 11		//

#define OFFSET_OLE 1024

int compile(int lang, const char* ceFile, const char* runId){// return 0 means compile success

	updateSubmitStatus(runId, OJ_CL, nullptr);/// set compiling
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
void updateSubmitStatus(const char* runId, int result, const char* ceInfo){// connect to Mysql and

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