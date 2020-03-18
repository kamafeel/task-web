
<!DOCTYPE html>
<html lang="en" class="app">
<head>
<meta charset="utf-8" />
<title>DACP数据云图</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1" />
<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css"
	type="text/css" rel="stylesheet" media="screen" />
<link href="${mvcPath}/dacp-res/task/css/app.v1.css" type="text/css" rel="stylesheet" />
<script type="text/javascript"
	src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript"
	src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${mvcPath}/dacp-lib/underscore/underscore-min.js"></script>
<script src="${mvcPath}/dacp-lib/backbone/backbone-min.js"
	type="text/javascript"></script>
<!-- <script src="${mvcPath}/dacp-view/ve/js/dacp-ve-js-1.0.js" type="text/javascript" charset="utf-8"></script> -->
<!--<script src="${mvcPath}/ve/ve-context-path.js" type="text/javascript" charset="utf-8"></script>-->
<script src="${mvcPath}/dacp-lib/jquery-plugins/jquery.layout-latest.js"
	type="text/javascript"> </script>
<script
	src="${mvcPath}/dacp-lib/jquery-plugins/bootstrap-treeview.min.js"> </script>
<script src="${mvcPath}/dacp-res/task/js/app.plugin.js"></script>

<!-- 使用ai.core.js需要将下面两个加到页面 -->
<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>

<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
<script
	src="${mvcPath}/dacp-lib/jquery-plugins/bootstrap-treeview.min.js"> </script>
<script type="text/javascript"
	src="${mvcPath}/dacp-lib/underscore/underscore-min.js"></script>

<script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>

<style>
body {
	margin: 0;
	font-family: Roboto, arial, sans-serif;
	font-size: 13px;
	line-height: 20px;
	color: #444444;
	background-color: #f1f1f1;
}

a {
	cursor: pointer;
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

.ui-layout-north {
	z-index: 10000 !important;
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
</style>
<script>

var curTeamCode="";
var proc_state="";
var run_freq="";
var trigger_type="";
var _treeSql="";
var procStore="";
var procSql=" SELECT a.proc_name,a.target,b.dbname,b.dataname,b.datacnname,a.data_time,a.generate_time ,b.team_code,b.topicname,(case when c.proc_name is null then a.proc_name else c.proc_name end) procname " +
			" FROM proc_schedule_meta_log a" +
			" INNER JOIN tablefile b ON a.target=b.xmlid " +
			" LEFT JOIN proc c ON a.proc_name=c.xmlid" +
			" where 1=1 {condi} ";

var _treeSql=" select  topicname,count(1) num from (" + procSql + ") t " +
	   	     " group by topicname order by num desc";
				   		  
var getQueryCondition = function(){
	var _searchText = $("#search-text").val().trim();
	var _searchCondi =_searchText.length>1?" AND (b.dataname LIKE '%"+ _searchText+"%' or b.datacnname LIKE '%"+_searchText+"%')":"";
	var _searchDate=$("#search-date-time").val().trim();
	_searchCondi += _searchDate.length>0?" AND a.data_time like '" + _searchDate + "' ":"";
	var _cycletype=$("#run_freq_select").val();
	 _searchCondi += _cycletype.length>0?" AND b.cycletype='"+_cycletype+"'":"";
	var _teamCodeCondi = (typeof(curTeamCode)=="undefined" || curTeamCode =='' || curTeamCode == 'undefined' )?(''):("  and team_code = '"+curTeamCode+"' ")
	 _searchCondi += _teamCodeCondi;
    return _searchCondi;
};

var switchContent = function(condi){
	buildTreeView(_treeSql.replace("{condi}",condi));
	procStore.select(procSql.replace("{condi}",condi) + " order by data_time desc");
};

var buildTreeView = function(sql){
	$('#treeview6').treeview({
		color: "#428bca",
		expandIcon: "glyphicon glyphicon-chevron-right",
		collapseIcon: "glyphicon glyphicon-chevron-down",
		nodeIcon: "glyphicon glyphicon-tasks",
		showTags: true,
		onNodeSelected:function(event,node){
			var strArray=node.id.split(">");
			var where="";
			for(var i=0;i<strArray.length;i++){
				var str =strArray[i];
				var subWhere=str.split(":")[0]+" = '"+str.split(":")[1]+"'";
				if(str.split(":")[1]=='未知') subWhere = str.split(":")[0] +" is null ";
				if(where) where += " and "+ subWhere
				else where=subWhere;
			}
			where = where.length>0?(" and "+where):"";
			procStore.select(procSql.replace("{condi}",where+searchCondi));
			if(curDisplayType=="card"){
				$("#tabpanel2").show();
				$("#datagrid").hide();
			}else{
				$("#datagrid").show();
				$("#tabpanel2").hide();
			}
		},
		groupfield: "TOPICNAME",
		titlefield: "TOPICNAME",
		iconfield: "",
		sql: sql,
		dataSource: "METADBS",
		subtype: 'grouptree' 
	});
};


$(document).ready(function() {
	curTeamCode = paramMap['team_code'];
	var curDisplayType="grid";
	var searchCondi='';
	var curdata;
	var toggleButtons = '<div class="btnCenter"></div>'
		+ '<div class="btnBoth"></div>'
		+ '<div class="btnWest"></div>';
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
		,	west__togglerContent_closed:	toggleButtons
		,	west__togglerContent_open:		toggleButtons
		,	west__size:						205
		,	north__size: 					50
	});

	var today = new Date();
	today.setDate(today.getDate()-1);
	var defaultDataTime = today.format("yyyymmdd");
	$("#search-date-time").val(defaultDataTime);
    
    var condi=getQueryCondition();
	buildTreeView(_treeSql.replace("{condi}",condi + " order by data_time desc"));
	
    procStore = new AI.JsonStore({
		sql:procSql.replace("{condi}", condi),
		pageSize:15,
		key:"SEQNO",
		table:"proc_schedule_meta_log",
		dataSource:"METADBS"
	});
	var config={
		id:'datagrid',
		store:	procStore,
		pageSize:12,
		containerId:'datagrid',
		nowrap:true,
		showcheck:true,
		rowclick: function (e,agr){
			curdata= agr.data;
		},
		celldblclick: function(val,rowdata){
			if(rowdata){
				//window.open("WizCreTable.html?OBJNAME="+rowdata.get('DATANAME'));
				//parent.loadTabStruct(rowdata.get('DATANAME'));
				var r = procStore.curRecord;
			   	var DBNAME = DBNAME='defaultDB';
			  	var METAPRJ = '';
			  	var caption='';
				var _title ="表:"+r.get('TARGET')+" 血缘分析";
				//parent.openTableInfo("ana-Before",_title,r.get('PROC_NAME'),true);
			}
			return false;
		},
		columns:[
		         {header: "数据名", width:130,dataIndex: 'DBNAME'},
			　  	 //{header: "表ID", width:130,dataIndex: 'TARGET'},
			　  	 {header: "表名", width:130,dataIndex: 'DATANAME'},
		  	     {header: "中文名称", width:200, dataIndex: 'DATACNNAME'},
		  	     {header: "数据日期", width:74, dataIndex: 'DATA_TIME'},
		  	     {header: "生成时间", width:75, dataIndex: 'GENERATE_TIME'},
		  	     {header: "生成来源", width:75, dataIndex: 'PROCNAME'} 
		]
	};
	var grid =new AI.Grid(config);
	
	$('#trigger_type_select').change(function(){
		trigger_type= $("#trigger_type_select").val();
        switchContent(getQueryCondition());
	});

	$('#run_freq_select').change(function(){
		run_freq = $("#run_freq_select").val();
		switchContent(getQueryCondition());
	});
	$('#search').click(function(){
		switchContent(getQueryCondition());
	});
	$("#insertBtn").click(function(){
		
	})

	var _checkUniq = function(arr){
		if(arr.length!=1){
			alert("请选取一项！");
		}
		return arr.length==1?true:false;
	}
	
	var $el = parent.$('#panel1');
	
	var bindCarouselWithProc = function(tabName){
		$el.on("push-left-"+tabName,function(){
			curIndex = parseInt(procStore.curIndex);
			var _index = curIndex==0?procStore.getCount()-1:curIndex-1;
			var r = procStore.getAt(_index);
			var _title = "程序:"+r.get('PROC_NAME').toUpperCase()+" 影响分析";
			parent.openTableInfo(tabName,_title,r.get('PROC_NAME'),true);
			procStore.curIndex = _index;
		});
		$el.on("push-right-"+tabName,function(){
			curIndex = parseInt(procStore.curIndex);
			var _index = curIndex==procStore.getCount()-1?0:curIndex+1;
			var r = procStore.getAt(_index);
			var _title = "程序:"+r.get('PROC_NAME').toUpperCase()+" 影响分析";
			parent.openTableInfo(tabName,_title,r.get('PROC_NAME'),true);
			procStore.curIndex = _index;
		});
	};

});
</script>
</head>

<body class="">
	<div class="ui-layout-north">
		<nav class="navbar navbar-default" role="navigation"
			style="margin-bottom: 1px">
			<div class="container-fluid" style="padding-left: 0px">
				<div class="collapse navbar-collapse" style="padding-left: 0px">
					<ul class="nav navbar-nav">
						<li><a><i class="fa fa-home"> </i> 数据生成记录</a></li>
					</ul>
					<form class="navbar-form navbar-left" role="search">
						<div class="form-group">
							<select id="run_freq_select" class="form-control formElement">
								<option value="">周期</option>
								<option value="year">年</option>
								<option value="month">月</option>
								<option value="day">日</option>
								<option value="hour">小时</option>
								<option value="minute">分钟</option>
							</select>
						</div>
						<div class="form-group">
							<input id="search-text" type="text" class="form-control"
								style="width: 200px" placeholder="输入表名,中文名">
							<input id="search-date-time" type="text" class="form-control"
								style="width: 200px" placeholder="数据日期">								
						</div>
						<div class="form-group formItem" id="search" style="margin-left:10px">	
							<button type="button" class="btn search_btn btn-sm btn-primary formElement">查询</button>
						</div>
						<!-- <button id="insertBtn" type="button"
							class="btn btn-primary btn-xs">分析</button> -->
					</form>
				</div>
				<!-- /.navbar-collapse -->
			</div>
			<!-- /.container-fluid -->
		</nav>
	</div>
	<div class="ui-layout-west" style="overflow: auto;">
		<div id="treeview6" class="test"></div>
	</div>
	<div class="ui-layout-center">
		<div id="datagrid" style="margin-bottom: 10px; margin-right: 10px"></div>
		<div id="tabpanel2" style="margin-bottom: 10px"></div>
	</div>
</body>
</html>