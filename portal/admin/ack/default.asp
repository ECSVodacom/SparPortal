<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="includes/constants.asp"-->
<!--#include file="includes/setuserdetails.asp"-->
<!--#include file="includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 8 July 2002
	' Pupose: This is the default login page for webaccess.
	' Basic Logic Flow:
	
										' Declare the variables
										dim SQL				' SQL Statement
										dim curConnection	' Connection Object
										dim ReturnSet		' Recordset
										dim ErrorMsg		' Errormessage

										' Set the body onload variable
										Preloader = "document.LoginForm.txtUserName.focus();"
										
										PageTitle = "Login Page"
										
										' Check if the user selected to submit the form
										if Request.Form("hidAction") = "1" Then
											' Create a connection

											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString

											' Create the SQL Statement
											SQL = "exec procAdminLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
												", @Password=" & MakeSQLText(Request.Form("txtPassword"))

											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
												
											' Check if there are a record returned
											if ReturnSet("returnvalue") <> 0 Then
												' No record return - Error occured
												ErrorMsg = ReturnSet("errormessage")
												
												' Close the returnset and connection
												Set Returnset = Nothing
												curConnection.Close
												Set curConnection = Nothing
											else
												' No error occured - Continue with the login process	
												' Set the User Details
												Call SetUserDetails (ReturnSet("UserID"), Request.Form("txtUserName"), ReturnSet("FirstName"), ReturnSet("Surname"), ReturnSet("UserMail"), ReturnSet("Permission"))
												
												' Close the returnset and connection
												Set Returnset = Nothing
												curConnection.Close
												Set curConnection = Nothing

												' Check if there was a urlafter supplied
												if Request.Form("urlafter") <> "" Then
													' redirect the user to the last url he was at
													Response.Redirect Request.Form("urlafter")
												else											
													Response.Redirect const_app_ApplicationRoot & "/menu.asp"
												end if
											end if
										end if
%>
<!--#include file="layout/start.asp"-->
<!--#include file="layout/title.asp"-->
<!--#include file="layout/headstart.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user supplied a username
		if (obj.txtUserName.value=='') {
			window.alert ('Please enter a username.');
			obj.txtUserName.focus();
			return false;
		};
		
		// Check if the user supplied a password
		if (obj.txtPassword.value=='') {
			window.alert ('Please enter a password.');
			obj.txtPassword.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="layout/globaljavascript.asp"-->
<!--#include file="layout/headclose.asp"-->
<!--#include file="layout/bodystart.asp"-->
<form name="LoginForm" id="LoginForm" method="post" action="default.asp?urlafter=<%=Request.QueryString("urlafter")%>" onsubmit="return validate(this);">
<p class="pheader">Ackermans - Administration</p>
<hr>
<table border="0" cellpadding="2" cellspacing="2">
<%
											' Check if there was a login error
											if ErrorMsg <> "" THen
												' A login error occured - display the error message
%>
				<tr>
					<td class="errortext" colspan="3" wrap="virtual"><%=ErrorMsg%></td>
				</tr>
<%										
											end if
										
											' Check if there was another login error
											if Request.QueryString("errorcode") = "1" Then
												' Display the error message
%>
				<tr>
					<td class="errortext" colspan="3">You are trying to access this application without a successful login. Please enter your username and password below.</td>
				</tr>
<%											
											end if
%>			
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2" align="center">
				<tr>
					<td colspan="3" class="pcontent">Please enter your User Name and Password.<br><br></td>
				</tr>
				<tr>
					<td class="pcontent"><b>User Name:</b></td>
					<td><input type="text" name="txtUserName" id="txtUserName" size="20" maxlength="20"></td>
				</tr>
				<tr>
					<td class="pcontent"><b>Password:</b></td>
					<td><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="20"></td>
				</tr>  
				<tr>
					<td colspan="2"><br>
						<input type="submit" name="btnSubmit" id="btnSubmit" value="Log In" class="button">&nbsp;
						<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">&nbsp;
						<input type="hidden" name="hidAction" id="hidAction" value="1">&nbsp;
						<input type="hidden" name="urlafter" id="urlafter" value="<%=Request.QueryString("urlafter")%>">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<!--#include file="layout/end.asp"-->
