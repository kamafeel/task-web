package com.asiainfo.dacp.task.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.modle.ProcessCatalog;
import com.asiainfo.dacp.modle.ProcessInfo;
import com.asiainfo.dacp.task.service.ProcessService;
import com.asiainfo.dacp.util.JsonHelper;

@Controller
@RequestMapping("/process")
public class ProcessMonitorController {
	private static Logger LOG = LoggerFactory.getLogger(ProcessMonitorController.class);

	@Autowired
	private ProcessService processService;

	private static JdbcTemplate jts = new JdbcTemplate("METADBS");

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String showProcessList(HttpServletRequest request, Model model) {

		String sql = "select * from process_list order by pname";
		List<Map<String, Object>> selectList = null;

		try {
			selectList = jts.queryForList(sql);
			model.addAttribute("processList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取进程列表失败", e);
			model.addAttribute("processList", "null");
		}
		
		sql = "select host_name k,host_name v from dp_host_config";
		try {
			selectList = jts.queryForList(sql);
			model.addAttribute("hostList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取主机列表失败", e);
			model.addAttribute("hostList", "null");
		}

		return "task/processMonitor";
	}

	@RequestMapping(value = "/processConfig", method = RequestMethod.GET)
	public String showProcessConfig(String pid, HttpServletRequest request, Model model) {
		List<Map<String, Object>> selectList = null;
		String sql="";
		
		if (pid == null) {
			model.addAttribute("process", "{}");
		}else{
			try {
				sql = "select * from process_list where pid='" + pid + "'";
				selectList = jts.queryForList(sql);
				if(!selectList.isEmpty()){
					model.addAttribute("process", JsonHelper.getInstance().write(selectList.get(0)));
				}else{
					model.addAttribute("process", "{}");
				}
			} catch (Exception ex) {
				LOG.error("未找到pid=" + pid + "进程配置");
				model.addAttribute("process", "{}");
			}
		}
		
		sql = "select dim_code k,dim_value v from proc_schedule_dim where dim_group_id =(select xmlid from proc_schedule_dim_group where group_code='BUSINESS_TYPE') order by dim_seq";
		try {
			selectList = jts.queryForList(sql);
			model.addAttribute("businessList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取业务分类列表失败", e);
			model.addAttribute("businessList", "null");
		}
		
		sql = "select host_name k,host_name v from dp_host_config  order by host_name";
		try {
			selectList = jts.queryForList(sql);
			model.addAttribute("hostList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取业务分类列表失败", e);
			model.addAttribute("hostList", "null");
		}
		
		return "task/processConfig";
	}

	@RequestMapping(value = "/processCatalogConfig", method = RequestMethod.GET)
	public String showProcessCatalogConfig(HttpServletRequest request, Model model) {
		String sql = "select * from process_catalog where pid is null or pid ='' order by order_id";
		List<Map<String, Object>> selectList = null;

		try {
			selectList = jts.queryForList(sql);
			model.addAttribute("CatalogRoot", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取进程目录根节点失败", e);
			model.addAttribute("CatalogRoot", null);
		}

		return "task/processCatalogConfig";
	}

	@RequestMapping(value = "/save", method = { RequestMethod.POST })
	public @ResponseBody Object save(@Valid @ModelAttribute("ProcessInfo") ProcessInfo processInfo,
			BindingResult result) {
		Map<String, String> returnMap = new HashMap<String, String>();
		if (result.hasErrors()) {
			returnMap.put("result", "false");
			returnMap.put("msg", "操作失败");
			return returnMap;
		}

		try {
			if ("add".equals(processInfo.getAction())) {
				processInfo.setPid(UUID.randomUUID().toString().replace("-", ""));
				processInfo.save(jts);
				returnMap.put("msg", "新增成功");
			} else {
				processInfo.update(jts);
				returnMap.put("msg", "修改成功");
			}

		} catch (Exception ex) {
			LOG.error("保存进程配置失败", ex.getMessage());
			returnMap.put("msg", "保存进程配置失败");
		}

		returnMap.put("result", "true");
		return returnMap;
	}
	
	@RequestMapping(value = "/delete", method = { RequestMethod.POST })
	public @ResponseBody Object delete(String pid, HttpServletRequest request) {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			processService.deleteProcess(pid);
		} catch (Exception ex) {
			LOG.error("保存进程配置失败", ex.getMessage());
			returnMap.put("msg", "保存进程配置失败");
		}

		returnMap.put("result", "true");
		return returnMap;
	}
	
	@RequestMapping(value = "isProcessExists", method = { RequestMethod.POST })
	public @ResponseBody Object isProcessExists(@Valid String pid, BindingResult result) {
		Map<String, String> returnMap = new HashMap<String, String>();
		if (result.hasErrors()) {
			returnMap.put("result", "false");
			returnMap.put("msg", "操作失败");
			return returnMap;
		}
		
		if(processService.isProcessExists(pid)){
			returnMap.put("result", "true");
		}else{
			returnMap.put("result", "false");
		}

		return returnMap;
	}

	private List<Map<String, Object>> getChildMap(String id, List<ProcessCatalog> processList, String fullText,
			String fullVal) {
		// 子菜单
		List<Map<String, Object>> childList = new ArrayList<>();
		for (ProcessCatalog item : processList) {
			// 遍历所有节点，不包括一级节点
			if (!StringUtils.isEmpty(item.getCid())) {
				// 将父菜单id与传过来的id比较
				if (item.getPid().equals(id)) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("text", item.getCname());
					map.put("fullText", fullText + ">" + item.getCname());
					map.put("fullVal", fullVal + ">" + item.getCid());
					map.put("nodes", getChildMap(item.getCid(), processList, fullText + ">" + item.getCname(),
							fullVal + ">" + item.getCid()));
					childList.add(map);
				}
			}
		}
		// 递归退出条件
		if (childList.size() == 0) {
			return null;
		}
		return childList;
	}

	@RequestMapping(value = "/getCatalog", method = RequestMethod.GET)
	public @ResponseBody Object getCatalog(HttpServletRequest request, Model model) {
		// 最后的返回结果
		List<Map<String, Object>> res = new ArrayList<>();

		// 获取所有分组信息
		List<ProcessCatalog> allProcessCatalog = processService.getProcessCatalogList();

		// 组装分组信息
		for (ProcessCatalog item : allProcessCatalog) {
			// 一级菜单没有pid
			if (StringUtils.isEmpty(item.getPid()) || "0".equals(item.getPid())) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("text", item.getCname());
				map.put("fullText", item.getCname());
				map.put("fullVal", item.getCid());
				map.put("nodes", getChildMap(item.getCid(), allProcessCatalog, item.getCname(), item.getCid()));
				res.add(map);
			}
		}
		return res;
	}
	
	@RequestMapping(value = "/getBusiness", method = RequestMethod.GET)
	public @ResponseBody Object getBusiness(HttpServletRequest request, Model model) {
		// 最后的返回结果
		List<Map<String, Object>> res = new ArrayList<>();

		// 获取所有分组信息
		List<ProcessCatalog> allProcessCatalog = processService.getBusinessList();

		// 组装分组信息
		for (ProcessCatalog item : allProcessCatalog) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("text", item.getCname());
			map.put("fullText", item.getCname());
			map.put("fullVal", item.getCid());
			map.put("nodes", null);
			res.add(map);
		}
		return res;
	}
}
