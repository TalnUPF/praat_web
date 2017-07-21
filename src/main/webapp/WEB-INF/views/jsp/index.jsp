<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*"%>
<%@page import ="java.util.Iterator" %> 
<%@page import ="edu.upf.taln.praat_web.classes.DemoData" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<link href="${pageContext.servletContext.contextPath}/resources/core/css/index.css" rel="stylesheet" type="text/css"/>
	<link href="${pageContext.servletContext.contextPath}/resources/core/css/general.css" rel="stylesheet" type="text/css"/>
<title>Praat on the Web Demo</title>
</head>
<body>
	<div class="container">
	  <div class="page-header">
	  	<h1 class="left big">Praat on the Web Demo</h1>
	  	<img src="${pageContext.servletContext.contextPath}/resources/core/images/TALN.png" class="logo"/>
	  </div>
	  <div class="page-subheader">
		<h3 class="left">This website demonstrates two Praat on the Web functionalities: web visualization (demo 1) and modular scripting using features (demo 2). Two further demos on feature annotation are available for merging tiers as feature vectors (demo 3) and splitting features into tiers (demo 4).<br/>To access each demo, click on the Enter Demo button.</h3>
	  </div>
		
	<%
	List<DemoData> demos = (List<DemoData>)request.getAttribute("demos");
	for (DemoData demo : demos){

	%>
	  <div class="jumbotron">
	    <div class="left-content">
		    <h2><%=demo.getMenuName()%></h2>
		    <p><%=demo.getMenuDescription()%></p>
		    <form action="GeneralForm" method="post" enctype="multipart/form-data" id="runForm">
		    	<input type="hidden" name="demo" value="<%=demo.getFilePath()%>"/>
		    	<button type="submit" class="btn btn-textgrid btn-lg">Enter <%=demo.getMenuName()%></button>
	    	</form>
	    </div>
	    <div class="right-content">
	    	<img src="${pageContext.servletContext.contextPath}/resources/core/images/praat_on_the_web.png" class="thumbnail"/>
	    </div>
	  </div>
	<%
	}
	%>

	</div>

</body>
</html>