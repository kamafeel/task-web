package com.asiainfo.dacp.dp.syn;

import com.asiainfo.dacp.crypto.cipher.DesCipher;
import com.asiainfo.dacp.dp.message.DpMessage;
import com.asiainfo.dacp.dp.message.DpSender;
import com.asiainfo.dacp.jdbc.JdbcTemplate;

import com.google.gson.Gson;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import net.sf.json.JSONObject;

import org.apache.commons.vfs.FileObject;
import org.apache.commons.vfs.FileSystemManager;
import org.apache.commons.vfs.FileSystemOptions;
import org.apache.commons.vfs.VFS;
import org.apache.commons.vfs.impl.StandardFileSystemManager;
import org.apache.commons.vfs.provider.UriParser;
import org.apache.commons.vfs.provider.sftp.SftpFileSystemConfigBuilder;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;

import org.springframework.util.StringUtils;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Writer;

import java.net.URI;

import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/syn")
public class DpSynController {
    @Autowired
    private DpSender dpSender;
    private String ShellMsg = null;

    @RequestMapping("/kill")
    @ResponseBody
    public void killProcess(HttpServletRequest request,
        HttpServletResponse response, Writer writer) throws IOException {
        String synType = request.getParameter("SYN_TYPE"); // syntype
        String seqno = request.getParameter("SEQNO"); // seqno
        String agentCode = request.getParameter("AGENT_CODE"); // agent_code
        Writer out = response.getWriter();
        Gson gson = new Gson();
        Map<String, String> returnRes = new HashMap<String, String>();

        if (StringUtils.isEmpty(synType) || StringUtils.isEmpty(seqno) ||
                StringUtils.isEmpty(agentCode)) {
            returnRes.put("response", "the param is error");
            returnRes.put("flag", "false");
            out.write(gson.toJson(returnRes));

            return;
        }

        DpMessage message = new DpMessage();
        Map<String, String> map = new HashMap<String, String>();
        map.put("SEQNO", seqno);
        map.put("AGENT_CODE", agentCode);
        message.setMsgType(synType);
        message.setMsgId(seqno);
        message.setClassUrl("default-url");
        message.setClassMethod("default-method");
        message.setSourceQueue("taskServer");
        message.addBody(map);

        Object delRes = dpSender.sendAndRecieve(agentCode + "_REQUEST_QUEUE",
                message, 1000 * 20);

        if ((delRes != null) && delRes.equals("true")) {
            returnRes.put("response", "kill process success");
            returnRes.put("flag", "true");
        } else {
            returnRes.put("response", "kill process fail");
            returnRes.put("flag", "false");
        }

        out.write(gson.toJson(returnRes));
    }

    /**
     * 获取运行态日�?
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     */
    @RequestMapping("/getLog")
    @ResponseBody
    public void getLog(HttpServletRequest request,
        HttpServletResponse response, Writer writer) throws IOException {
        String seqno = request.getParameter("SEQNO"); // seqno
        String agentCode = request.getParameter("AGENT_CODE"); // agent_code
        String cmd = request.getParameter("CMD");
        String dateArgs = request.getParameter("DATADIR");
        Writer out = response.getWriter();
        Gson gson = new Gson();
        Map<String, String> returnRes = new HashMap<String, String>();

        if (StringUtils.isEmpty(seqno) || StringUtils.isEmpty(agentCode)) {
            returnRes.put("response", "the param is error");
            returnRes.put("flag", "false");
            out.write(gson.toJson(returnRes));

            return;
        }

        if (!StringUtils.hasText(cmd)) {
            cmd = "tail -n ";
        } else {
            cmd = cmd + " ";
        }

        DpMessage message = new DpMessage();
        Map<String, String> map = new HashMap<String, String>();
        map.put("SEQNO", seqno);
        map.put("AGENT_CODE", agentCode);
        map.put("commandLine", cmd);
        message.setMsgType("GET_LOG");
        message.setMsgId(seqno);
        message.setClassUrl("default-url");
        message.setClassMethod("default-method");
        message.setSourceQueue("taskServer");
        message.setDateArgs(dateArgs);
        message.addBody(map);

        Object delRes = dpSender.sendAndRecieve(agentCode + "_REQUEST_QUEUE",
                message, 1000 * 60);

        if (delRes != null) {
            returnRes.put("response", (String) delRes);
            returnRes.put("flag", "true");
        } else {
            returnRes.put("response", "无日�?");
            returnRes.put("flag", "false");
        }

        out.write(gson.toJson(returnRes));
    }

    /**
     * 关闭/启动agent
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     * @throws Exception
     */
    @RequestMapping("/controllAgent")
    @ResponseBody
    public void controllAgent(HttpServletRequest request,
        HttpServletResponse response, Writer writer) throws IOException {
        Map<String, String> map = new HashMap<String, String>();
        JdbcTemplate jdbc = new JdbcTemplate("METADBS");
        String agentCode = (request.getParameter("AGENT_CODE") == null) ? ""
                                                                        : request.getParameter(
                "AGENT_CODE"); // agent_code
        String sql = "select b.ipaddr,b.user_name,b.password,b.port,b.login_type,a.script_path,a.node_status from aietl_agentnode a left join dp_host_config b on a.host_name = b.host_name where a.agent_name='" +
            agentCode + "'";
        List<Map<String, Object>> list = jdbc.queryForList(sql);
        Writer out = response.getWriter();
        Gson gson = new Gson();
        String ip = list.get(0).get("ipaddr").toString();
        String user = list.get(0).get("user_name").toString();

        //String psw=AesCipher.decrypt(list.get(0).get("password").toString());
        String psw = DesCipher.decrypt(list.get(0).get("password").toString(),
                null);
        String path = list.get(0).get("script_path").toString();
        String loginType = list.get(0).get("login_type").toString();
        String status = list.get(0).get("node_status").toString();

        path = path.endsWith("/") ? path : (path + "/");

        String op = status.equalsIgnoreCase("0") ? "start" : "stop";
        String cmd = "cd " + path + "bin \n sh  " + op + "-" + agentCode +
            ".sh \n";

        try {
            if (loginType.equals("ssh")) {
                //ssh方式远程登录agent
                if (this.sshShell(ip, user, psw, -1, null, null, cmd)) {
                    //修改agent状�??
                    String changeType = status.equalsIgnoreCase("0") ? "1" : "0";
                    String updateSql = "update aietl_agentnode set node_status=" +
                        changeType + " where agent_name='" + agentCode + "'";
                    jdbc.execute(updateSql);

                    if (status.equalsIgnoreCase("0")) {
                        map.put("response", "启动AGENT成功");
                    } else {
                        map.put("response", "关闭AGENT成功");
                    }

                    map.put("flag", "true");
                } else {
                    if (ShellMsg.contains("running")) {
                        String updateSql = "update aietl_agentnode set node_status= 1 where agent_name='" +
                            agentCode + "'";
                        jdbc.execute(updateSql);
                        ShellMsg = "进程已启�?";
                    } else if (ShellMsg.contains("stopped")) {
                        String updateSql = "update aietl_agentnode set node_status= 0 where agent_name='" +
                            agentCode + "'";
                        jdbc.execute(updateSql);
                        ShellMsg = "进程已停�?";
                    }

                    map.put("response", ShellMsg);
                    map.put("flag", "false");
                }
            } else {
                map.put("response", "暂不支持" + loginType + "类型登录方式�?");
                map.put("flag", "false");
            }
        } catch (Exception e) {
            map.put("response", "agent操作失败�?" + e.getMessage());
            map.put("flag", "false");
            e.printStackTrace();
        }

        out.write(gson.toJson(map));
    }

    /**
     * 启动/停止SERVER
     * @param request
     * @param response
     * @param writer
     * @throws IOException
     */
    @RequestMapping("/controllServer")
    @ResponseBody
    public void controllServer(HttpServletRequest request,
        HttpServletResponse response, Writer writer) throws IOException {
        Map<String, String> map = new HashMap<String, String>();
        JdbcTemplate jdbc = new JdbcTemplate("METADBS");
        Writer out = response.getWriter();
        Gson gson = new Gson();
        String serverId = (request.getParameter("serverId") == null) ? ""
                                                                     : request.getParameter(
                "serverId"); // serverId
        String sql = "select b.ipaddr,b.user_name,b.password,b.port,b.login_type,a.deploy_path,a.server_id,a.server_status from aietl_servernode a left join dp_host_config b on a.host_name = b.host_name where a.server_id='" +
            serverId + "'";
        List<Map<String, Object>> list = jdbc.queryForList(sql);
        String ip = list.get(0).get("ipaddr").toString();
        String user = list.get(0).get("user_name").toString();

        //		String psw=AesCipher.decrypt(list.get(0).get("login_password").toString());
        String psw = DesCipher.decrypt(list.get(0).get("password").toString(),
                null);
        String path = list.get(0).get("deploy_path").toString();
        String status = list.get(0).get("server_status").toString();
        String loginType = list.get(0).get("login_type").toString();

        path = path.endsWith("/") ? path : (path + "/");

        String startCommand = "cd " + path + "bin \n sh startServer.sh \n";
        String stopCommand = "cd " + path + "bin \n sh stopServer.sh \n";
        String shelllCommand = status.equalsIgnoreCase("-1") ? startCommand
                                                             : stopCommand;

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        String nowStr = sdf.format(calendar.getTime());

        try {
            if (loginType.equals("ssh")) {
                //ssh方式远程登录agent
                if (this.sshShell(ip, user, psw, -1, null, null, shelllCommand)) {
                    //修改agent状�??
                    String changeType = status.equalsIgnoreCase("-1") ? "0" : "-1";
                    String updateSql = "update aietl_servernode set server_status=" +
                        changeType + ",status_time='" + nowStr +
                        "' where server_id='" + serverId + "'";
                    jdbc.execute(updateSql);

                    if (status.equalsIgnoreCase("0")) {
                        map.put("response", "启动Server成功");
                    } else {
                        map.put("response", "关闭Server成功");
                    }

                    map.put("flag", "true");
                } else {
                    if (ShellMsg.contains("running")) {
                        String updateSql = "update aietl_servernode set server_status= 0,status_time='" +
                            nowStr + "' where server_id='" + serverId + "'";
                        jdbc.execute(updateSql);
                        ShellMsg = "进程已存�?";
                    } else if (ShellMsg.contains("stopped")) {
                        String updateSql = "update aietl_servernode set server_status= -1,status_time='" +
                            nowStr + "' where server_id='" + serverId + "'";
                        jdbc.execute(updateSql);
                        ShellMsg = "进程已停�?";
                    }

                    map.put("response", ShellMsg);
                    map.put("flag", "false");
                }
            } else {
                map.put("response", "暂不支持" + loginType + "类型登录方式�?");
                map.put("flag", "false");
            }
        } catch (Exception e) {
            map.put("response", "server操作失败:" + e.getMessage());
            map.put("flag", "false");
            e.printStackTrace();
        }

        out.write(gson.toJson(map));
    }

    /**
     * 利用JSch包实现远程主机SHELL命令执行
     * @param ip 主机IP
     * @param user 主机登陆用户�?
     * @param psw  主机登陆密码
     * @param port 主机ssh2登陆端口，如果取默认值，�?-1
     * @param privateKey 密钥文件路径
     * @param passphrase 密钥的密�?
     */
    public boolean sshShell(String ip, String user, String psw, int port,
        String privateKey, String passphrase, String shell)
        throws Exception {
        Session session = null;
        Channel channel = null;
        String temp = null;

        JSch jsch = new JSch();
        boolean result = false;

        //设置密钥和密�?
        if ((privateKey != null) && !"".equals(privateKey)) {
            if ((passphrase != null) && "".equals(passphrase)) {
                //设置带口令的密钥
                jsch.addIdentity(privateKey, passphrase);
            } else {
                //设置不带口令的密�?
                jsch.addIdentity(privateKey);
            }
        }

        if (port <= 0) {
            //连接服务器，采用默认端口
            session = jsch.getSession(user, ip);
        } else {
            //采用指定的端口连接服务器
            session = jsch.getSession(user, ip, port);
        }

        //如果服务器连接不上，则抛出异�?
        if (session == null) {
            throw new Exception("session is null");
        }

        //设置登陆主机的密�?
        session.setPassword(psw); //设置密码   
                                  //设置第一次登陆的时�?�提示，可�?��?�：(ask | yes | no)

        session.setConfig("StrictHostKeyChecking", "no");
        //设置登陆超时时间   
        session.connect(30000);

        try {
            //创建sftp通信通道
            channel = (Channel) session.openChannel("shell");
            channel.connect(4000);

            //获取输入流和输出�?
            InputStream instream = channel.getInputStream();
            OutputStream outstream = channel.getOutputStream();

            //发�?�需要执行的SHELL命令，需要用\n结尾，表示回�?
            outstream.write(shell.getBytes());
            outstream.flush();
            Thread.sleep(3000L);

            //获取命令执行的结�?
            if (instream.available() > 0) {
                byte[] data = new byte[instream.available()];
                int nLen = instream.read(data);

                if (nLen < 0) {
                    throw new Exception("network error.");
                }

                //转换输出结果并打印出�?
                temp = new String(data, 0, nLen, "UTF-8");
            }

            outstream.close();
            instream.close();

            if (temp.contains("successfully")) {
                result = true;
            } else {
                ShellMsg = temp;
                result = false;
            }
        } catch (Exception e) {
            ShellMsg = e.getMessage();
            result = false;
        } finally {
            session.disconnect();
            channel.disconnect();
        }

        return result;
    }

    @RequestMapping("/getRunningLog")
    @ResponseBody
    public void getRunningLog(HttpServletRequest request,
        HttpServletResponse response, Writer writer) throws IOException {
        String seqno = request.getParameter("SEQNO"); // seqno
        String agentCode = request.getParameter("AGENT_CODE"); // agent_code
        String cmd = request.getParameter("CMD");
        Writer out = response.getWriter();
        Gson gson = new Gson();
        Map<String, String> returnRes = new HashMap<String, String>();

        if (StringUtils.isEmpty(seqno) || StringUtils.isEmpty(agentCode)) {
            returnRes.put("response", "the param is error");
            returnRes.put("flag", "false");
            out.write(gson.toJson(returnRes));

            return;
        }

        if (!StringUtils.hasText(cmd)) {
            cmd = "tail -n ";
        } else {
            cmd = cmd + " ";
        }

        DpMessage message = new DpMessage();
        Map<String, String> map = new HashMap<String, String>();
        map.put("SEQNO", seqno);
        map.put("AGENT_CODE", agentCode);
        map.put("commandLine", cmd);
        message.setMsgType("GET_LOG");
        message.setMsgId(seqno);
        message.setClassUrl("default-url");
        message.setClassMethod("default-method");
        message.setSourceQueue("taskServer");
        message.addBody(map);

        Object delRes = dpSender.sendAndRecieve(agentCode + "_REQUEST_QUEUE",
                message, 1000 * 60);

        if (delRes != null) {
            returnRes.put("response", (String) delRes);
            returnRes.put("flag", "true");
        } else {
            returnRes.put("response", "无日�?");
            returnRes.put("flag", "false");
        }

        out.write(gson.toJson(returnRes));
    }

    /**
     * 获取运行结束日志
     * @param response
     * @param seqno
     * @throws IOException
     */
    @RequestMapping("/getTaskLog/{seqno}")
    @ResponseBody
    public void getTaskLog(HttpServletResponse response,
        @PathVariable
    String seqno) throws IOException {
        Writer out = response.getWriter();
        StandardFileSystemManager vfsmgr = null;

        try {
            FileObject targetfs = null;
            JdbcTemplate jdbc = new JdbcTemplate("METADBS");

            //获取taskLog
            String getTaskLogSql = "select date_args as dateArgs,run_freq runFreq,agent_code as agentCode from proc_schedule_log where seqno='" +
                seqno + "'";
            Map<String, Object> taskLog = jdbc.queryForMap(getTaskLogSql);
            String agentCode = taskLog.get("agentCode").toString();
            String runFreq = taskLog.get("runFreq").toString();
            String dateArgs = taskLog.get("dateArgs").toString();
            String sql = "select user_name as userName ,password as password ,b.SCRIPT_PATH as path,a.ipaddr as ipaddr from dp_host_config a left join aietl_agentnode b on a.host_name=b.host_name  where b.agent_name='" +
                agentCode + "'";
            Map<String, Object> agentNode = jdbc.queryForMap(sql);

            //String targetPath = "sftp://";
            String targetPath = "";

            if (agentNode.containsKey("userName") &&
                    !StringUtils.isEmpty(agentNode.get("userName"))) {
                String path = agentNode.get("path").toString();
                path += ((path.endsWith("/") ? "" : "/") +
                "agent-logs/outlog/");

                //targetPath+=""+agentNode.get("userName")+":"+DesCipher.decrypt(agentNode.get("password").toString())+"@"+agentNode.get("ipaddr")+path+(path.endsWith("/")?"":"/")+"agent-logs/outlog/";
                String userInfo = agentNode.get("userName") + ":" +
                    DesCipher.decrypt(agentNode.get("password").toString());
                //				if(org.apache.commons.lang.StringUtils.equals("month", runFreq)){
                //					dateArgs="month"+dateArgs;
                //				}else if (org.apache.commons.lang.StringUtils.equals("year", runFreq)){
                //					dateArgs="year"+dateArgs;
                //				}else if (org.apache.commons.lang.StringUtils.equals("manual", runFreq)){
                //					dateArgs="manualTask";
                //				}else{
                //					dateArgs=dateArgs.substring(0,10);
                //				}
                dateArgs = dateArgs.substring(0, 10);
                path += (dateArgs + "/" + seqno + ".log");

                URI uri = new URI("sftp", userInfo,
                        agentNode.get("ipaddr").toString(), -1, path, null, null);
                targetPath = uri.toString();
            }

            System.out.println("targetPath:" + targetPath);
            // FileSystemManager vfsmgr = VFS.getManager();
            vfsmgr = new StandardFileSystemManager();
            vfsmgr.init();

            FileSystemOptions opts = new FileSystemOptions();
            SftpFileSystemConfigBuilder.getInstance().setTimeout(opts, 2000000);
            SftpFileSystemConfigBuilder.getInstance()
                                       .setStrictHostKeyChecking(opts, "no");
            targetfs = vfsmgr.resolveFile(targetPath, opts);

            if (!targetfs.exists()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("reCode", "400");
                jsonObject.put("reMsg", "无当前日志信�?");
                out.write(jsonObject.toString());
            }

            if (org.apache.commons.lang.StringUtils.equalsIgnoreCase("file",
                        targetfs.getType().getName())) {
                InputStream in = targetfs.getContent().getInputStream();
                InputStreamReader isr = new InputStreamReader(in);
                BufferedReader bufferedReader = new BufferedReader(isr);
                StringBuffer sb = new StringBuffer();
                String str = "";

                while ((str = bufferedReader.readLine()) != null) {
                    sb.append(new String(str.getBytes(), "utf8") + "\n");
                }

                bufferedReader.close();
                isr.close();
                in.close();

                JSONObject jsonObject = new JSONObject();
                jsonObject.put("reCode", "200");
                jsonObject.put("reMsg", "操作成功");
                jsonObject.put("reInfo", sb.toString());
                out.write(jsonObject.toString());
            }
        } catch (Exception e) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("reCode", "400");
            jsonObject.put("reMsg", "系统错误");
            e.printStackTrace();
            out.write(jsonObject.toString());
        } finally {
            vfsmgr.close();
            vfsmgr = null;
        }
    }

    @RequestMapping("/getMetadbsType")
    public @ResponseBody
    Object getMetaDbType(HttpServletRequest request) throws Exception {
        JdbcTemplate jt = new JdbcTemplate("METADBS");

        return jt.getDatabaseType();
    }

    public static void main(String[] args) throws Exception {
        //		DpSynController d=new DpSynController();
        //		String shell="sh /home/hadoop/dps/dacp-task-server-deploy-1.0.0-SNAPSHOT/bin/stopServer.sh \n";
        //		boolean flag =d.sshShell("192.168.111.130", "hadoop", "hadoop", -1, null, null, shell);
        //		System.out.println(flag);
        //		System.out.println(d.ShellMsg);
        String ll = "sftp://dag:1qaz@WSX@10.78.217.57/app/dag/dacp/dacp-task-agent/dacp-task-agent-2.0.0/agent-logs/outlog/2017-01-03/17010314220018300.log";
        System.out.println(UriParser.encode(ll));
    }
}
