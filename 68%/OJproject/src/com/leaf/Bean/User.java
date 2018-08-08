package com.leaf.Bean;
//封装用户数据的Bean，用于注册与登录
public class User {	
	
	protected Long id;
	
	private String name;
	private String password;
	private String email;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	public String toString() {
		return "User [name=" + name + ", password=" + password + ", email="
				+ email + ", id=" + id + "]";
		}
}
