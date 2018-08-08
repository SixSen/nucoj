package com.leaf.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.leaf.Bean.ProblemDescribe;
import com.leaf.dao.ProblemDescribeDao;
import com.leaf.util.ConnectionFactory;

public class DescribeServlet extends HttpServlet {

	public DescribeServlet() {
		super();
	}

	public void init() throws ServletException {
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		//String get = request.getParameter("param").replace(' ','+');
		//String get = request.getParameter("param");
		//用上面的方法获取参数+号会被转义掉
		String testName = request.getQueryString().substring(0);
		System.out.println(testName);
		request.getSession().setAttribute("problemDescribe",testName);
		
		Connection conn = null;
		// 实例化ProblemDescribe
		ProblemDescribeDao dao = new ProblemDescribeDao();
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			// 查询题目的样例信息
			List<ProblemDescribe> list = dao.show(conn, testName);
			// 将List放置到request中
			request.setAttribute("PDList", list);
			
			
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
		
		
		request.getRequestDispatcher("/jsp/describe.jsp").forward(request, response);
	}

	public void destroy() {
		super.destroy();
	}
	
}
