/*====================     公共表 TODO 需要抽象到framework中          ========================*/
/*jdbc配置表*/
create table metadbcfg (
	DBNAME varchar2 (48),
	CNNAME varchar2 (96),
	DRIVERCLASSNAME varchar2 (192),
	url varchar2 (1024),
	USERNAME varchar2 (96),
	PASSWORD varchar2 (192),
	JNDINAME varchar2 (96),
	ALIAS varchar2 (192),
	REMARK varchar2 (192)
);

/*用户表*/

create table metauser (
  USERNAME varchar2(32) ,
  USECNNAME varchar2(128) ,
  PASSWORD varchar2(64) ,
  REMARK varchar2(128) ,
  QQ varchar2(32) ,
  MSN varchar2(16) ,
  PHONE varchar2(16) ,
  MAIL varchar2(64) ,
  MD5PASS varchar2(128) ,
  DBUSER varchar2(32) 
);

/*菜单模型*/
CREATE TABLE metamodel (
  MODELCODE varchar2(288) ,
  PARENTCODE varchar2(288) ,
  MODELNAME varchar2(576) ,
  MODELTYPE varchar2(288) ,
  CRETIME date ,
  REMARK varchar2(1080) ,
  CLASSTYPE varchar2(288) ,
  SEQ int,
  IMAGEINDEX varchar2(128),
  URL varchar2(1152) ,
  FRAME varchar2(288) ,
  COUNTSQL clob ,
  IMAGES varchar2(576) ,
  STATE varchar2(288) 
);

/*用户菜单权限控制*/

CREATE TABLE metapermission (
  MODELCODE varchar2(32) ,
  GROUPCODE varchar2(64) ,
  MODELNAME varchar2(64) ,
  PARENTCODE varchar2(32) ,
  PERMISSIONLEVEL varchar2(64) 
);

/*角色表*/

create table metagroup (
	GROUPCODE VARCHAR2(192),
	GROUPNAME VARCHAR2(192),
	TYPE VARCHAR2(192),
	TEAMCODE VARCHAR2(48),
	TEAM_CODE VARCHAR2(96)
); 


/*用户角色表*/

create table  metagroupuser (
	USERNAME varchar2 (576),
	GROUPCODE varchar2 (576),
	USERROLE varchar2 (576),
	REMARK varchar2 (2295)
);

/* 系统日志表 */
create table dacp_trace_log (
	user_id varchar2(16) not null ,
	ip_addr varchar2(32) ,
	uri varchar2(128) ,
	req_method varchar2(16) ,
	req_params varchar2(128) ,
	resp_header varchar2(128) ,
	resp_header_len int ,
	resp_body clob ,
	resp_body_len int ,
	resp_cont_type varchar2(64) ,
	resp_time int ,
	create_dt date default sysdate ,
	serv_host varchar2(32) ,
	user_agent varchar2(16) 
);
CREATE TABLE metaframe_config (
  config_code varchar2(96) DEFAULT NULL,
  config_name varchar2(192) DEFAULT NULL,
  parentcode varchar2(96) DEFAULT NULL,
  type varchar2(96) DEFAULT NULL,
  url varchar2(384) DEFAULT NULL,
  isvalid varchar2(10) DEFAULT NULL,
  isdefault varchar2(20) DEFAULT NULL,
  icon varchar2(198) DEFAULT NULL,
  role varchar2(128) DEFAULT NULL
);

/* 系统级维度表 */
CREATE TABLE metaedimdef (
  ID varchar2(64) primary key,
  DIMCODE varchar2(96),
  DIMNAME varchar2(96),
  ROWCODE varchar2(96),
  ROWNAME varchar2(1000),
  TYPE varchar2(96),
  PARENTCODE varchar2(96),
  REMARK varchar2(768),
  TEAM_CODE varchar2(64)
);

comment on column DACP_TRACE_LOG.user_id
  is '接入用户ID';
comment on column DACP_TRACE_LOG.ip_addr
  is '接入IP';
comment on column DACP_TRACE_LOG.uri
  is '请求URI';
comment on column DACP_TRACE_LOG.req_method
  is '请求方法';
comment on column DACP_TRACE_LOG.req_params
  is '请求参数';
comment on column DACP_TRACE_LOG.resp_header
  is '返回的头信息内容';
comment on column DACP_TRACE_LOG.resp_header_len
  is '返回的头信息长度';
comment on column DACP_TRACE_LOG.resp_body
  is '返回的内容';
comment on column DACP_TRACE_LOG.resp_body_len
  is '返回内容长度';
comment on column DACP_TRACE_LOG.resp_cont_type
  is '返回内容格式';
comment on column DACP_TRACE_LOG.resp_time
  is '响应时间，毫秒';
comment on column DACP_TRACE_LOG.create_dt
  is '创建时间';
comment on column DACP_TRACE_LOG.serv_host
  is '服务器地址';
comment on column DACP_TRACE_LOG.user_agent
  is '请求的user_agent';


/* webframe end */
  
/*团队表*/
create table meta_team (
	TEAM_CODE VARCHAR2(96),
	TEAM_NAME VARCHAR2(192),
	TEAM_TYPE VARCHAR2(96),
	START_DATE VARCHAR2(60),
	END_DATE VARCHAR2(60),
	STATE VARCHAR2(24),
	REMARK VARCHAR2(768),
	RES_CFG VARCHAR2(768)
);

/*操作日志*/
CREATE TABLE visitlist (
  LOGINNAME VARCHAR2(16) NOT NULL,
  AREA_ID NUMBER(6) DEFAULT NULL,
  TRACK_MID VARCHAR2(64) DEFAULT NULL,
  TRACK VARCHAR2(128) DEFAULT NULL,
  IPADDR VARCHAR2(16) DEFAULT NULL,
  URI VARCHAR2(128) DEFAULT NULL,
  PARAM VARCHAR2(128) DEFAULT NULL,
  OPERTYPE VARCHAR2(256) DEFAULT NULL,
  OPERNAME VARCHAR2(128) DEFAULT NULL,
  APP_SERV VARCHAR2(32) DEFAULT NULL,
  CREATE_DT VARCHAR2(32) DEFAULT SYSDATE,
  DUR_TIME NUMBER(11) DEFAULT NULL,
  UA VARCHAR2(16) DEFAULT NULL
) ;

/*程序基本信息*/
/*
CREATE TABLE PROC
(
   XMLID                  VARCHAR2(64) NOT NULL,
   PROC_NAME              VARCHAR2(64) NOT NULL,
   NUMBERERCODE              VARCHAR2(20),
   PROCCNNAME             VARCHAR2(120),
   INORFULL               VARCHAR2(4),
   CYCLETYPE              VARCHAR2(60),
   TOPICNAME              VARCHAR2(60),
   STARTDATE              VARCHAR2(16),
   STARTTIME              TIME,
   ENDTIME                TIME,
   PARENTPROC             VARCHAR2(32),
   REMARK                 VARCHAR2(255),
   EFF_DATE               VARCHAR2(64) NOT NULL DEFAULT CURRENT_VARCHAR2(64),
   CREATER                VARCHAR2(32),
   STATE                  VARCHAR2(32),
   STATE_DATE             DATE,
   PROCTYPE               VARCHAR2(32),
   PATH                   VARCHAR2(200),
   RUNMODE                VARCHAR2(32),
   DBUSER                 VARCHAR2(32),
   CURTASKCODE            VARCHAR2(32),
   DESIGNER               VARCHAR2(32),
   AUDITER                VARCHAR2(32),
   DEPLOYER               VARCHAR2(32),
   RUNPARA                VARCHAR2(300),
   RUNDURA                VARCHAR2(32),
   TEAM_CODE              VARCHAR2(32),
   DEVELOPER              VARCHAR2(32),
   CURDUTYER              VARCHAR2(32),
   VERSEQ                 NUMBER(11),
   LEVEL_VAL              VARCHAR2(32),
   APPTYPE                VARCHAR2(32) COMMENT '应用类型',
   DBNAME                 VARCHAR2(32) COMMENT '数据库名',
   EXTEND_CFG             VARCHAR2(1024) COMMENT '扩展信息。输入输出表等',
   AREACODE               VARCHAR2(16),
   XML                    LONGTEXT,
   PRIMARY KEY (PROC_NAME)
);
*/
/*程序日志*/
CREATE TABLE proc_log (
  PROC_NAME VARCHAR2(64) NOT NULL,
  CYCLE_ID NUMBER(8,0) NOT NULL,
  START_TIME VARCHAR2(64) DEFAULT SYSDATE,
  END_TIME VARCHAR2(64) DEFAULT '',
  DUE_TIME NUMBER(11) DEFAULT NULL,
  EFFECT_ROWS decimal(10,2) DEFAULT NULL,
  RATE decimal(10,2) DEFAULT NULL,
  WRATE NUMBER(11) DEFAULT NULL,
  MRATE NUMBER(11) DEFAULT NULL,
  DQ_RUNSTATE VARCHAR2(32) DEFAULT NULL,
  DQ_NUMBERIME VARCHAR2(32) DEFAULT NULL,
  DQ_REMARK VARCHAR2(64) DEFAULT NULL,
  DQ_STATE VARCHAR2(16) DEFAULT NULL,
  REMARK VARCHAR2(200) DEFAULT NULL,
  PROC_ID VARCHAR2(32) DEFAULT NULL,
  DBMS_ID VARCHAR2(32) DEFAULT NULL,
  RESULT NUMBER(11) DEFAULT NULL
);

/*程序步骤信息*/
CREATE TABLE proc_step (
  PROC_NAME VARCHAR2(255) NOT NULL,
  STEP_SEQ NUMBER(11) NOT NULL,
  S_STEP NUMBER(11) DEFAULT NULL,
  F_STEP NUMBER(11) DEFAULT NULL,
  N_STEP NUMBER(11) DEFAULT NULL,
  STEP_NAME VARCHAR2(256) DEFAULT NULL,
  STEP_TYPE NUMBER(11) DEFAULT NULL,
  STEP_CODE VARCHAR2(40) DEFAULT NULL,
  SQL_TEXT CLOB,
  DBNAME VARCHAR2(32) DEFAULT NULL,
  AREACODE VARCHAR2(6) DEFAULT NULL,
  REMARK VARCHAR2(250) DEFAULT NULL,
  PREID VARCHAR2(128) DEFAULT NULL,
  AFTID VARCHAR2(128) DEFAULT NULL,
  PARNET_ID VARCHAR2(8) DEFAULT NULL
);

/*程序步骤日志*/
CREATE TABLE proc_step_log (
  PROC_NAME VARCHAR2(255) NOT NULL,
  STEP_SEQ VARCHAR2(32) NOT NULL,
  STEP_NAME VARCHAR2(64) DEFAULT NULL,
  CYCLE_ID DECIMAL(10,0) NOT NULL,
  START_TIME VARCHAR2(64) DEFAULT SYSDATE,
  END_TIME VARCHAR2(64) DEFAULT NULL,
  STEP_RESULT VARCHAR2(1024) DEFAULT NULL,
  ROWNUM_VAL NUMBER(10) DEFAULT NULL,
  REMARK CLOB,
  SQLCODE VARCHAR2(10) DEFAULT NULL,
  PARENTSEQ VARCHAR2(32) DEFAULT NULL,
  STEP_TYPE NUMBER(10) DEFAULT NULL,
  SQL_TEXT CLOB,
  AREACODE VARCHAR2(10) DEFAULT 'SC',
  REDOTIMES NUMBER(10) DEFAULT NULL,
  RUN_PARAM VARCHAR2(1024) DEFAULT NULL,
  BUSIKEY1 VARCHAR2(64) DEFAULT NULL,
  BUSIKEY2 VARCHAR2(64) DEFAULT NULL,
  BUSIKEY3 VARCHAR2(64) DEFAULT NULL
);

/*程序函数信息*/
CREATE TABLE proc_func_def_java (
	FUNC_CODE VARCHAR2(288),
	FUNC_ID NUMBER (10),
	FUNC_TYPE VARCHAR2(180),
	FUN_ORDSEQ VARCHAR2(72),
	FUNC_ICON VARCHAR2(288),
	SQL_DEF CLOB ,
	DLL_DEF VARCHAR2(2250),
	DLL_FUNC VARCHAR2(2250),
	SHELL_NAME VARCHAR2(2250),
	MEMO VARCHAR2(1800),
	FUNC_NAME VARCHAR2(1800),
	APPLY VARCHAR2(576),
	REMARK VARCHAR2(1152),
	SKIP_FLAG VARCHAR2(36),
	CFGJSON CLOB 
); 

/*程序函数参数信息*/
CREATE TABLE proc_func_def_para (
	FUNC_CODE VARCHAR2(360),
	PARA_IN_OUT VARCHAR2(120),
	PARA_NAME VARCHAR2(240),
	PARA_CNNAME VARCHAR2(360),
	INPUTTYPE VARCHAR2(96),
	INPUTPARA VARCHAR2(4000),
	ISNULL VARCHAR2(6),
	SELVAL VARCHAR2(96),
	SELMODEL VARCHAR2(96),
	PARA_SEQ NUMBER (11),
	REMARK VARCHAR2(1536),
	TABSHEET VARCHAR2(384),
	INPUT_STYLE VARCHAR2(768),
	DEPENDENCIES VARCHAR2(768),
	CHECKITEMS VARCHAR2(768)
);
