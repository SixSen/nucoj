<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Online Judge</title>
    <!-- Bootstrap core CSS -->
    <link href="..\css\bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="..\css\login.css" rel="stylesheet">
    <link rel= "stylesheet" href = "..\css\bootstrap-theme.css">
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
                <a href="login.jsp">
                    <button class="btn btn-primary btn-lg" style="font-size:12px; " >登录</button>
                </a>
                <a href="sign up.jsp">
                    <button class="btn btn-default btn-lg" style="font-size:12px">注册</button>
                </a>
            </ul>
        </div>
    </div>
</nav>
    <div class="container">
  <div class="well form-sign-in-well" >
   <form class="form-signin" action="<%= request.getContextPath()%>/LoginServlet" method="post">
    
    <br/>
    <p class="form-signin-heading"><br/>
      <label for="inputEmail" class="sr-only">Email address</label>
      <input type="name" name="username" id="inputusename" class="form-control" placeholder="用户名" required autofocus>
      <br/>
      <input type="password" name="password" id="inputPassword" class="form-control" placeholder="密码" required>
      <br/>
    </p>
    <button class="btn btn-lg btn-primary btn-block" type="submit">登录</button>
   </form>
  </div>
    </div> <!-- /container -->
  </body>
</html>

