<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><%@page
	language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*" %>
<html>
<head>
<title>admin</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script type="text/javascript">
	function logoff(){
		document.forms[0].submit();
	}
</script>
</head>
<body>
	<div style="height: 30px;">
		<div style="float: right;">
			<form method="post" action="ibm_security_logout" name="logout">			
				<img src="../images/logout.png" height="35px;" style="cursor: pointer;" title="Logoff" onclick="logoff();"></img>
				<input type="hidden" name="logoutExitPage" value="../Login.html">
			</form>
		</div>
		<div style="float: right; margin-right: 15px;"><a href="../Index.html" title="Home"><img src="../images/home.png" height="35px;"></img></a></div>
	</div>
		
	<p style="text-align: center; font-size: 24px; margin-top: 30px; font-weight: bold; color: BLUE;">Welcome to common admin page</p>
	<h2>Remote user is: <%=request.getRemoteUser() %></h2>
	<h2>HTTP Request Headers Received</h2>
      <table border="1" cellpadding="4" cellspacing="0">
      <%
         Enumeration<String> eNames = request.getHeaderNames();
         while (eNames.hasMoreElements()) {
            String name = (String) eNames.nextElement();
            String value = normalize(request.getHeader(name));
      %>
         <tr><td><%= name %></td><td><%= value %></td></tr>
      <%
         }
      %>
      </table>

</body>
</html>
<%!
   private String normalize(String value)
   {
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < value.length(); i++) {
         char c = value.charAt(i);
         sb.append(c);
         if (c == ';')
            sb.append("<br>");
      }
      return sb.toString();
   }
%>