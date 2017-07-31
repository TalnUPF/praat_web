package edu.upf.taln.praat_web.classes;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DemoData {
	String menuName;
	String menuDescription;
	String button;
	String name;
	String description;
	String audiosFolder;
	boolean useTextGrid = false; 
	String textgridFolder;
	String scriptsFolder;
	String filePath;
	List<ScriptInfo> scriptsInfo = new ArrayList<ScriptInfo>();
	
	public String getButton() {
		return button;
	}
	public void setButton(String button) {
		this.button = button;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getAudiosFolder() {
		return audiosFolder;
	}
	public void setAudiosFolder(String audiosFolder) {
		this.audiosFolder = audiosFolder;
	}
	public String getTextgridFolder() {
		return textgridFolder;
	}
	public void setTextgridFolder(String textgridFolder) {
		this.textgridFolder = textgridFolder;
	}
	public String getScriptsFolder() {
		return scriptsFolder;
	}
	public void setScriptsFolder(String scriptsFolder) {
		this.scriptsFolder = scriptsFolder;
	}
	public boolean isUseTextGrid() {
		return useTextGrid;
	}
	public void setUseTextGrid(boolean useTextGrid) {
		this.useTextGrid = useTextGrid;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public List<ScriptInfo> getScriptsInfo() {
		return scriptsInfo;
	}
	public void setScriptsInfo(List<ScriptInfo> scriptsInfo) {
		this.scriptsInfo = scriptsInfo;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public String getMenuDescription() {
		return menuDescription;
	}
	public void setMenuDescription(String menuDescription) {
		this.menuDescription = menuDescription;
	}
}
