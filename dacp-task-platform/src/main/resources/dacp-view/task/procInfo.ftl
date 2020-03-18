<!DOCTYPE html>
<html lang="en" class="app">
    <head>
      <meta charset="utf-8" /> 
      <title>DACP数据云图</title>   
      <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"  />  
		<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
		<link href="${mvcPath}/dacp-lib/bootstrap-datetimepicker/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" media="screen"/>
		
		<script type="text/javascript" src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/underscore/underscore-min.js" type="text/javascript"></script>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/backbone/backbone-min.js" type="text/javascript"></script>
		<script type="text/javascript" src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
		<script type="text/javascript" src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>
      
		<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
		<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
		<script src="${mvcPath}/dacp-lib/bootstrap-jquery-plugin/src/jquery.datagrid.js"></script>
		<script src="${mvcPath}/dacp-lib/bootstrap-datetimepicker/js/bootstrap-datetimepicker.min.js"></script>
		<script  src="${mvcPath}/dacp-lib/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
		
    	<script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
    </head>
<style>
	body {
    margin: 0;
    font-family: Arial,sans-serif;
    font-size: 13px;
    line-height: 20px;
    color: #444;
    background-color: #f1f1f1;
}

.card {
    padding-top: 20px;
    margin: 10px 0 20px 0;
    background-color: #fff;
    border: 1px solid #d8d8d8;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
}
.card-small {
    margin-top: 0;
    padding-top: 4px;
}

    .navbar-default {
        background-color: #d1d1d1;
        border-color: #b1b1b1;
    }

    #res_folder_id, #tag_id {
        background-color:white;
        cursor: default
    }

    #tagDiv{width:270px;border:1px solid #d5d5d5;padding:10px;background-color: #FFF;position:absolute;display:none;}
    #tagDiv .textBox{margin: 0px 0 10px 0;float: left;}
    #tagDiv .input_text,#tagDiv .search_btn{border-color:#d5d5d5;border-width: 1px 0 1px 1px;border-style:solid;}
    #tagDiv .search_btn{border-width: 1px 1px 1px 0px;height:26px;background-position: 8px -26px;}
    #tagDiv .toolbar{margin:0 auto 0 ;text-align:center;padding-top:10px;}
    #folderDiv{width:270px;border:1px solid #d5d5d5;padding:10px;background-color: #FFF;position:absolute;display:none;}
    #folderDiv .textBox{margin: 0px 0 10px 0;float: left;}
    #folderDiv .input_text,#folderDiv .search_btn{border-color:#d5d5d5;border-width: 1px 0 1px 1px;border-style:solid;}
    #folderDiv .search_btn{border-width: 1px 1px 1px 0px;height:26px;background-position: 8px -26px;}
    #folderDiv .toolbar{margin:0 auto 0 ;text-align:center;padding-top:10px;}


    .settings:after{
        background-color: #fcfcfc;
        border-right: 1px solid #ddd;
        border-bottom: 1px solid #ddd;
        color: #9DA0A4;
        font-weight: bold;
        font-size: 12px;
        border-radius:0 0px 4px 0;
        position: absolute;
        top: 0;
        left: 0;
        padding: 3px 7px;
    }

    .settings.request-area:after{
        content: "基本信息";
    }

    .settings.para-area:after{
        content: "参数列表";
    }

    .settings.task-area:after{
        content: "调度配置";
    }
    .settings.monitor-area:after{
        content: "监控配置";
    }

    .dl-horizontal dt{
        width:80px
    }
    .dl-horizontal dd{
        margin-left:100px
    }

    .form-group {
        margin-bottom: 5px;
    }
    .container-fluid .card-small .navbar{
        margin-bottom: 5px;
        min-height: 30px;
        height: 30px
    }
    .navbar-brand {
        padding: 4px 15px;
        font-size: 15px;
    }
    .navbar-text {
        margin-top: 4px;
    }

    .settings {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 4px 4px 4px 4px;
        padding: 20px 10px 0px 10px;
        margin-top: 8px;
        position: relative;
    }
    .row {
        margin-right: 0px;
        margin-left: 0px;
    }

    .required {
        color: red;
    }
    
    .inputLen {
    	width: 50px;
    }
    .task_tree_hide{
    	display: none;
    }
    .task_tree_show{
    	display: block;
    	position: absolute;
    	z-index: 99999;
    }
</style>
<script>
var team_code =  window.parent.paramMap["team_code"]||"";
function buildSelect(data,selectId,selectValue){
	var optionsHtml='<option value="">请选择</option>';
	$.each(data, function (i, item) {
		 var isChecked="";
		 if(data[i].id==selectValue) isChecked='selected=true'; 
		 optionsHtml+='<option value="'+data[i].id+'" '+isChecked+'>'+data[i].name+'</option>';
	});
	$("#"+selectId).html(optionsHtml);
}

function buildSelect2(data,selectId,selectValue,parentValue){
	var newData = [];
	$.each(data, function (i, item) {
		if(item.parent == parentValue){
			newData.push(item);
		}
	});
	buildSelect(newData,selectId,selectValue);
}

function buildRadio(data,selectId,selectValue){
	var optionsHtml="";
	$.each(data, function (i, item) {
		 var isChecked="";
		 if(item.id==selectValue) isChecked='checked=checked';
		 optionsHtml += '<label class="radio-inline"> '+
						    '<input type="radio" id="'+ selectId +'" '+isChecked+' name="'+selectId+'" value="'+ item.id+'" >'+item.name+
						'</label>';
	});
	$("#"+selectId).html(optionsHtml);
}

function showDailog(){
	  var iWidth =650;                         //弹出窗口的宽度;
	  var iHeight=400;                       //弹出窗口的高度;
	  var iTop = (window.screen.availHeight-30-iHeight)/2;       //获得窗口的垂直位置;
	  var iLeft = (window.screen.availWidth-10-iWidth)/2;           //获得窗口的水平位置;
	  
	  var freq = $("input[type='radio'][id='cycletype']:checked").val()||'';
	  var curFreq = $("#curFreq").val()||freq;
	  
	  if(freq!=""){
		  var defaultVal=  document.getElementById('cron_exp').value;
		  var url = "${mvcPath}/ftl/task/cron/cron?freq="+freq+"&cron="+defaultVal+"&cron_id="+'cron_exp'+"&current_freq="+curFreq;
		  var _window=window.open(url,'','height='+iHeight+',innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no');
   		 window.onclick=function (){_window.focus();};
	  }else{
		  alert("请选择程序运行周期");
	  }
}

function buildSelect3(store,selectId,selectValue){
	var data = store.root;
	var optionsHtml='<option value="">请选择</option>';
	$.each(data, function (i, item) {
		 var isChecked="";
		 if(data[i].ID==selectValue) isChecked='selected=true'; 
		 optionsHtml+='<option value="'+data[i].ID+'" '+isChecked+'>'+data[i].NAME+'</option>';
	});
	$("#"+selectId).html(optionsHtml);
}


var opType = window.parent.paramMap["type"];
var isPaas = false;//是否paas建模
$(document).ready(function(){

	var xmlid="${proc.xmlid!}";
	var state = '${proc.state!}';
	var proc_type = '${procsched.proc_type!}' || "dp";
	var precmd = '${procsched.precmd!}'; 

	var procTypeList = ${procTypeList};
	buildRadio(procTypeList,"proc_type","${procsched.proc_type!}");
	
	var precmdList = ${precmdList};
	buildSelect2(precmdList,"precmd","${procsched.precmd!}",proc_type);
	
	var cycleList = ${cycleList};
	buildRadio(cycleList,"cycletype","${proc.cycletype!}");

	var platformList=${platformList};
	buildSelect(platformList,"platform","${procsched.platform!}");

	var agentList=${agentList};
	buildSelect2(agentList,"agent_code","${procsched.agent_code!}","${procsched.platform!}");
	
	var trigger_type="${procsched.trigger_type!}";
	if(trigger_type=="0"){
		$("input:radio[id=trigger_type][value=0]").attr("checked",true);
	}else{
		$("input:radio[id=trigger_type][value=1]").attr("checked",true);
	}
	
	if(proc_type.length==0){
		$("input:radio[id=proc_type][value='dp']").attr("checked",true);	
	}else{
		$("input:radio[id=proc_type][value='"+proc_type+"']").attr("checked",true);	
	}
	
	var muti_run_flag="${procsched.muti_run_flag!}";
	$("input:radio[id=muti_run_flag][value='"+muti_run_flag+"']").attr("checked",true);

	var cycletype="${proc.cycletype!}";
	$("input:radio[id=cycletype][value='"+cycletype+"']").attr("checked",true);

	//显示控制
	var isPaas= window.parent.paramMap["type"]=="edit"|| (opType=="add" && (state=="NEW" || state=="新建"))? true: false;
	if(isPaas){
		$("#proc_name").attr("disabled","disabled");
		$("#proccnname").attr("disabled","disabled");
    	$("#cycletype input[name='cycletype']").attr("disabled","disabled");
	} 
		
	var initProcParamsArray=[];
	var initProcParams=${procParams};
	$.each(initProcParams, function (i, item) {
		 var rows = {
			 "orderid":'<div class="input-group input-group-sm "><input id="orderid" class="form-control" value="'+i+'"></div>',
			 "run_para":'<div class="input-group input-group-sm "><input id="run_para" class="form-control" value="'+initProcParams[i].run_para+'"></div>',
			 "run_para_value":'<div class="input-group input-group-sm "><input id="run_para_value" class="form-control" value="'
				+ initProcParams[i].run_para_value.replaceAll("\"","&quot;") + '" style="width:450px;"></div>'
		 };
		 initProcParamsArray.push(rows);
	});
	
    $("#touchCronExp").bind("click", function() {
		showDailog();
	});
   
    $('.number-input button').on('click', function(e){
    	$this = $(e.currentTarget);
        var min = 0;
        var max = 100;
        var $input = $this.parent().parent().find('input');
        if($input.attr("max")!=undefined){
        	max = $input.attr("max");
       	}
        if($input.attr("min")!=undefined){
        	min = $input.attr("min");
       	}
        if($this.hasClass('number-plus')){
        	if(parseInt($input.val())<max)
           		$input.val(parseInt($input.val())+1);
        }else{
           	if(parseInt($input.val())>min)
        		$input.val(parseInt($input.val())-1);
        }
    });
    
    $("#nextBtn").click(function(){
       // iframe1.location = "/" + model.get('xmlid');//设置配置组件iframe的地址
       // $($(iframe1.parent.document).find('li a')[1])[0].click();//点击配置组件
       // $($(iframe1.parent.document).find('#grid-area-tab a')[1]).css('pointer-events','auto');
    });
    
    $(".form_date1").datetimepicker({
	        language: 'zh-CN',
	        pickTime: false,
	        todayBtn: false,
	        autoclose: true,
	        minView: '2',
	        forceParse: false,
	        pickerPosition:'top-right',
	        format:"yyyy-mm-dd"
        });
    
    $(".form_date2").datetimepicker({
        language: 'zh-CN',
        pickTime: false,
        todayBtn: false,
        autoclose: true,
        minView: '2',
        forceParse: false,
        pickerPosition:'top-right',
        format:"yyyy-mm-dd"
    });
    
    //	接入平台切换
    $("#platform").change(function(){
    	buildSelect2(agentList,"agent_code","${procsched.agent_code!}",$("#platform").val());
    });
    
    //根据程序类型切换执行命令前缀
    $("#proc_type label input").click(function(){
    	buildSelect2(precmdList,"precmd","${procsched.precmd!}",$(this).val());
    })
    
    //保存信息
    $("#saveBtn").click(function(){
        if(!validateSave()){
             return ;
        } 

         var procParams = {};//${proc};
         var procSchedParams = {};
         procParams['xmlid']=xmlid;
         procSchedParams['xmlid']=xmlid;
         var $items = $("input[type!=radio], select, textarea, input[type='radio']:checked");
         $.each($items, function(i, item){
        	 procParams[$(item).attr("id")] = $(item).val();//添加程序信息到proc
        	 procSchedParams[$(item).attr("id")] = $(item).val();//添加调度信息
         });
         
         var isDp = $("#proc_type label input[checked='checked']").val()=="dp";
         //设置proc程序类型
         if(isDp){
        	 procParams["proctype"] = "taskTypeProc";
         }else{
        	 procParams["proctype"] = "taskTypeFunc";
         }
         
         procParams["state"] = "CHANGE";//设置当前状态
         //procParams["state_date"] = new Date().format("yyyy-MM-dd hh:mm:ss");//设置当前更新时间
         if(window.parent.paramMap["type"]=="add" && window.parent.curTaskId==""){
         	procParams["team_code"] = window.parent.team_code;//设置当前团队号
         	//procParams["curdutyer"] = _UserInfo.usercnname;//设置当前更新人
         }
         procSchedParams["run_freq"] = procParams["cycletype"];
         procSchedParams["task_group"] = $("#task_group").attr("data-val")
         procSchedParams["task_group_name"] = $("#task_group").val()
         var procRunParams=new Array();
         var paraTrList=$('#tablewrap1').find("tbody tr");
   		 for(var i=0 ;i<paraTrList.length;i++){
   			 var currow={};
   			 
   			var input = $(paraTrList[i]).find("input[type!=radio], select, textarea, input[type='radio']:checked");
   			input.each(function(i, item){
   			 currow[$(item).attr("id")] = $(item).val();
   		 	 });
   			currow["xmlid"] = xmlid;
   			console.log(currow);
   		 	
   			procRunParams.push(currow);
   		 }
   		 
   		var params={};
   		params["xmlid"]=xmlid;     
   		params["proc"]=procParams;         
   		params["procScheuleInfo"]=procSchedParams;
   		params["procScheduleRunpara"]=procRunParams;

        var dataSource=paramMap['dataSource']||"";
   		var url="${mvcPath}/task/createProcInfo";
   		//url+="?isDp="+isDp;

        
   		//添加操作需要判断程序是否重名
   		if(!isPaas){
   			var _procStore = new AI.JsonStore({
   				sql: "select * from proc where proc_name='"+procParams["proc_name"]+"'",
   				dataSource: dataSource
   			});
   			
   			if(_procStore.count>0){
   				alert("程序名已存在！");
   				return;
   			}
   		}
   		
         procModel = Backbone.Model.extend({
             url:url
         });
         var model = new procModel(params);
         var iframe1 = $(parent)[0][1];
         model.save({}, {
             type: "POST",
             success: function (model, response) {
                 if (window.location.search && window.location.search.split('=').length>0) {
                     alert('调度信息保存成功');
                     //iframe1.location = "zj/" + model.get('xmlid');//设置配置组件iframe的地址
                     var toUrl = "${mvcPath}/task/getProcRela?xmlid="+xmlid;
                     if(dataSource.length>0){
                    	 toUrl+="&dataSource=" + dataSource;
                     }
                     iframe1.location = toUrl;
                     $($(iframe1.parent.document).find('li a')[1])[0].click();//点击配置组件
                     $($(iframe1.parent.document).find('#grid-area-tab a')[1]).css('pointer-events','auto');
                 } else {

                 }
             },
             error :function(model, response){
                 alert("调度信息保存失败!");
             }
         });

     });
    
    //参数列表展示
	$('#tablewrap1').datagrid({
		columns:[
			[{title: "参数顺序", field: "orderid"},
			{title: "参数", field: "run_para"},
			{title: "参数值", field: "run_para_value"}]
		],
		singleSelect:  true, //false allow multi select
		selectedClass: 'danger', //default: 'success'
		selectChange: function(selected, rowIndex, rowData, $row) {
            //allow multi-select
            console.log(selected, rowIndex, rowData, $row);
            delRow=rowIndex;
		}
    }).datagrid("loadData", {rows: initProcParamsArray});
    
	if($("#proc_type label input[checked='checked']").val()=="dp"){
		$("#exec_path").val("go.sh");
		$("#exec_path").attr("disabled","disabled");
		/*
		$("#tablewrap1 thead tr th").eq(1).show();
		$.each($("#tablewrap1 tbody tr"),function(i,item){
			$(item).find("td:eq(1)").show();
		});*/
	}
    if($("#proc_type label input[checked='checked']").val()=="procedure"){
        $("#exec_path").val("procedureCall.sh");
        $("#exec_path").attr("disabled","disabled");
    }
    $("#proc_type label input").click(function(){
    	proc_type = $(this).val();
    	var exec_path = '${procsched.exec_path!""}';
    	switch(proc_type){
    		case "dp":
        		$("#exec_path").val("go.sh");
        		$("#exec_path").attr("disabled","disabled");
	    		$("label[for='exec_proc']").html('执行程序');
        		/*
	    		$("#tablewrap1 thead tr th").eq(1).show();
	    		$.each($("#tablewrap1 tbody tr"),function(i,item){
	    			$(item).find("td:eq(1)").show();
	    		});*/
        		break;
            case "procedure":
                $("#exec_path").val("procedureCall.sh");
                $("#exec_path").attr("disabled","disabled");
                $("label[for='exec_proc']").html('执行程序');
                break;
       		default:
	    		$("#exec_path").val(exec_path);
	    		$("#exec_path").removeAttr("disabled");
	    		$("label[for='exec_proc']").html('<span class="required">*</span>执行程序');
	    		/*
	    		$("#tablewrap1 thead tr th").eq(1).hide();
	    		$.each($("#tablewrap1 tbody tr"),function(i,item){
	    			$(item).find("td:eq(1)").hide();
	    		});*/
	    		break;
    	}
    })
        
    //只读控制
    if (window.parent.paramMap["type"]=="edit" && window.parent.isReadOnly){
		$("button").attr("disabled","disabled");
		window.parent.$(".bg").show();
	} else if (typeof window.parent.paramMap["type"]=="undefined"){
		window.parent.$(".bg").show();
		$(".btn").hide();
	} else{
		window.parent.$(".bg").hide();
	}
    

    //任务分组下拉选择
    $("#task_group").click(function(){
        initTaskTree();
    	if($("#task_tree").hasClass("task_tree_hide")){
    		$("#task_tree").removeClass("task_tree_hide").addClass("task_tree_show");
    		$("#task_tree").width($("#task_group").width()+20);
    	}else{
    		$("#task_tree").removeClass("task_tree_show").addClass("task_tree_hide");
    	}
    })
    
    $("#task_group_clear").click(function(){
    	if($("#task_tree").hasClass("task_tree_show")){
    		$("#task_tree").removeClass("task_tree_show").addClass("task_tree_hide");
    	}
		$("#task_group").val("");
		$("#task_group").attr("data-val","");
    })
});

function initTaskTree(){
	var json = []
	var _url = "/" + contextPath + "/task/getTheme";
	$.ajax({
		headers: {'Content-type': 'application/json;charset=UTF-8'},
		url: _url,
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
    var $tree = $('#task_tree').treeview({
     	expandIcon: "glyphicon glyphicon-plus",
		collapseIcon: "glyphicon glyphicon-minus",
		nodeIcon: "glyphicon glyphicon-user",
		color: "#428bca",
		backColor: "#fff",
		onhoverColor: "#f5f5f5",
		borderColor: "#d8d8d8",
		showBorder: true,
		showTags: true,
		highlightSelected: true,
		selectedColor: "#fff",
		selectedBackColor: "#428bca",
		data: json,
		onNodeSelected: function(event, data) {
			var selectVal = data.fullVal;
			$("#task_group").val(data.fullText);
			$("#task_group").attr("data-val",selectVal);
			$("#task_tree").removeClass("task_tree_show").addClass("task_tree_hide");
	    }
     });
}

var delRow=-1;
//增加参数列表
function CreatePara() {		
	var rowSizes=$('#tablewrap1').datagrid("getData").length;
	
	$('#tablewrap1').datagrid("insertRow", {
		row: {
				"orderid": '<div class="input-group input-group-sm"><input id="orderid" class="form-control" value="'+rowSizes+'"></div>',
				"run_para": '<div class="input-group input-group-sm "><input id="run_para" class="form-control" value=""></div>',
				"run_para_value": '<div class="input-group input-group-sm "><input id="run_para_value" class="form-control" style="width:450px;"></div>'
		}
	});
	
	/* if(proc_type!="dp"){
		$("#tablewrap1 tbody tr").find("#orderid[value='" + rowSizes + "']").parent().parent().next().hide();
	} */
}

//删除参数列表
function DelPara() {
	var rowSizes=$('#tablewrap1').datagrid("getData").length;
	if(delRow !=-1){
		$('#tablewrap1').datagrid("deleteRow", delRow);
		delRow=-1;
	}
}

//表单验证
function validateSave(){
	var $proc_name = $("#proc_name");
    if($proc_name.val() == "") {
        alert("程序名称不能为空");
        $proc_name.focus();
        return false;
    }
    
	var $proccnname = $("#proccnname");
    if($proccnname.val() == "") {
        alert("程序中文名称");
        $proccnname.focus();
        return false;
    }
        
    if(typeof($("input[type='radio'][id='proc_type']:checked").val())== "undefined"){
        alert("请选择程序类型");
        $("input[type='radio'][id='proc_type']").focus();
        return false;
    }
    
    if(typeof($("input[type='radio'][id='cycletype']:checked").val())=="undefined"){
        alert("请选择程序周期");
        $("input[type='radio'][id='cycletype']").focus();
        return false;
    }
    
    var $level_val = $("#platform");
    if( $level_val.val()==""){
        alert("请选择接入平台");
        $level_val.focus();
        return false;
    }
  
    var $precmd = $("#precmd");
    if( $precmd.val()==""){
        alert("请选择执行命令前缀");
        $precmd.focus();
        return false;
    }
    
    var $exec_proc = $("#exec_proc");
    if($("input[type='radio'][id='proc_type']:checked").val()!='dp' && $exec_proc.val()==""){
        alert("非dp程序请输入执行程序");
        $exec_proc.focus();
        return false;
    }
    
    var $exec_path = $("#exec_path");
    if($exec_path.val()==""){
        alert("请设置程序路径");
        $exec_path.focus();
        return false;
    }
    
    if($("input[type='radio'][id='trigger_type']:checked").val()=="0"){
        var $cron_exp = $("#cron_exp");
        if($cron_exp.val()==""){
            alert("请设置计划执行时间");
            $cron_exp.focus();
            return false;
        } 
    }
    
    var paraTrList=$('#tablewrap1').find("tbody tr");
	var msg = "";
	var index=0;
    $.each(paraTrList,function(i,item){
    	index=i;
    	var orderid = $(item).find("td input[id='orderid']").val().trim();
    	var runPara = $(item).find("td input[id='run_para']").val().trim();
    	var runParaValue = $(item).find("td input[id='run_para_value']").val().trim();
    	if(orderid.length==0)msg+="参数顺序为空 ";
    	//if(proc_type=="dp" && runPara.length==0)msg+="参数名为空 ";//dp程序参数名必填
    	if(runParaValue.length==0)msg+="参数值为空 ";
    	if(msg.length>0) return false;
    });
    
    if(msg.length>0) {
		alert("第" + (index+1) + "行," + msg);
		return false;
	}

    return true;
}
</script>  
<body>
<div class="container-fluid">                
	<div class="card card-small">
	    <nav class="navbar navbar-default ">
	        <div class="container-fluid">
	            <div class="navbar-header">
	                <a class="navbar-brand" href="#"><span class="text-primary">程序信息录入</span></a>
	            </div>
	            <div class="collapse navbar-collapse">
	                <ul class="navbar navbar-nav navbar-right">
	                    <p class="navbar-text"><span class="text-success"><i class="glyphicon glyphicon-tags"></i>&nbsp; xxx <span class="text-muted">|</span> 0001</span></p>
	                    <p class="navbar-text"><a href="javascript:void(0)" data-toggle="modal" data-target="#helper"><i class="glyphicon glyphicon-question-sign"></i> 说明</a></p>
	                </ul>
	            </div>
	        </div>
	    </nav>
	           
		<!-- 基本信息-->
	    <div class="settings request-area">
		    <div class="row" >
		        <form class="form-horizontal">
		            <div class="form-group form-group-sm">
		                <label for="request_name" class="col-md-2 control-label"><span class="required">*</span>程序名称 </label>
		                <div class="col-md-4">
		                    <input id="proc_name" name="proc_name" class="form-control" value="${proc.proc_name!}" >
		                </div>
		
	                    <label for="request_person" class="col-md-2 control-label"><span class="required">*</span>程序中文名称 </label>
	                    <div class="col-md-4">
	                        <input id="proccnname" name="proccnname" class="form-control" value="${proc.proccnname!}" >
	                    </div>
		            </div>

					<div class="form-group form-group-sm">
		                <label for="proc_type" class="col-md-2 control-label"><span class="required">*</span>程序类型 </label>
		                <div class="col-md-4">
		                	<div id="proc_type"></div>
		                </div>
		                
		                <label for="cycletype" class="col-md-2 control-label"><span class="required">*</span> 运行周期 </label>
		                <div class="col-md-4">
		                	<div id ="cycletype"></div>
		                </div>
		            </div>
		            
		            <div class="form-group form-group-sm">
		
		                <label for="platform" class="col-md-2 control-label"><span class="required">*</span>接入平台 </label>
		                <div class="col-md-4">
		                    <select id="platform" name="platform" class="form-control">
		                    </select>
		                </div>
		                <label for="agent_code" class="col-md-2 control-label">执行主机</label>
		                <div class="col-md-4">
		                    <select id="agent_code" name="agent_code" class="form-control">
		                    </select>
		                </div>
		            </div>
		            
		             <div class="form-group form-group-sm">
		                <label for="precmd" class="col-md-2 control-label"><span class="required">*</span>执行命令前缀 </label>
		                <div class="col-md-4">
		                	<select id="precmd" name="precmd" class="form-control">
		                    </select>
		                </div>
		                <label for="exec_proc" class="col-md-2 control-label">执行程序 </label>
		                <div class="col-md-4">
			                <input id="exec_proc" name="exec_proc" class="form-control" value="${procsched.exec_proc!}">
		                </div>
		            </div>
		           
		            <div class="form-group form-group-sm">
		
		                <label for="exec_path" class="col-md-2 control-label"><span class="required">*</span>程序路径 </label>
		                <div class="col-md-4">
		                	 <input id="exec_path" name="exec_path" class="form-control input-sm" value="${procsched.exec_path!}">
		                </div>
		                
		                <label for="task_group" class="col-md-2 control-label">任务分组 </label>
		                <div class="col-md-4">
		                	<div class="input-group">
			                	<input id="task_group" name="task_group" class="form-control" value="${procsched.task_group_name!}" data-val="${procsched.task_group!}" readonly >
			                	<span class="input-group-btn">
			                		<button class="btn btn-default" id="task_group_clear" type="button" style="margin-left:10px;">清空</button>
			                	</span>
		    				</div>
			                <div id="task_tree" class="task_tree_hide"></div>
		                </div>
		            </div>                    
		        </form>
		    </div>
		</div>
	       
		<!-- 参数列表-->
		<div class="settings para-area">
			<div class="row">
				<div class="form-group">
			        <div id="toolbar" style="margin-left:11%;">
			            <button type="button" class="btn btn-primary btn-xs" name="" onclick="CreatePara()"> <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>增加</button>
			            <button type="button" class="btn btn-primary btn-xs" name="" onclick="DelPara()"> <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
			        </div>
	  			 	<table id="tablewrap1" class="table table-striped" style="width:750px; margin-left:11%;"></table>
	    		</div>
	    	</div>
		</div>
	
		<!-- 调度信息-->
		<div class="settings task-area">
	 		<div class="row">
				<form class="form-horizontal">
					<div class="form-group form-group-sm">
						<label for="trigger_type" class="col-md-2 control-label"><span class="required">*</span>触发类型 </label>
						<div class="col-md-4">
							<label class="radio-inline">
	                              <input type="radio" id="trigger_type" name="trigger_type" value="0" >时间触发
							</label>
							<label class="radio-inline">
	                              <input type="radio" id="trigger_type" name="trigger_type" value="1" >事件触发
							</label>
						</div>
						<label for="cron_exp" class="col-md-2 control-label"><span class="required">*</span>计划执行时间</label>
						<div class="col-md-4">
							<div class="input-group">
								<input id="cron_exp" name="cron_exp" class="form-control" value="${procsched.cron_exp!}" disabled>
								<span class="input-group-btn"> 
						        	<button class="btn btn-info btn-sm glyphicon glyphicon glyphicon-dashboard" id="touchCronExp" type="button"></button>
						    	</span>
							</div>
						</div>
					</div>
	                     
					<div class="form-group">
						<label for="muti_run_flag" class="col-md-2 control-label">启动类型</label>
							<div class="col-md-4">
								<label class="radio-inline">
									<input type="radio" id="muti_run_flag" name="muti_run_flag" value="0" >顺序启动
								</label>
								<label class="radio-inline">
									<input type="radio" id="muti_run_flag" name="muti_run_flag" value="1">多重启动
								</label>
								<label class="radio-inline">
									<input type="radio" id="muti_run_flag" name="muti_run_flag" value="2">唯一启动
								</label>
								<label class="radio-inline">
									<input type="radio" id="muti_run_flag" name="muti_run_flag" value="3">周期内顺序启动
								</label>                           	
							</div>  
							<label for="date_args" class="col-md-2 control-label"><span class="required">*</span>日期参数偏移量 </label>
							<div class="col-md-2">
							   	<div class="input-group bootstrap-touchspin number-input" style="width: 100px;">
					                <span class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-down number-minus" type="button">-</button>
					                </span><input id="date_args" type="text" class="form-control"  name="date_args" value="${procsched.date_args!}" min="-30" 
					                             style="display: block;width:50px;background-color: #fff;" disabled>
					                <div class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-up number-plus" type="button">+</button>
					                </div>
				                </div>
							</div>     
							<div class="col-md-2">
							</div>                     
						</div>
	                   
					<div class="form-group">
						<label for="pri_level" class="col-md-2 control-label">优先级 </label>
							<div class="col-md-2">						    
						    <div class="input-group bootstrap-touchspin number-input" style="width: 100px;">
				                <span class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-down number-minus" type="button">-</button>
				                </span><input id="pri_level" type="text" class="form-control" name="pri_level" value="${procsched.pri_level!}" 
				                             style="display: block;width:50px;background-color: #fff;" disabled>
				                <div class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-up number-plus" type="button">+</button>
				                </div>
			                </div>
						    	                           		
						</div>
                        <div class="col-md-2">
	                       </div>    
	                       <label for="redo_interval" class="col-md-2 control-label ">重做间隔(分钟)</label>
	                       <div class="col-md-2">						    
						   <div class="input-group bootstrap-touchspin number-input" style="width: 100px;">
			                <span class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-down number-minus" type="button">-</button>
			                </span><input id="redo_interval" type="text" class="form-control" name="redo_interval" value="${procsched.redo_interval!}" 
			                             style="display: block;width:50px;background-color: #fff;" disabled>
			                <div class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-up number-plus" type="button">+</button>
			                </div>
			              </div>
	                       </div>
	                       <div class="col-md-2">
	                       </div>   
	                   </div>
	                   
					<div class="form-group">
						<label for="redo_num" class="col-md-2 control-label">失败重做次数</label>
							<div class="col-md-2">             
								<div class="input-group bootstrap-touchspin number-input" style="width: 100px;">
					                <span class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-down number-minus" type="button">-</button></span>
					                <input id="redo_num" type="text" class="form-control" id="redo_num" name="redo_num" value="${procsched.redo_num!}" style="display: block;width:50px;background-color: #fff;" disabled>
					                <div class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-up number-plus" type="button">+</button></div>
								</div>
							</div>
	                       <div class="col-md-2">
	                       </div>  
							<label for="descr" class="col-md-2 control-label">有效期</label>
							<div class="col-md-4">
	                        	<div class="input-group">
				                    <input class="form-control input-sm form_date1" style="cursor:pointer;display: block;width:100px;" id="eff_time" name="eff_time" type="text" value="${procsched.eff_time!}" >
									<span style="float:left;margin-top:5px;">&nbsp;至&nbsp;</span>
				               		<input class="form-control input-sm form_date2" style="cursor:pointer;display: block;width:100px;" id="exp_time" name="exp_time" type="text" value="${procsched.exp_time!}" >
				            	</div>
			            	</div>
	                                          
	                   </div>
	                        
					<div class="form-group">
						<label for="redo_num" class="col-md-2 control-label">最长运行时间(小时)</label>
							<div class="col-md-4">
								<div class="input-group bootstrap-touchspin number-input" style="width: 100px;">
				                <span class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-down number-minus" type="button">-</button>
				                </span><input type="text" class="form-control" id="max_run_hours" name="max_run_hours" value="${procsched.max_run_hours!}" 
				                             style="display: block;width:50px;background-color: #fff;" disabled>
				                <div class="input-group-btn"><button class="btn btn-default bootstrap-touchspin-up number-plus" type="button">+</button>
				                </div>
				              </div>
							</div>
	                    </div>
				</form>
			</div>
		</div>
		<!-- 监控信息-->
		<div class="settings monitor-area hide">
			<div class="row">
				<form class="form-horizontal">
					<div class="form-group form-group-sm hide">
						<label for="st_day" class="col-md-2 control-label">最晚完成时间</label>
						<div class="col-md-4">
							<div class="input-group">
								<input id="st_day" name="st_day" class="form-control input-sm" >
								<span class="input-group-addon">天</span>
								<input id="st_time" name="st_time" class="form-control input-sm">
								<span class="input-group-addon">时</span>
							</div>
						</div>
					</div>
					
					<div class="form-group">
						<label for="on_focus" class="col-md-2 control-label">重要关注</label>
						<div class="col-md-4">
							<label class="radio-inline">
								<input type="radio" id="on_focus" name="on_focus" value="1" >是
							</label>
							<label class="radio-inline">
								<input type="radio" id="on_focus" name="on_focus" value="0">否
							</label>	
						</div>
						 
<!-- 						<label for="descr" class="col-md-2 control-label">期望完成时间</label>
						<div class="col-md-2">
							<input id="time_win" name="time_win" type="time" class="form-control input-sm" value="${procsched.time_win!}">
						</div> -->
					</div>
					
					<div class="form-group hide">
						<label for="monitor_topic" class="col-md-2 control-label">监控主题</label>
						<div class="col-md-4">
							<input id="monitor_topic" name="monitor_topic" class="form-control input-sm" value="${procsched.monitor_topic!}">
						</div>
					</div>
				</form>
			</div>
		</div>		
		<!-- 保存按钮-->
		<div class="row" style="padding-top: 5px;">
			<button type="button" class="btn btn-primary pull-right btn-sm" id="saveBtn" style="margin-right: 5px"><i class="glyphicon glyphicon-floppy-disk"></i> 保存信息</button>
		</div>
		
		
		<input id="curFreq" type="hidden" name="curFreq" class="form-control input-sm" value="">
	</div>
</body>
</html>