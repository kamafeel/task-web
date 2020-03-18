package com.asiainfo.dacp.task.entity;

import java.io.Serializable;
import javax.persistence.*;


/**
 * The persistent class for the schedule_task_global_val database table.
 * 
 */
@Entity
@Table(name="schedule_task_global_val")
public class ScheduleVal implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Id
	private String id;

	@Lob
	private String memo;

	@Column(name="var_name")
	private String varName;

	@Column(name="var_type")
	private String varType;

	@Column(name="var_value")
	private String varValue;

    @Transient
    private int rowsperpage;
    
	public ScheduleVal() {
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getMemo() {
		return this.memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getVarName() {
		return this.varName;
	}

	public void setVarName(String varName) {
		this.varName = varName;
	}

	public String getVarType() {
		return this.varType;
	}

	public void setVarType(String varType) {
		this.varType = varType;
	}

	public String getVarValue() {
		return this.varValue;
	}

	public void setVarValue(String varValue) {
		this.varValue = varValue;
	}

	public int getRowsperpage() {
		return rowsperpage;
	}

	public void setRowsperpage(int rowsperpage) {
		this.rowsperpage = rowsperpage;
	}

}