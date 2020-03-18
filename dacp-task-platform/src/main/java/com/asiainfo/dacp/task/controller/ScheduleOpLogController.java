/**
 * 
 */
package com.asiainfo.dacp.task.controller;

import javax.servlet.http.HttpServletRequest;

import org.jboss.logging.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.task.entity.JobCommand;
import com.asiainfo.dacp.task.entity.ScheduleOpLog;
import com.asiainfo.dacp.task.service.ScheduleOpLogService;

/**
 * @author FengL
 *
 */

@Controller
@RequestMapping("/task/v3")
public class ScheduleOpLogController {
	
	
	@Autowired
	private ScheduleOpLogService scheduleOpLogService;
	private static final Logger logger = Logger.getLogger(ScheduleOpLogController.class);
	
    @RequestMapping(value = {"/scheduleoplog"}, method = RequestMethod.GET)
    public String getBoot(Model model) {
    	return "task/scheduleoplog";
    }
    
    @SuppressWarnings({ "unused", "unchecked" })
	@RequestMapping(value = "/scheduleoplog/list", method ={ RequestMethod.GET,RequestMethod.POST})
    public  @ResponseBody DpPager<ScheduleOpLog> getData(@RequestParam String page,@RequestParam String sort,@RequestParam String per_page,
    		@RequestParam(value="filter", required=false) String filter,
    		@ModelAttribute("jobcommand") JobCommand jobCommand, Model model, HttpServletRequest request){

		int pageNumber=Integer.valueOf(request.getParameter("page"));
		String rowsPerpageList = null;
		String defaultRowsPerpage=request.getParameter("per_page");
		
		logger.info("getData 32.rowsPerpageList=" + rowsPerpageList + ";defaultRowsPerpage=" + defaultRowsPerpage);

		if (defaultRowsPerpage==null || defaultRowsPerpage.isEmpty())
			defaultRowsPerpage="10";
		if (rowsPerpageList==null || rowsPerpageList.isEmpty()) 
			rowsPerpageList="10,20,50,100,200";

		String rowsperpage=String.valueOf(jobCommand.getRowsperpage());
		String jobType = (jobCommand.getJobType() == null && filter != null) ? filter : jobCommand.getJobType();
		String jobCmd = (jobCommand.getJobCommand() == null && filter != null) ? filter : jobCommand.getJobCommand();

		
		logger.info("Paging all JobCommands.rowsperpage=" + rowsperpage + ";jobType=" + jobType + ";jobCmd=" + jobCmd);
		if (pageNumber<1) pageNumber=1;
		if (rowsperpage==null || rowsperpage.isEmpty()
				|| rowsperpage.equalsIgnoreCase("null")|| rowsperpage.equalsIgnoreCase("0")) rowsperpage=defaultRowsPerpage;
		System.out.println(";pageNumber=" + pageNumber + ";rowsperpage=" + rowsperpage);
		
		String sortColumn="id";

		Page<ScheduleOpLog> pageJc = scheduleOpLogService.getPage(pageNumber-1, Integer.parseInt(rowsperpage),sortColumn,
				jobType, jobCmd);
		
		@SuppressWarnings("rawtypes")
		DpPager dppager=new DpPager(pageJc,pageNumber,Integer.parseInt(rowsperpage));
		return dppager;
    }
}
