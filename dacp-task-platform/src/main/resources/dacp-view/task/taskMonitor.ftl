<!DOCTYPE html> 
<html lang="zh" class="app"> 
<head>      
	<meta charset="utf-8" />         
	<title>大数据开放平台</title>     
	<meta http-equiv="X-UA-Compatible" content="chrome=1,ie=edge"/>
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/datepicker.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.simpledate.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-lib/datepicker/jquery.pst-area-control.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-view/ve/css/dacp-ve-js-1.0.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-res/task/css/implWidgets.css" type="text/css" rel="stylesheet"  />
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
    
    
  	<script src="${mvcPath}/dacp-view/task/taskType.js"></script>
  	<script src="${mvcPath}/dacp-view/task/js/scheduleOpLog.js"></script>
  	
<style type="text/css">
	body {
		margin: 0;
		font-family: Roboto, arial, sans-serif;
		font-size: 13px;
		line-height: 20px;
		color: #444444;
		background-color: #f1f1f1;
	}
	
	a{
		cursor:pointer;
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
	.ai-grid-body-td[dataindex=TASK_STATE]{
		overflow:visible !important;
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
	
	.dropdown-menu{
		position: absolute;
		top: 100%;
		left: 0;
		z-index: 99999;
		display: none;
		float: left;
		min-width: 60px;
		padding: 5px 0;
		margin: 2px 0 0;
		font-size: 14px;
		list-style: none;
		background-color: #fff;
		background-clip: padding-box;
		border: 1px solid #ccc;
		border: 1px solid rgba(0,0,0,.15);
		border-radius: 4px;
		-webkit-box-shadow: 0 6px 12px rgba(0,0,0,.175);
		box-shadow: 0 6px 12px rgba(0,0,0,.175);
		max-height:300px;
		overflow:visible;
	}
	#myModal{
		z-index: 99999;
	}
	.detail_dv:not(.detail_1){
		width: auto;
		min-width: 50px;
	    margin-right: 20px;
	}
	.detail_7{
		-moz-border-bottom-colors: none;
	    -moz-border-left-colors: none;
	    -moz-border-right-colors: none;
	    -moz-border-top-colors: none;
	    border-color: -moz-use-text-color #AADDFF;
	    border-image: none;
	    border-left: 1px solid #AADDFF;
	    border-right: 1px solid #0FEE9E;
	    border-style: none solid;
	    border-width: 0 0 0 3px;
	    float: right;
	    height:35px;
	    width: 95px;
	    margin-top:8px;
	    padding-left:5px;
	}
	.detail_8{
		-moz-border-bottom-colors: none;
	    -moz-border-left-colors: none;
	    -moz-border-right-colors: none;
	    -moz-border-top-colors: none;
	    border-color: -moz-use-text-color #AADDFF;
	    border-image: none;
	    border-left: 1px solid #AADDAA;
	    border-right: 1px solid #AADDFF;
	    border-style: none solid;
	    border-width: 0 0 0 3px;
	    float: right;
	    height:35px;
	    width: 95px;
	    margin-top:8px;
	    padding-left:5px;
	}
	
	.detail_9{
		-moz-border-bottom-colors: none;
	    -moz-border-left-colors: none;
	    -moz-border-right-colors: none;
	    -moz-border-top-colors: none;
	    border-color: -moz-use-text-color #AADDAA;
	    border-image: none;
	    border-left: 1px solid #BBCCAA;
	    border-right: 1px solid #AADDAA;
	    border-style: none solid;
	    border-width: 0 0 0 3px;
	    float: right;
	    height:35px;
	    width: 95px;
	    margin-top:8px;
	    padding-left:5px;
	}
	
	.detail_10{
		-moz-border-bottom-colors: none;
	    -moz-border-left-colors: none;
	    -moz-border-right-colors: none;
	    -moz-border-top-colors: none;
	    border-color: -moz-use-text-color #CCCCCC;
	    border-image: none;
	    border-left: 1px solid #CCCCCC;
	    border-right: 1px solid #BBBBBB;
	    border-style: none solid;
	    border-width: 0 0 0 3px;
	    float: right;
	    height:35px;
	    width: 95px;
	    margin-top:8px;
	    padding-left:5px;
	}
</style>

<script>
var cycleList=${cycleList!"[]"};
var agentList=${agentList!"[]"};
</script>
<!-- 必须放下面 -->
<script src="${mvcPath}/dacp-view/task/taskMonitor.js"></script>

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
	
	<div class="ui-layout-north" onclick="removeManualOptionList()">
	   <div class="row breadcrumb" id="totalPanel" style="margin:5px 1px 1px 1px;padding:6px 0px;"></div>
	   <div id="queryPanel">
	   	</div>
	</div>
	<div class="ui-layout-west" onclick="removeManualOptionList()">
		<div id="treeview6" class="test" style="overflow:auto;"></div>
	</div>
	<div class="ui-layout-center">
		<div id="tabpanel1"></div>
	</div>
</body>
</html>
