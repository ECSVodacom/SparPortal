<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css" type="text/css">
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10">
<p class="welcome" align="left" valign="middle"><img src="<%=const_app_ApplicationRoot%>/layout/images/logout.gif" border="0">&nbsp;<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) self.parent.location.href='<%=const_app_ApplicationRoot%>/logout/';">Logout</a></p>
<!--#include file="../../layout/end.asp"-->
