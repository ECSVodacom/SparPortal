<%@ Language=VBScript %>
<% 
		For Each Item In Session.Contents 
			
			If IsNumeric(Session(Item)) Then
				Session(Item) = 0
			Else
				Session(Item) = ""
			End If
			
		Next 

		For Each Cookie In Response.Cookies 
		
			Response.Cookies(Cookie) = "" 
			Response.Cookies(Cookie).Expires = date() -1 ' DateAdd("d",-1,now()) 
			
		Next
		
		Response.CacheControl = "no-cache"
		Response.AddHeader "Pragma", "no-cache"
		Response.Expires = -1
		Response.Cookies("DSLogin").Expires = date() -1 'DateAdd("m",-1,now())
		
		
%>

<!--#include file="../includes/constants.asp"-->
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css" type="text/css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<p class="bheader" align="left">Log out</p>
<table border="0" cellspacing="2" cellpadding="2" width="80%" align="left">
	<tr>
		<td class="pcontent" align="left">You have been successfully logged out.</td>
		<td class="pcontent" align="right" valign="middle"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif" border="0"><br><br></td>
	</tr>
	<tr>
		<td class="pcontent" align="left">Thank you for using the SPAR Drop Shipment Track and Trace facility.<br><br></td>
	</tr>
	<tr>
		<td class="pcontent" align="left"><b>We recommend that for your own security you close the Internet Browser window, before leaving your personal computer.</b></td>
	</tr>
	<tr>
		<td align="center"><br><input type="button" name="btnClose" id="btnClose" value="  Exit  " class="button" onclick="javascript:top.window.close();"></td>
	</tr>
</table>

