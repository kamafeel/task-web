package com.asiainfo.dacp.modle;

import java.io.Serializable;

import com.asiainfo.dacp.jdbc.persistence.Column;
import com.asiainfo.dacp.jdbc.persistence.Persistence;
import com.asiainfo.dacp.jdbc.persistence.Table;

@SuppressWarnings("serial")
@Table(name = "process_list")
public class ProcessInfo extends Persistence implements Serializable {

	@Column(name = "pid", isPrimaryKey = true)
	String pid;
	@Column(name = "pname")
	String pname;
	@Column(name = "business")
	String business;
	@Column(name = "host_name")
	String host_name;
	@Column(name = "deploy_path")
	String deploy_path;
	@Column(name = "log_path")
	String log_path;
	@Column(name = "start_cmd")
	String start_cmd;
	@Column(name = "stop_cmd")
	String stop_cmd;
	@Column(name = "pstatus")
	int pstatus;
	@Column(name = "remark")
	String remark;

	// 记录模型操作类型，add/edit
	String action;

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public String getBusiness() {
		return business;
	}

	public void setBusiness(String business) {
		this.business = business;
	}

	public String getHost_name() {
		return host_name;
	}

	public void setHost_name(String host_name) {
		this.host_name = host_name;
	}

	public String getDeploy_path() {
		return deploy_path;
	}

	public void setDeploy_path(String deploy_path) {
		this.deploy_path = deploy_path;
	}

	public String getLog_path() {
		return log_path;
	}

	public void setLog_path(String log_path) {
		this.log_path = log_path;
	}

	public String getStart_cmd() {
		return start_cmd;
	}

	public void setStart_cmd(String start_cmd) {
		this.start_cmd = start_cmd;
	}

	public String getStop_cmd() {
		return stop_cmd;
	}

	public void setStop_cmd(String stop_cmd) {
		this.stop_cmd = stop_cmd;
	}

	public int getPstatus() {
		return pstatus;
	}

	public void setPstatus(int pstatus) {
		this.pstatus = pstatus;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

}
