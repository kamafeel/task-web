package com.asiainfo.dacp.task.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TreeUtil {
	
	/**
	 * list数组转为树型
	 * @param list 数据集
	 * @param idName 编号字段,默认id
	 * @param pidName 父级编号字段，默认pid
	 * @param childName 子集名称，默认children
	 * @return 返回树形结构的集合
	 */
	public static List<Map<String,Object>> listToTree(List<Map<String,Object>> list,String idName,String pidName,String childName){
		if(idName == null || idName.length() == 0){
			idName = "id";
		}
		if(pidName == null || pidName.length() == 0){
			pidName = "pid";
		}
		if(childName == null || childName.length() == 0){
			childName = "children";
		}
		List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();
		Map<String,Map> hash = new HashMap<String,Map>();
		Map map ,parentMap = new HashMap();
		String id,pid;
		for(int i = 0 ,length = list.size(); i<length; i++){
			map = list.get(i);
			hash.put((String)map.get(idName), map);
		}
		for(int i = 0 ,length = list.size(); i<length; i++){
			map = list.get(i);
			id = (String)map.get(idName);
			pid = (String)map.get(pidName);
			if(pid != null && pid.length() > 0 && (parentMap = hash.get(pid)) != null){
				List<Map> childList = (List)parentMap.get(childName);
				if(childList == null){
					childList = new ArrayList<Map>();
					parentMap.put(childName, childList);
				}
				childList.add(map);
			}else{
				resultList.add(map);
			}
		}
		
		return resultList;
	}
}
