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
import org.springframework.transaction.annotation.Transactional;

import com.asiainfo.dacp.task.dao.ScheduleValDAO;
import com.asiainfo.dacp.task.entity.ScheduleVal;
import com.asiainfo.dacp.task.service.ScheduleValService;

@Service
@Transactional
public class ScheduleValServiceImpl implements ScheduleValService{
	private static final Logger logger = Logger.getLogger(ScheduleValServiceImpl.class);
	@Autowired
    private ScheduleValDAO scheduleValDAO;

	@Override
	public ScheduleVal save(ScheduleVal scheduleVal) {
		return scheduleValDAO.save(scheduleVal);
	}

	@Override
	public void delete(String id) {
		scheduleValDAO.delete(id);;
	}
		
	@Override
	public ScheduleVal findById(String id) {
		return scheduleValDAO.findById(id);
	}

	@Override
	public boolean isExist(String varName) {
		return scheduleValDAO.findByVarNameLike(varName).size() > 0;
	}
    
	@Override
	public Page<ScheduleVal> findAll(Integer pageNumber, Integer pageSize, 
			String sortColumn, String sortType, String searchWord) {
		
		//排序
		List< Order> orders=new ArrayList< Order>();
		if("ASC".equalsIgnoreCase(sortType)) orders.add( new Order(Direction.ASC, sortColumn));
		else if("DESC".equalsIgnoreCase(sortType)) orders.add( new Order(Direction.DESC, sortColumn));
		PageRequest request = new PageRequest(pageNumber, pageSize, new Sort(orders));

		return scheduleValDAO.findAll(searchWord, request);
	}
}
