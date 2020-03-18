
CREATE TABLE transflow_manual (
  FLOWCODE varchar2(500) NOT NULL,
  FLOWNAME varchar2(500) NOT NULL,
  CYCLETYPE varchar2(32) DEFAULT '',
  CREATER varchar2(32) DEFAULT '',
  CREATE_DATE varchar2(32) DEFAULT '',
  STATE varchar2(32) DEFAULT '',
  STATE_DATE date DEFAULT '',
  TEAM_CODE varchar2(32) DEFAULT '',
  XML BLOB,
  REMARK varchar2(3000) DEFAULT ''
);

CREATE TABLE transdatamap_design_manual (
  FLOWCODE varchar2(40) DEFAULT 'DEFAULT_FLOW',
  TRANSNAME varchar2(200) DEFAULT '',
  SOURCE varchar2(120) DEFAULT '',
  SOURCETYPE varchar2(10) DEFAULT '',
  SOURCEFREQ varchar2(20) DEFAULT '',
  SOURCE_APPOINT varchar2(20) DEFAULT '',
  TARGET varchar2(120) DEFAULT '',
  TARGETTYPE varchar2(10) DEFAULT '',
  TARGETFREQ varchar2(20) DEFAULT '',
  NEED_DQ_CHECK NUMBER(1) DEFAULT ''
);
CREATE INDEX IDX_transdatamap_design_manual ON transdatamap_design_manual(FLOWCODE);

CREATE TABLE schedule_task_premisstion (
  run_freq varchar2(12) DEFAULT '',
  date_args varchar2(24) DEFAULT '',
  task_num NUMBER(10) DEFAULT '0',
  succ_num NUMBER(10) DEFAULT '0',
  fail_num NUMBER(10) DEFAULT '0',
  running_num NUMBER(11) DEFAULT '0',
  other_num NUMBER(11) DEFAULT '0',
  run_flag NUMBER(11) DEFAULT '1',
  stat_time varchar2(24) DEFAULT '',
  oper_time varchar2(24) DEFAULT '',
  user_name varchar2(30) DEFAULT ''
);

CREATE TABLE PROC_SCHEDULE_EXE_CLASS
(
   XMLID                varchar2(32) PRIMARY KEY,
   PROCTYPE             varchar2(32),
   PROCTYPE_NAME        varchar2(64),
   EXE_CLASS            varchar2(512),
   EXE_FUNC             varchar2(512)
);


insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('1e5368429e1f11e5a1ec28d244996b89','shell','SHELL','com.asiainfo.dacp.execClass.ScheduleExe4Shell','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996b80','tcl','TCL','com.asiainfo.dacp.execClass.ScheduleExe4TCL','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996b81','dp','DP程序','com.asiainfo.dacp.execClass.ScheduleExe4DP','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996b89','hive','HiveSQL','com.asiainfo.dacp.execClass.ScheduleExe4HQL','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996c01','jar','java程序','com.asiainfo.dacp.execClass.ScheduleExe4JAVA','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996c02','mapReduce','hadoop程序','com.asiainfo.dacp.execClass.ScheduleExe4Hadoop','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996c03','python','python程序','com.asiainfo.dacp.execClass.ScheduleExe4Python','run');
insert into proc_schedule_exe_class (XMLID, PROCTYPE, PROCTYPE_NAME, EXE_CLASS, EXE_FUNC) values('36f9c37a9e1f11e5a1ec28d244996c04','sql','sql脚本','com.asiainfo.dacp.execClass.ScheduleExe4SQL','run');
commit;

CREATE TABLE dp_host_config (
  host_name varchar2(64) NOT NULL,
  hostcnname varchar2(32) DEFAULT '',
  login_type varchar2(32) DEFAULT '',
  ipaddr varchar2(32) DEFAULT '',
  port varchar2(16) DEFAULT '',
  chartset varchar2(16) DEFAULT '',
  workdir varchar2(64) DEFAULT '',
  user_name varchar2(32) DEFAULT '',
  password varchar2(128) DEFAULT '',
  op_user varchar2(64) DEFAULT '',
  op_time varchar2(64) DEFAULT ''
);

CREATE TABLE proc_schedule_dim_group (
  XMLID varchar2(32)  PRIMARY KEY ,
  GROUP_CODE varchar2(64) DEFAULT '',
  GROUP_VALUE varchar2(128) DEFAULT '',
  GROUP_SEQ NUMBER(6) DEFAULT '',
  REMARK varchar2(200) DEFAULT ''
) ;

CREATE TABLE proc_schedule_dim (
  XMLID varchar2(32) PRIMARY KEY ,
  DIM_GROUP_ID varchar2(64) DEFAULT '',
  DIM_CODE varchar2(64) DEFAULT '',
  DIM_VALUE varchar2(128) DEFAULT '',
  DIM_SEQ NUMBER(6) DEFAULT '',
  REMARK varchar2(200) DEFAULT ''
);
COMMENT ON table proc_schedule_dim IS '调度系统维表';
comment on column proc_schedule_dim.DIM_GROUP_ID is '关联proc_schedule_dim_group表XMLID';

CREATE TABLE proc_schedule_runpara (
  xmlid varchar2(100) DEFAULT '',
  orderid NUMBER(11) DEFAULT '',
  run_para varchar2(100) DEFAULT '',
  run_para_value varchar2(100) DEFAULT ''
);
COMMENT ON table PROC_SCHEDULE_RUNPARA IS '调度运行参数表，存放调度任务需要的运行程序参数。';

CREATE TABLE aietl_agentnode (
  AGENT_ID NUMBER(6) DEFAULT '-1',
  AGENT_NAME varchar2(50) DEFAULT '',
  TASK_TYPE varchar2(10) DEFAULT '',
  NODE_IP varchar2(50) DEFAULT '',
  NODE_TCP_PORT NUMBER(11) DEFAULT '',
  NODE_UDP_PORT NUMBER(11) DEFAULT '',
  NODE_STATUS NUMBER(11) DEFAULT '',
  STATUS_CHGTIME varchar2(20) DEFAULT '',
  HOST_NAME varchar2(100) DEFAULT '',
  IPS NUMBER(38) DEFAULT '',
  IPS_WEIGHT NUMBER(6) DEFAULT '',
  CURIPS NUMBER(38) DEFAULT '0',
  SCRIPT_PATH varchar2(128) DEFAULT '',
  PLATFORM varchar2(32) DEFAULT ''
) ;

/*Table structure for table proc */
CREATE TABLE proc (
  XMLID varchar2(32) NOT NULL,
  PROC_NAME varchar2(200) NOT NULL,
  INTERCODE varchar2(20) DEFAULT '',
  PROCCNNAME varchar2(120) DEFAULT '',
  INORFULL varchar2(4) DEFAULT '',
  CYCLETYPE varchar2(60) DEFAULT '',
  TOPICNAME varchar2(60) DEFAULT '',
  STARTDATE varchar2(16) DEFAULT '',
  STARTTIME varchar2(200) DEFAULT '',
  ENDTIME varchar2(200) DEFAULT '',
  PARENTPROC varchar2(32) DEFAULT '',
  REMARK varchar2(255) DEFAULT '',
  EFF_DATE varchar2(200) DEFAULT '',
  CREATER varchar2(32) DEFAULT '',
  STATE varchar2(32) DEFAULT '',
  STATE_DATE varchar2(200) DEFAULT '',
  PROCTYPE varchar2(32) DEFAULT '',
  PATH varchar2(1000) DEFAULT '',
  RUNMODE varchar2(32) DEFAULT '',
  DBNAME varchar2(32) DEFAULT '',
  DBUSER varchar2(32) DEFAULT '',
  CURTASKCODE varchar2(32) DEFAULT '',
  DESIGNER varchar2(32) DEFAULT '',
  EXTEND_CFG varchar2(2048) DEFAULT '',
  AUDITER varchar2(32) DEFAULT '',
  DEPLOYER varchar2(32) DEFAULT '',
  RUNPARA varchar2(300) DEFAULT '',
  RUNDURA varchar2(32) DEFAULT '',
  TEAM_CODE varchar2(32) DEFAULT '',
  DEVELOPER varchar2(32) DEFAULT '',
  CURDUTYER varchar2(32) DEFAULT '',
  VERSEQ NUMBER(11) DEFAULT '',
  LEVEL_VAL varchar2(32) DEFAULT '',
  AREACODE varchar2(16) DEFAULT '',
  TOPICCODE varchar2(32) DEFAULT '',
  XML CLOB
);
alter table proc add constraint PK_PROC primary key(XMLID,PROC_NAME);

/*Table structure for table proc_schedule_info */
CREATE TABLE proc_schedule_info (
  XMLID varchar2(100) PRIMARY KEY ,
  PROC_NAME varchar2(200) DEFAULT '',
  AGENT_CODE varchar2(32) DEFAULT '',
  TRIGGER_TYPE NUMBER(11) DEFAULT '',
  RUN_FREQ varchar2(32) DEFAULT '',
  ST_DAY varchar2(20) DEFAULT '',
  ST_TIME varchar2(20) DEFAULT '',
  CRON_EXP varchar2(32) DEFAULT '',
  PROC_GROUP varchar2(32) DEFAULT '',
  PRI_LEVEL NUMBER(11) DEFAULT '',
  PLATFORM varchar2(32) DEFAULT '',
  RESOUCE_LEVEL NUMBER(11) DEFAULT '',
  REDO_NUM NUMBER(11) DEFAULT '',
  ALARM_CLASS varchar2(32) DEFAULT '',
  EXEC_CLASS varchar2(32) DEFAULT '',
  DATE_ARGS varchar2(32) DEFAULT '',
  MUTI_RUN_FLAG NUMBER(11) DEFAULT '',
  DURA_MAX NUMBER(11) DEFAULT '',
  EFF_TIME varchar2(20) DEFAULT '',
  EXP_TIME varchar2(20) DEFAULT '',
  ON_FOCUS NUMBER(11) DEFAULT '',
  REDO_INTERVAL NUMBER(11) DEFAULT '',
  ALLOW_EXEC_TIME varchar2(20) DEFAULT '',
  TIME_WIN varchar2(8) DEFAULT '',
  FLOWCODE varchar2(32) DEFAULT 'DEFAULT_FLOW',
  MAX_RUN_HOURS NUMBER(6) DEFAULT '',
  EXEC_PROC varchar2(200) DEFAULT '',
  PROC_TYPE varchar2(32) DEFAULT '',
  EXEC_PATH varchar2(200) DEFAULT '',
  PRE_CMD varchar2(200) DEFAULT '',
  ONOFF NUMBER(2) DEFAULT ''
);
COMMENT ON table PROC_SCHEDULE_INFO IS '程序调度信息表';
comment on column PROC_SCHEDULE_INFO.PROC_NAME is '程序名';
comment on column PROC_SCHEDULE_INFO.TRIGGER_TYPE is '0: 时间触发（3~7行字段）\n            1：事件触发\n            如果是事件触发，则不配置st_day,st_time,\n            cron_exp字段\n';
comment on column PROC_SCHEDULE_INFO.RUN_FREQ is '天（day）/月(month)/\n            小时(hour)/分钟(minute)/ 手工(manul)\n';
comment on column PROC_SCHEDULE_INFO.PRI_LEVEL is '程序优先级：1~20';
comment on column PROC_SCHEDULE_INFO.PLATFORM is 'Agent组/接入平台';
comment on column PROC_SCHEDULE_INFO.RESOUCE_LEVEL is '资源级别：高(3)，中(2)，低(1)';
comment on column PROC_SCHEDULE_INFO.REDO_NUM is '大于或等于0';
comment on column PROC_SCHEDULE_INFO.ALARM_CLASS is '0/1【短信/电话】';
comment on column PROC_SCHEDULE_INFO.EXEC_CLASS is '重庆再用/关联proc_func_def_java的FUN_ID字段';
comment on column PROC_SCHEDULE_INFO.DATE_ARGS is '0：顺序启动;1:多重启动;2:唯一启动:3 顺序启动但是不依赖月末最后一天';
comment on column PROC_SCHEDULE_INFO.DURA_MAX is '不为0的整数【重庆在用】\n            单位为分钟/根据运行平均时长加上浮比';
comment on column PROC_SCHEDULE_INFO.EFF_TIME is '（YYYY-MM-DD)';
comment on column PROC_SCHEDULE_INFO.EXP_TIME is '1/0';
comment on column PROC_SCHEDULE_INFO.TIME_WIN is '杭州：最迟完时间\n            重庆：到点执行时间\n ';
comment on column PROC_SCHEDULE_INFO.MAX_RUN_HOURS is '任务最长运行时间';
comment on column PROC_SCHEDULE_INFO.EXEC_PROC is '运行程序';
comment on column PROC_SCHEDULE_INFO.PROC_TYPE is '任务类型';
comment on column PROC_SCHEDULE_INFO.PRE_CMD is '命令前缀';
comment on column PROC_SCHEDULE_INFO.EXEC_PATH is '执行路径';

/*Table structure for table proc_schedule_log */
CREATE TABLE proc_schedule_log (
  seqno varchar2(50) DEFAULT '',
  xmlid varchar2(32) DEFAULT '',
  agent_code varchar2(32) DEFAULT '',
  run_freq varchar2(10) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  flowcode varchar2(500) DEFAULT '',
  platform varchar2(20) DEFAULT '',
  task_state NUMBER(6) DEFAULT '',
  status_time varchar2(20) DEFAULT '',
  start_time varchar2(20) DEFAULT '',
  exec_time varchar2(20) DEFAULT '',
  end_time varchar2(20) DEFAULT '',
  use_time varchar2(20) DEFAULT '',
  retrynum NUMBER(6) DEFAULT '',
  errcode NUMBER(6) DEFAULT '',
  proc_date varchar2(20) DEFAULT '',
  alarm_flag NUMBER(6) DEFAULT '0',
  date_args varchar2(20) DEFAULT '',
  queue_flag NUMBER(6) DEFAULT '0',
  trigger_flag NUMBER(6) DEFAULT '0',
  pri_level NUMBER(6) DEFAULT '1',
  pid varchar2(10) DEFAULT '',
  team_code varchar2(32) DEFAULT '',
  time_win varchar2(20) DEFAULT '',
  path varchar2(300) DEFAULT '',
  runpara varchar2(300) DEFAULT '',
  proctype varchar2(32) DEFAULT '',
  VALID_FLAG NUMBER(11) DEFAULT '',
  PRE_CMD varchar2(200) DEFAULT '',
  RETURN_CODE NUMBER(11) DEFAULT ''
);
CREATE INDEX idx_seqno ON proc_schedule_log(seqno);
CREATE INDEX idx_proc_name_date_args ON proc_schedule_log(proc_name,date_args);
comment on column proc_schedule_log.VALID_FLAG is '0 有效 1失效';
comment on column proc_schedule_log.RETURN_CODE is 'dp任务步骤返回号';

/*Table structure for table proc_schedule_meta_log */
CREATE TABLE proc_schedule_meta_log (
  seqno varchar2(50) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  date_args varchar2(20) DEFAULT '',
  flowcode varchar2(500) DEFAULT '',
  proc_date varchar2(20) DEFAULT '',
  target varchar2(50) DEFAULT '',
  data_time varchar2(20) DEFAULT '',
  trigger_flag NUMBER(6) DEFAULT '0',
  generate_time varchar2(20) DEFAULT '',
  need_dq_check NUMBER(1) DEFAULT '0',
  dq_check_res NUMBER(1) DEFAULT '1'
);
CREATE INDEX idx_target_datatime ON proc_schedule_meta_log(target,data_time);

/*Table structure for table proc_schedule_platform */
CREATE TABLE proc_schedule_platform (
  platform varchar2(32) DEFAULT '',
  platform_cnname varchar2(32) DEFAULT '',
  ips NUMBER(6) DEFAULT '',
  curips NUMBER(6) DEFAULT '',
  team_code varchar2(1000) DEFAULT ''
);

/*Table structure for table proc_schedule_script_log */
CREATE TABLE proc_schedule_script_log (
  seqno varchar2(50) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  flowcode varchar2(500) DEFAULT '',
  date_args varchar2(20) DEFAULT '',
  deal_log varchar2(20) DEFAULT '',
  deal_time varchar2(20) DEFAULT '',
  operator varchar2(20) DEFAULT '',
  app_log CLOB
);
CREATE INDEX idx_schedule_script_log ON proc_schedule_script_log(seqno);

/*Table structure for table proc_schedule_source_log */
CREATE TABLE proc_schedule_source_log (
  seqno varchar2(50) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  date_args varchar2(20) DEFAULT '',
  flowcode varchar2(500) DEFAULT '',
  source varchar2(50) DEFAULT '',
  source_type varchar2(10) DEFAULT '',
  data_time varchar2(20) DEFAULT '',
  check_flag NUMBER(6) DEFAULT '0'
);
CREATE INDEX idx_schedule_source_log_seqno ON proc_schedule_source_log(seqno);
CREATE INDEX idx_schedule_source_log_source ON proc_schedule_source_log(source);

/*Table structure for table proc_schedule_target_log */
CREATE TABLE proc_schedule_target_log (
  seqno varchar2(50) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  date_args varchar2(20) DEFAULT '',
  flowcode varchar2(500) DEFAULT '',
  proc_date varchar2(20) DEFAULT '',
  target varchar2(50) DEFAULT '',
  data_time varchar2(20) DEFAULT '',
  trigger_flag NUMBER(6) DEFAULT '0',
  generate_time varchar2(20) DEFAULT '',
  need_dq_check NUMBER(1) DEFAULT '0',
  dq_check_res NUMBER(1) DEFAULT '1'
);

/*Table structure for table transdatamap_design */
CREATE TABLE transdatamap_design (
  XMLID varchar2(64) PRIMARY KEY,
  FLOWCODE varchar2(500) DEFAULT 'DEFAULT_FLOW',
  transname varchar2(200) DEFAULT '',
  SOURCE varchar2(120) DEFAULT '',
  SOURCETYPE varchar2(10) DEFAULT '',
  SOURCEFREQ varchar2(20) DEFAULT '',
  SOURCE_APPOINT varchar2(100) DEFAULT '',
  TARGET varchar2(120) DEFAULT '',
  TARGETTYPE varchar2(10) DEFAULT '',
  TARGETFREQ varchar2(20) DEFAULT '',
  NEED_DQ_CHECK NUMBER(1) DEFAULT ''
);

CREATE TABLE proc_schedule_alarm_info (
  xmlid varchar2(100) NOT NULL,
  proc_xmlid varchar2(200) DEFAULT '',
  sms_group_id varchar2(64) DEFAULT '',
  alarm_type varchar2(20) DEFAULT '',
  due_time_cron varchar2(20) DEFAULT '',
  offset varchar2(2) DEFAULT '',
  max_send_count varchar2(2) DEFAULT '',
  interval_time varchar2(5) DEFAULT '',
  is_valid varchar2(1) DEFAULT '',
  flag varchar2(1) DEFAULT ''
);
comment on column proc_schedule_alarm_info.xmlid is '主键xmlid';
comment on column proc_schedule_alarm_info.proc_xmlid is '程序xmlid';
comment on column proc_schedule_alarm_info.sms_group_id is '短信用户组';
comment on column proc_schedule_alarm_info.alarm_type is '告警类型';
comment on column proc_schedule_alarm_info.due_time_cron is '告警时间cron表达式';
comment on column proc_schedule_alarm_info.offset is '告警批次偏移量';
comment on column proc_schedule_alarm_info.max_send_count is '最大发送次数';
comment on column proc_schedule_alarm_info.interval_time is '发送时间间隔';
comment on column proc_schedule_alarm_info.is_valid is '告警信息是否生效';
comment on column proc_schedule_alarm_info.flag is '通知server处理：0，未处理｜1，已处理';

/*CREATE TABLE proc_schedule_alarm_log (
  xmlid varchar2(100) DEFAULT '',
  proc_xmlid varchar2(200) DEFAULT '',
  proc_name varchar2(200) NOT NULL,
  proc_date_args varchar2(20) NOT NULL,
  alarm_type varchar2(20) DEFAULT '' ,
  alarm_content CLOB,
  alarm_time varchar2(20) DEFAULT ''
);
comment on column proc_schedule_alarm_log.xmlid is '主键xmlid';
comment on column proc_schedule_alarm_log.proc_xmlid is '程序xmlid';
comment on column proc_schedule_alarm_log.proc_name is '程序名称';
comment on column proc_schedule_alarm_log.proc_date_args is '告警批次';
comment on column proc_schedule_alarm_log.alarm_type is '告警类型';
comment on column proc_schedule_alarm_log.alarm_content is '告警内容';
comment on column proc_schedule_alarm_log.alarm_time is '告警时间';*/
CREATE TABLE proc_schedule_alarm_log (
  seqno varchar2(50) PRIMARY KEY,
  proc_name varchar2(200) NOT NULL,
  date_args varchar2(20) NOT NULL,
  alarm_level number(11) DEFAULT NULL,
  alarm_context varchar2(255) DEFAULT NULL,
  on_focus number(11) DEFAULT NULL,
  alarm_type varchar2(20) DEFAULT NULL,
  alarm_time varchar2(20) DEFAULT NULL,
  MAX_SEND_CNT varchar2(2) DEFAULT NULL,
  INTERVAL_TIME varchar2(20) DEFAULT NULL,
  last_send_time varchar2(50) DEFAULT NULL,
  error_type varchar2(20) DEFAULT NULL,
  team_code varchar2(50) DEFAULT NULL,
  topicname varchar2(100) DEFAULT NULL,
  send_flag number(11) DEFAULT NULL,
  sms_group_id varchar2(20) DEFAULT NULL,
  send_cnt varchar2(5) DEFAULT NULL
);

CREATE TABLE proc_schedule_alarm_send_log (
  xmlid varchar2(100) DEFAULT '',
  proc_xmlid varchar2(200) DEFAULT '',
  proc_name varchar2(200) DEFAULT '',
  proc_date_args varchar2(20) DEFAULT '',
  send_phone varchar2(20) DEFAULT '',
  send_content CLOB,
  send_time varchar2(20) DEFAULT ''
);
comment on column proc_schedule_alarm_send_log.proc_xmlid is '程序xmid';
comment on column proc_schedule_alarm_send_log.proc_name is '程序名';
comment on column proc_schedule_alarm_send_log.proc_date_args is '告警批次';
comment on column proc_schedule_alarm_send_log.send_phone is '发送告警号码';
comment on column proc_schedule_alarm_send_log.send_content is '发送告警内容';
comment on column proc_schedule_alarm_send_log.send_time is '发送告警时间';

CREATE TABLE sms_log (
  phonenumber varchar2(20) DEFAULT '',
  smscontent varchar2(1000) DEFAULT ''
);
comment on column sms_log.phonenumber is '模拟发送告警短信的号码';
comment on column sms_log.smscontent is '模拟发送告警短信的内容';

/*Table structure for table sms_message_group */
CREATE TABLE sms_message_group (
  SMS_GROUP_ID varchar2(100) DEFAULT '',
  SMS_GROUP_NAME varchar2(200) DEFAULT ''
);
comment on column sms_message_group.SMS_GROUP_ID is '用户组';
comment on column sms_message_group.SMS_GROUP_NAME is '用户组名称';

insert  into sms_message_group(SMS_GROUP_ID,SMS_GROUP_NAME) values ('G0001','经分团队');
insert  into sms_message_group(SMS_GROUP_ID,SMS_GROUP_NAME) values ('G0002','一经模块');
insert  into sms_message_group(SMS_GROUP_ID,SMS_GROUP_NAME) values ('G0003','二经模块');
insert  into sms_message_group(SMS_GROUP_ID,SMS_GROUP_NAME) values ('G0004','MIS模块');
commit;

/*Table structure for table sms_message_group_member */
CREATE TABLE sms_message_group_member (
  SMS_GROUP_ID varchar2(100) DEFAULT '',
  MEMBER_NAME varchar2(20) DEFAULT '',
  PHONENUM varchar2(15) DEFAULT '',
  STATUS varchar2(1) DEFAULT ''
);
comment on column sms_message_group_member.SMS_GROUP_ID is '用户组';
comment on column sms_message_group_member.MEMBER_NAME is '成员';
comment on column sms_message_group_member.PHONENUM is '发送号码';
comment on column sms_message_group_member.STATUS is '是否发送 0 发送 1不发送';

insert  into sms_message_group_member(SMS_GROUP_ID,MEMBER_NAME,PHONENUM,STATUS) values ('G0001','heziming','138000000001','0');
insert  into sms_message_group_member(SMS_GROUP_ID,MEMBER_NAME,PHONENUM,STATUS) values ('G0002','sufan','138000000002','0');
insert  into sms_message_group_member(SMS_GROUP_ID,MEMBER_NAME,PHONENUM,STATUS) values ('G0002','niuzhenjia','138000000003','1');
insert  into sms_message_group_member(SMS_GROUP_ID,MEMBER_NAME,PHONENUM,STATUS) values ('G0003','wuliang','138000000004','0');
commit;

/*Table structure for table sms_message_group_task */
CREATE TABLE sms_message_group_task (
  XMLID varchar2(32) PRIMARY KEY,
  PROC_NAME varchar2(200) DEFAULT '',
  SMS_GROUP_ID varchar2(64) DEFAULT '',
  WARNING_TYPE varchar2(20) DEFAULT '',
  DUE_TIME_CRON varchar2(20) DEFAULT '',
  OFFSET varchar2(2) DEFAULT '',
  MAX_SEND_CNT varchar2(2) DEFAULT '',
  INTERVAL_TIME varchar2(5) DEFAULT '',
  IS_SEND varchar2(1) DEFAULT '',
  MAX_RUN_TIME varchar2(20) DEFAULT ''
);
comment on column sms_message_group_task.PROC_NAME is '程序名';
comment on column sms_message_group_task.SMS_GROUP_ID is '短信用户组';
comment on column sms_message_group_task.WARNING_TYPE is '告警类型';
comment on column sms_message_group_task.DUE_TIME_CRON is '告告警检查时间';
comment on column sms_message_group_task.OFFSET is '告警便宜批次';
comment on column sms_message_group_task.MAX_SEND_CNT is '最大发送次数';
comment on column sms_message_group_task.INTERVAL_TIME is '发送时间间隔';
comment on column sms_message_group_task.IS_SEND is '该程序是否发送短信 0 发送 1不发送';


/*Data for the table warning_type */
CREATE TABLE warning_type (
  TYPE_CODE varchar2(5) DEFAULT '',
  TYPE_NAME varchar2(64) DEFAULT ''
);
comment on column warning_type.TYPE_CODE is '告警类型';
comment on column warning_type.TYPE_NAME is '告警名称';

insert  into warning_type(TYPE_CODE,TYPE_NAME) values ('1','到点未跑完');
insert  into warning_type(TYPE_CODE,TYPE_NAME) values ('2','程序运行错误');
commit;

CREATE TABLE tablefile (
  XMLID varchar2(64) NOT NULL,
  DATANAME varchar2(120) NOT NULL,
  DATACNNAME varchar2(120) NOT NULL,
  TEAM_CODE varchar2(32) DEFAULT '',
  SCHEMA_NAME varchar2(120) DEFAULT '',
  DATATYPE varchar2(20) DEFAULT '',
  DBNAME varchar2(32) DEFAULT '',
  TABSPACE varchar2(120) DEFAULT '',
  INDEX_TABSPACE varchar2(120) DEFAULT '',
  LEVEL_VAL varchar2(32) NOT NULL,
  RIGHTLEVEL varchar2(32) DEFAULT '',
  DELIMITER char(10) DEFAULT '',
  SPLITTYPE varchar2(8) DEFAULT '',
  TOPICNAME varchar2(32) DEFAULT '',
  CYCLETYPE varchar2(32) DEFAULT '',
  COMPRESSION varchar2(1) DEFAULT '',
  FIELDNUM NUMBER(11) DEFAULT '0',
  TABSIZES DECIMAL(15,0) DEFAULT '0',
  ROWNUM_VAL DECIMAL(10,0) DEFAULT '0',
  REFCOUNT NUMBER(11) DEFAULT '0',
  EFF_DATE date NOT NULL ,
  CREATER varchar2(32) NOT NULL ,
  STATE varchar2(32) DEFAULT 'NEW',
  STATE_DATE date DEFAULT '',
  DEVELOPER varchar2(32) DEFAULT '',
  CURDUTYER varchar2(32) DEFAULT '',
  VERSEQ NUMBER(11) DEFAULT '',
  DESIGNER varchar2(32) DEFAULT '',
  AUDITER varchar2(32) DEFAULT '',
  DATEFIELD varchar2(32) DEFAULT '',
  DATEFMT varchar2(16) DEFAULT '',
  DATETYPE varchar2(16) DEFAULT '',
  EXTEND_CFG varchar2(1024) DEFAULT '',
  REMARK varchar2(512) DEFAULT '',
  OPEN_STATE varchar2(32) DEFAULT ''
);
alter table tablefile add constraint PK_tablefile primary key(XMLID,DATANAME);
COMMENT ON table tablefile IS '数据表.存储RDB、hive元模型';
comment on column tablefile.XMLID is '对象ID';
comment on column tablefile.DATANAME is '表名';
comment on column tablefile.DATACNNAME is '中文名';
comment on column tablefile.TEAM_CODE is '团队代码';
comment on column tablefile.SCHEMA_NAME is '模式名';
comment on column tablefile.DATATYPE is '数据类型（V:视图、T:表）';
comment on column tablefile.DBNAME is '存储数据库(metadbcfg.dbname)';
comment on column tablefile.TABSPACE is '表空间.如果是hive存放路径';
comment on column tablefile.INDEX_TABSPACE is '索引空间';
comment on column tablefile.LEVEL_VAL is '层次（ODS、DWD、DW、DM、ST）';
comment on column tablefile.RIGHTLEVEL is '敏感级别';
comment on column tablefile.DELIMITER is '分割符(hadoop平台文件分割。也可作为接口平台入库文件依据)';
comment on column tablefile.TOPICNAME is '主题（客户域\n            用户域\n            服务域\n            行为域\n            资源域\n            事件域\n            账务域\n            资源域\n            财务域\n            维表域\n            集团用户\n            专题分析\n            KPI分析\n            多维成本\n            重点应用\n            ）';
comment on column tablefile.CYCLETYPE is '周期类型(日、周、月、年、多日、多月、多年）';
comment on column tablefile.COMPRESSION is '是否压缩(Y/N)';
comment on column tablefile.FIELDNUM is '字段个数';
comment on column tablefile.TABSIZES is '表大小';
comment on column tablefile.ROWNUM_VAL is '记录条数';
comment on column tablefile.REFCOUNT is '引用次数';
comment on column tablefile.EFF_DATE is '创建时间';
comment on column tablefile.CREATER is '创建者';
comment on column tablefile.STATE is '当前状态（新建、审核、发布、未上线、开放()）';
comment on column tablefile.STATE_DATE is '状态时间';
comment on column tablefile.DEVELOPER is '开发者';
comment on column tablefile.CURDUTYER is '负责人（如果是新建，与CREATER一样。根据状态修改人员而变化）';
comment on column tablefile.VERSEQ is '版本号';
comment on column tablefile.DESIGNER is '设计人员';
comment on column tablefile.AUDITER is '审核人员';
comment on column tablefile.DATEFIELD is '生命周期';
comment on column tablefile.DATEFMT is '生命周期单位（日、月、永久)';
comment on column tablefile.EXTEND_CFG is '{location:"文件路径",sprate:''分隔符}';
comment on column tablefile.REMARK is '备注';
comment on column tablefile.OPEN_STATE is '开放状态';

CREATE TABLE schedule_op_log (
  OP_OBJ varchar2(50) NOT NULL,
  OP_USER varchar2(50) DEFAULT '',
  OP_USER_IP varchar2(50) DEFAULT '',
  OP_TYPE varchar2(20) DEFAULT '',
  OP_SQL varchar2(1000) DEFAULT '',
  OP_STATE varchar2(10) DEFAULT '',
  OP_TIME varchar2(50) DEFAULT ''
);
COMMENT ON table schedule_op_log IS '调度人工干预日志表';

CREATE TABLE aietl_servernode (
  server_id varchar2(36) DEFAULT '',
  host_name varchar2(100) DEFAULT '',
  deploy_path varchar2(128) DEFAULT '',
  server_status NUMBER(11) DEFAULT '',
  status_time varchar2(20) DEFAULT ''
);
COMMENT ON table aietl_servernode IS 'server状态监控日志表';
comment on column aietl_servernode.host_name is '关联dp_host_config表host_name';

CREATE TABLE schedule_task_supplement (
  xmlid varchar2(200) PRIMARY KEY,
  proc_name varchar2(200) DEFAULT '',
  next_time NUMBER(20) DEFAULT '',
  run_freq varchar2(6) DEFAULT ''
);

CREATE TABLE JOB_COMMAND (
  ID VARCHAR2(32) PRIMARY KEY,
  JOB_COMMAND VARCHAR2(255) DEFAULT '',
  JOB_INSTRUCTION VARCHAR2(255) DEFAULT '',
  JOB_TYPE VARCHAR2(255) DEFAULT ''
);

CREATE TABLE schedule_task_global_val (
  id VARCHAR2(32) DEFAULT '',
  var_name VARCHAR2(255) DEFAULT '',
  var_type VARCHAR2(20) DEFAULT '',
  var_value VARCHAR2(255) DEFAULT '',
  memo CLOB 
);

create table PROC_SCHEDULE_RUN_INDEX
(
  MONTH_ID 		VARCHAR2(10),
  TEAM_CODE 	VARCHAR2(32),
  xmlid        VARCHAR2(32),
  proc_name    VARCHAR2(800),
  RUN_FREQ varchar2(32) DEFAULT '',
  index_type   NUMBER(1),
  index_value  VARCHAR2(200),
  index_offset   VARCHAR2(100),
  update_time    VARCHAR2(20),
  constraint PS_RUN_INDEX_PK primary key(xmlid, index_type,MONTH_ID)
);
comment on column PROC_SCHEDULE_RUN_INDEX.index_type is '0 平均开始时间,1 平均结束时间,2 平均耗时';
