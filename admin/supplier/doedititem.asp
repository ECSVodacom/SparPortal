<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 02 Sept 2002
	' Purpose: This page will update then relationships for the selected buyer.
					
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Set the page header
										PageTitle = "Edit Supplier Detail"
										
										' Check if this page is accessed from the item page
										if Request.Form("btnSubmit") <> "Submit" Then
											' redirect to the default page
											Response.Redirect const_app_ApplicationRoot & "/supplier/default.asp"
										end if
					
										' Declare the variables
										dim SQL
										dim ReturnSet
										dim curConnection	
										dim IsDisable
										dim ErrorCount
										dim SupplierArray
										dim Counter
										dim txtSupplier
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if
										
										' Build the SQL for updating the User detail
										SQL = "exec editSupplier @SupplierID=" & Request.Form("hidSupplierID") & _
											", @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @Password=" & MakeSQLText(Request.Form("txtConfirmPassword")) & _
											", @Name=" & MakeSQLText(Request.Form("txtName")) & _
											", @Email=" & MakeSQLText(Request.Form("txtMail")) & _
											", @Address=" & MakeSQLText(Request.Form("txtAddress")) & _
											", @Disable=" & IsDisable
											
										' Set the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Update Supplier Detail</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/suppliermenu.asp"-->
<!--#include file="includes/subsuppliermenu.asp"-->
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display the message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again. Please contact the <a href="mailto:spar@firstnet.co.za">System Administrator</a> if you encounter the same problem.</p>
<%											
										else
											' No errors occured - Display the success message
%>
<p class="pcontent">The Detail for supplier <b><%=Request.Form("txtName")%></b> has been updated successfully.</p>
<p class="pcontent"><b>Options:</b>
	<ul>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/">List Suppliers</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp">Add a New Supplier</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=Request.Form("hidSupplierID")%>">View the Supplier details just updated</a></li>
	</ul>
</p>
<%		
										end if
										
										' Close the recordset
										Set ReturnSet = Nothing
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
