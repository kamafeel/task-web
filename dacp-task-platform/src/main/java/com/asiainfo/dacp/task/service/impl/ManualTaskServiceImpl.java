package com.asiainfo.dacp.task.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.domain.Sort.Order;
import org.springframework.stereotype.Service;

import com.asiainfo.dacp.task.dao.ManualTaskDAO;
import com.asiainfo.dacp.task.entity.TaskLog;
import com.asiainfo.dacp.task.service.ManualTaskService;

@Service
public class ManualTaskServiceImpl implements ManualTaskService {
	private static final Logger logger = Logger.getLogger(ManualTaskServiceImpl.class);

	@Autowired
	private ManualTaskDAO manualTaskDao;

	@Override
	public TaskLog save(TaskLog taskLog) {
		return manualTaskDao.save(taskLog);
	}

	@Override
	public void delete(String seqno) {
		manualTaskDao.delete(seqno);
	}

	@Override
	public TaskLog findBySeqno(String seqno) {
		return manualTaskDao.findBySeqno(seqno);
	}

	@Override
	public Page<TaskLog> findAll(Integer pageNumber, Integer pageSize, String sortColumn, String sortType,
			String procName, String dateArgs) {
		if (procName == null)
			procName = "";
		if (dateArgs == null)
			dateArgs = "";

		List<Order> orders = new ArrayList<Order>();
		if ("ASC".equals(sortType.toUpperCase()))
			orders.add(new Order(Direction.ASC, sortColumn));
		else if ("DESC".equals(sortType.toUpperCase()))
			orders.add(new Order(Direction.DESC, sortColumn));
		PageRequest request = new PageRequest(pageNumber, pageSize, new Sort(orders));

		logger.debug("proc_name=" + procName + ",date_args=" + dateArgs);

		Page<TaskLog> manualTaskList = manualTaskDao.findAll(procName, dateArgs, request);
		return manualTaskList;
	}

}
