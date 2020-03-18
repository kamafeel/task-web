<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
		<meta name="viewport" content="width=device-width,initial-scale=1" />
		<meta name="Keywords" content="dispatch system"/>
		<meta name="description" content="dispatch system version 1.0"/>
		<title>总体监控</title>
		<link rel="stylesheet" href="${mvcPath}/dacp-lib/ued/dataps-css/bootstrap.css" />
		<link rel="stylesheet" href="${mvcPath}/dacp-lib/ued/dataps-css/font-awesome.css" />
		<link rel="stylesheet" href="${mvcPath}/dacp-lib/ued/dataps-css/dacp-css-for-dataps.css" />

		<link rel="stylesheet" href="${mvcPath}/dacp-view/css/dacp-dispatchSystem.css" />
		<link rel="stylesheet" href="${mvcPath}/dacp-view/css/dispatchSystem-css.css" />

	<script src="${mvcPath}/dacp-lib/ued/dataps-js/jquery-3.1.0.js"></script>
	<script src="${mvcPath}/dacp-lib/ued/dataps-js/bootstrap.js"></script>
	<script src="${mvcPath}/dacp-lib/ued/dataps-js/dacp-js.js"></script>
	<body>
		<div class="dissys-content">
			<div class="dacp-breadcrumb dissys-path">
				<ol class="breadcrumb">
				  	<li><a href="#">主页</a></li>
				  	<li><a href="#">运维监控</a></li>
				  	<li><a href="#">总体监控</a></li>
				</ol>
			</div>
			<div class="dissys-monitor">
				<div class="row">
					<div class="col-md-6">
						<div class="dacp-dissys-block dissys-block" id="realTimeMonitor">
							<div class="dacp-dissys-block-heading clearfix">
								<h2 class="dacp-dissys-block-title pull-left">实时监控</h2>
								<div class="pull-right dissys-block-right">
									<a class="btn btn-sm dacp-btn-white dacp-btn-ellipse" href="#">订阅</a>
								</div>
							</div>
							<div class="dacp-dissys-block-body">
								<div class="text-center">
									<div>
										<a href="#"><span class="dissys-data">63,342</span></a>
										<label class="dacp-tag dacp-tag-triangle">总数</label>
									</div>
									<a href="#">失败任务增幅异常，建议查看优化分析</a>
								</div>
								<div class="row">
									<div class="col-xs-4 col-md-4">
										<div>
											<p>
												<a href="#">
													<span class="dissys-data dacp-color-warning">432</span>
													<span class="fa fa-long-arrow-up dacp-color-warning">&nbsp;</span>
												</a>
											</p>
											<p><label class="dacp-tag dacp-tag-triangle dacp-tag-error">失败</label></p>
											<button class="btn btn-sm dacp-btn-blue dacp-btn-ellipse">优化</button>
										</div>
									</div>
									<div class="col-xs-4 col-md-4">
										<div>
											<p>
												<a href="#">
													<span class="dissys-data">13,342</span>
													<span class="fa fa-long-arrow-down dacp-color-success">&nbsp;</span>
												</a>
											</p>
											<p><label class="dacp-tag dacp-tag-triangle">成功</label></p>
										</div>
									</div>
									<div class="col-xs-4 col-md-4">
										<div>
											<p><a href="#"><span class="dissys-data">43,432</span></a></p>
											<p><label class="dacp-tag dacp-tag-triangle dacp-tag-success">运行中</label></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="dacp-dissys-block dissys-block" id="systemInfo">
							<div class="dacp-dissys-block-heading clearfix">
								<h2 class="dacp-dissys-block-title pull-left">系统信息</h2>
								<div class="pull-right dissys-block-right">
									<a class="btn btn-sm dacp-btn-white dacp-btn-ellipse" href="#">更多</a>
								</div>
							</div>
							<div class="dacp-dissys-block-body">
								<div class="dacp-list">
		    						<div class="dacp-list-content">
		    							<ul class="nav nav-stacked">
		    								<li>
		    									<a href="#">
		    										内存不足告警。
		    										<span>09:01:35</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										硬盘使用率预警/告警。
		    										<span>2016-08-29</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										内存不足告警。
		    										<span>2016-08-19</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										硬盘使用率预警/告警。
		    										<span>2016-08-09</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										 硬盘使用率预警/告警。
		    										<span>2016-06-29</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										内存不足告警。
		    										<span>2016-08-19</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										硬盘使用率预警/告警。
		    										<span>2016-08-09</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										内存不足告警。
		    										<span>2016-08-19</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										硬盘使用率预警/告警。
		    										<span>2016-08-09</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										内存不足告警。
		    										<span>2016-08-19</span>
		    									</a>
		    								</li>
		    								<li>
		    									<a href="#">
		    										硬盘使用率预警/告警。
		    										<span>2016-08-09</span>
		    									</a>
		    								</li>
		    							</ul>
		    						</div>
		    					</div>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="dacp-dissys-block dissys-block" id="missonTrend">
							<div class="dacp-dissys-block-heading clearfix">
								<h2 class="dacp-dissys-block-title pull-left">任务趋势</h2>
								<div class="pull-right dissys-block-right">
									<ul class="nav nav-tabs">
		    							<li class="active"><a href="#tab12" data-toggle="tab" aria-expanded="true">今日</a></li>
		    							<li><a href="#tab13" data-toggle="tab" aria-expanded="true">3天</a></li>
		    							<li><a href="#tab14" data-toggle="tab" aria-expanded="true">5天</a></li>
		    							<li><a href="#tab15" data-toggle="tab" aria-expanded="true">最近一个月</a></li>
		    						</ul>
								</div>
							</div>
							<div class="dacp-dissys-block-body">
								<div class="tab-content">
	    							<div class="tab-pane active" id="tab12">
	    								<div class="dissys-imgwrapper">
	    									<img src="dispatchSystem-image/dissys-missiontrend.png"/>
	    								</div>
	    							</div>
	    							<div class="tab-pane" id="tab13">
	    								tab13
	    								
	    							</div>
	    							<div class="tab-pane" id="tab14">
	    								tab14
	    								
	    							</div>
	    							<div class="tab-pane" id="tab15">
	    								tab15
	    								
	    							</div>
	    						</div>								
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="dacp-dissys-block dissys-block" id="missonMonitor">
							<div class="dacp-dissys-block-heading clearfix">
								<h2 class="dacp-dissys-block-title pull-left">任务监控</h2>
								<div class="pull-right dissys-block-right">
									<a class="btn btn-sm dacp-btn-white dacp-btn-ellipse" href="#">更多</a>
								</div>
							</div>
							<div class="dacp-dissys-block-body">
								<div class="dacp-table">
		    						<table class="table table-bordered table-hover">
		    							<thead>
		    								<tr>
		    									<th>服务器名称</th>
		    									<th>上线任务</th>
		    									<th>状态</th>
		    									<th>完成</th>
		    									<th>失败</th>
		    									<th>等待运行</th>
		    								</tr>
		    							</thead>
		    							<tbody>
		    								<tr>
		    									<td><a href="#">嘀嘀打车</a></td>
		    									<td>245</td>
		    									<td><button class="btn btn-sm dacp-btn-red">异常</button></td>
		    									<td class="dacp-color-hilight">0</td>
		    									<td class="dacp-color-warning">245</td>
		    									<td>0</td>
		    								</tr>
		    								<tr>
		    									<td><a href="#">京东大数据</a></td>
		    									<td>967</td>
		    									<td><button class="btn btn-sm dacp-btn-green">运行中</button></td>
		    									<td class="dacp-color-hilight">423</td>
		    									<td class="dacp-color-warning">32</td>
		    									<td>42</td>
		    								</tr>
		    								<tr>
		    									<td><a href="#">阿里云</a></td>
		    									<td>675</td>
		    									<td><button class="btn btn-sm dacp-btn-blue">完成</button></td>
		    									<td class="dacp-color-hilight">534</td>
		    									<td class="dacp-color-warning">42</td>
		    									<td>521</td>
		    								</tr>
		    								<tr>
		    									<td><a href="#">网易云</a></td>
		    									<td>745</td>
		    									<td><button class="btn btn-sm dacp-btn-green">运行中</button></td>
		    									<td class="dacp-color-hilight">567</td>
		    									<td class="dacp-color-warning">1</td>
		    									<td>436</td>
		    								</tr>
		    								<tr>
		    									<td><a href="#">淘宝</a></td>
		    									<td>864</td>
		    									<td><button class="btn btn-sm dacp-btn-green">运行中</button></td>
		    									<td class="dacp-color-hilight">456</td>
		    									<td class="dacp-color-warning">32</td>
		    									<td>075</td>
		    								</tr>
		    								<tr>
		    									<td><a href="#">其他</a></td>
		    									<td>345</td>
		    									<td><button class="btn btn-sm dacp-btn-gray">等待</button></td>
		    									<td class="dacp-color-hilight">253</td>
		    									<td class="dacp-color-warning">41</td>
		    									<td>356</td>
		    								</tr>
		    							</tbody>
		    						</table>
		    					</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
