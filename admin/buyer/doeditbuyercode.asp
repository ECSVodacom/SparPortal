<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/buyer/default.asp")
										
										' Check if the id parameter is passed in the querystring
										if Request.Form("hidBuyerID") = "" Then
											Response.Redirect const_app_ApplicationRoot & "/buyer/default.asp"
										end if
										
										PageTitle = "Edit Buyer Codes"
										
										dim SQL
										dim curConnection
										dim ReturnSet
										dim ErrorMessage
										dim ErrorCount
										dim DoUpdate
										dim Counter
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString	
										
										Errormessage = ""
										ErrorCount = 0
										
										' Loop through the form fields
										For Counter = 1 to Request.Form("hidTotal")
											' Check if the user selected to update buyer codes
											if Request.Form("chkDelete" & Counter) = "checked" or Request.Form("chkDelete" & Counter) = "on" then
												DoUpdate = False
												SQL = "exec delBuyerCode @BuyerID=" & Request.Form("hidBuyerID") & _
													", @BuyerCodeID=" &  Request.Form("hidBuyerCodeID" & Counter)												
											else
												DoUpdate = True
												SQL = "exec editBuyerCode  @BuyerID=" & Request.Form("hidBuyerID") & _
													", @BuyerCodeID=" & Request.Form("hidBuyerCodeID" & Counter) & _
													", @Code=" & MakeSQLText(Request.Form("txtCode" & Counter))
											end if

											' Execute the SQL Staytement
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = ErrorCount + 1
												if DoUpdate then
													' An error occured - Set the error message
													Errormessage = ErrorMessage & "Buyer Code <b>" & Request.Form("txtCode" & Counter) & "</b> was not updated successfully.<br>"
													Errormessage = ErrorMessage & "<b>Reason: </b>" & ReturnSet("errormessage")
												else
													Errormessage = ErrorMessage & "Buyer Code <b>" & Request.Form("txtCode" & Counter) & "</b> was not deleted successfully.<br>"
												end if
											end if
											
											'Response.Write ErrorCount
											'Response.End
											
											' Close the recordset
											Set ReturnSet = Nothing
										Next
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Edit Buyer Codes</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/buyermenu.asp"-->
<!--#include file="includes/subbuyermenu.asp"-->							
<%
										' Determine if there were errors
										if ErrorCount > 0 then
											' Display the error message
%>
<p class="errortext">Errors</p>
<p class="pcontent"><%=ErrorMessage%></p>
<%		
										else									
%>
<p class="pcontent">The buyer codes were updated or deleted successfully.</p>
<%
										end if
%>
<p class="pcontent">Options
	<ul>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/">List Buyers</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp">Add a New Buyer</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=Request.Form("hidBuyerID")%>">View the Buyer detail</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/buyercode.asp?id=<%=Request.Form("hidBuyerID")%>">View Buyer Codes just updated/deleted</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/buyeremail.asp?id=<%=Request.Form("hidBuyerID")%>">Edit Buyer Email Addresses</a></li>
	</ul>
</p>
<%
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
