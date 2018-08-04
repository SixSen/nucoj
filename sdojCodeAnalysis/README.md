## Online Judge

----

## 0. 简介

>* 首先是一定要感谢HUST OJ的大大们的，阅读源代码的过程中经验值飞增。
>* 这是一个使用JSP实现的简单的OJ，对数据库的操作均通过调用存储过程和激发触发器来实现。~~（所以最后写出来的存储过程好多啊。。。。）~~
>* 数据库的信息，例如地址啊用户名啊密码啊没有写在Java类里，而是写了一个叫做databaseInfo.xml的文件（在web/WEB-INF路径下），
>* 然后用一个监听类来获取这个文件的绝对路径地址，在ConnectionDao这个类里读取出相应的信息，这样移植起来就方便啦，不给源码只给编译后的class文件的话也可以修改数据库。
>* 判题的隔离问题使用Docker来实现，下载了一个ubuntu镜像，然后自己在镜像中安装gcc, g++, java, 并新建一个弱权限的用户。把修改后的镜像保存起来，在判题时进入docker使用弱权限用户运行程序。
>* JSP只负责前端和处理用户提交的信息。用户提交代码后，JSP将信息写入数据库，提交状态设置成queueing，之后就不需要管了，全权交给Linux端去弄。
>* Linux端有两个程序，一个是轮询程序（polling.cpp），另一个是判题程序（judge.cpp），两个程序的参数都是通过命令行传参的，因此我又另外写了两个shell脚本（startup.sh和judge.sh）去执行程序。
>* Linux端C++与数据库的连接是使用[mysql-connector-c++](https://dev.mysql.com/doc/connector-cpp/en/)实现的。

----

## 1. 目前实现的功能


>- [x] 登录、注册、修改个人信息； ~~（这不是废话吗）~~
>- [x] 通过竞赛的标题搜索相关的竞赛；
>- [x] 可以根据用户名、代码提交的结果、编程语言来查看提交状态；
>- [x] 管理员增删改题目、样例，添加竞赛；
>- [x] 使用JQuery富文本编辑器编辑题目信息；
>- [x] 用户可以提交C、C++、JAVA程序；
>- [x] 限制每个账号30秒内只能提交一次；
>- [x] 后台判题使用Docker，能判断AC、WA，能处理编译超时，运行超时，内存超限，输出超限，运行错误这几种情况。
>- [x] 竞赛/作业加密功能，且用户登录正确之后就不需要再输入密码；
>- [x] 竞赛模式和练习模式，竞赛模式有时间限制，时间截止就无法提交，而练习模式无限制；
>- [x] 用户提交代码可以选择是否公开自己的代码，其他用户可以在竞赛结束后查看别人公开的代码；
>- [x] 增加总排行榜，显示AC数、AC率；
>- [x] 分页显示信息；
>- [x] 测试数据文本文件上传；
>- [x] 判题按队列顺序进行，全权由linux处理。
>- [x] 通过使用setrlimit和alarm限制时间、内存、输出文件大小、可产生的进程数等，ptrace监听控制，实现防止#include "/dev/random"头文件造成的编译无法停止，死循环程序攻击，疯狂输出，fork炸弹，系统调用等攻击手段，同时，使用Docker进行隔离，容器炸了也不关我主机的事，判题结束后容器会被删除，下次判题又是新的容器。
>- [x] 通过ptrace获取子进程的syscallId，并与允许的系统调用id进行比对，若不在许可列表中，则返回RE。自己手动跑了几个程序打表打出好多常规程序会产生的系统调用Id，但是怕漏了几个导致误判，就借鉴了[HUST OJ源码](https://github.com/zhblue/hustoj)中的过滤列表。（再次感谢大佬们开源） 

----

## 2. 主要判题流程

>* 使用 **nohup ./startup.sh $** 命令可以让进程在后台运行，退出终端后程序也不会终止。这个脚本会执行polling程序，并将相关的参数以命令行的形式传进程序中。polling程序是一个死循环的轮询程序。程序获取参数后，会连接数据库，然后调用存储过程将数据库中所有状态为queueing的提交按提交时间排序，先提交的排前面，全部放进队列里，然后断开数据库连接。如果队列不为空，就将数据逐个拿出来，把代码写入到文件中后，fork()一个子进程去启动judge.sh脚本，父进程就用waitpid()等待子进程结束。一直到队列为空。之后就sleep一秒中，然后继续刚才的操作，查询数据库的信息并判题。
>* judge.sh文件做两件事，一件是把编译后的judge程序拷贝到所要隔离的目录下（当初写这个是怕用户程序把目录下所有文件都删了，导致后续无法判题，现在想想，似乎删不了正在执行的程序，不过这样做了之后，我在修改judge文件之后，就不需要再手动拷过去了2333），另一件事是运行Docker，并在Docker中运行judge程序。
>* judge程序是判题程序。首先是通过传递的参数编译用户的源代码，如果编译出错，则向数据库写入系统错误或编译错误及错误信息；否则，开始判题。判题时，通过链接数据库获取题目限制的时间和内存，并读取所有的输入数据、输出数据。对于每组数据，先将输入数据写入到当前工作目录下的文件中，然后fork()一个子进程去运行代码，并用freopen重定向输入数据为刚才保存的文件、输出为文本文件，stderr也重定向为文本文件。父进程用ptrace监控该子进程，若达到超时、超内存、状态异常等情况，则改变判题结果为对应的状态，并结束子进程。若子进程正常结束，则比对一下用户输出与该组输出数据。判题直到数据全跑完，或者判题结果不再是AC，就可以结束了。最后就是更新数据库结果了。（PS：Docker默认不能使用ptrace，这个bug调了好久，最后才发现是Docker的问题。。。在启动Docker之前，加入启动选项 **--cap-add=SYS_PTRACE**就行了。）
>* 运行时间的获取可以直接有usage得到，而内存大小就搞不定了。通过研究HUST OJ的源代码，发现进程在运行的时候，会产生 **/proc/pid/status**这个文件（pid就是该进程的pid），里面记录了挺多内存信息的，且单位是KB，需要自己转一下，那么问题就变成文件读取了。（这是C和C++的，JAVA的需要到另一个地方看，应该是因为JVM的关系。）

## 3. 计划拓展功能

>- [ ] 批量生成竞赛用户账号，并加入到竞赛中；
>- [ ] 通过邮箱找回密码；
>- [ ] 数据下载，包括竞赛排行榜、总排行榜、题目信息、竞赛信息等；
>- [ ] 除管理员外，其他用户查看别人的代码，均将代码生成为图片；

----
