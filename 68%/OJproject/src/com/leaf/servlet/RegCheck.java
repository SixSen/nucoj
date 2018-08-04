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


public class RegCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
	

	protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
		
		String uname = request.getParameter("username");

		Connection conn = null;
		
		User user = new User();
		user.setName(uname);

		
		
		UserDao userDao = new UserDaoRel();
		
		try {
			conn = ConnectionFactory.getInstance().makeConnection();

			ResultSet resultSet = userDao.getForReg(conn, user);

			while (resultSet.next()) {
				request.setAttribute("checkname", false);
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
	}

	public void init() throws ServletException {

	}

}
