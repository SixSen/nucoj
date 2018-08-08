package com.leaf.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.leaf.Bean.ProblemDescribe;

public class ProblemDescribeDao {
	
	/*
	 * 分页查询所有商品信息
	 * @param conn 连接对象
	 * @param testId 题目
	 * @return List<ProblemDescribe> 
	 * 
	 */
	
	
	public List<ProblemDescribe> show(Connection conn,String testName){
		//创建List
		List<ProblemDescribe> list = new ArrayList<ProblemDescribe>();
		//查询的SQL语句
		String sql = "SELECT * FROM testproblem WHERE testName = ?"; 
		try {
				// 获取PreparedStatement
                PreparedStatement ps = conn.prepareStatement(sql);				
                // 对SQL语句中的占位符赋值
                ps.setString(1, testName);
                // 执行查询操作
                ResultSet rs = ps.executeQuery();
                while(rs.next()){
                	// 实例化集合
                	ProblemDescribe pd = new ProblemDescribe();
                	// 对description属性赋值
                	pd.setDescription(rs.getString("description"));
                	// 对setInput属性赋值
                	pd.setInput(rs.getString("input"));
                	// 对setOutput属性赋值
                	pd.setOutput(rs.getString("output"));
                	// 对setSampleInput属性赋值
                	pd.setSampleInput(rs.getString("sampleinput"));
                	// 对setSampleOutput属性赋值
                	pd.setSampleOutput(rs.getString("sampleOutput"));
                	// 对javaTime属性赋值
                	pd.setJavaTime(rs.getString("javaTime"));
                	// 对javaMemory属性赋值
                	pd.setJavaMemory(rs.getString("javaMemory"));
                	// 对othersTime属性赋值
                	pd.setOthersTime(rs.getString("othersTime"));
                	// 对othersMemory属性赋值
                	pd.setOthersMermory(rs.getString("othersMemory"));
                	list.add(pd);
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
	
}
