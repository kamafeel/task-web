var bigfont = "bold 12pt Helvetica, Arial, sans-serif";
var smallfont = "bold 10pt Helvetica, Arial, sans-serif";
var flowSql=" select source,sourcetype,sourcefreq,target,targettype,targetfreq from transdatamap_design where 1=1 ";

var dateArgs = "";

var keys =[];
var ref=[];
//边界
var preMap = {};
var nextMap = {};


function textStyle() {
	return { 
		margin : 6,  
		wrap : go.TextBlock.WrapFit, 
		textAlign : "center", 
		editable : true, 
		font : bigfont 
	}
}
var getProcState = function(state){
	var state = state || -8;
	var category="";
	if(state == -7){
		category = "PROC_NOT_TRIGGER";
	}else if(state==0){
		category = "PROC_WAIT"
	}else if(state==5){
		category = "PROC_RUNING";
	}else if(state==6){
		category = "PROC_SUCCESS";
	}else if (state==3||state==2){
		category = "PROC_QUEUING";
	}else if (state==1){
		category = "PROC_CREATE";
	}else if (state<=-1&&state>=-3){
		category = "PROC_RECOVERY";
	}else if (state==-8){
		category = "PROC_NO_LOG";
	}else {
		category = "PROC_FAIL";
	}
	return category;
};

var getScopeState = function(state){
	return getProcState(state);
};

var getEventState= function(state){
	return "EVENT";
};

var getDataState=function(state){
	state = state || "-8";
	if(state == "1"){
		return "DATA_SUCCESS";
	}else{
		return "DATA";
	}
};

function getInterState(state){
	//var state = stateStore&&stateStore.count>0?stateStore.root[0]['CHECK_PUT_STATUS']:null;
	var state = state || null;
	switch(state){
		case "0":
			return "INTER_RUNING";
		case "1":
			return "INTER_FAIL";
		case "2":
			return "INTER_SUCCESS"
		default:
			return "INTER_INVALID";
	}
}

var checkKeyUnqi = function(objArray,key) {
	var _flag1 = true;
	for (var k = 0; k < objArray.length; k++) {
		if (objArray[k].key == key) {
			_flag1 = false;
		}
	}
	return _flag1;
};
var checkRefUnqi = function(objArray,from,to) {
	var _flag1 = true;
	for (var k = 0; k < objArray.length; k++) {
		if (objArray[k].from == from&&objArray[k].to==to) {
			_flag1 = false;
		}
	}
	return _flag1;
};

function getKeyVal(key){
	 switch(key){
	 	case "DATA":return "表：";
	 	case "PROC":return "程序：";
	 	case "INTER":return "接口：";
	 	case "EVENT":return "事件源：";
	 	case "FILE":return "文件：";
	 	case "SCOPE":return "指标组：";
	 	default:return "";
	 }
}

function getCategory(state,type){
	var category = "";
	switch(type){
		case "PROC":
			category = getProcState(state);
			break;
		case "EVENT":
			category = getEventState(state);
			break;
		case "SCOPE":
			category = getScopeState(state);
			break;
		case "INTER":
			category = getInterState(state);
			break;
		case "DATA":		
			category = getDataState(state);
			break;
		case "FILE":
			category = "FILE";
			break;
		default:
			break;
	}
	return category;
}


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

function getDataModel(data){
	keys =[];
	ref=[];
	keys.push({
			"key" : data.XMLID,
			"text": getKeyVal(data.NODE_TYPE) + data.PROC_NAME,
		    "category": getCategory(data.TASK_STATE, data.NODE_TYPE),
		    "status": getNodeStatus(data.TASK_STATE),
		    "dateArgs": data.DATE_ARGS,
		    "execTime": data.EXEC_TIME,
		    "endTime": data.END_TIME,
		    "useTime": data.USE_TIME
	});
	dateArgs = data.DATE_ARGS;
	preMap[data.XMLID]=[{
							xmlid:data.XMLID, 
							type:data.NODE_TYPE, 
							state:"", 
							text:"", 
							freq:""
						}];
	nextMap = JSON.parse(JSON.stringify(preMap));
}

//刷新
function  reLoad(data){
	getDataModel(data);
    myDiagram.model = new go.GraphLinksModel(keys, ref);
}

//初始加载
function loadDataFlow(data) {
	if (window.goSamples)
		goSamples(); // init for these samples -- you don't need to call this
	var $ = go.GraphObject.make; 
	// for conciseness in defining templates
    myDiagram=$(go.Diagram, "myDiagram");
    var yellowgrad = $(go.Brush, go.Brush.Linear, {0 : "rgb(254, 201, 0)",1 : "rgb(254, 162, 0)"});
    var blue       = $(go.Brush, go.Brush.Linear, {0 : "rgb(240,255,255)",1 : "rgb(230,255,255)"});
	var greengrad  = $(go.Brush, go.Brush.Linear, {0 : "#98FB98",1 : "#9ACD32"});
	var bluegrad   = $(go.Brush, go.Brush.Linear, {0 : "#B0E0E6",1 : "#87CEEB"});
	var redgrad    = $(go.Brush, go.Brush.Linear, {0 : "#C45245",1 : "#7D180C"});
	var whitegrad  = $(go.Brush, go.Brush.Linear, {0 : "#F0F8FF",1 : "#E6E6FA"});
	var radgrad    = $(go.Brush, go.Brush.Radial, {0: "rgb(240, 240, 240)", 1: "rgba(240, 240, 240, 0)" });
	var lavgrad    = $(go.Brush, go.Brush.Linear, {0: "#EF9EFA", 1: "#A570AD" });

	function returnContext(runState){
		var  contextMenu =""; 
		if(typeof(runState) == "undefined"){
			contextMenu =null;
		}
		if (runState=="") {
		 contextMenu=null;
		}
		if(runState=="PROC_SUCCESS"){
			contextMenu =$(go.Adornment, "Vertical", $("ContextMenuButton",
		        $(go.TextBlock, "重做后续"), { 
		        	click: function(e,obj){
		    			if(confirm("确定重做?")){
		    				var xmlid= obj.part.data.key;
		    				var dateArgs =obj.part.data.dataArgs;
							var execSql="update proc_schedule_log set task_state=0,trigger_flag=0,queue_flag=0,exec_time=NULL,end_time=NULL where xmlid ='"+xmlid+"' and date_args='"+dateArgs+"' and ( task_state >=50 or task_state=6 )";
							res=ai.executeSQL(execSql,false,"METADBS");
							reLoad(data);
						}
		        	} 
		        }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "重做当前"),{ 
		            	click: function(e,obj){
			            	if(confirm("确定重做?")){
								var xmlid= obj.part.data.key;
			    				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set task_state=1,trigger_flag=1,queue_flag=0,exec_time=NULL,end_time=NULL where xmlid ='"+xmlid+"' and date_args='"+dateArgs+"' and ( task_state >=50 or task_state=6 )";
								res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
							}
		            	} 
		            }
				)
			); 
		}
		
		if (runState=="PROC_NOT_TRIGGER") {
			contextMenu =$(go.Adornment, "Vertical",$("ContextMenuButton",
		            $(go.TextBlock, "强制通过"),
		            { 
		            	click: function(e,obj){
	        				var  message =  prompt("请填写原因");
	        				if(message==null||message==""){
	        					alert("请填写原因")
        						return false;
	        				}else{
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and task_state<>6 "
								res=ai.executeSQL(execSql,false,"METADBS");
								var findSeqno="select seqno from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
								res =ai.getStore(findSeqno,"METADBS");
								var _seqno=res.root[0]['SEQNO'];
								var sql1 ="select seqno from proc_schedule_script_log where seqno='"+_seqno+"' ";
								var store1=ai.getStore(sql1,'METADBS');
								var sql2="";
								if(store1&&store1.count>0){
								sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+message+"') where seqno='"+_seqno+"' ";
								}else{
									sql2=" insert into proc_schedule_script_log values('"+_seqno+"',(select proc_name from proc_schedule_log where seqno='"+_seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+message+"')"
								}			
								ai.executeSQL(sql2,false,"METADBS");
								reLoad(data);
	        				}	
		            	} 
		            }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "强制执行"),
		            { 
		            	click: function(e,obj){
		            		if(confirm("强制执行?")){
			            		var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=2,trigger_flag=0,queue_flag=0 where  xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and (task_state=1 or task_state=-7)"
			            		res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
		            		}
		            	} 
		            }
		    	)); 
		}
		if(runState=="PROC_QUEUING"){
			contextMenu=$(go.Adornment, "Vertical",$("ContextMenuButton",
		            $(go.TextBlock, "强制通过"),
		            { 
		            	click: function(e,obj){
	        				var  message =  prompt("请填写原因");
	        				if(message==null||message==""){
	        					alert("请填写原因")
        						return false;
	        				}else{
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and task_state<>6 "
								res=ai.executeSQL(execSql,false,"METADBS");
								var findSeqno="select seqno from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
								res =ai.getStore(findSeqno,"METADBS");
								var _seqno=res.root[0]['SEQNO'];
								var sql1 ="select seqno from proc_schedule_script_log where seqno='"+_seqno+"' ";
								var store1=ai.getStore(sql1,'METADBS');
								var sql2="";
								if(store1&&store1.count>0){
								sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+message+"') where seqno='"+_seqno+"' ";
								}else{
									sql2=" insert into proc_schedule_script_log values('"+_seqno+"',(select proc_name from proc_schedule_log where seqno='"+_seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+message+"')"
								}			
								ai.executeSQL(sql2,false,"METADBS");
								reLoad(data);
	        				}	
		            	} 
		            }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "暂停执行"),
		            { 
		            	click: function(e,obj){
		            	if(confirm("确定暂停任务?")){
								var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
		        				var findTaskState="select task_state from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
		        				res= ai.getStore(findTaskState,"METADBS");
								var task_state=res.root[0]['TASK_STATE'];
								var execSql= "update proc_schedule_log set TASK_STATE='"+(0-task_state)+"' where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and  task_state='"+task_state+"'";
								res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
							}
		            	} 
		            }
		    	));
		}
		if(runState=="PROC_RECOVERY"){
			contextMenu=$(go.Adornment, "Vertical",$("ContextMenuButton",
		            $(go.TextBlock, "强制通过"),
		            { 
		            	click: function(e,obj){
	        				var  message =  prompt("请填写原因");
	        				if(message==null||message==""){
	        					alert("请填写原因")
        						return false;
	        				}else{
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and task_state<>6 "
								res=ai.executeSQL(execSql,false,"METADBS");
								var findSeqno="select seqno from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
								res =ai.getStore(findSeqno,"METADBS");
								var _seqno=res.root[0]['SEQNO'];
								var sql1 ="select seqno from proc_schedule_script_log where seqno='"+_seqno+"' ";
								var store1=ai.getStore(sql1,'METADBS');
								var sql2="";
								if(store1&&store1.count>0){
								sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+message+"') where seqno='"+_seqno+"' ";
								}else{
									sql2=" insert into proc_schedule_script_log values('"+_seqno+"',(select proc_name from proc_schedule_log where seqno='"+_seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+message+"')"
								}			
								ai.executeSQL(sql2,false,"METADBS");
								reLoad(data);
	        				}	
		            	} 
		            }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "恢复任务"),
		            { 
		            	click: function(e,obj){
		            	if(confirm("确定恢复任务?")){
								var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var findTaskState="select task_state from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
		        				res= ai.getStore(findTaskState,"METADBS");
								var task_state=res.root[0]['TASK_STATE'];
								var execSql= "update proc_schedule_log set TASK_STATE='"+(0-task_state)+"' where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'  and  task_state='"+task_state+"'";
								res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
							}
		            	} 
		            }
		    	));
		}
		if(runState=="PROC_CREATE"){
			contextMenu= $(go.Adornment, "Vertical",$("ContextMenuButton",
		            $(go.TextBlock, "强制通过"),
		            { 
		            	click: function(e,obj){
	        				var  message =  prompt("请填写原因");
	        				if(message==null||message==""){
	        					alert("请填写原因")
        						return false;
	        				}else{
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and task_state<>6 "
								res=ai.executeSQL(execSql,false,"METADBS");
								var findSeqno="select seqno from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
								res =ai.getStore(findSeqno,"METADBS");
								var _seqno=res.root[0]['SEQNO'];
								var sql1 ="select seqno from proc_schedule_script_log where seqno='"+_seqno+"' ";
								var store1=ai.getStore(sql1,'METADBS');
								var sql2="";
								if(store1&&store1.count>0){
								sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+message+"') where seqno='"+_seqno+"' ";
								}else{
									sql2=" insert into proc_schedule_script_log values('"+_seqno+"',(select proc_name from proc_schedule_log where seqno='"+_seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+message+"')"
								}			
								ai.executeSQL(sql2,false,"METADBS");
								reLoad(data);
	        				}	
		            	} 
		            }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "强制执行"),
		            { 
		            	click: function(e,obj){
		            		if(confirm("强制执行?")){
			            		var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=2,trigger_flag=0,queue_flag=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and (task_state=1 or task_state=-7)"
			            		res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
		            		}
		            	} 
		            }
		    	),$("ContextMenuButton",
		            $(go.TextBlock, "暂停执行"),
		            { 
		            	click: function(e,obj){
		            	if(confirm("确定暂停任务?")){
								var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
		        				var findTaskState="select task_state from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
		        				res= ai.getStore(findTaskState,"METADBS");
								var task_state=res.root[0]['TASK_STATE'];
								var execSql= "update proc_schedule_log set TASK_STATE='"+(0-task_state)+"' where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and  task_state='"+task_state+"'";
								res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
							}
		            	} 
		            }
		    	));
		}
		if(runState=="PROC_FAIL"){
			contextMenu=$(go.Adornment, "Vertical",$("ContextMenuButton",
		            $(go.TextBlock, "强制通过"),
		            { 
		            	click: function(e,obj){
	        				var  message =  prompt("请填写原因");
	        				if(message==null||message==""){
	        					alert("请填写原因")
        						return false;
	        				}else{
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set TASK_STATE=6,QUEUE_FLAG=0,TRIGGER_FLAG=0 where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and task_state<>6 "
								res=ai.executeSQL(execSql,false,"METADBS");
								var findSeqno="select seqno from proc_schedule_log where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"'";
								res =ai.getStore(findSeqno,"METADBS");
								var _seqno=res.root[0]['SEQNO'];
								var sql1 ="select seqno from proc_schedule_script_log where seqno='"+_seqno+"' ";
								var store1=ai.getStore(sql1,'METADBS');
								var sql2="";
								if(store1&&store1.count>0){
								sql2=" update proc_schedule_script_log set app_log= CONCAT(app_log,'\\n\\n','【"+getNowTime()+"强制通过】,原因："+message+"') where seqno='"+_seqno+"' ";
								}else{
									sql2=" insert into proc_schedule_script_log values('"+_seqno+"',(select proc_name from proc_schedule_log where seqno='"+_seqno+"'),'DEFAULT_FLOW','【"+getNowTime()+"强制通过】,原因："+message+"')"
								}			
								ai.executeSQL(sql2,false,"METADBS");
								reLoad(data);
	        				}	
		            	} 
		            }
		    	), $("ContextMenuButton",
		            $(go.TextBlock, "重做后续"),
		            { 
		            	click: function(e,obj){
		        			if(confirm("确定重做?")){
		        				var xmlid= obj.part.data.key;
		        				var dateArgs =obj.part.data.dataArgs;
								var execSql="update proc_schedule_log set task_state=0,trigger_flag=0,queue_flag=0,exec_time=NULL,end_time=NULL where xmlid ='"+xmlid+"' and   date_args='"+dateArgs+"' and ( task_state >=50 or task_state=6 )";
								res=ai.executeSQL(execSql,false,"METADBS");
								reLoad(data);
							}
		            	} 
		            }
		    	));
		}

		return contextMenu;
	}
	
	
	//节点悬浮显示模版
	var $toolTip = $(go.Adornment,"Auto",
		$(go.Shape, 
      		{ 
      			fill: "#fff",
      			stroke: "#444",
      			strokeWidth: 0.5,
				fromLinkable: true,
				toLinkable: true,
				cursor: "pointer"
			}
        ),
		$(go.Panel, "Table",
  			{ alignment: go.Spot.Center, margin: 10 },
        	$(go.RowColumnDefinition, { column: 1, width: 5 }),
        	$(go.TextBlock, { row: 1, column: 0 }, "日期批次:"),
        	$(go.TextBlock, { row: 1, column: 2 }, new go.Binding("text", "dateArgs")),//,function(v) { return v.DATE_ARGS; })),
        	$(go.TextBlock, { row: 2, column: 0 }, "任务状态:"),
        	$(go.TextBlock, { row: 2, column: 2 },  new go.Binding("text", "status")),
        	$(go.TextBlock, { row: 3, column: 0 }, "执行时间:"),
        	$(go.TextBlock, { row: 3, column: 2 }, new go.Binding("text", "execTime")),
        	$(go.TextBlock, { row: 4, column: 0 }, "结束时间:"),
        	$(go.TextBlock, { row: 4, column: 2 }, new go.Binding("text", "endTime")),
        	$(go.TextBlock, { row: 5, column: 0 }, "运行时长:"),
        	$(go.TextBlock, { row: 5, column: 2 }, new go.Binding("text", "useTime"))
  		)
	 );



	myDiagram.nodeTemplateMap.add("FILE", $(go.Node, go.Panel.Auto, $(go.Shape,
			"Rectangle", {
				fill : "white",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("EVENT", $(go.Node, go.Panel.Auto, $(go.Shape,
			"Rectangle", {
				fill : "white",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("DATA", $(go.Node, go.Panel.Auto, $(go.Shape,
			"Rectangle", {
				fill : bluegrad,
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("DATA_SUCCESS", $(go.Node, go.Panel.Auto, $(go.Shape,
			"Rectangle", {
				fill : greengrad,//表前置任务完成
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $(go.Adornment,
					"Auto",
				    $(go.Shape, { fill: "#fff" }),
				    $(go.TextBlock, { margin: 4 },
			       "已完成"))
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("INTER_INVALID", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//未生效 灰色
				fill : "grey",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("INTER_RUNING", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//处理中 黄色
				fill : "yellow",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
    myDiagram.nodeTemplateMap.add("INTER_SUCCESS", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//处理成功 绿色
				fill : greengrad,
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	 myDiagram.nodeTemplateMap.add("INTER_FAIL", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//运行失败 红色
				fill : "red",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick  
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("PROC_NO_LOG", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {
				fill : yellowgrad,
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source'
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("PROC_NOT_TRIGGER", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//未触发 白色
				fill : "white",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_NOT_TRIGGER")
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));

	myDiagram.nodeTemplateMap.add("PROC_WAIT", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//排队中 灰色
				fill : "grey",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	
	myDiagram.nodeTemplateMap.add("PROC_QUEUING", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//依赖检测通过/排队等待 灰色
				fill : "grey",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_QUEUING")
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));

	myDiagram.nodeTemplateMap.add("PROC_RECOVERY", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//排队中 灰色
				fill : "yellow",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_RECOVERY") 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));

	myDiagram.nodeTemplateMap.add("PROC_CREATE", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//排队中 灰色
				fill : "grey",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_CREATE") 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));

	myDiagram.nodeTemplateMap.add("PROC_RUNING", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//运行中 黄色
				fill : "yellow",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	
    myDiagram.nodeTemplateMap.add("PROC_SUCCESS", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//运行成功 绿色
				fill : greengrad,
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_SUCCESS")
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
    
	 myDiagram.nodeTemplateMap.add("PROC_FAIL", $(go.Node, go.Panel.Auto, $(go.Shape,
			"RoundedRectangle", {//运行失败 红色
				fill : "red",
				portId : "",
				fromLinkable : true,
				cursor : "pointer"
			}), {
		 doubleClick : nodeDoubleClick,
		 //contextMenu:returnContext("PROC_FAIL") 
	}, // 鼠标单击事件函数
	$(go.TextBlock, textStyle(), {
		text : 'Source',
		editable : true,
		toolTip : $toolTip
	}, new go.Binding("text", "text").makeTwoWay())));
	 
     // replace the default Link template in the linkTemplateMap
	myDiagram.linkTemplate = $(go.Link, // the whole link panel
	{
		curve : go.Link.Bezier,
		toShortLength : 15
	}, new go.Binding("curviness", "curviness"), $(go.Shape, // the link
	// shape
	{
		isPanelMain : true,
		stroke : "#2F4F4F",
		strokeWidth : 2.5
	}), $(go.Shape, // the arrowhead
	{
		toArrow : "kite",
		fill : '#2F4F4F',
		stroke : null,
		scale : 2
	}));
	myDiagram.linkTemplateMap.add("Comment", $(go.Link, {
		selectable : false
	}, $(go.Shape, {
		strokeWidth : 2,
		stroke : "darkgreen"
	})));
	myDiagram.toolManager.mouseWheelBehavior = go.ToolManager.WheelZoom;
	myDiagram.allowDrop = true;
	myDiagram.initialAutoScale = go.Diagram.Uniform;
	myDiagram.toolManager.linkingTool.direction = go.LinkingTool.ForwardsOnly;
	myDiagram.initialContentAlignment = go.Spot.Center;
	myDiagram.layout = $(go.LayeredDigraphLayout, {isOngoing : false,layerSpacing : 50});
    getDataModel(data);
    myDiagram.model = new go.GraphLinksModel(keys, ref);
    
}

function addGoJsNode(type){
	var tempMap = type=="SOURCE" ? preMap : nextMap;
	var _key = "";
	var _from = "";
	var _to = "";
	for(var prop in tempMap){
		$.each(tempMap[prop], function(i, item){
			if(item.xmlid == "0") return;
			_key = item.type=="DATA" ? (item.xmlid||"") : item.xmlid;
			//节点
			if(checkKeyUnqi(keys, _key)){
				keys.push({
					"key" : _key,
					"text": getKeyVal(item.type) + item.text,
					"category": getCategory(item.state, item.type),
				    "status": getNodeStatus(item.state),
				    "dateArgs": item.date_args,
				    "execTime": item.exec_time,
				    "endTime": item.end_time,
				    "useTime": item.use_time
				});
			}
			//关系
			_from = type=="SOURCE" ? _key : prop;
			_to  = type=="SOURCE" ? prop : _key;
			if(checkRefUnqi(ref, _from, _to)){
				ref.push({
					"from": _from,
					"to": _to
				});
			}
		});
	}
}

function bindFlowClick(){
	//前置
	$("#preDialog").click(function(){
		var stopFlag = true;
		for(var _prop in preMap){
			stopFlag = false;
			break;
		}
		if(stopFlag) return;
		preMap["dateArgs"] = [{"dateArgs":dateArgs}];
		preMap["direct"] = [{"direct":"pre"}];
		//如果没有前置节点了则返回
		$.ajax({
			url : "../../dataflow/preornext",
			type : "POST",
			async : false,
			data: JSON.stringify(preMap),
			dataType: 'json',
			contentType: 'application/json', 
			success : function(data, textStatus) {
				console.log(data);
				preMap = data;
				addGoJsNode("SOURCE");
				myDiagram.model = new go.GraphLinksModel(keys, ref);
			},
			error : function() {
				console.log('获取数据失败');
			}
		});
	});
	//影响
	$("#nextDialog").click(function(){
		//如果没有影响节点了则返回
		var stopFlag = true;
		for(var _prop in nextMap){
			stopFlag = false;
			break;
		}
		if(stopFlag) return;
		nextMap["dateArgs"] = [{"dateArgs":dateArgs}];
		nextMap["direct"] = [{"direct":"next"}];
		$.ajax({
			url : "../../dataflow/preornext",
			type : "POST",
			async : false,
			data: JSON.stringify(nextMap),
			dataType: 'json',
			contentType: 'application/json', 
			success : function(data, textStatus) {
				nextMap = data;
				addGoJsNode("TARGET");
				myDiagram.model = new go.GraphLinksModel(keys, ref);
			},
			error : function() {
				console.log('获取数据失败');
			}
		});
	});
	//全部
	$("#allDialog").click(function(){
			if(confirm("确认要展示流程图的所有部分？可能会有漫长的等待")){
			var stopFlag = true;
			for(var _prop in preMap){
				stopFlag = false;
				break;
			}
			for(var _prop in nextMap){
				stopFlag = false;
				break;
			}
			if(stopFlag) return;
			preMap["dateArgs"] = [{"dateArgs":dateArgs}];
			preMap["direct"] = [{"direct":"pre"}];
			nextMap["dateArgs"] = [{"dateArgs":dateArgs}];
			nextMap["direct"] = [{"direct":"next"}];
			//如果没有前置节点了则返回
			$.ajax({
				url : "../../dataflow/all",
				type : "POST",
				async : false,
				data: JSON.stringify({"nextMap":nextMap,"preMap":preMap}),
				dataType: 'json',
				contentType: 'application/json', 
				success : function(data, textStatus) {
					nextMap = data.next;
					preMap = data.pre;
					addGoJsNode("TARGET");
					addGoJsNode("SOURCE");
					myDiagram.model = new go.GraphLinksModel(keys, ref);
					nextMap = {};
					preMap = {};
				},
				error : function() {
					console.log('获取数据失败');
				}
			});
		}
	})
}
function getNodeStatus(state){
	
	switch(state){
	case -7:
		status="未触发";
		break;
	case -1:
	case -2:
	case -3:
		status="暂停任务";
		break;
	case 0:
		status="正在重做";
		break;
	case 1:
		status="创建成功";
		break;
	case 2:
		status="依赖通过";
		break;
	case 3:
		status="排队等待";
		break;
	case 4:
		status="发送agent";
		break;
	case 5:
		status="正在运行";
		break;
	case 6:
		status="运行成功";
		break;
	default:
		if(data.TASK_STATE>=50){
			status="运行失败";
		}
		break;
	}
	return status;
}