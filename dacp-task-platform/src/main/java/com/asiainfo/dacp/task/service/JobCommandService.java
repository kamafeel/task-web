/**
 * 
 */
package com.asiainfo.dacp.task.service;

import java.util.List;

import org.springframework.data.domain.Page;

import com.asiainfo.dacp.task.entity.JobCommand;

/**
 * @author FengL
 *
 */
public interface JobCommandService {
	JobCommand save(JobCommand jobCommand);
	
    void delete(String id);
    
    void deleteList(List<JobCommand> jobcommands);
    
    JobCommand findById(String id);
    
    Page<JobCommand> findAll(Integer pageNumber, Integer pageSize, String sortColumn, String sortType, String searchWord) ;

	boolean isExist(String jobType, String jobCommand);

}
