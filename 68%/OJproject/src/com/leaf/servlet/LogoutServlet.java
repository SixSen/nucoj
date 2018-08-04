package com.leaf.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LogoutServlet extends HttpServlet {

	private final String PATH = "/jsp/.jsp";
	
	
	public LogoutServlet() {
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
		String forward = null;
		String returnUrl = request.getParameter("return_url");
		if(returnUrl!=null){
			forward =returnUrl;
		}else{
			forward = "/jsp/oj.jsp";
		}
		request.getSession().invalidate(); // 直接删除Session对象
		response.sendRedirect(request.getContextPath()+forward);
	}

	public void destroy() {
		super.destroy();
	}
}
