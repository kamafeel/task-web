<!DOCTYPE html>
<html lang="zh" class="app">
<head>
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge"></meta>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
<meta charset="utf-8"></meta>
<meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
<title>DACP数据云图</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
	<link href="${mvcPath}/dacp-lib/bootstrap/css/bootstrap.min.css" type="text/css" rel="stylesheet" media="screen"/>
	<script src="${mvcPath}/dacp-lib/jquery/jquery-1.10.2.min.js" type="text/javascript"></script>

<script type="text/javascript">

$(document).ready(function() {
	
	$("#btn").click(function(){
		$.ajax({
			url: "/dacp/shd/saveKpiScopeDependciesInfo",
			type: "post",
			dataType: "json",
			data: {
				"target": "B",
				"targetCycle": "day",
				"targetType": "scope",
				"source": "aa,bb,cc",
				"sourceCycle": "day,day,month",
				"sourceType": "proc"
			},
			success:function(msg){
				var msg = $.parseJSON(msg);
				$("#result").empty().append("返回信息："+"<br/>").append(msg.toString());
			}
		});
	})
	
	$("#btn1").click(function(){
		$.ajax({
			url: "/dacp/taskOpt/setPriLevel",
			type: "post",
			dataType: "json",
			data: {
				"seqno": "16102121541110004",
				"prilevel": "8888",
			},
			success:function(msg){
				var msg = $.parseJSON(msg);
				$("#result").empty().append("返回信息："+"<br/>").append(msg.toString());
			}
		});
	})
	
	$("#btn2").click(function(){
		$.ajax({
			url: "/dacp/taskOpt/queryTaskScriptLog",
			type: "post",
			dataType: "json",
			data: {
				"seqno": "20161015203906912"
			},
			success:function(msg){
				var msg = $.parseJSON(msg);
				$("#result").empty().append("返回信息："+"<br/>").append(msg.toString());
			}
		});
	})
	
	$("#btn3").click(function(){
		var data=[{"jobCode":"11"},
			      {"jobCode":"12"},
			      {"jobCode":"13"},
			      {"jobCode":"12"}];
		$.ajax({
			url: "/dacp/task/taskRegister",
			type: "post",
			dataType: "json",
			data: {"data":JSON.stringify(data)},
			success:function(msg){
				$("#result").empty().append("返回信息："+"<br/>").append(msg.response);
			}
		});
	})
	
});
</script>
</head>
<body>
<button id="btn" class="btn btn-default">测试指标组服务</button><br/>
<pre id="result">返回信息</pre>
<br><br><br><br>
<button id="btn1" class="btn btn-default">测试调度服务</button><br/>
<button id="btn2" class="btn btn-default">查看日志</button><br/>
<button id="btn3" class="btn btn-default">测试调度注入服务</button><br/>
</body>
</html>