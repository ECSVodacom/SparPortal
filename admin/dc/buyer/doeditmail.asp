<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>
<%
										' Check if the id parameter is passed in the querystring
										if Request.Form("hidBuyerID") = "" Then
											Response.Redirect const_app_ApplicationRoot & "/buyer/default.asp"
										end if
										
										PageTitle = "Edit Buyer Emails"
										
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
												SQL = "delBuyerMail @BuyerID=" & Request.Form("hidBuyerID") & _
													", @BuyerMailID=" &  Request.Form("hidMailID" & Counter)												
											else
												DoUpdate = True
												SQL = "editBuyerMail  @BuyerID=" & Request.Form("hidBuyerID") & _
													", @BuyerMailID=" & Request.Form("hidMailID" & Counter) & _
													", @Mail=" & MakeSQLText(Request.Form("txtMail" & Counter))
											end if
											
											' Execute the SQL Staytement
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = ErrorCount + 1
												if DoUpdate then
													' An error occured - Set the error message
													Errormessage = ErrorMessage & "Buyer Email <b>" & Request.Form("txtMail" & Counter) & "</b> was not updated successfully.<br>"
												else
													Errormessage = ErrorMessage & "Buyer Email <b>" & Request.Form("txtMail" & Counter) & "</b> was not deleted successfully.<br>"
												end if
											end if
											
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
		<td class="bheader">Edit Buyer Emails</td>
	</tr>
</table>
<!--#include file="includes/subbuyermenu.asp"-->							
<%
										' Determine if there were errors
										if ErrorCount > 0 then
											' Display the error message
%>
<p class="errortext">Errors</p>
<p class="pcontent"><%=ErrorMessage%></p>
<%		
										end if									
%>
<p class="pcontent">The buyer Emails were updated or deleted successfully.</p>
<%
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
