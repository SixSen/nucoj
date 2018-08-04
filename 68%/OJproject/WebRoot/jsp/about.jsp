<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Online Judge</title>
<link rel= "stylesheet" href = "../css/bootstrap-theme.css">
<link rel= "stylesheet" href = "../css/bootstrap.min.css">
</head>

<body>
<%if(request.getAttribute("return_url")!=null){ %>
  		<input type="hidden" name="return_url" value="<%=request.getAttribute("return_url")%>">
 <%} %>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid" style="margin-right:30px">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Online Judge</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
           <a class="navbar-brand" style="margin-left:30px; " href="#">Online Judge</a>
					<a class="navbar-brand" style="margin-left:30px; " href="oj.jsp">首页</a>
					<a class="navbar-brand" style="margin-left:30px; " href="type.jsp">问题</a>
					<a class="navbar-brand" style="margin-left:30px; " href="oj_tests.jsp">考试</a>
					<a class="navbar-brand" style="margin-left:30px; " href="oj_status.jsp">状态</a>
					<a class="navbar-brand" style="margin-left:30px; " href="about.jsp">关于</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse" style="margin-top:5px">
            <ul class="nav navbar-nav navbar-right">
              <!--登陆以前-->
                  <%
  		String flag = "";
  		String userName ="";
  		Object obj = session.getAttribute("flag");
  		Object userNa = session.getAttribute("userName");
  	
  		if(obj!=null){
  			flag = obj.toString();
  		}
  		if(userNa!=null){
  			userName = userNa.toString();
  		}
  		
  		if(flag.equals("login_success")){
  %>	
  				<!--登陆以后,???处将来显示用户名-->
				<a href=".html" style="color:white;font-size:13px"><%= userName%></a>
				&nbsp;
				<a href=<%=request.getContextPath() +"/LogoutServlet" %>>
					<button class="btn btn-primary btn-lg" style="font-size:13px">退出</button>
				</a>
  <%}  else{ %>
				<a href="login.jsp">
					<button class="btn btn-primary btn-lg" style="font-size:12px; " >登录</button>
				</a>
				<a href="sign up.jsp">
					<button class="btn btn-default btn-lg" style="font-size:12px">注册</button>
				</a>
 <%} %>		
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="center jumbotron" style="margin-top:60px">
    <h2 style="margin-left:-40px; margin-top:-10px;">Compiler & Judger</h2><br/><br/>
        <p>C ( GCC 5.4 )</p>
        /usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c11 {src_path} -lm -o {exe_path}<br/><br/>
        <p>C++ ( G++ 5.4 )</p>
       /usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++14 {src_path} -lm -o {exe_path}<br/><br/>
        <p>Java ( OpenJDK 1.8 )</p>
        /usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8<br/><br/>
       <h2 style="margin-left:-40px;">Result Explanation</h2><br/><br/>
       
 <span style="font-weight:bold"> Output Limit Exceeded :</span> 输出超限制<br/><br />

<span style="font-weight:bold">Compile Error :	</span>编译错误<br><br />

<span style="font-weight:bold">Accepted :</span>通过<br/><br />
<span style="font-weight:bold">Wrong Answer :</span>答案错误<br/><br />

<span style="font-weight:bold">Runtime Error :</span>运行时错误<br/><br />

<span style="font-weight:bold">Time Limit Exceeded :</span>	超时<br/><br />

<span style="font-weight:bold">Memory Limit Exceeded :</span>内存超过限制<br/><br />

<span style="font-weight:bold">System Error :</span>系统错误<br/><br />

<span style="font-weight:bold">Queue :</span>排队状态<br/><br />

<span style="font-weight:bold">Compiling:</span>正在编译<br/><br />

<span style="font-weight:bold">Running :</span>正在判断<br/>
    </div>
</div>
</body>
</html>
