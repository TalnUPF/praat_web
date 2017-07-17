// do a call to the generalDemo.jsp with the get parameter as the file<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<%@ page import="java.util.HashMap" %>
	<%@ page import="edu.upf.dtic.classes.FileFormInfo" %>
	<%@ page import="java.util.Map.Entry" %>
	<%@page import ="org.json.simple.JSONArray" %>
	<%@page import ="org.json.simple.JSONObject" %>
	<%@page import ="org.json.simple.parser.JSONParser" %>
	<%@page import ="org.json.simple.parser.ParseException" %>
	<%@page import ="java.io.FileNotFoundException" %>
	<%@page import ="java.io.FileReader" %>
	<%@page import ="java.io.IOException" %>
	<%@page import ="java.util.Iterator" %> 
	<%@page import ="java.io.File" %>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<link href="${pageContext.se
	rvletContext.contextPath}/resources/core/css/forms.css" rel="stylesheet" type="text/css"/>
	<link href="${pageContext.servletContext.contextPath}/resources/core/css/general.css" rel="stylesheet" type="text/css"/>
	<title>Demo 2: Modular Scripting</title>
</head>
<body>

	<%
	String fileName=request.getParameter("file");
	File file = request.getRealPath("${pageContext.servletContext.contextPath}/resources/demos/"+fileName);  
	// get name and description of the demo
	JSONParser parser = new JSONParser();

	        try {

	            Object obj = parser.parse(new FileReader(file));

	            JSONObject jsonObject = (JSONObject) obj;
	            String name = (String) jsonObject.get("name");
	            String description = (String) jsonObject.get("description");
	            String scriptsPath = (String) jsonObject.get("sciptsPath");
	            String audiosPath = (String) jsonObject.get("audiosPath");
	            String textGridsPath = (String) jsonObject.get("textGridsPath");

	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } catch (ParseException e) {
	            e.printStackTrace();
	        }
	 %>
	<div class="container">
		<div class="page-header">
		    <h1 class="left"><% System.out.print(name);  %></h1>
		     <a href="${pageContext.servletContext.contextPath}/" class="right back">Back to Menu <span class="glyphicon glyphicon-hand-left"></span></a>
		</div>
		<div class="page-subheader">
		    <div class="left">
		    	<% System.out.print(description);  %>
		    </div>
		</div>
		<div class="form" id="formDiv">
			<form action="Modules" method="post" enctype="multipart/form-data" id="runForm">
				<div class="row">
	  				<div class="col-sm-5">
		  				<div class="praat-group">
			  				<div class="related-praat-group">
								<label for="audioFile">Upload your audio file or select a sample file:</label>
								<input type="file" id="audioFile" name="audioFile" size="50" class="fileInput"/>
							</div>
							<div >
							 	<select class="form-control" id="audioSel" name="audioSelection">
							 		<option value="" selected="selected">Select an option</option>
							 		<%
								 		File audios = request.getRealPath("${pageContext.servletContext.contextPath}/"+audiosPath);  
								 		File[] list = audios.listFiles();
								 		for (File file : list){
								 			// read the file, File contents in Json format
								 			String fileName=file.getName();
									   			%><option value="<%=fileName%>"><%=fileName%></option><%
											}
							 		%>
								</select>
							</div>
						</div>
						
						<div  id="textgridDiv">
							<div class="praat-group">
				  				<div class="related-praat-group">
									<label for="textGridFile">Upload your TextGrid file or select a sample file: </label> 
									<input type="file" id="textGridFile" name="textGridFile" size="50" class="fileInput"/>
				  				</div>
				  				<div >
								 	<select class="form-control" id="tgSel" name="textgridSelection">
								 		<option value="" selected="selected">Select an option</option>
								 		<%
								 		File textGrids = request.getRealPath("${pageContext.servletContext.contextPath}/"+textGridsPath);  
								 		list = textGrids.listFiles();
								 		for (File file : list){
								 			// read the file, File contents in Json format
								 			String fileName=file.getName();
									   			%><option value="<%=fileName%>"><%=fileName%></option><%
										}
							 		%>
									</select>
				  				</div>
				  			</div>
						</div>
				
						<div  id="checkboxDiv">
			  				<div class="praat-group">
			  					<label for="justFinalTiers">Select visualization mode:</label>
				  				<div class="checkbox">
									<label><input type="checkbox" id="justFinalTiers" name="justFinalTiers" class="large-checkbox" value="1" > Only predicted tiers</label>
								</div>
			  				</div>
			  			</div>
					</div>
					<div class="col-sm-2"></div>
	  				<div class="col-sm-5">
	  					<div class="praat-group">
			  				<div data-force="30" class="layer block" style="width: 100%;">
								<div class="layer title">Selected modules</div>
								<ul id="selected" class="block__list block__list_words">
								</ul>
							</div>
	  					</div>
		  				<div class="praat-group" style="display:none">
		  					<div data-force="18" class="layer block" style="width: 100%;">
								<div class="layer title">Available modules</div>
								<ul id="available" class="block__list block__list_words">
								<%
						 		File spripts = request.getRealPath("${pageContext.servletContext.contextPath}/"+scriptsPath); 
						 		list = scripts.listFiles();
						 		for (File file : list){
						 			// read the file, File contents in Json format
						 			String fileName=file.getName();
										out.println("<li data-id=\"" + fileName + "\"><span class='drag-handle'>&#9776;</span>" + fileName + "</li>");
									}
								%>
								</ul>
							</div>
		  				</div>
		  				<input type="hidden" id="scripsOrder" name="scripsOrder"/>
						<input type="hidden" id="wtd" name="wtd"/>
					</div>
				</div>
				
				<div class="row">
					<div class="col-sm-7"></div>
					<div class="col-sm-5">
						<div class="praat-group">
							<div id="errorMessage" style="color: #FF0000;">${errorMessage}</div>
		  					<input type="button" class="btn btn-textgrid btn-lg" onClick=" if(checkAll())run();" value="Run" />
		  				</div>
	  				</div>
				</div>
			</form>
		</div>
	</div>
	
	<script src="${pageContext.servletContext.contextPath}/resources/core/js/Sortable.js"></script>
	<script src="${pageContext.servletContext.contextPath}/resources/core/js/modules.js"></script>
	
</body>
</html>