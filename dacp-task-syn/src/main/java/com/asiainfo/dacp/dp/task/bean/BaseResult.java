package com.asiainfo.dacp.dp.task.bean;

import java.io.Serializable;

public class BaseResult  implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -6894297625090911674L;
	private Integer reCode;
	private String reMsg;
	private Object reInfo;

	public Integer getReCode() {
		return reCode;
	}

	public void setReCode(Integer reCode) {
		this.reCode = reCode;
	}

	public String getReMsg() {
		return reMsg;
	}

	public void setReMsg(String reMsg) {
		this.reMsg = reMsg;
	}

	public Object getReInfo() {
		return reInfo;
	}

	public void setReInfo(Object reInfo) {
		this.reInfo = reInfo;
	}

}
