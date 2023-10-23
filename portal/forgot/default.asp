<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/sendmail.asp"-->
<%
	' Author & Date: Chris Kennedy, 25 Feb 2003
	' Pupose: This is the default forgot password page for Spar Drop shipment.
	' Basic Logic Flow:
	
										' Declare the variables
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorMessage
										dim SuccessMessage
										dim BodyText
										dim IntValue
										dim RndSet
										
										' Check if the user submitted the form
										if Request.Form("hidAction") = "1" Then
											' Build the SQL Statement
											SQL = "exec procForgotPassword @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
												", @EMail=" & MakeSQLText(Request.Form("txtMail"))
												
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")	
											curConnection.Open const_db_ConnectionString
											
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") = 0 Then
												Randomize
												
												IntValue = Int((32100 - 12300 + 1) * Rnd + 12300)

												' Build the SQL to update the password field for the selected user
												SQL = "editUserPassword @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @RndPassword=" & MakeSQLText(IntValue)
													
												' Execute the password
												Set RndSet =  ExecuteSql(SQL, curConnection)   
												
												' Check the returnvalue
												if RndSet("returnvalue") <> 0 then
													' Error occured
													ErrorMessage = ReturnSet("errormessage")
												else	
													SuccessMessage = "Your password has been send to you successfully."
													
													' Biuld the BodyText
													BodyText = BodyText & "Dear Spar User,"
													BodyText = BodyText & "<p>You  initiated a request to reset a password reset your password. The system has generated a new random password.</p>"
													BodyText = BodyText & "<p>Your new password is: <b>" & IntValue & "</b></p>"
													BodyText = BodyText & "<p>You will be required to change your password as soon as you log in with this password.</p>"
													BodyText = BodyText & "<p>Thank You</p>"
													BodyText = BodyText & "<p><i>NOTE: This is a system generated mail sent from Enterprise Cloud Services. Please do not reply.</i></p>"
													
													' Call the function SendCDOMail
													Call SendCDOMail (Request.Form("txtMail"), "spar@gatewaycomms.co.za", "Spar Drop Ship Forgot Password Notification", BodyText, 0)
												end if
												
												' Close the recordset
												Set RndSet = Nothing
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
<title>SPAR - Drop Shipment: Forgot Password</title>
<head>
<link rel="stylesheet" type="text/css" href="../layout/css/classes.css">
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user supplied a username
		if (obj.txtUserName.value=='') {
			window.alert ('Please enter a username.');
			obj.txtUserName.focus();
			return false;
		};
		
		// Validates e-Mail Address's
			var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
			var charpos = obj.txtMail.value.indexOf('@');
			// Ensure that Field Filled in
			if ((obj.txtMail.value=='')||
				(charpos==-1)||
				(obj.txtMail.value.indexOf('.', charpos)==-1)||
				(obj.txtMail.value.indexOf('@', charpos+1)!=-1)||
				(obj.txtMail.value[obj.txtMail.value.length-1]=='.')) {
				
				window.alert('Please enter a valid e-mail address.');
				obj.txtMail.focus();
				return false;
			};
			
			// Ensure that Illegal Characters not Entered
			if (obj.txtMail.value.search(TestExp)!=-1) {
				window.alert('Please enter a valid e-mail address.');
				obj.txtMail.focus();
				return false;
			};
	};
//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="" link="#FF0000" vlink="#FF0000" alink="#FF0000" text="#000000" onLoad="window.defaultStatus='Enter your User Name and E-Mail Address...';document.droplogin.txtUserName.focus();">
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
					<td colspan="2" valign="top"><font face="Arial" size="4" color="white"><b><u>Drop Shipment: Forgot Password</u></b></font><br><br></td>
					
				</tr>
				<tr>
					<td colspan="2" valign="top"><font face="Arial" size="4" color="white"><b>This page has been moved. Please contact Vodacom Helpdesk for assistance</b></font><br><br></td>
					
				</tr>
				<tr>
					<td colspan="2" valign="top"><font face="Arial" size="4" color="white"><b>TEL: 082 191</b></font><br><br></td>
					
				</tr>

				</form>
		</td>
	</tr>
</table>
</center>
</body>
