package com.asiainfo.dacp.task.service.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.modle.ProcScheduleInfo;
import com.asiainfo.dacp.modle.ProcessCatalog;
import com.asiainfo.dacp.modle.ProcessInfo;
import com.asiainfo.dacp.task.service.ProcessService;

@Service
public class ProcessServiceImpl implements ProcessService {
	private static Logger LOG = LoggerFactory.getLogger(ProcessServiceImpl.class);
	private static JdbcTemplate jts =new JdbcTemplate("METADBS");
	
	@Override
	public List<ProcessInfo> getProcessList() {
		String sql= "select * from proc_schedule_theme order by pid,sort_no";
		@SuppressWarnings({ "unchecked", "rawtypes" })
		List<ProcessInfo> result = jts.query(sql, new Object[] {},
				new RowMapper() {
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ProcessInfo process = new ProcessInfo();
//						theme.setId(rs.getString("id"));
//						theme.setPid(rs.getString("pid"));
//						theme.setThemeName(rs.getString("theme_name"));
//						theme.setNote(rs.getString("note"));
//						theme.setOnFocus(rs.getString("on_focus"));
//						theme.setSortNo(rs.getInt("sort_no"));
//						theme.setValidFlag(rs.getString("valid_flag"));
//						theme.setAvgUseTime(rs.getString("avg_use_time"));
						return process;
					}
				});
		return result;
	}
	
	@Override
	public List<ProcessCatalog> getProcessCatalogList() {
		String sql= "select * from process_catalog order by pid,order_id";
		@SuppressWarnings({ "unchecked", "rawtypes" })
		List<ProcessCatalog> result = jts.query(sql, new Object[] {},
				new RowMapper() {
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ProcessCatalog catalog = new ProcessCatalog();
						catalog.setCid(rs.getString("cid"));
						catalog.setPid(rs.getString("pid"));
						catalog.setCname(rs.getString("cname"));
						catalog.setClevel(rs.getString("clevel"));
						catalog.setOrderId(rs.getString("order_id"));
						catalog.setIcon(rs.getString("icon"));
						catalog.setRemark(rs.getString("remark"));
						return catalog;
					}
				});
		return result;
	}

	@Override
	public List<ProcessCatalog> getBusinessList() {
		String sql= "select * from proc_schedule_dim where dim_group_id =(select xmlid from proc_schedule_dim_group where group_code='BUSINESS_TYPE')";
		@SuppressWarnings({ "unchecked", "rawtypes" })
		List<ProcessCatalog> result = jts.query(sql, new Object[] {},
				new RowMapper() {
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ProcessCatalog catalog = new ProcessCatalog();
						catalog.setCid(rs.getString("dim_code"));
						catalog.setPid(null);
						catalog.setCname(rs.getString("dim_value"));
						catalog.setClevel("0");
						catalog.setOrderId(rs.getString("dim_seq"));
						catalog.setIcon("d-icon-folder-open");
						catalog.setRemark(rs.getString("remark"));
						return catalog;
					}
				});
		return result;
	}
	
	@Override
	public boolean saveProcess(ProcessInfo processInfo) {
		try {
			processInfo.save(jts);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean isProcessExists(String pid) {
		String sql="select * from process_list where pid='"+pid+"'";
		List list = jts.queryForList(sql);
		
		if(list.isEmpty()){
			return false;
		}
		return true;
	}

	@Override
	public boolean deleteProcess(String pid) {
		try {
			String sql="delete from  process_list where pid='"+pid+"'";
			jts.execute(sql);
			return true;
		} catch (Exception e) {
			LOG.error(e.getMessage());
			return false;
		}
	}

	
}
