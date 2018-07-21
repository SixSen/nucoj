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
//judge״̬
#define OJ_AC 1
#define OJ_WA 2
#define OJ_TLE 3
#define OJ_MLE 4
#define OJ_RE 5
#define OJ_OLE 6
#define OJ_CE 7
#define OJ_SE 8
#define OJ_QU 9
#define OJ_CL 10
#define OJ_RN 11

#define OFFSET_OLE 1024
