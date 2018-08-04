package com.leaf.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class EncodingFilter implements Filter {
	private String charEncoding = null;

	public void init(FilterConfig fConfig) throws ServletException {

		charEncoding = fConfig.getInitParameter("encoding");
		if (charEncoding == null) {
			throw new ServletException("EncodingFilter中的编码设置为空！！！");
		}

	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		if (!charEncoding.equals(request.getCharacterEncoding())) { // 如果当前应用的默认编码与请求中的编码不一致，就将请求中的编码设置成当前默认的编码设置
			request.setCharacterEncoding(charEncoding);
		}
		response.setCharacterEncoding(charEncoding);// 将response的编码也设置成当前应用的默认编码设置
		chain.doFilter(request, response);
	}

	public void destroy() {

	}
}
