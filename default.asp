<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="includes/constants.asp"-->
<!--#include file="includes/formatfunctions.asp"-->
<!--#include file="includes/setuserdetails.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorFlag
										dim CreateCookie
										dim UsType
										
										ErrorFlag = 0
										CreateCookie = False
										
										' Check if the user selected to login
										if Request.Form("hidAction") = "1" or Request.Cookies("PortalLogin") <> "" Then
											if Request.Form("chkBoxCookie") = "checked" or Request.Form("chkBoxCookie") = "on" then
												CreateCookie = True
											end if

											' Set the connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											if Request.Cookies("PortalLogin") <> "" Then
												' Create the SQL for the cookie login
												SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("PortalLogin"))
												
											else	
												' Set the SQL Statement
												SQL = "exec procLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @Password=" & MakeSQLText(Request.Form("txtPassword"))
											end if
											
											' Execute the SQL
											'response.Write(sql)
											'response.End 
											Set ReturnSet = ExecuteSql(SQL, curConnection)
																					
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Set the error flag
												ErrorFlag = 1
												
												' Close the Recodset
												Set ReturnSet = Nothing
																				
												' Close the connection
												curConnection.Close
												Set curConnection = Nothing
												
											else
												' No error occured - Log the user into the site
												' Set the Session variables
												
												'	  SetUserDetails (UserID, UserName,										FirstName,					UserType,					Permission,					PhysAddress,					PostAddress,					Email)
												Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("ClientName"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("PhysAddress"), ReturnSet("PostAddress"), ReturnSet("ClientMail"))
													
												' Close the Recodset
												Set ReturnSet = Nothing
																					
												' Close the connection
												curConnection.Close
												Set curConnection = Nothing
												
												' Check if we need to create a cookie
													if CreateCookie then
														Response.Cookies("PortalLogin") = Request.Form("txtUserName")
														Response.Cookies("PortalLogin").Expires = DateAdd("m",1,Date)
													end if

												Response.Redirect const_app_ApplicationRoot & "/track/"
											end if
										end if

%>
<html>
	<head>
		<title>Vodacom Business - SPAR Portal Sign In</title>
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
					<td><div class="banner"><b>Vodacom Business - SPAR Portal // <font color="#FF6F2F" > Production server</font></b></div></td>
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
			<table class="tablewindow" align="center" cellspacing="0" cellpadding="10" border="0" width="60%">
				<tr>
					<td class="tdtitle" valign="top"><img align="left" src="<%=const_app_ApplicationRoot%>/layout/images/bullet.gif" hspace="7">Login</td>
				</tr>
				<tr>
					<td>
						<br>
						<table border="0" cellspacing="10" width="100%">
							<tr>
								<!--<td valign="middle" align="right"><img src="<%=const_app_ApplicationRoot%>/layout/images/newgatelogo.gif" border="0"></td>-->
								<td>&nbsp;</td>
								<td valign="middle" align="left"><h3> Welcome on SPAR Portal </h3></td>
							</tr>
						</table><br>
						<form method="post" action="default.asp" name="form" onkeypress="getKey()" onsubmit="return validate(this);">
							<center>
							<table class="tableform" cellspacing="1" cellpadding="1">
								<tr>
									<td class="tdformhdr" width="100">Username</td>
									<td class="tdforminput" width="80"><input class="text" type="text" name="txtUserName" size="25" maxlength="15"></td>
								</tr>
								<tr>
									<td class="tdformhdr">Password</td>
									<td class="tdforminput">
										<input class="text" type="password" name="txtPassword" size="25" maxlength="15">
										<input type="hidden" name="hidAction" id="hidAction" value="1">
									</td>
								</tr>
								<tr>
									<td class="tdformhdr" width="100">Remember Login?</td>
									<td class="tdforminput" width="80"><input type="checkbox" id="chkBoxCookie" name="chkBoxCookie" class="pcontent"></td>
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
												<!-- <td>
													[<a class="forgot" href="<%=const_app_ApplicationRoot%>/forgot/">Forgot Password?</a>]&nbsp;
													 [<a class="forgot" href="<%=const_app_ApplicationRoot%>/register/">Register</a>]-->
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
