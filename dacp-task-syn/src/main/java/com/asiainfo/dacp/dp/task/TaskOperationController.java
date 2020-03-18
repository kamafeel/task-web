package com.asiainfo.dacp.dp.task;

import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.httpclient.NameValuePair;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.dp.task.bean.BaseResult;
import com.asiainfo.dacp.dp.task.type.TaskOperation;
import com.asiainfo.dacp.dp.task.utils.HttpClientUtil;
import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.google.gson.Gson;

import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;

@Slf4j
@Controller
@RequestMapping("/taskOpt")
public class TaskOperationController {
	
	private final static String API_URL = "/scheduleManager/synCache/";
	
	@RequestMapping("/executionWithoutDelay")
	@ResponseBody
	public void executionWithoutDelay(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
				new NameValuePair("seqno", seqno)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.executionWithoutDelay.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reInfo"));
		out.write(gson.toJson(returnRes));
	}
	
	
	@RequestMapping("/getCondiNotrigger")
	@ResponseBody
	public void getCondiNotrigger(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String xmlid = request.getParameter("xmlid");
		String dateArgs = request.getParameter("dateArgs");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(xmlid)) {
			returnRes.put("response", "缺少参数xmlid");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		if (StringUtils.isEmpty(dateArgs)) {
			returnRes.put("response", "缺少参数dateArgs");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
				new NameValuePair("xmlid", xmlid),
				new NameValuePair("dateArgs", dateArgs)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.getCondiNotrigger.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reInfo"));
		out.write(gson.toJson(returnRes));
	}
	
	
	@RequestMapping("/getWaitCode")
	@ResponseBody
	public void getWaitCode(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.getWaitCode.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/addNew")
	@ResponseBody
	public void addNew(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String xmlid = request.getParameter("xmlid");
		String dateArgs = request.getParameter("dateArgs");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(xmlid)) {
			returnRes.put("response", "缺少参数xmlid");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		if (StringUtils.isEmpty(dateArgs)) {
			returnRes.put("response", "缺少参数dateArgs");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
			new NameValuePair("xmlid", xmlid),
			new NameValuePair("dateArgs", dateArgs)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.addNew.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	
	@RequestMapping("/redoCur")
	@ResponseBody
	public void redoCur(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		String returnCode = request.getParameter("returncode");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
			new NameValuePair("invalidSeqno", seqno),
			new NameValuePair("returnCode", returnCode)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.redoCur.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/redoAfter")
	@ResponseBody
	public void redoAfter(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		String returnCode = request.getParameter("returncode");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={ 
			new NameValuePair("invalidSeqno", seqno),
			new NameValuePair("returnCode", returnCode)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.redoAfter.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/setPriLevel")
	@ResponseBody
	public void setPriLevel(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		String priLevel = request.getParameter("prilevel");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}else if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数prilevel");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno), 
			new NameValuePair("priLevel", priLevel)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.setPriLevel.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/forceExec")
	@ResponseBody
	public void forceExec(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.forceExec.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/forcePass")
	@ResponseBody
	public void forcePass(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={  
			new NameValuePair("seqno", seqno)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.forcePass.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/pauseTask")
	@ResponseBody
	public void pauseTask(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno)
		};
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.pauseTask.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/recoverTask")
	@ResponseBody
	public void recoverTask(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.recoverTask.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/manualTask")
	@ResponseBody
	public void manualTask(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		NameValuePair[] data={  
			new NameValuePair("seqno", seqno)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.manualTask.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	@RequestMapping("/executeManual")
	@ResponseBody
	public void executeManual(HttpServletRequest request, HttpServletResponse response, Writer writer)
			throws IOException {
		String seqno = request.getParameter("seqno");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();
		if (StringUtils.isEmpty(seqno)) {
			returnRes.put("response", "缺少参数seqno");
			returnRes.put("flag", "false");
			out.write(gson.toJson(returnRes));
			return;
		}
		
		NameValuePair[] data={ 
			new NameValuePair("seqno", seqno)
		};
		
		JSONObject json = JSONObject.fromObject(sendRequest(data, TaskOperation.executeManual.name()));
		if(json.getInt("reCode")==200){
			returnRes.put("flag", "true");
		}else{
			returnRes.put("flag", "false");
		}
		returnRes.put("response", json.getString("reMsg"));
		out.write(gson.toJson(returnRes));
	}
	
	public Object sendRequest(NameValuePair[] data, String opType) {		
		JdbcTemplate jdbc = new JdbcTemplate("METADBS");
		List<Map<String, Object>> ips = jdbc.queryForList(
				"select host_name,api_port from aietl_servernode b where b.server_status=1 ORDER BY b.status_time DESC");
		if(ips == null || ips.isEmpty()){
			BaseResult returnRes = new BaseResult();
			returnRes.setReCode(400);
			returnRes.setReInfo("无有效server可用");
			return returnRes;
		}
		String hostName = ips.get(0).get("host_name").toString();
		String strURL = "http://" + hostName.substring(hostName.lastIndexOf("@")+1,hostName.length()) + ":" + ips.get(0).get("api_port").toString()
				+ API_URL + opType;
		log.info("Call task-server URL:{},Pair:{}", strURL,data.toString());
		return HttpClientManager.executePostMethod(strURL, data);
	
	}
}
