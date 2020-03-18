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

import com.asiainfo.dacp.task.dao.JobCommandDAO;
import com.asiainfo.dacp.task.entity.JobCommand;
import com.asiainfo.dacp.task.service.JobCommandService;

@Service
@Transactional
public class JobCommandServiceImpl implements JobCommandService{
	private static final Logger logger = Logger.getLogger(JobCommandServiceImpl.class);
	@Autowired
    private JobCommandDAO jobCommandDAO;

	@Override
	public JobCommand save(JobCommand jobCommand) {
		// TODO Auto-generated method stub
		return jobCommandDAO.save(jobCommand);
	}

	@Override
	public void delete(String id) {
		// TODO Auto-generated method stub
		jobCommandDAO.delete(id);;
	}
	
	@Override
	public void deleteList(List<JobCommand> jobcommands){
		//jobCommandDAO.delete(jobcommands);
	}
	
	@Override
	public JobCommand findById(String id) {
		return jobCommandDAO.findById(id);
	}

	@Override
	public Page<JobCommand> findAll(Integer pageNumber, Integer pageSize, 
			String sortColumn, String sortType, String searchWord) {
		
		List< Order> orders=new ArrayList< Order>();
		if("ASC".equals(sortType.toUpperCase())) orders.add( new Order(Direction.ASC, sortColumn));
		else if("DESC".equals(sortType.toUpperCase())) orders.add( new Order(Direction.DESC, sortColumn));
		PageRequest request = new PageRequest(pageNumber, pageSize, new Sort(orders));

		return jobCommandDAO.findAll(searchWord, request);
	}

	@Override
	public boolean isExist(String jobType, String jobCommand) {
		if(jobCommandDAO.isExist(jobType, jobCommand).size() == 0){
			return false;
		}else{
			return true;
		}
	}
    
	
}
