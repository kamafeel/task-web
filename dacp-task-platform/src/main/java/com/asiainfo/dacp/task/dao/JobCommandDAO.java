package com.asiainfo.dacp.task.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.asiainfo.dacp.task.entity.JobCommand;


public interface JobCommandDAO  extends CrudRepository<JobCommand, String> {
	//save or saveAndFlush.
	@SuppressWarnings("unchecked")
	@Transactional(value="produceDB")
	JobCommand save(JobCommand persisted);
    
	@Modifying
	@Transactional(value="produceDB")
	@Query("delete from JobCommand where id =:id")
	void delete(@Param("id") String id);
 	
	@Transactional(value="produceDB")
	void delete(JobCommand deleted);
	
	JobCommand findById(String id);	
    
	@Query("SELECT a FROM JobCommand a where JOB_TYPE=:jobType and JOB_COMMAND=:jobCommand ")
	List<JobCommand> isExist(@Param("jobType") String jobType,@Param("jobCommand") String jobCommand);
	
	@Query("SELECT a FROM JobCommand a where JOB_TYPE like %:searchWord%  or JOB_COMMAND like %:searchWord% ")
	Page<JobCommand> findAll(@Param("searchWord") String searchWord, Pageable pageable);
	
}
