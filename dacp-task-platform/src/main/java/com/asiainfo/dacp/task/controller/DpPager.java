package com.asiainfo.dacp.task.controller;
import java.util.List;

import org.springframework.data.domain.Page;


public class DpPager<T> {
	
	public  DpPager(Page <T> page,int current_page,int per_page){
		
		this.total=page.getTotalElements();
		this.per_page=per_page;
		this.current_page=current_page;
		this.last_page=page.getTotalPages();
		this.data=page.getContent();
		this.from=(current_page-1)*per_page+1;
		this.to=(current_page-1)*per_page+page.getNumberOfElements();
	}
	
	public DpPager(){
		
	}
	
	private long total=0;
	private int per_page=0;
	private int current_page=0;
	private int from=0;
	private int to=0;
	private int last_page=0;
	private List<T> data;
	public long getTotal() {
		return total;
	}
	public void setTotal(long total) {
		this.total = total;
	}
	public int getPer_page() {
		return per_page;
	}
	public void setPer_page(int per_page) {
		this.per_page = per_page;
	}
	public int getCurrent_page() {
		return current_page;
	}
	public void setCurrent_page(int current_page) {
		this.current_page = current_page;
	}
	public int getFrom() {
		return from;
	}
	public void setFrom(int from) {
		this.from = from;
	}
	public int getTo() {
		return to;
	}
	public void setTo(int to) {
		this.to = to;
	}
	public int getLast_page() {
		return last_page;
	}
	public void setLast_page(int last_page) {
		this.last_page = last_page;
	}
	public List<T> getData() {
		return data;
	}
	public void setData(List<T> data) {
		this.data = data;
	}
	
	
}
