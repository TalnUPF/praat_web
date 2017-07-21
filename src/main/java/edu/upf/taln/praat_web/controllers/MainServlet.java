package edu.upf.taln.praat_web.controllers;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.upf.taln.praat_web.classes.DemoData;

public class MainServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	ServletContext context = getServletContext();
    	String demosPath = context.getRealPath("/resources/core/demos");
    	
    	//We search for all the folders with a config file in the demos directory
    	List<DemoData> demos = new ArrayList<DemoData>();
    	File demosFolder = new File(demosPath);
    	if (demosFolder.isDirectory()) {
			for (final File fileEntry : demosFolder.listFiles()) {
		        if (fileEntry.isDirectory()) {
		        	for (final File subFileEntry : fileEntry.listFiles()) {
		        		if (!subFileEntry.isDirectory()) {
		        			if(subFileEntry.getName().equals("config.json")){
		        				ObjectMapper mapper = new ObjectMapper();
		        				DemoData demoData = mapper.readValue(subFileEntry, DemoData.class);
		        				demoData.setFilePath(subFileEntry.getAbsolutePath());
		        				demos.add(demoData);
		        			}
		        		}
		        	}
		        }
		    }
		}
    	request.setAttribute("demos", demos);
    	
    	getServletContext().getRequestDispatcher("/WEB-INF/views/jsp/index.jsp")
	    .forward(request, response);     
    }
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		doGet(request, response);
	}
    
}
