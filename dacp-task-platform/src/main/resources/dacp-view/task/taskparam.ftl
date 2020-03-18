<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>参数配置</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="${mvcPath}/dacp-res/uikit/css/bootstrap.css"/>
	<link rel="stylesheet" href="${mvcPath}/dacp-res/dps/css/dacp-css-for-dataps.css" />
	<link rel="stylesheet" href="${mvcPath}/dacp-res/uikit/css/font-awesome.css" />
	<link rel="stylesheet" href="${mvcPath}/dacp-res/vue/css/vuetable.css" />

	<style type="text/css">
		.dacp-table {
		    margin-left: 0;
		}
	</style>
	
	<script src="${mvcPath}/dacp-lib/common/jquery-3.1.0.js"></script>
	<script src="${mvcPath}/dacp-lib/common/bootstrap.js"></script>
	<script src="${mvcPath}/dacp-lib/vue/vue2.0.1.js"></script>
	<script src="${mvcPath}/dacp-lib/vue/vue-resource1.0.2.js"></script>
	<script src="${mvcPath}/dacp-res/vue/dist/vue-dps.js"></script>
  </head>

  <body>
  	
    <div id="app" class="container">

        <h2 class="sub-header">参数配置</h2>
        <hr>
        <div class="row">
            <div class="col-md-7 form-inline">
                <div class="form-inline form-group">
                    <div class="dacp-input dacp-input-notice">
	                    <input v-model="searchFor" @keyup.enter="setFilter">
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
                api-url="../../scheduleVal/findAll"
				pagination-path="" 
				:fields="fields" 
				:per-page="perPage" 
				table-class="table table-bordered table-hover" 
				:sort-order="sortOrder" 
				:item-actions="actionItems"
                :append-params="moreParams"
				detail-row-component="my-detail-row" 
               	detail-row-id="id" 
               	wrapper-class="vuetable-wrapper"
                table-wrapper=".vuetable-wrapper"
                :bus="bus"
                :selected-to="selectedRow"
            ></vuetable>

        </div>
		<!-- 弹出框-表单 -->
		<modal v-model="showFormModal" effect="fade" width="400" v-bind:title="formModalTitle">
			<div slot="modal-body" class="modal-body ">
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">变量类型</label>
					<div class="col-sm-9">
						<select class="form-control" v-model="jcObj.varType" >
							<option value="CONST" >变量</option>
							<!-- <option value="PRPAM">实参</option> -->
							<!-- <option :value="jcObj.varType" v-if="jcObj.varType!='PRPAM' && jcObj.varType!='CONST'" v-html="jcObj.varType"></option> -->
	                    </select>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">变量名称</label>
					<div class="col-sm-9">
						<bs-input custom-class="customClass" 
							v-model="jcObj.varName"
							required 
							icon>
						</bs-input>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">变量值</label>
					<div class="col-sm-9">
						<bs-input custom-class="customClass" 
							v-model="jcObj.varValue"
							required 
							icon>
						</bs-input>
					</div>
				</div>
				<div class="form-group clearfix">
					<label class="col-sm-3 control-label">备注</label>
					<div class="col-sm-9">
						<bs-input v-model="jcObj.memo" type="textarea" ></bs-input>
					</div>
				</div>
			</div>
			<div slot="modal-footer" class="modal-footer">
			    <button type="button" class="btn btn-default dacp-btn-gray" @click="cancelJobmand">取消</button>
			    <button type="button" class="btn btn-default dacp-btn-blue" @click="saveJobCommand">保存</button>
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

    // fields definition
    var tableColumns = [
        {
            name: '__checkbox:id',
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
            name: 'varType',
            title: '变量类型',
            titleClass: 'text-left',
            sortField: 'varType',
            callback: 'varType',
        },
        {
            name: 'varName',
            title: '变量名称',
            titleClass: 'text-left',
            sortField: 'varName',
        },
        {
            name: 'varValue',
            title: '变量值',
            titleClass: 'text-left',
            sortField: 'varValue',
        },
        {
            name: 'memo',
            title: '备注',
            titleClass: 'text-left',
            sortField: 'memo',
        },
        {
            name: '__actions',
            dataClass: 'text-center',
            title: '操作',
            titleClass: 'text-center',
            dataClass: 'text-center',
        },
    ]

	var eventBus=new Vue();
    var vueTable = new Vue({
        el: '#app',
        data: function(){
        	return{
	 			bus:eventBus,
	            fields: tableColumns,
	            perPage: 15,
				paginationComponent: 'vuetable-pagination-dps',
				
				showFormModal: false,
				formModalTitle: '',
				showQModal: false,
				qModalText: '',
				editData:'',
				
				selectedRow: [],
	            jcObj: {varType:"CONST"},
	            
	            showTopSuccess: false,
	            showTopError: false,
	            alertErrorText:'',
	            alertSuccessText:'',
	            
	            searchFor: '',//查询关键字
	            sortOrder: [{//排序
	                field: 'varType',
	                direction: 'asc'
	            }],
	            
	            deleteObj:[],
	            actionItems: [
	                { name: 'edit-item', label: '', icon: 'glyphicon glyphicon-pencil', class: 'btn btn-sm dacp-btn-green', extra: {title: 'Edit', 'data-toggle':"tooltip", 'data-placement': "left"} },
	                { name: 'delete-item', label: '', icon: 'glyphicon glyphicon-remove', class: 'btn btn-sm dacp-btn-red', extra: {title: 'Delete', 'data-toggle':"tooltip", 'data-placement': "right" } },
	            ],
	            moreParams: [],
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
        methods: {
        	varType: function(value){
        		return value === 'CONST' ? '变量' : (value === 'PRPAM' ? '实参' : value);
        	},
        	//保存或修改
            saveJobCommand: function(){
            	if(vueTable.jcObj.varType == undefined || vueTable.jcObj.varType == ""){
            		vueTable.alertErrorText = "变量类型不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
				if(vueTable.jcObj.varName == undefined || vueTable.jcObj.varName == ""){
            		vueTable.alertErrorText = "变量名称不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
				if(vueTable.jcObj.varValue == undefined || vueTable.jcObj.varValue == ""){
            		vueTable.alertErrorText = "变量值不能为空";
            		vueTable.showTopError = true;
            		return false;
            	}
				var _tempFlag = false;
				if(vueTable.editData.varName != vueTable.jcObj.varName){
	            	$.ajax({
	                    url: '../../scheduleVal/isExist?varName=' + vueTable.jcObj.varName,
	                    type: 'GET',
	                    async : false,
	                    success: function (returnData) {
	                    	if(returnData == true || returnData == "true"){
								vueTable.showTopError = true;
								vueTable.alertErrorText = "变量名称已存在!";
								_tempFlag = true;
								vueTable.jcObj.varName = "";
	                    	}
	                    },
						error : function() {
							vueTable.showTopError = true;
							vueTable.alertErrorText = "请重试";
						}
	                });
				}
            	if(_tempFlag) return false;
            	$.ajax({
                    url: '../../scheduleVal/save',
                    type: 'POST',
                    async : false,
                    data: this.jcObj,
                    dataType: 'json',
                    success: function (returnData) {
                        vueTable.showTopSuccess = true;
                        vueTable.alertSuccessText = returnData.msg;
                        vueTable.bus.$emit('vuetable-pagination:refresh');
                        vueTable.showFormModal = false;
                    },
					error : function() {  
						vueTable.showTopError = true;
						vueTable.alertErrorText = "操作失败";
					}
                });
                vueTable.jcObj = {varType:"CONST"};
            },
            cancelJobmand: function(){
            	vueTable.showFormModal = false;
            	vueTable.jcObj = {varType:"CONST"};
            },
            //查询
            setFilter: function() {
                this.moreParams = [
                    'filter=' + this.searchFor
                ]
                this.$nextTick(function() {
                    this.bus.$emit('vuetable-pagination:refresh')
                })
            },
            addModal: function() {
            	vueTable.jcObj = {};
            	vueTable.jcObj.varName = "";
            	vueTable.jcObj.varValue = "";
            	vueTable.jcObj.varType = "CONST";
            	vueTable.jcObj.memo = "";
            	vueTable.formModalTitle = '新增配置信息';
        		vueTable.showFormModal = true;
        		vueTable.editData = {};
            },
            editModal: function(data){
        		vueTable.jcObj=JSON.parse(JSON.stringify(data));
        		vueTable.formModalTitle = '编辑配置信息';
        		vueTable.showFormModal = true;
        		vueTable.editData = JSON.parse(JSON.stringify(data));
            },
            resetFilter: function() {
                this.searchFor = '';
                this.setFilter()
            },
            //批量删除
            delRow: function() {
            	if(vueTable.selectedRow.length == 0){
					vueTable.showTopError = true;
					vueTable.alertErrorText = "请先选择!";
            	}
            	for(var i in vueTable.selectedRow){
            		vueTable.deleteObj[vueTable.deleteObj.length] = {id:vueTable.selectedRow[i]};
            	}
            	vueTable.qModalText = "确定要批量删除吗？";
            	vueTable.showQModal = true;
            },
            deleteAjax: function(){
            	vueTable.showQModal = false;
            	$.ajax({
					url: '../../scheduleVal/delete',
					type: 'POST',
					data: JSON.stringify(vueTable.deleteObj),
					dataType: 'json',
					contentType: 'application/json', 
					success: function (returnData) {
						vueTable.showTopSuccess = true;
                        vueTable.alertSuccessText = '删除成功';
						vueTable.bus.$emit('vuetable-pagination:refresh');
					},
	            	error : function() {  
						vueTable.showTopError = true;
						vueTable.alertErrorText = "删除失败";
					}
				});
            	vueTable.deleteObj = [];
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
            	if(action == "delete-item") {
           			vueTable.deleteObj[0] = {id:data.id};
                	vueTable.qModalText = "确定删除吗？";
                	vueTable.showQModal = true;
            	}else if(action == "edit-item"){
            		vueTable.editModal(data);
            	}else{
                    alert('custom-action: ' + action, data.name);
                }
			});
			this.bus.$on("vuetable:load-success", function(response){
			});
			//点击行时选中复选框
			this.bus.$on("vuetable:row-click", function(data,event){
				if(event.path[0].outerHTML.indexOf("td") >= 0  && event.path[0].outerHTML.indexOf("checkbox") == "-1"){
					vueTable.changeSelectArray(data.id); 
				}
			});
		}
    })
    </script>
  </body>
</html>
