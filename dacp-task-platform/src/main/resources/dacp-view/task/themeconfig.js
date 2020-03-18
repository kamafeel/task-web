function buildTree(){
	$.ajax({
   		url:"/"+contextPath+"/task/themeconfig/getThemeTree",
   		datatype:"json",
   		data:null,
   		type:'post',
   		async:true,
   		success:function(data){
   			if(data.success==false){
   			 	new Load({type: 'error', text: data.msg, auto: true, time: 2000});
   				return;
   			}
   			$.fn.zTree.init($("#treeTheme"), self.setting, data.data);
   			$.fn.zTree.getZTreeObj("treeTheme").expandAll(true);
   		},
   		error:function(){
   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
   		}
   	});
}
//查询面板
var _queryPanel = new ve.FormWidget({
	config:{
		"class":"form",
		"formClass":"form-inline",
		"id": "_query",
		"noJustfiyFilter":"on",
		"items": [
			{
				"id":"addParent",
				"value":"新增父节点",
				"type":"button",
				"className":"btn btn-sm btn-default"
			},
			{
				"id":"addLeaf",
				"value":"新增子节点",
				"type":"button",
				"className":"btn btn-sm btn-default"
			},
			{
				"id":"edit",
				"value":"编辑节点",
				"type":"button",
				"className":"btn btn-sm btn-default"
			},
			{
				"id":"remove",
				"value":"删除节点",
				"type":"button",
				"className":"btn btn-sm btn-default"
			},
			{
				"id":"clearLeaf",
				"value":"清空子节点",
				"type":"button",
				"className":"btn btn-sm btn-default"
			}
		],
		'events': {
			'click #addParent':function(){
				showDialog("addParent", null);
			},
			'click #addLeaf':function(){
				var zTree = $.fn.zTree.getZTreeObj("treeTheme");
				nodes = zTree.getSelectedNodes();
				if (nodes.length == 0) {
					alert("请先选择一个节点");
					return;
				}
				treeNode = nodes[0];
				showDialog("addLeaf", treeNode);
			},
			'click #edit':function(){
				var zTree = $.fn.zTree.getZTreeObj("treeTheme");
				nodes = zTree.getSelectedNodes();
				if (nodes.length == 0) {
					alert("请先选择一个节点");
					return;
				}
				treeNode = nodes[0];
				showDialog("edit", treeNode);
			},
			'click #remove':function(){
				var zTree = $.fn.zTree.getZTreeObj("treeTheme");
				nodes = zTree.getSelectedNodes();
				if (nodes.length == 0) {
					alert("请先选择一个节点");
					return;
				}
				treeNode = nodes[0];
				if(!window.confirm("确定删除？")){
					return;
				}
				var params = {id:treeNode.id};
				$.ajax({
			   		url:"/"+contextPath+"/task/themeconfig/deleteTheme",
			   		datatype:"json",
			   		data:params,
			   		type:'post',
			   		async:true,
			   		success:function(data){
			   			if(data.success==false){
			   				new Load({type: 'error', text: data.msg, auto: true, time: 2000});
			   				return;
			   			}
			   			new Load({type: 'success', text: "删除成功", auto: true, time: 2000});
			   			buildTree();
			   		},
			   		error:function(){
			   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
			   		}
			   	});
			},
			'click #clearLeaf':function(){
				var zTree = $.fn.zTree.getZTreeObj("treeTheme");
				nodes = zTree.getSelectedNodes();
				if (nodes.length == 0) {
					alert("请先选择一个父节点");
					return;
				}
				treeNode = nodes[0];
				if(!window.confirm("确定清空子节点？")){
					return;
				}
				var params = {pid:treeNode.id};
				$.ajax({
			   		url:"/"+contextPath+"/task/themeconfig/clearLeaf",
			   		datatype:"json",
			   		data:params,
			   		type:'post',
			   		async:true,
			   		success:function(data){
			   			if(data.success==false){
			   				new Load({type: 'error', text: data.msg, auto: true, time: 2000});
			   				return;
			   			}
			   			new Load({type: 'success', text: "清空子节点成功", auto: true, time: 2000});
			   			buildTree();
			   		},
			   		error:function(){
			   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
			   		}
			   	});
			}
		}
	}
});
//弹出编辑框		
function showDialog(actType, node){
	$('#upsertForm').empty();
	$("#dialog-ok").show();
	_act = actType;
	var itemscfg =[];
	if (_act == "addParent"){
		$(".modal-title").html("父节点新增");
		itemscfg.push({type:'text',label:'主题名称',notNull:'N',fieldName :'THEME_NAME',width:300});
	}
	if (_act == "addLeaf") {
		$(".modal-title").html("子节点新增");
		itemscfg.push({type:'hidden',label:'PID',notNull:'N',fieldName :'PID',isReadOnly:'y',width:300});
		itemscfg.push({type:'text',label:'父级名称',notNull:'N',fieldName :'PARENT_NAME',isReadOnly:'y',width:300});
		itemscfg.push({type:'text',label:'主题名称',notNull:'N',fieldName :'THEME_NAME',width:300});
	}
	if (_act == "edit") {
		$(".modal-title").html("主题更新");
		itemscfg.push({type:'hidden',label:'ID',notNull:'N',fieldName :'ID',isReadOnly:'y',width:300});
		itemscfg.push({type:'text',label:'原主题名称',notNull:'N',fieldName :'OLD_NAME',isReadOnly:'y',width:400});
		itemscfg.push({type:'text',label:'新主题名称',notNull:'N',fieldName :'THEME_NAME',width:400});
	}
	var _editPanel = new AI.Form({
		id: 'baseInfoForm',
		containerId: 'upsertForm',
		fieldChange: function(fieldName, newVal){},
		items: itemscfg
	});
	$("#myModal").modal({
		show:true,
		backdrop:false
	});
	if(_act=="addLeaf" ){
		$("#PID").val(node.id);
		$("#PARENT_NAME").val(node.name);
	}
	if(_act=="edit" ){
		$("#ID").val(node.id);
		$("#OLD_NAME").val(node.name);
	}
};
//确定
function dialogOk(){
	var pid;
	var id;
	var themeName = $("#THEME_NAME").val().trim();
	if (!themeName || themeName.length==0){
		alert("主题名称不能为空！");
		return false;
	}
	if (_act == "addParent"){
		var params = {themeName:themeName, opType:_act};
		$.ajax({
	   		url:"/"+contextPath+"/task/themeconfig/saveTheme",
	   		datatype:"json",
	   		data:params,
	   		type:'post',
	   		async:true,
	   		success:function(data){
	   			if(data.success==false){
	   			 	new Load({type: 'error', text: data.msg, auto: true, time: 2000});
	   				return;
	   			}
	   			$('#myModal').modal('hide');
	   			new Load({type: 'success', text: "新增父节点成功", auto: true, time: 2000});
	   			buildTree();
	   		},
	   		error:function(){
	   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
	   		}
	   	});
	}
	if (_act == "edit"){
		id = $("#ID").val().trim();
		var params = {themeName:themeName, opType:_act, id:id};
		$.ajax({
	   		url:"/"+contextPath+"/task/themeconfig/saveTheme",
	   		datatype:"json",
	   		data:params,
	   		type:'post',
	   		async:true,
	   		success:function(data){
	   			if(data.success==false){
	   			 	new Load({type: 'error', text: data.msg, auto: true, time: 2000});
	   				return;
	   			}
	   			$('#myModal').modal('hide');
	   			new Load({type: 'success', text: "编辑节点成功", auto: true, time: 2000});
	   			buildTree();
	   		},
	   		error:function(){
	   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
	   		}
	   	});
	}
	if(_act=="addLeaf"){
		pid = $("#PID").val().trim();
		var params = {themeName:themeName, opType:_act, pid:pid};
		$.ajax({
	   		url:"/"+contextPath+"/task/themeconfig/saveTheme",
	   		datatype:"json",
	   		data:params,
	   		type:'post',
	   		async:true,
	   		success:function(data){
	   			if(data.success==false){
	   			 	new Load({type: 'error', text: data.msg, auto: true, time: 2000});
	   				return;
	   			}
	   			$('#myModal').modal('hide');
	   			new Load({type: 'success', text: "新增子节点成功", auto: true, time: 2000});
	   			buildTree();
	   		},
	   		error:function(){
	   			new Load({type: 'warn', text: '请求服务失败', auto: true, time: 2000});
	   		}
	   	});
	}
};
//取消
function close(){
   $('#myModal').modal('hide');
};