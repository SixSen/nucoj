package com.leaf.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.leaf.Bean.User;
import com.leaf.dao.UserDao;
import com.leaf.dao.realize.UserDaoRel;
import com.leaf.util.ConnectionFactory;

//bug go away(›´ω`‹ )


public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	//private CheckUserService cku = new CheckUserService();

	protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		String userId = request.getParameter("username");
		String uPassword = request.getParameter("password");
		String returnUrl = request.getParameter("return_url");//访问用户登录之前访问的页面，通过这个值，登录成功后可以跳转回登录前的页面
		
		UserDao userDao = new UserDaoRel();
		Connection conn = null;
		RequestDispatcher rd = null;
		String forward = null;

		
		User user = new User();
		user.setName(userId);
		user.setPassword(uPassword);
		
		boolean bool = false;
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();
			conn.setAutoCommit(false);
			ResultSet resultSet = userDao.get(conn, user);

			while (resultSet.next()) {
				bool = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
			try {
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
	

		if (bool) {
			request.getSession().setAttribute("userName", user.getName());
			request.getSession().setAttribute("flag", "login_success");// 在当前的session中保存一个key为flag，值为login_success的字符串，用于表明当前用户处于登录状态
			forward = "/jsp/oj.jsp";
			if(returnUrl != null) {
				
				forward = returnUrl;
				
			} else {
	
				forward = "/jsp/oj.jsp";		
			}
			
		} else {
			request.getSession().setAttribute("flag", "login_error");
			request.setAttribute("msg", "登录失败，用户名或者密码输入错误！！");
			forward = "/jsp/login.jsp";
		}

		//rd = request.getRequestDispatcher(forward);
		//rd.forward(request, response);
		response.sendRedirect(request.getContextPath()+forward);

	}



	public void init() throws ServletException {

	}

}
