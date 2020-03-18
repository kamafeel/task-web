package com.asiainfo.dacp.dp.task.utils;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.dp.task.bean.BaseResult;

public class HttpClientUtil {
	private static Logger log = LoggerFactory.getLogger(HttpClientUtil.class);

	/**
	 * get方式
	 * 
	 * @param 
	 * @return
	 */
	//url="http://localhost:8080/UpDown/httpServer?param1="+param1+"&param2="+param2;
	public static String getHttp(String url) {
		String responseMsg = "";
		// 1.构造HttpClient的实例
		HttpClient httpClient = new HttpClient();
		// 用于测试的http接口的url
		// 2.创建GetMethod的实例
		GetMethod getMethod = new GetMethod(url);

		// 使用系统系统的默认的恢复策略
		getMethod.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler());

		try {
			// 3.执行getMethod,调用http接口
			httpClient.executeMethod(getMethod);

			// 4.读取内容
			byte[] responseBody = getMethod.getResponseBody();

			// 5.处理返回的内容
			responseMsg = new String(responseBody);
			log.info(responseMsg);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 6.释放连接
			getMethod.releaseConnection();
		}
		return responseMsg;
	}

	/**
	 * post方式
	 * 
	 * @param param1
	 * @param param2
	 * @return
	 */
	public static @ResponseBody Object postHttp(String url,String charset,NameValuePair[] nameValues) {
		Object responseMsg = "";

		// 1.构造HttpClient的实例
		HttpClient httpClient = new HttpClient();

		//httpClient.getParams().setContentCharset(charset);

		//String url = "http://localhost:8080/UpDown/httpServer";

		// 2.构造PostMethod的实例
		PostMethod postMethod = new PostMethod(url);

		// 3.把参数值放入到PostMethod对象中
		// 方式1：
		//NameValuePair[] data = { new NameValuePair("param1", param1), new NameValuePair("param2", param2) };
		postMethod.setRequestBody(nameValues);

		// 方式2：
		// postMethod.addParameter("param1", param1);
		// postMethod.addParameter("param2", param2);

		try {
			// 4.执行postMethod,调用http接口
			httpClient.executeMethod(postMethod);// 200

			// 5.读取内容
			responseMsg = postMethod.getResponseBodyAsString().trim();
			log.info(responseMsg.toString());

			// 6.处理返回的内容

		} catch (Exception e) {
			BaseResult result = new BaseResult();
			result.setReCode(400);
			result.setReMsg(e.getMessage());
			log.error("",e);
			responseMsg = result;
		} finally {
			// 7.释放连接
			postMethod.releaseConnection();
		}
		return responseMsg;
	}

	/**
	 * 测试方法
	 * @param args
	 */
	public static void main(String[] args) {
		String serviceUrl="/scheduleManager/synCache";

		String url="http://localhost:"+serviceUrl;
		
		String param1 = "111";
		String param2 = "222";
		//String url="";
		String charset="UST-8";
		NameValuePair[] data={ 
			new NameValuePair("param1", param1), 
			new NameValuePair("param2", param2) 
		};
		// get
		// System.out.println("get方式调用http接口\n"+getHttp(param1, param2));
		// post
		System.out.println("post方式调用http接口\n" + postHttp(url,charset,data));
	}
}
