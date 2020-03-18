package com.asiainfo.dacp.task.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.task.entity.TaskLog;
import com.asiainfo.dacp.task.service.ManualTaskService;
import com.asiainfo.dacp.util.JsonHelper;

@Controller
@RequestMapping(value="/task")
public class ManualTaskController {
	private static Logger LOG = LoggerFactory.getLogger(ManualTaskController.class);

	@Autowired
	private ManualTaskService manualTaskService;

	private static String rowsperpage;

	public ManualTaskController() {
		System.out.println("ManualTaskController()");
	}

	@RequestMapping(value = { "/manualTask/list" }, method = RequestMethod.GET)
	public String toPage(Model model) {
		JdbcTemplate jts = new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList = null;
		
		// 程序类型
		try {
			selectList = jts.queryForList("SELECT proctype k ,proctype_name v FROM proc_schedule_exe_class order by v");
			model.addAttribute("proctypeList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取任务类型失败", e);
			model.addAttribute("proctypeList", "[]");
		}

		// platform列表
		try {
			selectList = jts.queryForList("select platform k,platform_cnname v from proc_schedule_platform order by v");
			model.addAttribute("platformList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取platform列表失败", e);
			model.addAttribute("platformList", "[]");
		}

		// agent列表
		try {
			selectList = jts.queryForList(
					"select agent_name k,agent_name v,platform p from aietl_agentnode where task_type='TASK' order by v");
			model.addAttribute("agentList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取agent列表失败", e);
			model.addAttribute("agentList", "[]");
		}
		// 命令前缀
		try {
			selectList = jts.queryForList(
					"select job_command k ,job_command v,job_type p from job_command order by v ");
			model.addAttribute("preCmdList", JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取程序执行命令前缀失败", e);
			model.addAttribute("preCmdList", "[]");
		}
		return "task/manualTask";
	}

	@RequestMapping(value = "/manualTask/save", method = { RequestMethod.POST })
	@ResponseBody
	public Map<String, String> save(TaskLog taskLog, BindingResult result) {
		Map<String, String> returnMap = new HashMap<String, String>();
		if (result.hasErrors()) {
			returnMap.put("result", "false");
			returnMap.put("msg", "操作失败");
			return returnMap;
		}
		if (taskLog.getSeqno() == null || taskLog.getSeqno().equals("")) {
			returnMap.put("result", "false");
			returnMap.put("msg", "未生成seqno");
			return returnMap;
		} else {
			manualTaskService.save(taskLog);
			returnMap.put("msg", "保存成功");
		}
		returnMap.put("result", "true");
		return returnMap;
	}

	@RequestMapping(value = "/manualTask/delete", method = { RequestMethod.POST })
	@ResponseBody
	public String delete(@RequestBody List<TaskLog> logs) {
		for (int i = 0; i < logs.size(); i++) {
			manualTaskService.delete(logs.get(i).getSeqno());
		}
		return "true";
	}

	// @SuppressWarnings({ "unused", "unchecked" })
	@RequestMapping(value = "/manualTask/findAll", method = { RequestMethod.GET, RequestMethod.POST })
	public @ResponseBody DpPager<TaskLog> findAll(@RequestParam String page, @RequestParam String sort,
			@RequestParam String per_page, @RequestParam(value = "filter", required = false) String filter,
			@RequestParam(value = "filter2", required = false) String filter2,
			@ModelAttribute("manualTask") TaskLog taskLog, Model model, HttpServletRequest request) {

		//分页处理
		int pageNumber=Integer.valueOf(request.getParameter("page"));
		rowsperpage=request.getParameter("per_page");
		
		if (StringUtils.isEmpty(rowsperpage) || rowsperpage.equalsIgnoreCase("null") 
				|| rowsperpage.equalsIgnoreCase("0")) rowsperpage="10";
		if (pageNumber < 1) pageNumber = 1;

		String procName = (taskLog.getProcName() == null && filter != null) ? filter : taskLog.getProcName();
		String dateArgs = (taskLog.getDateArgs() == null && filter2 != null) ? filter2 : taskLog.getDateArgs();

		// 排序
		String[] sortArr = sort.split("\\|");
		String sortColumn = "dateArgs";
		String sortType = "DESC";
		if (sortArr.length == 2) {
			sortColumn = sortArr[0].trim();
			sortType = sortArr[1].trim();
		}

		Page<TaskLog> pageJc = manualTaskService.findAll(pageNumber - 1, Integer.parseInt(rowsperpage), sortColumn,
				sortType, procName, dateArgs);

		return new DpPager<TaskLog>(pageJc, pageNumber, Integer.parseInt(rowsperpage));
	}

}
