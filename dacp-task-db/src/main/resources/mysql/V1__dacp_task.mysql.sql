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
/*Table structure for table `aietl_agentnode` */

REATE TABLE `proc` (
  `XMLID` varchar(32) NOT NULL,
  `PROC_NAME` varchar(200) NOT NULL DEFAULT '',
  `INTERCODE` varchar(20) DEFAULT NULL,
  `PROCCNNAME` varchar(120) DEFAULT NULL,
  `INORFULL` varchar(4) DEFAULT NULL,
  `CYCLETYPE` varchar(60) DEFAULT NULL,
  `TOPICNAME` varchar(60) DEFAULT NULL,
  `STARTDATE` varchar(16) DEFAULT NULL,
  `STARTTIME` time DEFAULT NULL,
  `ENDTIME` time DEFAULT NULL,
  `PARENTPROC` varchar(32) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `EFF_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CREATER` varchar(32) DEFAULT NULL,
  `STATE` varchar(32) DEFAULT NULL,
  `STATE_DATE` timestamp NULL DEFAULT NULL,
  `PROCTYPE` varchar(32) DEFAULT NULL,
  `PATH` varchar(200) DEFAULT NULL,
  `RUNMODE` varchar(32) DEFAULT NULL,
  `DBNAME` varchar(32) DEFAULT NULL,
  `DBUSER` varchar(32) DEFAULT NULL,
  `CURTASKCODE` varchar(32) DEFAULT NULL,
  `DESIGNER` varchar(32) DEFAULT NULL,
  `EXTEND_CFG` varchar(2048) DEFAULT NULL,
  `AUDITER` varchar(32) DEFAULT NULL,
  `DEPLOYER` varchar(32) DEFAULT NULL,
  `RUNPARA` varchar(300) DEFAULT NULL,
  `RUNDURA` varchar(32) DEFAULT NULL,
  `TEAM_CODE` varchar(32) DEFAULT NULL,
  `DEVELOPER` varchar(32) DEFAULT NULL,
  `CURDUTYER` varchar(32) DEFAULT NULL,
  `VERSEQ` int(11) DEFAULT NULL,
  `LEVEL_VAL` varchar(32) DEFAULT NULL,
  `AREACODE` varchar(16) DEFAULT NULL,
  `TOPICCODE` varchar(32) DEFAULT NULL,
  `XML` longtext,
  PRIMARY KEY (`XMLID`,`PROC_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8




DROP TABLE IF EXISTS `aietl_agentnode`;

CREATE TABLE `aietl_agentnode` (
  `AGENT_ID` smallint(6) DEFAULT '-1',
  `AGENT_NAME` varchar(50) DEFAULT NULL,
  `TASK_TYPE` varchar(10) DEFAULT NULL,
  `NODE_IP` varchar(50) DEFAULT NULL,
  `NODE_TCP_PORT` int(11) DEFAULT NULL,
  `NODE_UDP_PORT` int(11) DEFAULT NULL,
  `NODE_STATUS` int(11) DEFAULT NULL,
  `STATUS_CHGTIME` varchar(20) DEFAULT NULL,
  `HOST_NAME` varchar(100) DEFAULT NULL,
  `IPS` smallint(100) DEFAULT NULL,
  `CURIPS` smallint(6) DEFAULT '0',
  `IPS_WEIGHT` smallint(6) DEFAULT '0',
  `SCRIPT_PATH` varchar(128) DEFAULT NULL,
  `PLATFORM` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `aietl_servernode` */

DROP TABLE IF EXISTS `aietl_servernode`;

CREATE TABLE `aietl_servernode` (
  `server_id` varchar(250) DEFAULT NULL,
  `host_name` varchar(100) DEFAULT NULL COMMENT '关联dp_host_config表host_name',
  `deploy_path` varchar(128) DEFAULT NULL,
  `server_status` int(11) DEFAULT NULL,
  `status_time` varchar(20) DEFAULT NULL,
  `api_port` int(22) NOT NULL COMMENT 'jetty端口'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='server状态监控日志表'

/*Table structure for table `dp_host_config` */

DROP TABLE IF EXISTS `dp_host_config`;

CREATE TABLE `dp_host_config` (
  `host_name` varchar(64) NOT NULL,
  `hostcnname` varchar(32) DEFAULT NULL,
  `login_type` varchar(32) DEFAULT NULL,
  `ipaddr` varchar(32) DEFAULT NULL,
  `port` varchar(16) DEFAULT NULL,
  `chartset` varchar(16) DEFAULT NULL,
  `workdir` varchar(64) DEFAULT NULL,
  `user_name` varchar(32) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `op_user` varchar(64) DEFAULT NULL,
  `op_time` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `job_command` */

DROP TABLE IF EXISTS `job_command`;

CREATE TABLE `job_command` (
  `id` varchar(32) NOT NULL,
  `JOB_COMMAND` varchar(255) DEFAULT NULL,
  `JOB_INSTRUCTION` varchar(255) DEFAULT NULL,
  `job_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_dim` */

DROP TABLE IF EXISTS `proc_schedule_dim`;

CREATE TABLE `proc_schedule_dim` (
  `XMLID` varchar(32) NOT NULL,
  `DIM_GROUP_ID` varchar(64) DEFAULT NULL COMMENT '关联proc_schedule_dim_group表XMLID',
  `DIM_CODE` varchar(64) DEFAULT NULL,
  `DIM_VALUE` varchar(128) DEFAULT NULL,
  `DIM_SEQ` int(6) DEFAULT NULL,
  `REMARK` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`XMLID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度系统维表';

/*Table structure for table `proc_schedule_dim_group` */

DROP TABLE IF EXISTS `proc_schedule_dim_group`;

CREATE TABLE `proc_schedule_dim_group` (
  `XMLID` varchar(32) NOT NULL,
  `GROUP_CODE` varchar(64) DEFAULT NULL,
  `GROUP_VALUE` varchar(128) DEFAULT NULL,
  `GROUP_SEQ` int(6) DEFAULT NULL,
  `REMARK` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`XMLID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_info` */

DROP TABLE IF EXISTS `proc_schedule_info`;

CREATE TABLE `proc_schedule_info` (
  `XMLID` varchar(100) NOT NULL,
  `PROC_NAME` varchar(200) DEFAULT NULL COMMENT '程序名',
  `AGENT_CODE` varchar(32) DEFAULT NULL,
  `TRIGGER_TYPE` int(11) DEFAULT NULL,
  `RUN_FREQ` varchar(32) DEFAULT NULL,
  `ST_DAY` varchar(20) DEFAULT NULL,
  `ST_TIME` varchar(20) DEFAULT NULL,
  `CRON_EXP` varchar(32) DEFAULT NULL,
  `PROC_GROUP` varchar(32) DEFAULT NULL,
  `PRI_LEVEL` int(11) DEFAULT NULL COMMENT '程序优先级：1~20',
  `PLATFORM` varchar(32) DEFAULT NULL COMMENT 'Agent组/接入平台',
  `RESOUCE_LEVEL` int(11) DEFAULT NULL,
  `REDO_NUM` int(11) DEFAULT NULL COMMENT '大于或等于0',
  `ALARM_CLASS` varchar(32) DEFAULT NULL COMMENT '0/1【短信/电话】',
  `EXEC_CLASS` varchar(32) DEFAULT NULL,
  `DATE_ARGS` varchar(32) DEFAULT NULL,
  `MUTI_RUN_FLAG` int(11) DEFAULT NULL,
  `DURA_MAX` int(11) DEFAULT NULL,
  `EFF_TIME` varchar(20) DEFAULT NULL,
  `EXP_TIME` varchar(20) DEFAULT NULL,
  `ON_FOCUS` int(11) DEFAULT NULL,
  `REDO_INTERVAL` int(11) DEFAULT NULL,
  `ALLOW_EXEC_TIME` varchar(20) DEFAULT NULL,
  `TIME_WIN` varchar(8) DEFAULT NULL,
  `FLOWCODE` varchar(32) DEFAULT 'DEFAULT_FLOW',
  `MAX_RUN_HOURS` int(6) DEFAULT NULL COMMENT '任务最长运行时间',
  `EXEC_PROC` varchar(200) DEFAULT NULL COMMENT '运行程序',
  `PROC_TYPE` varchar(32) DEFAULT NULL COMMENT '任务类型',
  `EXEC_PATH` varchar(200) DEFAULT NULL COMMENT '执行路径',
  `PRE_CMD` varchar(200) DEFAULT NULL COMMENT '命令前缀',
  `ONOFF` int(11) DEFAULT NULL COMMENT '沈阳用，任务开关',
  `task_group` varchar(200) DEFAULT NULL COMMENT '任务分组',
  `task_group_name` varchar(500) DEFAULT NULL COMMENT '任务分组显示名称',
  PRIMARY KEY (`XMLID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='程序调度信息表';

/*Table structure for table `proc_schedule_log` */

DROP TABLE IF EXISTS `proc_schedule_log`;

CREATE TABLE `proc_schedule_log` (
  `seqno` varchar(50) DEFAULT NULL,
  `xmlid` varchar(32) DEFAULT NULL,
  `agent_code` varchar(32) DEFAULT NULL,
  `run_freq` varchar(10) DEFAULT NULL,
  `proc_name` varchar(200) DEFAULT NULL,
  `flowcode` varchar(500) DEFAULT NULL,
  `platform` varchar(20) DEFAULT NULL,
  `task_state` smallint(6) DEFAULT NULL,
  `status_time` varchar(20) DEFAULT NULL,
  `start_time` varchar(20) DEFAULT NULL,
  `exec_time` varchar(20) DEFAULT NULL,
  `end_time` varchar(20) DEFAULT NULL,
  `use_time` varchar(20) DEFAULT NULL,
  `retrynum` smallint(6) DEFAULT NULL,
  `errcode` smallint(6) DEFAULT NULL,
  `proc_date` varchar(20) DEFAULT NULL,
  `alarm_flag` int(6) DEFAULT '0',
  `date_args` varchar(20) DEFAULT NULL,
  `queue_flag` smallint(6) DEFAULT '0',
  `trigger_flag` smallint(6) DEFAULT '0',
  `pri_level` smallint(6) DEFAULT '1',
  `pid` varchar(10) DEFAULT NULL,
  `team_code` varchar(32) DEFAULT NULL,
  `time_win` varchar(20) DEFAULT NULL,
  `path` varchar(300) DEFAULT NULL,
  `runpara` varchar(300) DEFAULT NULL,
  `proctype` varchar(32) DEFAULT NULL,
  `VALID_FLAG` int(11) DEFAULT NULL COMMENT '0 有效 1失效',
  `RETURN_CODE` int(11) DEFAULT NULL COMMENT 'dp任务步骤返回号',
  `PRE_CMD` varchar(200) DEFAULT NULL COMMENT '命令前缀',
  KEY `idx_seqno` (`seqno`),
  KEY `idx_proc_name_date_args` (`proc_name`,`date_args`),
  KEY `IDX_TASK_PSL_1` (`queue_flag`,`VALID_FLAG`),
  KEY `IDX_TASK_PSL_2` (`task_state`,`VALID_FLAG`),
  KEY `IDX_TASK_PSL_3` (`seqno`),
  KEY `IDX_TASK_PSL_4` (`xmlid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_meta_log` */

DROP TABLE IF EXISTS `proc_schedule_meta_log`;

CREATE TABLE `proc_schedule_meta_log` (
  `seqno` varchar(50) DEFAULT NULL,
  `proc_name` varchar(200) DEFAULT NULL,
  `date_args` varchar(20) DEFAULT NULL,
  `flowcode` varchar(500) DEFAULT NULL,
  `proc_date` varchar(20) DEFAULT NULL,
  `target` varchar(50) DEFAULT NULL,
  `data_time` varchar(20) DEFAULT NULL,
  `trigger_flag` smallint(6) DEFAULT '0',
  `generate_time` varchar(20) DEFAULT NULL,
  `need_dq_check` smallint(1) DEFAULT '0',
  `dq_check_res` smallint(1) DEFAULT '1',
  KEY `idx_target_datatime` (`target`,`data_time`),
  KEY `IDX_TASK_PSML_1` (`target`,`data_time`),
  KEY `IDX_TASK_PSML_2` (`proc_name`,`date_args`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_platform` */

DROP TABLE IF EXISTS `proc_schedule_platform`;

CREATE TABLE `proc_schedule_platform` (
  `platform` varchar(32) DEFAULT NULL,
  `platform_cnname` varchar(32) DEFAULT NULL,
  `ips` smallint(6) DEFAULT NULL,
  `curips` smallint(6) DEFAULT NULL,
  `team_code` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_runpara` */

DROP TABLE IF EXISTS `proc_schedule_runpara`;

CREATE TABLE `proc_schedule_runpara` (
  `xmlid` varchar(100) DEFAULT NULL,
  `orderid` int(11) DEFAULT NULL,
  `run_para` varchar(100) DEFAULT NULL,
  `run_para_value` varchar(100) DEFAULT NULL,
  KEY `IDX_TASK_PSR_1` (`xmlid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度运行参数表，存放调度任务需要的运行程序参数。';

/*Table structure for table `proc_schedule_script_log` */

DROP TABLE IF EXISTS `proc_schedule_script_log`;

CREATE TABLE `proc_schedule_script_log` (
  `seqno` varchar(50) DEFAULT NULL,
  `generate_time` varchar(200) DEFAULT NULL,
  `app_log` longtext,
  KEY `idx_seqno` (`seqno`),
  KEY `IDX_TASK_PSSCL_1` (`seqno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_source_log` */

DROP TABLE IF EXISTS `proc_schedule_source_log`;

CREATE TABLE `proc_schedule_source_log` (
  `seqno` varchar(50) DEFAULT NULL,
  `proc_name` varchar(200) DEFAULT NULL,
  `date_args` varchar(20) DEFAULT NULL,
  `flowcode` varchar(500) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `source_type` varchar(10) DEFAULT NULL,
  `data_time` varchar(20) DEFAULT NULL,
  `check_flag` smallint(6) DEFAULT '0',
  KEY `idx_seqno` (`seqno`),
  KEY `idx_source` (`source`),
  KEY `IDX_TASK_PSSL_1` (`seqno`,`check_flag`),
  KEY `IDX_TASK_PSSL_2` (`seqno`,`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_target_log` */

DROP TABLE IF EXISTS `proc_schedule_target_log`;

CREATE TABLE `proc_schedule_target_log` (
  `seqno` varchar(50) DEFAULT NULL,
  `proc_name` varchar(200) DEFAULT NULL,
  `date_args` varchar(20) DEFAULT NULL,
  `flowcode` varchar(500) DEFAULT NULL,
  `proc_date` varchar(20) DEFAULT NULL,
  `target` varchar(50) DEFAULT NULL,
  `data_time` varchar(20) DEFAULT NULL,
  `trigger_flag` smallint(6) DEFAULT '0',
  `generate_time` varchar(20) DEFAULT NULL,
  `need_dq_check` smallint(1) DEFAULT '0',
  `dq_check_res` smallint(1) DEFAULT '1',
  KEY `IDX_TASK_PSTL_1` (`trigger_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `proc_schedule_theme` */

DROP TABLE IF EXISTS `proc_schedule_theme`;

CREATE TABLE `proc_schedule_theme` (
  `ID` varchar(64) NOT NULL,
  `PID` varchar(64) DEFAULT NULL,
  `THEME_NAME` varchar(128) DEFAULT NULL,
  `SORT_NO` int(11) DEFAULT NULL,
  `ON_FOCUS` varchar(2) DEFAULT NULL,
  `NOTE` varchar(128) DEFAULT NULL,
  `VALID_FLAG` varchar(2) DEFAULT NULL,
  `AVG_USE_TIME` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度主题层次表';

/*Table structure for table `schedule_task_global_val` */

DROP TABLE IF EXISTS `schedule_task_global_val`;

CREATE TABLE `schedule_task_global_val` (
  `id` varchar(32) DEFAULT NULL,
  `var_name` varchar(255) DEFAULT NULL COMMENT '变量名称',
  `var_type` varchar(20) DEFAULT NULL COMMENT '变量类型',
  `var_value` varchar(255) DEFAULT NULL COMMENT '变量值',
  `memo` text COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `schedule_task_premisstion` */

DROP TABLE IF EXISTS `schedule_task_premisstion`;

CREATE TABLE `schedule_task_premisstion` (
  `run_freq` varchar(12) DEFAULT NULL,
  `date_args` varchar(24) DEFAULT NULL,
  `task_num` int(10) unsigned DEFAULT '0',
  `succ_num` int(10) unsigned DEFAULT '0',
  `fail_num` int(10) unsigned DEFAULT '0',
  `running_num` int(11) DEFAULT '0',
  `other_num` int(11) DEFAULT '0',
  `run_flag` int(11) DEFAULT '1',
  `stat_time` varchar(24) DEFAULT NULL,
  `oper_time` varchar(24) DEFAULT NULL,
  `user_name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `transdatamap_design` */

DROP TABLE IF EXISTS `transdatamap_design`;

CREATE TABLE `transdatamap_design` (
  `XMLID` varchar(64) NOT NULL,
  `FLOWCODE` varchar(500) DEFAULT 'DEFAULT_FLOW',
  `transname` varchar(200) DEFAULT NULL,
  `SOURCE` varchar(120) DEFAULT NULL,
  `SOURCETYPE` varchar(10) DEFAULT NULL,
  `SOURCEFREQ` varchar(20) DEFAULT NULL,
  `SOURCE_APPOINT` varchar(100) DEFAULT NULL,
  `TARGET` varchar(120) DEFAULT NULL,
  `TARGETTYPE` varchar(10) DEFAULT NULL,
  `TARGETFREQ` varchar(20) DEFAULT NULL,
  `NEED_DQ_CHECK` smallint(1) DEFAULT NULL,
  PRIMARY KEY (`XMLID`),
  KEY `IDX_TASK_TP_1` (`transname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `schedule_op_log`;

CREATE TABLE `schedule_op_log` (
  `xmlid` varchar(32) NOT NULL DEFAULT '',
  `proc_name` varchar(200) NOT NULL DEFAULT '',
  `team_code` varchar(32) DEFAULT NULL,
  `user` varchar(50) DEFAULT NULL,
  `user_ip` varchar(50) DEFAULT NULL,
  `op_type` smallint(2) COMMENT '0重做当前,1重做后续,2强制通过,3强制执行',
  `op_time` TIMESTAMP DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='调度人工干预日志表';


CREATE TABLE `proc_schedule_run_index` (
   MONTH_ID VARCHAR(10),
   TEAM_CODE varchar(32),
  `xmlid` VARCHAR(32),
  `PROC_NAME` VARCHAR(200) DEFAULT NULL COMMENT '程序名',
  `RUN_FREQ` varchar(32) DEFAULT NULL,
  `index_type` SMALLINT(1) COMMENT '0 平均开始时间,1 平均结束时间,2 平均耗时',
  `index_value` VARCHAR(200) DEFAULT NULL,
  `index_offset` VARCHAR(100) DEFAULT NULL,
  `update_time` VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (`XMLID`,`index_type`,`MONTH_ID`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


CREATE TABLE `proc_schedule_statistics` (
   DATE_ID VARCHAR(10),
   TEAM_CODE VARCHAR(32),
   TOTAL_NUM BIGINT(20),
   SUC_NUM BIGINT(20),
   FAIL_NUM BIGINT(20),
   OTHER_NUM BIGINT(20),
  `update_time` VARCHAR(20) DEFAULT NULL,
  PRIMARY KEY (`DATE_ID`,`TEAM_CODE`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
