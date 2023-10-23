<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/clearuserdetails.asp"-->
<%
	' Author & Date: Chris Kennedy, 21 June 2002
	' Purpose: This page will display the logout confirmation page. The user can select yes, then the system will direct him to
	'				the login page or else the user can select no and the system will direct him to the menu.asp page.
										
										PageTitle = "Log Off"
										
										' Check if the user posted a form
										if Request.Form("hidAction") <> "" Then
											' Determine if the user selected to log out of the system
											if Request.Form("hidAction") = "1" Then
												' Clear the userdetails
												Call ClearUserDetails()
												
												' Redirect the user to the login page
												Response.Redirect const_app_ApplicationRoot
											else
												' Redirect the user to the login page
												Response.Redirect const_app_ApplicationRoot & "/menu.asp"
											end if
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Log Off</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<p class="pcontent">Click on the "Yes" button to log you out of the system, or click on the "No" button to stop the logout.</p>
<form name="logoff" id="logoff" method="post" action="default.asp">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td><input type="submit" name="btnYes" id="btnYes" value="Yes" class="button" onclick="document.logoff.hidAction.value=1;"></td>
		<td><input type="submit" name="btnNo" id="btnNo" value="No  " class="button" onclick="document.logoff.hidAction.value=0;">
			<input type="hidden" name="hidAction" id="hidAction" value="0">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->