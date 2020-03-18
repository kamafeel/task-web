var userIp="";
var userName=_UserInfo['username'];
var dbType="mysql";

//获取用户ip
$.get("/"+contextPath+"/getIp/ip", function(data, status){
	userIp=data;
});

//获取数据库类型
$.ajax({
	url:'/'+contextPath+'/syn/getMetadbsType',
	async: false,
	dataType: "text",
	success: function(data){
		dbType=data;
	}
});

function taskOpLog(obj,op_type,op_sql,state){
	if(dbType=="mysql"){
		taskOpLog2(obj,op_type,op_sql,state)
	}else{
		taskOpLog1(obj,op_type,op_sql,state)
	}
}

//记录任务日志方法(oracle)
function taskOpLog1(obj,op_type,op_sql,state){
	
	op_sql= op_sql.replace(/'/g, '\'\'');
	var procLog = new AI.JsonStore({
		sql:"  select proc_name from proc_schedule_log WHERE seqno in ("+obj+")",
		dataSource:"METADBS",
		pageSize:-1
	});
	var objs ="";
	if(procLog.getCount()>0){
		$.each(procLog.root,function(index,item){
			var obj = item.PROC_NAME.trim();
			objs += obj + ",";
		})
		objs = objs.substring(0,objs.length-1);
		
	}else{
		objs = obj.replaceAll("'","");
	}
	
	var sql=" INSERT INTO schedule_op_log(op_obj,op_user,op_user_ip,op_type,op_sql,op_state,op_time) "+
	" values('"+objs+"','"+userName+"','"+userIp+"','"+op_type+"','"+op_sql+"','"+state+"',to_char(sysdate,'yyyy-MM-dd HH24:mi:ss')) ";
	ai.executeSQL(sql,false,"METADBS");
}

//记录任务日志方法(mysql)
function taskOpLog2(obj,op_type,op_sql,state){
	
	op_sql= op_sql.replace(/'/g, '\\\'');
	var procLog = new AI.JsonStore({
		sql:"  select proc_name from proc_schedule_log WHERE seqno in ("+obj+")",
		dataSource:"METADBS",
		pageSize:-1
	});
	var objs ="";
	if(procLog.getCount()>0){
		$.each(procLog.root,function(index,item){
			var obj = item.PROC_NAME.trim();
			objs += obj + ",";
		})
		objs = objs.substring(0,objs.length-1);
		
	}else{
		objs = obj.replaceAll("'","");
	}
	
	var sql=" INSERT INTO schedule_op_log(op_obj,op_user,op_user_ip,op_type,op_sql,op_state,op_time) "+
	" values('"+objs+"','"+userName+"','"+userIp+"','"+op_type+"','"+op_sql+"','"+state+"',sysdate()) ";
	ai.executeSQL(sql,false,"METADBS");
}

function logCleanLog(obj,op_type,params,state){
	var sql=" INSERT INTO schedule_op_log(op_obj,op_user,op_user_ip,op_type,op_sql,op_state,op_time) "+
	" values('"+obj+"','"+userName+"','"+userIp+"','"+op_type+"','"+params+"','"+state+"',sysdate()) ";
	ai.executeSQL(sql,false,"METADBS");
}