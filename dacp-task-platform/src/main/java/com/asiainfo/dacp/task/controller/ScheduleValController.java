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
import com.asiainfo.dacp.task.entity.ScheduleVal;
import com.asiainfo.dacp.task.service.ScheduleValService;
import com.asiainfo.dacp.task.util.CustomUtils;

@Controller
public class ScheduleValController {
	
	@Autowired
	private ScheduleValService scheduleValService;
	
	private static String rowsperpage;
	
	private static Logger LOG = LoggerFactory.getLogger(ScheduleValController.class);
	
	public ScheduleValController() {
		LOG.info("ScheduleValController()");
	}
    
    @RequestMapping(value = "/scheduleVal/save", method ={ RequestMethod.POST})
    @ResponseBody
    public Map<String, String> save(@Valid @ModelAttribute("ScheduleVal") ScheduleVal  scheduleVal, BindingResult result) {
    	Map<String, String> returnMap = new HashMap<String, String>();
    	if (result.hasErrors()) {
    		returnMap.put("result", "false");
    		returnMap.put("msg", "操作失败");
    		return returnMap;
    	}
        if(StringUtils.isEmpty(scheduleVal.getId())){ // if ScheduleVal id is 0 then creating the ScheduleVal other updating the ScheduleVal
        	scheduleVal.setId(CustomUtils.getUUID());
        	scheduleValService.save(scheduleVal);
            returnMap.put("msg", "新增成功");
        } else {
            scheduleValService.save(scheduleVal);
            returnMap.put("msg", "修改成功");
        }
        returnMap.put("result", "true");
        return returnMap;
    }
    
    @RequestMapping(value = "/scheduleVal/delete", method ={ RequestMethod.POST})
    @ResponseBody
    public String delete(@RequestBody List<ScheduleVal> jobcommands) {
    	System.out.println(jobcommands);
    	for(int i = 0; i < jobcommands.size(); i++){
    		scheduleValService.delete(jobcommands.get(i).getId());
    	}
        return "true";
    }
    
    
    @RequestMapping(value = "/scheduleVal/isExist", method ={ RequestMethod.GET})
    @ResponseBody
    public boolean isExist(@RequestParam String varName){
    	return scheduleValService.isExist(varName);
    }
    
    /**
     * 分页查询*/
	@RequestMapping(value = "/scheduleVal/findAll", method ={ RequestMethod.GET,RequestMethod.POST})
    public  @ResponseBody DpPager<ScheduleVal> findAll(@RequestParam String page,
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

		Page<ScheduleVal> pageJc = scheduleValService.findAll(pageNumber-1, Integer.parseInt(rowsperpage),
				sortColumn, sortType, searchWord);
		
		return new DpPager<ScheduleVal>(pageJc,pageNumber,Integer.parseInt(rowsperpage));
    }

    
}
