<!DOCTYPE html>
<html lang="en" class="app">
<head>
<meta charset="UTF-8">
<title>程序模型列表</title>   
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"  />
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/datepicker.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.simpledate.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.pst-area-control.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-view/ve/css/dacp-ve-js-1.0.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="/dacp/dacp-res/task/css/implWidgets.css" type="text/css" rel="stylesheet"  />
	<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"  />
	
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="${mvcPath}/dacp-lib/jquery/jquery-ui-1.10.2.min.js"></script>
	<script src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
	<script src="${mvcPath}/dacp-lib/underscore/underscore-min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/backbone/backbone-min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/highcharts/highcharts.js" type="text/javascript" ></script>
	<script src="${mvcPath}/dacp-lib/datepicker/bootstrap-datepicker.js" type="text/javascript" ></script>
	<script src="${mvcPath}/dacp-lib/datepicker/jquery.simpledate.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/datepicker/jquery.pst-area-control.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-view/ve/js/dacp-ve-js-1.0.js" type="text/javascript" charset="utf-8"></script>
	<script src="${mvcPath}/ve/ve-context-path.js" type="text/javascript" charset="utf-8"></script>

    <script src="${mvcPath}/dacp-lib/jquery-plugins/bootstrap-treeview.min.js"> </script>
    <script src="${mvcPath}/dacp-lib/jquery-plugins/jquery.layout-latest.js" type="text/javascript"> </script>
    <script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
    
    
    <!-- 使用ai.core.js需要将下面两个加到页面 -->
	<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
	<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
	
	<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>

<style>
body {     
	margin: 0;
	font-family: Roboto, arial, sans-serif;
	font-size: 13px;
	line-height: 20px;
	color: #444444;
	background-color: #f1f1f1;
}
 
.navbar-btn.btn-sm {
	margin-top: 5px;
	margin-bottom: 10px;
}

tr.active.table-text-visited {
	color: #4CB6CB;
	background-color: #000000;
	font-weight: bold;
}

#myModal {
	z-index: 999999;	
}

#queryPanel{
margin-top:10px;
}

.ui-layout-center {
	overflow: auto;
}

.ui-layout-toggler-west .btnCenter {
	background: #00C;
}

.ui-layout-toggler-west .btnWest {
	background: #090;
}

.ui-layout-toggler-west .btnBoth {
	background: #C00; 
}

.ui-layout-resizer-west { 
	border-width: 0 1px;
}

.ui-layout-toggler-west {
	border-width: 0;
}

.ui-layout-toggler-west div {
	width: 4px;
	height: 35px; /* 3x 35 = 105 total height */
}

.ui-layout-toggler-west .btnCenter {
	background: #00C;
}

.ui-layout-toggler-west .btnWest {
	background: #090;
}

.ui-layout-toggler-west .btnBoth {
	background: #C00;
}

.glyphicon{
	position: relative;
  top: 1px;
  display: inline-block;
  font-family: 'Glyphicons Halflings';
  font-style: normal;
  font-weight: normal;
  line-height: 1;
  -webkit-font-smoothing: antialiased;
}
</style>

<script>
var _act= "edit";
var _grid = "";
var _editPanel="";
var _sql="select ID,JOB_TYPE,JOB_COMMAND,JOB_INSTRUCTION,b.proctype_name from job_command a left join proc_schedule_exe_class b on a.job_type=b.proctype WHERE 1=1 {condi}";
var _treeSql="select job_type,proctype_name,count(1) num from (" + _sql + ") tablefile group by job_type,proctype_name";
var tableStore = new AI.JsonStore({
	sql: _sql.replace("{condi}",""),
	pageSize: 15,
	key: "ID",
	table: "job_command",
	dataSource: "METADB"
});

//查询条件
var getQueryCondi=function(){
	var searchText = $("#search-text input").val()
	var _condi = "";
	if(searchText) {
		_condi +=" AND  (job_command like '%" + searchText + "%' or job_instruction like '%" + searchText + "%' )";
	};
	return _condi;
};

//刷新版面
var switchContent = function(condi){
	if(!condi||typeof(condi)=="undefined"){
		condi="";
	}
	buildTreeView(_treeSql.replace("{condi}",condi));
	tableStore.select(_sql.replace("{condi}",condi))
	if(tableStore.count == 0) {
		$("#undefined_page").html('<li><a class=" pull-center">记录总数:0</a></li>');
	}
};

//查询面板
var _queryPanel = new ve.FormWidget({
	config:{
		"class":"form",
		"formClass":"form-inline",
		"id": "_query",
		"noJustfiyFilter":"on",
		"items": [
			{
				"type": "text",
				"id":"search-text",
				"fieldLabel":"",
				"placeholder":"关键字",
				"style": "min-width:200px;width:180px;margin-left:210px;"
			},
			{
				"type": "text",
				"style": "display: none"
			},
			{
				"id":"search",
				"value":"查询",
				"type":"button",
				"className":"btn btn-sm btn-warning"
			},
			{
				"id":"add",
				"value":"新增",
				"type":"button",
				"className":"btn btn-sm btn-primary"
			},
			{
				"id":"edit",
				"value":"修改",
				"type":"button",
				"className":"btn btn-sm btn-primary"
			},
			{
				"id":"delete",
				"value":"删除",
				"type":"button",
				"className":"btn btn-sm btn-primary"
			}
		],
		'events': {	
			afterRender:function(){
				var _view = this;
				_view.$el.find("#search").empty().append('<button type="button" class="btn btn-sm btn-warning"><span class="glyphicon glyphicon-eye-open"></span>查询</button>');
				_view.$el.find("#add").empty().append('<button id="cre-ojb" type="button" class="btn btn-sm btn-success" style="margin:0px 5px"><span class="fa fa-plus"></span> 新增</button>')
				_view.$el.find("#delete").empty().append('<button id="delete-data" type="button" class="btn btn-sm btn-danger"><span class="fa fa-trash-o"></span> 删除</button>')
			},		
			'click #search':function(){
				switchContent(getQueryCondi());
			},
			'click #add':function(){
				var r = tableStore.getNewRecord();
				tableStore.curRecord = r;
				showDialog("add");
				$("#myModal").modal({
					show:true,
					backdrop:false
				});
			},
			'click #edit':function(){
				var selected = _grid.getCheckedRows();
				if(selected && selected.length!=1){
					alert('只能选中一行！');
					return false;
				}
				tableStore.curRecord = selected[0];
				showDialog("edit")
			},
			'click #delete':function(){
				var selected = _grid.getCheckedRows();
				if(!selected || selected.length < 1){
					alert('至少选中一项！');
					return false;
				}
				if(confirm("确定要删除选择项吗？")){
					for(var i=0;i< selected.length;i++){
						ai.executeSQL("delete from inter_cfg where XMLID='" + selected[i].get("XMLID") + "'","false","METADB")	
					}
					alert("删除成功")
		   			tableStore.select();
		   			buildTreeView(_treeSql.replace("{condi}",""));
				}
			}
		}
	}
});

//配置界面
function showDialog(actType){
	$('#upsertForm').empty();
	var isRead = 'n';
	$("#dialog-ok").show();
	$("#dialog-cancel").html("取消");	
	if(actType=="add"){
		_act = "add";
	}else if(actType=="edit"){
		_act = "edit";	
	}else if(actType == "view"){
		_act = "view";
		isRead = 'y';
		$("#dialog-ok").hide();
		$("#dialog-cancel").html("关闭");
	}
	_editPanel = new AI.Form({
		id: 'baseInfoForm',
		store: tableStore,
		containerId: 'upsertForm',
		fieldChange: function(fieldName, newVal){},
		items: [
			{type : 'combox', label : '类别', notNull: 'N', fieldName : 'JOB_TYPE', isReadOnly: isRead, width : 220, storesql:"select proctype K,proctype_name V from proc_schedule_exe_class " },
			{type : 'textarea', label : '命令', notNull: 'N', fieldName : 'JOB_COMMAND', isReadOnly: isRead, width : 220 },
			{type : 'textarea', label : '说明', notNull: 'Y', fieldName : 'JOB_INSTRUCTION', isReadOnly: isRead, width : 220 }
		]
	});
	
	$("#myModal").modal({
		show:true,
		backdrop:false
	});
}

//左边树   
var buildTreeView = function(sql){
	$('#treeview6').empty().treeview({
		color: "#428bca",
		expandIcon: "glyphicon glyphicon-chevron-right",
		collapseIcon: "glyphicon glyphicon-chevron-down",
		nodeIcon: "glyphicon glyphicon-tasks",
		showTags: true,
		onNodeSelected:function(event,node){
			var strArray = node.id.split(">");
			var where = "";
			for(var i=0;i<strArray.length;i++){
				var str =strArray[i];
				var subWhere=str.split(":")[0]+" = '"+str.split(":")[1]+"'";
				if(str.split(":")[1]=='未知') subWhere = str.split(":")[0] +" IS NULL ";
				if(where) where += " AND "+ subWhere
				else where = subWhere;
			}
			where = where.length>0?(" AND "+ where):"";
			tableStore.select(_sql.replace("{condi}", where + getQueryCondi()));
		},
		groupfield:"JOB_TYPE",
		titlefield:"PROCTYPE_NAME",
		sql:sql,
		dataSource:"METADB",
		subtype:'grouptree',
		renderer: function(val,node){
			var res = '未知';
			res=val||res;
			return res;
		}
	});
};

$(document).ready(function(){
	 $('body').layout({
	    	sizable:						false
		,	animatePaneSizing:				true
		,	fxSpeed:						'slow'
		,	spacing_open:					0
		,	spacing_closed:					0
		,	west__spacing_closed:			8
		,	west__spacing_open:				8
		,	west__togglerLength_closed:		105
		,	west__togglerLength_open:		105
		,	west__size:						205
		,	north__size: 					50
	});
	//_totalPanel.$el=$("#totalPanel");
	_queryPanel.$el=$("#queryPanel");
	_queryPanel.render();
	$("#search-text").on("keydown",function(e){
		if(e.keyCode == 13){ 
			document.getElementById("search").click();
		} 
	})
	//表格
	_grid = new AI.Grid({
		store: tableStore,
		containerId: 'tabpanel',
		pageSize: 15,
		nowrap: true,
		rowclick: function(rowdata){
			//curdata= rowdata;
		},
		celldblclick: function(rowdata){
			showDialog('view');
		},
		showcheck: true,
		columns: [
			{header: "命令类别", dataIndex: 'PROCTYPE_NAME', className: "ai-grid-body-td-center"},
			{header: "命令内容", dataIndex: 'JOB_COMMAND', className: "ai-grid-body-td-center"},
			{header: "说明", dataIndex: 'JOB_INSTRUCTION', className: "ai-grid-body-td-center"}
		]
	});
	
	buildTreeView(_treeSql.replace("{condi}",""));
	
	function checkInput(){
		var items = _editPanel.config.items;
		for(var i=0; i< items.length; i++){
			if(items[i].notNull=="N"){
				var item = $("#"+items[i].fieldName);
				if(typeof(item)=="undefined" || item.val().length==0){
					alert(items[i].label + "为空！");
					return false;
				}
			}
		}
		
		return true;
	}
	
	//确定
	$("#dialog-ok").on('click', function(){
		if(!checkInput()) return false;
		
		var record = tableStore.curRecord;
		if( _act == "add"){
			record.set("ID",ai.guid());
			tableStore.add(record);
		}
		var r = tableStore.commit(false);
		var rJson = $.parseJSON(r);
		if(rJson.success){
			alert(rJson.msg);
		}else{
			alert("出错：" + rJson.msg);
		}
        $('#myModal').modal('hide');
		tableStore.select();
		buildTreeView(_treeSql.replace("{condi}",""));
	});
	
	//取消
	$(".close-modal").on('click', function(){
       $('#myModal').modal('hide');
	});
});
</script>
</head>
<body>
	<div id="myModal" class="modal fade"> 
	   <div class="modal-dialog"> 
		   <div class="modal-content" > 
			   <div class="modal-header"> 
				   <button type="button" class="close close-modal" > <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> 
				   <h4 class="modal-title">基本信息</h4> 
			   </div> 
			   <div class="modal-body" id="upsertForm"></div> 
			   <div class="modal-footer"> 
				   <button id="dialog-cancel" type="button" class="btn btn-default close-modal" >取消</button> 
				   <button id="dialog-ok" type="button" class="btn btn-primary">确定</button> 
			   </div> 
		  </div>
	   </div>
	</div>
	
	<div class="ui-layout-north">
	   <div  id="queryPanel"></div>
	</div>
	<div class="ui-layout-west" >
		<div id="treeview6" class="test"></div>
	</div>
	<div class="ui-layout-center">
		<div id="tabpanel" style="margin-bottom: 120px;"></div>
	</div>
</body>
</html>