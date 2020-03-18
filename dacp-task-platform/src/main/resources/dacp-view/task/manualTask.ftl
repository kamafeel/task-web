<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>手工任务监控</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="${mvcPath}/dacp-res/uikit/css/bootstrap.css"/>
	<link rel="stylesheet" href="${mvcPath}/dacp-res/dps/css/dacp-css-for-dataps.css" />
	<link rel="stylesheet" href="${mvcPath}/dacp-res/uikit/css/font-awesome.css" />
	<link rel="stylesheet" href="${mvcPath}/dacp-res/vue/css/vuetable.css" />

	<style type="text/css">
	</style>

	<script src="${mvcPath}/dacp-lib/common/jquery-3.1.0.js"></script>
	<script src="${mvcPath}/dacp-lib/common/bootstrap.js"></script>
	<script src="${mvcPath}/dacp-lib/vue/vue2.0.1.js"></script>
	<script src="${mvcPath}/dacp-lib/vue/vue-resource1.0.2.js"></script>
	<script src="${mvcPath}/dacp-res/vue/dist/vue-dps.js"></script>
	
	<!-- 使用ai.core.js需要将下面两个加到页面 -->
	<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
	<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
	
	<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
	<script src="${mvcPath}/dacp-view/task/js/ai.field.js"></script>
	<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
	<script src="${mvcPath}/dacp-view/task/js/ai.grid.js"></script>
	<script src="${mvcPath}/dacp-lib/bootstrap-jquery-plugin/src/jquery.datagrid.js"></script>
  </head>

  <body>
  	
    <div id="app" class="container">

        <h2 class="sub-header">手工任务列表</h2>
        <hr>
        <div class="row">
            <div class="col-md-12 form-inline">
                <div class="form-inline form-group">
                    <div class="dacp-input dacp-input-notice">
	                    <input v-model="searchForProcName" @keyup.enter="setFilter" style="width:220px;" placeholder="任务名">
	                    <input v-model="searchForDateArgs" @keyup.enter="setFilter" style="width:120px;" placeholder="日期参数">
			    	</div>
                    <button class="btn btn-sm dacp-btn-blue" @click="setFilter">查询</button>
                    <button class="btn btn-sm dacp-btn-green" @click="addModal">新增</button>
                    <button class="btn btn-sm dacp-btn-red" @click="delRow">删除</button>
                </div>
            </div>
        </div>
		<!-- 表格 -->
        <div class="table-wrapper">
            <vuetable 
            	ref:vuetable
                api-url="../manualTask/findAll"
				pagination-path="" 
				table-class="table table-bordered table-hover" 
				ascending-icon="fa fa-sort-asc" 
				descending-icon="fa fa-sort-desc" 
				detail-row-component="my-detail-row" 
               	detail-row-id="seqno" 
               	wrapper-class="vuetable-wrapper"
                table-wrapper=".vuetable-wrapper"
				:fields="fields" 
				:per-page="perPage" 
				:sort-order="sortOrder" 
				:item-actions="actionItems"
                :append-params="moreParams"
                :bus="bus"
                :selected-to="selectedRow"
            ></vuetable>

        </div>
        
		<!-- 弹出框-表单 -->
		<modal v-model="showFormModal" effect="fade" width="400" v-bind:title="formModalTitle">
			<div slot="modal-body" class="modal-body ">
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">任务类型</label>
					<div class="col-sm-9">
						<select id="proctype" name="proctype" class="form-control" v-model="proctype" v-on:change="changeProctype($event,proctype)" >
							<option value=""></option>
							<option v-for="item in proctypeList" :value="item.k" v-text="item.v"></option>
	                    </select>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">任务名</label>
					<div class="col-sm-9">
						<bs-input id="procName" custom-class="customClass" 
							v-model="manualObj.procName"
							required
							icon>
						</bs-input>
						<input type="hidden" id="xmlid"/>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">agent资源组</label>
					<div class="col-sm-9">
						<select class="form-control" v-model="platform" >
							<option value=""></option>
							<option v-for="item in platformList" :value="item.k" v-html="item.v"></option>
	                    </select>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">指定agent</label>
					<div class="col-sm-9">
						<select class="form-control" v-model="manualObj.agentCode" >
							<option value=""></option>
							<option v-for="item in filterAgentList" :value="item.k" v-html="item.v"></option>
	                    </select>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">日期参数</label>
					<div class="col-sm-9">
						<bs-input id="dateArgs" custom-class="customClass" placeholder="yyyy-MM-dd hh:mm"
							v-model="manualObj.dateArgs"
							required 
							icon>
						</bs-input>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">命令前缀</label>
					<div class="col-sm-9">
						<select class="form-control" v-model="manualObj.preCmd" >
							<option value=""></option>
							<option v-for="item in filterPreCmdList" :value="item.k" v-html="item.v"></option>
	                    </select>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">脚本路径</label>
					<div class="col-sm-9">
						<bs-input custom-class="customClass"
							id="path"
							v-model="manualObj.path"
							required 
							icon>
						</bs-input>
					</div>
				</div>
			</div>
			<div slot="modal-footer" class="modal-footer">
			    <button type="button" class="btn btn-default dacp-btn-gray" @click="cancelJobmand">取消</button>
			    <button type="button" class="btn btn-default dacp-btn-blue" @click="saveManualTask">保存</button>
			</div>
		</modal>
		<!-- 批量删除-弹出确认框 -->
		<modal v-model="showQModal" effect="fade" width="400" title="确认操作">
		  <div slot="modal-body" class="modal-body" v-html="qModalText"></div>
		  <div slot="modal-footer" class="modal-footer">
		    <button type="button" class="btn btn-sm dacp-btn-gray" @click="showQModal = false">取消</button>
		    <button type="button" class="btn btn-sm dacp-btn-blue" @click="deleteAjax">确认</button>
		  </div>
		</modal>
		<!-- 任务重做-弹出确认框 -->
		<modal v-model="showRedoModal" effect="fade" width="400" title="确认操作">
		  <div slot="modal-body" class="modal-body" v-html="redoModalText"></div>
		  <div slot="modal-footer" class="modal-footer">
		    <button type="button" class="btn btn-sm dacp-btn-gray" @click="showRedoModal = false">取消</button>
		    <button type="button" class="btn btn-sm dacp-btn-blue" @click="redoAjax">确认</button>
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
    </div>

    <script>
    
    function checkDateArgs(val){
    	return /^\d{4}(-\d{2}(-\d{2}(\s\d{2}(:\d{2})?)?)?)?$/.test(val);
    }
    
    function getNowTime(){
    	var d = new Date();
    	var vYear = d.getFullYear();
    	var vMon = d.getMonth() + 1;
    	var vDay = d.getDate();
    	var h = d.getHours();
    	var m = d.getMinutes();
    	var se = d.getSeconds();
    	return vYear +"-"+(vMon<10 ? "0" + vMon : vMon)+"-"+(vDay<10 ? "0"+ vDay : vDay)+" "+(h<10 ? "0"+ h : h)+":"+(m<10 ? "0" + m : m)+":"+(se<10 ? "0" +se : se);
    }
    
  	//生成seqno
    function getSeqNo(){
    	var now = new Date();
    	now = now.format("yyyyMMddhhmmss") +"0"+ now.getMilliseconds();
    	return now;
    }
    
    // fields definition
    var tableColumns = [
        {
            name: '__checkbox:seqno',
            titleClass: 'text-center',
            dataClass: 'text-center',
            
        },
        {
            name: '__sequence',
            title: '序号',
            titleClass: 'text-center',
            dataClass: 'text-center',
            
        },
        {
            name: 'procName',
            title: '任务名',
            titleClass: 'text-center',
            dataClass: 'text-left',
            sortField: 'procName'
        },
        {
            name: 'dateArgs',
            title: '日期参数',
            titleClass: 'text-center',
            dataClass: 'text-left',
            sortField: 'dateArgs'
        },
        {
            name: 'taskState',
            title: '任务状态',
            titleClass: 'text-center',
            sortField: 'taskState',
            dataClass: 'text-center',
            callback: 'renderState'
        },
        {
            name: 'agentCode',
            title: '执行agent',
            titleClass: 'text-left',
            sortField: 'agentCode'
        },
        {
            name: 'execTime',
            title: '开始执行时间',
            titleClass: 'text-left',
            sortField: 'execTime'
        },
        {
            name: 'endTime',
            title: '执行结束时间',
            titleClass: 'text-left',
            sortField: 'endTime'
        },
        {
            name: 'useTime',
            title: '运行时长',
            titleClass: 'text-left',
            sortField: 'useTime'
        },
        {
            name: '__actions',
            dataClass: 'text-center',
            title: '操作',
            titleClass: 'text-center',
            dataClass: 'text-center'
        },
    ]

	var eventBus=new Vue();
    var vueTable = new Vue({
        el: '#app',
        data: {
       		//proctypeList: [{k:"1",v:"1"},{k:"2",v:"2"}], 
       		proctypeList: ${proctypeList},
       		platformList: ${platformList},
       		agentList: ${agentList},
       		preCmdList: ${preCmdList},
 			bus: eventBus,
            fields: tableColumns,
            perPage: 12,
			paginationComponent: 'vuetable-pagination-dps',
			
			showFormModal: false,
			formModalTitle: '',
			showQModal: false,
			qModalText: '',
			showRedoModal: false,
			redoModalText: '',
			editData: '',
			
			selectedRow: [],
            manualObj: {
            	
            },
            proctype:'',
            platform:'',
            
            showTopSuccess: false,
            showTopError: false,
            alertErrorText:'',
            alertSuccessText:'',
            
            searchFor: '',//查询关键字
            searchForProcName: '',
            searchForDateArgs: '',
            sortOrder: [{//排序
                field: 'dateArgs',
                direction: 'desc'
            }],
            
            deleteObj:[],
            redoObj:{},
            actionItems: [
                { name: 'redo-item', label: '', icon: 'fa fa-refresh', class: 'btn btn-sm dacp-btn-blue', extra: {'title': 'refresh', 'data-toggle':"tooltip", 'data-placement': "left"} },
                { name: 'delete-item', label: '', icon: 'glyphicon glyphicon-trash', class: 'btn btn-sm dacp-btn-red', extra: {title: 'Edit', 'data-toggle':"tooltip", 'data-placement': "left"} },
                /* { name: 'view-item', label: '', icon: 'glyphicon glyphicon-zoom-in', class: 'btn btn-sm dacp-btn-blue', extra: {'title': 'View', 'data-toggle':"tooltip", 'data-placement': "left"} },
                { name: 'edit-item', label: '', icon: 'glyphicon glyphicon-pencil', class: 'btn btn-sm dacp-btn-green', extra: {title: 'Edit', 'data-toggle':"tooltip", 'data-placement': "left"} },
                { name: 'delete-item', label: '', icon: 'glyphicon glyphicon-remove', class: 'btn btn-sm dacp-btn-red', extra: {title: 'Delete', 'data-toggle':"tooltip", 'data-placement': "right" } } */
            ],
            moreParams: []
        },
        computed: {
        	filterPreCmdList: function() {
        		var result = [];
                for (var i = 0; i < this.preCmdList.length; i++) {
                    if (this.preCmdList[i].p == this.proctype) {
                    	result.push({"k":this.preCmdList[i].k,"v":this.preCmdList[i].v,})
                    }
                }
        		return result;
            },
            filterAgentList: function() {
        		var result = [];
                for (var i = 0; i < this.agentList.length; i++) {
                    if (this.agentList[i].p == this.platform) {
                    	result.push({"k":this.agentList[i].k,"v":this.agentList[i].v,})
                    }
                }
        		return result;
            }
        },
        watch: {
            'perPage': function(val, oldVal) {
                this.$broadcast('vuetable-pagination:refresh')
            },
            'paginationComponent': function(val, oldVal) {
                this.$broadcast('vuetable-pagination:load-success', this.$refs.vuetable.tablePagination)
                this.paginationConfig(this.paginationComponent)
            }
        },
        //表单输入验证
        validators: {
        	proctype: function(val){
        		var isFlag = true;
        		if(val== undefined || val == ""){
            		vueTable.alertErrorText = "任务类型不能为空";
            		vueTable.showTopError = true;
            		isFlag = false;
        		}
        		return isFlag;
            }
        },
        methods: {
            renderState: function(value){
            	var state = "";
				if(value<5){
            		state='<button class="btn btn-sm dacp-btn-blue">等待运行</button>';
            	}else if(value==5){
            		state='<button class="btn btn-sm dacp-btn-yellow">正在运行</button>';
            	}else if(value==6){
            		state='<button class="btn btn-sm dacp-btn-green">运行成功</button>';
            	}else if(value>=50){
            		state='<button class="btn btn-sm dacp-btn-red">运行失败</button>';
            	}
            	return state;
            },
        	changeProctype: function(e,type){
        		var procNameHtml=$("#procName").html();
        		if(typeof(type)!="undefined" && type=="dp"){
        			$("#procName input").prop("disabled","disabled");
        			$("#procName").css("width","80%").css("float","left")
						.parent().append("<button id='chooseTask' class='btn btn-sm dacp-btn-white' style='float:left;margin-left:10px; margin-top:4px;'>选择</button>");
        			

        			$("#path input").prop("disabled","disabled");
        			$("#path input").val("go.sh");
					$("#path").removeClass("has-error").addClass("has-success");
					$("#path span").addClass("glyphicon-ok").removeClass("glyphicon-remove");
					vueTable.manualObj.path="go.sh";
					
        			$("#chooseTask").click(function(){
        				var _sql = " select distinct a.xmlid as keyfield,a.proc_name as values1,a.proccnname as values2 " +
		        			       " from proc a, proc_schedule_info b " +
		        			       " where a.xmlid = b.xmlid and b.proc_type='dp' and a.state='VALID' ";
        				function afterIndexSelect(rs){
        					if(rs.length != 1) {
        						alert("只能选择一项")
        						return false;
        					}
        					var xmlid = rs[0].get("KEYFIELD");
        					var procName = rs[0].get("VALUES1");
        					$("#xmlid").val(xmlid);
        					$("#procName input").val(procName);
        					vueTable.manualObj.procName=procName;
        					vueTable.manualObj.xmlid=xmlid;
        				};
        				
        				var selectValue = $("#xmlid").val();
        			       
        				var selcetBox = new SelectBox({
        					sql: _sql,
        					selectedValue: selectValue,
        					callback: afterIndexSelect,
        					dataSource: "METADBS"
        				});
        				selcetBox.show();
        			})
        		}else{
        			var xmlid = ai.guid();
        			$("#xmlid").val(xmlid);
					vueTable.manualObj.xmlid=xmlid;
        			$("#procName input").prop("disabled",false);
        			$("#procName input").val("");
        			$("#procName").css("width","100%").parent().find("#chooseTask").remove();
        			
        			$("#path input").prop("disabled",false);
        			$("#path input").val("");
					$("#path").removeClass("has-success").addClass("has-error");
					$("#path span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
        		}
        	},
        	//保存或修改
            saveManualTask: function(){
            	vueTable.manualObj.proctype = vueTable.proctype;
            	vueTable.manualObj.platform = vueTable.platform;
            	
            	if(vueTable.manualObj.proctype == undefined || vueTable.manualObj.proctype == ""){
            		vueTable.alertErrorText = "任务类型不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
				if(vueTable.manualObj.procName == undefined || vueTable.manualObj.procName == ""){
            		vueTable.alertErrorText = "任务名不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
            	if(vueTable.manualObj.platform == undefined || vueTable.manualObj.platform == ""){
            		vueTable.alertErrorText = "请选择agent资源组";
            		vueTable.showTopError = true;
            		return false;
            	}
            	if(vueTable.manualObj.agentCode == undefined || vueTable.manualObj.agentCode == ""){
            		vueTable.alertErrorText = "请选择agent";
            		vueTable.showTopError = true;
            		return false;
            	}
            	if(vueTable.manualObj.dateArgs == undefined || vueTable.manualObj.dateArgs == ""){
            		vueTable.alertErrorText = "日期参数不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}else if(!checkDateArgs(vueTable.manualObj.dateArgs)){
					vueTable.alertErrorText = "日期参数格式有误";
					$("#dateArgs").removeClass("has-success").addClass("has-error");
					$("#dateArgs span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
					vueTable.showTopError = true;
					return false;
            	}else{
            		
            	}

            	if(vueTable.manualObj.preCmd == undefined || vueTable.manualObj.preCmd == ""){
            		vueTable.alertErrorText = "请选择命令前缀";
            		vueTable.showTopError = true;
            		return false;
            	}
            	if(vueTable.manualObj.path == undefined || vueTable.manualObj.path == ""){
            		vueTable.alertErrorText = "脚本路径不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
            	
            	//form其他字段赋值
            	vueTable.manualObj.runFreq="manual";
            	vueTable.manualObj.taskState=3;
            	vueTable.manualObj.seqno = getSeqNo();
            	vueTable.manualObj.triggerType = 1;
            	vueTable.manualObj.workType = 1;
            	vueTable.manualObj.triggerFlag = 1;
            	vueTable.manualObj.queueFlag = 0;
            	vueTable.manualObj.validFlag = 0;
            	vueTable.manualObj.statusTime = getNowTime();
            	vueTable.manualObj.startTime = getNowTime();
            	//vueTable.manualObj.dutyUser = _UserInfo.username;
            	vueTable.manualObj.teamCode = _UserInfo.teamCode;
            	vueTable.manualObj.procName = vueTable.manualObj.procName;
            	
            	$.ajax({
                    url: '../manualTask/save',
                    type: 'POST',
                    async : false,
                    data: this.manualObj,
                    dataType: 'json',
                    success: function (returnData) {
                        vueTable.showTopSuccess = true;
                        //vueTable.alertSuccessText = returnData.msg;
                        vueTable.showFormModal = false;
                        
                        //调用服务，修改缓存
                        var _url = '/'+contextPath+'/taskOpt/manualTask';
						var _data = {
							"seqno": vueTable.manualObj.seqno
						};
                        $.ajax({
                    		headers: {'Content-type': 'application/json;charset=UTF-8'},
                			url: _url,
                			data: _data,
                			async: false,
                			error: function(){     
                				vueTable.alertErrorText = '请求服务：'+ _url +'失败,请重做';
                				vueTable.showTopError = true;
                		    },
                			success: function(msg){
                				var msg = $.parseJSON(msg);
                				if(msg.flag==true||msg.flag=="true"){
                                     vueTable.alertSuccessText = msg.response;
                                     vueTable.showTopSuccess = true;
                				}else{
                                    vueTable.alertErrorText = '操作失败：' + msg.response;
                                    vueTable.showTopError = true;
                					
                				}
                			}
                		});
                    },
					error : function() {  
						vueTable.showTopError = true;
						vueTable.alertErrorText = "服务返回错误";
					}
                });

                vueTable.bus.$emit('vuetable-pagination:refresh');
                vueTable.manualObj = {};
            },
            cancelJobmand: function(){
            	vueTable.showFormModal = false;
            	vueTable.manualObj = {};
            },
            //查询
            setFilter: function() {
                this.moreParams = [  
                	'filter=' + this.searchForProcName
                	,'filter2=' + this.searchForDateArgs
                ]
                
                this.$nextTick(function() {
                    this.bus.$emit('vuetable-pagination:refresh')
                })
            },
            addModal: function() {
            	vueTable.manualObj = {};
            	vueTable.proctype = "";
            	vueTable.manualObj.procName = "";
            	//还原任务名
    			$("#procName input").prop("disabled",false);
    			$("#procName input").val("");
    			$("#procName").css("width","100%").parent().find("#chooseTask").remove();
    			
            	vueTable.platform = "";
            	vueTable.manualObj.agentCode = "";
            	vueTable.manualObj.dateArgs = "";
            	vueTable.manualObj.path = "";
            	vueTable.formModalTitle = '新增配置信息';
        		vueTable.showFormModal = true;
        		vueTable.editData = {};
            },
            editModal: function(data){
        		vueTable.manualObj=JSON.parse(JSON.stringify(data));
        		vueTable.formModalTitle = '编辑配置信息';
        		vueTable.showFormModal = true;
        		vueTable.editData = JSON.parse(JSON.stringify(data));
            },
            resetFilter: function() {
                this.searchFor = '';
                this.searchForProcName = '';
                this.searchForDateArgs = '';
                this.setFilter();
            },
            //批量删除
            delRow: function() {
            	console.log(vueTable.selectedRow);
            	if(vueTable.selectedRow.length == 0){
					vueTable.showTopError = true;
					vueTable.alertErrorText = "请先选择!";
					return false;
            	}
            	for(var i in vueTable.selectedRow){
            		vueTable.deleteObj[vueTable.deleteObj.length] = {seqno:vueTable.selectedRow[i]};
            	}
            	vueTable.qModalText = "确定要批量删除吗？";
            	vueTable.showQModal = true;
            },
            deleteAjax: function(){
            	vueTable.showQModal = false;
            	$.ajax({
					url: '../manualTask/delete',
					type: 'POST',
        			async: false,
					data: JSON.stringify(vueTable.deleteObj),
					dataType: 'json',
					contentType: 'application/json', 
					success: function (returnData) {
						console.log(returnData);
						vueTable.showTopSuccess = true;
                        vueTable.alertSuccessText = '删除成功';
					},
	            	error : function() {  
						vueTable.showTopError = true;
						vueTable.alertErrorText = "删除失败";
					}
				});
				vueTable.bus.$emit('vuetable-pagination:refresh');
            	vueTable.deleteObj = [];
            },
            redoAjax: function(){
            	
            	//不是完成状态,拒绝重做
            	/* if(vueTable.redoObj.taskState!=6 && vueTable.redoObj.taskState<50){
    				vueTable.alertErrorText = '任务还未完成不能重做';
    				vueTable.showTopError = true;
    				return;
            	} */
            	vueTable.showRedoModal = false;
            	//修改任务状态为
            	ai.executeSQL("update proc_schedule_log set task_state=3,queue_flag=0,trigger_flag=1,start_time=null,end_time=null,use_time=null where seqno='"+vueTable.redoObj.seqno+"'",false,"METADBS");
            	
            	//调用服务，修改缓存
                var _url = '/'+contextPath+'/taskOpt/manualTask';
				var _data = {
					"seqno": vueTable.redoObj.seqno
				};
                $.ajax({
            		headers: {'Content-type': 'application/json;charset=UTF-8'},
        			url: _url,
        			data: _data,
        			async: false,
        			error: function(e){     
        				vueTable.alertErrorText = '请求服务：'+ _url +'失败';
        				vueTable.showTopError = true;
        		    },
        			success: function(msg){
        				var msg = $.parseJSON(msg);
        				if(msg.flag==true||msg.flag=="true"){
                             vueTable.alertSuccessText = msg.response;
                             vueTable.showTopSuccess = true;
        				}else{
                          	 vueTable.alertErrorText = '操作失败：' + msg.response;
                          	 vueTable.showTopError = true;
        				}
						vueTable.bus.$emit('vuetable-pagination:refresh');
        			}
        		});
            	vueTable.redoObj = {};
            },
            //存在时移除，不存在时加入
            changeSelectArray: function(newItem){
            	var _index = $.inArray(newItem,vueTable.selectedRow); 
            	if(_index >= 0){
            		vueTable.selectedRow.splice(_index, 1);
            	}else{
            		vueTable.selectedRow.push(newItem);
            	}
            }
        },
		created: function(){
			this.bus.$on('vuetable:action', function(action, data){
				console.log("vuetable:action" + action);
            	if(action == "redo-item") {
           			vueTable.redoObj.seqno = data.seqno;
           			vueTable.redoObj.taskState = data.taskState;
                	vueTable.redoModalText = "确定要重做吗？";
                	vueTable.showRedoModal = true;
            	}else if(action == "delete-item"){
            		vueTable.deleteObj[0] = {seqno:data.seqno};
                	vueTable.qModalText = "确定删除吗？";
                	vueTable.showQModal = true;
            	}else{
                	vueTable.qModalText = "未知操作";
                	vueTable.showQModal = true;
            	}
			});
			this.bus.$on("vuetable:load-success", function(response){
				console.info(response)
			});
			//点击行时选中复选框
			this.bus.$on("vuetable:row-click", function(data, event){
				if(event.path[0].outerHTML.indexOf("td") >= 0  && event.path[0].outerHTML.indexOf("checkbox") == "-1"){
					vueTable.changeSelectArray(data.seqno); 
				}
			});
			//行双击事件
			this.bus.$on("vuetable:cell-dblclick", function(dataItem, field, event) {
				window.open('/'+contextPath+'/ftl/task/monitorDialog?seqno=' + dataItem.seqno + '&proc_name=' + dataItem.procName + '&op=manual_log');
			})
		},
		mounted:function() {
		}
    })
    </script>
  </body>
</html>
