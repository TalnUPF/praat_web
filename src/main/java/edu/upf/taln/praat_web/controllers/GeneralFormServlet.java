package edu.upf.taln.praat_web.controllers;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import edu.upf.taln.praat_web.classes.DemoData;
import edu.upf.taln.praat_web.classes.ScriptInfo;
import edu.upf.taln.praat_web.utils.Utils;

@MultipartConfig
public class GeneralFormServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	
	public static void requestWithExtraAttributes(HttpServletRequest request, Map<String, String> extras) throws JsonParseException, JsonMappingException, IOException{
		String json = (String) request.getParameter("demo");
		File jsonFile = new File(json);
		
		//Parse json file to DemoData object
		ObjectMapper mapper = new ObjectMapper();
		DemoData demoData = mapper.readValue(jsonFile, DemoData.class);
		demoData.setFilePath(json);
		
		File audiosFolder = new File(demoData.getAudiosFolder());
		List<File> audios = Utils.getFilesInFolder(audiosFolder);
		
		List<ScriptInfo> scriptsInfo = demoData.getScriptsInfo();
		Collections.sort(scriptsInfo);
		
		if(demoData.getTextgridFolder()!=null){
			File textgridsFolder = new File(demoData.getTextgridFolder());
			List<File> textgrids = Utils.getFilesInFolder(textgridsFolder);
			request.setAttribute("textgrids", textgrids);
		}

		//Initialization needed attributes
		request.setAttribute("name", demoData.getName());
		request.setAttribute("description", demoData.getDescription());
		request.setAttribute("scriptsFolder", demoData.getScriptsFolder());
		request.setAttribute("scriptsInfo", scriptsInfo);
		request.setAttribute("audios", audios);
		request.setAttribute("useTextgrids", demoData.isUseTextGrid());
		request.setAttribute("demo", json);
		
		if(extras != null){
			for(Map.Entry<String, String> entry: extras.entrySet()){
				request.setAttribute(entry.getKey(), entry.getValue());
			}
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.setContentType("text/html");
		//If get call have not all required parameters we return to the main page
		try{
			requestWithExtraAttributes(request, null);
		}catch(Exception e){
			RequestDispatcher dispatcher = request.getRequestDispatcher("");
			dispatcher.forward(request, response);
			return;
		}
		
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		requestWithExtraAttributes(request, null);
		
		getServletContext().getRequestDispatcher("/WEB-INF/views/jsp/GeneralForm.jsp")
	    .forward(request, response);
	}
	
}
