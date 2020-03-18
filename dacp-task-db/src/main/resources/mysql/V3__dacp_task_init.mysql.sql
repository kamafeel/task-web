/* 系统 初始化数据 */
/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 5.7.18 : Database - dacp_task
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Data for the table `proc_schedule_dim` */

insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('05497f74972eac7b34f02ebbcf846e94','caa2bcc8b69964f1f271dd3c595ae838','year','年',1,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('2a69c91094042071e1fab08d41112c04','34c795581b15b1333a1b39843e1de6a9','KPI层','KPI层',NULL,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('556e76f869dbcfdf63794efb6d26e3da','caa2bcc8b69964f1f271dd3c595ae838','minute','分钟',5,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('6291d9d652eeb078f5fc6868533b9f6c','4cf958a1f37e961fa73e9293c757761e','O域','O域',NULL,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('79964f58b4dacf412c23b0ef68ee7fd2','caa2bcc8b69964f1f271dd3c595ae838','hour','小时',4,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('926863e9b34fa61402346d0338614b31','4cf958a1f37e961fa73e9293c757761e','B域','B域',NULL,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('cb116776012439922e8f41b546d47371','caa2bcc8b69964f1f271dd3c595ae838','month','月',2,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('e64abf37d4a29b9322c17645fb8cdd39','caa2bcc8b69964f1f271dd3c595ae838','day','日',3,NULL);
insert  into `proc_schedule_dim`(`XMLID`,`DIM_GROUP_ID`,`DIM_CODE`,`DIM_VALUE`,`DIM_SEQ`,`REMARK`) values ('f29645ccfc0f28c6f609516c794752e0','34c795581b15b1333a1b39843e1de6a9','DW层','DW层',NULL,NULL);

/*Data for the table `proc_schedule_dim_group` */

insert  into `proc_schedule_dim_group`(`XMLID`,`GROUP_CODE`,`GROUP_VALUE`,`GROUP_SEQ`,`REMARK`) values ('34c795581b15b1333a1b39843e1de6a9','LEVEL_TYPE','层次',NULL,'层次');
insert  into `proc_schedule_dim_group`(`XMLID`,`GROUP_CODE`,`GROUP_VALUE`,`GROUP_SEQ`,`REMARK`) values ('4cf958a1f37e961fa73e9293c757761e','TOPIC_TYPE','主题',NULL,'主题');
insert  into `proc_schedule_dim_group`(`XMLID`,`GROUP_CODE`,`GROUP_VALUE`,`GROUP_SEQ`,`REMARK`) values ('caa2bcc8b69964f1f271dd3c595ae838','CYCLE_TYPE','周期类型',NULL,'周期类型');

/*Data for the table `schedule_task_global_val` */

insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('2','day','CONST','${day|yyyy-MM-dd|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('3','yyyy','CONST','${day|yyyy|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('4','MM','CONST','${day|MM|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('5','dd','CONST','${day|dd|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('6','today','CONST','${day|yyyy-MM-dd|1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('7','todayyear','CONST','${day|yyyy|1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('8','todayMM','CONST','${day|MM|1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('9','todaydd','CONST','${day|dd|1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('10','preday','CONST','${day|yyyy-MM-dd|-1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('11','predayyyyy','CONST','${day|yyyy|-1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('12','predayMM','CONST','${day|MM|-1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('13','predaydd','CONST','${day|dd|-1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('14','month','CONST','${month|yyyy-MM|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('15','monthyyyy','CONST','${month|yyyy|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('16','monthMM','CONST','${month|MM|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('17','thismonth','CONST','${month|yyyy-MM|1}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('18','thisyyyy','CONST','${month|yyyy|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('19','thisMM','CONST','${month|MM|0}',NULL);
insert  into `schedule_task_global_val`(`id`,`var_name`,`var_type`,`var_value`,`memo`) values ('20','day_','CONST','${day|yyyyMMdd|0}',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


/*Data for the table `proc_schedule_exe_class` */

insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('1e5368429e1f11e5a1ec28d244996b89','shell','SHELL','com.asiainfo.dacp.execClass.ScheduleExe4Shell','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996b80','tcl','TCL','com.asiainfo.dacp.execClass.ScheduleExe4TCL','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996b81','dp','DP程序','com.asiainfo.dacp.execClass.ScheduleExe4DP','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996b89','hive','HiveSQL','com.asiainfo.dacp.execClass.ScheduleExe4HQL','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996c01','jar','java程序','com.asiainfo.dacp.execClass.ScheduleExe4JAVA','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996c02','mapReduce','hadoop程序','com.asiainfo.dacp.execClass.ScheduleExe4Hadoop','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996c03','python','python程序','com.asiainfo.dacp.execClass.ScheduleExe4Python','run');
insert  into `proc_schedule_exe_class`(`XMLID`,`PROCTYPE`,`PROCTYPE_NAME`,`EXE_CLASS`,`EXE_FUNC`) values ('36f9c37a9e1f11e5a1ec28d244996c04','sql','sql脚本','com.asiainfo.dacp.execClass.ScheduleExe4SQL','run');


insert  into `job_command`(`id`,`JOB_COMMAND`,`JOB_INSTRUCTION`,`job_type`) values ('17010416305310001','sh','dp程序调用go.sh脚本','dp');
insert  into `job_command`(`id`,`JOB_COMMAND`,`JOB_INSTRUCTION`,`job_type`) values ('17011616123510002','sh','shell程序','shell');

INSERT INTO `metamodel` VALUES ('sysmgr', null, '系统管理', null, null, null, null, '12', 'desklist-img1.png', 'ftl/frame/metaframe?modelcode=sysmgr', 'desktop', null, 'desklist-icon1.png', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_06', 'sysmgr', '数据库列表', null, null, null, null, '6', '1', 'ftl/sysmgr/database', null, null, 'fa fa-list-alt text-warning-lter', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_02', 'sysmgr', '系统菜单配置', null, null, null, null, '1', '2', 'ftl/sysmgr/menu', null, null, 'fa fa-puzzle-piece text-success', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_01', 'sysmgr', '系统用户配置', null, null, null, null, '2', '3', 'ftl/sysmgr/user', null, null, 'fa fa-user text-info', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_03', 'sysmgr', '系统角色配置', null, null, null, null, '3', '4', 'ftl/sysmgr/role', null, null, 'fa fa-users text-success', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_04', 'sysmgr', '角色权限管理', null, null, null, null, '4', '5', 'ftl/sysmgr/user_menu_rights', null, null, 'fa fa-users text-success', 'off');
INSERT INTO `metamodel` VALUES ('sysmgr_05', 'sysmgr', '修改密码', null, null, null, null, '7', '6', 'ftl/sysmgr/chang_pwd', null, null, 'fa fa-eye text-warning-dk', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_07', 'sysmgr', '系统加密服务', null, null, null, null, '5', '7', 'ftl/sysmgr/pwdserv', null, null, 'fa fa-eye-slash text-primary', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg', null, '调度配置', null, null, null, null, '2', 'desklist-img2.png', 'ftl/frame/metaframe?modelcode=task_cfg', 'desktop', null, 'desklist-icon2.png', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_02', 'task_cfg', '任务配置', null, null, 'xx', null, '2', null, 'ftl/task/miniProcList', null, null, 'fa fa-user text-info', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_03', 'task_cfg', '数据模型', null, null, null, null, '3', null, 'ftl/task/model_table', null, null, 'fa fa-users text-success', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_04', 'task_cfg', '数据字典', null, null, null, null, '4', null, 'ftl/task/model_dictionary', null, null, 'fa fa-users text-success', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_05', 'task_cfg', 'Agent配置', null, null, null, null, '5', null, 'ftl/task/agentList', null, null, 'fa fa-eye text-warning-dk', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_01', 'task_cfg', '日志周期管理', null, null, null, null, '6', null, 'ftl/task/sysmgr_pwdserv', null, null, 'fa fa-eye-slash text-primary', 'off');
INSERT INTO `metamodel` VALUES ('task_monitor', null, '调度监控', null, null, null, null, '1', 'desklist-img3.png', 'ftl/frame/metaframe?modelcode=task_monitor', 'desktop', null, 'desklist-icon3.png', 'on');
INSERT INTO `metamodel` VALUES ('task_monitor_01', 'task_monitor', '任务监控', null, null, null, null, '1', null, 'task/miniTaskMonitor', null, null, 'fa fa-puzzle-piece text-success', 'on');
INSERT INTO `metamodel` VALUES ('task_monitor_02', 'task_monitor', 'Agent监控', null, null, null, null, '2', null, 'task/miniAgentMonitorList', null, null, 'fa fa-user text-info', 'on');
INSERT INTO `metamodel` VALUES ('task_monitor_03', 'task_monitor', '手工任务', null, null, null, null, '3', null, 'task/manualTask/list', null, null, 'fa fa-user text-info', 'on');
INSERT INTO `metamodel` VALUES ('task_monitor_05', 'task_monitor', '数据监控', null, null, null, null, '3', null, 'ftl/task/dataMonitor', null, null, 'fa fa-user text-info', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_13', 'task_cfg', '主机配置', null, null, null, 'TFMoniteShow', '6', '1', 'ftl/task/miniHostList', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_06', 'task_cfg', '运行参数', null, null, '运行参数', 'TFMoniteShow', '2', '1', 'taskservercfg', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_07', 'task_cfg', '数据源配置', null, null, '数据源配置', 'TFMoniteShow', '2', '1', 'taskdatasource', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_08', 'task_cfg', '远程命令主机', null, null, '远程命令主机', 'TFMoniteShow', '2', '1', 'taskremote', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_09', 'task_cfg', '参数配置', null, null, '参数配置', 'TFMoniteShow', '2', '1', 'taskpara', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_10', 'task_cfg', '告警配置', null, null, '告警配置', 'TFMoniteShow', '2', '1', 'warncfg', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_11', 'task_cfg', '服务列表', null, null, '服务列表', 'TFMoniteShow', '2', '1', 'taskservice', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_cfg_12', 'task_cfg', '操作日志', null, null, '操作日志', 'TFMoniteShow', '2', '1', 'ftl/task/scheduleOpLogList', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_monitor_04', 'task_monitor', '总体监控', null, null, '总体监控', 'TFMoniteShow', '2', '1', 'ftl/overallMonitor', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('task_monitor_06', 'task_monitor', '资源监控', null, null, '资源监控', 'TFMoniteShow', '2', '1', 'ftl/task/resourceMonitor', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('sysmgr_08', 'sysmgr', '系统公告', null, null, null, null, '8', null, 'ftl/sysmgr/notice', null, null, null, 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_14', 'task_cfg', '执行命令配置', null, null, '执行命令配置', 'TFMoniteShow', '2', '1', 'ftl/jobcommand', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_15', 'task_cfg', '任务主题配置', null, null, '任务主题配置', 'TFMoniteShow', '2', '1', 'ftl/task/themeconfig', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_16', 'task_cfg', '告警资源组', null, null, '告警资源组', 'TFMoniteShow', '2', '1', 'ftl/task/alarmManager', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_cfg_17', 'task_cfg', '告警配置', null, null, '告警配置', 'TFMoniteShow', '2', '1', 'ftl/task/procAlarm', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('task_logClean', 'task_cfg', '日志清理', null, null, null, 'TFMoniteShow', '2', '1', 'ftl/task/logClean', 'content', null, 'fa fa-list-alt', 'on');
INSERT INTO `metamodel` VALUES ('processConfig', 'task_cfg', '进程配置', null, null, null, 'TFMoniteShow', '2', '1', '/process/processConfig', 'content', null, 'fa fa-list-alt', 'off');
INSERT INTO `metamodel` VALUES ('processMonitor', 'task_monitor', '进程监控', null, null, null, 'TFMoniteShow', '2', '1', '/process/list', 'content', null, 'fa fa-list-alt', 'off');


INSERT INTO `metapermission` VALUES ('sysmgr', 'SysMgr', '系统管理', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_02', 'SysMgr', '系统模块配置', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_01', 'SysMgr', '数据库列表', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_03', 'SysMgr', '系统用户配置', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_04', 'SysMgr', '系统组列表', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_06', 'SysMgr', '修改密码', null, '2');
INSERT INTO `metapermission` VALUES ('sysmgr_11', 'SysMgr', '密码服务', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg', 'SysMgr', '任务配置', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_01', 'SysMgr', '流程设计', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_02', 'SysMgr', '任务配置(表单)', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_03', 'SysMgr', '数据开发', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_04', 'SysMgr', '上线管理', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_05', 'SysMgr', 'Agent配置', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_06', 'SysMgr', '运行参数', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor', 'SysMgr', '任务配置(表单)', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_01', 'SysMgr', '任务监控', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_02', 'SysMgr', 'Agent监控', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_03', 'SysMgr', '手工任务', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_04', 'SysMgr', '总体监控', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_05', 'SysMgr', '数据监控', null, '2');
INSERT INTO `metapermission` VALUES ('task_monitor_11', 'SysMgr', '数据监控', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_15', 'SysMgr', '任务主题配置', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_16', 'SysMgr', '告警资源组', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_17', 'SysMgr', '告警配置', null, '2');
INSERT INTO `metapermission` VALUES ('task_logClean', 'SysMgr', '日志清理', null, '2');
INSERT INTO `metapermission` VALUES ('task_cfg_14', 'SysMgr', '执行命令配置', null, '2');
INSERT INTO `metapermission` VALUES ('processConfig', 'SysMgr', '进程配置', null, '2');
INSERT INTO `metapermission` VALUES ('processMonitor', 'SysMgr', '进程监控', null, '2');