package com.asiainfo.dacp.task.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.jdbc.JdbcTemplate;

/**
 * 流程图
 * @author lll
 * 
 */
@Controller
@RequestMapping("/dataflow")
public class DataFlowController {
	private static Logger LOG = LoggerFactory.getLogger(DataFlowController.class);
	
	/**获取一层前置节点或影响节点，
	 * @return Map<String, List<Map<String, Object>>>
	 */
	@RequestMapping(value = "preornext", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, List<Map<String, Object>>> preOrNext(@RequestBody Map<String, List<Map<String,Object>>> requestObjListMap){
		String xmlid = "";
		String dateArgs = (String) requestObjListMap.get("dateArgs").get(0).get("dateArgs");
		String direct = (String) requestObjListMap.get("direct").get(0).get("direct");//pre：前置，next：影响
		
		JdbcTemplate jts =new JdbcTemplate("METADBS");
		List<Map<String, Object>> selectList = null;
		Map<String, List<Map<String, Object>>> nextMap = new HashMap<String, List<Map<String, Object>>>();
		
		for(Entry<String, List<Map<String, Object>>> entry : requestObjListMap.entrySet()){
			if("dateArgs".equals(entry.getKey())) continue;
			List<Map<String,Object>> requestObjList = entry.getValue();
			for(int i = 0; i < requestObjList.size(); i++){
				xmlid = (String) requestObjList.get(i).get("xmlid");
				LOG.info("xmlid:{}",xmlid);
				//todo,null值判断
				if("pre".equals(direct)){		
					try {
						selectList = jts.queryForList("select a.source text,a.source xmlid,a.sourcefreq freq,a.sourcetype type "
								+ " from transdatamap_design a where a.target='" + xmlid + "'");
					} catch (Exception e) {
						LOG.error("获取前置程序失败", e);
					}
				}
				if("next".equals(direct)){
					try {
						selectList = jts.queryForList("select a.target text,a.target xmlid,a.targetfreq freq,a.targettype type "
								+ " from transdatamap_design a where a.source='" + xmlid + "'");
					} catch (Exception e) {
						LOG.error("获取影响程序失败", e);
					}
				}
				
				if(selectList != null && selectList.size() > 0){
					selectList = getNameState(jts, dateArgs, selectList);
					nextMap.put(xmlid, selectList);
				}
			}
		}
		return nextMap;
	}
	
	/**获取所有前置和影响节点
	 * @return Map<String, List<Map<String, Object>>>
	 */
	@ResponseBody
	@RequestMapping(value = "all", method = RequestMethod.POST)
	public Map<String, Map<String, List<Map<String,Object>>>> all(@RequestBody Map<String, Map<String, List<Map<String,Object>>>> requestAllMap){
		Map<String, Map<String, List<Map<String,Object>>>> returnAllMap = new HashMap<String, Map<String, List<Map<String,Object>>>>();
		
		Map<String, List<Map<String,Object>>> preAllMap = new HashMap<String, List<Map<String, Object>>>();
		Map<String, List<Map<String,Object>>> nextAllMap = new HashMap<String, List<Map<String, Object>>>();
		
		Map<String, List<Map<String, Object>>> preMap = preOrNext(requestAllMap.get("preMap"));
		Map<String, List<Map<String, Object>>> nextMap = preOrNext(requestAllMap.get("nextMap"));
		List<Map<String, Object>> dateArgsList = requestAllMap.get("preMap").get("dateArgs");
		List<Map<String, Object>> preDirectList = requestAllMap.get("preMap").get("direct");
		List<Map<String, Object>> nextDirectList = requestAllMap.get("nextMap").get("direct");
		do{
			preAllMap.putAll(preMap);
			preMap.put("dateArgs", dateArgsList);
			preMap.put("direct", preDirectList);
			preMap = preOrNext(preMap);
		}while(!preMap.isEmpty());
		returnAllMap.put("pre", preAllMap);
		do{
			nextAllMap.putAll(nextMap);
			nextMap.put("dateArgs", dateArgsList);
			nextMap.put("direct", nextDirectList);
			nextMap = preOrNext(nextMap);
		}while(!nextMap.isEmpty());
		returnAllMap.put("next", nextAllMap);
		return returnAllMap;
	}
	
	/**根据类型 获取中文名所在表和字段
	 * return List<Map<String, Object>> 
	 */
	public List<Map<String, Object>> getNameState(JdbcTemplate jts,String dateArgs, List<Map<String, Object>> list){
		String xmlid = "";
		String type = "";

		String basePk = "";
		String colName = "";
		String baseInfoTable = "";
		
		String logPk = "";
		String colState = "";
		String colDate = "";
		String logTableName = "";
		String otherWhere = "";
		
		//List<Map<String, Object>> tempList;
		List<Map<String, Object>> tempNameList;
		List<Map<String, Object>> tempStateList;
		for(int i = 0; i < list.size(); i++){
			tempNameList = null;
			tempStateList = null;
			otherWhere = "";
			type = (String) list.get(i).get("type");
			xmlid = (String) list.get(i).get("xmlid");
			Boolean baseFlag = true;
			Boolean stateFlag = true;
			//通过类型获取表名、主键，通过表名主键获取名称
			switch(type){
				case "PROC":
				case "EVENT":
					basePk ="xmlid";
					colName = "proc_name";
					baseInfoTable = "proc";
					break;
				case "DATA":
					basePk = "xmlid";
					colName= "dataname";
					baseInfoTable = "tablefile";
					break;
				case "INTER":
					basePk = "xmlid";
					colName = "fullintercode";
					baseInfoTable = "inter_cfg";
					break;
				case "SCOPE":
					basePk = "kpi_scope_id";
					colName = "kpi_scope_code";
					baseInfoTable = "kpi_scope_def";
					break;
				default:
					baseFlag = false;
					break;
			}
			//通过类型获取表名、主键，通过表名、主键、时间 获取此刻状态
			switch(type){
				case "PROC":
				case "SCOPE":
					logPk = "xmlid";
					logTableName = "proc_schedule_log";
					colState = "task_state state,date_args,exec_time,end_time,use_time";
					colDate = "date_args";
					otherWhere = " and valid_flag='0'";
					break;
				case "DATA":
					logPk = "target";
					logTableName = "proc_schedule_meta_log";
					colState = "'1' state";
					colDate = "date_args";
					break;
				case "INTER":
					logPk = "xmlid";
					logTableName = "inter_log";
					colState = "check_put_status state";
					colDate = "date_args";
					break;
				case "EVENT":
				case "FILE":
					stateFlag = false;
					break;
				default:
					stateFlag = false;
					break;
			}
//			if(baseFlag){
//				tempList = jts.queryForList("SELECT " + colName + " text,(SELECT " + colState + " FROM " 
//						+ logTableName +" WHERE " + logPk + "='" +xmlid + "' and " + colDate + "='" + dateArgs +"') AS state FROM " 
//						+ baseInfoTable +" WHERE " + basePk +"='" + xmlid + "'");
//				if(tempList.size() > 0) list.get(i).putAll(tempList.get(0));
//			}
			if(baseFlag){
				try {
					tempNameList =  jts.queryForList("SELECT " + colName + " text FROM " 
							+ baseInfoTable +" WHERE " + basePk +"='" + xmlid + "'");
				} catch (Exception e) {
					LOG.error("获取xmlid=" + xmlid +"的名称失败", e);
				}
				if(tempNameList !=null && tempNameList.size() > 0) list.get(i).putAll(tempNameList.get(0));
			}
			if(stateFlag){
				try {
					tempStateList = jts.queryForList("SELECT " + colState + " FROM " 
						+ logTableName +" WHERE " + logPk + "='" +xmlid + "' and " + colDate + "='" + dateArgs 
						+ "'" + otherWhere);
				} catch (Exception e) {
					LOG.error("获取xmlid=" + xmlid +"的状态失败", e);
				}
				if(tempStateList !=null && tempStateList.size() > 0) list.get(i).putAll(tempStateList.get(0));
			}
		}
		return list;
	}

}
