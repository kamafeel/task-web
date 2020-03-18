package com.asiainfo.dacp.task.service.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.asiainfo.dacp.jdbc.JdbcTemplate;
import com.asiainfo.dacp.modle.ThemeBean;
import com.asiainfo.dacp.task.service.TaskViewService;

@Service
public class TaskViewServiceImpl implements TaskViewService {
	private static JdbcTemplate jts =new JdbcTemplate("METADBS");

	@Override
	public List<ThemeBean> getAllThemeList() {
		String sql= "select * from proc_schedule_theme order by pid,sort_no";
		@SuppressWarnings({ "unchecked", "rawtypes" })
		List<ThemeBean> result = jts.query(sql, new Object[] {},
				new RowMapper() {
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						ThemeBean theme = new ThemeBean();
						theme.setId(rs.getString("id"));
						theme.setPid(rs.getString("pid"));
						theme.setThemeName(rs.getString("theme_name"));
						theme.setNote(rs.getString("note"));
						theme.setOnFocus(rs.getString("on_focus"));
						theme.setSortNo(rs.getInt("sort_no"));
						theme.setValidFlag(rs.getString("valid_flag"));
						theme.setAvgUseTime(rs.getString("avg_use_time"));
						return theme;
					}
				});
		return result;
	}

	@Override
	public List<String> getThemesByTeamCode(String teamCode) {
		List<String> list = new ArrayList<>();
		//list.contains(o)
		String teamCodeWhere = "";
		if(teamCode!=null && teamCode.length()>0){
			teamCodeWhere = " and b.team_code='" + teamCode + "'";
		}
		String sql = "select distinct task_group from proc_schedule_info a " +
					 " inner join proc b on a.xmlid = b.xmlid " + teamCodeWhere +
					 " where a.task_group is not null";

		@SuppressWarnings({ "unchecked", "rawtypes" })
		List<String> result = jts.query(sql, new Object[] {},
				new RowMapper() {
					public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
						return rs.getString("task_group");
					}
				});
		String temp[] = new String[]{};
		for (String res : result) {
			temp = res.split(">");
			for (String str : temp) {
				if(!list.contains(str)){
					list.add(str);
				}
			}
		}
		return list;
	}
}
