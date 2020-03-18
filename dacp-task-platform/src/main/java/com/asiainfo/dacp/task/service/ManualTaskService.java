package com.asiainfo.dacp.task.service;

import org.springframework.data.domain.Page;
import com.asiainfo.dacp.task.entity.TaskLog;

public interface ManualTaskService {

	TaskLog save(TaskLog taskLog);

	void delete(String seqno);

	TaskLog findBySeqno(String seqno);

	Page<TaskLog> findAll(Integer pageNumber, Integer pageSize, String sortColumn, String sortType, String procName,
			String dateArgs);
}
