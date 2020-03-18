/**
 * 
 */
package com.asiainfo.dacp.task.service;

import java.util.List;

import org.springframework.data.domain.Page;

import com.asiainfo.dacp.task.entity.JobCommand;
import com.asiainfo.dacp.task.entity.ScheduleOpLog;

/**
 * @author FengL
 *
 */
public interface ScheduleOpLogService {
	public ScheduleOpLog createScheduleOpLog(JobCommand ScheduleOpLog);
    public Page<ScheduleOpLog> getPage(Integer pageNumber,
    		Integer pageSize, String sortColumn,String jobType,String jobCommand) ;
}
