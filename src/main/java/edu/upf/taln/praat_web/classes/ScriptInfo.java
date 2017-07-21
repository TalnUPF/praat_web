package edu.upf.taln.praat_web.classes;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ScriptInfo implements Comparable<ScriptInfo>{
	String file;
	String description;
	String params;
	Integer defaultSort;
	
	public String getFile() {
		return file;
	}
	public void setFile(String file) {
		this.file = file;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public Integer getDefaultSort() {
		return defaultSort;
	}
	public void setDefaultSort(Integer defaultSort) {
		this.defaultSort = defaultSort;
	}
	@Override
	public int compareTo(ScriptInfo o) {
		if(defaultSort == null && o.defaultSort == null) return 0;
		else if(defaultSort == null) return 1;
		else if(o.defaultSort == null) return -1;
		
		if(defaultSort - o.defaultSort < 0){
			return -1;
		}else if(defaultSort - o.defaultSort > 0){
			return 1;
		}else{
			return 0;
		}
	}
	
}
