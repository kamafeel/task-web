﻿<!DOCTYPE html>
<html lang="zh" class="app">
<head>
<meta charset="utf-8" />
<title>大数据开放平台</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript" src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>

<!-- 使用ai.core.js需要将下面两个加到页面 -->
<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>

<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>


<script type="text/javascript" src="${mvcPath}/dacp-lib/underscore/underscore-min.js"></script>
<style>
body {
	margin: 0;
	font-family: Roboto, arial, sans-serif;
	font-size: 13px;
	line-height: 20px;
	color: #444444;
	background-color: #f1f1f1;
}
#ai-grid-table-div {
	margin-left: 10px;
}
.navbar-btn.btn-sm {
	margin-top: 5px;
	margin-bottom: 10px;
}
</style>

<script>
//数字验证  
var isNumber = function(n){
	var reg = /^\d+$/;
    return reg.test(n);
};
var team_code = paramMap["team_code"]||_UserInfo.teamCode;

$(document).ready(function() {
    var platform="";//当前选择的团队
    var curPlatform=""; 
    var curPlatformIPS=0; 
    var tableGrid = "";
    var isAdd = true;
    var whereCase="";
    var selectIndex=0;
   	var smsMsgGroupSql = "select sms_group_id,sms_group_name,team_code from sms_message_group where 1=1 {} order by sms_group_id";
   	var tableSql = "SELECT SMS_GROUP_ID,MEMBER_NAME,PHONENUM,STATUS FROM SMS_MESSAGE_GROUP_MEMBER where 1=1 {}";
  
	var smsMsgGroupStore = new AI.JsonStore({
		sql : smsMsgGroupSql.replace("{}"," and team_code='"+team_code+"'"),
		pageSize : -1,
		table : 'sms_message_group',
		key : 'SMS_GROUP_ID',
		dataSource:"METADBS"
	});	         
	var tableStore = new AI.JsonStore({
		sql :tableSql.replace("{}",whereCase),
		table:'SMS_MESSAGE_GROUP_MEMBER',
		pageSize : -1,
		key:'SMS_GROUP_ID,MEMBER_NAME',
		dataSource:"METADBS"
	});  
 
	var ipsRender = function(record, val){
		return val;
	};                  
    //打开编辑平台界面
    var showPlatformInfoDialog = function(acttype){
  		$("#platform-upsertForm").empty();
  		var isRead = 'n';
  		if(acttype=='edit'){
  			isRead='y';
  		}
		var formcfg = ({
			id : 'form',
			store : smsMsgGroupStore,
			containerId : 'platform-upsertForm',
			items : [ 
			{type: 'text',label:'用户组',notNull:'Y',fieldName:'SMS_GROUP_ID',isReadOnly:isRead,width:250}, 
			{type: 'text',label : '用户组名称',fieldName : 'SMS_GROUP_NAME',notNull:'N',width : 250 }
			]
		});

		var from = new AI.Form(formcfg);
		$('#platformConfig').modal({
			show : true,
			backdrop:false		
		});
		//取消
		$("#platformConfig #dialog-cancel").on('click', function(){
	   	    smsMsgGroupStore.select();
			$('#platformConfig').modal("hide");
	    });
	}; 
	var buildPlatformList = function(){
		var teamList = "";
		$("#teamList").empty();
		smsMsgGroupStore.select();
		for (var i = 0; i < smsMsgGroupStore.getCount(); i++) {
			var r=smsMsgGroupStore.getAt(i);
			var activeClass="";
			if(i==selectIndex){
				activeClass = " active ";
				curPlatform = r.get("SMS_GROUP_ID");
			}
			teamList += '<a data-topic="' +r.get("SMS_GROUP_NAME")
				+ '" data-name="'+r.get("SMS_GROUP_ID")
				+ '" data-index="'+i
				+ '" class="list-group-item' + activeClass
				+ '"> <i class="icon-users icon text-warning"></i>'
				+ (r.get("SMS_GROUP_NAME") || "其他")+'('+r.get("SMS_GROUP_ID")+')'
				+ '</a>';
		}
		whereCase=" and SMS_GROUP_ID='"+curPlatform+"'";
		tableStore.select(tableSql.replace("{}",whereCase));
		$("#teamList").append(teamList);
		$("#teamList .list-group-item").click( function() {
			$("#teamList .list-group-item").removeClass("active");
			$(this).addClass("active");
			// $("a#saveResource").addClass("disabled");
			curPlatform=$(this).attr("data-name");
			selectIndex = $(this).attr("data-index");
			var platform_cnname=$(this).attr("data-topic");
	  	    var whereCase = curPlatform.length>0?" and SMS_GROUP_ID='"+curPlatform+"'":"";
	 	    tableStore.select(tableSql.replace("{}",whereCase));
		    $(".platform_label").html(platform_cnname+","+curPlatform);
		});		
	}

	$("#delPlaform").click(function(){
		var r=smsMsgGroupStore.curRecord;
		if(window.confirm("确定删除平台:"+r.get('SMS_GROUP_NAME')+"吗?")){
			smsMsgGroupStore.remove(r);
			smsMsgGroupStore.commit();
			var sql="delete from  sms_message_group where SMS_GROUP_ID ='"+r.get('SMS_GROUP_ID')+"'";
			ai.executeSQL(sql);
            var sql="delete from  SMS_MESSAGE_GROUP_MEMBER where SMS_GROUP_ID ='"+r.get('SMS_GROUP_ID')+"'";
			ai.executeSQL(sql);	
			alert('成功删除');
			buildPlatformList();
		};
	});
	//创建平台
	$("#addPlaform").click(function(){

		isAdd=true;
	   var r=smsMsgGroupStore.getNewRecord();
	   smsMsgGroupStore.curRecord=r;
	   showPlatformInfoDialog('add');
	});
	//修改平台
	$("#editPlaform").click(function() {
		isAdd=false;
		smsMsgGroupStore.curRecord = smsMsgGroupStore.getRecordByKey(curPlatform); 
	    showPlatformInfoDialog("edit");
	});
	var statusFlag={"0":"发送","1":"不发送"};
	//用户信息
	var buildMemberList = function(){
	 	$("#agentList").empty();
		tableGrid = new AI.Grid({
			store:tableStore,
			//pageSize:15,
			containerId:'agentList',
			nowrap:true,
			showcheck:true,
			columns:[
				{header: "成员", width:120, dataIndex: 'MEMBER_NAME', sortable: true},
				{header: "发送号码", width: 105, dataIndex: 'PHONENUM', sortable: true},
				{header: "是否发送", width: 200, dataIndex: 'STATUS',  maxLength:20,
				render:function(record,value){
					return statusFlag[record.get("STATUS")+""];
				}
		    }
			]
		});	
	}
	
   //用户信息窗口
   var showMemberInfoDialog=function(acttype){
   	  
		$("#member-upsertForm").empty();
		var isRead='y';
		var isSelect = 'n';
		if(acttype=='add'){
		   isRead = 'n';
		   isSelect = 'y';
		}
		var formcfg = ({
			id : 'form',
			store : tableStore,
			containerId : 'member-upsertForm',
			items : [ 
			{type:'text',label:'成员',notNull:'N',fieldName:'MEMBER_NAME',isReadOnly:isRead,width:300}, 
			{type:'text',label:'发送号码',fieldName :'PHONENUM',notNull:'N',width:300},
			{type:'radio-custom',label:'是否发送',notNull:'N',fieldName :'STATUS',width:300,storesql:'0,发送|1,不发送'}
			]
		});
		var from = new AI.Form(formcfg);
		$('#memberConfig').modal({
			show : true,
			backdrop:false
		});
		//取消
		$("#memberConfig #dialog-cancel2").on('click', function(){
			$('#memberConfig').modal("hide");
	    });
	}; 
   //查找
   $("#findAgent").click(function(){
   	   var whereCase = "";
   	   var key=$("#input_content").val();
   	   whereCase +=curPlatform.length>0?" and SMS_GROUP_ID='"+curPlatform+"'":"";
   	   whereCase +=key.length>0?" and (MEMBER_NAME like'%"+key+"%' or PHONENUM like '%"+key+"%')":"";
   	   tableStore.select(tableSql.replace("{}",whereCase));
   });
   //创建
   $("#addAgent").click(function(){
   	   isAdd = true;
       var r = tableStore.getNewRecord();
       r.set("SMS_GROUP_ID",curPlatform);
	   // r.set("NODE_STATUS",0);
	   // r.set("TASK_TYPE","TASK");
	   // r.set("STATUS_CHGTIME","2015-01-01 12:00");
	   tableStore.curRecord = r;
       showMemberInfoDialog('add');

   });
   //修改
   $("#editAgent").click(function(){
   	    isAdd = false;
     	var curAgent=tableGrid.getCheckedRows();
   		if(curAgent.length>1 || curAgent.length==0){
   			alert("只能选中一项！")
   			return false;
   		}
   	   tableStore.curRecord = curAgent[0];
	   showMemberInfoDialog('edit');
   });
   
   //删除
   $("#delMember").click(function(){
   	    var curAgent=tableGrid.getCheckedRows();
   		if(curAgent.length>1 || curAgent.length==0){
   			alert("只选中一项！")
   			return false;
   		}
   		if(confirm("确定删除选中项吗?")){
   			ai.executeSQL("delete from SMS_MESSAGE_GROUP_MEMBER where SMS_GROUP_ID='"+curAgent[0].get("SMS_GROUP_ID")+"' and MEMBER_NAME='"+curAgent[0].get("MEMBER_NAME")+"'","false","METADBS");
   			tableStore.select();
   		}
   });
    //确定
	$("#platformConfig #dialog-ok").click(function() {
		var record = smsMsgGroupStore.curRecord;
		var SMS_GROUP_ID = record.get("SMS_GROUP_ID");
		var SMS_GROUP_NAME = record.get("SMS_GROUP_NAME");
		if(!SMS_GROUP_ID||SMS_GROUP_ID.trim().length<1){
		    alert("用户组不能为空！");
		    return false;
		}

		if(!SMS_GROUP_NAME || SMS_GROUP_NAME.toString().trim().length<1 ){
		    alert("用户组名称不能为空！");
		    return false;
		}
		if(isAdd){	
			var isExist = checkIsExist("sms_message_group",null,record.get("SMS_GROUP_ID"));	
			if(isExist==1||isExist=='1'){
				 alert("不能添加重复数据");
				return false;
			}
		   smsMsgGroupStore.add(record);
		}
		record.set("TEAM_CODE",team_code);
		smsMsgGroupStore.commit(false);
		smsMsgGroupStore.select();
		buildPlatformList();
		tableStore.select();
		$('#platformConfig').modal("hide");
   });
	function checkIsExist(table,memberName,sms_group_id){
		var findSql = "select 1 ISEXIST from "+table+" where SMS_GROUP_ID='"+sms_group_id+"'";
		if(memberName!=null){
			findSql+=" and MEMBER_NAME='"+memberName+"'";
		}
		var num=ai.getStore(findSql,"METADBS");
		if(num.root.length!=0&&num.root[0]['ISEXIST']==1&&num.root[0]['ISEXIST']=='1'){
			return 1;
		}else{
			return 0;
		}
	}
	//确定
	$("#memberConfig #dialog-ok2").click(function() {
		var record = tableStore.curRecord;
		var MEMBER_NAME = record.get("MEMBER_NAME");
		var PHONENUM = record.get("PHONENUM");
		var STATUS = record.get("STATUS");
		if(!MEMBER_NAME||MEMBER_NAME.trim().length<1){
		    alert("成员不能为空！");
		    return false;
		}
		if(!PHONENUM||PHONENUM.trim().length<1|| !isNumber(PHONENUM)){
		    alert("请校检发送号码！");
		    return false;
		}
		if(!STATUS || STATUS.toString().trim().length<1 ){
		    alert("请选择是否发送");
		    return false;
		}
		if(isAdd){
			var isExist = checkIsExist("SMS_MESSAGE_GROUP_MEMBER",MEMBER_NAME,record.get("SMS_GROUP_ID"));	
			if(isExist==1||isExist=='1'){
				 alert("不能添加重复数据");
				return false;
			}
		   tableStore.add(record);
		}
		tableStore.commit(true);
		tableStore.select();
		smsMsgGroupStore.select();
		$('#memberConfig').modal("hide");
	});
   buildPlatformList();
   buildMemberList();   
});

</script>
</head>
<body class="">
	<section class="vbox">
		<section>
			<section class="hbox stretch">
				<section id="content">
					<section class="vbox">
						<section class="scrollable">
							<section class="hbox stretch">
								<aside class="aside bg-light dk" id="sidebar"
									style="width: 285px; height: 90%;">
									<section class="vbox animated fadeInUp">
										<section class="scrollable padder-lg w-f-md">
											<div class="panel panel-default">
												<div class="panel-heading">
													<span class="font-thin m-l-md m-t">用户组列表</span>
												</div>
												<div class="panel-body">
													<div
														class="list-group no-radius no-border no-bg m-t-n-xxs m-b-none auto"
														id="teamList"></div>
												</div>
												<div class="panel-footer no-border">
													<a id="addPlaform" class="btn btn-sm btn-primary"> <i
														class="fa fa-css3"> </i> 创建
													</a> <a id="delPlaform" class="btn btn-sm btn-danger hide"> <i
														class="fa fa-times"> </i> 删除
													</a> <a id="editPlaform" class="btn btn-sm btn-primary"> <i
														class="fa fa-css3"> </i> 修改
													</a>
												</div>
											</div>
										</section>
									</section>
								</aside>
								<aside class="bg-white">
									<section class="vbox">
										<header class="bg-light lt">
											<ul class="nav nav-tabs nav-white" id="myTab">
												<li class="active"><a href="#activity" data-toggle="tab">用户列表 </a></li>
											</ul>
										</header>
										<div class="tab-content">
											<div class="tab-pane active" id="activity"
												style="background: white">
												<div id = "coverNember" style="position: absolute;background:#fff;z-index:10000;width:0px;height:0px;opacity:0.3;"></div>
												<div class="row" style="z-index = 10001;">
													<div class="col-md-12">
														<div class="row row-sm"  style="padding-left:20px">
														<ul class="nav navbar-nav">
															<li class="active" ><a class="platform_label">用户信息</a></li>
															<li
																style="margin-top: 12px; margin-left: 1px; margin-right: 3px; border-left: 1px solid #ddd; height: 20px;"></li>
															<li class="navbar-text" style="margin-top: 10px;">
																	<input type="text" id="input_content" placeholder = "请输入查询关键字">
															</li>
															<li><button id="findAgent" class="btn btn-sm" style="float: left; margin-top: 10px;"><i class="glyphicon glyphicon-eye-open"></i>查找</button></li>
															<li
																style="margin-top: 12px; margin-left: 1px; margin-right: 3px; border-left: 1px solid #ddd; height: 20px;"></li>
															<li><button id="addAgent" class="btn btn-sm btn-primary" style="float: left; margin-top: 10px;">创建</button></li>
															<li
																style="margin-top: 12px; margin-left: 1px; margin-right: 3px; border-left: 1px solid #ddd; height: 20px;"></li>
															<li><button class="btn btn-sm btn-primary" id="editAgent" style="float: left; margin-top: 10px;">修改</button></li>
															<li
																style="margin-top: 12px; margin-left: 1px; margin-right: 3px; border-left: 1px solid #ddd; height: 20px;"></li>
															<li><button class="btn btn-sm btn-primary"id="delMember" style="float: left; margin-top: 10px;">删除</button></li>
														</ul>
													</div>
													<div class="row row-sm" id="agentList"></div>
													</div> 
													
												</div>
											</div>
										</div>
									</section>
								</aside>
							</section>
						</section>
					</section>
				</section>
			</section>
		</section>
	</section>
	<!-- Bootstrap -->
	<!-- App -->
	<div id="platformConfig" class="modal fade" style = "z-index:10000">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button id="dialog-cancel" type="button" class="close">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">用户组信息</h4>
				</div>
				<div class="modal-body" id="platform-upsertForm"></div>
				<div class="modal-footer">
					<button id="dialog-cancel" type="button" class="btn btn-default">取消</button>
					<button id="dialog-ok" type="button" class="btn btn-primary">确认</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<!-- Bootstrap -->
	<!-- App -->
	<div id="memberConfig" class="modal fade" style = "z-index:10000">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button id="dialog-cancel2" type="button" class="close">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">用户信息</h4>
				</div>
				<div class="modal-body" id="member-upsertForm"></div>
				<div class="modal-footer">
					<button id="dialog-cancel2" type="button" class="btn btn-default">取消</button>
					<button id="dialog-ok2" type="button" class="btn btn-primary">确认</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
</body>
</html>