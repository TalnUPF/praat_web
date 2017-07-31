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
		<h3 class="left">This website demonstrates two Praat on the Web functionalities: web visualization and modular scripting using features. The modular scripting functionality is exemplified as a prosody tagger that predicts prosodic phrases and prominence from audio with and without word alignment. Two further demos on feature annotation are available for merging tiers as feature vectors and splitting features into tiers.<br/>To access each demo, click on the Enter button.</h3>
		<h4>Citation:
		<br/>
		If you this webpage or any of the tools included, please cite the following paper:<br/>
		 [1] Domínguez, M., Latorre, I., Farrús, M., Codina, J., and Wanner, L. (2016). Praat on the Web: An upgrade of Praat for semiautomatic speech annotation. In Proceedings of COLING 2016, the 26th International Conference on Computational Linguistics: System Demonstrations. Osaka, Japan, pages 218–222.<br/>
		If you use any of the modular scripting demos, you must cite paper [1] and also the following paper:<br/>
		 [2] Domínguez, M., Farrús, M., and Wanner, L. (2016). An automatic prosody tagger for spontaneous speech. In Proceedings of COLING 2016, the 26th International Conference on Computational Linguistics. Osaka, Japan, pages 377–387.</h4>
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
		    	<button type="submit" class="btn btn-textgrid btn-lg">Enter <%=demo.getButton()%></button>
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