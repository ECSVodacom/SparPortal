<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
	' Author & Date: Chris Kennedy, 8 July 2002
	' Pupose: This is the change password page.
	' Basic Logic Flow:
	
										' Declare the variables
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorMessage
										dim txtUserID
										dim txtFirstName
										dim txtSurname
										dim txtBuyerMail
										dim txtSupplierMail
										dim txtProcID
										dim txtUserType
										dim txtPermission
										dim Delimiter
										dim ErrorFlag
										
										' Check if the user submitted the form
										if Request.Form("hidAction") = "1" Then
											' Build the SQL Statement
											SQL = "exec procChangePassword @UserName=" & MakeSQLText(Request.Form("hidUserName")) & _
												", @OldPassword=" & MakeSQLText(Request.Form("txtOldPassword")) & _
												", @NewPassword=" & MakeSQLText(Request.Form("txtNewPassword"))
												
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")	
											curConnection.Open const_db_ConnectionString
											
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") = 0 Then

												' No error occured - Set the users details
												'Call SetUserDetails (txtUserID, Request.Form("txtUserName"), txtFirstName, txtSurname, txtSupplierMail, txtBuyerMail, "", txtProcID, txtUserType, txtPermission)
												
												Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("FirstName"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("PhysAddress"), ReturnSet("ProcID"), ReturnSet("ProcEAN"), ReturnSet("ProcName"))
												
												' Set the Cookie - WebLogon
												Response.Cookies("DSLogin") = Request.Form("hidUserName")
												Response.Cookies("DSLogin").Expires = DateAdd("m",1,Date)
												
												' redirect the user to the track and trace default page
												Response.Redirect const_app_ApplicationRoot & "/track/"
											else
												' An error occured - Set the error message
												ErrorMessage = ReturnSet("errormessage")
											end if
											
											' Close the recordset and connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<html>
<title>SPAR - Drop Shipment: Change Password</title>
<head>
<link rel="stylesheet" type="text/css" href="../layout/css/classes.css">
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user entered his old password
		if (obj.txtOldPassword.value=='') {
			window.alert ('Please enter your old password.');
			obj.txtOldPassword.focus();
			return false;
		};
		
		// Check if a new password was supplied
		if (obj.txtNewPassword.value=='') {
			window.alert ('Please enter your new password.');
			obj.txtNewPassword.focus();
			return false;
		};
		
		// Check if the new password = old password
		if (obj.txtNewPassword.value == obj.txtOldPassword.value) {
			window.alert ('Your new password may not be the same as your old password. Please choose another password.');
			obj.txtNewPassword.focus();
			return false;
		};
		
		// Check if the confirm password is the same as the new password
		if (obj.txtNewPassword.value != obj.txtConfirmNewPassword.value) {
			window.alert ('Your confirm new password is not the same as your new password. Please check the spelling.');
			obj.txtConfirmNewPassword.focus();
			return false;
		};
	};
//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="" link="#FF0000" vlink="#FF0000" alink="#FF0000" text="#000000" onLoad="window.defaultStatus='Enter your Old and New Password and Confirm your new password...';document.droplogin.txtOldPassword.focus();">
<br><br><br><br><center>
<table border="0" cellpadding="2" cellspacing="2" bgcolor="#666699" width="40%">
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td><a target="_blank" href="http://www.gatewaycomms.co.za"><img src="<%=const_app_ApplicationRoot%>/layout/images/back.gif" border="0" alt="Visit out web site..."></a></td>
				</tr>
			</table>
		</td>
		<td align="left">
		<form name="droplogin" id="droplogin" method="post" action="default.asp" onsubmit="return validate(this);">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td colspan="2" valign="top"><font face="Arial" size="5" color="white"><b><u>Drop Shipment: Change Password</u></b></font><br><br></td>
				</tr>
<%
										' Check if there was errors
										if ErrorMessage <> "" Then
											' Display the error
%>
				<tr>
					<td colspan="2"><font face="Arial" size="1" color="red"><b><%=ErrorMessage%></b><br></font></td>
				</tr>
<%											
										end if
%>				
				<tr>
					<td><font face="Arial" size="2" color="white"><b>Old Password</b></font></td>
					<td><input type="password" name="txtOldPassword" id="txtOldPassword" size="20" maxlength="20"></td>
				</tr>
				<tr>
					<td><font face="Arial" size="2" color="white"><b>New Password</b></font></td>
					<td><input type="password" name="txtNewPassword" id="txtNewPassword" size="20" maxlength="50"></td>
				</tr>  
				<tr>
					<td><font face="Arial" size="2" color="white"><b>Confirm New Password</b></font></td>
					<td><input type="password" name="txtConfirmNewPassword" id="txtConfirmNewPassword" size="20" maxlength="50"></td>
				</tr> 
				<tr>
					<td colspan="2"><br>
						<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
						<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
						<input type="hidden" name="hidAction" id="hidAction" value="1">
						<input type="hidden" name="hidUserName" id="hidUserName" value="<%=Request.QueryString("id")%>">
						<input type="hidden" name="urlafter" id="urlafter" value="<%=Request.QueryString("urlafter")%>">
					</td>
				</tr>
			</table>
		</form>
		</td>
	</tr>
</table>
</center>
</body>
