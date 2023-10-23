<%@ Language=VBScript %>
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
												
												' Set the user details to variables
												txtUserID = ReturnSet("UserID")
												txtFirstName = ReturnSet("FirstName")
												txtSurname = ReturnSet("Surname")
												txtSupplierMail = ReturnSet("SupplierEMail")
												txtBuyerMail = ""
												txtProcID = ReturnSet("ProcID")
												txtUserType = ReturnSet("UserType")
												txtPermission = ReturnSet("Permission")
												
												' Check if the buyer email address is not blank
												if not isNull(ReturnSet("BuyerEMail")) then
													' Build the Buyer Email address string
													Delimiter = ""
													While not ReturnSet.EOF
														txtBuyerMail = txtBuyerMail & Delimiter & ReturnSet("BuyerEMail")
														Delimiter = ";"
															
														ReturnSet.MoveNext
													Wend
												end if
												
												Call SetUserDetails (txtUserID, Request.Form("txtUserName"), txtFirstName, txtSurname, txtSupplierMail, txtBuyerMail, "", txtProcID, txtUserType, txtPermission, 0)
												' No error occured - Set the users details
												'Call SetUserDetails (txtUserID, Request.Form("txtUserName"), txtFirstName, txtSurname, txtSupplierMail, txtBuyerMail, "", txtProcID, txtUserType, txtPermission)
												
												' Set the Cookie - WebLogon
												Response.Cookies("WebLogon") = Request.Form("hidUserName")
												Response.Cookies("WebLogon").Expires = DateAdd("m",1,Date)
												
												' redirect the user to the urlafter page
												Response.Redirect Request.Form("urlafter")
											else
												' An error occured - Set the error message
												ErrorMessage = ReturnSet("errormessage")
											end if
											
											' Close the recordset and connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
										
										' Set the body onload variable
										Preloader = "document.ChangePassword.txtOldPassword.focus();"
										
										PageTitle = "Forgot Password"
%>
<html>
	<head>
		<title>Vodacom Business - SPAR Distribution Centre Sign In</title>
		<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/Afr_Style.css">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
		<script language="javascript">
		<!--
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
<body marginheight="0" onload="setFocus();" topmargin="0" vlink="#27408B" alink="#27408B" link="#27408B">
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td background="<%=const_app_ApplicationRoot%>/layout/images/bg0.gif" height="23">
				<table width="100%" cellspacing="0" cellpadding="0" border="0"> 
					<tr>
						<td width="10"><img src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7" /></td>
						<td><div class="banner"><b>Vodacom Business - SPAR DC Track & Trace // <font color="#FF6F2F" > Production server</font></b></div></td>
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
						<td class="tdtitle" valign="top"><img align="left" src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7">Change Password</td>
					</tr>
					<tr>
						<td>
							<br>
								<form method="post" action="changepassword.asp?urlafter=<%=Request.QueryString("urlafter")%>&id=<%=Request.QueryString("id")%>" name="form" onkeypress="getKey()" onsubmit="return validate(this);">
								<center>
								<table class="tableform" cellspacing="1" cellpadding="1" border="0">
									<tr>
										<td valign="middle" align="left" width="30%"></td>
										<td valign="middle" align="left" width="70%"><h3>Change Password </h3></td>
									</tr>
									<tr>
										<td><br><br></td>
									</tr>
<%
											' Check if there was a login error
											if ErrorMessage <> "" Then
												' A login error occured - display the error message
%>
									<tr>
										<td class="warning" colspan="3" wrap="virtual"><%=ErrorMessage%><br><br></td>
									</tr>
<%										
											end if
%>			
									<tr>
										<td colspan="2" class="text">Please enter your old Password and then your new Password in the form below.<br>
											<b>Note:</b> You will be automatically logged into the system, if your password has been successfully changed.<BR><BR>
										</td>
									</tr>
									<tr>
										<td class="tdformhdr">Old Password</td>
										<td class="tdforminput"><input class="text" type="password" name="txtOldPassword" size="25" maxlength="15"></td>
									</tr>
									<tr>
										<td class="tdformhdr">New Password</td>
										<td class="tdforminput"><input class="text" type="password" name="txtNewPassword" size="25" maxlength="15"></td>
									</tr>
									<tr>
										<td class="tdformhdr">Confirm New Password</td>
										<td class="tdforminput">
											<input class="text" type="password" name="txtConfirmNewPassword" size="25" maxlength="15">
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
																			<td align="center" valign="middle"><input type="submit" name="btnSubmit" id="btnSubmit" value="Sign in >>" class="button"></td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
													<td>
														[<a class="forgot" href="<%=const_app_ApplicationRoot%>/profile/default.asp">Forgot Password?</a>]
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2" align="center">Please contact the Vodacom Business Call Centre on <b>0821951</b> <br>should you encounter any problems.</td>
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
