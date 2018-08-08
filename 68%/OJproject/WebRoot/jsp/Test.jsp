<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@page import="java.util.List"%>
<%@page import="com.leaf.Bean.Problem" %>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<link rel= "stylesheet" href = "css/bootstrap.css">
<link rel= "stylesheet" href = "css/bootstrap.min.css">
<link rel= "stylesheet" href = "css/bootstrap-theme.css">
<link rel= "stylesheet" href = "css/bootstrap-theme.min.css">
<link rel= "stylesheet" href = "css/test.css">
<title>无标题文档</title>
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
            </button>
            <a class="navbar-brand" style="margin-left:30px; " href="#">Online Judge</a>
					<a class="navbar-brand" style="margin-left:30px; " href="jsp/oj.jsp">首页</a>
					<a class="navbar-brand" style="margin-left:30px; " href="jsp/type.jsp">问题</a>
					<a class="navbar-brand" style="margin-left:30px; " href="jsp/oj_tests.jsp">考试</a>
					<a class="navbar-brand" style="margin-left:30px; " href="jsp/oj_status.jsp">状态</a>
					<a class="navbar-brand" style="margin-left:30px; " href="jsp/about.jsp">关于</a>
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

	<div class="container-fluid" id="middle">
    	<div class="row">
        <div class="col-md-12 col-md-offset-0 main">
            <h2 class="sub-header" style="text-align: center">结果显示</h2>
			<br/>
			<form class="form-inline" role="form" style="text-align: center">
				nickName:<input type="text" class="form-control form-control-plus form-group" style = "width:150px;"/>
				testId:<input type="text" class="form-control form-control-plus form-group" style = "width:150px;"/>
				Language:<select class="form-control form-control-plus form-group" onchange="choiceBack(this)" style = "width:150px;">
					<option selected="selected">All</option>
					<option value="C/C++">C/C++</option>
					<option value="JAVA">JAVA</option>
				</select>
				Status:<select class="form-control form-control-plus form-group" onchange="choiceSJ(this)" style = "width:150px;">
					<option selected="selected">All</option>
					<option value="1">Accepted</option>
					<option value="2">Wrong Answer</option>
					<option value="3">Time Limit Exceeded</option>
					<option value="4">Memory Limit Exceeded</option>
					<option value="5">Runtime Error</option>
					<option value="6">Output Limit Exceeded</option>
					<option value="7">Compilation Error</option>
					<option value="8">System Error</option>
					<option value="9">Queuing</option>
					<option value="10">Compiling</option>
					<option value="11">Running</option>
				</select>
				<button class="btn btn-sm btn-primary" type="submit">搜索</button>
			</form>
			<br/>
			
            <div class="table-responsive">
				<!-- table-striped设置条纹状表格无边框-->
                <table class="table table-striped" >
                    <thead>
                    <tr>
                        <th style="text-align:center;">提交序号</th>
                        <th style="text-align:center;">用户编号</th>
						<th style="text-align:center;">题目编号</th>
                        <th style="text-align:center;">提交时间</th>
                        <th style="text-align:center;">判断结果</th>
                        <th style="text-align:center;">运行时间</th>
						<th style="text-align:center;">运行内存</th>
						<th style="text-align:center;">代码长度</th>
						<th style="text-align:center;">语言</th>
                    </tr>
        </thead>
        <%
   			List<Problem> list = (List<Problem>)request.getAttribute("list");
   			for(Problem p : list){
   		 %>
                  
                    <tbody align="center">
						<c:forEach item="" var="usr" varStatus="idx">
							<tr>
								<td><a href="/"><%=p.getTestId() %></a></td>
								<td><%=p.getTestName() %></td>
								<td><%=p.getKeyword() %></td>
								<td><%=p.getUpdateTime() %></td>
								<td><%=p.gettPassRate() %></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</c:forEach>
                   </tbody>
         <%
   			}
   		 %>	
                </table>
           </div>
            <ul class="pagination">
                <li class="active"><%=request.getAttribute("bar")%></li>
                
            </ul>
        </div>
    </div>
 </div>	
</body>
</html>
