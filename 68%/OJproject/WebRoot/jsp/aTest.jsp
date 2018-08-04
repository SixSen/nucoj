<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>aTest.jsp</title>
    
	
  </head>
  
  <body>
		<a herf=<%=request.getContextPath() +"/FindServlet" %>>
			查看所有题目信息
		</a>
  </body>
</html>
