var page = { 
		teamCode: null,
		_queryPanel: null,
		_sql: null,
		_store: null,
	    init: function(){
	    	this._sql = " select op_obj,a.op_user,b.usecnname,a.op_user_ip,a.op_type,a.op_sql,a.op_time,a.op_state from schedule_op_log a " +
				        " left join metauser b on a.op_user = b.username " +
					    " WHERE op_type='log-clean' {where} order by a.op_time desc";
	    	this.initQueryPanel();
	    	this.initGrid();
	    },
	    initQueryPanel:function(){
	    	//查询面板
	    	var self = this;
	    	
	    	var _filter = new ve.FormWidget({
	    		config:{
	    			"class":"form",
	    			"formClass":"form-inline",
	    			"id": "view_total_up_total_tab_nav",
	    			"noJustfiyFilter":"on",
	    			"items": [
						{
							"id":"logClean",
							"value":"日志清理",
							"type":"button",
							"className":"search_btn btn-sm btn-danger",
						},
//	    				{
//	    					"type": "text",
//	    					"fieldLabel":"日期批次",
//	    					"id":"date_args",
//	    					"placeholder":"yyyy-MM-dd hh:mm",
//	    					//"format" : "yyyy-mm-dd",
//	    					"style": "width:130px;"
//	    				},
//	    				{
//	    					"type": "text",
//	    					"id":"task_name",
//	    					"fieldLabel":"",
//	    					"placeholder":"流程编号或名称",
//	    					"style": "min-width:220px;"
//	    				},
//	    				{
//	    					"id":"search",
//	    					"value":"查询",
//	    					"type":"button",
//	    					"className":"search_btn btn-sm btn-primary",
//	    				}
	    			],
	    			'events': {
	    				afterRender: function(){
	    					var _view = this;
	    					_view.$el.find("#logClean").append("<button class='btn btn-default' style='display:none'>清理中...</button>")
	    				},
	    				'click #search': function(){
	    					self.switchContent(self.getQueryCondi());
	    					self._totalPanel.render();
	    				},
	    				'click #logClean>button': function(){
	    					self.showDialog();
	    				}
	    			}
	    		}
	    	});
	    	_filter.$el = $('#filter');
	    	_filter.render();
	    },
	    initGrid: function(){
	    	var self = this;
	    	_store = new AI.JsonStore({
				sql: self._sql.replace("{where}",self.getQueryCondi()),
				dataSource: 'METADBS',
				pageSize: 12
	    	}) 
	    	var columns = [
				{header: "清理周期", dataIndex: 'OP_SQL', cls:"ai-grid-body-td-center",
					render: function(data,val){
						if(val){
							var data = eval("("+val+")");
							var cycle='';
							switch(data.run_freq){
							case 'year':
								cycle='年';
								break;
							case 'month':
								cycle='月';
								break;
							case 'day':
								cycle='日';
								break;
							case 'hour':
								cycle='时';
								break;
							case 'minute':
								cycle='分';
								break;
							}
							return cycle;
						}else{
							return '--';
						}
					}
				},
				{header: "清理截止日期", dataIndex: 'OP_SQL', cls:"ai-grid-body-td-center",
					render: function(data,val){
						if(val){
							var data = eval("("+val+")");
							return data.end_date;
						}else{
							return '--';
						}
					}
				},
				{header: "是否清理队列中任务", dataIndex: 'OP_SQL', cls:"ai-grid-body-td-center",
					render: function(data,val){
						if(val){
							var data = eval("("+val+")");
							return data.flag==1||data.flag=='1'?'是':'否';
						}else{
							return '--';
						}
					}
				},
				{header: "清理操作人", dataIndex: 'USECNNAME', cls:"ai-grid-body-td-center"},
				{header: "清理操作IP", dataIndex: 'OP_USER_IP', cls:"ai-grid-body-td-center"},
				{header: "清理时间", dataIndex: 'OP_TIME', cls:"ai-grid-body-td-center"},
				{header: "清理结果", dataIndex: 'OP_STATE', cls:"ai-grid-body-td-center",
					render: function(data,val){
						if(val=='true'||val==true){
							return '<span style="color:green">成功</span>'
						}else if(val=='false'||val==false){
							return '<span style="color:red">失败</span>'
						}else{
							return '<span style="color:yellow">处理中</span>'
						}
					}
				}
	    	];
	    	
	    	$("#tableList").empty();
	    	listGrid = new AI.Grid({
	    		id: 'view_config_grid',
				store: _store,
				containerId: 'tableList',
				showcheck: true,
				columns: columns
	    	});
	    	self._store = _store;
	    },
	    getQueryCondi: function(){
	    	var self = this;
	    	var _condi = "";

//	    	var dateArgs = $('#date_args input').val().trim();
//	    	if(dateArgs.length>0){
//	    		_condi+=" and a.date_args like '" + dateArgs + "%'";
//	    	}
//	    	
//	    	var taskName = $('#task_name input').val().trim();
//	    	if(taskName.length>0){
//	    		_condi+=" and a.proc_name like '%" + taskName + "%'";
//	    	}
//	    	
//	    	
//	    	//团队过滤
//    		if(typeof teamCode!="undefined" && self.teamCode!=null && teamCode.length>0){
//    			_condi += "  and a.team_code in ('" + teamCode + "')";
//    		}
    		
	    	return _condi;
	    },
	    switchContent: function(condi){
	    	var self = this;
	    	if(!condi||typeof(condi)=="undefined"){
	    		condi="";
	    	}

	    	condi += self.stateFilter[self.curStateIndex];//任务状态过滤
	    	this._store.select(self._sql.replace("{where}",condi));
	    	
	    },
	    validInput: function(data){
	    	for(var p in data){
	    		if(data[p]==undefined || data[p]==""){
	    	    	alert("未设置："+p);
	    	    	return false;
	    	    }
	    	} 
	    	return true;
	    },
	    showDialog: function(xmlid){
	    	$("#upsertForm").empty();
	    	$("#dialog-ok").unbind("click");
	    	$(".close-modal").unbind("click");
	    	var formcfg = ({
	    		id: 'view_config_form',
	    		containerId: 'upsertForm',
	    		items: [
	    			{type: 'combox',label: '清理周期',fieldName: 'RUN_FREQ',storesql:'year,年|month,月|day,日|hour,时|minute,分',isReadOnly:"n",notNull:'N'},
	    			{type: 'date',label: '截止日期',fieldName: 'END_DATE',isReadOnly: "n",notNull:'N'},
	    			{type:  "radio-custom", label: "是否清理队列中任务", fieldName: "FLAG",storesql:'1,是|0,否',isReadOnly:"n",notNull:'N'}
	    		],
	    		
	    	});

	    	var from = new AI.Form(formcfg);
	    	
	    	//确定
	    	$("#dialog-ok").on('click', function(){
	    		var run_freq = $("#upsertForm").find("#RUN_FREQ").val();
	    		var end_date = $("#upsertForm").find("#END_DATE").val();
	    		var flag = $("#upsertForm").find("input[name='FLAG']:checked").val();
	    		var data = {
	    				"清理周期": run_freq,
	    				"截止日期": end_date,
	    				"是否清理队列中任务": flag
		    		}
	    		if(!page.validInput(data))return false;
	    		var _url = '/'+contextPath+'/taskOpt/logClean';
	    		var _data = {
    				run_freq: run_freq,
    				end_date: end_date,
    				flag: flag
	    		}
	    		
	    		var obj = "logClean-"+new Date().getTime();
	    		//记录操作日志
	    		logCleanLog(obj,"log-clean",JSON.stringify(_data),false);
	    		
	        	$.ajax({
	        		headers: {'Content-type': 'application/json;charset=UTF-8'},
	    			url: _url,
	    			data: _data,
	    			//async: false,
	    			error:function(msg){     
	    		       alert('清理失败！');
	  				   var sql="update schedule_op_log set op_state='false' where op_obj='"+obj+"' ";
					   ai.executeSQL(sql,false,"METADBS");
	    		       return;
	    		    },
	    		    beforeSend:function(){
	    				$("#logClean").find("button").toggle();
	    			},
	    			complete:function(){
	    				$("#logClean").find("button").toggle();
	    			},
	    			success:function(msg){
	    				var msg = $.parseJSON(msg);
	    				if(msg.flag==true||msg.flag=="true"){
	    				     var sql="update schedule_op_log set op_state='true' where op_obj='"+obj+"' ";
	    				     ai.executeSQL(sql,false,"METADBS");
	    				     alert(msg.response);
	    				}else{
	    					alert('清理失败：' + msg.response);
	 	  				    var sql="update schedule_op_log set op_state='false' where op_obj='"+obj+"' ";
						    ai.executeSQL(sql,false,"METADBS");
	    				}
	    				page._store.select();
	    			}
	    		});
	    		
	            $('#myModal').modal('hide');
	    	});
	    	//取消
	    	$(".close-modal").click(function(){
	    		$('#myModal').modal('hide');
	    	});
	    	
	        $('#myModal').modal({
	    		show : true,
	    		backdrop:false
	    	});
	    }
	};
	