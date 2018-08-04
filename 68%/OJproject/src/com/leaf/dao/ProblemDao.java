package com.leaf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.leaf.Bean.Problem;
import com.leaf.util.TransDate;

public class ProblemDao {
	
	/*
	 * 分页查询所有商品信息
	 * @param page 页数
	 * @return List<Problem> 
	 * 
	 */
	
	public List<Problem> find(Connection conn,int page){
		//创建List
		List<Problem> list = new ArrayList<Problem>();
		//分页查询的SQL语句
		String sql = "select * from testproblem order by testId limit ?,?";
		try {
			//	获取PreparedStatement
			PreparedStatement ps = conn.prepareStatement(sql);
			//  对SQL语句中的第一个参数赋值
			ps.setInt(1, (page-1)*Problem.PAGE_SIZE);
			//  对SQL语句中的第二个参数赋值
			ps.setInt(2, Problem.PAGE_SIZE);
			//  执行查询操作
			ResultSet rs = ps.executeQuery();
			//  光标向后移动，并判断是否有效
			while(rs.next()){
				//实例化Problem
				Problem pb = new Problem();
				//对updateTime属性赋值
				Timestamp timestamp = rs.getTimestamp("updateTime");
				String updateTime = TransDate.timeToString(timestamp);
				pb.setUpdateTime(updateTime);
				//对testId属性赋值
				pb.setTestId(rs.getInt("testId"));
				//对testName属性赋值
				pb.setTestName(rs.getString("testName"));
				//对keyWord属性赋值
				pb.setKeyword(rs.getString("keyWord"));
				//对tPassRate属性进行赋值
				pb.settPassRate(rs.getDouble("tPassRate"));
				// 将Problem添加到List集合中
				list.add(pb);
			}
			// 关闭ResultSet
			rs.close();
			// 关闭PreparedStatement
			ps.close();			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	/*
	 * 查询总记录数
	 * @return 总记录数
	 */
	public int findCount(Connection conn){
		// 总记录数
		int count = 0;
		// 查询总记录数SQL语句
		String sql = "select count(*) from testproblem";
		try {
			// 创建Statement
			Statement stmt = conn.createStatement();
			// 查询并获取ResultSet
			ResultSet rs = stmt.executeQuery(sql);
			// 光标向后移动，并判断是否有效
			if(rs.next()){
				//对总记录数赋值
				//rs.getInt()方法，通过索引或者列名来获得查询结果集中的某一列的值
				count = rs.getInt(1);
			}
			// 关闭ReslultSet
			rs.close();	
		} catch (Exception e) {
			e.printStackTrace();
		}
		//返回总记录数
		return count;
	}
}

