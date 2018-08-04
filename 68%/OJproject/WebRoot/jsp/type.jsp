<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<link rel= "stylesheet" href = "../css/bootstrap.css">
		<link rel= "stylesheet" href = "../css/bootstrap.min.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.min.css">
		<link rel= "stylesheet" href = "../css/test.css">
		<title>题目类型</title>
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
		<div class="container-fluid" style="margin-top: 80px;">
			<div class="row">
				<div class="col-md-10 col-md-offset-1 main">
				<h2 class="sub-header" align="center">题目类型</h2>
				<br/>
				<div class="table-responsive">
					<!-- table-striped设置条纹状表格无边框-->
					<table class="table table-striped">
						<thead>
							<tr>
								<th class="thead-style">类型名称</th>
								<th class="thead-style">题目数量</th>
								<th class="thead-style">难易程度</th>
								<th class="thead-style">更新时间</th>
							</tr>
						</thead>
						<tbody class="tbody-style">
							<tr>
								<td><a href=<%=request.getContextPath() +"/TypeServlet" %>?title=入门训练>入门训练</a></td>
								<td>400</td>
								<td>简单</td>
								<td>2018-1-1</td>
							</tr>
							<tr>
								<td><a href=<%=request.getContextPath() +"/TypeServlet" %>?title=基础练习>基础练习</a></td>
								<td>130</td>
								<td>中等</td>
								<td>2018-1-1</td>
							</tr>
							<tr>
								<td><a href=<%=request.getContextPath() +"/TypeServlet" %>?title=算法训练>算法训练</a></td>
								<td>30</td>
								<td>较难</td>
								<td>2018-1-1</td>
							</tr>
							<tr>
								<td><a href=<%=request.getContextPath() +"/TypeServlet" %>?title=算法提高>算法提高</a></td>
								<td>245</td>
								<td>--</td>
								<td>2018-1-1</td>
							</tr>
							<tr>
								<td><a href="/">历届试题</a></td>
								<td>55</td>
								<td>--</td>
								<td>2018-1-1</td>
							</tr>
						</tbody>
					</table>
				</div> 
			</div>
			</div>
		</div>
	</body>
</html>