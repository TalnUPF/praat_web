<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<%@ page import="java.util.HashMap" %>
	<%@ page import="java.util.List" %>
	<%@ page import="edu.upf.taln.praat_web.classes.FileFormInfo" %>
	<%@ page import="edu.upf.taln.praat_web.classes.ScriptInfo" %>
	<%@ page import="java.util.Map.Entry" %>
	<%@page import ="java.io.FileNotFoundException" %>
	<%@page import ="java.io.FileReader" %>
	<%@page import ="java.io.IOException" %>
	<%@page import ="java.util.Iterator" %> 
	<%@page import ="java.io.File" %>
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<link href="${pageContext.servletContext.contextPath}/resources/core/css/forms.css" rel="stylesheet" type="text/css"/>
	<link href="${pageContext.servletContext.contextPath}/resources/core/css/general.css" rel="stylesheet" type="text/css"/>
	<% 
	String name = (String)request.getAttribute("name");
	%>
	<title><%=name%></title>
</head>
<body>

	<%
	String description = (String)request.getAttribute("description"); 
	String demo = (String)request.getAttribute("demo");
	%>
	<div class="container">
		<div class="page-header">
		    <h1 class="left"><%=name%></h1>
		     <a href="${pageContext.servletContext.contextPath}/" class="right back">Back to Menu <span class="glyphicon glyphicon-hand-left"></span></a>
		</div>
		<div class="page-subheader">
		    <h3 class="left">
		    	<%=description%>
		    </h3>
		</div>
		<div class="form" id="formDiv">
			<form action="General" method="post" enctype="multipart/form-data" id="runForm">
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
								 		List<File> audios = (List<File>)request.getAttribute("audios");  
								 		for (File audio : audios){
								   			%>
								   			<option value="<%=audio.getAbsolutePath()%>"><%=audio.getName()%></option>
								   			<%
										}
							 		%>
								</select>
							</div>
						</div>
						<%
						Boolean useTextgrids = (Boolean)request.getAttribute("useTextgrids");  
						if(useTextgrids){
						%>
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
								 		List<File> textGrids = (List<File>)request.getAttribute("textgrids");  
								 		for (File textGrid : textGrids){
									   		%>
									   		<option value = "<%=textGrid.getAbsolutePath()%>"><%=textGrid.getName()%></option>
									   		<%
										}
							 		%>
									</select>
				  				</div>
				  			</div>
						</div>
						<%
						}
						Boolean useTexts = (Boolean)request.getAttribute("useTexts");  
						if(useTexts){
						%>
						<div  id="textDiv">
							<div class="praat-group">
				  				<div class="related-praat-group">
									<label for="textFile">Upload your Text file or select a sample file: </label> 
									<input type="file" id="textFile" name="textFile" size="50" class="fileInput"/>
				  				</div>
				  				<div >
								 	<select class="form-control" id="textSel" name="textSelection">
								 		<option value="" selected="selected">Select an option</option>
								 		<%
								 		List<File> texts = (List<File>)request.getAttribute("texts");  
								 		for (File text : texts){
									   		%>
									   		<option value = "<%=text.getAbsolutePath()%>"><%=text.getName()%></option>
									   		<%
										}
							 		%>
									</select>
				  				</div>
				  			</div>
						</div>
						<%
						}
						%>
				
					</div>
					<div class="col-sm-2"></div>
	  				<div class="col-sm-5">
	  					<div class="praat-group">
			  				<div data-force="30" class="layer block" style="width: 100%;">
								<div class="layer title">Selected modules</div>
								<ul id="selected" class="block__list block__list_words">
								<%
						 		String scriptsFolder = (String)request.getAttribute("scriptsFolder"); 
								List<ScriptInfo> scriptsInfo = (List<ScriptInfo>)request.getAttribute("scriptsInfo"); 
								int i = 0;
						 		for (ScriptInfo script : scriptsInfo){
						 			if(script.getDefaultSort() != null){
						 				File scriptFile = new File(scriptsFolder + "/" + script.getFile());
						 				%>
										<li data-id="<%=scriptFile.getAbsolutePath()%>"> <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=i%>"><span class='drag-handle'>&#9776;</span></a><%=script.getDescription()%>
											<div id="collapse<%=i%>" class="panel-collapse collapse out"><span>Parameters list:</span><input name="params" type="text" value="<%=script.getParams()!=null?script.getParams():""%>"></div>
										</li>
										<%
						 			}
									i++;
								}
								%>
								</ul>
							</div>
	  					</div>
		  				<div class="praat-group">
		  					<div data-force="18" class="layer block" style="width: 100%;">
								<div class="layer title">Available modules</div>
								<ul id="available" class="block__list block__list_words">
								<%
								i = 0;
						 		for (ScriptInfo script : scriptsInfo){
						 			if(script.getDefaultSort() == null){
						 				File scriptFile = new File(scriptsFolder + "/" + script.getFile());
						 				%>
										<li data-id="<%=scriptFile.getAbsolutePath()%>"> <a data-toggle="collapse" data-parent="#accordion" href="#collapse<%=i%>"><span class='drag-handle'>&#9776;</span></a><%=script.getDescription()%>
											<div id="collapse<%=i%>" class="panel-collapse collapse out"><span>Parameters list:</span><input name="params" type="text" value="<%=script.getParams()!=null?script.getParams():""%>"></div>
										</li>
										<%
						 			}
									i++;
								}
								%>
								</ul>
							</div>
		  				</div>
		  				<input type="hidden" id="scriptsOrder" name="scriptsOrder"/>
		  				<input type="hidden" id="scriptsParams" name="scriptsParams"/>
						<input type="hidden" id="wtd" name="wtd"/>
					</div>
				</div>
				
				<input type="hidden" name="demo" value="<%=demo%>"/>
				
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
	<script src="${pageContext.servletContext.contextPath}/resources/core/js/general.js"></script>
	
</body>
</html>