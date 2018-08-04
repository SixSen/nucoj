<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="utf-8" />
		<script type="text/javascript" src="../js/time.js"></script>
		<link rel= "stylesheet" href = "../css/bootstrap.css">
		<link rel= "stylesheet" href = "../css/bootstrap.min.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.css">
		<link rel= "stylesheet" href = "../css/bootstrap-theme.min.css">
		<link rel= "stylesheet" href = "。。/css/test.css">
		<link rel="stylesheet" type="text/css" href="../css/table.css">
		<link rel="stylesheet" type="text/css" href="../css/new.css"/>
		<title>考试题目</title>
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
		<div id="projects">
			 <h2 class="sub-header" style="text-align: center">?????</h2>
			<span id="s"></span>
			<span>:</span>
			<span id="m"></span>
			<span>倒计时&nbsp;&nbsp;</span>
		</div>

		<script src="/demos/googlegg.js"></script>
		<div class="container-fluid" id="middle" style="margin-top: 100px;">
    	<div class="row">
        <div class="col-md-10 col-md-offset-1 main">
            <div class="table-responsive">
				<!-- table-striped设置条纹状表格无边框-->
                <table class="table table-striped" >
                    <thead>
                    <tr>
                        <th style="text-align:center;">题目序号</th>  
						<th style="text-align:center;">题目名称</th>
                        <th style="text-align:center;">状态</th>
                    </tr>
                    </thead>
                    <tbody align="center">
						<c:forEach item="" var="usr" varStatus="idx">
							<tr>
								<td></td>
								<td><a href="describe.jsp"></a></td>
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