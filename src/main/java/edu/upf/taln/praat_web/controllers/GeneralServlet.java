package edu.upf.taln.praat_web.controllers;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import edu.upf.taln.praat_web.classes.Global;
import edu.upf.taln.praat_web.utils.Utils;

import static java.nio.file.StandardCopyOption.*;

@MultipartConfig
public class GeneralServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.setContentType("text/html");
		//If get call have not all required parameters we return to the main page
		try{
			GeneralFormServlet.requestWithExtraAttributes(request, null);
		}catch(Exception e){
			RequestDispatcher dispatcher = request.getRequestDispatcher("");
			dispatcher.forward(request, response);
			return;
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/GeneralForm");
		dispatcher.forward(request, response);
	}
	
	private static String SERVER_UPLOAD_LOCATION_FOLDER;
	private static String SERVER_SCRIPTS_FOLDER;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		ServletContext context = getServletContext();
		String tmpPath = context.getRealPath("/resources/core/tmp");
		SERVER_UPLOAD_LOCATION_FOLDER =  tmpPath + "/";
		
		String scriptsPath = context.getRealPath("/resources/core/scripts");
		SERVER_SCRIPTS_FOLDER =  scriptsPath + "/";
		
		//We recover form parameters
		String scriptOrder = request.getParameter("scriptsOrder");
		boolean scripts = true;
		String[] order = null;
		if(scriptOrder == null || scriptOrder.trim().equals("")){
			scripts = false;
		}else{
			order = scriptOrder.split(",");
		}
		
		String scriptsParams = request.getParameter("scriptsParams");
		String[] params = scriptsParams.split("\\|@\\|:");
		
		String audioSelection = request.getParameter("audioSelection");
		Part audioFilePart = request.getPart("audioFile");
		InputStream audioFileContent = null;
		
		String textgridSelection = request.getParameter("textgridSelection");
		Part textGridFilePart = request.getPart("textGridFile");
		InputStream textGridFileContent = null;
		
		String textSelection = request.getParameter("textSelection");
		Part textFilePart = request.getPart("textFile");
		InputStream textFileContent = null;
		
		//Data checks
		boolean audioFile = (audioFilePart != null && audioFilePart.getSize() > 0);
		if (!audioFile && audioSelection.equals("")) {
			Map<String, String> extraAttributes= new HashMap<String, String>();
			extraAttributes.put("errorMessage", "No audio provided.");
			GeneralFormServlet.requestWithExtraAttributes(request, extraAttributes);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/GeneralForm");
			dispatcher.forward(request, response);
			return;
		}
		Boolean textgrid = false;
		boolean textgridFile = (textGridFilePart != null && textGridFilePart.getSize() > 0);
		if (textgridFile || (textgridSelection != null && !textgridSelection.equals(""))) {
			textgrid = true;
		}
		Boolean text = false;
		boolean textFile = (textFilePart != null && textFilePart.getSize() > 0);
		if (textFile || (textSelection != null && !textSelection.equals(""))) {
			text = true;
		}
		
		//Obtain the input streams
		if(audioFile){
			audioFileContent = audioFilePart.getInputStream();
		}
		if(textgrid){
			if(textgridFile){
				textGridFileContent = textGridFilePart.getInputStream();
			}
		}
		if(text){
			if(textFile){
				textFileContent = textFilePart.getInputStream();
			}
		}
		
		//We generate a temporal directory name based on current time and client IP
		long currentMilis = System.currentTimeMillis();
		String ref = request.getRemoteAddr().replace(".", "").replace(":", "") + currentMilis;
		String temporalDirectory = SERVER_UPLOAD_LOCATION_FOLDER + ref + "/";
		String audioFilePath = temporalDirectory + ref + ".wav";
		String textGridFilePath = temporalDirectory + ref + ".TextGrid";
		String textFilePath = temporalDirectory + ref + ".txt";
		//We expect textgrid result of the scripts pipeline to end in "_result.TextGrid"
		String resultFilePath = temporalDirectory + ref + "_result.TextGrid";
		
		File theDir = new File(SERVER_UPLOAD_LOCATION_FOLDER + ref);
		// if the temportal directory does not exist, create it
		if (!theDir.exists()) {
		    try{
		        theDir.mkdir();
		    }catch(SecurityException se){
		    	Map<String, String> extraAttributes= new HashMap<String, String>();
				extraAttributes.put("errorMessage", "Unexpected error creating temporal directory.");
				GeneralFormServlet.requestWithExtraAttributes(request, extraAttributes);
				RequestDispatcher dispatcher = request.getRequestDispatcher("/GeneralForm");
				dispatcher.forward(request, response);
		        return;
		    }        
		}
		
		//We save needed files to the temporal directory
		if(audioFile){
			Utils.saveFile(audioFileContent, audioFilePath);
		}else{
			Files.copy(Paths.get(audioSelection), Paths.get(audioFilePath), REPLACE_EXISTING);
		}
		if(textgrid){
			if(textgridFile){
				Utils.saveFile(textGridFileContent, textGridFilePath);
			}else{
				Files.copy(Paths.get(textgridSelection), Paths.get(textGridFilePath), REPLACE_EXISTING);
			}
		}
		if(text){
			if(textFile){
				Utils.saveFile(textFileContent, textFilePath);
			}else{
				Files.copy(Paths.get(textSelection), Paths.get(textFilePath), REPLACE_EXISTING);
			}
		}
		
		//If there are scripts to run
		if(scripts){
			//Execute all modular scripts sequentialy
			for(int i = 0; i < order.length; i++){
				String scriptParams = params[i];
			
				List<String> command = new ArrayList<String>();
				//Script is python
				if (order[i].endsWith(".py")) {
					command.add("python");
					command.add(order[i]);
					command.add(temporalDirectory);
					command.add(ref);
				
				} else { //Script is praat
					command.add(Global.getPraatLocation());
					command.add("--run");
					command.add("--no-pref-files");
					command.add(order[i]);
					command.add(temporalDirectory);
					command.add(ref);
				}
				
				String[] paramsSplitted = scriptParams.split(",");
				for(int j = 0; j < paramsSplitted.length; j++){
					String param = paramsSplitted[j];
					if(!param.trim().equals("")){
						command.add(param.trim());
					}
				}
				
				try {
					Utils.executeCommand(command, 300000);
				} catch (Exception e1) {
					e1.printStackTrace();
					
					Utils.deleteFolderAndContent(temporalDirectory);
					PrintWriter out = response.getWriter();
					response.setContentType("text/html");
					out.println(e1.getMessage());
					return;
				}
			}
		}//else{
			//If there are not scripts to run extract Pitch and Intensity with default script
			List<String> command = new ArrayList<String>();
			command.add(Global.getPraatLocation());
			command.add("--run");
			command.add("--no-pref-files");
			command.add(SERVER_SCRIPTS_FOLDER + "extractPitchIntensity.praat");
			command.add(temporalDirectory);
			command.add(ref);
			try {
				if(audioFile || !audioSelection.equals("")){
					Utils.executeCommand(command, 300000);
				}
			} catch (Exception e1) {
				e1.printStackTrace();
				Utils.deleteFolderAndContent(temporalDirectory);
				PrintWriter out = response.getWriter();
				response.setContentType("text/html");
				out.println(e1.getMessage());
				return;
			}
		//}
		
		//Obtain Pitch and Intensity data for printing
		List<String> command2 = new ArrayList<String>();
		command2.add(Global.getPraatLocation());
		command2.add("--run");
		command2.add("--no-pref-files");
		command2.add(SERVER_SCRIPTS_FOLDER + "pitchIntensityScript.praat");
		command2.add(temporalDirectory);
		command2.add(ref);
		try {
			Utils.executeCommand(command2, 300000);
		} catch (Exception e1) {
			e1.printStackTrace();
			Utils.deleteFolderAndContent(temporalDirectory);
			PrintWriter out = response.getWriter();
			response.setContentType("text/html");
			out.println(e1.getMessage());
			return;
		}
		
		//Forward to viewer
		RequestDispatcher dispatcher = request.getRequestDispatcher("/Viewer");
		String contextPath = context.getContextPath();
		request.setAttribute("audioFile", contextPath + "/resources/core/tmp/" + ref + "/" + ref + ".wav");
		request.setAttribute("resultFile", scripts?resultFilePath:textGridFilePath);
		request.setAttribute("graphData", contextPath + "/resources/core/tmp/" + ref + "/" + ref + ".graph");
		request.setAttribute("tmpGeneratedFolder", ref);
		if(!scripts){ 
			request.setAttribute("download", 0);
		}
		dispatcher.forward(request, response);
		
	}
	
}
