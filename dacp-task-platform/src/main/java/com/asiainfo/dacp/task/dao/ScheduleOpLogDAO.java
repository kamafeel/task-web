package com.asiainfo.dacp.task.dao;


import org.springframework.transaction.annotation.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.asiainfo.dacp.task.entity.ScheduleOpLog;


public interface ScheduleOpLogDAO  extends CrudRepository<ScheduleOpLog, Long> {
	//save or saveAndFlush.
	@SuppressWarnings("unchecked")
	@Transactional
	public ScheduleOpLog save(ScheduleOpLog persisted);
    
	
	@Query("SELECT a FROM ScheduleOpLog a ")
	public Page<ScheduleOpLog> getPage(
			Pageable pageable);
	
}
