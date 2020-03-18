package com.asiainfo.dacp.dp.syn;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.crypto.cipher.DesCipher;
import com.asiainfo.dacp.dp.task.bean.BaseResult;
import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.google.gson.Gson;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;


@Controller
public class ScheduleController {
	private static Logger log = LoggerFactory.getLogger(ScheduleController.class);
	private static JdbcTemplate jts = new JdbcTemplate("METADBS");
	//执行shell，输出
	private String stdout;
	
	private String getShortCycle(String cycle){
		String shortCycle="D";
		switch (cycle) {
		case "year":
			shortCycle="Y";
			break;
		case "month":
			shortCycle="M";
			break;
		case "day":
			shortCycle="D";
			break;
		case "hour":
			shortCycle="H";
			break;
		case "minute":
			shortCycle="MI";
			break;
		case "week":
			shortCycle="W";
			break;

		default:
			break;
		}
		return shortCycle;
	}
	
	
	/**
	 * 保存指标组依赖服务(兼容Oracle)
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/shd/saveKpiScopeDependciesInfo")
	public void SaveKpiScopeDependciesInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String target = request.getParameter("target");
		String targetType = request.getParameter("targetType").toUpperCase();//全部转换为大写
		String sourceCycle = request.getParameter("sourceCycle");
		String source = request.getParameter("source");
		String sourceType = request.getParameter("sourceType").toUpperCase();
		String targetCycle = request.getParameter("targetCycle");
		String targetFreq = StringUtils.isEmpty(targetCycle)?null: getShortCycle(targetCycle) + "-0";

		JdbcTemplate jdbc = new JdbcTemplate("METADB");
		Writer out = response.getWriter();
		Gson gson = new Gson();
		Map<String, String> returnRes = new HashMap<String, String>();

		try {
			// 删除原有依赖
			String delete_sql = " DELETE FROM transdatamap_design WHERE target ='"
					+ target + "' ";
			jdbc.execute(delete_sql);
			// 保存依赖关系
			String _sql = " insert into transdatamap_design (xmlid,flowcode,transname,source,sourcetype,sourcefreq,target,targettype,targetfreq) "+
						  " values(?,?,?,?,?,?,?,?,?) ";
			String transname = target;
			if (sourceType.toUpperCase() .equals("SCOPE")) {
				transname = source;
			}
			PreparedStatement ps = jdbc.getDataSource().getConnection().prepareStatement(_sql);

			String[] sources = source.split(",");
			String[] sourcecycles=sourceCycle.split(",");
			String[] sourcetypes=sourceType.split(",");
			for (int i = 0; i < sources.length; i++) {
				ps.setString(1, UUID.randomUUID().toString().replace("-", ""));
				ps.setString(2, "DEFAULT_FLOW");
				ps.setString(3, transname);
				ps.setString(4, sources[i]);
				ps.setString(5, sourcetypes[i]);
				String sourceFreq= sourcecycles[i].equals("null")?null:sourcecycles[i].substring(0,1).toUpperCase()+"-0";
				ps.setString(6, sourceFreq);
				ps.setString(7, target);
				ps.setString(8, targetType);
				ps.setString(9, targetFreq);
				ps.addBatch();
			}
			
			ps.executeBatch();
			ps.clearBatch();
			
			//指标组初始化/修改调度信息
			if (targetType.toUpperCase().equals("SCOPE")) {
				String infoSql = "";
				String __sql="select count(1) from proc_schedule_info where proc_name = '" + target + "'";
				int count = jdbc.queryForObject(__sql, Integer.class);
				if (count>0) {
					infoSql = "UPDATE proc_schedule_info a SET a.pri_level=(SELECT priority FROM kpi_scope_def WHERE kpi_scope_code = a.proc_name) WHERE a.proc_name = '"
							+ target + "'";
				} else {
					infoSql = "INSERT INTO proc_schedule_info (proc_name,run_freq,pri_level) SELECT kpi_scope_code,cycle,priority FROM kpi_scope_def WHERE kpi_scope_code = '"
							+ target + "'";
				}
				jdbc.execute(infoSql);
			}
			returnRes.put("response", "数据更新成功！");
			returnRes.put("flag", "true");
		} catch (Exception e) {
			returnRes.put("response", e.getMessage().toString());
			returnRes.put("flag", "false");
		} finally {
			out.write(gson.toJson(returnRes));
		}

	}
	
	public String getSourceFreq(String source,String sourceType,JdbcTemplate jdbc){
		String sql="";
		if(sourceType.toLowerCase()=="proc"){
			sql="SELECT cycletype FROM proc ";
		}
		if(sql.length()==0){
			return null;
		}else{
			Map<String,Object> obj = jdbc.queryForMap(sql);
			String cycle = obj.get(1).toString();
			String freq = (cycle==null||cycle.length()==0)?null:cycle.substring(0,1).toUpperCase()+"-0";
			return freq;
		}
	}
	
	/**
	 * agent前台启停服务
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/control/agent/{opType}")
	public @ResponseBody Object AgentControl(@PathVariable String opType, HttpServletRequest request, HttpServletResponse response) {
		BaseResult result = new BaseResult();
		String sql="";
		
		String code = request.getParameter("code")==null?"":request.getParameter("code");

		if (StringUtils.isEmpty(code)) {
			result.setReCode(400);
			result.setReMsg("缺少参数code");
		} else {
			try {
				//sql="select agent_code,agent_name,node_ip,node_user,node_pwd,node_status,status_time,deploy_path from proc_schedule_agent where agent_code='"+code+"'";
				sql="select b.ipaddr,b.user_name,b.password,b.port,b.login_type,a.script_path,a.node_status from aietl_agentnode a left join dp_host_config b on a.host_name = b.host_name where a.agent_name='"+code+"'";

				List<Map<String, Object>> list = jts.queryForList(sql);
				if (list == null || list.isEmpty()) {
					result.setReCode(400);
					result.setReMsg("找不到code为" + code + "的agent");
				}else{
					String ip = list.get(0).get("ipaddr").toString();
					String user = list.get(0).get("user_name").toString();
					// String pwd=AesCipher.decrypt(list.get(0).get("password").toString());
					String pwd = DesCipher.decrypt(list.get(0).get("password").toString(), null);
					String path = list.get(0).get("script_path").toString();
					
					if(opType.equals("start") || opType.equals("stop")){
						path = path.endsWith("/") ? path : path + "/";
						String cmd = "cd " + path + "bin \n sh " + opType + "-" + code + ".sh \n";//&& sh checkAgent.sh " + code + "  \n";
						log.info(cmd);
						int shell = this.sshShell(ip, user, pwd, -1, null, null, cmd);
						if (shell == 1) {
							result.setReCode(200);
							result.setReMsg("已检测到" + code + "后台进程");
						} else if (shell == 0) {
							result.setReCode(200);
							result.setReMsg("已检测不到" + code + "后台进程");
						}else {
							result.setReCode(400);
							result.setReMsg(stdout);
						}
						
					}else{
						result.setReCode(300);
						result.setReMsg("未知的操作：" + opType);
					}
				}
				
			}catch(JSchException e){
				result.setReCode(400);
				result.setReMsg("连接拒绝，请检测配置ip，用户，密码！");
				e.getStackTrace();
				log.error(e.getMessage());
			}catch (Exception e) {
				result.setReCode(400);
				result.setReMsg(e.getMessage());
				e.getStackTrace();
				log.error(e.getMessage());
			}
		}
		return result;
	}
	
	
	/**
	 * server前台启停服务
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/control/server/{opType}")
	public @ResponseBody Object ServerControl(@PathVariable String opType, HttpServletRequest request, HttpServletResponse response) {
		BaseResult result = new BaseResult();
		String sql="";
		
		String code = request.getParameter("code")==null?"":request.getParameter("code");

		if (StringUtils.isEmpty(code)) {
			result.setReCode(400);
			result.setReMsg("缺少参数code");
		} else {
			try {
				//sql="select server_code,server_name,node_ip,node_user,node_pwd,node_status,status_time,deploy_path,send_flag,remark from proc_schedule_server where server_code='"+code+"'";
				sql="select b.ipaddr,b.user_name,b.password,b.port,b.login_type,a.deploy_path,a.server_id,a.server_status from aietl_servernode a left join dp_host_config b on a.host_name = b.host_name where a.server_id='"+code+"'";

				List<Map<String, Object>> list = jts.queryForList(sql);
				if (list == null || list.isEmpty()) {
					result.setReCode(400);
					result.setReMsg("找不到code为" + code + "的server");
				}else{
					String serverId = list.get(0).get("server_id").toString();
					String ip = list.get(0).get("ipaddr").toString();
					String user = list.get(0).get("user_name").toString();
					// String pwd=AesCipher.decrypt(list.get(0).get("password").toString());
					String pwd = DesCipher.decrypt(list.get(0).get("password").toString(), null);
					String path = list.get(0).get("deploy_path").toString();
					
					if(opType.equals("start") || opType.equals("stop")){
						path = path.endsWith("/") ? path : path + "/";
						String cmd = "cd " + path + "bin \n sh " + opType + "Server.sh " + serverId + " \n";
						//String cmd = "cd " + path + "bin \n sh " + opType + "Server.sh \n";
						log.info(cmd);
						int shell = this.sshShell(ip, user, pwd, -1, null, null, cmd);
						if (shell == 1) {
							result.setReCode(200);
							result.setReMsg("已检测到" + code + "后台进程");
						} else if (shell == 0) {
							result.setReCode(200);
							result.setReMsg("已检测不到" + code + "后台进程");
						}else {
							result.setReCode(400);
							result.setReMsg(stdout);
						}
						
					}else{
						result.setReCode(300);
						result.setReMsg("未知的操作：" + opType);
					}
				}
				
			}catch(JSchException e){
				result.setReCode(400);
				result.setReMsg("连接拒绝，请检测配置ip，用户，密码！");
				e.getStackTrace();
				log.error(e.getMessage());
			}catch (Exception e) {
				result.setReCode(400);
				result.setReMsg(e.getMessage());
				e.getStackTrace();
				log.error(e.getMessage());
			}
		}
		return result;
	}
	
	
	/**
	 * ssh远程执行shell命令
	 * @param ip 远程ip
	 * @param user 远程用户
	 * @param pwd 用户密码
	 * @param port 端口，-1，默认端口
	 * @param privateKey null
	 * @param passphrase null
	 * @param shell 命令
	 * @return
	 * @throws Exception
	 */
	public int sshShell(String ip, String user, String pwd, int port, String privateKey, String passphrase, String shell) throws Exception {
		int resVal=0;
		Session session = null;
		Channel channel = null;
	    String temp = null;

		JSch jsch = new JSch();

		// 设置密钥和密码
		if (privateKey != null && !"".equals(privateKey)) {
			if (passphrase != null && "".equals(passphrase)) {
				// 设置带口令的密钥
				jsch.addIdentity(privateKey, passphrase);
			} else {
				// 设置不带口令的密钥
				jsch.addIdentity(privateKey);
			}
		}

		if (port <= 0) {
			// 连接服务器，采用默认端口
			session = jsch.getSession(user, ip);
		} else {
			// 采用指定的端口连接服务器
			session = jsch.getSession(user, ip, port);
		}

		// 如果服务器连接不上，则抛出异常
		if (session == null) {
			throw new Exception("session is null");
		}

		// 设置登陆主机的密码
		session.setPassword(pwd);// 设置密码
		// 设置第一次登陆的时候提示，可选值：(ask | yes | no)
		session.setConfig("StrictHostKeyChecking", "no");
		// 设置登陆超时时间
		session.connect(300000);

		try {
			//创建sftp通信通道
	        channel = (Channel) session.openChannel("shell");
	        channel.connect(4000);
	 
	        //获取输入流和输出流
	        InputStream instream = channel.getInputStream();
	        OutputStream outstream = channel.getOutputStream();
	         
	        //发送需要执行的SHELL命令，需要用\n结尾，表示回车
	        outstream.write(shell.getBytes());
	        outstream.flush();
	        //睡眠3s等待返回
	        Thread.sleep(3000L);
	 
	        //获取命令执行的结果
	        if (instream.available() > 0) {
	            byte[] data = new byte[instream.available()];
	            int nLen = instream.read(data);
	             
	            if (nLen < 0) {
	                throw new Exception("network error.");
	            }
	             
	            //转换输出结果并打印出来
	            temp = new String(data, 0, nLen,"UTF-8");
	        }
	        outstream.close();
	        instream.close();
	        
			if (temp.contains("proccess exists")) {
				resVal = 1;
			} else if (temp.contains("proccess does not exist")) {
				resVal = 0;
			} else {
				stdout = "请检测部署路径！";//temp;
				resVal = -1;
			}

		} catch (Exception e) {
			stdout = e.getMessage();
			log.error("",e);
			resVal = -1;
		} finally {
			channel.disconnect();
			session.disconnect();
		}
		return resVal;
	}
	
	@RequestMapping(value = "/test")
	public void test(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		JdbcTemplate jdbc = new JdbcTemplate("METADB");
		String sql="select count(1) from kpi_schedule_info where kpi_scope_code = 'AcctIttemD_Org'";
		int a = jdbc.queryForObject(sql, Integer.class);;
		System.out.println(a);
	}
}
