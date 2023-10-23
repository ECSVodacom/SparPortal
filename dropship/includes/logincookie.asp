<!--#include file="formatfunctions.asp"-->
<!--#include file="setuserdetails.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorFlag
										dim CreateCookie
										dim UsType

										ErrorFlag = 0
										
										' Check if the user selected to login
										if Request.Form("hidAction") = "1" or Request.Cookies("DSLogin") <> "" Then

											' Set the connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											if Request.Cookies("DSLogin") <> "" Then
												' Create the SQL for the cookie login
												SQL = "exec procCookieLogin @LoginName=" & MakeSQLText(Request.Cookies("DsLogin"))
												
												CreateCookie = False
												'Response.Write "Doi not Create cookie"
											else
												' Set the SQL Statement
												SQL = "exec procLogin @LoginName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @Password=" & MakeSQLText(Request.Form("txtPassword"))
													
												CreateCookie = True
												'Response.Write "Create cookie"
											end if
											
											'Response.Write "test"
											'Response.Write SQL
											'Response.End

											' Execute the SQL
											
											Set ReturnSet = ExecuteSql(SQL, curConnection) 
											'response.Write SQL
											'Response.Write Request.Cookies("DSLogin")
											
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
													Response.Redirect const_app_ApplicationRoot & "/profile/default.asp?id=" & Request.Form("txtUserName")
												else
													Dim txtStoreCode, txtStoreFormat, txtClaimCaptureOverrideIndicator
													txtStoreCode = ""
													txtStoreFormat = ""
													txtClaimCaptureOverrideIndicator = ""
													If ReturnSet("UserType") = 3 Then 
														txtStoreCode = ReturnSet("StoreCode")
														txtStoreFormat = ReturnSet("StoreFormat")
														txtClaimCaptureOverrideIndicator = ReturnSet("ClaimCaptureOverrideIndicator")
													End If
													' Set the Session variables
													Call SetUserDetails (ReturnSet("UserID"), ReturnSet("UserName"), ReturnSet("FirstName"), ReturnSet("UserType"), ReturnSet("Permission"), ReturnSet("PhysAddress"), ReturnSet("ProcID"), ReturnSet("ProcEAN"), ReturnSet("ProcName"), ReturnSet("IsXML"), ReturnSet("DCID"), "","", ReturnSet("IsSuperUser"),  ReturnSet("IsWarehouseUser"),txtStoreCode,txtStoreFormat,txtClaimCaptureOverrideIndicator)
													'Response.write("Session")
													'Response.end
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

													
													
												end if
											end if
										end if

%>