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
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										
										PageTitle = "List Suppliers"										
										
										' Build the SQL 
										SQL = "exec listSupplier"
										
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
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - Display the error message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please try again later. Thank you.</p>
<%											
										else
											' No error occured - Continue
%>
<p class="pcontent">Below is a list of suppliers registered on our system. Click on a supplier name to edit his details.</p>
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<th class="tblheader" align="left">Supplier Name</th>
		<th class="tblheader" align="left">Supplier EAN</th>
	</tr>
<%
											' Loop through the recordset
											While not ReturnSet.EOF
%>
	<tr>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></a></td>
		<td class="tbldata"><%=ReturnSet("SupplierEAN")%></td>
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
