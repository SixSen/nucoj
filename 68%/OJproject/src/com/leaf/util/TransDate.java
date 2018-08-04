package com.leaf.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

/*
 * 日期格式化工具类
 * 
 */

public class TransDate {

	/*
	 * 将Date转化为String
	 * @param date
	 * @return
	 */
	public static  String dateToString(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String dateStr = sdf.format(date);
		return dateStr;
	}
	
	/*
	 * 将Timestamp转换成String
	 * 用于数据库中字段类型为datetime
	 * @param timestamp
	 * @return
	 */
	
	public static String timeToString(Timestamp timestamp){
		Date date = new Date(timestamp.getTime());
		String dateStr = dateToString(date);
		return dateStr;
	}
	
	
}
