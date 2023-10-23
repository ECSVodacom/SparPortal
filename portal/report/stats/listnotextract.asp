<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
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
										dim strDC
										dim strMonth
										dim SupName
										dim TogColor
										dim Count
										
										' Set the DC and Month
										if isNull(Request.QueryString("date")) then
											strMonth = ""
										else
											strMonth = Request.QueryString("date")
										end if
										
										if isNull(Request.QueryString("id")) then
											strDC = ""
										else
											strDC = Request.QueryString("id")
										end if
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="bheader" align="left">Daily Order Statistics - Orders Not Extracted</td>		
	</tr>
	<tr>
		<td class="sheader" align="left"><%=GetDC(strDC)%></td>
		<td class="pcontent" align="right" rowspan="3">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="pcontent" valign="middle">
						<a class="stextnav" href="javascript:window.print();"><img src="<%=const_app_ApplicationRoot%>/layout/images/print_new.gif" border="0" alt="Print this page...">&nbsp;Print this page</a><br>
						<a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/includes/bugreport.asp', 'BugReport', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="<%=const_app_ApplicationRoot%>/layout/images/bug.gif" border="0" alt="Report a Bug...">&#160;Report a Bug</a><br/>
						<a class="stextnav" href="javascript:history.back(-1);"><img src="<%=const_app_ApplicationRoot%>/layout/images/backbutton.gif" border="0" alt="Return to previous page...">&nbsp;Previous Page</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ReportConnection
										
										' Set the SQL Statement
										SQL = "listOrdersNotExtracted @Date=" & MakeSQLText(strMonth) & _
											", @DC=" & MakeSQLText(UCase(strDC))

										' Call the Stored procedure - listOrdersNotExtracted - To get the list of order numbers not extracted
										Set ReturnSet = ExecuteSql(SQL, curConnection) 
										
										' Check the Returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' No records returned - Display an error message
%>
<p class="pcontent">There are no data available for the selected date. Please try again later.</p>
<%											
										else
											' There are records returned - Display them
%>
<p class="pcontent">Below is a list of Order Numbers that have not been extracted for orders received on <b><%=FormatLongDate(strMonth,false)%></b>
	<ul>
		<li class="pcontent">Click on the <b>Order Number</b> link, to view the order detail.</li>
	</ul>
</p>
<table border="1" cellpadding="2" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center" width="50%"><b>Supplier Name</b></td>
		<td class="tdcontent" align="center" width="20%"><b>Order Number</b></td>
		<td class="tdcontent" align="center" width="30%"><b>Buyer Name</b></td>
	</tr>
<%	
											' Set the default SupName
											SupName = ""
											Count = 0
											TogColor = ""
					
											' Loop through the recordset
											While not ReturnSet.EOF
												Count = Count + 1
											
												if Count MOD 2 Then
													TogColor = "#ccccc2"
												else
													TogColor = ""		
												end if

												if SupName <> ReturnSet("SupplierName") then
%>	
		<tr><td colspan="3"></td></tr>
		<tr bgcolor="<%=TogColor%>">
		<td class="pcontent" align="center" width="50%"><b><%=ReturnSet("SupplierName")%></b></td>
<%
												else
%>
		<tr bgcolor="<%=TogColor%>">
		<td class="pcontent" align="center" width="50%">&nbsp;</td>
<%
												end if
%>		
		<td class="pcontent" align="center" width="20%"><a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/report/stats/vieworder.asp?id=<%=ReturnSet("OrderNumber")%>&date=<%=strMonth%>', 'ViewOrder', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=Mid(ReturnSet("OrderNumber"),1,Len(ReturnSet("OrderNumber"))-4)%></a></td>
		<td class="pcontent" align="center" width="30%"><%=ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname")%></td>
	</tr>
<%											
												SupName = ReturnSet("SupplierName")

												ReturnSet.MoveNext
											Wend
%>
</table>
<%											
										end if
										
										' Close the Recordset
										Set ReturnSet = Nothing
										
										' close the Connection
										curConnection.Close
										Set curConnection = Nothing
%>

<!--#include file="../../layout/end.asp"-->
