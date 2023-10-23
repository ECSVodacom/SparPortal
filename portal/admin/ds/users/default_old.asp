<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/functions.asp"-->
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
										dim txtMaxRecords
										dim txtRecordFrom
										dim txtRecordTo
										dim txtBandSize
										dim txtRecordCount
										dim Page
										dim TotPages
										
										PageTitle = "List Stores"	
										
										' Determine the page number
										if Request.QueryString("page") = "" then
											Page = 1
										else	
											Page = CInt(Request.QueryString("page"))
										end if									
										
										' Build the SQL 
										'SQL = "exec listStores @Admin=1" & _
										'	", @RecordBand=" & Page & _
										'	", @DCID=" & Session("UserID")
										
										SQL = "exec listStores @Admin=0" 

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Execute the SQL
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
		<td class="bheader">Store Section</td>
	</tr>
</table>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") < 0 then
											' An error occured - Display the error message
%>
<p class="errortext">There are currently no Stores allocated to this Distribution Centre.</p>
<p class="errortext">Please try again later. Thank you.</p>
<%											
										else
											' No error occured - Continue
											' Get the Bandsize ect.
											'txtMaxRecords = ReturnSet("MaxRecords")
											'txtRecordFrom = ReturnSet("RecordFrom")
											'txtRecordTo = ReturnSet("RecordTo") 
											'txtBandSize = ReturnSet("BandSize")
											'txtRecordCount = ReturnSet("RecordCount")
%>
<p class="pcontent">Below is a list of stores registered on our system. Click on a store name to edit its details.</p>
<%
											'TotPages = CalcNumPages(txtMaxRecords, txtBandSize)

											'Call PageHeadNav ("pcontent", txtRecordCount, txtMaxRecords, txtRecordFrom, txtRecordTo)
											
											'Call PageNav (const_app_ApplicationRoot & "/store/default.asp", "pcontent", txtRecordCount, txtMaxRecords, txtRecordFrom, txtRecordTo, TotPages, Page, "")
%>
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<th class="tblheader" align="left">Store Name</th>
		<th class="tblheader" align="left">Store EAN</th>
	</tr>
<%
											' Loop through the recordset
											While not ReturnSet.EOF
%>
	<tr>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/store/item.asp?id=<%=ReturnSet("StoreID")%>"><%=ReturnSet("StoreName")%></a></td>
		<td class="tbldata"><%=ReturnSet("StoreEAN")%></td>
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
