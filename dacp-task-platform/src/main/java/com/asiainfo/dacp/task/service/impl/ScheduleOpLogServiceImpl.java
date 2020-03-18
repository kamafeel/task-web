/**
 * 
 */
package com.asiainfo.dacp.task.service.impl;

import java.util.List;

import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.asiainfo.dacp.task.dao.JobCommandDAO;
import com.asiainfo.dacp.task.dao.ScheduleOpLogDAO;
import com.asiainfo.dacp.task.entity.JobCommand;
import com.asiainfo.dacp.task.entity.ScheduleOpLog;
import com.asiainfo.dacp.task.service.ScheduleOpLogService;

/**
 * @author FengL
 *
 */
@Service
@Transactional
public class ScheduleOpLogServiceImpl implements ScheduleOpLogService {
	private static final Logger logger = Logger
			.getLogger(ScheduleOpLogServiceImpl.class);
	@Autowired
	private ScheduleOpLogDAO scheduleOpLogDAO;


	public Page<ScheduleOpLog> getPage(Integer pageNumber, Integer pageSize,
			String sortColumn, String jobType, String jobCommand) {
		PageRequest request = new PageRequest(pageNumber, pageSize);

		if (jobType == null)
			jobType = "";
		if (jobCommand == null)
			jobCommand = "";

		logger.debug("jobType=" + jobType + ",jobCommand=" + jobCommand);
		Page<ScheduleOpLog> pageData = scheduleOpLogDAO.getPage(request);

		return pageData;
	}

	@Override
	public ScheduleOpLog createScheduleOpLog(JobCommand ScheduleOpLog) {
		// TODO Auto-generated method stub
		return null;
	}
}
