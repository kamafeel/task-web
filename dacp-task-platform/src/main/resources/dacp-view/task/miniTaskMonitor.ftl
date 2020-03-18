<!DOCTYPE html> 
<html lang="zh" class="app"> 
<head>      
	<meta charset="utf-8" />         
	<title>任务监控</title>     
	<meta http-equiv="X-UA-Compatible" content="chrome=1,ie=edge"/>
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/datepicker.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.simpledate.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.pst-area-control.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-view/ve/css/dacp-ve-js-1.0.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-view/css/smartMenu.css" type="text/css" rel="stylesheet" />
	<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"  />
	
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/jquery/jquery-ui-1.10.2.min.js"></script>
	<script src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
	<script src="${mvcPath}/dacp-lib/underscore/underscore-min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/backbone/backbone-min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/datepicker/bootstrap-datepicker.js" type="text/javascript" ></script>
	<script src="${mvcPath}/dacp-lib/datepicker/jquery.simpledate.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/datepicker/jquery.pst-area-control.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-view/ve/js/dacp-ve-js-1.0.js" type="text/javascript" charset="utf-8"></script>
	<script src="${mvcPath}/ve/ve-context-path.js" type="text/javascript" charset="utf-8"></script>

    <script src="${mvcPath}/dacp-lib/jquery-plugins/bootstrap-treeview.min.js"> </script>
    <script src="${mvcPath}/dacp-lib/jquery-plugins/jquery.layout-latest.js" type="text/javascript"> </script>
	<script src="${mvcPath}/dacp-view/task/js/jquery-smartMenu.js"></script>
    <script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
    
    
    <!-- 使用ai.core.js需要将下面两个加到页面 -->
	<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
	<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
	
	<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
	<!-- <script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script> -->
	<script src="${mvcPath}/dacp-view/task/js/ai.grid.js"></script>
    
  	<script src="${mvcPath}/dacp-view/task/taskType.js"></script>
  	<script src="${mvcPath}/dacp-view/task/js/scheduleOpLog.js"></script>
  	<script src="${mvcPath}/dacp-view/task/js/bootstrap-treeview.js"></script>
  	
<style type="text/css">

html {
    background-color: #f8f9fa;
}
.ai-grid thead th {
    font-weight: 500;
}

.btn-gray{
	background-color: gray;
    border-color: gray;
    color: #fff;    
    text-decoration: line-through;
}
.btn-gray:hover{
	background-color: gray;
    border-color: gray;
    color: #fff;    
    text-decoration: line-through;
}
.dropdown-menu li{
	cursor: pointer;
}
.formItem{
	height: 45px;
}
button{
	outline: none;
}

#totalPanel .totalPanel{
	min-width: 1000px;
	height: 70px;
	background-color: #fff;
	border: 1px solid #ebebeb;
	padding-left: 0;
}

#totalPanel .totalPanel li{
	list-style: none;
	float: left;
	min-width: 80px;
	margin: 10px 5px;
}

#totalPanel .totalPanel .total-li{
	border: 1px solid #fff;
	font-size: 12px;
}
#totalPanel .totalPanel .total-val:hover{
	font-size: 20px;
}
#totalPanel .totalPanel .active{
	background-color: #eff5fd;
	border: 1px solid #d8d8d8;
	font-size: 14px;
}
#totalPanel .totalPanel li dt{
	line-height:20px;
    text-align: center;
    font-weight: 500;
}

#totalPanel .totalPanel li dd{
    line-height: 30px;
    font-size: 18px;
    font-weight: bolder;
    text-align: center; 
}

#totalPanel .totalPanel li .total-val{
	cursor: pointer;
}

#queryPanel{
	background-color: #fff;
	border: 1px solid #ddd;
	position: relative;
}
#queryPanel #filter{
	height: 45px;
	line-height: 40px;
	border-bottom: 1px solid #ddd;
}
#queryPanel #moreFilter{
	height: 45px;
	line-height: 40px;
	border-bottom: 1px solid #ddd;
}

#tabPanel>#treeView{
    position: absolute;
	width: 200px;
	overflow: hidden;
}
#tabPanel>#treeView ul li{
	overflow: hidden;
}
#tabPanel>#separateBar{
	position: absolute;
    top: 30%;
    left: 200px;
    width: 6px;
    height: 120px;
    background-color: #bcbcbc;
    cursor: pointer;
    z-index: 1;
}
#tabPanel .resize_button_left{
    border-radius: 0 4px 4px 0;
}
#tabPanel .resize_button_left div{
	color: #fff;
    margin-top: 50px;
    border-right: 6px solid;
    border-top: 6px solid transparent;
    border-bottom: 6px solid transparent;
}

#tabPanel .resize_button_right{
	border-radius: 4px 0 0 4px;
}
#tabPanel .resize_button_right div {
	color:#fff;
	margin-top:50px;
	border-left: 6px solid;
    border-top: 6px solid transparent;
    border-bottom: 6px solid transparent;
}

#tabPanel>#taskList{
    position: absolute;
    left: 206px;
    right: 0;
}

</style>

<script>
var cycleList=${cycleList!"[]"};
var agentList=${agentList!"[]"};

$(document).ready(function() {
	var options = {
		teamCode : paramMap["team_code"]
	}
	page.__init__(options);
	
	//点击分隔栏伸缩左边树
	$("#separateBar").click(function(){
		var width = $("#treeView").width();
		if(parseInt(width)>10){
			$("#treeView").animate({width:0});
			$("#taskList").animate({left:10},function(){
				$("#separateBar").removeClass("resize_button_left").addClass("resize_button_right");
			});
			$("#separateBar").animate({left:1});
		}else{
			$("#treeView").animate({width:200});
			$("#taskList").animate({left:206},function(){
				$("#separateBar").removeClass("resize_button_right").addClass("resize_button_left");
			});
			$("#separateBar").animate({left:200});
		}
	});
})
</script>
<!-- 必须放下面 -->
<script src="${mvcPath}/dacp-view/task/miniTaskMonitor.js"></script>

</head>
<body class="body">
	<div id="myModal" class="modal fade"> 
	   <div class="modal-dialog"> 
		   <div class="modal-content" > 
			   <div class="modal-header"> 
				   <button type="button" class="close close-modal" > <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> 
				   <h4 class="modal-title">强制通过原因</h4>
			   </div> 
			   <div class="modal-body" id="upsertForm"></div>
			   <div class="modal-footer">
				   <button id="dialog-cancel" type="button" class="btn btn-default close-modal" >取消</button>
				   <button id="dialog-ok" type="button" class="btn btn-primary">通过</button>
			   </div>
		  </div>
	   </div>
	</div>
	
	<div id="totalPanel">
	
	</div>
	
	<div id="queryPanel">
		<div id="filter"></div>
		<div id="moreFilter" class="hide"></div>
	</div>
	
	<div id="tabPanel" >
		<div id="treeView"></div>
		<div id="separateBar" class="resize_button_left">
			<div></div>
		</div>
		<div id="taskList"></div>
	</div>
</body>
</html>
