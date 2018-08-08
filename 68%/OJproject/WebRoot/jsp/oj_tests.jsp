<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>Online Judge</title>
		<link rel= "stylesheet" href = "../css/bootstrap.css">
		<link rel= "stylesheet" href = "../css/bootstrap.min.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.min.css">
		<link rel="stylesheet" type="text/css" href="../css/table.css">
		<link rel="stylesheet" type="text/css" href="../css/test.css">
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
		<div class="container-fluid" id="middle" style="margin-top: 100px;">
    	<div class="row">
        <div class="col-md-12 col-md-offset-0 main">
            <h2 class="sub-header" style="text-align: center">考试</h2>
			<br/>
            <div class="table-responsive">
				<!-- table-striped设置条纹状表格无边框-->
                <table class="table table-striped" >
                    <thead>
                    <tr>
                        <th style="text-align:center;">考试名称</th>  
						<th style="text-align:center;">开始时间</th>
                        <th style="text-align:center;">结束时间</th>
                        <th style="text-align:center;">开放与否</th>
                        <th style="text-align:center;">所用语言</th>
                    </tr>
                    </thead>
                    <tbody align="center">
						<c:forEach item="" var="usr" varStatus="idx">
							<tr>
								<td><a href="oj_each_problems.html"></a></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</c:forEach>
                   </tbody>
                </table>
           </div>
            <ul class="pagination pull-right">
                <li class="active"><a href="/">1</a></li>
                <li><a href="/">2</a></li>
                <li><a href="/">3</a></li>
                <li><a href="/">4</a></li>
                <li><a href="/">5</a></li>
            </ul>
        </div>
    	</div>
	</div>	
	</body>
</html>