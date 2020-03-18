package com.asiainfo.dacp.task.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "proc_schedule_log")
public class TaskLog implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5137495699572879314L;

	@Id
	@Column(name = "seqno")
	private String seqno;

	@Column(name = "xmlid")
	private String xmlid;

	@Column(name = "proc_name")
	private String procName;

	@Column(name = "date_args")
	private String dateArgs;

	@Column(name = "run_freq")
	private String runFreq;

	@Column(name = "task_state")
	private String taskState;

	@Column(name = "status_time")
	private String statusTime;

	@Column(name = "start_time")
	private String startTime;

	@Column(name = "exec_time")
	private String execTime;

	@Column(name = "end_time")
	private String endTime;

	@Column(name = "use_time")
	private String useTime;

	@Column(name = "platform")
	private String platform;

	@Column(name = "agent_code")
	private String agentCode;

	@Column(name = "pri_level")
	private int priLevel;

	@Column(name = "proctype")
	private String proctype;

	@Column(name = "runpara")
	private String runpara;

	@Column(name = "pre_cmd")
	private String preCmd;

	@Column(name = "path")
	private String path;

	@Column(name = "time_win")
	private String timeWin;

	@Column(name = "errcode")
	private Integer errcode;

	@Column(name = "queue_flag")
	private Integer queueFlag;

	@Column(name = "trigger_flag")
	private Integer triggerFlag;

	@Column(name = "valid_flag")
	private Integer validFlag;

	@Transient
	String procCnName;

	@Transient
	int rowsperpage;

	public String getSeqno() {
		return seqno;
	}

	public void setSeqno(String seqno) {
		this.seqno = seqno;
	}

	public String getXmlid() {
		return xmlid;
	}

	public void setXmlid(String xmlid) {
		this.xmlid = xmlid;
	}

	public String getProcName() {
		return procName;
	}

	public void setProcName(String procName) {
		this.procName = procName;
	}

	public String getDateArgs() {
		return dateArgs;
	}

	public void setDateArgs(String dateArgs) {
		this.dateArgs = dateArgs;
	}

	public String getRunFreq() {
		return runFreq;
	}

	public void setRunFreq(String runFreq) {
		this.runFreq = runFreq;
	}

	public String getTaskState() {
		return taskState;
	}

	public void setTaskState(String taskState) {
		this.taskState = taskState;
	}

	public String getStatusTime() {
		return statusTime;
	}

	public void setStatusTime(String statusTime) {
		this.statusTime = statusTime;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getExecTime() {
		return execTime;
	}

	public void setExecTime(String execTime) {
		this.execTime = execTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getUseTime() {
		return useTime;
	}

	public void setUseTime(String useTime) {
		this.useTime = useTime;
	}

	public String getPlatform() {
		return platform;
	}

	public void setPlatform(String platform) {
		this.platform = platform;
	}

	public String getAgentCode() {
		return agentCode;
	}

	public void setAgentCode(String agentCode) {
		this.agentCode = agentCode;
	}

	public int getPriLevel() {
		return priLevel;
	}

	public void setPriLevel(int priLevel) {
		this.priLevel = priLevel;
	}

	public String getProctype() {
		return proctype;
	}

	public void setProctype(String proctype) {
		this.proctype = proctype;
	}

	public String getRunpara() {
		return runpara;
	}

	public void setRunpara(String runpara) {
		this.runpara = runpara;
	}

	public String getPreCmd() {
		return preCmd;
	}

	public void setPreCmd(String preCmd) {
		this.preCmd = preCmd;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getTimeWin() {
		return timeWin;
	}

	public void setTimeWin(String timeWin) {
		this.timeWin = timeWin;
	}

	public Integer getErrcode() {
		return errcode;
	}

	public void setErrcode(Integer errcode) {
		this.errcode = errcode;
	}

	public Integer getQueueFlag() {
		return queueFlag;
	}

	public void setQueueFlag(Integer queueFlag) {
		this.queueFlag = queueFlag;
	}

	public Integer getTriggerFlag() {
		return triggerFlag;
	}

	public void setTriggerFlag(Integer triggerFlag) {
		this.triggerFlag = triggerFlag;
	}

	public Integer getValidFlag() {
		return validFlag;
	}

	public void setValidFlag(Integer validFlag) {
		this.validFlag = validFlag;
	}

	public String getProcCnName() {
		return procCnName;
	}

	public void setProcCnName(String procCnName) {
		this.procCnName = procCnName;
	}

	public int getRowsperpage() {
		return rowsperpage;
	}

	public void setRowsperpage(int rowsperpage) {
		this.rowsperpage = rowsperpage;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
