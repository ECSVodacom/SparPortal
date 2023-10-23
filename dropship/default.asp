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
										dim IsSuperUser

										ErrorFlag = 0
										
										If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
											Response.Cookies("DSLogin") = ""
										End If
'Response.Write const_db_ConnectionString
										' Check if the user selected to login
										if Request.Form("hidAction") = "1" or Request.Cookies("DSLogin") <> "" Then
											' Set the connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											
											curConnection.Open const_db_ConnectionString
											
											
											
											if Request.Cookies("DSLogin") <> "" Then
												' Create the SQL for the cookie login
												SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("DsLogin"))
												
												CreateCookie = False
											else
												' Set the SQL Statement
												SQL = "exec procLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @Password=" & MakeSQLText(Request.Form("txtPassword"))
												'response.write SQL	
												'response.end
												CreateCookie = True
											end if
											
											'Response.Write SQL
											'Response.End

											' Execute the SQL
											
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
												'Response.write(ReturnSet("ChangePwd"))
												'Response.end
												' No error occured - Log the user into the site
												' Check if the user has to change his password
												if ReturnSet("ChangePwd") = 1 Then
													' redirect the user to the change password screen
													Response.Redirect const_app_ApplicationRoot & "/profile/default.asp?id=" & ReturnSet("UserName") 'Request.Form("txtUserName")
												else
													' Set the Session variables
													'response.write(sql)
													'response.end
													Dim txtStoreCode, txtStoreFormat, txtClaimCaptureOverrideIndicator
													txtStoreCode = ""
													txtStoreFormat = ""
													txtClaimCaptureOverrideIndicator = ""
													If ReturnSet("UserType") = 3 Then 
														txtStoreCode = ReturnSet("StoreCode")
														txtStoreFormat = ReturnSet("StoreFormat")
														txtClaimCaptureOverrideIndicator = ReturnSet("ClaimCaptureOverrideIndicator")
													End If
													Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("FirstName"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("PhysAddress"), ReturnSet("ProcID"), ReturnSet("ProcEAN"), ReturnSet("ProcName"), ReturnSet("IsXML"), ReturnSet("DCID"), "",ReturnSet("DCcEANNumber"),ReturnSet("IsSuperUser"),ReturnSet("IsWarehouseUser"),txtStoreCode,txtStoreFormat,txtClaimCaptureOverrideIndicator)
												
												
													' Close the Recodset
													Set ReturnSet = Nothing
																					
													' Close the connection
													curConnection.Close
													Set curConnection = Nothing
													
													' Check if we need to create a cookie
													if CreateCookie then
														Response.Cookies("DSLogin") = Request.Form("txtUserName")
														Response.Cookies("DSLogin").Expires = DateAdd("m",1,Date)
													end if
													Session("HideMenu") = False
													if request.querystring("exceptid") = "" then
														if request.querystring("RRID") = "" then
															If Request.QueryString("i") Then
																Select Case Session("Action")
																	Case 1,2,3,4,5,6
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/track/"
																	Case 10
																		Response.Redirect const_app_ApplicationRoot & "/claims/integrate.asp?id=2"
																	Case 11
																		Response.Redirect const_app_ApplicationRoot & "/claims/index.asp?id=1"
																	Case 12
																		Response.Redirect const_app_ApplicationRoot & "/claims/index.asp"
																	Case 15
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/search/default.asp"
																	Case 16
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/Stats/billing/default.asp?id=ds&type=stat"
																	Case 17
																		Response.Redirect const_app_ApplicationRoot & "/track/dc/dcclaimoptions.asp"
																	Case 18
																		Response.Redirect const_app_ApplicationRoot & "/track/dc/OrderConfigurations.asp"
																	Case 19
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/track/dc/WebOrderingConfig.asp"
																	Case 20
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/MaintainClaimSupplierEan.asp"
																	Case 21
																		Response.Redirect const_app_ApplicationRoot & "/track/dc/WarehouseClaimConfig.asp"
																	Case 23
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/DCAdminClaimsCategories.asp"
																	Case 25
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminClaimsCategories.asp"
																	Case 26
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminReasonCodes.asp"
																	Case 27
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/SupplierAdminSubReasonCodes.asp"
																	Case 28
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/SupplierClaimCaptureStoreExceptions.asp"
																	Case 29 
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/ClaimStatusManagement.asp"
																	Case 30
																		Session("HideMenu") = True
																		Response.Redirect const_app_ApplicationRoot & "/claims/MaintainClaimSupplierEan.asp"
																
																	Case Else
																		Session("HideMenu") = False
																		Response.Redirect const_app_ApplicationRoot & "/track/"
																End Select
																
																
															Else
																Session("HideMenu") = False
																Response.Redirect const_app_ApplicationRoot & "/track/"
															End If
														else
															'Response.Write("RRID")
															'Response.End 
															Response.Redirect const_app_ApplicationRoot & "/track/default.asp?RRID=" & request.querystring("RRID")
														end if
													else
														Response.Redirect const_app_ApplicationRoot & "/track/dc/default.asp?exceptid=" & request.querystring("exceptid")
													end if
													
												end if
											end if
										end if

%>
<html>
	<head>
		<title>SPAR - Drop Shipment Login Page</title>
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
			   key = 10; <!--(isNav) ? keyStroke.which : event.keyCode;-->
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
						<td><div class="banner"><b>Vodacom Business - SPAR Dropshipment: Track & Trace // <font color="#FF6F2F" > Production Server</font></b></div></td>
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
										<td valign="middle" align="left" width="30%"><!--<img src="<%=const_app_ApplicationRoot%>/layout/images/newgatelogo.gif" border="0">-->&nbsp;</td>
										<td valign="middle" align="left" width="70%"><h3>Welcome to DSH Login </h3></td>
									</tr>
									<tr>
										<td><br><br></td>
									</tr>
<%
											' Check if there was errors
											if ErrorFlag = 1 Then
												' Display the error
%>
									<tr>
										<td class="warning" colspan="3" wrap="virtual">A login error occured. Check the spelling of your User Name or Password and try again.<br><br></td>
									</tr>
<%										
											end if
%>			
									<tr>
										<td class="tdformhdr">Username</td>
										<td class="tdforminput"><input class="text" type="text" name="txtUserName" size="25" maxlength="25"></td>
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
														[<a class="forgot" href="<%=const_app_ApplicationRoot%>/forgot/">Forgot Password?</a>]
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
