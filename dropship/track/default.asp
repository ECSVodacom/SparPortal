<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck ("")

										
										' Check what type of user is logging in
										Select Case Session("UserType")
										Case 1,4
											if request.querystring("RRID") = "" then
												' redirect the user to the supplier section
												Response.Redirect const_app_ApplicationRoot & "/track/supplier/"
											else
												'Response.Write("RRIDSUP")
												'Response.End 
												Response.Redirect const_app_ApplicationRoot & "/track/supplier/default.asp?RRID=" & request.querystring("RRID")
											end if
											
										Case 2 
											if request.querystring("RRID") = "" then
												' redirect the user to the dc section
												Response.Redirect const_app_ApplicationRoot & "/track/dc/"
											else
												'Response.Write("RRIDDC")
												'Response.End 
												Response.Redirect const_app_ApplicationRoot & "/track/dc/default.asp?RRID=" & request.querystring("RRID")
											end if
										Case 3
											' redirect the user to the store section
											Response.Redirect const_app_ApplicationRoot & "/track/store/"
										End Select
%>
