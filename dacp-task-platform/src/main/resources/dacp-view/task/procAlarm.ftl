<!DOCTYPE html>
<html lang="zh" class="app">
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge"></meta>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<meta charset="utf-8"></meta>
<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>程序告警信息配置</title>
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"  />
		<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
		<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"/>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
		
		
		<!-- 使用ai.core.js需要将下面两个加到页面 -->
		<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
		<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
		
		<script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
		  
<script type="text/javascript">
var team_code = paramMap["team_code"]||_UserInfo.teamCode;
$(document).ready(function() {
	var sql = {
		content: "SELECT a.xmlid,c.trigger_type,a.PROC_NAME,a.PROCCNNAME,b.sms_group_id,b.WARNING_TYPE,b.MAX_SEND_CNT,b.INTERVAL_TIME,b.IS_SEND,b.MAX_RUN_TIME  "
				+ " FROM proc a LEFT JOIN proc_schedule_info c ON a.XMLID=c.XMLID LEFT JOIN sms_message_group_task b ON a.XMLID=b.XMLID "
				+ " where 1=1  {condi}",
		getCondi: function(){
			var _condi = " and a.team_code in ('" + team_code + "')";
			var input = $("#for-query").val().trim();
			if(input.length>0){
				_condi += " and (a.PROC_NAME like '%"+input+"%'"+" or a.PROCCNNAME like '%"+input+"%')";
			}
			var smsGroup= $("#smsGroup_select").val();
			if(smsGroup!=null && smsGroup.length>0){
				_condi += " and b.SMS_GROUP_ID='"+smsGroup+"'";
			}
			return _condi;
		},
		getContent: function(){
			return this.content.replace('{condi}',sql.getCondi()||"");
		}
	};

	var GroupStore = new AI.JsonStore({
			sql:sql.getContent(),
			key:"XMLID",
	        pageSize:20,
	        dataSource:"METADBS"
	    });

	var smsTasksql ="select * from  sms_message_group_task where xmlid='{xmlid}'";
	var smsTaskStore = new AI.JsonStore({
		  sql:smsTasksql,
		  table:"sms_message_group_task",
			key:"XMLID",
	    pageSize:-1,
	    dataSource:"METADBS"
	});

	var _rowdblClickFunc = function(){
		//alert('行双击事件！');
		//buildForm();
	};

	var smsGroupStore = new AI.JsonStore({
			sql:"select * from sms_message_group where team_code='"+team_code+"'",
			key:"SMS_GROUP_ID",
	    pageSize:-1,
	    dataSource:"METADBS"
	    });
	
	var renderSelectHtml = function(selectedValue,sql,dataSource){
		var _store = new AI.JsonStore({
			sql: sql,
			pageSize: -1,
	    	dataSource: dataSource
		});
		var res='<option value="">请选择</option>';
		if(_store.count>0){
			$.each(_store.root,function(index,item){
				var selected ='';
				if(selectedValue!=null && selectedValue.length>0 && selectedValue == item.K ){
					selected=' selected ';
				}
				res +='<option value="'+item.K+'" '+selected+'>'+item.V+'</option>';
			});
		}
		return res;
	}
	
    function getsmsGroupName(v){
		if (!v) return v;
		var smsGroupId = v;
		var smsgroupName;
		for(var k=0;k<smsGroupStore.getCount();k++){
			var record=smsGroupStore.getAt(k);
			if(record.get("SMS_GROUP_ID")==smsGroupId){
				smsgroupName=record.get("SMS_GROUP_NAME");
				break;
			}
		}
		if(!smsgroupName)
			smsgroupName="未设置";
		return 	smsgroupName;
	};

  	var warnTypeStore = new AI.JsonStore({
			sql:"select * from warning_type",
			key:"TYPE_CODE",
	    pageSize:-1,
	    dataSource:"METADBS"
	    });
	
	
	 function getWarnType(v){
		if (!v) return v;
		var rtnVal="";
		if(v&&v.length>0){inputVals = v.split("|");}
		for(var i=0;i<inputVals.length;i++){
				var record=warnTypeStore.getRecordByKey(inputVals[i]);
				if(record)
					rtnVal=rtnVal+record.get("TYPE_NAME")+",";
		}
		if(!rtnVal)
			rtnVal="未设置";
		else
			rtnVal=rtnVal.substr(0,rtnVal.length-1);
		return 	rtnVal;
	};    

  var statusFlag={"0":"发送","1":"不发送",'null':'未配置'};
  	$("#grid-container").empty();
	var grid = new AI.Grid({							//表格组件
		store:GroupStore,									//表格渲染的数据源										
		id:'expl',										//组件在html标签中的id
		containerId:'grid-container',					//组件在html中父节点id
		pageSize:5,									//每一页的记录条数
		nowrap:true,									//是否换行（true不换行，false换行）
		showcheck:true,								//是否显示勾选框（true显示，false不显示）
	//	rowclick:function(){alert('行单击事件！');},		//行单击事件
		// celldblclick:_rowdblClickFunc,					//单元格双击事件，实现在43行
		columns:[										//列表头配置
			// {
			// 	header:"XMLID",							//列名
			// 	dataIndex: 'XMLID',					//对应store中的字段，注意要大写
			// 	sortable: true,							//是否允许排序（true允许，false不允许）
			// 	maxLength:20,							//单元格最大显示字符长度
			// 	render:function(record,value){			//自定义渲染，record参数为当前记录，value为当前列字段值
			// 		return value;
			// 	}
			// },
			{header:"程序名",dataIndex: 'PROC_NAME',  sortable: true,maxLength:30},
			{header:"程序中文名",dataIndex: 'PROCCNNAME',  sortable: true,maxLength:30},
			{header:"用户组",dataIndex: 'SMS_GROUP_ID',  sortable: true,maxLength:50},
			{header:"用户组名",dataIndex: 'SMS_GROUP_ID',  sortable: true,maxLength:50,
					render:function(rec, cellVal){
						return getsmsGroupName(cellVal);
					}
			},
			
			

			{header:"告警类型",dataIndex: 'WARNING_TYPE',  sortable: true,maxLength:200,
									render:function(rec, cellVal){
						return getWarnType(cellVal);
					}
			},
			{header:"最大运行时长(分)",dataIndex: 'MAX_RUN_TIME',  sortable: true,maxLength:20},
			{header:"最大发送次数",dataIndex: 'MAX_SEND_CNT',  sortable: true,maxLength:20},
			{header:"发送时间间隔",dataIndex: 'INTERVAL_TIME',  sortable: true,maxLength:20},
			{header:"该程序是否发送短信",dataIndex: 'IS_SEND',  sortable: true,maxLength:20,
					render:function(record,value){
					return statusFlag[record.get("IS_SEND")+""];
				}}
		],
	});

	var buildForm = function(){
		var selected=grid.getCheckedRows();
		if(selected && selected.length==0){
			alert("请选择数据修改");
			return;
		}
		if(selected && selected.length>1){
			alert("请选择一行记录修改");
			return;
		}
		$('#upsertForm').empty();
		var xmlId=selected[0].get("XMLID");
		var tt=selected[0].get("TRIGGER_TYPE");
		var ttwhere = tt == 1 ? ' where TYPE_CODE <> 1 ' : '';
		//smsTaskStore.sql=smsTaskSql.replace('{xmlid}',xmlId);
		GroupStore.curRecord = GroupStore.getRecordByKey(xmlId);
		
		
		$('#myModal').modal('show');
		var form = new AI.Form({							//表单组件
			id : 'form',									//组件在html标签中的id
			store : GroupStore,									//表单数据存储的数据源
			containerId : 'upsertForm',						//组件在html中父节点id
			items : [ 										//表单内容
				{											//formField，表单实例对象
					type : 'hidden',							//表单类型，text文本框，password密码框，date日期框，combox筛选框，radio选择框，multilevel多级筛选
					label : 'XMLID',						//表单名称
					fieldName : 'XMLID',					//对应字段
					isReadOnly:"y",							//是否只读
					value:"dbuer",								//默认值
					// storesql:"",							//参数值，有两种设置值的方式，sql：“select col from tab”，
															// “select col1，col2 from tab“，定值：“1,2”,"1,是|0,否"
					notNull:  'Y',							//是否允许为空
					isReadOnly: 'y',					//是否只读，y只读，n可以修改
					width: '100px',							//设置宽度
					//tip: 'notice that…',					//备注
					dependencies: '{val}=2',				//依赖关系条件，｛val｝为依赖表单的值
					checkItems: 'FIELD2'					//影响的底钻名称
				},
				{type : 'text',label : '程序名',fieldName : 'PROC_NAME',isReadOnly:"y"}, 
				{type : 'combox',label : '用户组',fieldName : 'SMS_GROUP_ID',notNull:'N'},
				{type : 'checkbox',label : '告警类型',fieldName : 'TYPE_CODE',notNull:'N'},
				{type : 'text',label : '最大运行时长(分)',fieldName : 'MAX_RUN_TIME',notNull:'Y'},
				{type : 'text',label : '最大发送次数',fieldName : 'MAX_SEND_CNT',notNull:'N'},
				{type : 'combox',label : '发送时间间隔',fieldName : 'INTERVAL_TIME',notNull:'N',storesql:'5,5分钟|10,10分钟|20,20分钟|30,30分钟|40,40分钟|60,60分钟'},
				{type : 'radio-custom',label : '该程序是否发送短信',fieldName : 'IS_SEND',storesql:'0,发送|1,不发送',notNull:'N'}
			]
			//,fieldChange: function(fieldName, newVal){
			//	alert('['+fieldName+']字段的值修改为: '+newVal);
			//}
		});

		var smdGroupId = $("#SMS_GROUP_ID").val();
		$("#SMS_GROUP_ID").empty().append(renderSelectHtml(smdGroupId,"select sms_group_id as K,sms_group_name as V from sms_message_group where team_code = '"+team_code+"' order by sms_group_id",'METADBS'))
		
		var alarmTypeStore = new AI.JsonStore({
			sql: "select type_code as K ,type_name as V from warning_type " + ttwhere + " order by type_code",
			pageSize: -1,
	    	dataSource: "METADBS"
		});
		
		var res="";
		var x = GroupStore.curRecord.data.WARNING_TYPE!=null?GroupStore.curRecord.data.WARNING_TYPE.split("|"):[];
		if(alarmTypeStore.count>0){
			$.each(alarmTypeStore.root,function(index,item){
				var checked="";
				for (var j = 0; j < x.length; j++) {
					if(x[j]==item.K){
						checked=" checked ";
						break;
					}
				}
				res += '<span><input type="checkbox" name="TYPE_CODE" value="'+item.K+'" '+checked+'>'+item.V+'</span>';
			});
			if(res.length>0){
				res=res.substr(0,res.length-1);
				$("#container_TYPE_CODE").empty().append(res);
			}
		}
	};

	var addRecord = function(){
		var rec = store.getNewRecord();
		store.add(rec);
		store.curRecord = rec;
	};

	/*
	 *插入数据
	 */
	$('#insert').on('click',function(){
		addRecord();
		buildForm();
	});

	/*
	 *修改数据
	 */
	$('#modify').on('click',function(){
		buildForm();
	});

	 
	function getCheckedValue(name){
		var radio = $("input[type='radio'][name='" + name + "']");
		for(var i=0; i < radio.length; i++){
			if(radio[i].checked){
				return $(radio[i]).val();
			}			
		}
	}

	function getCheckedBoxValue(name){
		var checkedValue="";
		checkedValue = $("input:checkbox[name='"+name+"']:checked")
						.map(function(index,elem){
								return $(elem).val();
							}).get().join('|');
		return checkedValue;
	}
	
	
		function checkGroupId(inputString){
			if(inputString==null) return false;
		    var fl=false;
		    if(inputString.match("[0-9]"))
		    {
		         return true;
		    }
		    else
		    {
		         return false;
		    }
		};
	
	$('#dialog-ok').on('click',function(){
		var record =GroupStore.curRecord;
		var XMLID = record.get("XMLID");
    	var PROC_NAME = record.get("PROC_NAME");
		var SMS_GROUP_ID=record.get("SMS_GROUP_ID");
		var WARNING_TYPE = getCheckedBoxValue("TYPE_CODE");
		var MAX_SEND_CNT = record.get("MAX_SEND_CNT");
		var MAX_RUN_TIME = record.get("MAX_RUN_TIME");
		var INTERVAL_TIME = record.get("INTERVAL_TIME");
		var IS_SEND = getCheckedValue("IS_SEND");
		
		
		if(SMS_GROUP_ID==null || SMS_GROUP_ID==""){
			alert("请检查,未选择用户组");
			return;
		}
		if(WARNING_TYPE==""){
			alert("请检查,至少选择一种告警类型");
			return;
		}
		if(!checkGroupId(MAX_SEND_CNT)){
			alert("请检查,发送次数必填，且必须为数字");
			return;			
		}
		if(!checkGroupId(INTERVAL_TIME)){
			alert("请检查,请选择发送时间间隔");
			return;			
		}

		if(MAX_RUN_TIME!=null && MAX_RUN_TIME!="" &&!checkGroupId(MAX_RUN_TIME)){
			alert("请检查,最大运行时长必须是数字");
			return;
		}
		if(IS_SEND == undefined || IS_SEND==null || IS_SEND==""){
			alert("请检查,请选择是否发送告警短信");
			return;
		}

		smsTaskStore.sql=smsTasksql.replace('{xmlid}',XMLID);

		smsTaskStore.select();
		if(smsTaskStore.count==0){//新增
		    var newRecord=smsTaskStore.getNewRecord();
		    newRecord.set("XMLID",XMLID);
	        newRecord.set("PROC_NAME",PROC_NAME);
	        newRecord.set("SMS_GROUP_ID",SMS_GROUP_ID);
	        newRecord.set("WARNING_TYPE",WARNING_TYPE);
	        newRecord.set("MAX_SEND_CNT",MAX_SEND_CNT);
	        newRecord.set("MAX_RUN_TIME",MAX_RUN_TIME);
	        newRecord.set("INTERVAL_TIME",INTERVAL_TIME);
	        newRecord.set("IS_SEND",IS_SEND);
	        smsTaskStore.add(newRecord);
		}else if (smsTaskStore.count=1){//修改
			var updateRecord=smsTaskStore.getRecordByKey(XMLID);
	        updateRecord.set("PROC_NAME",PROC_NAME);
	        updateRecord.set("SMS_GROUP_ID",SMS_GROUP_ID);
	        updateRecord.set("WARNING_TYPE",WARNING_TYPE);
	        updateRecord.set("MAX_SEND_CNT",MAX_SEND_CNT);
	        updateRecord.set("MAX_RUN_TIME",MAX_RUN_TIME);
	        updateRecord.set("INTERVAL_TIME",INTERVAL_TIME);
	        updateRecord.set("IS_SEND",IS_SEND);
        
		}
		var rs=smsTaskStore.commit(false);
		var rsJson =  $.parseJSON(rs);
			if(rsJson.success){
					GroupStore.select();
					$('#userModal').modal('hide');
					//alert("修改成功");
				}else{
					alert("修改失败");
				}
		$('#myModal').modal('hide');
	});
	$('#dialog-cancel,.close-modal').on('click',function(){
		GroupStore.cache={
			save:[],
			remove:[],
			update:[]
		};
		$('#myModal').modal('hide');
	});
	
	function initsmsGroup_select(){
		$("#smsGroup_select").append("<option value=''>用户组</option>");
		for(var i=0;i<smsGroupStore.count;i++){
			var record=smsGroupStore.getAt(i);
			var smsGroupId=record.get("SMS_GROUP_ID");
			var smsGroupName=record.get("SMS_GROUP_NAME");
			$("#smsGroup_select").append("<option value='"+smsGroupId+"'>"+smsGroupId+"->"+smsGroupName+"</option>");
		}
	};
	initsmsGroup_select();
	
		//触发类型
	$('#smsGroup_select').on('change',function(e){
		GroupStore.sql = sql.getContent(),
		GroupStore.select();
	});
	
		/*
	 *查询数据
	 */
	$('#queryOne').on('click',function(){
		GroupStore.sql=sql.getContent(),
		GroupStore.select();
	});
	
});




</script>
<body>
<div class="row">
	<div style="padding-left: 0px;margin-left: 10px;">
		<form class="navbar-form navbar-left" role="search">
			<div class="form-group" >
					<select id="smsGroup_select" class="form-control formElement">
					</select>
			</div>
			<div class="form-group">
						<input type="text" class="form-control" placeholder="输入程序名/程序中文名" id="for-query">
						<input class="hide" />
			</div>
			<button class="btn btn-default" type="button" id="queryOne">查询</button>
		  <button class="btn btn-default" type="button" id="modify">设置告警信息</button>
		</form>			
	 </div>
</div>
<div class="row">
	<div id="grid-container" style="margin-left: 20px;"></div>
</div>
<div id="myModal" class="modal fade"> 
	<div class="modal-dialog"> 
	    <div class="modal-content" > 
	     <div class="modal-header"> 
		      <button type="button" class="close close-modal" > <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> 
		      <h4 class="modal-title">告警设置</h4> 
	     </div> 
	     <div class="modal-body" id="upsertForm"></div> 
	     <div class="modal-footer">
			<button id="dialog-cancel" type="button" class="btn btn-default">取消</button> 
			<button id="dialog-ok" type="button" class="btn btn-primary">保存</button>
	     </div> 
	    </div>
	<!-- /.modal-content --> 
	</div> 
<!-- /.modal-dialog --> 
</div>
</body>
</html>