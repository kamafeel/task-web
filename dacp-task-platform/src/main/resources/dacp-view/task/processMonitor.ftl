<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>后台进程监控</title>
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen" />
	<link href="${mvcPath}/dacp-lib/datepicker/datepicker.css" type="text/css" rel="stylesheet" media="screen" />
	<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"  />
	<link href="${mvcPath}/dacp-lib/dacp-icon/style.css" type="text/css" rel="stylesheet"  />
	
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/jquery/jquery-ui-1.10.2.min.js"></script>
	<script src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
	<script src="${mvcPath}/dacp-lib/datepicker/bootstrap-datepicker.js" ></script>
	
    <!-- 使用ai.core.js需要将下面两个加到页面 -->
	<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
	<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
	
	<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
  	<script src="${mvcPath}/dacp-view/task/js/bootstrap-treeview.js"></script>

	<style>
	.dacp-btn {
	    background-color: transparent;
	    border-color: transparent;
	}
	.dacp-btn:hover{
	    background-color: transparent;
	    border-color: transparent;
	}
	
    
	.container{
    	position: relative;
    	font-family: MicrosoftYaHei, "Microsoft YaHei";
    }
	.left{
		position: absolute;
		left: 0px;
		width: 205px;
		height: 580px;
		over-flow: auto;
		border: 1px solid rgba(224, 230, 237, 1);
		background-color: rgba(249, 250, 252, 1);
		overflow: hidden;
	}
	#leftHeader{
		width: 205px;
		height: 35px;
		line-height: 35px;
		border: 1px solid rgba(224, 230, 237, 1);
		margin-bottom:2px;
	}
	#leftHeader .pull-left span{
		font-size: 16px;
		margin-left: 10px;
		color: #475669;
	}
	#leftHeader .pull-right span{
		font-size: 20px;
		width: 20px;
		height: 20px;
		line-height: 35px;
		margin-right: 10px;
		color: #A2B0C4;
		cursor: pointer;
	}
	#leftTree{
		background-color: white;
		clear: both;
	}
	
	#separateBar{
		position: absolute;
	    top: 150px;
	    left: 205px;
	    width: 6px;
	    height: 120px;
	    background-color: #bcbcbc;
	    cursor: pointer;
	    z-index: 1;
	}
	.resize_button_left{
	    border-radius: 0 4px 4px 0;
	}
	.resize_button_left div{
		color: #fff;
	    margin-top: 50px;
	    border-right: 6px solid;
	    border-top: 6px solid transparent;
	    border-bottom: 6px solid transparent;
	}
	
	.resize_button_right{
		border-radius: 4px 0 0 4px;
	}
	.resize_button_right div {
		color:#fff;
		margin-top:50px;
		border-left: 6px solid;
	    border-top: 6px solid transparent;
	    border-bottom: 6px solid transparent;
	}
	
	.right{
		position: absolute;
		left: 210px;
		right: 0;
    	height: 580px;
	}
	.query{
		height: 45px;
		line-height: 40px;
		border-bottom: 2px solid #adf;
	}
	.query .form-group{
		margin-left: 10px;
		color: #A2B0C4;
	}
	.query .form-group input{
		height: 28px;
		font-weight: 400;
		font-style: normal;
		font-size: 12px;
		text-decoration: none;
		color: #475669;
		text-align: left;
		outline-style: none;
	}
	
	.query #btn-search{
		width: 30px;
		height: 28px;
    	padding-left: 8px;
    	background-color: rgba(71, 178, 251, 1);
    	bord-color: rgba(71, 178, 251, 1);
	}
	
	.grid{
		
	}
	.grid .option{
		height: 40px;
		line-height: 40px;
	}
	.grid .option .option-item{
		margin-left: 10px;
		cursor: pointer;
		color: rgb(71, 86, 105);
		font-size: 12px;
	}
	.grid .option .option-item:hover{
		color: #5781b3;
	}
	
	#list tr td .d-icon-edit{
		color: #00CF9B;
	}
	#list tr td .d-icon-delete{
		color: #FB6362;
	}
	#list tr td .d-icon-stop{
		color: #47B2FB;
	}
	#list tr td .d-icon-caret-right{
		color: #47B2FB;
	}
	#list tr td .d-icon-view-detail{
		color: #47B2FB;
	}
	
	</style>
	<script>
	
	var page = {
		_sql: "select * from process_list where 1=1 {where}",
		_store: null,
		_grid: null,
	    init: function(){
	    	this.initGrid();
	    	this.initTreeView();
	    },
	    bindHostList: function(){
	    	
	    },
	    initTreeView: function(){
	    	var json = []
	    	var _url = "/" + contextPath + "/process/getBusiness";
	    	$.ajax({
	    		headers: {'Content-type': 'application/json;charset=UTF-8'},
				url: _url,
				data: {
					team_code: _UserInfo.teamCode||''
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
	    	
	        var $tree = $('#leftTree').treeview({
	         	expandIcon: "d-icon-caret-right",
	 			collapseIcon: "d-icon-caret-bottom",
	 			nodeIcon: "d-icon-folder-open",
	 			color: "#475669",
	 			backColor: "#fff",
	 			onhoverColor: "#f5f5f5",
	 			borderColor: "#d8d8d8",
	 			showBorder: false,
	 			showTags: true,
	 			highlightSelected: true,
	 			selectedColor: "#fff",
	 			selectedBackColor: "#aaa",
	 	        showCheckbox: false,
	 			data: json,
	 			onNodeSelected: function(event, data) {
	 	    		var selectVal = data.fullVal;
	 				var nodeCondi = " and business like '" + selectVal + "%'";
	 				nodeCondi += page.getQueryCondi();
	 				page._store.select(page._sql.replace("{where}",nodeCondi));
	 			},
			    onNodeUnselected: function(event, data) {
			    	
			    }
			});
			$('#leftTree').treeview('collapseAll', { silent: true });
	    },
	    initGrid: function(){
	    	this._store = new AI.JsonStore({
				sql: page._sql.replace("{where}",""),
				dataSource: 'METADBS',
				pageSize: 12
	    	})
	    	var columns = [
	    		{header:"进程名称",dataIndex:'PNAME',sortable:true,cls: "ai-grid-body-td-left"},
	    		{header:"部署路径",dataIndex:'DEPLOY_PATH',sortable:true},
	    		{header:"进程状态",dataIndex:'PSTATUS',sortable:true,cls: "ai-grid-body-td-center",
	    			render: function(data,val){
	    				return data.data.PSTATUS==1?'<span style="color: green;">启动</span>':'<span style="color: red;">停止</span>';
	    			}
	    		},
	    		{header:"进程启动命令",dataIndex:'START_CMD',sortable:true},
	    		{header:"进程停止命令",dataIndex:'STOP_CMD',sortable:true},
	    		{header:"操作",dataIndex:'OPTION',sortable:true,
	    			render: function(data,val){
	    				var id = data.data.PID;
	    				var flag = data.data.PSTATUS==1?false:true;
	    				var optionHtml = "";
	    				optionHtml+='<span class="btn btn-xs dacp-btn" onclick="editItem(\''+id+'\')"><i class="d-icon-edit"></i></span>';
	    				optionHtml+='<span class="btn btn-xs dacp-btn" onclick="deleteItem(\''+id+'\')"><i class="d-icon-delete"></i></span>';
	    				optionHtml+='<span class="btn btn-xs dacp-btn" onclick="startOrStop(\''+id+'\','+flag+')"><i class="'+(flag?"d-icon-caret-right":"d-icon-stop")+'"></i></span>';
	    				optionHtml+='<span class="btn btn-xs dacp-btn" onclick="viewItem(\''+id+'\')"><i class="d-icon-view-detail"></i></span>';
	    				return optionHtml;
	    			}
	    		}
	    	];
	    	
	    	$("#grid-table").empty();
	    	this._grid = new AI.Grid({
	    		id: 'list',
				store: this._store,
				containerId: 'grid-table',
				showcheck: true,
				celldblclick: function(val,record){
				},
				columns: columns
	    	});
	    },
	    getQueryCondi: function(){
	    	var _condi = "";
	    	var inputName = $('#input-name').val().trim();
	    	
	    	if(inputName.length>0){
	    		_condi+= " and pname like '%" + inputName + "%'";
	    	}

	    	/* var startDate = $('#start-date').val().trim();
	    	if(startDate.length>0){
	    		_condi+=" and proc_name like '%" + taskName + "%'";
	    	} */
			
	    	return _condi;
	    },
	    switchContent: function(condi){
	    	if(!condi||typeof(condi)=="undefined"){
	    		condi="";
	    	}
	    	this._store.select(page._sql.replace("{where}",condi));
	    	
	    	//重置左边树
	    	this.initTreeView();
	    },
	}
	
	$(function(){
		page.init();
		
		$("#btn-search").click(function(){
			page.switchContent(page.getQueryCondi());
		})
		
		$("#config-process").click(function(){
			window.open("processConfig?action=add&&pid="+ai.guid());
		});
		
		$("#separateBar").click(function(){
			//伸缩树形菜单
			var width = $(".left").width();
			if(parseInt(width)>5){
				$(".left").animate({width:0});
				$(".right").animate({left:5},function(){
					$("#separateBar").removeClass("resize_button_left").addClass("resize_button_right");
				});
				$("#separateBar").animate({left:0});
			}else{
				$(".left").animate({width:205});
				$(".right").animate({left:210},function(){
					$("#separateBar").removeClass("resize_button_right").addClass("resize_button_left");
				});
				$("#separateBar").animate({left:205});
			}
		});
		
		$("#start-all").click(function(){
			if(confirm("确定要全部启动吗？")){
				
			}
		});
		$("#stop-all").click(function(){
			if(confirm("确定要全部停止吗？")){
				
			}
		});
		$("#start-process").click(function(){
			if(confirm("确定要启动该进程吗？")){
				
			}
		});
		$("#stop-process").click(function(){
			if(confirm("确定要停止该进程吗？")){
				
			}
		});
		$("#view-process").click(function(){
			window.open("processLog");
		});
		
	});
	
	function editItem(id){
		//阻止冒泡
		this.event.stopPropagation();
		
		window.open("processConfig?action=edit&&pid="+id);
	}
	function deleteItem(id){
		//阻止冒泡
		this.event.stopPropagation();
		
		if(confirm("确定要删除该进程记录吗？")){
			$.ajax({
	            url: "delete",
	            type: 'POST',
	            async : false,
	            data: {
	            	pid:id
	            },
	            dataType: 'json',
	            success: function (returnData) {
					alert("已删除")
	            },
				error: function(error) {
					alert("删除失败")
				}
	        });
			page.switchContent(page.getQueryCondi());
		}
	}
	
	function startOrStop(id,flag){
		//阻止冒泡
		this.event.stopPropagation();
		
		if(flag){

			alert("start:"+id)
		}else{

			alert("stop:"+id)
		}
	}
	function viewItem(id){

		alert("viewItem:"+id)
	}
	</script>
</head>
<body>
<div class="container">
	<div class="left">
		<div id="leftHeader">
			<div class="form-line">
				<div class="pull-left">
					<span>所属业务</span>
				</div>
			</div>
		</div>
		<div id="leftTree"></div>
	</div>
	<div id="separateBar" class="resize_button_left">
		<div></div>
	</div>
	<div class="right">
		<div id="query-panel" class="query form-inline">
			<div class="form-group">
				<span for="input-name">进程名称：</span>
				<input id="input-name" type="text" class="form-control" placeholder="输入名称">
			</div>
			<div class="form-group">
				<span for="start-date">所属主机：</span>
				<select id="host_name">
					<option>请选择</option>
				</select>
			</div>
			<div class="form-group">
				<button id="btn-search" type="button" class="btn btn-sm btn-info" ><span class="d-icon-search"></span></button>
			</div>
		</div>

		<div id="grid-panel" class="grid">
			<div class="option form-inline">
				<div id="config-process" class="form-group option-item">
					<span class="d-icon-document"></span>
					<span>配置进程</span>
				</div>
				<div id="start-all" class="form-group option-item">
					<span class="d-icon-start-all"></span>
					<span>全部启动</span>
				</div>
				<div id="stop-all" class="form-group option-item">
					<span class="d-icon-stop-all"></span>
					<span>全部停止</span>
				</div>
				<div id="start-process" class="form-group option-item">
					<span class="d-icon-caret-right"></span>
					<span>启动</span>
				</div>
				<div id="stop-process" class="form-group option-item">
					<span class="d-icon-stop"></span>
					<span>停止</span>
				</div>
				<div id="view-log" class="form-group option-item">
					<span class="d-icon-view-detail"></span>
					<span>查看日志</span>
				</div>
			</div>
			<div id="grid-table">
				
			</div>
		</div>
	</div>
</div>

</body>
</html>