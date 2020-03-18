<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>进程配置</title>
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
	<script src="${mvcPath}/dacp-lib/jquery/jquery-ui-1.10.2.min.js"></script>
	<script src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
	<script src="${mvcPath}/dacp-lib/vue/vue2.0.1.js"></script>
	<script src="${mvcPath}/dacp-res/vue/dist/vue-dps.js"></script>

	<style>
	div,ul,li{
		margin: 0;
		padding: 0;
		list-style: none;
	}
	
	.container{
    	position: relative;
    }
    .red{
    	color: red;
    }
    .header{
    	marign-top: 10px;
    	height: 40px;
		line-height: 40px;
        border: 1px solid rgba(224, 230, 237, 1);
		border-bottom: 2px solid #adf;
    }
    .header .title{
    	margin-left: 20px;
    }
    .header .btn{
    	margin-right: 10px;
    }
    .table{
    	border:1px solid rgba(224, 230, 237, 1);
    }
    .table .row{
    	margin-top: 20px;
    	line-height: 28px;
    }
    
	.input,.select{
		height: 28px;
		font-weight: 400;
		font-style: normal;
		font-size: 12px;
		text-decoration: none;
		color: #475669;
		text-align: left;
		outline-style: none;
	}
	.input2{
		height: 28px;
		font-weight: 400;
		font-style: normal;
		font-size: 12px;
		text-decoration: none;
		color: #475669;
		text-align: left;
		outline-style: none;
		border-top: 0;
		border-left: 0;
		border-right: 0;
		width: 100%;
	}
    
    
	</style>
	
	
	<script>
	//获取url中的参数
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null){ 
        	return unescape(r[2]);
        }
        return null; //返回参数值
    }
	
	$(function(){
		var pid = getUrlParam("pid");
		
		var vue = new Vue({
			el: "#processForm",
			data: {
				process: ${process},
				businessList: ${businessList},
				hostList: ${hostList},
				
				showConfirmModal: false,
				confirmModalText: '',
	            showTopSuccess: false,
	            alertSuccessText: '',
	            showTopError: false,
	            alertErrorText: ''
			},
			mounted: function(){
				$("#processCatalog").val(this.process.catalog_name);
			},
			methods:{
				checkInput: function(){
					if(this.process["pname"]==undefined||this.process["pname"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "进程名称不能为空";
						return false
					}else if(this.process["business"]==undefined||this.process["business"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "请选择所属业务";
						return false
					}else if(this.process["host_name"]==undefined||this.process["host_name"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "请选择所在主机";
						return false
					}else if(this.process["deploy_path"]==undefined||this.process["deploy_path"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "进程路径不能为空";
						return false
					}else if(this.process["log_path"]==undefined||this.process["log_path"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "日志路径不能为空";
						return false
					}else if(this.process["start_cmd"]==undefined||this.process["start_cmd"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "启动命令不能为空";
						return false
					}else if(this.process["stop_cmd"]==undefined||this.process["stop_cmd"]==""){
						vue.showTopError = true;
						vue.alertErrorText = "停止命令不能为空";
						return false
					}else{
						return true;
					}
				},
				saveProcess: function(){
					var _act = getUrlParam("action");
					var _url ="";
					if(_act == "add"){
						_url = "save";
						vue.process["action"] = "add";
					}else{
						vue.process["action"] = "edit";
						_url = "save";
					}
					
					vue.process["pstatus"] = 0;
					
					if(!this.checkInput()){
						return false;
					}
					
					$.ajax({
	                    url: _url,
	                    type: 'POST',
	                    async : false,
	                    data: vue.process,
	                    dataType: 'json',
	                    success: function (returnData) {
	                    	vue.alertSuccessText = returnData.msg;
	                    	vue.showTopSuccess = true;
	                    	
	                    	//新增成功时修改url
	                    	if(vue.process["action"] == "add"){
	                    		setTimeout('window.location.href=window.location.href.replace("add","edit")',1000)
	                    		
	                    	}
	                    },
						error: function(error) {
							vue.showTopError = true;
							vue.alertErrorText = "服务返回错误";
						}
	                });
	                vue.manualObj = {};
				}
			}
		})
	})
	</script>
</head>
<body>
<div class="container">
	<form id="processForm" >
		<div class="header form-inline">
			<div class="title form-group">进程配置</div>
			<div class="form-group pull-right">
				<button type="button" class="btn-ok btn btn-sm btn-info" @click="saveProcess">确认配置</button>
				<button type="reset" class="btn-cancel btn btn-sm btn-default">重填</button>
			</div>
		</div>
		<div class="table table-condensed">
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					进程名称
				</div>
				<div class="col-md-3">
					<input v-model="process.pname" class="input form-control" placeholder="输入名称">
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					所属业务
				</div>
				<div class="col-md-2">
					<select v-model="process.business" class="select form-control">
						<option value="">选择业务</option>
						<option v-for="b in businessList" v-bind:value="b.k">{{b.v}}</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					所在主机
				</div>
				<div class="col-md-2">
					<select v-model="process.host_name" class="select form-control">
						<option value="">选择主机</option>
						<option v-for="h in hostList" v-bind:value="h.k">{{h.v}}</option>
					</select>
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					进程路径
				</div>
				<div class="col-md-4">
					<input v-model="process.deploy_path" class="input form-control" placeholder="输入路径">
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					日志路径
				</div>
				<div class="col-md-4">
					<input v-model="process.log_path" class="input form-control" placeholder="输入路径">
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					启动命令
				</div>
				<div class="col-md-4">
					<input v-model="process.start_cmd" class="input2" placeholder="输入命令">
				</div>
			</div>
			<div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					停止命令
				</div>
				<div class="col-md-4">
					<input v-model="process.stop_cmd" class="input2" placeholder="输入命令">
				</div>
			</div>
			<!-- <div class="row">
				<div class="col-md-2 text-right">
					<span class="red">*</span>
					是否启动
				</div>
				<div class="col-md-4">
					<label class="radio-inline">
						<input v-model="process.pstatus" type="radio" value="1"> 是
					</label>
					<label class="radio-inline">
						<input v-model="process.pstatus" type="radio" value="0" checked> 否
					</label>
				</div>
			</div> -->
			
			<div class="row"></div>
			<div class="row"></div>
			<div class="row"></div>
		</div>
		
		<!-- 弹出确认框 -->
		<modal v-model="showConfirmModal" effect="fade" width="400" title="确认操作">
			<div slot="modal-body" class="modal-body" v-html="confirmModalText"></div>
			<div slot="modal-footer" class="modal-footer">
			  <button type="button" class="btn btn-sm dacp-btn-gray" @click="">取消</button>
			  <button type="button" class="btn btn-sm dacp-btn-blue" @click="">确认</button>
			</div>
		</modal>
		<!-- 操作成功提示框 -->
		<alert v-model="showTopSuccess" placement="top" :duration="3000" type="success" width="400px" dismissable>
			<span class="icon-info-circled alert-icon-float-left"></span>
			<strong>提示</strong>
			<p v-html="alertSuccessText"></p>
		</alert>
		<!-- 操作失败提示框 -->
		<alert v-model="showTopError" placement="top" :duration="3000" type="danger" width="400px" dismissable>
			<span class="icon-info-circled alert-icon-float-left"></span>
			<strong>提示</strong>
			<p v-html="alertErrorText">操作失败，请重试！</p>
		</alert>
	</form>
</div>

</body>
</html>