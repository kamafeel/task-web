<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>任务主题配置</title>   
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"  />  
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	<link href="${mvcPath}/dacp-view/task/css/zTree.css" type="text/css" rel="stylesheet"  />
	<link href="${mvcPath}/dacp-view/task/css/zTreeStyle.css" type="text/css" rel="stylesheet"  />
	
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="${mvcPath}/dacp-lib/jquery/jquery-ui-1.10.2.min.js"></script>
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
    <script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
	<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
    <script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
	<script src="${mvcPath}/dacp-lib/underscore/underscore-min.js"></script>
    <script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
	<script src="${mvcPath}/dacp-view/task/js/jquery.ztree.core.min.js"></script>
    <script src="${mvcPath}/dacp-view/task/themeconfig.js"></script>
    <script src="${mvcPath}/dacp-view/task/js/Load.js"></script>
    <script type="text/javascript">
    	var setting = {
    		view: {
    			selectedMulti: false
    		},
    		edit: {
    			enable: true,
    			showRemoveBtn: false,
    			showRenameBtn: false
    		},
    		data: {
    			keep: {
    				parent:true,
    				leaf:true
    			},
    			simpleData: {
    				enable: true
    			}
    		}
    	};
    
	    $(document).ready(function(){
	    	var self = this;
	    	buildTree();
	    	$("#dialog-ok").bind("click", dialogOk);
	    	$(".close-modal").on('click', close);
	    	_queryPanel.$el=$("#queryPanel");
	    	_queryPanel.render();
	    });
    </script>
<style>
body {     
	margin: 0;
	font-family: Roboto, arial, sans-serif;
	font-size: 13px;
	line-height: 20px;
	color: #444444;
	background-color: #f1f1f1;
	height: 100%
}
 
.navbar-btn.btn-sm {
	margin-top: 5px;
	margin-bottom: 10px;
}

#myModal {
	z-index: 999999;	
}

#queryPanel{
	margin-top:10px;
	margin-left:20px;
}

html, body, .ui-layout-center {
	overflow: auto;
	height: 96%;
}
</style>
</head>
<body>
	<div id="myModal" class="modal fade"> 
	   <div class="modal-dialog"> 
		   <div class="modal-content" > 
			   <div class="modal-header"> 
				   <button type="button" class="close close-modal" > <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> 
				   <h4 class="modal-title" >节点新增</h4> 
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
	   <div id="queryPanel"></div>
	</div>
	<div class="ui-layout-center" >
		<ul id="treeTheme" class="ztree"></ul>
	</div>
</body>
</html>