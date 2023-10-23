<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Check if the id parameter is passed in the querystring
										if Request.Form("btnAdd") <> "  Add  " Then
											Response.Redirect const_app_ApplicationRoot & "/supplier/default.asp"
										end if
										
										PageTitle = "Add a New Supplier EAN Number"
										
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
										
										' Build the SQL
										SQL = "addSupplierCode @SupplierID=" & Request.Form("hidSupplierID") & _
											", @Code=" & MakeSQLText(Request.Form("txtSupplierCode"))

										' Execute the SQL Staytement
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
		<td class="pheader">Add a New Supplier EAN Number</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/suppliermenu.asp"-->
<!--#include file="includes/subsuppliermenu.asp"-->
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' Display the error message
%>
<p class="errortext">Error</p>
<p class="pcontent"><%=ReturnSet("errormessage")%></p>
<%											
										else
											' No error occured
%>
<p class="pcontent">The Supplier EAN Number <b><%=Request.Form("txtSupplierCode")%></b> was added successfully.</p>
<p class="pcontent">Options
	<ul>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/">List Suppliers</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp">Add a New Supplier</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=Request.Form("hidSupplierID")%>">View the Buyer detail</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/supplier/suppliercode.asp?id=<%=Request.Form("hidSupplierID")%>">View Supplier EAN Numbers just added</a></li>
	</ul>
</p>
<%
										end if
										
										' Close the recordset
										Set ReturnSet = Nothing
										
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
