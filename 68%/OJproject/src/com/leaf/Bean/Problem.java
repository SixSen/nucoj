package com.leaf.Bean;

public class Problem {
	public static final int PAGE_SIZE = 10;
	private int testId;
	private String testName;
	private String updateTime;
	private String keyword;
	private double tPassRate;
	
	public int getTestId() {
		return testId;
	}

	public void setTestId(int testId) {
		this.testId = testId;
	}

	public String getTestName() {
		return testName;
	}

	public void setTestName(String testName) {
		this.testName = testName;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public double gettPassRate() {
		return tPassRate;
	}

	public void settPassRate(double tPassRate) {
		this.tPassRate = tPassRate;
	}
	
	
}
