package com.asiainfo.dacp.task.dao;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.asiainfo.dacp.task.entity.TaskLog;

public interface ManualTaskDAO extends CrudRepository<TaskLog, String> {
	// save or saveAndFlush.
	@SuppressWarnings("unchecked")
	@Transactional(value = "produceDB")
	TaskLog save(TaskLog persisted);

	@Modifying
	@Transactional(value = "produceDB")
	@Query("delete from TaskLog where runFreq='manual' and seqno =:seqno")
	void delete(@Param("seqno") String seqno);

	@Transactional(value = "produceDB")
	void delete(TaskLog deleted);

	TaskLog findBySeqno(String seqno);

	@Query("SELECT a FROM TaskLog a where runFreq='manual' and seqno=:seqno")
	List<TaskLog> isExist(@Param("seqno") String seqno);

	@Query("SELECT a FROM TaskLog a where runFreq='manual' and procName=?1 and dateArgs =?2")
	List<TaskLog> isExist(String procName, String date_args);
	
	@Query("SELECT a FROM TaskLog a where runFreq='manual' and procName like %?1% and dateArgs like %?2% ")
	Page<TaskLog> findAll(String procName, String dateArgs, Pageable pageable);

}
