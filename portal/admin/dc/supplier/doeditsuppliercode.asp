<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Check if the id parameter is passed in the querystring
										if Request.Form("hidSupplierID") = "" Then
											Response.Redirect const_app_ApplicationRoot & "/supplier/default.asp"
										end if
										
										PageTitle = "Edit Supplier EAN Number"
										
										dim SQL
										dim curConnection
										dim ReturnSet
										dim ErrorMessage
										dim ErrorCount
										dim DoUpdate
										dim Counter
										dim isIntegrate
										Dim chkNGI
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString	
										
										Errormessage = ""
										ErrorCount = 0
										
										' response.write Counter
										' Loop through the form fields
										For Counter = 1 to Request.Form("hidTotal")
										
										If Request.Form("chkIntegrated" & Counter) = "checked" or Request.Form("chkIntegrated" & Counter) = "on" Then
											IsIntegrate = 1
										else
											IsIntegrate = 0
										End If

										
											' Check if the user selected to update supplier codes
											if Request.Form("chkDelete" & Counter) = "checked" or Request.Form("chkDelete" & Counter) = "on" then
												DoUpdate = False
												SQL = "delSupplierCode @SupplierID=" & Request.Form("hidSupplierID") & _
													", @SupplierCodeID=" &  Request.Form("hidSupplierCodeID" & Counter)	
											
											elseif Request.Form("chkIntegrated" & Counter) = "checked" or Request.Form("chkIntegrated" & Counter) = "on" then
												SQL = "SetIntegratedSupplierCode @SupplierID=" & Request.Form("hidSupplierID") & _
													", @SupplierCodeID=" &  Request.Form("hidSupplierCodeID" & Counter) & _
													", @IntegratedSupplier=" & IsIntegrate
											else
												DoUpdate = True
												SQL = "editSupplierCode @SupplierID=" & Request.Form("hidSupplierID") & _
													", @SupplierCodeID=" & Request.Form("hidSupplierCodeID" & Counter) & _
													", @Code=" & MakeSQLText(Request.Form("txtCode" & Counter)) & _
													", @IntegratedSupplier=" & IsIntegrate
											end if
											
											'response.write SQL
											'response.end
											'Execute the SQL Statement
											Set ReturnSet = curConnection.Execute (SQL)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = ErrorCount + 1
												if DoUpdate then
													' An error occured - Set the error message
													Errormessage = ErrorMessage & "Supplier EAN Number <b>" & Request.Form("txtCode" & Counter) & "</b> was not updated successfully.<br>"
												else
													Errormessage = ErrorMessage & "Supplier EAN Number <b>" & Request.Form("txtCode" & Counter) & "</b> was not deleted successfully.<br>"
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
		<td class="bheader">Edit Buyer Codes</td>
	</tr>
</table>
<!--#include file="includes/subsuppliermenu.asp"-->							
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
<p class="pcontent">The Supplier EAN Numbers were updated or deleted successfully.</p>
<%
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
