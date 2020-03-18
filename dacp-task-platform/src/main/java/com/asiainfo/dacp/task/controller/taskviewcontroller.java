package com.asiainfo.dacp.task.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.modle.Proc;
import com.asiainfo.dacp.modle.ProcInfo;
import com.asiainfo.dacp.modle.ProcRelation;
import com.asiainfo.dacp.modle.ProcScheduleInfo;
import com.asiainfo.dacp.modle.ProcScheduleRunpara;
import com.asiainfo.dacp.modle.ThemeBean;
import com.asiainfo.dacp.modle.TransdatamapDesign;
import com.asiainfo.dacp.repositoris.ProcRepository;
import com.asiainfo.dacp.task.service.TaskViewService;
import com.asiainfo.dacp.util.JsonHelper;
import com.asiainfo.dacp.web.models.User;
import com.asiainfo.dacp.web.SessionKeyConstants;












import org.springframework.web.bind.annotation.*;


@Controller
@RequestMapping("/task")
public class taskviewcontroller {
	private static Logger LOG = LoggerFactory
			.getLogger(taskviewcontroller.class);
	
	@Autowired
	ProcRepository procRepository;
	private static String dataSource="METADB";
	
	@Autowired
	private TaskViewService tvService;
	
	/**
	 * uri为total时，填写调度基本信息
	 */
	@RequestMapping(value = "edittask/{xmlid}", method = RequestMethod.GET)
	public String edittask(@PathVariable("xmlid") String xmlid,HttpServletRequest request, Model model) {
		// model.addAttribute("VIEW_CONF",
		// JsonHelper.getInstance().write(PluginConfig.getInstance().get("view-conf")));
		return "task/total";
	}
	
	@RequestMapping(value = "taskMonitor", method = RequestMethod.GET)
	public String taskMonitor(HttpServletRequest request, Model model) {
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList;
		try {
			selectList = jts.queryForList("select agent_name k,agent_name v,platform parent from aietl_agentnode order by agent_name");
			model.addAttribute("agentList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取agent列表失败", e);
			model.addAttribute("agentList",null);
		}
		
		
		try {
			selectList=jts.queryForList("SELECT dim_code k,dim_value v FROM proc_schedule_dim WHERE dim_group_id IN (SELECT xmlid FROM proc_schedule_dim_group WHERE group_code='CYCLE_TYPE' ) ORDER BY dim_seq");
			model.addAttribute("cycleList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取运行周期失败", e);
			model.addAttribute("cycleList",null);
		}
		try{
			model.addAttribute("team_code",request.getParameter("team_code")==null?"":request.getParameter("team_code"));
		}catch(Exception e){
			model.addAttribute("team_code","");
		}
		return "task/taskMonitor";
	}
	
	private List<Map<String, Object>> getChildMap(String id, List<ThemeBean> themeList,String fullText,String fullVal){
		// 子菜单
	    List<Map<String, Object>> childList = new ArrayList<>();
	    for (ThemeBean theme : themeList) {
	        // 遍历所有节点，不包括一级节点
	        if (!StringUtils.isEmpty(theme.getPid())) {
	        	//将父菜单id与传过来的id比较
	            if (theme.getPid().equals(id)) {
		        	Map<String, Object> map = new HashMap<String, Object>();
		        	map.put("text", theme.getThemeName());
		        	map.put("fullText", fullText + ">" + theme.getThemeName());
		        	map.put("fullVal", fullVal + ">" + theme.getId());
		        	map.put("nodes", getChildMap(theme.getId(), themeList, fullText + ">" + theme.getThemeName(),fullVal+">"+theme.getId()));
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
	
	@RequestMapping(value = "getTheme", method = RequestMethod.GET)
	public @ResponseBody Object getTheme(HttpServletRequest request, Model model) {
		// 最后的返回结果
		List<Map<String, Object>> res = new ArrayList<>();
		String teamCode = request.getParameter("team_code");
		
		//获取所有分组信息
		List<ThemeBean> allThemes = tvService.getAllThemeList();
		if(teamCode == null || "".equalsIgnoreCase(teamCode)||"undefined".equalsIgnoreCase(teamCode)){
			
		}else{
			//过滤租户的主题
			List<String> themeList = tvService.getThemesByTeamCode(teamCode);
			for (int i = allThemes.size() - 1; i >= 0; i--) {
				if (!themeList.contains(allThemes.get(i).getId())) {
					allThemes.remove(i);
				}
			}
		}
	    
	    //组装分组信息
	    for (ThemeBean theme : allThemes) {
	    	// 一级菜单没有pid
	        if (StringUtils.isEmpty(theme.getPid())||"0".equals(theme.getPid())) {
	        	Map<String, Object> map = new HashMap<String, Object>();
	        	map.put("text", theme.getThemeName());
	        	map.put("fullText", theme.getThemeName());
	        	map.put("fullVal", theme.getId());
	        	map.put("nodes", getChildMap(theme.getId(), allThemes, theme.getThemeName(), theme.getId()));
	        	res.add(map);
	        }
		}
		return res;
	}
	
	/**
	 * 新任务监控页面
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "miniTaskMonitor", method = RequestMethod.GET)
	public String miniTaskMonitor(HttpServletRequest request, Model model) {
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList;
		try {
			selectList = jts.queryForList("select agent_name k,agent_name v,platform parent from aietl_agentnode order by agent_name");
			model.addAttribute("agentList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取agent列表失败", e);
			model.addAttribute("agentList",null);
		}
		
		
		try {
			selectList=jts.queryForList("SELECT dim_code k,dim_value v FROM proc_schedule_dim WHERE dim_group_id IN (SELECT xmlid FROM proc_schedule_dim_group WHERE group_code='CYCLE_TYPE' ) ORDER BY dim_seq");
			model.addAttribute("cycleList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取运行周期失败", e);
			model.addAttribute("cycleList",null);
		}
		try{
			model.addAttribute("team_code",request.getParameter("team_code")==null?"":request.getParameter("team_code"));
		}catch(Exception e){
			model.addAttribute("team_code","");
		}
		return "task/miniTaskMonitor";
	}
	
	@RequestMapping(value = "miniAgentMonitorList", method = RequestMethod.GET)
	public String miniAgentMonitorList(HttpServletRequest request, Model model) {
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList;

		try {
			selectList=jts.queryForList("select platform k,platform_cnname v from proc_schedule_platform");
			model.addAttribute("platformList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取agent组列表失败", e);
			model.addAttribute("platformList",null);
		}
		return "task/miniAgentMonitorList";
	}
	
	@RequestMapping(value = "miniServerMonitorList", method = RequestMethod.GET)
	public String miniServerMonitorList(HttpServletRequest request, Model model) {
		return "task/miniServerMonitorList";
	}
	
	@RequestMapping(value = "model_table", method = RequestMethod.GET)
	public String modelTable(HttpServletRequest request, Model model) {
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList;

		try {
			selectList=jts.queryForList("select dbname k,cnname v from metadbcfg order by dbname");
			model.addAttribute("dbList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取数据库列表失败", e);
			model.addAttribute("dbList",null);
		}
		return "task/model_table";
	}
	
	/**
	 * 程序信息录入
	 * 请求方法为get
	 */
	@RequestMapping(value = "addProcInfo", method = RequestMethod.GET)
	public String getprocInfo(String xmlid, HttpServletRequest request,Model model) {
		//获取请求中包含的用户信息的session,并封装为对象
		User user = (User) request.getSession().getAttribute(SessionKeyConstants.USER);
		if (user != null) {
			//如果对象有值，将user添加到模型中 -------id为dacpuser
			model.addAttribute("dacpuser", JsonHelper.getInstance().write(user));
		} else {
			//如果user对象没有值,写入''
			model.addAttribute("dacpuser", "'nouserinfo'");
		}		
		
		if(request.getParameter("dataSource")!=null && request.getParameter("dataSource")!=""){
			dataSource = request.getParameter("dataSource").toString();
		}else{
			dataSource = "METADB";
		}
		
		ProcScheduleInfo procSchedInfo;
		if (StringUtils.isEmpty(xmlid)) {
			procSchedInfo=new ProcScheduleInfo();
		}else{
			procSchedInfo=this.getReportInfo(xmlid, model);
			if(procSchedInfo==null){
				procSchedInfo=new ProcScheduleInfo();
				procSchedInfo.setXmlid(xmlid);
			}
		}
		
		try {
			List<ProcScheduleRunpara> procParams=procRepository.queryRunpara(xmlid,dataSource);
			procSchedInfo.setProcParams(procParams);
			model.addAttribute("procParams", JsonHelper.getInstance().write(procParams));
		} catch (Exception e) {
			LOG.error("获取参数列表失败", e);
			model.addAttribute("procParams",null);
		}
		
		model.addAttribute("procsched",procSchedInfo);
		
		Proc proc = procRepository.queryProcByid(xmlid,dataSource);
		if(proc==null){
			proc=new Proc();
			proc.setXmlid(xmlid);
			proc.setCreater(user.getName());
		}
		model.addAttribute("proc",proc);
		
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		
		List<Map<String, Object>> selectList;
		String sql="";
		String team_code = request.getParameter("team_code")==null ? "" : request.getParameter("team_code");
		try {
			sql="select agent_name id,agent_name name,platform parent from aietl_agentnode order by agent_name";
			selectList=jts.queryForList(sql);
			model.addAttribute("agentList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取agent列表失败", e);
			model.addAttribute("agentList","[]");
		}
		try {
			sql="select platform id,platform_cnname name from proc_schedule_platform where 1=1 {team_code} order by platform";

			if(team_code.trim().equals("") || team_code.equals("null") || team_code.equals("undefined")){
				sql = sql.replace("{team_code}", " ");

			}else{
				sql = sql.replace("{team_code}", " and (team_code='" + team_code + "' or team_code like '" + team_code + ",%' or team_code like '%," + team_code + "' or team_code like '%," + team_code + ",%') ");
			}
			selectList=jts.queryForList(sql);
			model.addAttribute("platformList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取平台列表失败", e);
			model.addAttribute("platformList","[]");
		}
		
		try {
			selectList=jts.queryForList("SELECT dim_code id,dim_value NAME FROM proc_schedule_dim WHERE dim_group_id IN (SELECT xmlid FROM proc_schedule_dim_group WHERE group_code='CYCLE_TYPE' ) ORDER BY dim_seq");
			model.addAttribute("cycleList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取运行周期失败", e);
			model.addAttribute("cycleList","[]");
		}
		
		try {
			selectList=jts.queryForList("SELECT proctype id ,proctype_name NAME FROM proc_schedule_exe_class order by id");
			model.addAttribute("procTypeList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取程序类型失败", e);
			model.addAttribute("procTypeList","[]");
		}
		
		try {
			selectList=jts.queryForList("SELECT job_command id ,job_command NAME,job_type parent FROM job_command order by id");
			model.addAttribute("precmdList",JsonHelper.getInstance().write(selectList));
		} catch (Exception e) {
			LOG.error("获取程序执行命令前缀失败", e);
			model.addAttribute("precmdList","[]");
		}
		
		return "task/procInfo";
	}

	
	//请求为getReportInfo/xx时，交给这个来处理
	@RequestMapping(value = "getReportInfo/{id}", method = RequestMethod.GET)
	//@ResponseBody用于将Controller的方法返回的对象，通过适当的HttpMessageConverter转换为指定格式后，写入到Response对象的body数据区。
	//@PathVariable用来获取地址中携带的id变量值，和@RequestParam的区别是它接受变量值，而不是静态参数
	@ResponseBody
	ProcScheduleInfo getReportInfo(@PathVariable String xmlid, Model model) {
		//获取到id
		ProcScheduleInfo procSchedInfo = procRepository.querySchedInfo(xmlid,dataSource);
		//配置连接数据库
		
		try {
			if (procSchedInfo == null) {
				return procSchedInfo;
			}
		} catch (Exception e) {
			LOG.error("c", e);
		}
		return procSchedInfo;
	}
	
	@RequestMapping(value = "saveProcRela", method = RequestMethod.POST)
	public @ResponseBody String saveProcRela(@RequestBody ProcRelation procRela, Model model,
			HttpSession session, HttpServletRequest request){
		try {
			if(procRela==null)
			return null;
			
			JdbcTemplate jts=new JdbcTemplate(dataSource);
			jts.execute("delete from transdatamap_Design where transname='"+procRela.getTransname()+"'");
	
			List<TransdatamapDesign> transdatamapDesignList=procRela.getProcrala();
			if(transdatamapDesignList==null)
				return null;
			for(int i=0;i<transdatamapDesignList.size();i++){
				TransdatamapDesign transdatamapDesign=transdatamapDesignList.get(i);
				transdatamapDesign.save(jts);
			}
		} catch (SQLException e) {
			LOG.error("保存调度关系失败", e.getMessage());
			return "{\"fail\":\"-1\"}";
		}
	
		return  "{\"success\":\"0\"}";
	}
	
	

	@RequestMapping(value = "createProcInfo", method = RequestMethod.POST)
	public @ResponseBody
	ProcInfo create(@RequestBody ProcInfo procInfo, Model model,
			HttpSession session, HttpServletRequest request) throws Exception {
		User user = (User) session.getAttribute(SessionKeyConstants.USER);

		JdbcTemplate jdbcTemplate=new JdbcTemplate(dataSource);
		if (procInfo != null && procInfo.getXmlid()!= null) {
			//调度信息
			ProcScheduleInfo procScheduleInfo=procInfo.getProcScheuleInfo();
			ProcScheduleInfo procContext = procRepository.querySchedInfo(procScheduleInfo.getXmlid(),dataSource);
			if(procContext !=null){
				this.updateProcSchedInfo(procScheduleInfo, jdbcTemplate);
			}else{
				this.createProcSchedInfo(procScheduleInfo, jdbcTemplate);
			}
			//参数信息
			this.createProcSchedParas(procInfo, jdbcTemplate);
			
			Proc proc = procInfo.getProc();
			Proc procContext2 = procRepository.queryProcByid(proc.getXmlid(),dataSource);
			if(procContext2 !=null){
				
				procContext2.setProc_name(proc.getProc_name());
				procContext2.setProccnname(proc.getProccnname());
				procContext2.setDbname(proc.getDbname());
				procContext2.setTopiccode(proc.getTopiccode());
				procContext2.setProctype(proc.getProctype());
				procContext2.setState(proc.getState());
				procContext2.setState_date(proc.getState_date());

				this.updateProc(procContext2, jdbcTemplate);
			}else{
				this.createProc(proc, jdbcTemplate,user.getName());
			}
		}

		return procInfo;
		
	}
	
	

	void updateProc(Proc proc,JdbcTemplate jdbcTemplate) throws SQLException{
		proc.update(jdbcTemplate);
	}
	
	void createProc(Proc proc,JdbcTemplate jdbcTemplate,String userId) throws SQLException{
		SimpleDateFormat s=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date=s.format(new Date());
		proc.setEff_date(date);
		proc.setCreater(userId);
		proc.save(jdbcTemplate);
	}

	void updateProcSchedInfo(ProcScheduleInfo procScheduleInfo,JdbcTemplate jdbcTemplate) throws SQLException{
			procScheduleInfo.update(jdbcTemplate);
	}

	void createProcSchedInfo(ProcScheduleInfo procScheduleInfo,JdbcTemplate jdbcTemplate) throws SQLException{
		procScheduleInfo.save(jdbcTemplate);
	}
	
	void createProcSchedParas(ProcInfo procInfo,JdbcTemplate jdbcTemplate)
			throws Exception {
		 jdbcTemplate.execute("delete from proc_schedule_runpara where xmlid='"+procInfo.getXmlid()+"'");
	     List<ProcScheduleRunpara> ProcScheduleRunparas=procInfo.getProcScheduleRunpara();
			
		for(int i=0;i<ProcScheduleRunparas.size();i++){
			ProcScheduleRunpara p=ProcScheduleRunparas.get(i);
			p.save(jdbcTemplate);
		}
	}
	
	@RequestMapping(value = "getProcRela", method = RequestMethod.GET)
	public String getProcRela(String xmlid, HttpServletRequest request,Model model) {
		if(request.getParameter("dataSource")!=null && request.getParameter("dataSource")!=""){
			dataSource = request.getParameter("dataSource").toString();
		}else{
			dataSource = "METADB";
		}
		
		JdbcTemplate jts=new JdbcTemplate(dataSource);
		
		Proc proc = procRepository.queryProcByid(xmlid,dataSource);
		if(proc==null){
			proc=new Proc();
		}
		model.addAttribute("proc",proc);
		
		ProcScheduleInfo procContext = procRepository.querySchedInfo(xmlid,dataSource);
		model.addAttribute("procSchedInfo",procContext);
		
		String dependTableSql=" SELECT A.XMLID,A.DBNAME,A.DATANAME,A.DATACNNAME,B.SOURCEFREQ freq FROM TABLEFILE A,transdatamap_design b "+
                              " WHERE b.transname = '"+xmlid+"' AND sourcetype  = 'DATA' AND A.XMLID=B.SOURCE "+
                              " AND TARGETTYPE = 'PROC' AND TRANSNAME=TARGET";
		try {
			List<Map<String, Object>> dependTableList=jts.queryForList(dependTableSql);
			model.addAttribute("dependTableList",JsonHelper.getInstance().write(dependTableList));
		} catch (Exception e) {
			LOG.error("获取主题列表失败", e);
			model.addAttribute("dependTableList","[]");
		}
		String outTableSql=" SELECT A.XMLID,A.DBNAME,A.DATANAME,A.DATACNNAME,B.TARGETFREQ freq FROM TABLEFILE A,transdatamap_design b "+ 
                           " WHERE b.transname = '"+xmlid+"' AND targettype  = 'DATA' AND A.XMLID=B.TARGET "+
                           " AND SOURCETYPE = 'PROC' AND TRANSNAME=SOURCE";
		try {
			List<Map<String, Object>> outTableList=jts.queryForList(outTableSql);
			model.addAttribute("outTableList",JsonHelper.getInstance().write(outTableList));
		} catch (Exception e) {
			LOG.error("获取主题列表失败", e);
			model.addAttribute("outTableList","[]");
		}
		
		String dependProcSql= " SELECT a.xmlid ,a.proc_name,a.proccnname,b.SOURCEFREQ freq FROM proc a,transdatamap_design b WHERE transname = '"+xmlid+"'"
				            + " and a.xmlid=b.source "
                            + " AND SOURCETYPE = 'PROC' AND TARGETTYPE = 'PROC' AND  TRANSNAME=TARGET ";
		try {
			List<Map<String, Object>> dependProcList=jts.queryForList(dependProcSql);
			model.addAttribute("dependProcList",JsonHelper.getInstance().write(dependProcList));
		} catch (Exception e) {
			LOG.error("获取主题列表失败", e);
			model.addAttribute("dependProcList","[]");
		}
		return "task/editProcRelaInfo";
	}
	
	
	public static String[] chars = new String[] { "a", "b", "c", "d", "e", "f",
		"g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s",
		"t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5",
		"6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I",
		"J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
		"W", "X", "Y", "Z" };


	public static String generateShortUuid() {
	StringBuffer shortBuffer = new StringBuffer();
	String uuid = UUID.randomUUID().toString().replace("-", "");
	for (int i = 0; i < 8; i++) {
		String str = uuid.substring(i * 4, i * 4 + 4);
		int x = Integer.parseInt(str, 16);
		shortBuffer.append(chars[x % 0x3E]);
	}
	return shortBuffer.toString();

}
	
}
