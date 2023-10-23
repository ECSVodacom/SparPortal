<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/clearuserdetails.asp"-->
<%
	' Author & Date: Chris Kennedy, 21 June 2002; Amended by Hannes Kingsley, 5 September 2005
	' Purpose: This page will display the logout confirmation page. The user can select yes, then the system will direct him to
	'				the login page or else the user can select to delete his login and the application will close.
										
										PageTitle = "Log Off"
										
										' Check if the user posted a form
										if Request.Form("hidAction") <> "" Then
											' Determine if the user selected to log out of the system
											if Request.Form("hidAction") = "1" Then
											
											
											if Request.Form("chkBoxCookie") = "checked" or Request.Form("chkBoxCookie") = "on" then
												Response.Cookies("PortalLogin").Expires=#August 10,2005#
														
												' Clear the userdetails
												Call ClearUserDetails()
												
												
%>												<script language="javascript">
												<!--
													top.location.href = '<%=const_app_ApplicationRoot%>';
												//-->
												</script>
<%												
											else
%>												
												<script language="javascript">
												<!--
													parent.close()
												//-->
												</script>
<%													
											end if	
										  end if
											
										end if
										
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->

<p class="bheader">Log Out</p>
<table border="0" cellspacing="2" cellpadding="2" width="100%">
	<tr>
		<td class="pcontent">Click on the <b>Yes</b> button to log you out of the system, <b>OR</b> <br>Click on the <b>No</b> button to stop the logout and return you to your inbox.</td>
	</tr>
</table>
<form name="logoff" id="logoff" method="post" action="default.asp">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td><input type="submit" name="btnYes" id="btnYes" value="Yes" class="button" onclick="document.logoff.hidAction.value=1;"></td>
		<!--<td><input type="submit" name="btnNo" id="btnNo" value="No  " class="button" onclick="document.logoff.hidAction.value=0;">-->
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		
	<%	
								' Check if the user selected to login
								If Request.Cookies("PortalLogin") <> "" Then	
	%>	
		<td class="pcontent"><input type="checkbox" id="chkBoxCookie" name="chkBoxCookie" class="pcontent">&nbsp;<b>Delete login</b></td>
	<%
								end if
	%>	
		<input type="hidden" name="hidAction" id="hidAction" value="0">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->