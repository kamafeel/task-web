package com.asiainfo.dacp.task.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "job_command")
public class JobCommand implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4234915250332492633L;
	
	@Id
    private String id;
	
    @Column(name="job_type")
    private String jobType;
    
    @Column(name="JOB_COMMAND")
    private String jobCommand;
    
    @Column(name="JOB_INSTRUCTION")
    private String jobInstruction;
    
    @Transient
    int rowsperpage;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getJobType() {
		return jobType;
	}

	public void setJobType(String jobType) {
		this.jobType = jobType;
	}

	public String getJobCommand() {
		return jobCommand;
	}

	public void setJobCommand(String jobCommand) {
		this.jobCommand = jobCommand;
	}

	public String getJobInstruction() {
		return jobInstruction;
	}

	public void setJobInstruction(String jobInstruction) {
		this.jobInstruction = jobInstruction;
	}
	
	public int getRowsperpage() {
		return rowsperpage;
	}

	public void setRowsperpage(int rowsperpage) {
		this.rowsperpage = rowsperpage;
	}
	
    @Override
    public String toString() {
        return "job_command{" +
                "id=" + id +
                ", jobType='" + jobType + '\'' +
                ", JOB_COMMAND=" + jobCommand +
                ", JOB_INSTRUCTION=" + jobInstruction +
                '}';
    }
    
    
}
