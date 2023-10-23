<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the User is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										
										PageTitle = "List Suppliers"										
										
										' Build the SQL 
										SQL = "exec listUnassignSupplier"
										
										' Create a connection
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
		<td class="bheader">Supplier Section</td>
	</tr>
</table>
<hr>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - Display the error message
%>
<br>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please try again later. Thank you.</p>
<%											
										else
										
%>
<br>
<form name="lstSupplier" id="lstSupplier" method="post" action="item.asp">
<select name="drpSupplier" id="drpSupplier" class="pcontent" onchange="document.lstSupplier.action='item.asp?id=' + document.lstSupplier.drpSupplier.value; document.lstSupplier.submit();">
				<option value="-1">-- Select a Supplier --</option>
<%										
											' No error occured - Continue
											' Loop through the recordset
											While not ReturnSet.EOF
											
%>

<option value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName") & " (" & ReturnSet("SupplierCode") & ") "%></option>
		<p class="pcontent"><b><%=ReturnSet("SupplierName") & " (" & ReturnSet("SupplierCode") & ") "%></b></p>

<%

										ReturnSet.MoveNext
											Wend
										end if
										
										'Close the recordset and connection
										Set ReturnSet = Nothing
										'curConnection.Close
										'Set curConnection = Nothing
										
										' Build the SQL 
										SQL = "exec listUnassignSupplier"
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)

%>
<p class="pcontent">Below is a list of suppliers registered on our system. Click on a supplier name to edit his details.</p>
<table border="0" cellspacing="2" cellpadding="2">
<br>
	<tr>
		<th class="tblheader" align="center">Supplier Name</th>
		<th class="tblheader" align="center">EAN Number</th>
	</tr>
<%
											
											
											' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - Display the error message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please try again later. Thank you.</p>
<%											
										else
										
										' Loop through the recordset
											While not ReturnSet.EOF
										
%>
	<tr>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=ReturnSet("SupplierID")%>"><%=UCase(ReturnSet("SupplierName"))%></a></td>
		<td class="tbldata"><%=ReturnSet("SupplierCode")%></td>
	</tr>
	
	
	
	
<%										
												ReturnSet.MoveNext
											Wend
										end if
%>	
</table>
<!--#include file="../layout/end.asp"-->
<%
										' Close the recordset and connection
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>
