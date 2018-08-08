package com.leaf.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.leaf.Bean.User;
import com.leaf.dao.UserDao;
import com.leaf.dao.realize.UserDaoRel;
import com.leaf.util.ConnectionFactory;


public class RegServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	

	protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		String uname = request.getParameter("username");
		String passwd = request.getParameter("password");
		String eml = request.getParameter("email");

		Connection conn = null;
		String forward = null;

		User user = new User();
		user.setName(uname);
		user.setPassword(passwd);
		user.setEmail(eml);
		boolean bool = true;
		
		UserDao userDao = new UserDaoRel();
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();

			ResultSet resultSet = userDao.getForReg(conn, user);

			while (resultSet.next()) {
				bool = false;
			}
		
		if(bool){	
			userDao.save(conn, user);
		}
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
		
		
		if (bool) {
			forward = "/jsp/login.jsp";
		} else {
			request.setAttribute("msg", "用户名已存在");
			forward = "/jsp/sign up.jsp";
		}

		response.sendRedirect(request.getContextPath()+forward);

	}

	public void init() throws ServletException {

	}

}
