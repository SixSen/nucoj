<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%@page import="java.util.List"%>
<%@page import="com.leaf.Bean.ProblemDescribe" %>
<!doctype html>
<html>
	<head>
		<meta charset="utf-8">
		<link rel= "stylesheet" href = "css/bootstrap.css">
		<link rel= "stylesheet" href = "css/bootstrap.min.css">
		<link rel= "stylesheet" href = "css/bootstrap-theme.css">
		<link rel= "stylesheet" href = "css/bootstrap-theme.min.css">
		<link rel= "stylesheet" href = "css/test.css">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.6/ace.js" type="text/javascript" charset="utf-8"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.6/ext-language_tools.js" type="text/javascript" charset="utf-8"></script>
		<title>具体题目</title>
	</head>
	<body>
	<%if(request.getAttribute("return_url")!=null){ %>
  		<input type="hidden" name="return_url" value="<%=request.getAttribute("return_url")%>">
 <%} %>
 
 <%
   			List<ProblemDescribe> list = (List<ProblemDescribe>)request.getAttribute("PDList");
   			for(ProblemDescribe pd : list){
   				String de = pd.getDescription();
   				String ip = pd.getInput();
   				String op = pd.getOutput();
   				String si = pd.getSampleInput();
   				String so = pd.getSampleOutput();
   				String jt = pd.getJavaTime();
   				String jm = pd.getJavaMemory();
   				String ot = pd.getOthersTime();
   				String om = pd.getOthersMermory();
			
%>
 
 
 
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
  		String TitleName ="";
  		Object obj = session.getAttribute("flag");
  		Object userNa = session.getAttribute("userName");
  		Object tN = session.getAttribute("problemDescribe");
  		if(tN!=null){
  			TitleName = tN.toString();
  		}
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
		<div class = "container" id="middle">
		<h2 class="sub-header" style="text-align: center"><%=TitleName%></h2>
			<ul style="text-align: center">
                <li style="list-style: none;">Java的时间限制：<%=jt%>，内存限制：<%=jm%></li>
                <li style="list-style: none;">C/C++的时间限制：<%=ot%>，内存限制：<%=om%></li>
            </ul>
	
			<div class = "row">
				<div class ="col-md-12" >
					<h1 class= "text-left">题目描述</h1>
					<div class="well" style ="height:150px">
	
						<p class = "text-left"><%=de%></p>
						
					</div>
				</div>
			</div>
			<div class = "row">
				<div class = "col-md-12">
					<h1 class= "text-left">题目输入</h1>
					<div class="well" style ="height:100px">
						<p class = "text-left"><%=ip%></p>	
					</div>
			</div>
			</div>	
			<div class = "row">
				<div class = "col-md-12">
					<h1 class= "text-left">题目输出</h1>
					<div class="col-md-12 well" style ="height:100px">	
						<p class = "text-left"><%=op%></p>	
					</div>
				</div>
			</div>
			<div class = "row">
				<div class = "col-md-12">
					<h1 class= "text-left">样例输入</h1>
					<div class="col-md-12 well" style ="height:100px">	
						<p class = "text-left"><%=si%></p>	
					</div>
				</div>
			</div>	
			<div class = "row">
				<div class = "col-md-12">
					<h1 class= "text-left">样例输出</h1>
					<div class="col-md-12 well" style ="height:100px">	
						<p class = "text-left"><%=so%></p>	
					</div>
				</div>
			</div>
			
			<div class = "row">
				<form class="form-inline" role="form" >
					<div class="col-md-12">
						<h1 class= "text-left">代码提交</h1>
						<select class="form-control form-control-plus form-group" onchange="choiceLang(this)" style = "width:150px;">
							<option value="ace/mode/c_cpp" selected="selected">语言</option>
							<option value="ace/mode/c_cpp">C/C++</option>  
							<option value="ace/mode/java">JAVA</option>
						</select>
						<select class="form-control form-control-plus form-group" onchange="choiceBack(this)" style = "width:150px;">
							<option value="ace/theme/xcode" selected="selected">环境配色</option>
							<option value="ace/theme/xcode">高亮</option>
							<option value="ace/theme/monokai">暗色</option>
						</select>
						<select class="form-control form-control-plus form-group" onchange="choiceSJ(this)" style = "width:150px;">
							<option value="4" selected="selected">代码缩进</option>
							<option>2</option>
							<option>4</option>
							<option>8</option>
						</select>
						<div class="flex-btn form-group" onclick="expand('spanid')">
							<span class="glyphicon glyphicon-resize-full" id="spanid"></span>
						</div>
					</div>
				</form>
			</div>
			<br/>
			<div class = "row" >		  
				<pre id="code" class="ace_editor" style="min-height:400px"><textarea class="ace_text-input"></textarea></pre>
			</div>
			<br/>
			<div class = "row" id="buttom">
				<div class="col-md-12">
					<button type="button" class="btn btn-warning" style="background:#337ab7;border: #337ab7" >提交</button>
				</div>
			</div>
		</div>
		
		<script>
			//初始化对象
			editor = ace.edit("code");//该值为编辑框的id值
			window.onload = (function () {
				editor.setTheme("ace/theme/xcode"); //设置背景色为高亮
				editor.session.setMode("ace/mode/c_cpp");  //设置默认语言为c/c++
				editor.getSession().setTabSize(4);  //设置默认缩进大小
			})();
			//设置语言
			function choiceLang(select){
				editor.session.setMode(select.value);
			}
			//设置背景色
			function choiceBack(select){
				editor.setTheme(select.value); 
			}
			//设置缩进大小
			function choiceSJ(select){
				editor.getSession().setTabSize(select.value);
			}
			function submit(){
				var code  = editor.getValue();
			}
			//字体大小
			editor.setFontSize(18);
			//设置只读（true时只读，用于展示代码）
			editor.setReadOnly(false); 
			//自动换行,设置为off关闭
			editor.setOption("wrap", "free")
			//启用提示菜单
			ace.require("ace/ext/language_tools");
			editor.setOptions({
				enableBasicAutocompletion: true,
				enableSnippets: true,
				enableLiveAutocompletion: true
			});
		</script>
<% } %>
	</body>
</html>


