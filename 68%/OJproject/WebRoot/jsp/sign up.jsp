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
		<link rel= "stylesheet" href = "../css/bootstrap.css">
		<link href="../css/bootstrap.min.css" rel="stylesheet">
		<!-- Custom styles for this template -->
		<link href="../css/signUp.css" rel="stylesheet">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.min.css">


<script type="text/javascript">
    <%
    	String msg = null;
    	Object mess = request.getAttribute("msg");
    	if(mess!=null){
    	msg = mess.toString();
    	}
    	
    	String chName = null;
    	Object ck = request.getAttribute("msg");
    	if(ck!=null){
    	chName = ck.toString();
    	}
    	
    	
    if(msg!=null){%>
	
	function warning() //定义函数
	{
		alert("用户名重复！！");
	}warning()
	<% } %>
	
	<% session.removeAttribute("msg"); %>
</script>

	</head>
	<body>
<%if(request.getAttribute("return_url")!=null){ %>
  		<input type="hidden" name="return_url" value="<%=request.getAttribute("return_url")%>">
 <%} %>
 

		<script src="/demos/googlegg.js"></script>
		<script type="text/javascript">
			function check(){
				var username=document.getElementById("inputName").value;
				var password=document.getElementById("inputPassword").value;
				var password1=document.getElementById("inputPassword1").value;
				var email=document.getElementById("inputEmail").value;
				var reg1=new RegExp("^[0-9a-zA-Z]{6}?$");
				var reg=new RegExp("^[0-9a-zA-z]{6,10}?$");
				var reg2=new RegExp("^[_a-zA-Z0-9_-_._-]+@([_a-zA-Z0-9_-]+\\.)+[a-zA-Z]{2,3}$");
				
				

				if(username ==""){
					document.getElementById("username_info").innerHTML="<span style='color:red'>用户名不能为空!</span>";
					username_info.focus();
					return false;
				}

				if(!reg.test(username)){
					document.getElementById("username_info").innerHTML="<span style='color:red'>用户名格式错误!</span>";
					username_info.focus();
					return false;
				}	
					
				if(reg.test(username)){
						document.getElementById("username_info").innerHTML="<span style='color:green'>用户名验证通过!</span>";	
				}
				
				if(password ==""){
					document.getElementById("password_info").innerHTML="<span style='color:red'>密码不能为空!</span>";
					password_info.focus();
					return false;
				}

				if(!reg1.test(password)){
					document.getElementById("password_info").innerHTML="<span style='color:red'>密码必须是6位数字或字母!</span>";
					password_info.focus();
					return false;
				}

				if(reg1.test(password)){
					document.getElementById("password_info").innerHTML="<span style='color:blue'>密码验证通过!</span>";
				}

				if(password1!=password){
					document.getElementById("password1_info").innerHTML="<span style='color:red'>两次输入的密码不一样!</span>";
					password_info.focus();
					return false;
				}

				if(password1==password){
					document.getElementById("password1_info").innerHTML="<span style='color:blue'>密码验证通过!</span>";
				}

				if(email ==""){
					document.getElementById("email_info").innerHTML="<span style='color:red'>邮箱不能为空!</span>";
					return false;
				}

				if(!reg2.test(email)){
					document.getElementById("email_info").innerHTML="<span style='color:red'>邮箱格式不对!</span>";
					return false;
				}

				if(reg2.test(email)){
					document.getElementById("email_info").innerHTML="<span style='color:blue'>邮箱格式正确!</span>";
				}
			}
		</script>
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
			<div class="well form-sign-up-well" >
				<center>
					<form class="form-signin" action="<%= request.getContextPath()%>/RegServlet" method="post">
						<br/>
						<br/>
						<table align="center">
							<tr>
								<td>
									<input type="name" name="username" id="inputName" class="form-control" placeholder="昵称" onblur="check()" required autofocus>
								</td>
								<td id="username_info"><font color="red">&nbsp;请输入6~10个字母或数字!</font></td>
							</tr>
							<tr height="15px">
							</tr>
							<tr>
								<td>
									<input type="password" name="password" id="inputPassword" class="form-control" placeholder="密码" onblur="check()" required>
								</td>
								<td id="password_info"><font color="red">&nbsp;请输入6个字母或数字!</font></td>
							</tr>
							<tr height="15px">
							</tr>
							<tr>
								<td>
									<input type="password" name="password1" id="inputPassword1" class="form-control" placeholder="确认密码" onblur="check()" required>
								</td>
								<td id="password1_info"><font color="red">&nbsp;请输入6个字母或数字!</font></td>
							</tr>
							<tr height="15px">
							</tr>
							<tr>
								<td>
									<input type="email" name="email" id="inputEmail" class="form-control" placeholder="邮箱" onblur="check()" required>
								</td>
								<td id="email_info"><font color="red">&nbsp;请输入您的邮箱!</font></td>
							</tr>
						</table>
						<br/>
						<br/>
					  <button class="btn btn-lg btn-primary btn-block" type="submit" style="width: 250px">注册</button>
					</form>
				</center>
			</div>
		</div> <!-- /container -->
	</body>
</html>