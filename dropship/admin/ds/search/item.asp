<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
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
										dim curConnection
										dim SQL
										dim ReturnSet
										dim FolderName
										dim TotPages
										dim Band
										dim RecordCount
										dim MaxRecords
										dim RecordFrom
										dim RecordTo
										dim BandSize
										dim UserID
										dim Selected
										dim UserType
										dim OrdNum
										dim txtSupplier
										dim txtStore
										dim ErrorCount
										dim strType
										
										ErrorCount = 0
										ErrorCode = 0
										strType = 0
										
										' Check if the user selected to search
										if Request.Form("hidAction") = "2" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											strType = CInt(Request.Form("hidType"))

											if strType = 1 then
												' Build the SQL
												SQL = "exec delOrder @OrderNumber=" & MakeSQLText(Request.Form("hidOrdNum"))
											else
												' Build the SQL
												SQL = "exec delInvoice @InvoiceNumber=" & MakeSQLText(Request.Form("hidInvNum")) & _
													", @StoreID=" & Request.Form("drpStore")
											end if
												
											'Response.Write strType
											'Response.End
	
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											if ReturnSet("returnvalue") <> 0 then
												ErrorCode = 1
											else
												ErrorCode = 2
											end if
											
											' Close the recordset and Connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/validation.js"></script>
<script language="javascript">
<!--
	var Type = <%=strType%>
	switch (Type) {
		case 1:
			if (<%=ErrorCode%>==1) {
				window.alert ('The selected Order was not deleted successful');
				break;
			} else {
				window.alert ('The selected Order and was deleted successful');
				break;
			};
		case 2:
			if (<%=ErrorCode%>==1) {
				window.alert ('The selected Invoice was not deleted successful');
				break;
			} else {
				window.alert ('The selected Invoice and was deleted successful');
				break;
			};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Check if the user selected to search
										'if Request.Form("hidAction") = "1" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString

											'StoreArray = Split(Request.Form("drpStore"),",")

											' Build the SQL
											SQL = "exec searchOrder @StoreID=" & Request.Form("drpStore")
												
												'Response.Write SQL
												'Response.End
	
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="bheader" align="left">Search Results</td>
				</tr>
				<tr>
					<td class="pcontent"><br>Below is the search results on the supplied search criteria.</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<%
											' Check the returnvalue
											if ReturnSet("returnvalue") < 0 then
												' an error occured - display
												ErrorCount = ErrorCount + 1
											else
												' no error occured
%>
<p class="bheader">Orders</p>
<table border="0" cellpadding="2" cellspacing="2" bordercolor="red">
	<tr>
		<td class="pcontent" valign="middle"><b>Note:</b> Click on the <b>Delete</b> button to delete the selected Order.</td>
	</tr>
</table>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Order Number</b></td>
		<td class="tdcontent" align="center"><b>From Store</b></td>
		<td class="tdcontent" align="center"><b>To Supplier</b></td>
		<td class="tdcontent" align="center"><b>Action</b></td>
	</tr>
<%												
												Counter = 0
												' Loop through the recordset
												While not ReturnSet.EOF
													Counter = Counter + 1
%>
	<tr>
		<td class="pcontent" align="center"><%=ReturnSet("OrderNumber")%></td>
		<td class="pcontent" align="center"><%=ReturnSet("StoreName")%></td>
		<td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
		<td class="pcontent" align="center">
			<form name="frmDel<%=Counter%>" id="frmDel<%=Counter%>" method="post" action="item.asp">
				<input type="submit" name="btnDel" id="btnDel" class="button" value="Delete"></td>
				<input type="hidden" name="hidOrdNum" id="hidOrdNum" value="<%=ReturnSet("OrderNumber")%>">
				<input type="hidden" name="drpStore" id="drpStore" value="<%=ReturnSet("StoreID")%>">
				<input type="hidden" name="hidType" id="hidType" value="1">
				<input type="hidden" name="hidAction" id="hidAction" value="2">
			</form>
		</td>
	</tr>
<%									
													ReturnSet.MoveNext
												Wend
%>	
</table>
<%
											end if
											
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Now get the the invoices
											Set ReturnSet = ExecuteSql("exec searchInvoice @StoreID=" & Request.Form("drpStore"), curConnection)  

											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = ErrorCount + 1
											else
%>
<p class="bheader">Invoices</p>
<table border="0" cellpadding="2" cellspacing="2" bordercolor="red">
	<tr>
		<td class="pcontent" valign="middle"><b>Note:</b> Click on the <b>Delete</b> button to delete the selected Invoice.</td>
	</tr>
</table>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Invoice Number</b></td>
		<td class="tdcontent" align="center"><b>From Supplier</b></td>
		<td class="tdcontent" align="center"><b>To Store</b></td>
		<td class="tdcontent" align="center"><b>Action</b></td>
	</tr>
<%												
												Counter = 0
												' Loop through the recordset
												While not ReturnSet.EOF
													Counter = Counter + 1
%>
	<tr>
		<td class="pcontent" align="center"><%=ReturnSet("InvoiceNumber")%></td>
		<td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
		<td class="pcontent" align="center"><%=ReturnSet("StoreName")%></td>
		<td class="pcontent" align="center">
			<form name="frmDel<%=Counter%>" id="frmDel<%=Counter%>" method="post" action="item.asp">
				<input type="submit" name="btnDel" id="btnDel" class="button" value="Delete"></td>
				<input type="hidden" name="hidInvNum" id="hidInvNum" value="<%=ReturnSet("InvoiceNumber")%>">
				<input type="hidden" name="hidAction" id="hidAction" value="2">
				<input type="hidden" name="hidType" id="hidType" value="2">
				<input type="hidden" name="drpStore" id="drpStore" value="<%=ReturnSet("StoreID")%>">
			</form>
		</td>
	</tr>
<%									
													ReturnSet.MoveNext
												Wend
%>	
</table>
<%											
											end if
											
											' Close the recordset
											Set ReturnSet = Nothing
										
											' Close the connection
											curConnection.Close
											Set curConnection = Nothing
										
										'end if
										
										if ErrorCount = 2 then
%>
<table border="0" cellpadding="0" cellspacing="0" bordercolor="red">
	<tr>
		<td class="pcontent" valign="middle"><font color="red"><b>No match found: Select an alternative search criteria.</b></font></td>
	</tr>
</table>
<%										
										end if
%>
<!--#include file="../layout/end.asp"-->
