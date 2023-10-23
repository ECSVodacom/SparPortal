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
										dim OrdTot
										dim ExtTot
										dim QtyTot
										dim PriceTot
										dim MontDay
										dim LineCount
										
										OrdTot = 0
										ExtTot = 0
										QtyTot = 0
										PriceTot = 0
										LineCount = 0
										
										' Set the DC and Month
										if isNull(Request.QueryString("month")) then
											strMonth = 0
										else
											strMonth = Request.QueryString("month")
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
		<td class="bheader">Daily Order Statistics</td>		
	</tr>
	<tr>
		<td class="sheader" align="left"><%=GetDC(strDC)%></td>
		<td class="pcontent" align="right" rowspan="3" valign="top">
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
										SQL = "listDCRollOverTots @RollMonth=" & strMonth & _
											", @DC=" & MakeSQLText(UCase(strDC))

										' Call the Stored procedure - listDCRollOverTots - To get the totals for the selected month and DC
										Set ReturnSet = ExecuteSql(SQL, curConnection) 
										
										' Check the Returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' No records returned - Display an error message
%>
<p class="pcontent">There are no data available for the selected month. Please try again later.</p>
<%											
										else
											' There are records returned - Display them
%>
<p class="pcontent">Below is the daily drill down statistical data for <b><%=GetMonth (strMonth,True)%></b>
	<ul>
		<li class="pcontent">Click on the daily <b>Number of Orders Extracted</b> total, to view the list of orders that have not been extracted.</li>
	</ul>
</p>
<table border="1" cellpadding="2" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Date</b></td>
		<td class="tdcontent" align="center"><b>Total Orders<br>Received</b></td>
		<td class="tdcontent" align="center"><b>Total Orders<br>Extracted</b></td>
		<td class="tdcontent" align="center"><b>Total Price<br>Confirmations</b></td>
		<td class="tdcontent" align="center"><b>Total Quantity<br>Confirmations</b></td>
	</tr>
<%						
											' Loop through the recordset
											While not ReturnSet.EOF
												' Add the Totals
												OrdTot = OrdTot + ReturnSet("NumOrders")
												ExtTot = ExtTot + ReturnSet("NumOrdExtract")
												QtyTot = QtyTot + ReturnSet("FirstConfirmOrd")
												PriceTot = PriceTot + ReturnSet("SecConfirmOrd")
												MontDay = ReturnSet("DayOfMonth")
												LineCount = LineCount + 1
												
												if LineCount MOD 2 Then
%>
	<tr>
<%
												else
%>
	 <tr bgcolor="#ccccc2">
<%												
												end if
%>
		<td class="pcontent" align="center"><%=GetDay(MontDay, false) & "  " & FormatDate(MontDay,false)%></td>
		<td class="pcontent" align="center"><%=ReturnSet("NumOrders")%></td>
<%
												if ReturnSet("NumOrders") <> ReturnSet("NumOrdExtract") then
%>		
		<td class="pcontent" align="center"><a class="diffnav" href="<%=const_app_ApplicationRoot%>/report/stats/listnotextract.asp?id=<%=strDC%>&date=<%=MontDay%>"><%=ReturnSet("NumOrdExtract")%></a></td>
<%
												else
%>		
		<td class="pcontent" align="center"><%=ReturnSet("NumOrdExtract")%></td>
<%												
												end if
%>		
		<td class="pcontent" align="center"><%=ReturnSet("SecConfirmOrd")%></td>
		<td class="pcontent" align="center"><%=ReturnSet("FirstConfirmOrd")%></td>
	</tr>
<%											
												ReturnSet.MoveNext
											Wend
%>
<tr>
	<td class="tdcontent" bgcolor="#333366" align="center"><b>Grand Total</b></td>
	<td class="pcontent" align="center"><b><%=OrdTot%></b></td>
	<td class="pcontent" align="center"><b><%=ExtTot%></b></td>
	<td class="pcontent" align="center"><b><%=PriceTot%></b></td>
	<td class="pcontent" align="center"><b><%=QtyTot%></b></td>
	<!--
	<td class="pcontent" align="center"><b><%=QtyTot%></b></td>
	<td class="pcontent" align="center"><b><%=PriceTot%></b></td>-->
</tr>
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
