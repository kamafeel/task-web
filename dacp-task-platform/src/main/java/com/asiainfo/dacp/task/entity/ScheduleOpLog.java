package com.asiainfo.dacp.task.entity;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the schedule_op_log database table.
 * 
 */
@Entity
@Table(name="schedule_op_log")
@NamedQuery(name="ScheduleOpLog.findAll", query="SELECT s FROM ScheduleOpLog s")
public class ScheduleOpLog implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="seq_no")
	private String seqNo;
	
	@Column(name="OP_OBJ")
	private String opObj;

	@Column(name="OP_SQL")
	private String opSql;

	@Column(name="OP_STATE")
	private String opState;

	@Column(name="OP_TIME")
	private String opTime;

	@Column(name="OP_TYPE")
	private String opType;

	@Column(name="OP_USER")
	private String opUser;

	@Column(name="OP_USER_IP")
	private String opUserIp;

	public ScheduleOpLog() {
	}

	public String getOpObj() {
		return this.opObj;
	}

	public void setOpObj(String opObj) {
		this.opObj = opObj;
	}

	public String getOpSql() {
		return this.opSql;
	}

	public void setOpSql(String opSql) {
		this.opSql = opSql;
	}

	public String getOpState() {
		return this.opState;
	}

	public void setOpState(String opState) {
		this.opState = opState;
	}

	public String getOpTime() {
		return this.opTime;
	}

	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}

	public String getOpType() {
		return this.opType;
	}

	public void setOpType(String opType) {
		this.opType = opType;
	}

	public String getOpUser() {
		return this.opUser;
	}

	public void setOpUser(String opUser) {
		this.opUser = opUser;
	}

	public String getOpUserIp() {
		return this.opUserIp;
	}

	public void setOpUserIp(String opUserIp) {
		this.opUserIp = opUserIp;
	}

}