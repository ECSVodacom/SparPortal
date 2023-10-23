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
										Dim chkInt
										
										chkInt = Request("chkInt") & ""
										If chkInt = "" Then
											chkInt = "0"
										else
											chkInt = "1"
										End If
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString	
										
										' Build the SQL
										SQL = "addSupplierCode @SupplierID=" & Request.Form("hidSupplierID") & _
											", @Code=" & MakeSQLText(Request.Form("txtSupplierCode")) & _
											", @Integrated=" & chkInt
										'response.write SQL
										'response.end
										' Execute the SQL Staytement
										Set ReturnSet = curConnection.Execute (SQL)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Add a New Supplier EAN Number</td>
	</tr>
</table>
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
<%
										end if
										
										' Close the recordset
										Set ReturnSet = Nothing
										
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
