package com.asiainfo.dacp.task.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.asiainfo.dacp.task.entity.ScheduleVal;


public interface ScheduleValDAO  extends CrudRepository<ScheduleVal, String> {

	//save or update
	@SuppressWarnings("unchecked")
	@Transactional(value="produceDB")
	ScheduleVal save(ScheduleVal persisted);
    
	@Transactional(value="produceDB")
	void delete(String id);
 	
	@Transactional(value="produceDB")
	void delete(ScheduleVal deleted);

	ScheduleVal findById(String id);
	
	List<ScheduleVal> findByVarNameLike(String varName);
	
	@Query("SELECT a FROM ScheduleVal a where a.varName like %?1%  or a.varValue like %?1% ")
	Page<ScheduleVal> findAll(String searchWord, Pageable pageable);
	
	
}
