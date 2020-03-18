package com.asiainfo.dacp.modle;

/**
 * 任务分组模型类
 * 
 * @author L
 *
 */
public class ThemeBean {
	// 主键id
	private String id;
	// 父id
	private String pid;
	// 名称
	private String themeName;
	// 序号
	private int sortNo;
	// 是否重点
	private String onFocus;
	// 备注
	private String note;
	// 是否生效
	private String validFlag;
	// 平均使用事件
	private String avgUseTime;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getThemeName() {
		return themeName;
	}

	public void setThemeName(String themeName) {
		this.themeName = themeName;
	}

	public int getSortNo() {
		return sortNo;
	}

	public void setSortNo(int sortNo) {
		this.sortNo = sortNo;
	}

	public String getOnFocus() {
		return onFocus;
	}

	public void setOnFocus(String onFocus) {
		this.onFocus = onFocus;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getValidFlag() {
		return validFlag;
	}

	public void setValidFlag(String validFlag) {
		this.validFlag = validFlag;
	}

	public String getAvgUseTime() {
		return avgUseTime;
	}

	public void setAvgUseTime(String avgUseTime) {
		this.avgUseTime = avgUseTime;
	}

}
