var team_code = paramMap["team_code"]||"";

var _STATUS=[' and task_state=-7 ',' and task_state=0 ',' and task_state=1 ',' and task_state in (2,3) ',' and task_state in (-1,-2,-3) ',' and task_state in (4,5) ',' and task_state=6 ',' and task_state>=50 ',' and task_state>=-7 '];
var _CLASS=['btn-default','btn-info','btn-info','btn-primary','btn-warning','btn-success','btn-danger','btn-warning','btn-default','btn-danger','btn-info','btn-warning','btn-danger','btn-default'];
var _VALUE=['创建成功','依赖通过','执行模式通过','发送至agent','正在运行','运行成功','运行失败','暂停任务','重做后续','等待中断','失效','未触发','等待重做','重做当前'];

var searchType="m-simple";//全量m-all和去重m-simple
var _querySql = "select seqno,a.xmlid,a.proc_name,b.proccnname,b.topicname,b.level_val,b.curdutyer,a.pri_level,a.platform,a.agent_code,a.run_freq,task_state,status_time,start_time,exec_time,end_time,use_time,retrynum,a.proctype,a.date_args,creater,a.time_win,a.return_code,c.on_focus,queue_flag,trigger_flag,errcode,proc_date "
		   + " from proc_schedule_log a left join proc b on a.xmlid = b.xmlid left join proc_schedule_info c on a.xmlid = c.xmlid "
		   + " where 1=1 {condi} ";
var _totalSql = " select count(*) as total, sum(case when task_state=6 then 1 else 0 end ) as finish, sum(case when task_state in (4,5) then 1 else 0 end ) as running, sum(case when task_state in (-1,-2,-3) then 1 else 0 end ) as pause, sum(case when task_state=3 then 1 else 0 end ) as wait, sum(case when task_state=2 then 1 else 0 end ) as pass,sum(case when task_state=1 then 1 else 0 end ) as created , sum(case when task_state=0 then 1 else 0 end) as redo , sum(case when task_state=-7 then 1 else 0 end) as notrigger, sum(case when task_state>=50 then 1 else 0 end ) as fail "
		   	    + " from (select a.task_state from  proc_schedule_log a left join proc b on a.xmlid = b.xmlid where 1=1 {condi}) t ";

//查询条件，不包括任务状态
var getQueryCondi = function(flag){
	var _condi="";
	_condi += " and a.task_state >=-7 ";//有效状态
	_condi += searchType == "m-simple"? " and valid_flag=0 ":"";//是否展示失效任务
	_condi += " and a.run_freq <> 'manual' ";//不展示手工任务
	
	var taskName = $("#task_name input").val().trim();
	if(taskName.length >0 ){
		_condi +=" AND (a.proc_name like '%" + taskName + "%' ) " ;
	}
	
	var date_args = $("#date_args input").val();
	if(date_args && date_args.length > 0){
		_condi += " and a.date_args like '" + formatDateArgs(date_args) + "%'";
	}

	var start_time = $("#start_time").val().trim();
	if(start_time && start_time.length > 0){
		_condi += " and a.start_time >= '" + start_time + " 00:00:00'";
	} 

	var end_time = $("#end_time").val().trim();
	if(end_time && end_time.length > 0){
		_condi += " and a.start_time <= '" + end_time + " 23:59:59'";
	}
	
	var run_freq = $("#run_freq_select select").val();
	if(run_freq.length>0){
		_condi += " and a.run_freq='" + run_freq + "' ";
	}
	
	var agent_code = $("#agent_code_select select").val();
	if(agent_code.length>0){
		_condi += " and a.agent_code='" + agent_code + "' ";
	}
	
	if(typeof(team_code)!="undefined" && team_code.length>0){
		_condi += "  and b.team_code in ('" + team_code + "')";
	}
	
	return _condi;
}

function validInput(){
	var date_args = $("#date_args input").val().trim();
	if(date_args && date_args.length > 0){
		 if(!/^((\d{4})|(\d{4}-\d{2})|(\d{4}-\d{2}-\d{2})|(\d{4}-\d{2}-\d{2} \d{2})|(\d{4}-\d{2}-\d{2} \d{2}:\d{2}))$/.test(date_args)){
		 	alert("日期批次格式有误");
		 	return false;
		 }
	}
	return true;
}

function switchContent(condi){
	if(!condi||typeof(condi)=="undefined"){
		condi="";
	}
	//查询时，统计面板不过滤任务状态，列表需要过滤任务状态
	var total = _totalSql.replace("{condi}",condi);
	var task_state = $("#task_state_select select").val();
	
	if(task_state.length>0){
		condi += _STATUS[task_state];
	}
	var content = _querySql.replace("{condi}",condi);

	_totalStore.config.sql = total;
	_totalStore.fetch();
	refreshGrid(content);
};

function kill(seqno,agentCode){
	$.ajax({ 
		url:'/'+contextPath+'/syn/kill?SEQNO='+seqno+'&AGENT_CODE='+agentCode+'&SYN_TYPE=KILL_PROC',
		error:function(){     
		       alert('网络错误！');     
	    },
		success:function(msg){
			var msg = $.parseJSON(msg);
			if(msg.flag==true||msg.flag=="true"){
			     alert('终止任务成功');
				 _contentStore.select();
			}else{
				alert('终止任务失败');     
			}
		}
  });
}

//刷新统计面板不更新数据
function refreshTotal(condi){
	if(!condi||typeof(condi)=="undefined"){
		condi="";
	}

	var tree = _treeSql.replace("{condi}",condi);
	var content = _querySql.replace("{condi}",condi);
	refreshGrid(content);
	_totalStore.fetch();
};

//刷新列表
function refreshGrid(sql){
	rowIndex=0;
	if(sql==null){
		_contentStore.select();
	}else{
		_contentStore.select(sql);
	}
	$("#tabpanel1").children(0).css("overflow","visible");
}

function showDetail(seqno,op){
	window.open("/" + contextPath + "/ftl/task/monitorDialog?seqno="+seqno+"&op="+op);
}
function showTransDataMapManual(seqno,procName,dateArgs){
	window.open("/" + contextPath + "/ftl/task/monitorRedoManual?seqno="+seqno+"&procName="+procName+"&dateArgs="+dateArgs);
}

//统计面板
var _totalPanel = new ve.HtmlWidget({
	config:{
		"className": "html",
		"id": "view_total_up_total_id",
		"template":
			'<div class="total_line row">'+
		   		'<div class="total_run col-sm-2">'+
		   			'<div class="total_1 ">任务运行概况</div>'+
		   			'<div id="total_2" class="total_2 "><%=curDate%></div>'+
	   			'</div>'+
	       		'<div class="total_detail col-sm-10">'+
			        '<div id="detail_dv_1" class="detail_1" ><label class="total_label_1"><%=finishRate%>%</label><div><label class="sm-detail">运行成功率</label></div></div>'+
			        '<div id="detail_dv_2" class="detail_dv detail_2" ><label class="total_label_2 detail_label" status="8"><%=total%></label><div><label class="sm-detail">总程序数</label></div></div>'+
			        '<div id="detail_dv_3" class="detail_dv detail_3" ><label class="total_label_3 detail_label" status="6"><%=finish%></label><div><label class="sm-detail">执行成功</label></div></div>'+
			        '<div id="detail_dv_4" class="detail_dv detail_4" ><label class="total_label_4 detail_label" status="7"><%=fail%></label><div><label class="sm-detail">执行失败</label></div></div>'+
			        '<div id="detail_dv_5" class="detail_dv detail_5" ><label class="total_label_5 detail_label" status="5"><%=running%></label><div><label class="sm-detail">正在执行</label></div></div>'+
			        '<div id="detail_dv_6" class="detail_dv detail_6" ><label class="total_label_6 detail_label" status="4"><%=pause%></label><div><label class="sm-detail">暂停任务</label></div></div>'+
			        '<div id="detail_dv_7" class="detail_dv detail_7" ><label class="total_label_7 detail_label" status="3"><%=wait%></label><div><label class="sm-detail">排队等待</label></div></div>'+
			        '<div id="detail_dv_9" class="detail_dv detail_8" ><label class="total_label_9 detail_label" status="2"><%=created%></label><div><label class="sm-detail">创建成功</label></div></div>'+
			        '<div id="detail_dv_9" class="detail_dv detail_9" ><label class="total_label_9 detail_label" status="1"><%=redo%></label><div><label class="sm-detail">重做等待</label></div></div>'+
			        '<div id="detail_dv_10" class="detail_dv detail_10" ><label class="total_label_10 detail_label" status="0"><%=notrigger%></label><div><label class="sm-detail">未触发</label></div></div>'+
       			'</div>'+
	       '</div>',
		"events":{
			afterRender:function(){
				var _view = this;
				var curDate = $("#date_args input").val();
			
		  		var finish = _totalStore.models.length>0?_totalStore.models[0].get("FINISH"):0;
		  		var fail = _totalStore.models.length>0?_totalStore.models[0].get("FAIL"):0;
		  		var running = _totalStore.models.length>0?_totalStore.models[0].get("RUNNING"):0;
		  		var notrigger= _totalStore.models.length>0?_totalStore.models[0].get("NOTRIGGER"):0;
		  		var wait = _totalStore.models.length>0?_totalStore.models[0].get("WAIT"):0;
		  		var pass = _totalStore.models.length>0?_totalStore.models[0].get("PASS"):0;
		  		var pause = _totalStore.models.length>0?_totalStore.models[0].get("PAUSE"):0;
		  		var created = _totalStore.models.length>0?_totalStore.models[0].get("CREATED"):0;
		  		var redo = _totalStore.models.length>0?_totalStore.models[0].get("REDO"):0;
		  		var total = _totalStore.models.length>0?_totalStore.models[0].get("TOTAL"):0;
		  		
		  		finish = finish==undefined||finish==null?0:finish;
		  		fail = fail==undefined||fail==null?0:fail;
		  		running = running==undefined||running==null?0:running;
		  		wait = wait==undefined||wait==null?0:wait;
		  		pass = pass==undefined||pass==null?0:pass;
		  		pause = pause==undefined||pause==null?0:pause;
		  		created = created==undefined||created==null?0:created;
		  		redo = redo==undefined||redo==null?0:redo;
		  		notrigger = notrigger==undefined||notrigger==null?0:notrigger;
		  		
		  		var finishRate = (finish*100/(total==0?1:total)).toFixed(2);
		  		_view.$el.addClass('info-general').empty().append(_.template(_view.config.template,{
		  			'curDate': curDate,
		  			'finishRate': finishRate,
		  			'total': total,
		  			'finish': finish,
		  			'fail': fail,
		  			'running': running,
		  			'wait': wait,
		  			'notrigger': notrigger,
		  			'pass': pass,
		  			'pause': pause,
		  			'created': created,
		  			'redo': redo
	  			}));
		  		_view.$el.find(".detail_dv").css("cursor","pointer");
				_view.$el.find(".detail_dv").on('click',function(e){
					if(!validInput())return false;
		  			var _id = $(e.currentTarget).find(".detail_label").attr("status");
		  			if(_id<8){
			  			$("#task_state_select select").val(_id);
		  			}else{
		  				$("#task_state_select select option:first").prop("selected","selected");
		  			}
		  			$("#search button").click();		  			
		  		});
			}
		}
	}
});

//查询面板
var _queryPanel = new ve.FormWidget({
	config:{
		"class":"form",
		"formClass":"form-inline",
		"id": "view_total_up_total_tab_nav",
		"noJustfiyFilter":"on",
		"items": [
			{
				"type":"combox",
				"id":"task_state_select",
				"fieldLabel":"状态",
				"select":[
				           {'key':'0','value':'未触发'}
				          ,{'key':'1','value':'重做等待'}
				          ,{'key':'2','value':'创建成功'}
				          ,{'key':'3','value':'排队等待'}
				          ,{'key':'4','value':'暂停执行'}
				          ,{'key':'5','value':'正在运行'}
				          ,{'key':'6','value':'执行成功'}
				          ,{'key':'7','value':'执行失败'}
				          ],
			    "style": "min-width:80px;width:100px;"
			},
			{
				"type":"combox",
				"fieldLabel":"任务周期",
				"id":"run_freq_select",
				"select":cycleList,
				"style": "min-width:80px;width:100px;"
			},
			{
				"type":"combox",
				"fieldLabel":"执行Agent",
				"id":"agent_code_select",
				"select":agentList,
				"style": "min-width:80px;width:120px;"
			},
			{
				"type": "text",
				"id":"task_name",
				"fieldLabel":"",
				"placeholder":"任务名称",
				"style": "min-width:80px;width:155px;"
			},
			{
				"type": "timebetween",
				"id":"timebetween",
				"startTimeId":"start_time",
				"endTimeId":"end_time",
				"fieldLabel":"创建时间范围",
				"placeholder":"创建时间范围",
				"format" : "yyyy-mm-dd",
				"style": "min-width:80px;width:100px;"
			},
			{
				"type": "text",
				"id":"date_args",
				"fieldLabel":"日期批次",
				"placeholder":"yyyy-MM-dd hh:mm",
				"format" : "yyyy-mm-dd",
				"style": "min-width:80px;width:120px;"
			},
			{
				"id":"search",
				"value":"查询",
				"type":"button",
				"className":"search_btn btn-sm btn-primary",
			},
			{
				"id":"switch-mode",
				"value":"",
				"type":"button",
				"className":"search_btn btn-sm btn-primary",
			},
			{
				"id":"batch_redo_self",
				"value":"批量重做当前",
				"type":"hidden",
				"className":"search_btn btn-sm btn-warning",
			},
			{
				"id":"batch_redo_after",
				"value":"批量重做后续",
				"type":"hidden",
				"className":"search_btn btn-sm btn-danger",
			},
			{
				"id":"batch_option",
				"value":"多批次操作",
				"type":"button",
				"className":"search_btn btn-sm btn-warning hide",
				"style": "margin-left:5px;"
			},
			{
				"id":"export-to-excel",
				"value":"导出数据",
				"type":"button",
				"className":"search_btn btn-sm btn-primary",
			}
		],
		'events': {
			afterRender:function(){
				var _view = this;
				_view.$el.find('form').addClass('form_personal');
				_view.$el.css("padding","2px 2px 2px 20px");
				_view.$el.find("#task_name").after("<br />");
				_view.$el.find("#timebetween").attr("style","margin-right:4px");
				_view.$el.find("#search").attr("style","margin-left:10px")
				_view.$el.find("#refresh-btn button").append('<span class="glyphicon glyphicon-refresh"></span>');
				
				_view.$el.find("#switch-mode").empty().append(
					'<div class="btn-group" data-toggle="buttons" style="margin-right: 5px;">'+
						'<label id="m-simple" class="btn btn-sm btn-info active">'+
							'<input type="radio" name="options">'+
							'<i class="fa fa-check text-active" ></i>去重'+
						'</label>'+
						'<label id="m-all" class="btn btn-sm btn-success">'+
							'<input type="radio" name="options">'+
							'<i class="fa fa-check text-active"></i>全量'+
						'</label>'+
					'</div>'
				);

				var _refresh = function(flag){
					if(flag){
						REFRESHTIMER = setTimeout(function(){
							_contentStore.select();
							_totalStore.fetch();
							_refresh(true);
						},10000);
					}else{
						clearTimeout(REFRESHTIMER);
					}
				};
				_view.$el.find("#m-simple,#m-all").on("click",function(e){
					if(!validInput())return false;
					searchType = $(e.currentTarget).attr("id");
					if(searchType=="m-simple"){
						$("#batch_redo_self").show();
						$("#batch_redo_after").show();
					}else{
						$("#batch_redo_self").hide();
						$("#batch_redo_after").hide();
					}
					switchContent(getQueryCondi());
			   });
			},
			'change #agent_code_select select':function(e){
				if(!validInput())return false;
				switchContent(getQueryCondi());
			},
			'change #run_freq_select select':function(e){
				if(!validInput())return false;
			    switchContent(getQueryCondi());
			},
			'change #task_state_select select':function(e){
				switchContent(getQueryCondi());
			},
			'click #search':function(){
				if(!validInput())return false;
				switchContent(getQueryCondi());
			},
			'click #batch_option':function(){
				var selected = _grid.getCheckedRows();
				if(selected.length!=1){
					alert("只能选择一项");					
				}else{
					var seqno=selected[0].data.SEQNO;
					var xmlid = selected[0].data.XMLID;
					var procName = selected[0].data.PROC_NAME;
					var dateArgs = selected[0].data.DATE_ARGS;
					batchOptionDialog(seqno,xmlid,procName,dateArgs);
				}
			},
			'click #refresh-btn':function(){
				if(!validInput())return false;
				switchContent(getQueryCondi());
			},//批量重做当前
			'click #batch_redo_self':function(){
				var selected = _grid.getCheckedRows();
				if(selected.length==0){
					alert("至少选中一个可重做项");					
				}else{
					if(confirm("确定所选项都要重做当前吗？")){
						redoProc("cur",selected);
						//刷新版面
						switchContent(getQueryCondi());
					}
				}
			},//批量重做后续
			'click #batch_redo_after':function(){
				var selected = _grid.getCheckedRows();
				if(selected.length==0){
					alert("至少选中一个可重做项");					
				}else{
					if(confirm("确定所选项都要重做后续吗？")){
						redoProc("after",selected);
						//刷新版面
						switchContent(getQueryCondi());
					}
				}
			},//导出查询的数据为EXCEl的格式
			'click #export-to-excel':function(){
				var header = [{"label":'程序名称',"dataIndex":"PROC_NAME"},{"label":'周期',"dataIndex":"RUN_FREQ"},{"label":'Agent',"dataIndex":"AGENT_CODE"},{"label":'状态',"dataIndex":"TASK_STATE"},{"label":'当前责任人',"dataIndex":"CURDUTYER"},{"label":'创建时间',"dataIndex":"START_TIME"},{"label":'开始执行时间',"dataIndex":"EXEC_TIME"},{"label":'执行结束时间',"dataIndex":"END_TIME"},{"label":'运行时长',"dataIndex":"USE_TIME"},{"label":'批次号',"dataIndex":"DATE_ARGS"}];
				var contextPath = location.pathname.split('/')[1]||'';
		        contextPath = '/'+contextPath+'/ve/download';
				var exportSql=_contentStore.sql;
		        //exportSql = exportSql.replace("order by START_TIME desc"," ");
		        var sql="select proc_name,run_freq,agent_code,task_state,creater,start_time,exec_time,end_time,use_time,date_args,time_win from( "
			        	  + " select proc_name,agent_code,creater,start_time,exec_time,end_time,date_args,time_win, "
			        	  + " case run_freq  "
			        	  + " when 'year' then '年' "
			        	  + " when 'month' then '月' "
			        	  + " when 'day' then '日' "
			        	  + " when 'hour' then '时' "
			        	  + " when 'minute' then '分' "
			        	  + " when 'manual' then '手工任务' "
			        	  + " when 'week' then '周' "
			        	  + " else '--' end as run_freq, "
			        	  + " case "
			        	  + " when task_state = -7 then '未触发' "
			        	  + " when task_state = -6 then '失效' "
			        	  + " when task_state = -5 then '等待中断' "
			        	  + " when task_state in (-3, -2, -1) then '暂停任务' "
			        	  + " when task_state = 0 and trigger_flag=0 then '重做后续' "
			        	  + " when task_state = 0 and trigger_flag=1 then '重做当前' "
			        	  + " when task_state = 1 then '创建成功' "
			        	  + " when task_state = 2 then '依赖通过' "
			        	  + " when task_state = 3 then '排队等待' "
			        	  + " when task_state = 4 then '发送至agent' "
			        	  + " when task_state = 5 then '正在运行' "
			        	  + " when task_state = 6 then '运行成功' "
			        	  + " else '运行失败' end as task_state, "
			        	  + " case when use_time is null then '--' else use_time  end as use_time "
		        	  + " from ( " + exportSql + " ) tt "
		        	+" ) t ";
		        var downloadStore = new AI.JsonStore({
					sql: sql,
					dataSource:"METADBS"
				});
		        if (downloadStore && downloadStore.count>0){
					ve.DownloadHelper.download({
					    sql:sql,
					    dataSource:"METADBS",
					    header:JSON.stringify(header),
					    url:contextPath,
					    fileName : "任务监控的查询结果",
					    fileType:'excel'
			        });
		        }else{
		        	alert("没有数据！");
		        }
				
			}
		}
	}

});


//左边树
var buildTreeView = function(sql){
};

var procNameRender = function(record,value){
	var res='<a href="#" style="text-decoration:underline;color:blue;" title="查看调度信息" onclick="showProcScheduleInfo(\'' + record.data.XMLID.trim() + '\')">'+ value +'</a>';
	return res;
};

function showProcScheduleInfo(xmlid){
	$("#upsertForm").empty();
	var sql="SELECT b.proc_name,b.creater,a.platform,a.agent_code,a.trigger_type,a.eff_time,a.exp_time,a.cron_exp,a.muti_run_flag,a.date_args,a.pri_level FROM proc_schedule_info a RIGHT JOIN proc b on a.proc_name = b.proc_name where b.xmlid ='" + xmlid + "'";
	ds_mydata=new AI.JsonStore({
		sql : sql,
		filter : 'proctype =1',
		selfield : '',
		key : "XMLID",
		pageSize : 15,
		table : "PROC",
		dataSource:"METADBS"
	});
	var formcfg = ({
		id : 'form',
		store : ds_mydata,
		containerId : 'upsertForm',
		items : [ 
			{type : 'text',label : '程序名称',fieldName : 'PROC_NAME',isReadOnly:"y"},
			{type : 'date',label : '上线时间',fieldName : 'EFF_TIME',value:new Date().format('yyyy-mm-dd'),isReadOnly:"y"}, 
			{type : 'date',label : '下线时间',fieldName : 'EXP_TIME',isReadOnly:"y"},
			{type : 'text',label : '资源组',fieldName : 'PLATFORM',isReadOnly:"y"},
		    {type : 'text',label : 'AGENT',fieldName : 'AGENT_CODE',isReadOnly:"y"},
			{type : 'text',label : '优先级',fieldName : "PRI_LEVEL",isReadOnly:"y"}, 
			{type : 'radio-custom',label : '运行模式',fieldName : 'MUTI_RUN_FLAG',storesql:'0,顺序启动|1,多重启动|2,唯一启动|3,月内顺序启动',isReadOnly:"y"},
			{type:  "radio-custom", label: "触发类型", fieldName: "TRIGGER_TYPE",storesql:'0,时间触发|1,事件触发',isReadOnly:"y"},
			{type : 'text',label : 'cron表达式',fieldName : 'CRON_EXP',isReadOnly:"y"}, 
			{type : 'text',label : '日期偏移量',fieldName : 'DATE_ARGS',isReadOnly:"y"}
		],
		
	});

	var from = new AI.Form(formcfg);
	var x = document.getElementsByName('TRIGGER_TYPE');
       for (var j = 0; j < x.length; j++) {
           if (x[j].checked) {
           	if(j == '0'){
           		$("#CRON_EXP").parent().parent().show();
        		$("#DATE_ARGS").parent().parent().show();
           	}else{
           		$("#CRON_EXP").parent().parent().hide();
        		$("#DATE_ARGS").parent().parent().hide();
           	}
           }
       }
	$("#dialog-ok").hide();
	$(".modal-title").html("查看调度信息");
	$('#myModal').css("z-index",99999)
	
	$(".close-modal").click(function(){
		$('#myModal').modal('hide');
	});
	
    $('#myModal').modal({
		show : true,
		backdrop:false
	});
}

var runFreqRender = function(data,value){
	var res="未知";
	switch(value){
		case "year":
			res="年"
			break;
		case "week":
			res="周"
			break;
		case "month":
			res="月"
			break;
		case "day":
			res="日"
			break;
		case "hour":
			res="小时"
			break;
		case "minute":
			res="分钟"
			break;
		default:
			break;
	}
	return res;
};

var _argsRender = function (record,value){
	var args = record.data.DATE_ARGS;
	var argsType = record.data.RUN_FREQ;
	switch(argsType){
		case "month":
			args = args.substr(0,7);
			break;
		case "year":
			args = args.substr(0,4);
			break;
		default:
			break;
	}
	return args;
};

var rowIndex=0;
var _stateIcon = function(record,value){
	value = record.data.TASK_STATE;
	var index=rowIndex++;
	var data = record.data;
	//操作下拉菜单
	var li_condi = '<li><a onclick="taskManualOption(this)" id="li_condi" seq="<%=seqno%>" name="<%=procName%>" err="<%=errorCode%>" task_status="<%=task_status%>">查看执行条件</a></li>';
	var li_log = '<li><a onclick="taskManualOption(this)" id="li_log" seq="<%=seqno%>">查看日志</a></li>';
	var li_running_log = '<li><a onclick="taskManualOption(this)" id="li_running_log" seq="<%=seqno%>" agent="<%=agent%>">查看运行日志</a></li>';
	var li_force_pass = '<li><a onclick="taskManualOption(this)" id="li_force_pass" seq="<%=seqno%>">强制通过</a></li>';
	var li_force_exec = '<li><a onclick="taskManualOption(this)" id="li_force_exec" seq="<%=seqno%>" >强制执行</a></li>';
	var li_stop = '<li><a onclick="taskManualOption(this)" id="li_stop" seq="<%=seqno%>" agent="<%=agent%>">停止</a></li>';
	var li_pause = '<li><a onclick="taskManualOption(this)" id="li_pause" seq="<%=seqno%>" task_status="<%=task_status%>">暂停执行</a></li>';
	var li_recover = '<li><a onclick="taskManualOption(this)" id="li_recover" seq="<%=seqno%>" task_status="<%=task_status%>">恢复任务</a></li>';
	var li_redo_after = '<li><a onclick="taskManualOption(this)" id="li_redo_after" seq="<%=seqno%>">重做后续</a></li>';
	var li_redo_self = '<li><a onclick="taskManualOption(this)" id="li_redo_self" seq="<%=seqno%>">重做当前</a></li>';
	var li_use_time = '<li><a onclick="taskManualOption(this)" id="li_use_time"   seq="<%=seqno%>">时长分析</a></li>';
	//taskType.js设置dp_redo_type
	if(value>=50 && data.PROCTYPE == "taskTypeProc" ){ 
		li_redo_after =
			'<li class="dropdown-submenu">'+
				'<a tabindex="-1" href="javascript:void(0);">重做后续</a>'+
				'<ul class="dropdown-menu" >'+
					'<li> <a onclick="taskManualOption(this)" id="li_redo_after_0" name="li_redo_after_0" seq="<%=seqno%>" href="javascript:void(0);"><span class="glyphicon "></span>从头开始</a></li>'+
					'<li> <a onclick="taskManualOption(this)" id="li_redo_after_1" name="li_redo_after_1" seq="<%=seqno%>" returncode="<%=returnCode%>" href="javascript:void(0);"><span class="glyphicon "></span>从错误步骤开始</a></li>'+
				'</ul>'+
			'</li>';
		li_redo_self =
			'<li class="dropdown-submenu">'+
				'<a tabindex="-1" href="javascript:void(0);">重做当前</a>'+
				'<ul class="dropdown-menu" >'+
					'<li> <a onclick="taskManualOption(this)" id="li_redo_self_0" name="li_redo_self_0" seq="<%=seqno%>" href="javascript:void(0);"><span class="glyphicon "></span>从头开始</a></li>'+
					'<li> <a onclick="taskManualOption(this)" id="li_redo_self_1" name="li_redo_self_1" seq="<%=seqno%>"  returncode="<%=returnCode%>"  href="javascript:void(0);">'+'<span class="glyphicon "></span>从错误步骤开始</a></li>'+
				'</ul>'+
			'</li>';
	}
	
	var li_set_priv='<li class="dropdown-submenu">'+
				    	'<a tabindex="-1" href="javascript:void(0);">设置优先级</a>'+
					    '<ul class="dropdown-menu" >'+
					        '<li class="<%=(priLevel==20?"active":"")%>"><a onclick="taskManualOption(this)" id="li_set_priv" name="20" seq="<%=seqno%>" href="javascript:;"><span class="glyphicon glyphicon-ok <%=priLevel==20?"":"hide"%>"></span> 高（20）</a></li>'+
					        '<li class="<%=(priLevel>14&&priLevel<20?"active":"")%>"><a onclick="taskManualOption(this)" id="li_set_priv" name="15" seq="<%=seqno%>" href="javascript:;"><span class="glyphicon glyphicon-ok <%=priLevel>14&&priLevel<20?"":"hide"%>"></span> 高于正常（15）</a></li>'+
					        '<li class="<%=(priLevel>9&&priLevel<15?"active":"")%>"><a onclick="taskManualOption(this)" id="li_set_priv" name="10" seq="<%=seqno%>" href="javascript:;"><span class="glyphicon glyphicon-ok <%=priLevel>9&&priLevel<15?"":"hide"%>"></span> 正常（10）</a></li>'+
					        '<li class="<%=(priLevel>5&&priLevel<10?"active":"")%>"><a onclick="taskManualOption(this)" id="li_set_priv" name="5" seq="<%=seqno%>" href="javascript:;"><span class="glyphicon glyphicon-ok <%=priLevel>5&&priLevel<10?"":"hide"%>"></span> 低于正常（5）</a></li>'+
					        '<li class="<%=priLevel<5?"active":""%>"><a onclick="taskManualOption(this)" id="li_set_priv" name="1" seq="<%=seqno%>" href="javascript:;"><span class="glyphicon glyphicon-ok <%=priLevel<5?"":"hide"%>"></span> 低（1）</a></li>'+
					    '</ul>'+
			        '</li>';
	
			  
	var lis ="";
	var flag = value;
	switch(value){
		case -7:
			flag = 12;
			lis = li_force_pass + li_force_exec;
			break;
			
		case -1:
		case -2:
		case -3:
			flag = 8;
			lis = li_recover;
			break;
			
		case 0:
			if(data.TRIGGER_FLAG==0){
				flag = 9;
			}else{
				flag = 14;
			}
			lis = li_condi + li_set_priv;
			break;
			
		case 1:
			lis = li_condi + li_force_pass + li_force_exec + li_pause + li_set_priv;
			break;
			
		case 2:
		case 3:
			lis = li_condi + li_force_pass + li_pause + li_set_priv;
			break;
			
		case 4:
			lis = li_condi;
			break;
			
		case -5:
			flag = 10;
		case 5:
			lis = li_condi + li_running_log + li_stop;
			break;
			
		case -6:
			flag = 11;
		case 6:
			lis = li_condi + li_log + li_redo_after + li_redo_self + li_use_time;
			break;
		case 7:
			break;
		default:
			if(value>=50){
				lis = li_condi + li_log + li_redo_after + li_redo_self + li_force_pass + li_use_time;
				flag = data.QUEUE_FLAG==0? 13: 7;
			}
			break;
	}	
	var _tmpl = 
		//'<div onclick="showStateMenu(this)" class="task-state-option '+((index%_contentStore.pageSize)>6?"dropup":"")+'">'+
		'<div onclick="showStateMenu(this)" class="task-state-option">'+
			'<button type="button" class="btn btn-xs <%=cla%> " >' +//dropdown-toggle data-toggle="dropdown"
				'<%=name%><span class="caret"></span>'+
			'</button>'+
			'<ul class="dropdown-menu" role="menu">'+
				lis +
			'</ul>'+
		'</div>';
	return _.template(_tmpl,{"cla":_CLASS[flag-1],"name":_VALUE[flag-1],"value":value,"seqno":data.SEQNO,"priLevel":data.PRI_LEVEL,"procName":data.PROC_NAME,"task_status":data.TASK_STATE,"agent":data.AGENT_CODE,"errorCode":data.ERRCODE,"returnCode":data.RETURN_CODE,"dateArgs":data.DATE_ARGS});
};

function showStateMenu(obj){
	if($(obj).attr("class").indexOf("open")<0){
		$(obj).addClass("open");
	}else{
		$(obj).removeClass("open");
	}
};

$(document).ready(function() {
	var toggleButtons = '<div class="btnCenter"></div>'
			+ '<div class="btnBoth"></div>'
			+ '<div class="btnWest"></div>';
	$('body').layout({
    	sizable:						false,
    	animatePaneSizing:				true,
    	fxSpeed:						'slow',
    	spacing_open:					0,
    	spacing_closed:					0,
    	west__spacing_closed:			8,
    	west__spacing_open:				8,
    	west__togglerLength_closed:		105,
    	west__togglerLength_open:		105,
    	west__togglerContent_closed:	toggleButtons,
    	west__togglerContent_open:		toggleButtons,
    	west__size:						0,
    	north__size: 					135
	});
	_totalPanel.$el=$("#totalPanel");
	_queryPanel.$el=$("#queryPanel");
	_queryPanel.render();
	
	var today = new Date();
	today.setDate(today.getDate()-1);
	var defaultShowDate = today.format("yyyy-mm-dd");
	$("#start_time").val("");
	$("#end_time").val("");
	$("#date_args input").val(defaultShowDate);

	var _condi = getQueryCondi();
	//默认加载失败任务纪录
	//_condi += " and task_state>=50 ";
	
	_totalStore = new ve.SqlStore({
		sql:_totalSql.replace("{condi}",_condi),
		dataSource:"METADBS"
	});
	_totalStore.on("reset",function(){
		_totalPanel.store=_totalStore;
		_totalPanel.store.fetched=true;
		_totalPanel.render();
	});
	_totalStore.fetch();
    
	_contentStore = new AI.JsonStore({
		sql: _querySql.replace("{condi}",_condi),
		dataSource: "METADBS",
		pageSize: 30
	});
	
	_grid = new AI.Grid({
		id:"taskListTable",
		store: _contentStore,
		containerId: 'tabpanel1',
		//pageSize: 30,
		nowrap: true,
		showcheck: true,
		align: "left",
		rowclick: function(rowIndex,record){
			curdata= rowIndex;
		},
		cellclick: function(dataIndex,rowIndex, record){
			curdata= rowIndex;
			if($("table tr").find(".task-state-option.open").length>0){
				$("table tr").find(".task-state-option.open").removeClass("open");
			}
			if(dataIndex=="TASK_STATE"){
				$("table tr").eq(rowIndex).find(".task-state-option").addClass("open");
			}
		},
		celldblclick: function(val,rowdata){
			if(rowdata){
				var seqno = rowdata.data.SEQNO;
				showDetail(seqno,"flow");
			}
			return false;
		},
		columns:[
			{header: "程序名称",dataIndex: "PROC_NAME",cls: "ai-grid-body-td-left",sortable: true,render: procNameRender},
			{header: "周期",dataIndex: "RUN_FREQ",sortable: true,render: runFreqRender},
			{header: "日期批次",dataIndex: "DATE_ARGS",align: "left",sortable: true,render: _argsRender},
			{header: "状态",dataIndex: "TASK_STATE",sortable: true,render: _stateIcon},
			{header: "Agent",dataIndex: "AGENT_CODE",sortable: true},
			{header: "当前责任人",dataIndex: "CURDUTYER",sortable: true},
			{header: "创建时间",dataIndex: "START_TIME",sortable: true},
			{header: "开始执行时间",dataIndex: "EXEC_TIME",sortable: true},
			{header: "执行结束时间",dataIndex: "END_TIME",sortable: true},
			{header: "运行时长",dataIndex: "USE_TIME",sortable: true}	
		]
	});
});
	
function removeManualOptionList(){
	var e = $(this);
	if($(".task-state-option.open").length>0){
		$(".task-state-option.open").removeClass("open");
	}
}

function taskManualOption(obj){
	var _seqno = $(obj).attr("seq");
	var _workType = $(obj).attr("id");
    var task_status= $(obj).attr("task_status");
    var agent=$(obj).attr("agent");
	var execSql="";
	var res="";
	var _url="";
	var _date={};
	var _opFlag = false;
	if(_workType=="li_log" || _workType=="li_use_time" || _workType=="li_condi" || _workType=="li_running_log"){
		showDetail(_seqno, _workType);
	}else if(_workType=='li_pause'||_workType=='li_recover'){
		var alterStr = _workType=='li_pause'?"确定暂停程序?":"确定恢复程序?";
		if(confirm(alterStr)){
			_url = '/'+contextPath+'/taskOpt/'+ (_workType=='li_pause'?'pauseTask':'recoverTask');
			_data = {
				"seqno": _seqno
			};
			_opFlag =  true;
		}
	}else if(_workType=='li_set_priv'){
		if(confirm("确定调整优先级?")){
			var _level = $(obj).attr("name")
			_url = '/'+contextPath+'/taskOpt/setPriLevel';
			_data = {
				"seqno": _seqno,
				"prilevel": _level
			};
			_opFlag =  true;
		}
	}else if(_workType=='li_force_pass'){
		//showForcePassDialog(_seqno);
		if(confirm("确定要强制通过?")){
			_url = '/'+contextPath+'/taskOpt/forcePass';
			_data = {
				"seqno": _seqno,
				"prilevel": _level
			};
			_opFlag =  true;
		}
	}else if(_workType=='li_force_exec'){
		if(confirm("确定强制执行?")){
			_url = '/'+contextPath+'/taskOpt/forceExec';
			_data = {
				"seqno": _seqno
			};
			_opFlag =  true;
		}
	}else if(_workType=='li_stop'){
		if(confirm("停止任务?")){
			kill(_seqno,agent);

			//记录人工操作日志
			taskOpLog("'"+_seqno+"'","停止任务",'','');
		}
	//从错误步骤开始重做
	}else if (_workType=='li_redo_self_1'||_workType=='li_redo_after_1'){
		var _return_code = $(obj).attr("returncode")?$(obj).attr("returncode"):0;
		if(confirm("确定从第" + return_code + "步开始重做？")){
			var logStore = getValidStore(_seqno);
			if(!logStore) {
				alert("当前记录已失效，不能被重做！");
				return;
			}

			_url = '/'+contextPath+'/taskOpt/' + (_workType.indexOf("redo_self")>-1?"redoCur":"redoAfter");
			_data = {
				"seqno": _seqno,
				"returncode": _return_code
			};
			_opFlag =  true;

		}
	}else if (_workType=='li_redo_self'||_workType=='li_redo_after'||_workType=='li_redo_self_0'||_workType=='li_redo_after_0'){
		if(confirm("确定重做?")){
			var logStore = getValidStore(_seqno);
			if(!logStore) {
				alert("当前记录已失效，不能被重做！");
				return;
			}
			
			_url = '/'+contextPath+'/taskOpt/' + (_workType.indexOf("redo_self")>-1?"redoCur":"redoAfter");
			_data = {
				"seqno": _seqno
			};
			_opFlag =  true;
			
			//记录人工操作日志(后台记录操作日志)
			//taskOpLog("'"+_seqno+"'",_workType.indexOf("redo_self")>-1?"重做当前":"重做后续",sql1,res.success);
	  	}
	}
	
	if(_opFlag){
		$.ajax({
    		headers: {'Content-type': 'application/json;charset=UTF-8'},
			url: _url,
			data: _data,
			async:false,
			error:function(){     
		       alert('不能获取服务：'+ _url);
		       return;
		    },
			success:function(msg){
				var msg = $.parseJSON(msg);
				if(msg.flag==true||msg.flag=="true"){
				     log = msg.response;
				}else{
					alert('操作失败：' + msg.response);
					return false;
				}
			}
		});
	}
	
	refreshGrid(null);
}
	
function showForcePassDialog(seqno){	
	$("#dialog-ok").show();
	$(".modal-title").html("强制通过原因");
	$("#myModal").modal({
		show:true,
		backdrop:false
	});

	$("#upsertForm").empty();
	$("#dialog-ok").unbind("click");
	var _editPanel = new AI.Form({
		id: 'baseInfoForm',
		//store: tableStore,
		containerId: 'upsertForm',
		fieldChange: function(fieldName, newVal){},
		items: [
			{type : 'text', label : '通过原因', notNull: 'N', fieldName : 'PASS_REASON', width : 420 }
		]
	});
	
	//确定
	$("#dialog-ok").on('click', function(){
		if($("#PASS_REASON").val().trim()==""){
			alert("通过原因不能为空！")
			return false;
		}
		
		var sql= "update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where seqno='"+seqno+"' and task_state<>6 ";
		ai.executeSQL(sql,false,"METADBS");
		
		var sql1 ="select seqno from proc_schedule_script_log where seqno='"+seqno+"' ";
		var store1=ai.getStore(sql1,'METADBS');
		var sql2="";
		if(store1&&store1.count>0){
			sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+$("#PASS_REASON").val()+"') where seqno='"+seqno+"' ";
		}else{
			sql2=" insert into proc_schedule_script_log values('"+seqno+"',(select proc_name from proc_schedule_log where seqno='"+seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+$("#PASS_REASON").val()+"')"
		}			
		ai.executeSQL(sql2,false,"METADBS");
		_contentStore.select();
        $('#myModal').modal('hide');
	});
	
	$(".close-modal").click(function(){
		$('#myModal').modal('hide');
	});
	
	$("#myModal").modal({
		show:true,
		backdrop:false
	});
}

//多批次操作
function batchOptionDialog(seqno,xmlid,procName,dateArgs){	
	$("#dialog-ok").show();
	$("#dialog-ok").html("确定");
	$(".modal-title").html("多批次操作");
	$("#myModal").modal({
		show:true,
		backdrop:false
	});

	$("#upsertForm").empty();
	$("#dialog-ok").unbind("click");
	var _editPanel = new AI.Form({
		id: 'baseInfoForm',
		//store: tableStore,
		containerId: 'upsertForm',
		fieldChange: function(fieldName, newVal){},
		items: [
			{type : 'text', label : '程序名',isReadOnly:'y', fieldName : 'OPTION_PROC_NAME',value: procName },
			{type : 'text', label : '批次区间', notNull: 'N', fieldName : 'batch_range'},
			{type: 'radio',label : '操作类型', notNull: 'N',fieldName : 'OPTION_TYPE',storesql:'redo_cur,重做当前|redo_after,重做后续'}
	
		]
	});
	
	//修改批次区间显示
	var batch_range = '<input id="start_batch" type="text" class="form-control" style="width:100px; float:left" value="' + dateArgs + '">' +
					  '<span style="float:left"> - </span> ' +
					  '<input id="end_batch" type="text" class="form-control" style="width:100px; float:left" value="' + dateArgs + '">';
	$("#upsertForm").find("#batch_range").parent().html(batch_range);
	
	
	//确定
	$("#dialog-ok").on('click', function(){
		var startBatch = $("#start_batch").val().trim();
		var endBatch = $("#end_batch").val().trim();
		var optionType = getRadioValue("OPTION_TYPE");
		if(start_batch =="" || end_batch==""){
			alert("请填写批次区间！")
			return false;
		}
		if(optionType==""){
			alert("请选择操作类型！")
			return false;
		}
		var triggerFlag=0;
		var sql="";
		switch(optionType){
			case "redo_after":
				triggerFlag=0;
				break;
			case "redo_cur":
				triggerFlag=1;
				break;
			default:
				
				break;
		}
		var now = new Date().format("yyyy-mm-dd hh:mm:ss");
		sql= "update proc_schedule_log set task_state=0,status_time='"+now+"',trigger_flag="+triggerFlag+",queue_flag=0,return_code=0,exec_time=NULL,end_time=NULL where xmlid='"+xmlid+"' and date_args between '"+startBatch+"' and '"+endBatch+"' and valid_flag=0";
		var res = ai.executeSQL(sql,false,"METADBS");
		
		//记录操作日志
		taskOpLog("'"+seqno+"'","多批次"+ (optionType=="redo_cur"?"重做当前":"重做后续"),sql,res.success);
		_contentStore.select();
        $('#myModal').modal('hide');
	});
	
	$(".close-modal").click(function(){
		$('#myModal').modal('hide');
	});
	
	$("#myModal").modal({
		show:true,
		backdrop:false
	});
}

function getRadioValue(name){
	var radios = document.getElementsByName(name);
	var val="";
	$.each(radios,function(index,item){
		if(item.checked){
			val = item.value;
			return;
		}
	});
	return val;
}

//批量重做
function redoProc(type,data){
	var sql="";
	var _dateStr = new Date().format("yyyy-mm-dd hh:mm:ss");
	if(type=="cur"){
		sql="update proc_schedule_log set task_state=0,status_time='" + _dateStr + "',trigger_flag=1,queue_flag=0,return_code=0,exec_time=NULL,end_time=NULL where seqno in ({seqnos})  and ( task_state >=50 or task_state=6 )";
	}else{
		sql="update proc_schedule_log set task_state=0,status_time='" + _dateStr + "',trigger_flag=0,return_code=0,queue_flag=0,exec_time=NULL,end_time=NULL where seqno in ({seqnos}) and ( task_state >=50 or task_state=6 )";
	}
	
	var seqnos="";
	for(var i=0;i<data.length;i++){
		if(data[i].TASK_STATE >=6){
			//运行成功和运行失败方可重做
			seqnos +="'"+ data[i].SEQNO +"',"
		}
	}
	//没有可重做返回 -1
	if(seqnos.length==0){
		return -1;
	}else{
		seqnos = seqnos.substring(0,seqnos.length-1);
		sql = sql.replace('{seqnos}',seqnos);
		var res = ai.executeSQL(sql,false,"METADBS");
		//记录人工操作日志
		taskOpLog(seqnos,"批量重做"+type,sql,res.success);
		return 0;
	}
}

function getValidStore(seqno){
	var store = new AI.JsonStore({
		sql :"select * from proc_schedule_log where seqno='"+seqno+"' and valid_flag=0",
		table:'proc_schedule_log',
		key:"SEQNO",
		dataSource:"METADBS"
	});
	if(store.count>0)return store;
	return null;
}	

//获取当前时间
function getNowTime(){
	var d = new Date();
	var vYear = d.getFullYear();
	var vMon = d.getMonth() + 1;
	var vDay = d.getDate();
	var h = d.getHours();
	var m = d.getMinutes();
	var se = d.getSeconds();
	return vYear +"-"+(vMon<10 ? "0" + vMon : vMon)+"-"+(vDay<10 ? "0"+ vDay : vDay)+" "+(h<10 ? "0"+ h : h)+":"+(m<10 ? "0" + m : m)+":"+(se<10 ? "0" +se : se);
}

//生成seqno
function getSeqNo(){
	var now = new Date();
	now = now.format("yyyyMMddhhmmss") +"0"+ now.getMilliseconds();
	return now;
}


//日期格式化 yyyyMMddhhmmss--->yyyy-MM-dd hh:mm:ss
var formatDateArgs=function(dateArgs){
	var tmp = dateArgs.toString().trim();
	tmp =  tmp.replace(/-/g,"");
	tmp =  tmp.replace(":" ,"");
	tmp =  tmp.replace(" " ,"");
	var newStr = "";
	for(var i=0;i<tmp.length;i++){
		 if(i==3){
		 	newStr=newStr+tmp.charAt(i)+"-";
		 }else if(i==5){
		 	newStr=newStr+tmp.charAt(i)+"-";
		 }else if(i==7){
		 	newStr=newStr+tmp.charAt(i)+" ";
		 }else if(i==9){
		 	newStr=newStr+tmp.charAt(i)+":";
		 }else{
		 	newStr=newStr+tmp.charAt(i);
		 }
	}
	var finalChar = newStr.charAt(newStr.length-1);
	if(finalChar==" "||finalChar==":"||finalChar=="-"){
	   newStr=newStr.substring(0,newStr.length-1);
	}
	return newStr;
}