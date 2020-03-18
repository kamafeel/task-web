/**
 * 
 */
package com.asiainfo.dacp.task.service;

import org.springframework.data.domain.Page;

import com.asiainfo.dacp.task.entity.ScheduleVal;

/**
 * @author FengL
 *
 */
public interface ScheduleValService {
	ScheduleVal save(ScheduleVal scheduleVal);
	
    void delete(String id);
    
    ScheduleVal findById(String id);
    
    Page<ScheduleVal> findAll(Integer pageNumber,Integer pageSize, String sortColumn, String sortType, String searchWord) ;

	boolean isExist(String varName);

}
