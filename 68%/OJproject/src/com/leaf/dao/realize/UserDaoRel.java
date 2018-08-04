package com.leaf.dao.realize;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.leaf.Bean.User;
import com.leaf.dao.UserDao;

public class UserDaoRel implements UserDao{

	/**
	 * 保存用户信息
	 */

	public void save(Connection conn, User user) throws SQLException {
		String saveSql = "INSERT INTO users(nick,uPassword,email)" + "VALUES(?,?,?)";

		PreparedStatement ps = conn.prepareStatement(saveSql);

		ps.setString(1, user.getName()); // 索引为1开始
		ps.setString(2, user.getPassword());
		ps.setString(3, user.getEmail());
		System.out.print(user.getName());

		int i = ps.executeUpdate(); //用户计数器

		System.out.println("用户注册成功");
		System.out.println("执行了" + i + "次");	
		ps.close();
	}

	/**
	 * 更新用户信息
	 */

	public void update(Connection conn, Long id, User user) throws SQLException {
		String updateSql = "UPDATE users SET nick =?,uPassword = ?,email = ?WHERE userId = ?";
		PreparedStatement ps = conn.prepareStatement(updateSql);

		ps.setString(1, user.getName());
		ps.setString(2, user.getPassword());
		// ps.setString(3, user.getEmail());
		ps.setLong(4, id);

	}

	/**
	 * 删除用户信息
	 */

	public void delete(Connection conn, User user) throws SQLException {
		PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE nick?");
		ps.setString(1, user.getName());
		ps.execute();
		System.out.println("已经删除");
	}

	/**
	 * 查询用户信息（登录）
	 */
	
	public ResultSet get(Connection conn, User user) throws SQLException {
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE nick = ? AND uPassword = ?");
		ps.setString(1, user.getName());
		ps.setString(2, user.getPassword());
		return ps.executeQuery();
	}

	/**
	 * 查询用户信息（注册）
	 */
	
	public ResultSet getForReg(Connection conn, User user) throws SQLException {
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE nick = ?");
		ps.setString(1, user.getName());

		return ps.executeQuery();
	}
	
}