<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@page import="java.util.List"%>
<%@page import="com.leaf.Bean.Problem" %>
 <html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <base href="<%=basePath%>">
    <title>所有题目</title>
<style type="text/css">
		td{font-size: 12px;}
		h2{margin: 0px}
</style>

</head>
  <body>
   	<table align="center" width="450" border="1" height="100" bordercolor="white" bgcolor="black" cellpadding="1" cellspacing="1">
   		<tr bgcolor="white">
   			<td align="center" colspan="5">
   				<h2>所有题目信息</h2>
   			</td>
   		</tr>
   		<tr align="center" bgcolor="#e1ffc1">
   			<td><b>试题编号</b></td>
   			<td><b>试题名称</b></td>
   			<td><b>关键字</b></td>
   			<td><b>更新时间</b></td>
   			<td><b>通过率</b></td>
   		</tr>
   		<%
   			List<Problem> list = (List<Problem>)request.getAttribute("list");
   			for(Problem p : list){
   		 %>
   		<tr align="center" bgcolor="white">
   			<td><%=p.getTestId() %></td>
   			<td><%=p.getTestName() %></td>
   			<td><%=p.getKeyword() %></td>
   			<td><%=p.getUpdateTime() %></td>
   			<td><%=p.gettPassRate() %></td>
   		</tr>
   		<%
   			}
   		 %>	
   		<tr>
   			<td align="center" colspan="5" bgcolor="white">
   				<%=request.getAttribute("bar")%>
   			</td>
   		</tr>
   	</table>
  </body>
</html>
