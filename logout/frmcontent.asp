<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/clearuserdetails.asp"-->
<%
										' Reset the Session variables
										Call ClearUserDetails ()
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css" type="text/css">
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<p class="bheader" align="left">Log out</p>
<table border="0" cellspacing="2" cellpadding="2" width="80%" align="left">
	<tr>
		<td class="pcontent" align="left">You have been successfully logged out.</td>
		<td class="pcontent" align="right" valign="middle"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif" border="0"><br><br></td>
	</tr>
	<tr>
		<td class="pcontent" align="left">Thank you for using the SPAR Portal facility.<br><br></td>
	</tr>
	<tr>
		<td class="pcontent" align="left"><b>We recommend that for your own security you close the Internet Browser window, before leaving your personal computer.</b></td>
	</tr>
	<tr>
		<td align="center"><br><input type="button" name="btnClose" id="btnClose" value="  Exit  " class="button" onclick="javascript:top.window.close();"></td>
	</tr>
</table>
<!--#include file="../layout/end.asp"-->
