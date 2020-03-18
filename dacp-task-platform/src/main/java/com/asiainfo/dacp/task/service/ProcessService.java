package com.asiainfo.dacp.task.service;

import java.util.List;

import com.asiainfo.dacp.modle.ProcessCatalog;
import com.asiainfo.dacp.modle.ProcessInfo;


public interface ProcessService {
	List<ProcessInfo> getProcessList();
	List<ProcessCatalog> getProcessCatalogList();
	boolean saveProcess(ProcessInfo processInfo);
	List<ProcessCatalog> getBusinessList();
	boolean deleteProcess(String pid);
	boolean isProcessExists(String pid);
}
