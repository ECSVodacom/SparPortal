<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the User is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/password/default.asp")
										
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										
										PageTitle = "Password Look_up"										
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user entered a user name
		if (obj.txtUserName.value=='') {
			window.alert ('Please enter a User Name.');
			obj.txtUserName.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Password Look-Up</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<%
										if Request.Form("hidAction") = "1" Then
											' Build the SQL 
											SQL = "exec procPassword @UserName=" & MakeSQLText(Request.Form("txtUserName"))
										

							
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
																					
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<p class="pheader">Results</p>
<%											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Display the error message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<hr>
<%
											else
%>
<p class="pcontent">The password for <b><%=Request.Form("txtUserName")%></b> is <b><%=ReturnSet("UserPassword")%></b>.</p>
<hr>
<%												
											end if
											
											' Close the recordset and connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<p class="pheader">Search</p>
<p class="pcontent">Enter the User Name into the field below and click on the <b>search</b> button.</p>
<form name="PwdSearch" id="PwdSearch" method="post" action="default.asp" onsubmit="return validate(this);">
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td class="pcontent" align="left"><b>User Name:</b></td>
		<td class="pcontent"><input type="text" name="txtUserName" id="txtUserName"></td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="submit" name="btnSearch" id="btnSearch" value="Search" class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->

