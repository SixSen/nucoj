package com.leaf.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class ConnectionFactory {

	private static String driver;
	private static String dateUrl;
	private static String user;
	private static String password;

	private static final ConnectionFactory factory = new ConnectionFactory();

	private Connection conn;

	static { // static声明一个代码块，此代码块叫做静态代码块，用于初始化类，可以为类的属性进行赋值，当JVM加载类的时候，会执行其中的静态代码块，其只会执行一次
		Properties prop = new Properties(); // 可以用于保存属性文件中的键值对
		try {
			InputStream in = ConnectionFactory.class.getClassLoader()
					.getResourceAsStream("dbConfig.properies"); // 用于获取属性文件中的内容
			prop.load(in); // 从输入流中读取属性列表
		} catch (Exception e) {
			System.out.println("==========配置文件读取错误==========");
		}

		driver = prop.getProperty("driver");
		dateUrl = prop.getProperty("dateUrl");
		user = prop.getProperty("user");
		password = prop.getProperty("password");

	}

	private ConnectionFactory() {

	}

	public static ConnectionFactory getInstance() {
		return factory;
	}

	public Connection makeConnection() {
		try {
			Class.forName(driver);
			conn = DriverManager.getConnection(dateUrl, user, password);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
}
