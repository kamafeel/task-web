package com.asiainfo.dacp.dp.task.type;

public enum TaskOperation {
	redoAfter,//重做后续
	redoCur,//重做当前
	forceExec,//强制执行
	forcePass,//强制通过
	setPriLevel,//设置优先级
	pauseTask,//暂停任务
	recoverTask,//恢复任务
	manualTask,//手工任务
	executeManual,//手动执行
	getWaitCode,
	getCondiNotrigger,
	executionWithoutDelay,
	runTime,
	debug,
	addNew
}
