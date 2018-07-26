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
#define OJ_OLE 6		// Output Limit Exceeded 输出超限制
#define OJ_CE 7			// Compile Error  编译出错
#define OJ_SE 8			// System Error 系统错误
#define OJ_QU 9			// Queue 排队状态
#define OJ_CL 10		// Compiling 正在编译
#define OJ_RN 11		// Running 正在判断

#define OFFSET_OLE 1024	//允许误差超出的文件长

//对于可调用系统进程的要求
// C and C++
const int ALLOW_SYS_CALL_C[] = { 0,1,2,3,4,5,8,9,11,12,20,21,59,63,89,158,231,240, SYS_time, SYS_read, SYS_uname, SYS_write
, SYS_open, SYS_close, SYS_execve, SYS_access, SYS_brk, SYS_munmap, SYS_mprotect, SYS_mmap, SYS_fstat
, SYS_set_thread_area, 252, SYS_arch_prctl, 0 };
// java
const int ALLOW_SYS_CALL_JAVA[] = { 0,2,3,4,5,9,10,11,12,13,14,21,56,59,89,97,104,158,202,218,231,273,257,
61, 22, 6, 33, 8, 13, 16, 111, 110, 39, 79, SYS_fcntl, SYS_getdents64, SYS_getrlimit, SYS_rt_sigprocmask
, SYS_futex, SYS_read, SYS_mmap, SYS_stat, SYS_open, SYS_close, SYS_execve, SYS_access, SYS_brk, SYS_readlink
, SYS_munmap, SYS_close, SYS_uname, SYS_clone, SYS_uname, SYS_mprotect, SYS_rt_sigaction, SYS_getrlimit
, SYS_fstat, SYS_getuid, SYS_getgid, SYS_geteuid, SYS_getegid, SYS_set_thread_area, SYS_set_tid_address
, SYS_set_robust_list, SYS_exit_group, 158, 0 };

char* hostname = nullptr;
char* username = nullptr;
char* passwd = nullptr;
char* dbname = nullptr;

//错误记录
const char* MYSQL_ERROR_LOG = "mysqlError.log";
const char* SYSTEM_ERROR_LOG = "systemError.log";

int main(int argc, char *argv[]) {
	// argv is command, runId, cid, pno, language, hostname username passwd dbname

	return 0;
}

int compile(int lang, const char* ceFile, const char* runId){// return 0 means compile success

	updateSubmitStatus(runId, OJ_CL, nullptr);/// set compiling

	int time_limit = COMPILE_TIME;/// time limit of compile
	int memory_limit = COMPILE_MEM*MB;/// memory limit of compile

	// compile commands
	// .需要使用静态编译--static 否则会增大内存使用量
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

		alarm(0);//重设alarm（）防止之前的干扰
		alarm(time_limit);

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


void updateSubmitStatus(const char* runId, int result, int time, int mem) {
	sql::Driver* driver = nullptr;
	sql::Connection* conn = nullptr;
	sql::PreparedStatement* ps = nullptr;

	try {
		driver = get_driver_instance();
		conn = driver->connect(hostname, username, passwd);
		conn->setSchema(dbname);

		const char* sql = "call updateRunningResult(?,?,?,?)";
		ps = conn->prepareStatement(sql);

		ps->setString(1, runId);
		ps->setInt(2, result);
		ps->setInt(3, time);
		ps->setInt(4, mem);
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
		timeLimit <<= 1; //?????????????????????????????????????????????????????????????????????????????????????????
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

		initAllowSysCall(atoi(lang));
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
	,const char* dataIn, const char* userOut, const char* errOut) {// function for run program

	freopen(dataIn, "r", stdin);
	freopen(userOut, "w", stdout);
	freopen(errOut, "w", stderr);

	ptrace(PTRACE_TRACEME, 0, nullptr, nullptr);// start to  ptrace .PTRACE_TRACEME 指本进程被其父进程所跟踪.其父进程应该希望跟踪子进程

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

	if (lang < 3) {//c and c++
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


void watchRunningStatus(pid_t pidRun, const char* errFile, int lang, int& result, int& topMem
	, int& usedTime, int memLimit, int timeLimit, const char* userOut, int outputLen) {// watch the status of run function
	// the unit of memLimit is MB, the unit of timeLimit is ms

	int tmpMem = 0;
	int status, sig, exitCode;
	struct rusage usage;

	if (topMem == 0)
		topMem = getProcStatus(pidRun, "VmRSS:") << 10; // VmRSS是程序现在使用的物理内存

	wait(&status);// wait execl
	if (WIFEXITED(status)) return;// WIFEXITED(status)如果子进程正常结束则为非 0 值

	ptrace(PTRACE_SETOPTIONS, pidRun, nullptr
		, PTRACE_O_TRACESYSGOOD | PTRACE_O_TRACEEXIT | PTRACE_O_EXITKILL);

	ptrace(PTRACE_SYSCALL, pidRun, nullptr, nullptr);

	while (true) {
		wait4(pidRun, &status, __WALL, &usage);

		// update topMem and result
		if (lang == 3) tmpMem = getPageFaultMem(usage);
		else tmpMem = getProcStatus(pidRun, "VmPeak:") << 10;	// the unit of function is KB .VmPeak代表当前进程运行过程中占用内存的峰值

		if (tmpMem > topMem) topMem = tmpMem;
		if (topMem > (memLimit << 20)) {
			if (result == OJ_AC) result = OJ_MLE;
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);

			break;
		}

		if (WIFEXITED(status)) break;
		if (getFileSize(errFile) != 0) {
			//			std::cout << "RE in line " << __LINE__ << "\n";

			if (result == OJ_AC) result = OJ_RE;
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);
			break;
		}

		if (getFileSize(userOut) > outputLen * 2 + OFFSET_OLE) {
			if (result == OJ_AC) result = OJ_OLE;
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);
			break;
		}

		exitCode = WEXITSTATUS(status);
		if (!((lang == 3 && exitCode == 17) || exitCode == 0 || exitCode == 133 || exitCode == 5)) {
			//			std::cout << "error in line " << __LINE__ << ", exitCode is " << exitCode << "\n";

			if (result == OJ_AC) {
				switch (exitCode) {
				case SIGCHLD:
				case SIGALRM:
					alarm(0);
				case SIGKILL:
				case SIGXCPU:
					result = OJ_TLE;
					break;
				case SIGXFSZ:
					result = OJ_OLE;
					break;
				default:
					result = OJ_RE;
				}
			}
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);
			break;
		}

		if (WIFSIGNALED(status)) {
			sig = WTERMSIG(status);

			//			std::cout << "error in line " << __LINE__ << ", signal is " << sig << "\n";

			if (result == OJ_AC) {
				switch (sig) {
				case SIGCHLD:
				case SIGALRM:
					alarm(0);
				case SIGKILL:
				case SIGXCPU:
					result = OJ_TLE;
					break;
				case SIGXFSZ:
					result = OJ_OLE;
					break;
				default:
					result = OJ_RE;
				}
			}
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);
			break;
		}

		// check invalid system call, x64 is ORIG_RAX*8, x86 is ORIG_EAX*4
		int sysCall = ptrace(PTRACE_PEEKUSER, pidRun, ORIG_RAX << 3, nullptr);
		if (!allowSysCall[sysCall]) {
			//			std::cout << "error in line " << __LINE__ << ", system call id is " << sysCall << "\n";

			result = OJ_RE;
			ptrace(PTRACE_KILL, pidRun, nullptr, nullptr);
			break;
		}

		ptrace(PTRACE_SYSCALL, pidRun, nullptr, nullptr);
	}

	if (result == OJ_TLE) usedTime = timeLimit;
	else {
		usedTime += (usage.ru_utime.tv_sec * 1000 + usage.ru_utime.tv_usec / 1000);
		usedTime += (usage.ru_stime.tv_sec * 1000 + usage.ru_stime.tv_usec / 1000);
	}
}


int getProcStatus(int pid, const char* statusTitle) {// get memory info from /proce/pid/status
	char file[64];
	sprintf(file, "/proc/%d/status", pid);
	std::ifstream fin(file);
	std::string line;

	int sLen = strlen(statusTitle);

	int status = 0;// the unit of status is KB
	while (getline(fin, line)) {
		//		std::cout << line << "\n";

		int lLen = line.length();
		if (lLen <= sLen) continue;

		// find line
		bool flag = true;
		for (int i = 0; i<sLen; ++i) {
			if (line[i] != statusTitle[i]) {
				flag = false;
				break;
			}
		}

		if (flag) {
			// get status
			for (int i = sLen; i<lLen; ++i) {
				if (line[i] >= '0' && line[i] <= '9') status = status * 10 + line[i] - '0';
				else if (status) break;
			}
			break;
		}
	}

	//	std::cout << "\n";

	return status;
}


int getPageFaultMem(const struct rusage& usage) {// get the memory of java program
	return usage.ru_minflt * getpagesize();
}


int getFileSize(const char* fileName) {// get the memory of java program
	struct stat f_stat;

	if (stat(fileName, &f_stat) == -1) return 0;// int stat(const char * file_name, struct stat *buf); 获取文件状态 执行成功则返回0，失败返回-1
	else return f_stat.st_size; // in bytes 文件大小, 以字节计算
}

void initAllowSysCall(int lang) {
	memset(allowSysCall, false, sizeof(allowSysCall));

	switch (lang) {
	case 1: case 2:
		for (int i = 0; !i || ALLOW_SYS_CALL_C[i]; ++i) {
			allowSysCall[ALLOW_SYS_CALL_C[i]] = true;
		}
		break;
	case 3:
		for (int i = 0; !i || ALLOW_SYS_CALL_JAVA[i]; ++i) {
			allowSysCall[ALLOW_SYS_CALL_JAVA[i]] = true;
		}
		break;
	}
}