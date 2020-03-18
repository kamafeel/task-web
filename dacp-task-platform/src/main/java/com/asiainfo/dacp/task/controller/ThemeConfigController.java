package com.asiainfo.dacp.task.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.task.util.TreeUtil;

@Controller
@RequestMapping("/task/themeconfig")
public class ThemeConfigController {
	private static Logger LOG = LoggerFactory.getLogger(ThemeConfigController.class);
	private static JdbcTemplate jt = new JdbcTemplate("METADBS");
	
	@RequestMapping("/getThemeTree")
	public @ResponseBody Object getThemeTree(HttpServletRequest request) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try{
			List<Map<String,Object>> list = jt.queryForList("select t.*, t.theme_name name from proc_schedule_theme t order by sort_no");
			resultMap.put("data", TreeUtil.listToTree(list, "id", "pid", "children"));
			resultMap.put("success", true);
		}catch(Exception e){
			LOG.error("获取任务主题配置信息失败",e);
			resultMap.put("success", false);
			resultMap.put("msg", "获取任务主题配置信息失败");
		}
		return resultMap;
	}
	
	@RequestMapping("/saveTheme")
	public @ResponseBody Object saveTheme(HttpServletRequest request) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try{
			String pid = request.getParameter("pid");
			String name = request.getParameter("themeName");
			String opType = request.getParameter("opType");
			String id = request.getParameter("id");
			if(pid == null || pid.length() == 0){
				pid = "0";
			}
			if (name == null || name.length() == 0){
				resultMap.put("success", false);
				resultMap.put("msg", "主题名称不能为空:");
				return resultMap;
			}
			if("edit".equalsIgnoreCase(opType)){
				jt.update("update proc_schedule_theme set theme_name=? where id = ?", 
						new Object[]{name, id});
			}else{
				String newId = RandomStringUtils.randomNumeric(10);
				List<Map<String,Object>> list = jt.queryForList("select * from proc_schedule_theme where theme_name = ?",new Object[]{name});
				if(list != null && list.size() > 0 ){
					resultMap.put("success", false);
					resultMap.put("msg", "主题名称已存在:"+name);
					return resultMap;
				}
				jt.update("insert into proc_schedule_theme(id,pid,theme_name) values (?,?,?)", 
						new Object[]{newId,pid,name});
			}
			resultMap.put("success", true);
		}catch(Exception e){
			LOG.error("保存主题对象失败",e);
			resultMap.put("success", false);
			resultMap.put("msg", "保存主题失败"+e.getMessage());
		}
		return resultMap;
	}
	
	@RequestMapping("/deleteTheme")
	public @ResponseBody Object deleteTheme(HttpServletRequest request) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try{
			String id = request.getParameter("id");
			List<Map<String,Object>> list = jt.queryForList("select * from proc_schedule_theme where pid = ?",new Object[]{id});
			if (list != null && list.size() > 0 ){
				resultMap.put("success", false);
				resultMap.put("msg", "存在子节点， 无法删除！");
				return resultMap;
			}
			jt.update("delete from proc_schedule_theme where id = ?", id);
			resultMap.put("success", true);
		}catch(Exception e){
			LOG.error("删除主题对象失败",e);
			resultMap.put("success", false);
			resultMap.put("msg", "删除主题对象失败");
		}
		return resultMap;
	}
	
	@RequestMapping("/clearLeaf")
	public @ResponseBody Object clearLeaf(HttpServletRequest request) throws Exception {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try{
			String pid = request.getParameter("pid");
			jt.update("delete from proc_schedule_theme where pid = ?", pid);
			resultMap.put("success", true);
		}catch(Exception e){
			LOG.error("删除子节点失败",e);
			resultMap.put("success", false);
			resultMap.put("msg", "删除子节点失败");
		}
		return resultMap;
	}
}
