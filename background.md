# NUC OnlineJudge
----

## 前言
> 因为学校自己的OJ用的是hust的后端判题系统，这个暑假实验室就打算弄一个自己学校的OnlineJudge出来，基本上大家就是参考hustoj的思路和源码慢慢啃。

+ 在这里特别感谢hustoj的dalao开放的源码，给了我们思路上的和技术上的支持。同时也感谢深圳大学的开源OJ，注释写的更明白，读代码时候经验值猛涨。
----

## 简介
>* 这套OJ前台页面是用的JSP，后台判题部分用的C++，中间是通过数据库连接。JSP处理用户提交的信息。用户提交代码,相关信息写入数据库，提交状态设置成*queueing*状态，之后Linux后台通过对数据库轮询，把*queueing*状态的待判题目拿出来，启动judge程序判题，判完把结果再存入数据库。
>* Linux端C++与数据库的连接是使用[mysql-connector-c++](https://dev.mysql.com/doc/connector-cpp/en/)实现的，此处再次感谢深圳大学开源OJ，知道了这么好用的东西^_^ 。
>* 判题安全问题同样利用了docker，在docker容器内完成judge过程。
----