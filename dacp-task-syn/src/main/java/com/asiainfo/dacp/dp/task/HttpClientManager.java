package com.asiainfo.dacp.dp.task;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.httpclient.NameValuePair;
import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.dacp.dp.task.bean.BaseResult;

import lombok.extern.slf4j.Slf4j;

/**
 * HTTP调用组件
 * @author zhangqi
 *
 */
@Slf4j
public class HttpClientManager {
	private static int connectionTimeout = 3000;// 连接超时时间,毫秒
	private static int soTimeout = 30000;// 读取数据超时时间，毫秒
	/** HttpClient对象 */
	private static CloseableHttpClient httpclient = HttpClients.custom().disableAutomaticRetries().build();
	/*** 超时设置 ****/
	private static RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(soTimeout)
			.setConnectTimeout(connectionTimeout).build();// 设置请求和传输超时时间

	/**
	 * 根据给定的URL地址和参数字符串，以Get方法调用
	 * 
	 * @param url
	 *            String url地址，不含参数
	 * @param param
	 *            String 参数字符串，例如：a=1&b=2&c=3
	 */
	public static @ResponseBody Object executeGetMethod(String url, String param) {
		String strResult = null;
		StringBuffer serverURL = new StringBuffer(url);
		if (param != null && param.length() > 0) {
			serverURL.append("?");
			serverURL.append(param);
		}
		HttpGet httpget = new HttpGet(serverURL.toString());
		httpget.setConfig(requestConfig);
		CloseableHttpResponse response = null;
		try {
			response = httpclient.execute(httpget);
			HttpEntity entity = response.getEntity();
			int iGetResultCode = response.getStatusLine().getStatusCode();
			if (iGetResultCode >= 200 && iGetResultCode < 303) {
				return EntityUtils.toString(entity);
			} else if (iGetResultCode >= 400 && iGetResultCode < 500) {
				strResult = "请求的目标地址不存在:" + iGetResultCode;
			} else {
				strResult = "请求错误:" + iGetResultCode;
			}
		} catch (Exception ex) {
			log.error("ex:{}", ex);
			strResult = ex.getMessage();
		} finally {
			try {
				if (response != null) {
					response.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		BaseResult result = new BaseResult();
		result.setReCode(400);
		result.setReMsg(strResult);
		return result;
	}
	
	
	public static @ResponseBody Object executePostMethod(String strURL, NameValuePair[] data) {
		Map<String, String> dataMap = new HashMap<String, String>();
		for(NameValuePair nv : data){
			dataMap.put(nv.getName(), nv.getValue());
		}
		return HttpClientManager.executePostMethod(strURL, dataMap);
	}
	
	
	/**
	 * 根据给定的URL地址和参数字符串，以Post方法调用
	 * 
	 * @param url
	 *            String url地址，不含参数
	 * @param param
	 *            Map<String, Object> 参数字表单
	 */
	public static @ResponseBody Object executePostMethod(String strURL, Map<String, String> param) {
		String strResult = null;
		HttpPost post = new HttpPost(strURL);
		post.setConfig(requestConfig);
		List<BasicNameValuePair> paraList = new ArrayList<BasicNameValuePair>(param.size());
		for (Entry<String, String> pEntry : param.entrySet()) {
			if (null != pEntry.getValue()) {
				BasicNameValuePair nv = new BasicNameValuePair(pEntry.getKey(), pEntry.getValue());
				paraList.add(nv);
			}
		}
		// 使用UTF-8
		UrlEncodedFormEntity entity = new UrlEncodedFormEntity(paraList, Charset.forName("utf-8"));
		post.setEntity(entity);
		CloseableHttpResponse response = null;
		try {
			response = httpclient.execute(post);
			int iGetResultCode = response.getStatusLine().getStatusCode();
			if (HttpStatus.SC_OK == iGetResultCode) {
				HttpEntity responseEntity = response.getEntity();
				return EntityUtils.toString(responseEntity);
			}

		} catch (Exception ex) {
			log.error("ex:{}", ex);
			strResult = ex.getMessage();
		} finally {
			try {
				if (response != null) {
					response.close();
				}
			} catch (IOException e) {
			}
		}
		BaseResult result = new BaseResult();
		result.setReCode(400);
		result.setReMsg(strResult);
		return result;
	}
}