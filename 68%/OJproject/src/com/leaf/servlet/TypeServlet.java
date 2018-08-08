package com.leaf.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.leaf.Bean.Problem;
import com.leaf.dao.ProblemDao;
import com.leaf.util.ConnectionFactory;


/*
 *Servlet implementation class TypeServlet 
 */


public class TypeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public TypeServlet() {
		super();
	}

	public void init() throws ServletException {

	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		// 当期页码
		int currPage = 1;
		// 判断传递页码是否有效
		if(request.getParameter("page")!=null){
			// 对当前页码赋值
			currPage = Integer.parseInt(request.getParameter("page"));
		}
		
		//获取题目标题
			String te = request.getParameter("title");
		//System.out.println(title);
		
		//分页的时候会获取不到标题，所以需要判断
			if(te!=null){
				//存在一个Session中
					request.getSession().setAttribute("title", te);
			}
		//设置不同的跳转内容
		String tag = null;	
		switch(te){
			case "入门训练" :	tag = "a";break;
			case "基础训练" :	tag = "b";break;
			case "算法训练" :	tag = "c";break;
			case "算法提高" :	tag = "d";break;
			case "历届试题" :	tag = "e";break;
			default: System.out.println(tag+"error");
		}
			
			
			
			
			
		Connection conn = null;
		
		// 实例化ProblemDao
				ProblemDao dao = new ProblemDao();
		
		try {
			
			conn = ConnectionFactory.getInstance().makeConnection();
			// 查询所有题目信息
			List<Problem> list = dao.find(conn, currPage);
			// 将list放置到request之中
			request.setAttribute("list", list);
			// 总页数
			int pages;
			// 查询总记录数
			int count = dao.findCount(conn);
			// 计算总页数
			if(count % Problem.PAGE_SIZE == 0){
				// 对总页数赋值
				pages = count/Problem.PAGE_SIZE;
			}else{
				// 对总页数赋值
				pages = count/Problem.PAGE_SIZE + 1;
			}
			// 实例化StringBuffer
			StringBuffer sb = new StringBuffer();
			//通过循环构建分页条
			for(int i = 1;i <= pages; i++){
				// 判断是否为当前页
				if(i == currPage){
					// 构建分页条
					sb.append("『" + i + "』");
				}else{
					// 构建分页条
					sb.append("<a href='TypeServlet?page=" + i + "'>" + i + "</a>");
				}
				// 构建分页条
				sb.append("  ");
			}
			// 将分页条的字符串放置到request之中
			request.setAttribute("bar", sb.toString());
			// 转发到problem_list.jsp页面
			//request.getRequestDispatcher("/jsp/ProblemList.jsp").forward(request, response);
			//String forward = "/jsp/Test.jsp";
			//response.sendRedirect(request.getContextPath()+forward);
			
			conn.setAutoCommit(false);
			
		} catch (Exception e) {
			e.printStackTrace();
			try {
				System.out.println("事务回滚了");
				conn.rollback();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		} finally {
			try {
				conn.close();
			} catch (Exception e3) {
				e3.printStackTrace();
			}
		}
		
		request.getRequestDispatcher("/jsp/ProblemList.jsp").forward(request, response);
		
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
		doGet(request,response);	
	}

	

	public void destroy() {
		super.destroy();
	}
	
}
