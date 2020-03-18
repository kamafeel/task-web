package com.asiainfo.dacp.task.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;

/**
 * <p>Title: CustomUtils
 * <p>Description: 工具类
 * @author lll
 */
public class CustomUtils {
	
	public static long seqno=0;
	/**
	 * <p>Title: getUUID
	 * <p>Description: 生成uuid
	 */
	public static synchronized String getUUID(){
		 Date date = new Date();
		 SimpleDateFormat simpl = new SimpleDateFormat("yyMMddHHmmss");
		 String TimeSeq = simpl.format(date);		 
		 seqno = seqno + 1;
		 if(seqno >= 9999) seqno = 0;	 
		 TimeSeq = TimeSeq + String.format("1%1$04d", seqno);
		 return Long.parseLong(TimeSeq) + "";
	}
	/**
	 * 
	 * <p>Title: getNullPropertyNames
	 * <p>Description: 获取对象的空值属性数组
	 */
	public static String[] getNullPropertyNames (Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for(java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null) emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }
	
	 public static void copyPropertiesIgnoreNull(Object src, Object target){
	        BeanUtils.copyProperties(src, target, getNullPropertyNames(src));
	 }

}
