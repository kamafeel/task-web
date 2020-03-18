var page = { 
	teamCode: null,
	_totalPanel: null,
	_queryPanel: null,
	_totalStore: null,
	taskListStore: null,
	_totalSql: null,
	_taskSql: null,
	isFilterMore: false,
	curStateIndex: 0,//选择任务状态索引
	stateFilter: [//状态索引对应条件
    	" and task_state >= -7 ",
      	" and task_state = -7 ",
      	" and task_state = 0 ",
      	" and task_state = 1 ",
      	" and task_state = 2 ",
      	" and task_state = 3 ",
      	" and task_state in (-1,-2,-3) ",
      	" and task_state in (4,5) ",
      	" and task_state = 6 ",
      	" and task_state >=50 "
	],
	searchType: "m-simple",//默认去重
	__init__ : function(options) {
		this.teamCode = options.teamCode || _UserInfo.teamCode;
    	this.init();
    },
    init: function(){
    	this._taskSql = " select a.seqno,a.xmlid,a.pri_level,a.proc_name,a.platform,a.agent_code,a.run_freq,a.task_state,a.status_time,a.start_time,a.exec_time,a.end_time,a.use_time,a.date_args,'' duration,a.time_win,a.return_code,a.proc_date,a.valid_flag,a.proctype,a.trigger_flag,a.queue_flag," +
		    			" b.proccnname,b.topicname,b.level_val,b.creater,b.curdutyer," +
		    			" c.on_focus,c.dura_max " +
						" from proc_schedule_log a " +
						" left join proc b on a.xmlid = b.xmlid " +
						" left join proc_schedule_info c on a.xmlid=c.xmlid " + 
						" where 1=1 {where}";
    	this._totalSql = " select count(*) as total, sum(case when task_state=6 then 1 else 0 end ) as success, sum(case when task_state in (4,5) then 1 else 0 end ) as running, sum(case when task_state in (-1,-2,-3) then 1 else 0 end ) as pause, sum(case when task_state=3 then 1 else 0 end ) as wait, sum(case when task_state=2 then 1 else 0 end ) as pass,sum(case when task_state=1 then 1 else 0 end ) as created , sum(case when task_state=0 then 1 else 0 end) as redo , sum(case when task_state=-7 then 1 else 0 end) as notrigger, sum(case when task_state>=50 then 1 else 0 end ) as fail " +
		   			     " from (select a.task_state from  proc_schedule_log a left join proc b on a.xmlid = b.xmlid  left join proc_schedule_info c on a.xmlid = c.xmlid where 1=1 {where}) t ",
    	this.initTotalPanel();
    	this.initQueryPanel();
    	this.initGrid();
    	this.initTotalData();
    	this.initTreeView();
    },
    initTotalPanel: function(){
    	//统计面板
    	var _totalPanel = new ve.HtmlWidget({
    		config:{
    			"className": "html",
    			"id": "view_total_up_total_id",
    			"template":'<ul class="totalPanel">'+
								'<li class="total-li">'+
									'<dt class="">运行成功率</dt>'+
									'<dd class=""><%=successRate%>%</dd>'+
								'</li>'+
								'<li class="total-li active" total-index="0">'+
									'<dt class="total-title">总任务(个)</dt>'+
									'<dd class="total-val"><%=total%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="1">'+
									'<dt class="total-title">未触发</dt>'+
									'<dd class="total-val"><%=notrigger%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="2">'+
									'<dt class="total-title">重做等待</dt>'+
									'<dd class="total-val"><%=redo%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="3">'+
									'<dt class="total-title">创建成功</dt>'+
									'<dd class="total-val"><%=created%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="4">'+
									'<dt class="total-title">依赖通过</dt>'+
									'<dd class="total-val"><%=pass%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="5">'+
									'<dt class="total-title">排队等待</dt>'+
									'<dd class="total-val"><%=wait%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="6">'+
									'<dt class="total-title">暂停任务</dt>'+
									'<dd class="total-val"><%=pause%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="7">'+
									'<dt class="total-title">正在执行</dt>'+
									'<dd class="total-val"><%=running%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="8">'+
									'<dt class="total-title">执行成功</dt>'+
									'<dd class="total-val"><%=success%></dd>'+
								'</li>'+
								'<li class="total-li" total-index="9">'+
									'<dt class="total-title">执行失败</dt>'+
									'<dd class="total-val"><%=fail%></dd>'+
								'</li>'+
							'</ul>',
    			"events":{
    				afterRender:function(){
    					var _view = this;
    					
    			  		var success = _totalStore.curRecord.data.SUCCESS;
    			  		var fail = _totalStore.curRecord.data.FAIL;
    			  		var running = _totalStore.curRecord.data.RUNNING;
    			  		var notrigger= _totalStore.curRecord.data.NOTRIGGER;
    			  		var wait = _totalStore.curRecord.data.WAIT;
    			  		var pass = _totalStore.curRecord.data.PASS;
    			  		var pause = _totalStore.curRecord.data.PAUSE;
    			  		var created = _totalStore.curRecord.data.CREATED;
    			  		var redo = _totalStore.curRecord.data.REDO;
    			  		var total = _totalStore.curRecord.data.TOTAL;
    			  		
    			  		success = success==undefined||success==null?0:success;
    			  		fail = fail==undefined||fail==null?0:fail;
    			  		running = running==undefined||running==null?0:running;
    			  		wait = wait==undefined||wait==null?0:wait;
    			  		pass = pass==undefined||pass==null?0:pass;
    			  		pause = pause==undefined||pause==null?0:pause;
    			  		created = created==undefined||created==null?0:created;
    			  		redo = redo==undefined||redo==null?0:redo;
    			  		notrigger = notrigger==undefined||notrigger==null?0:notrigger;
    			  		
    			  		var successRate = (success*100/(total==0?1:total)).toFixed(2);
    			  		_view.$el.addClass('info-general').empty().append(_.template(_view.config.template)({
    			  			'total': total,
    			  			'successRate': successRate,
    			  			'redo': redo,
    			  			'notrigger': notrigger,
    			  			'created': created,
    			  			'wait': wait,
    			  			'pass': pass,
    			  			'pause': pause,
    			  			'running': running,
    			  			'success': success,
    			  			'fail': fail
    		  			}));

						_view.$el.find(".totalPanel .total-li").removeClass("active");
						$(".total-li[total-index="+page.curStateIndex+"]").addClass("active");
    					_view.$el.find(".total-val").on('click',function(e){
    						_view.$el.find(".totalPanel .total-li").removeClass("active");
    						$(e.currentTarget).parent().addClass("active");
    						page.curStateIndex = $(e.currentTarget).parent().attr("total-index");
    						var _state_condi = page.stateFilter[page.curStateIndex];
    						page.switchContent(page.getQueryCondi());
    			  		});

    				}
    			}
    		}
    	});
    	_totalPanel.$el = $('#totalPanel');
    	this._totalPanel = _totalPanel;
    },
    initTotalData:function(){

    	_totalStore = new AI.JsonStore({
    	    //key:'XMLID',
    	    //service: 'api/dps/meta/distributeCount',
    		sql: page._totalSql.replace("{where}",page.getQueryCondi()),
    		dataSource:"METADBS"
    	});
    	//_totalStore.select({param:page.getQueryCondi()});
    	page._totalPanel.render();
    	page._totalStore = _totalStore;
    },
    initQueryPanel:function(){
    	//查询面板
    	var _filter = new ve.FormWidget({
    		config:{
    			"class":"form",
    			"formClass":"form-inline",
    			"id": "view_total_up_total_tab_nav",
    			"noJustfiyFilter":"on",
    			"items": [
    				{
    					"type": "text",
    					"fieldLabel":"日期批次",
    					"id":"date_args",
    					"placeholder":"yyyy-MM-dd hh:mm",
    					//"format" : "yyyy-mm-dd",
    					"style": "width:130px;"
    				},
    				{
    					"type": "text",
    					"id":"task_name",
    					"fieldLabel":"",
    					"placeholder":"任务名",
    					"style": "min-width:220px;"
    				},
    				{
    					"id":"search",
    					"value":"查询",
    					"type":"button",
    					"className":"search_btn btn-sm btn-primary",
    				},
//	    				{
//	    					"id":"batch_option",
//	    					"value":"批量重做",
//	    					"type":"button",
//	    					"className":"search_btn btn-sm btn-primary",
//	    				},
    				{
    					"id":"switch-mode",
    					"value":"",
    					"type":"button",
    					"className":"search_btn btn-sm btn-primary",
    				},
					{
						"id":"export-to-excel",
						"value":"导出数据",
						"type":"button",
						"className":"search_btn btn-sm btn-primary",
					},
    				{
    					"id":"moreBtn",
    					"value":"更多",
    					"type":"button",
    					"className":"search_btn btn-sm btn-primary",
    				}
    				
    			],
    			'events': {
    				afterRender:function(){
    					var _view = this;
    					//_view.$el.find("#date_args").append('<input id="hour_args" type="text" class="form-control formElement" style="width:50px;" placeholder="小时">')
    					//_view.$el.find("#date_args").append(':<input id="minute_args" type="text" class="form-control formElement" style="width:50px;"  placeholder="分钟">')

    					_view.$el.find("#date_args").css("margin-left","15px");
    					_view.$el.find("#batch_option .btn").attr("data-toggle","dropdown"); 
    					_view.$el.find("#batch_option .btn").append('<span class="caret"></span>');
    					var batchOptionList = '<ul class="dropdown-menu" role="menu">'+
					    					  	'<li><a id="li_batch_redo_self">重做当前</a></li>'+
					    						'<li><a id="li_batch_redo_after">重做后续</a></li>'
					    					  '</ul>';
    					_view.$el.find("#batch_option").append(batchOptionList);

    					//日期批次默认显示前一天
    					var today = new Date();
    					today.setDate(today.getDate()-1);
    					var defaultShowDate = today.format("yyyy-mm-dd");
    					_view.$el.find("#date_args input").val(defaultShowDate);
    					
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
    					_view.$el.find("#m-simple,#m-all").on("click",function(e){
    						//if(!page.validInput())return false;
    						page.searchType = $(e.currentTarget).attr("id");
    						if(page.searchType == "m-simple"){
    							$("#batch_redo_self").show();
    							$("#batch_redo_after").show();
    						}else{
    							$("#batch_redo_self").hide();
    							$("#batch_redo_after").hide();
    						}
    						page.switchContent(page.getQueryCondi());
    				   });
    					
    					if(paramMap.dtime){
    						_view.$el.find("#start_time").val(paramMap.dtime);
    					}
    				},
    				'click #search':function(){
						//if(!page.validInput())return false;
    					page.switchContent(page.getQueryCondi());
    					page._totalPanel.render();
    				},
    				'click #moreBtn':function(){
    					if($("#moreFilter").hasClass("hide")){
    						$("#moreFilter").removeClass("hide");
    						$("#moreBtn button").text("隐藏");
    						page.isFilterMore = true;
				    	}else{
				    		$("#moreFilter").addClass("hide");
    						$("#moreBtn button").text("更多");
    						page.isFilterMore = false;
				    	}
    				},
    				'click #li_batch_redo_self,#li_batch_redo_after':function(e){//批量重做
    					var selected = listGrid.getCheckedRows();
    					var _workType = $(e.currentTarget).attr("id");
    					if(selected.length==0){
    						alert("至少选中一个可重做项");					
    					}else{
    						if(_workType=='li_batch_redo_self'){
    							if(confirm("确定所选项都要重做当前吗？")){
    								redoProc("cur",selected);						
    								//刷新版面
    								switchContent(getQueryCondi());
    							}
    						}else if(_workType=='li_batch_redo_after'){
    							if(confirm("确定所选项都要重做后续吗？")){
    								redoProc("after",selected);
    								//刷新版面
    								switchContent(getQueryCondi());
    							}
    						}
    						
    					}
    				},
    				'click #export-to-excel':function(e){
    					var header = [
    					              {"label":'程序名称',"dataIndex":"PROC_NAME"},
    					              {"label":'周期',"dataIndex":"CYCLE"},
    					              {"label":'Agent',"dataIndex":"AGENT_CODE"},
    					              {"label":'状态',"dataIndex":"TASK_STATUS"},
    					              {"label":'当前责任人',"dataIndex":"CURDUTYER"},
    					              {"label":'创建时间',"dataIndex":"START_TIME"},
    					              {"label":'开始执行时间',"dataIndex":"EXEC_TIME"},
    					              {"label":'执行结束时间',"dataIndex":"END_TIME"},
    					              {"label":'运行时长',"dataIndex":"DURATION"},
    					              {"label":'批次号',"dataIndex":"DATE_ARGS"}
    					             ];
    					var contextPath = location.pathname.split('/')[1]||'';
    			        contextPath = '/'+contextPath+'/ve/download';
    			        
    			        var sql= " select proc_name,run_freq,agent_code,task_state,curdutyer,start_time,exec_time,end_time,date_args,"
    				        	  + " case run_freq  "
    				        	  + " when 'year' then '年' "
    				        	  + " when 'month' then '月' "
    				        	  + " when 'day' then '日' "
    				        	  + " when 'hour' then '时' "
    				        	  + " when 'minute' then '分' "
    				        	  + " when 'manual' then '手工任务' "
    				        	  + " else '--' end as cycle, "
    				        	  + " case "
    				        	  + " when task_state = -7 then '未触发' "
    				        	  + " when task_state = -6 then '失效' "
    				        	  + " when task_state = -5 then '等待中断' "
    				        	  + " when task_state in (-3, -2, -1) then '暂停任务' "
    				        	  + " when task_state = 0 then '重做后续' "
    				        	  + " when task_state = 1 then '创建成功' "
    				        	  + " when task_state in (2,3) then '排队等待' "
    				        	  + " when task_state = 4 then '发送agent' "
    				        	  + " when task_state = 5 then '正在运行' "
    				        	  + " when task_state = 6 then '运行成功' "
    				        	  + " else '运行失败' end as task_status, "
    				        	  + " case when end_time is null then '--' when exec_time is null then '--' else use_time end as duration "  
    			        	   + " from ( " + taskListStore.sql + " ) t ";
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
    	_filter.$el = $('#filter');
    	_filter.render();
    	
    	var _moreFilter = new ve.FormWidget({
    		config:{
    			"class":"form",
    			"formClass":"form-inline",
    			"id": "view_total_up_total_tab_nav",
    			"noJustfiyFilter":"on",
    			"items": [
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
						"type": "timebetween",
						"id":"timebetween",
						"startTimeId":"start_time",
						"endTimeId":"end_time",
						"fieldLabel":"创建时间范围",
						"placeholder":"创建时间范围",
						"format" : "yyyy-mm-dd",
						"style": "min-width:80px;width:100px;"
					}
    			],
    			'events': {
    				afterRender:function(){
    					var _view = this;
    					_view.$el.find("#run_freq_select").css("margin-left","15px");
    					
    					var today = new Date();
    					//默认时间区间
    					_view.$el.find("#end_time").val(today.format("yyyy-mm-dd"));
    					today.setDate(today.getDate()-1);
    					_view.$el.find("#start_time").val(today.format("yyyy-mm-dd"));
    				},
    				'change #agent_code_select select':function(e){
    					page.switchContent(page.getQueryCondi());
    				},
    				'change #run_freq_select select':function(e){
    					page.switchContent(page.getQueryCondi());
    				}
    			}
    		}
    	});
    	_moreFilter.$el = $('#moreFilter');
    	_moreFilter.render();
    },
    getSelect: function(){
    	var selected = listGrid.getCheckedRows();
				if(selected.length==0){
					alert("未选中任何数据！");	
					return null;
				}else if(selected.length==1){
					return selected;
				}
    },
    initTreeView: function(){
    	var json = []
    	var _url = "/" + contextPath + "/task/getTheme";
    	$.ajax({
    		headers: {'Content-type': 'application/json;charset=UTF-8'},
			url: _url,
			data: {
				team_code: page.teamCode
			},
			async:false,
			error:function(){     
		       alert('请求服务：'+ _url + '失败！');
		       return;
		    },
			success:function(data){
				if(data){
					json=JSON.stringify(data);
				}
			}
		});
    	
        var $tree = $('#treeView').treeview({
         	expandIcon: "glyphicon glyphicon-plus",
 			collapseIcon: "glyphicon glyphicon-minus",
 			nodeIcon: "glyphicon glyphicon-user",
 			color: "#428bca",
 			backColor: "#fff",
 			onhoverColor: "#f5f5f5",
 			borderColor: "#d8d8d8",
 			showBorder: true,
 			showTags: true,
 			highlightSelected: true,
 			selectedColor: "#fff",
 			selectedBackColor: "#428bca",
 			data: json,
 			collapseAll: true,
 			onNodeSelected: function(event, data) {
 	    		var selectVal = data.fullVal;
 				var nodeCondi = " and c.task_group like '" + selectVal + "%'";
 				page.nodeCondi = nodeCondi;
 				nodeCondi += page.getQueryCondi();
 				nodeCondi += page.stateFilter[page.curStateIndex];//任务状态过滤
 				page.taskListStore.select(page._taskSql.replace("{where}",nodeCondi));
 				page._totalStore.select(page._totalSql.replace("{where}",nodeCondi));
 				page._totalPanel.render();
 			},
		    onNodeUnselected: function(event, data) {
		    	page.nodeCondi = null;
		    }
         });
         $('#treeView').treeview('collapseAll', { silent: true });
    },
    initGrid: function(){
    	taskListStore = new AI.JsonStore({
    	    /* key: 'XMLID',
    	    service: 'api/dps/meta/distributeList',
			dataSource: 'METADBS',
			pageSize: 12 */
			sql: page._taskSql.replace("{where}",page.getQueryCondi()),
			dataSource: 'METADBS'
    	}) 
    	var columns = [
    		{header:"程序名称",dataIndex:'PROC_NAME',sortable:true,cls: "ai-grid-body-td-left"},
    		{header:"周期",dataIndex:'RUN_FREQ',sortable:true,render: function(data) {
				return page.renderFreq(data.get('RUN_FREQ')); 
			}},
    		{header:"日期批次",dataIndex:'DATE_ARGS',sortable:true},
    		{header:"状态",dataIndex:'TASK_STATE',sortable:true,
    			render: function(data,val){
    				return page.renderStatus(data,val);
    			}
    		},
			//{header:"所属域",dataIndex:'TOPICNAME',sortable:true},
			{header:"执行Agent",dataIndex:'AGENT_CODE',sortable:true},
    		{header:"创建时间",dataIndex:'START_TIME',sortable:true},
    		{header:"开始执行时间",dataIndex:'EXEC_TIME',sortable:true},
    		{header:"执行结束时间",dataIndex:'END_TIME',sortable:true},
    		{header:"运行时长",dataIndex:'USE_TIME',sortable:true},
    		{header:"当前负责人",dataIndex:'CURDUTYER',sortable:true}
    	];
    	
    	$("#taskList").empty();
    	//taskListStore.select({param:page.getQueryCondi()});
    	listGrid = new AI.Grid({
    		id: 'tasktable',
			containerId: 'taskList',
			store: taskListStore,
			showcheck: true,
			rightclick: rightClick,
			pageSize: 12,
			columns: columns
    	});
    	page.taskListStore = taskListStore;
    	
    	function rightClick(rowIndex,record){
    		var _seqno = record.data.SEQNO;
    		var _xmlid = record.data.XMLID;
    		var _agent = record.data.AGENT_CODE;
    		var _state = record.data.TASK_STATE;
    		var _procType = record.data.PROCTYPE;
    		var _valid_flag = record.data.VALID_FLAG;
    		
    		//公共菜单，所有状态都能查看
    		var showTaskInfo = { 
					text: "查看调度配置",
					func: function(){ page.showProcScheduleInfo(_xmlid) }
			}

    		var showCondi = { 
    				text: "查看依赖", 
    				func: function(){ page.showDetail(_seqno,'li_condi') } 
    		};
    		var showTransflow = { 
					text: "查看流程图",
					func: function(){ page.showDetail(_seqno,"flow") }
			}

    		//可选菜单配置
    		var showLog = { 
    				text: "查看日志", 
    				func: function(){page.showDetail(_seqno,'li_log')} 
    		};
    		var showRunningLog = { 
    				text: "运行日志", 
    				func: function(){page.showDetail(_seqno,'li_running_log')} 
    		};
    		var showUseTime = { 
    				text: "时长分析", 
    				func: function(){page.showDetail(_seqno,'li_use_time')} 
    		};
    		//任务干预
    		var options={};
    		var redoTask = {
					text: "重做任务",
    				func: function(){
    					page.showRedoModal(_seqno,_state,_procType);
    				} 
    		};
    		var forceExec = { 
    				text: "强制执行",
    				func: function(){
    					if(confirm("确定要强制执行该任务吗？")){
        					options={
        							type:"forceExec",
        							data:{
        								"seqno": _seqno
        							}
        					}
        					page.opAjax(options);
    					}
    				} 
    		};
    		var forcePass = { 
    				text: "强制通过",
    				func: function(){
    					if(confirm("确定要强制通过该任务吗？")){
	    					options={
	    							type:"forcePass",
	    							data:{
	    								"seqno": _seqno
	    							}
	    					}
	    					page.opAjax(options);
    					}
    				} 
    		};
    		var pauseTask = { 
    				text: "暂停任务",
    				func: function(){
    					if(confirm("确定要暂停该任务吗？")){
	    					options={
	    							type: 'pauseTask',
	    	    					data: {
	    	    						"seqno": _seqno
	    	    					}
	    					}
	    					page.opAjax(options);
    					}
    				} 
    		};
    		var recoverTask = { 
    				text: "恢复任务",
    				func: function(){
    					if(confirm("确定要恢复该任务吗？")){
	    					options={
	    							type: 'recoverTask',
	    	    					data: {
	    	    						"seqno": _seqno
	    	    					}
	    					}
	    					page.opAjax(options);
    					}
    				} 
    		};
    		var stopTask = { 
    				text: "停止任务",
    				func: function(){
    					if(confirm("确定要停止该任务吗？")){
    						page.killTask(_seqno,_agent);
    					}
    				} 
    		};
    		
    		function setPriv(level){
				options={
						type: 'setPriLevel',
    					data: {
    						"seqno": _seqno,
    						"prilevel": level
    					}
				}
				page.opAjax(options);
    		}
    		var setPriLevel = { 
    				text: "调整优先级",
					data:[[
							{ text: "高(20)",  func: function(){ setPriv(20) } },
							{ text: "高于正常(15)",  func: function(){ setPriv(15) } },
							{ text: "正常(10)",  func: function(){ setPriv(10) } },
							{ text: "低于正常(5)",  func: function(){ setPriv(5) } },
							{ text: "低(1)",  func: function(){ setPriv(1) } }
					]] 
			};
    		
    		var optionMenu = [[]];
    		
    		//根据不同的任务状态，展示右键菜单
    		switch(_state){
    		case -7:
    			optionMenu = [[
    							forceExec
    		    			]];
    			break;

    		case -3:
    		case -2:
    		case -1:
    			optionMenu = [[
								recoverTask
    		    			]];
    			break;
    			
    		case 0:
    			break;
    			
    		case 1:
    			optionMenu = [[
    							forceExec,
    							forcePass,
    							pauseTask,
    							setPriLevel
    		    			]];
    			break;
    		case 2:
    		case 3:
    			optionMenu = [[
    							forcePass,
    							pauseTask,
    							setPriLevel
    		    			]];
    			break;

    		case 4:
    			break;
    			
    		case 5:
    			optionMenu = [[
    							showRunningLog,
    							stopTask
    		    			]];
    			break;
    			
    		case 6:
    			optionMenu = [[
    							showLog,
    							redoTask,
    							showUseTime
    		    			]];
    			break;
    		case 8:
    			break;
    			
			default:
				if(_state>=50){
					optionMenu = [[
	    							showLog,
	    							redoTask,
	    							forcePass,
	    							showUseTime
	    		    			]];
				}else{
					optionMenu = [[]];
				}
				break;
    		}
    		
    		//右键菜单
    		var MenuData = [[
    		     		    //公共菜单
    		     		    showTaskInfo,
    		     		    showCondi,
    		     		    showTransflow
    		     		  ]];
    		//可选操作
    		if(optionMenu[0].length>0){
    			MenuData[0].push({
	   				text: "执行操作",
	   				data: optionMenu
				})
    		}
    		
    		//失效任务只可以查看任务配置
    		if(_valid_flag!=0){
    			MenuData=[[showTaskInfo]];
    		}
    		
			$.smartMenu.remove();
			$("#taskList table tr").smartMenu(MenuData);
		};
    },
    renderFreq: function(freq){
		switch(freq){
			case "year":
				return '年';
				break;
			case "month":
				return '月';
				break;
			case "day":
				return '日';
				break;
			case "hour":
				return '小时';
				break;
			case "minute":
				return '分钟';
				break;
			case "week":
				return '周';
				break;
			case "holiday":
				return '节假日';
				break;
		}
	},
	renderStatus: function(data,val){
		var _status = data.get('TASK_STATE');
		var _triggger_flag = data.get('TRIGGER_FLAG');
		var _valid_flag = data.get('VALID_FLAG');
		
//		var time = this._timeDiffRender(data);
//		var stime = time=="--"?0:(Math.floor(time.split(":")[0])*60*60+Math.floor(time.split(":")[1])*60 + Math.floor(time.split(":")[2]));//计算出秒
//		var durMax = data.get('DURA_MAX')==undefined?0:data.get('DURA_MAX');//平均秒
//		var perCent = stime>=durMax?99:parseInt(stime/durMax*100);
		
		var statusClass = "btn-default";
		var statusText = _status;
		switch(_status){
		case -7:
			statusClass = "btn-warning";
			statusText = "未触发";
			break;
		case -5:
			statusClass = "btn-danger";
			statusText = "等待中断";
			break;
		case -3:
		case -2:
		case -1:
			statusClass = "btn-warning";
			statusText = "已暂停";
			break;
		case 0:
			statusClass = "btn-default";
			if(_triggger_flag=="0"){
				statusText = "重做后续";
			}else{
				statusText = "重做当前";
			}
			break;
		case 1:
			statusClass = "btn-default";
			statusText = "创建成功";
			break;
		case 2:
			statusClass = "btn-info";
			statusText = "依赖通过";
			break;
		case 3:
			statusClass = "btn-info";
			statusText = "排队等待";
			break;
		case 4:
			statusClass = "btn-primary";
			statusText = "发送agent";
			break;
		case 5:
			statusClass = "btn-warning";
			statusText = "正在运行";
			/*return '<div class="progress">'+
				'<div class="progress-bar progress-bar-info" role="progress" aria-valuenow="'+stime+'" aria-valuemin="0" aria-valuemax="'+durMax+'" style="width:'+perCent+'%">'+
					'<span>'+perCent+'%</span>'+
				'</div>'+
			'</div>'*/
			break;
		case 6 :
			statusClass = "btn-success";
			statusText = "执行成功";
			break;
		default:
			statusClass = "btn-danger";
			statusText = "执行失败";
			break;
		}
		//任务日志失效
		if(_valid_flag!=0){
			return '<div class="btn-group"><button type="button" class="btn btn-xs btn-gray" title="日志已失效">'+statusText+'</button></div>';
		}
		return '<div class="btn-group"><button type="button" class="btn btn-xs '+statusClass+'">'+statusText+'</button></div>';
	},
	_timeDiffRender:function(data){
    	var res = '--';
    	var start =data.get('EXEC_TIME');
    	var status = data.get('STATUS');
    	var currDate = new Date();
    	var end = status=="执行"?currDate.format("yyyy-mm-dd hh:mm:ss"):data.get('END_TIME');
    	if(start&&start.length>0&&end&&end.length>0){
    		start = start.replace(/-/g,"/");
    		end  = end.replace(/-/g,"/");
    		var _start = new Date(start);
    		var _end = new Date(end);
    		var diff = _end.getTime()-_start.getTime();
    		//计算出相差天数
    		var days=Math.floor(diff/(24*3600*1000))
    		//计算出小时数
    		var leave1=diff%(24*3600*1000)    
    		//计算天数后剩余的毫秒数
    		var hours=Math.floor(leave1/(3600*1000))
    		//计算相差分钟数
    		var leave2=leave1%(3600*1000)      
    		//计算小时数后剩余的毫秒数
    		var minutes=Math.floor(leave2/(60*1000))
    		//计算分钟后剩余毫秒数
    		var leave3=leave2%(60*1000)
    		var secords=Math.floor(leave3/(1000))
    		if(days>0){
    			hours += days*24;
    		}

    		var _hours = hours<=9?"0"+hours:""+hours;
    		var _minutes=minutes<=9?"0"+minutes:""+minutes;
    		var secords=secords<=9?"0"+secords:""+secords;
    		if(_minutes.length>0 && _hours.length>0){
    			res = _hours+":"+_minutes+":"+secords;
    		}else{
    			res =  "--";
    		}
    	}else {
    		res=="--";
    	}
    	return res;
    },
	renderKeyTak:function(data){
		if(data.get('ON_FOCUS')=='0'){
			return '否';
		}else{
			return '是';
		}
	},
    
    getQueryCondi: function(){
    	var _condi = "";
    	_condi += " and a.run_freq <> 'manual' ";//不展示手工任务
    	_condi += " and a.task_state >=-7 ";//有效状态
    	_condi += page.searchType == "m-simple"? " and a.valid_flag=0 ":"";//是否展示失效任务

    	var dateArgs = $('#date_args input').val().trim();
//	    	var hourArgs = $('#hour_args').val().trim();
//	    	var minuteArgs = $('#minute_args').val().trim();
    	if(dateArgs.length>0){
    		_condi+=" and a.date_args like '" + dateArgs + "%'";
    	}
    	
    	var taskName = $('#task_name input').val().trim();
    	if(taskName.length>0){
    		_condi+=" and a.proc_name like '%" + taskName + "%'";
    	}
    	
    	//更多过滤条件
    	if(page.isFilterMore){
    		var run_freq = $("#run_freq_select select").val();
    		if(run_freq.length>0){
    			_condi += " and a.run_freq='" + run_freq + "' ";
    		}
    		
    		var agent_code = $("#agent_code_select select").val();
    		if(agent_code.length>0){
    			_condi += " and a.agent_code='" + agent_code + "' ";
    		}
    		
    		var start_time = $("#start_time").val().trim();
    		if(start_time && start_time.length > 0){
    			_condi += " and a.start_time >= '" + start_time + " 00:00:00'";
    		} 

    		var end_time = $("#end_time").val().trim();
    		if(end_time && end_time.length > 0){
    			_condi += " and a.start_time <= '" + end_time + " 23:59:59'";
    		}
    		
    	}
    	
    	//团队过滤
		if(typeof page.teamCode!="undefined" && page.teamCode!=null && page.teamCode.length>0){
			_condi += "  and b.team_code in ('" + page.teamCode + "')";
		}

		if(page.nodeCondi){
			_condi += page.nodeCondi;
		}
		
    	return _condi;
    },
    switchContent: function(condi){
    	if(!condi||typeof(condi)=="undefined"){
    		condi="";
    	}

    	this._totalStore.select(page._totalSql.replace("{where}",condi));
    	
    	condi += page.stateFilter[page.curStateIndex];//任务状态过滤
    	this.taskListStore.select(page._taskSql.replace("{where}",condi));
    	
    	//重置左边树
    	//this.initTreeView();
    },
    refreshTotal:function(condi){
    	if(!condi||typeof(condi)=="undefined"){
    		condi="";
    	}
    	this.taskListStore.select(condi);
    },
    showProcScheduleInfo: function(xmlid){
        window.open("/" + contextPath + "/ftl/task/proschedInfoAdd?dataSource=METADBS&xmlid=" + xmlid);
    },
    showDetail: function(seqno, op) {
    	window.open("/" + contextPath + "/ftl/task/monitorDialog?seqno=" + seqno + "&op=" + op);
    },
    validInput: function(){
    	var date_args = $("#date_args input").val().trim();
    	if(date_args && date_args.length > 0){
    		 if(!/^((\d{4})|(\d{4}-\d{2})|(\d{4}-\d{2}-\d{2})|(\d{4}-\d{2}-\d{2} \d{2})|(\d{4}-\d{2}-\d{2} \d{2}:\d{2}))$/.test(date_args)){
    		 	alert("日期批次不是yyyy-MM-dd hh:mm格式");
    		 	return false;
    		 }
    	}
    	return true;
    },
    getRadioValue: function(name){
    	var radios = document.getElementsByName(name);
    	var val="";
    	$.each(radios,function(index,item){
    		if(item.checked){
    			val = item.value;
    			return;
    		}
    	});
    	return val;
    },
    showRedoModal: function(seqno,state,procType){
    	$("#dialog-ok").show();
    	$("#dialog-ok").html("确定");
    	$(".modal-title").html("任务重做");
    	
    	$("#myModal").modal({
    		show:true,
    		backdrop:false
    	});
    	
    	$("#upsertForm").empty();
    	$("#dialog-ok").unbind("click");
    	$(".close-modal").unbind("click");
    	var _redoPanel = new AI.Form({
    		id: 'baseInfoForm',
    		containerId: 'upsertForm',
    		fieldChange: function(fieldName, newVal){},
    		items: [
    		    {type: 'hidden',label : '', notNull: 'N',fieldName : 'OPTION_SEQNO',value:seqno},
    			{type: 'radio',label : '重做类型', notNull: 'N',fieldName : 'OPTION_TYPE',value:'redoCur',storesql:'redoCur,重做当前|redoAfter,重做后续'},
    			{type: 'radio',label : '开始位置', notNull: 'N',fieldName : 'REDO_POSITION',value:'0',storesql:'0,从0开始|1,从错误步骤开始'}
    	
    		]
    	});
    	
		if(state==6||procType!="dp"){
			$("#upsertForm").find("label[for='REDO_POSITION']").parent().hide();
		}
		
    	//确定
    	$("#dialog-ok").on('click', function(){
    		var _type = "redoCur";
    		var _returnCode=0;
    		var _seqno = $("#OPTION_SEQNO").val()
    		_type = page.getRadioValue("OPTION_TYPE");
    		_returnCode = page.getRadioValue("REDO_POSITION");
    		
			var options={
					type: _type,
					data: {
						"seqno": _seqno,
						"returncode": _returnCode
					}
			}
			page.opAjax(options);

            $('#myModal').modal('hide');
    	});
    	//取消
    	$(".close-modal").click(function(){
    		$('#myModal').modal('hide');
    	});
    	
    },
    opAjax: function(options){
    	var _url = '/'+contextPath+'/taskOpt/'+ options.type;
    	var _data = options.data;
    	
    	$.ajax({
    		headers: {'Content-type': 'application/json;charset=UTF-8'},
			url: _url,
			data: _data,
			async:false,
			error:function(){     
		       alert('请求服务：'+ _url + '失败！');
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
    },
    killTask: function(seqno,agentCode){
    	var _url = '/'+contextPath+'/syn/kill?SEQNO='+seqno+'&AGENT_CODE='+agentCode+'&SYN_TYPE=KILL_PROC'
    	$.ajax({ 
    		url: _url,
    		error:function(){     
    		       alert('请求服务'+_url+'失败！');     
    	    },
    		success:function(msg){
    			var msg = $.parseJSON(msg);
    			if(msg.flag==true||msg.flag=="true"){
    			     alert('终止任务成功');
    			     taskListStore.select();
    			}else{
    				alert('终止任务失败');     
    			}
    		}
      });
    }
};
	