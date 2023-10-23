<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/sendmail.asp"-->
<!--#include file="../includes/generatepassword.asp"-->
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
										'Response.Write CommandText
										' Check if the user submitted the form
										if Request.Form("hidAction") = "1" Then
											' Build the SQL Statement
											SQL = "exec procForgotPassword @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
												", @EMail=" & MakeSQLText(Request.Form("txtMail"))
											
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")	
											curConnection.Open const_db_ConnectionString
											'response.write SQL	
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") = 0 Then
												Randomize
												
												IntValue = GeneratePassword() 'Int((32100 - 12300 + 1) * Rnd + 12300)

												' Build the SQL to update the password field for the selected user
												SQL = "editUserPassword @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @RndPassword=" & MakeSQLText(IntValue)
												'response.write SQL
												
												' Execute the password
												Set RndSet = ExecuteSql(SQL, curConnection)
												
												' Check the returnvalue
												if RndSet("returnvalue") <> 0 then
													' Error occured
													ErrorMessage = ReturnSet("errormessage")
												else	
													SuccessMessage = "Your password has been send to you successfully."
													
													' Biuld the BodyText
													'BodyText = BodyText & "Dear Spar Drop Shipment User" & "<br><br>"
													'BodyText = BodyText & "This is an electronic e-mail send from Gateway Communications. You forgot your password and the system has generated a new random password." & "<br>"
													'BodyText = BodyText & "Your new password is: <b>" & IntValue & "</b><br>"
													'BodyText = BodyText & "You will be required to change your password as soon as you log in with this password." & "<br><br>"
													'BodyText = BodyText & "Thank You"
													
													
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
	<head>
		<title>SPAR - Drop Shipment: Forgot Password</title>
		<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/Afr_Style.css">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
	
		<script language="javascript">

			var isNav = (navigator.appName.indexOf("Netscape") != -1);
			
			function setFocus() {
				if(document.forms[0][0] != null) 
				document.forms[0][0].focus(); 
			}

			if(isNav)
			{
			   document.captureEvents(Event.KEYPRESS);
			   document.onkeypress = getKey;
			}
			function getKey(keyStroke)
			{
			   key = (isNav) ? keyStroke.which : event.keyCode;
			   if(key == "13"){
			     document.form.submit();
			   }
			}
			
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
		</script>
	</head>

	<body marginheight="0" onload="setFocus();" topmargin="0" vlink="#27408B" alink="#27408B" link="#27408B">
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td background="<%=const_app_ApplicationRoot%>/layout/images/bg0.gif" height="23">
				<table width="100%" cellspacing="0" cellpadding="0" border="0"> 
					<tr>
						<td width="10"><img src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7" /></td>
						<td><div class="banner"><b>Vodacom Business - SPAR Dropshipment: Track & Trace // <font color="#FF6F2F" > Staging Server</font></b></div></td>
						<td align="right" width="20"><img src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" width="6" height="10" hspace="7" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<br />
	<p align=right></p>
	<center>	
	<BR><BR><BR><BR>
	<table border="0" width="100%">
		<tr>
			<td width="100" align="center"></td>
			<td>
				<table class="tablewindow" align="center" cellspacing="0" cellpadding="10" border="0" width="45%">
					<tr>
						<td class="tdtitle" valign="top"><img align="left" src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7">Forgot Password</td>
					</tr>
					<tr>
						<td>
							<br>
							<form method="post" action="default.asp" name="form" onkeypress="getKey()" onsubmit="return validate(this);">
								<center>
								<table class="tableform" cellspacing="1" cellpadding="1" border="0">
									<tr>
										<td valign="middle" align="left" width="30%">&nbsp;</td>
										<td valign="middle" align="left" width="70%"><h3>Forgot Password</h3></td>
									</tr>
									<tr>
										<td><br><br></td>
									</tr>
<%
											' Check if there was an error
											if ErrorMessage <> "" Then
												' Display the error message
%>
									<tr>
										<td class="warning" colspan="3" wrap="virtual"><%=ErrorMessage%><br><br></td>
									</tr>
<%										
											end if
											
											' Check if the password was send successfully
											if SuccessMessage <> "" Then
												' Display the message
%>		
									<tr>
										<td class="warning" colspan="3" wrap="virtual"><%=SuccessMessage%><br><br></td>
									</tr>
<%										
											end if
										
										if Request.Form("hidAction") <> "1" Then
%>		
									<tr>
										<td class="text" colspan="3" wrap="virtual">Please enter your User Name and E-Mail Address and we will send your Password.<br><br></td>
									</tr>
<%
										end if
%>																
									<tr>
										<td class="tdformhdr">Username</td>
										<td class="tdforminput"><input class="text" type="text" name="txtUserName" size="25" maxlength="15"></td>
									</tr>
									<tr>
										<td class="tdformhdr">E-Mail Addesss</td>
										<td class="tdforminput">
											<input class="text" type="text" name="txtMail" id = "txtMail" size="25" maxlength="200">
											<input type="hidden" name="hidAction" id="hidAction" value="1">
											<input type="hidden" name="hidUserName" id="hidUserName" value="<%=Request.QueryString("id")%>">
											<input type="hidden" name="urlafter" id="urlafter" value="<%=Request.QueryString("urlafter")%>">
										</td>
									</tr>
								</table>
								<br>
								<table width="100%" border="0" cellspacing="2">
									<tr>
										<td>&nbsp;</td>
										<td align=center>
											<table align="center" border="0" cellspacing="2" cellpadding="2">
												<tr>
													<td>
														<table align="center" width="130" height="24" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td>
																	<table height="100%" width="100%" border="0" cellspacing="2" cellpadding="2">
																		<tr>
																			<td align="center" valign="middle"><input type="submit" name="btnSubmit" id="btnSubmit" value="Send >>" class="button"></td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2" align="center">Please contact the Vodacom Call Centre on <b>0821951</b> <br>should you encounter any problems.</td>
									</tr>			
								</table>
							</form>
						</td>
					</tr>
				</table>
			</td>
			<td width=80 align="center"></td>
		</tr>
	</table>
	</center>
	</body>
</html>
