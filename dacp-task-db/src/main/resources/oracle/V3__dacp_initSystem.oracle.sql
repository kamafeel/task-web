/* 系统 初始化数据  webframe*/
insert into metadbcfg (DBNAME, CNNAME, DRIVERCLASSNAME, url, USERNAME, PASSWORD, JNDINAME, ALIAS, REMARK) values('METADB','元数据库','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/taskdb','root','NfeoEO5MY6s=','',NULL,NULL);
insert into metadbcfg (DBNAME, CNNAME, DRIVERCLASSNAME, url, USERNAME, PASSWORD, JNDINAME, ALIAS, REMARK) values('METADBS','元数据库','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/taskdb','root','NfeoEO5MY6s=','',NULL,NULL);

insert  into metaframe_config(config_code,config_name,parentcode,type,url,isvalid,isdefault,icon,role) values ('C01','调度系统',NULL,'subdir','/ftl/desktop','y','n','/dacp-res/images/logo.png','');

insert  into metagroup(GROUPCODE,GROUPNAME,TYPE,team_code) values ('AppUser','普通用户组','normal',NULL);
insert  into metagroup(GROUPCODE,GROUPNAME,TYPE,team_code) values ('SysMgr','系统管理组','normal',NULL);

insert  into metagroupuser(USERNAME,GROUPCODE,USERROLE,REMARK) values ('sys','SysMgr','系统管理组',NULL);

insert  into metauser(USERNAME,USECNNAME,PASSWORD,REMARK,QQ,MSN,PHONE,MAIL,MD5PASS,DBUSER) values ('sys','系统管理员','spsmJa0PGTs=','ASIAINFO',NULL,NULL,'13599448448',NULL,'spsmJa0PGTs=',NULL);


insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr',NULL,'系统管理',NULL,NULL,NULL,NULL,12,'desklist-img1.png','ftl/frame/metaframe?modelcode=sysmgr','desktop',NULL,'desklist-icon1.png','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_01','sysmgr','系统用户配置',NULL,NULL,NULL,NULL,2,'3','ftl/sysmgr/user',NULL,NULL,'fa fa-user text-info','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_02','sysmgr','系统菜单配置',NULL,NULL,NULL,NULL,1,'2','ftl/sysmgr/menu',NULL,NULL,'fa fa-puzzle-piece text-success','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_03','sysmgr','系统角色配置',NULL,NULL,NULL,NULL,3,'4','ftl/sysmgr/role',NULL,NULL,'fa fa-users text-success','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_04','sysmgr','角色权限管理',NULL,NULL,NULL,NULL,4,'5','ftl/sysmgr/user_menu_rights',NULL,NULL,'fa fa-users text-success','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_05','sysmgr','修改密码',NULL,NULL,NULL,NULL,7,'6','ftl/sysmgr/chang_pwd',NULL,NULL,'fa fa-eye text-warning-dk','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_06','sysmgr','数据库列表',NULL,NULL,NULL,NULL,6,'1','ftl/sysmgr/database',NULL,NULL,'fa fa-list-alt text-warning-lter','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_07','sysmgr','系统加密服务',NULL,NULL,NULL,NULL,5,'7','ftl/sysmgr/pwdserv',NULL,NULL,'fa fa-eye-slash text-primary','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('sysmgr_08','sysmgr','系统公告',NULL,NULL,NULL,NULL,8,NULL,'ftl/sysmgr/notice',NULL,NULL,NULL,'on');

insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor',NULL,'调度监控',NULL,NULL,NULL,NULL,1,'desklist-img3.png','ftl/frame/metaframe?modelcode=task_monitor','desktop',NULL,'desklist-icon3.png','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_01','task_monitor','任务监控',NULL,NULL,NULL,NULL,1,NULL,'ftl/task/taskMonitor',NULL,NULL,'fa fa-puzzle-piece text-success','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_02','task_monitor','Agent监控',NULL,NULL,NULL,NULL,2,NULL,'ftl/task/miniAgentMonitorList',NULL,NULL,'fa fa-user text-info','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_03','task_monitor','手工任务',NULL,NULL,NULL,NULL,3,NULL,'ftl/task/scheduleManual',NULL,NULL,'fa fa-user text-info','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_04','task_monitor','总体监控',NULL,NULL,'总体监控','TFMoniteShow',2,'1','ftl/overallMonitor','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_05','task_monitor','数据监控',NULL,NULL,NULL,NULL,3,NULL,'ftl/task/dataMonitor',NULL,NULL,'fa fa-user text-info','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_monitor_06','task_monitor','资源监控',NULL,NULL,'资源监控','TFMoniteShow',2,'1','ftl/task/resourceMonitor','content',NULL,'fa fa-list-alt','off');

insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg',NULL,'调度配置',NULL,NULL,NULL,NULL,2,'desklist-img2.png','ftl/frame/metaframe?modelcode=task_cfg','desktop',NULL,'desklist-icon2.png','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_01','task_cfg','日志周期管理',NULL,NULL,NULL,NULL,9,NULL,'ftl/task/sysmgr_pwdserv',NULL,NULL,'fa fa-eye-slash text-primary','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_02','task_cfg','任务配置',NULL,NULL,'xx',NULL,1,NULL,'ftl/task/miniProcList?team_code={TEAM_CODE}',NULL,NULL,'fa fa-user text-info','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_03','task_cfg','数据模型',NULL,NULL,NULL,NULL,7,NULL,'ftl/task/model_table',NULL,NULL,'fa fa-users text-success','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_04','task_cfg','数据字典',NULL,NULL,NULL,NULL,8,NULL,'ftl/task/model_dictionary',NULL,NULL,'fa fa-users text-success','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_05','task_cfg','Agent配置',NULL,NULL,NULL,NULL,5,NULL,'ftl/task/agentList',NULL,NULL,'fa fa-eye text-warning-dk','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_06','task_cfg','运行参数',NULL,NULL,'运行参数','TFMoniteShow',7,'1','taskservercfg','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_07','task_cfg','执行命令配置',NULL,NULL,'执行命令配置','TFMoniteShow',6,'1','ftl/jobcommand','content',NULL,'fa fa-list-alt','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_08','task_cfg','远程命令主机',NULL,NULL,'远程命令主机','TFMoniteShow',12,'1','taskremote','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_09','task_cfg','参数配置',NULL,NULL,'参数配置','TFMoniteShow',3,'1','ftl/task/taskparam','content',NULL,'fa fa-list-alt','on');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_10','task_cfg','告警配置',NULL,NULL,'告警配置','TFMoniteShow',4,'1','warncfg','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_11','task_cfg','服务列表',NULL,NULL,'服务列表','TFMoniteShow',10,'1','taskservice','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_12','task_cfg','操作日志',NULL,NULL,'操作日志','TFMoniteShow',11,'1','ftl/task/scheduleOpLogList','content',NULL,'fa fa-list-alt','off');
insert  into metamodel(MODELCODE,PARENTCODE,MODELNAME,MODELTYPE,CRETIME,REMARK,CLASSTYPE,SEQ,IMAGEINDEX,URL,FRAME,COUNTSQL,IMAGES,STATE) values ('task_cfg_13','task_cfg','主机配置',NULL,NULL,'主机配置','TFMoniteShow',2,'1','ftl/task/miniHostList','content',NULL,'fa fa-list-alt','on');


insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr','SysMgr','系统管理',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_01','SysMgr','系统用户配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_02','SysMgr','系统菜单配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_03','SysMgr','系统角色配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_04','SysMgr','角色权限管理',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_05','SysMgr','修改密码',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_06','SysMgr','数据库列表',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_07','SysMgr','系统加密服务',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('sysmgr_08','SysMgr','系统公告',NULL,'2');

insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg','SysMgr','调度配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_01','SysMgr','日志周期管理',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_02','SysMgr','任务配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_03','SysMgr','数据模型',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_04','SysMgr','数据字典',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_05','SysMgr','Agent配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_06','SysMgr','运行参数',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_07','SysMgr','执行命令配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_08','SysMgr','远程命令主机',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_09','SysMgr','参数配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_10','SysMgr','告警配置',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_11','SysMgr','服务列表',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_12','SysMgr','操作日志',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_cfg_13','SysMgr','主机配置',NULL,'2');

insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor','SysMgr','调度监控',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_01','SysMgr','任务监控',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_02','SysMgr','Agent监控',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_03','SysMgr','手工任务',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_04','SysMgr','总体监控',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_05','SysMgr','数据监控',NULL,'2');
insert  into metapermission(MODELCODE,GROUPCODE,MODELNAME,PARENTCODE,PERMISSIONLEVEL) values ('task_monitor_06','SysMgr','资源监控',NULL,'2');

/*webframe end*/

insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('05497f74972eac7b34f02ebbcf846e94','caa2bcc8b69964f1f271dd3c595ae838','year','年',1,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('2a69c91094042071e1fab08d41112c04','34c795581b15b1333a1b39843e1de6a9','KPI层','KPI层',NULL,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('556e76f869dbcfdf63794efb6d26e3da','caa2bcc8b69964f1f271dd3c595ae838','minute','分钟',5,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('6291d9d652eeb078f5fc6868533b9f6c','4cf958a1f37e961fa73e9293c757761e','O域','O域',NULL,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('79964f58b4dacf412c23b0ef68ee7fd2','caa2bcc8b69964f1f271dd3c595ae838','hour','小时',4,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('926863e9b34fa61402346d0338614b31','4cf958a1f37e961fa73e9293c757761e','B域','B域',NULL,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('cb116776012439922e8f41b546d47371','caa2bcc8b69964f1f271dd3c595ae838','month','月',2,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('e64abf37d4a29b9322c17645fb8cdd39','caa2bcc8b69964f1f271dd3c595ae838','day','日',3,NULL);
insert  into proc_schedule_dim(XMLID,DIM_GROUP_ID,DIM_CODE,DIM_VALUE,DIM_SEQ,REMARK) values ('f29645ccfc0f28c6f609516c794752e0','34c795581b15b1333a1b39843e1de6a9','DW层','DW层',NULL,NULL);
insert into proc_schedule_dim (XMLID, DIM_GROUP_ID, DIM_CODE, DIM_VALUE, DIM_SEQ, REMARK) values ('85883f958cc299cfb4858e298780a460', 'f9f8063174934f4a2148347076da95ad', '1', '到点未完成', 1, NULL);
insert into proc_schedule_dim (XMLID, DIM_GROUP_ID, DIM_CODE, DIM_VALUE, DIM_SEQ, REMARK) values ('8eba2d15a16a2e7a31eb47679495cb01', 'f9f8063174934f4a2148347076da95ad', '2', '程序运行失败', 2, NULL);


insert into proc_schedule_dim_group (XMLID, GROUP_CODE, GROUP_VALUE, GROUP_SEQ, REMARK) values('34c795581b15b1333a1b39843e1de6a9','LEVEL_TYPE','层次',NULL,'层次');
insert into proc_schedule_dim_group (XMLID, GROUP_CODE, GROUP_VALUE, GROUP_SEQ, REMARK) values('4cf958a1f37e961fa73e9293c757761e','TOPIC_TYPE','主题',NULL,'主题');
insert into proc_schedule_dim_group (XMLID, GROUP_CODE, GROUP_VALUE, GROUP_SEQ, REMARK) values('caa2bcc8b69964f1f271dd3c595ae838','CYCLE_TYPE','周期类型',NULL,'周期类型');
insert into proc_schedule_dim_group (XMLID, GROUP_CODE, GROUP_VALUE, GROUP_SEQ, REMARK) values('f9f8063174934f4a2148347076da95ad', 'ALARM_TYPE', '告警类型', NULL, '告警类型');
commit;




