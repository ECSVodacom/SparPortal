<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%
										dim curConnection
										dim ReturnSet 
										dim SQL
										dim OrderID
%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<%						
										' Check if there is a orderid provided
										if Request.QueryString("item") = "" then
											OrderID = 0
										else
											OrderID = Request.QueryString("item")
										end if

										' Biuld the SQL Statement for orders
										SQL = "exec listInvoice @OrderID=" & OrderID
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_DB_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<p class="bheader">Electronic Invoice List</p>
<p class="pcontent">Below is a list of Electronic Invoices for the selected order <b><%=ReturnSet("OrderNumber")%></b>.
	<ul>
		<li class="pcontent">Click on the <b>Invoice Number</b> link to view the invoice detail.</li>
		<li class="pcontent">Click on the <b>Print List</b> link at the bottom of the page, to print this list to your printer.</li>
	</ul>
</p>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Invoice Number</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Application</i></b><br>
			<b><i>Reference</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>File</i></b><br>
			<b><i>Received</i></b><br>
			<b><i>by Gateway</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Translation</i></b><br>
			<b><i>To</i></b><br>
			<b><i>FLAT or XML</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Posted to</i></b><br>
			<b><i>SPAR DC</i></b>
		</th>
	</tr>
<%
										' Loop through the recordset
										While Not ReturnSet.EOF
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="<%=const_app_ApplicationRoot%>/track/supplier/invoice/default.asp?item=<%=ReturnSet("InvoiceID")%>"><%=ReturnSet("TraceNumber")%></a></td>
		<td class="pcontent" align="center">TAXCPY</td>
		<td class="pcontent" align="center"><%=ReturnSet("RecieveDate") & "<br>[" & ReturnSet("RecieveTime") & "]"%></td>
		<td class="pcontent" align="center"><%=ReturnSet("TransDate") & "<br>[" & ReturnSet("TransTime") & "]"%></td>	
		<td class="pcontent" align="center"><%if ReturnSet("PostDate") <> "" Then Response.Write ReturnSet("PostDate") & "<br>[" & ReturnSet("PostTime") & "]" else Response.Write "-" end if%></td>				
	</tr>
<%										
										
											ReturnSet.MoveNext
										Wend
%>
</table><br>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<!-- Create the Buttons -->
	<tr>
		<td class="pcontent" align="center">
			<input type="button" name="btnPrint" id="btnPrint" value="Print List" class="button"  onclick="javascript:window.print();"/>&#160;
			<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
		</td>
	</tr>
	<!-- End Create the Buttons -->		
</table>
<%
										' Close the Recordset and Connection
										Set ReturnSet = Nothing
										
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../../../layout/end.asp"-->
