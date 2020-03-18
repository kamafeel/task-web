<!DOCTYPE html>
<html lang="zh" class="app">
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge"></meta>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<meta charset="utf-8"></meta>
<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>DACP数据云图</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<link rel="stylesheet" href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" />
<link href="${mvcPath}/dacp-view/aijs/css/ai.css" type="text/css" rel="stylesheet"/>
<!--[if lt IE 9]>
	<script src="lib/ie/html5shiv.js">
	</script>
	<script src="lib/ie/respond.js">
	</script>
	<script src="lib/ie/excanvas.js">
	</script>
<![endif]-->
<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="${mvcPath}/dacp-lib/bootstrap/js/bootstrap.min.js"></script>	
	
<!-- 使用ai.core.js需要将下面两个加到页面 -->
<script src="${mvcPath}/dacp-lib/cryptojs/aes.js" type="text/javascript"></script>
<script src="${mvcPath}/crypto/crypto-context.js" type="text/javascript"></script>

<script src="${mvcPath}/dacp-view/aijs/js/ai.treeview.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.core.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.field.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.jsonstore.js"></script>
<script src="${mvcPath}/dacp-view/aijs/js/ai.grid.js"></script>
  
<script src="${mvcPath}/dacp-res/task/js/metaStore.v1.js"></script>
<style type="text/css">
.form-control {
	height: 34px;
}
.row {
	margin-top: 3px;
}
.btn {
	font-weight: 800;
	border-radius: 5px;
}

</style>
<script type="text/javascript">
$(document).ready(function(){
	var curTeamCode = paramMap['TEAM_CODE'];

 //定义sql语句
 var oldValue;
 var oldValueRun;
 var flag=false;
 var flag1=null;
  var sql={　
  content:"SELECT date_args,run_freq,CONCAT(task_num,'') task_num,CONCAT(SUCC_NUM,'') succ_num,CONCAT(fail_num,'') fail_num,CONCAT(running_num,'') running_num,CONCAT(other_num,'') other_num,CONCAT(run_flag,'') run_flag,stat_time,oper_time,user_name FROM schedule_task_premisstion where 1=1 {condi}",
  getContent:function(condition){
    return this.content.replace('{condi}',condition||"");
  }
};

　var store = new  AI.JsonStore({ //Json 里面建立一个store对象
   sql:sql.getContent(),
   dataSource:"METADBS",
   table:'schedule_task_premisstion',
   key:'date_args',

});	
	var procUserName = ai.getStoreData("select USERNAME,USECNNAME from metauser");
	var getUserCNName = function(record,val){
		for (var i =0; i < procUserName.length; i++) {
			if (val == procUserName[i]["USERNAME"]) {
				return procUserName[i]["USECNNAME"]
			};
		};console.info(val);
		return val;
	    	
	};


 //页面显示表单
	var grid = new AI.Grid({							
		store:store,																		
		id:'expl',									
		containerId:'grid-container',					
		pageSize:15,									
		nowrap:true,									
		showcheck:true,									
		columns:[		//列头								
			{
				header:"批次号",						
				dataIndex: 'DATE_ARGS',					
				sortable: true,							
				maxLength:20,
			},
			{
				header:"周期",dataIndex: 'RUN_FREQ',  sortable: true,maxLength:20,
            render:function(record,value){			//自定义渲染，record参数为当前记录，value为当前列字段值
					if(value=='month')
					{
						return "月";
					}
					else if (value=='day'){
						return "日";
					}else if (value=='hour'){
						return "小时";
					}else{
						return "分钟";
					}

				}
			},
		    {header:"当天任务总数",dataIndex: 'TASK_NUM',  sortable: true,maxLength:20},
			{header:"当天任务成功数",dataIndex: 'SUCC_NUM',  sortable: true,maxLength:20,
                         render:function(record,value){

            	return '<font color=green></font><span style="color:blue">'+value+'</span>'
            }
		},
			{header:"当天任务失败数",dataIndex: 'FAIL_NUM',  sortable: true,maxLength:20,
            render:function(record,value){

            	return '<font color=red></font><span style="color:red">'+value+'</span>'
            }

		},
			{header:"运行的次数",dataIndex: 'RUNNING_NUM',  sortable: true,maxLength:20},
			{header:"其他任务次数",dataIndex: 'OTHER_NUM',  sortable: true,maxLength:20},
			{header:"是否允许标识",dataIndex: 'RUN_FLAG',  sortable: true,maxLength:20,
			 render:function(record,value){			//自定义渲染，record参数为当前记录，value为当前列字段值
					if(value=='1')
					{   
						return "允许执行";
					}
					else
						{return "不允许执行"}

				}

		},
			{header:"统计更新时间",dataIndex: 'STAT_TIME',  sortable: true,maxLength:20},
			//{header:"插入时间",dataIndex: 'OPER_TIME',  sortable: true,maxLength:20},
			//获取操作人员的值赋给USER_NAME
			{header:"操作人员",dataIndex: 'USER_NAME', sortable: true,maxLength:20,render:getUserCNName},
            


		]
	});
	$('#dialog-ok').on('click',function(){
		if (flag1=="add")
		{     
			var  dataArgs=$('#DATE_ARGS').val();
			var runFreq= $('#RUN_FREQ').val();
			var runflag=$('#RUN_FLAG').val();
			if(dataArgs==null||dataArgs==''){
				alert("批次号不能为空");
				return false;
			}
			if(runFreq==null||runFreq==''){
				alert("周期不能为空");
				return false;
			}
			if(runflag==null||runflag==''){
				alert("请选择是否允许执行");
				return false;
			}
			store.commit();
		var inTime=new Date().format('yyyy-MM-dd HH:mm:ss');
			ai.executeSQL("UPDATE schedule_task_premisstion SET oper_time ='"+inTime+"',user_name='"+_UserInfo.username+"' WHERE date_args='"+dataArgs+"'",false,"METADBS");
		var condi = "";
          store.select(sql.getContent(condi));
		$('#myModal').modal('hide');
	}
        else{
        	upTime=new Date().format('yyyy-MM-dd HH:mm:ss');
          ai.executeSQL("UPDATE schedule_task_premisstion SET date_args='"+$('#DATE_ARGS').val()+"', run_freq='"+$('#RUN_FREQ').val()+"',run_flag='"+$('#RUN_FLAG').val()+"',oper_time ='"+upTime+"',user_name='"+_UserInfo.username+"' WHERE date_args='"+oldValue+"' and run_freq='"+oldValueRun+"'",false,"METADBS");
          var condi = "";
          store.select(sql.getContent(condi));
         $('#myModal').modal('hide');
        // update metauser set username='',password='' where username="USERNAME"
        }
	});
	$('#dialog-cancel').on('click',function(){
		ai.executeSQL("select * from schedule_task_premisstion",false,"METADBS");
		store.select();
		for(var i=0;i<store.getCount();i++){
		    var _r = store.getAt(i);
		    	store.remove(_r);  
	    }
		store.cache={
			save:[],
			remove:[],
			update:[]
		};
	      var condi = "";
          store.select(sql.getContent(condi));
		$('#myModal').modal('hide');
	});

	$('#dialog-cancel1').on('click',function(){
	for(var i=0;i<store.getCount();i++){
		    var _r = store.getAt(i);
		    	store.remove(_r);   
	    }
	    store.cache={
			save:[],
			remove:[],
			update:[]
		};
		
	 var condi = "";
          store.select(sql.getContent(condi));
    $('#myModal').modal('hide');
     
	});


 //查询数据
	$('#query').on('click',function(){
          var condi = " and date_args like '%"+$("#for-query").val()+"%'";
          store.select(sql.getContent(condi));
	});
   var addRecord=function(){
    var record=store.getNewRecord();//生成一个store对象

    store.add(record);//添加到store里面
     store.curRecord=record;//新增表单加入record

   };
   	var buildForm = function(){
		$('#upsertForm').empty();
		if(flag==true)
		{  //修改数据
			var selected=grid.getCheckedRows();
			if(selected.length<=0){
				alert("请选择要修改的数据");
				return false;
			}
			if(selected.length>1){
				alert("只能选择一条数据");
				return false;
			}
			var condi = " and date_args ='"+selected[0].get("DATE_ARGS")+"'";
		    store.select(sql.getContent(condi));
	    }
		$('#myModal').modal('show');
		var form = new AI.Form({							
			id : 'form',									
			store : store,									
			containerId : 'upsertForm',						
			items : [ 										
				{											
					type : 'date',							
					label : '批次号',						
					fieldName : 'DATE_ARGS',					
                },
				{type : 'combox',label : '周期',fieldName : 'RUN_FREQ',storesql:'day,天|hour,小时|minute,分钟'}, 
				{type : 'combox',label : '是否允许执行',fieldName : 'RUN_FLAG',storesql:'0,不允许执行|1,允许执行'},
			],
		});

	};
     
	/*插入数据*/
   	$('#insert').on('click',function(){
       flag=false;
       flag1="add";
       addRecord();
       buildForm();
       
	});
  //修改数据
	$('#update').on('click',function(){
     flag=true;
     buildForm();
     oldValue=$('#DATE_ARGS').val();
     oldValueRun=$('#RUN_FREQ').val();
 });
  //删除数据
   $('#delete').on('click',function(){
	   var selected=grid.getCheckedRows();
     if(selected.length<=0){
			alert("请选择要修改的数据");
			return false;
		}
		if(selected.length>1){
			alert("只能选择一条数据");
			return false;
		}
   if (confirm('确认删除？')) {

	     var condi = " and date_args='"+selected[0].get("USERNAME")+"'";

     ai.executeSQL("delete from schedule_task_premisstion where date_args='"+selected[0].get("DATE_ARGS")+"' and run_freq='"+selected[0].get("RUN_FREQ")+"'",false,"METADBS");
     store.select();

   };

   });


})
</script>


<body>
<div id="exmpale">
<div class="row">
	<div class="col-md-4">
    <div class="input-group">
      <input type="text" class="form-control" placeholder="批次号" id="for-query">
      <span class="input-group-btn">
        <button class="btn btn-default"  type="button" id="query">查询</button>
      </span>
    </div><!-- /input-group -->
  </div><!-- /.col-lg-6 -->
  <div class="col-xs-12 col-md-6">
  	<button class="btn btn-default" type="submit" id="insert">新增</button>
  	<button class="btn btn-default" type="submit" id="update">修改</button>
  	<button class="btn btn-default" type="submit" id="delete">删除</button>
  </div>
</div>
<div class="row">
  <div class="col-xs-12 col-md-12" id="grid-container"></div>
</div>
</div>·
<div id="myModal" class="modal fade"> 
	<div class="modal-dialog"> 
	    <div class="modal-content" > 
	     <div class="modal-header"> 
		      <button type="button" id ="dialog-cancel1" class="close close-modal" > <span aria-hidden="true">&times;</span><span class="sr-only">Close</span> </button> 
		      <h4 class="modal-title">用户管理</h4> 
	     </div> 
	     <div class="modal-body" id="upsertForm"></div> 
	     <div class="modal-footer">
			<button id="dialog-cancel" type="button" class="btn btn-default">取消</button> 
			<button id="dialog-ok" type="button" class="btn btn-primary">保存</button>
	     </div> 
	    </div>
	<!-- /.modal-content --> 
	</div> 
<!-- /.modal-dialog --> 
</div>
</body>
</html>
