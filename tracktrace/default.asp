<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 8 July 2002
	' Pupose: This is the default login page for track and trace.
	' Basic Logic Flow:
	
	
	
	
										' Declare the variables
										dim SQL				' SQL Statement
										dim curConnection	' Connection Object
										dim ReturnSet		' Recordset
										dim ErrorMsg		' Errormessage
										dim CreateCookie	' Flag
										dim UserType		' The Type of User
										dim ChangePwd
										dim Preloader
										dim PageTitle
										
									
										
										
										' Set the body onload variable
										Preloader = "document.LoginForm.txtUserName.focus();"
										
										PageTitle = "Track and Trace Login Page"

										' Check if the user selected to submit the form
										if Request.Form("hidAction") = "1" or Request.Cookies("WebLogon") <> "" Then
											' Create a connection

											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Set the default flag value
											CreateCookie = False
										
										
											' Determine if the user has a cookie registered on his machine
											if Request.Cookies("WebLogon") = "" or isNull(Request.Cookies("WebLogon")) Then
												' The user does not have a cookie registered on his machine
												
												' Check if Unilever is logging in
												if Request.Form("txtUserName") = "6001085000002" or Request.Form("txtUserName") = "6001087000017" or Request.Form("txtUserName") = "6001081000013" Then
													CreateCookie = False
												else
													CreateCookie = True
												end if
												
												' Create the SQL Statement
												SQL = "exec procLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @Password=" & MakeSQLText(Request.Form("txtPassword"))
												
											else
												' Check if Unilever is logging in
												if Request.Form("txtUserName") = "6001085000002" or Request.Form("txtUserName") = "6001087000017" or Request.Form("txtUserName") = "6001081000013" Then
													' Set the default flag value
													CreateCookie = False
													
													' Call the sp - procLogin
													' Create the SQL Statement
													SQL = "exec procLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
														", @Password=" & MakeSQLText(Request.Form("txtPassword"))
												else
													' The cookie exist. Get the cookie
													SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("WebLogon"))				
												end if
											end if
											
											
		
										
									
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
												' Set the User Details
												ChangePwd = ReturnSet("ChangePwd")
												
												' No error occured - Continue with the login process	
												' Check if the user need to change the password
												if ChangePwd = 1 Then
													' Check the UserType
													if ReturnSet("UserType") = 1 Then
														' This is a buyer
														' Redirect him to the change password page
														Response.Redirect const_app_ApplicationRoot & "/profile/changepassword.asp?id=" & ReturnSet("UserName") & "&urlafter=" & const_app_ApplicationRoot & "/tracktrace/buyer/default.asp"
													else
														' This is a buyer
														' Redirect him to the change password page
														Response.Redirect const_app_ApplicationRoot & "/profile/changepassword.asp?id=" & ReturnSet("UserName") & "&urlafter=" & const_app_ApplicationRoot & "/tracktrace/supplier/default.asp"
													end if	
												else
													' Set the User Details
													Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("FirstName"), ReturnSet("Surname"), ReturnSet("SupplierEMail"), ReturnSet("BuyerEMail"), "", ReturnSet("ProcID"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("DCId"))
													
													
													' Check if the system should create the cookie
													if CreateCookie Then
														' Set the Cookie - WebLogon
														Response.Cookies("WebLogon") = Request.Form("txtUserName")
														Response.Cookies("WebLogon").Expires = DateAdd("m",1,Date)
													end if
												
													' Check the UserType
													if ReturnSet("UserType") = 1 Then
														' This is a buyer
														UserType = 1
													else
														UserType = 2
													end if
												
													' Close the returnset and connection
													Set Returnset = Nothing
													curConnection.Close
													Set curConnection = Nothing
												
													' Check if there was a urlafter supplied
													if Request.Form("urlafter") <> "" Then
														' redirect the user to the last url he was at
														Response.Redirect Request.Form("urlafter")
													else											
														' Check what the UserType is
														if UserType = 1 Then
															' This is a buyer - redirect to buyer default page
															Response.Redirect const_app_ApplicationRoot & "/tracktrace/buyer/default.asp"
														else
															' This is a supplier - Redirect to the supplier default page
															Response.Redirect const_app_ApplicationRoot & "/tracktrace/supplier/default.asp"
														end if
													end if
												end if
											end if
										end if
%>
<html>
	<head>
		<title>Vodacom Business - SPAR Distribution Centre Sign In</title>
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
				if (obj.txtUserName.value=='') {
					window.alert ('Enter your User Name into the User Name field.');
					obj.txtUserName.focus();
					return false;
				};
				
				if (obj.txtPassword.value=='') {
					window.alert ('Enter your Password into the Password field.');
					obj.txtPassword.focus();
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
						<td><div class="banner"><b>Vodacom Business - SPAR DC Track & Trace // <font color="#FF6F2F" > Production Server</font></b></div></td>
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
						<td class="tdtitle" valign="top"><img align="left" src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7">Login</td>
					</tr>
					<tr>
						<td>
							<br>
							<form method="post" action="default.asp" name="form" onkeypress="getKey()" onsubmit="return validate(this);">
								<center>
								<table class="tableform" cellspacing="1" cellpadding="1" border="0">
									<tr>
										<td>&nbsp;</td>
										<!--td valign="middle" align="left" width="30%"><img src="<%=const_app_ApplicationRoot%>/layout/images/newgatelogo.gif" border="0"></td>-->
										<td valign="middle" align="left" width="70%"><h3>Welcome to DC Login </h3></td>
									</tr>
									<tr>
										<td><br><br></td>
									</tr>
<%
											' Check if there was a login error
											if ErrorMsg <> "" Then
												' A login error occured - display the error message
%>
									<tr>
										<td class="warning" colspan="3" wrap="virtual"><%=ErrorMsg%><br><br></td>
									</tr>
<%										
											end if
											
											' Check if there was another login error
											if Request.QueryString("errorcode") = "1" Then
												' Display the error message
%>
									<tr>
										<td class="warning" colspan="3">You are trying to access this application without a successful login. Please enter your username and password below.</td>
									</tr>
<%											
											end if
%>			
									<tr>
										<td class="tdformhdr">Username</td>
										<td class="tdforminput"><input class="text" type="text" name="txtUserName" size="25" maxlength="15"></td>
									</tr>
									<tr>
										<td class="tdformhdr">Password</td>
										<td class="tdforminput">
											<input class="text" type="password" name="txtPassword" size="25" maxlength="25">
											<input type="hidden" name="hidAction" id="hidAction" value="1">
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
														<a class="forgot" href="<%=const_app_ApplicationRoot%>/profile/default.asp">Forgot Password?</a>]
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
