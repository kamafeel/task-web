package com.asiainfo.dacp.task.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.task.entity.JobCommand;
import com.asiainfo.dacp.task.service.JobCommandService;
import com.asiainfo.dacp.task.util.CustomUtils;
import com.asiainfo.dacp.util.JsonHelper;

@Controller
public class JobCommandController {
	@Autowired
	private JobCommandService jobCommandService;
	
	private static String rowsperpage;
	
	private static Logger LOG = LoggerFactory.getLogger(JobCommandController.class);
	//程序类型
	private static String jobtypeList;
	
	public JobCommandController() {
		LOG.info("JobCommandController()");
	}
    
    @RequestMapping(value = {"/ftl/jobcommand"}, method = RequestMethod.GET)
    public String toPage(Model model) {
    	model.addAttribute("jobtypeList",getJobtypeList());
    	return "task/jobcommand";
    }
    
    
    @RequestMapping(value = "/jobcommand/save", method ={ RequestMethod.POST})
    @ResponseBody
    public Map<String, String> save(@Valid @ModelAttribute("JobCommand") JobCommand  jobCommand, BindingResult result) {
    	Map<String, String> returnMap = new HashMap<String, String>();
    	if (result.hasErrors()) {
    		returnMap.put("result", "false");
    		returnMap.put("msg", "操作失败");
    		return returnMap;
    	}
        if(jobCommand.getId() == null || jobCommand.getId().equals("")){ // if JobCommand id is 0 then creating the JobCommand other updating the JobCommand
        	jobCommand.setId(CustomUtils.getUUID());
        	jobCommandService.save(jobCommand);
            returnMap.put("msg", "新增成功");
        } else {
            jobCommandService.save(jobCommand);
            returnMap.put("msg", "修改成功");
        }
        returnMap.put("result", "true");
        return returnMap;
    }
    
    @RequestMapping(value = "/jobcommand/delete", method ={ RequestMethod.POST})
    @ResponseBody
    public String delete(@RequestBody List<JobCommand> jobcommands) {
    	System.out.println(jobcommands);
//    	jobCommandService.deleteList(jobcommands);
    	for(int i = 0; i < jobcommands.size(); i++){
    		jobCommandService.delete(jobcommands.get(i).getId());
    	}
        return "true";
    }
    
	@RequestMapping(value = "/jobcommand/findAll", method ={ RequestMethod.GET,RequestMethod.POST})
    public  @ResponseBody DpPager<JobCommand> findAll(@RequestParam String page,
    			@RequestParam String sort,@RequestParam String per_page,
    			@RequestParam(value="filter", required=false) String filter,
    			Model model, HttpServletRequest request){

		//查询关键字
		String searchWord = StringUtils.isEmpty(filter) ? "" : filter.trim();
		
		//分页处理
		int pageNumber=Integer.valueOf(request.getParameter("page"));
		rowsperpage=request.getParameter("per_page");
		
		if (StringUtils.isEmpty(rowsperpage) || rowsperpage.equalsIgnoreCase("null") 
				|| rowsperpage.equalsIgnoreCase("0")) rowsperpage="10";
		if (pageNumber < 1) pageNumber = 1;
		
		//排序处理
		String[] sortArr = sort.split("\\|");
		String sortColumn = "varType";
		String sortType = "ASC";
		if(sortArr.length == 2){
			sortColumn = sortArr[0].trim();
			sortType = sortArr[1].trim();
		}

		LOG.info("Paging all ScheduleVals: pageNumber:{};rowsperpage={};searchWord={};sortColumn={};sortType={}",
				pageNumber, rowsperpage, searchWord, sortColumn, sortType);
		
		Page<JobCommand> pageJc = jobCommandService.findAll(pageNumber-1, Integer.parseInt(rowsperpage),
				sortColumn, sortType, searchWord);
		
		return new DpPager<JobCommand>(pageJc,pageNumber,Integer.parseInt(rowsperpage));
    }

    @RequestMapping(value = "/jobcommand/isExist", method ={ RequestMethod.GET})
    @ResponseBody
    public boolean isExist(@RequestParam String jobType, @RequestParam String jobCommand){
    	return jobCommandService.isExist(jobType, jobCommand);
    }
    
    public static String getJobtypeList(){
    	//if(jobtypeList == null || "".equals(jobtypeList.trim())){
    		try {
    			JdbcTemplate jts = new JdbcTemplate("METADBS");
    			List<Map<String, Object>> selectList = jts.queryForList("SELECT proctype FROM proc_schedule_exe_class");
    			jobtypeList = JsonHelper.getInstance().write(selectList);
    		} catch (Exception e) {
    			LOG.error("获取程序类型失败", e);
    			jobtypeList = "[]";
    		}
    	//}
    	return jobtypeList;
    }

}
