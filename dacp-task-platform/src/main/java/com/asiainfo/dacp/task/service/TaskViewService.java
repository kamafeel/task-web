package com.asiainfo.dacp.task.service;

import java.util.List;

import com.asiainfo.dacp.modle.ThemeBean;

public interface TaskViewService {
	List<ThemeBean> getAllThemeList();
	List<String> getThemesByTeamCode(String teamCode);
}
