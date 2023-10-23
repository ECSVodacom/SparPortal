<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
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
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
	
	if ('<%=Session("UserName")%>'=='GATEWAYCALLCEN') {
		setTimeout('document.location=document.location',180000);	
	};
//-->
</script>
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim MCount
										dim TestDate
										dim NewDate
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<script language="javascript">
<!--
function blinkit(){
	intrvl=0;
	for(nTimes=0;nTimes<3;nTimes++){
	intrvl += 200;
	setTimeout("document.bgColor='#0000FF';",intrvl);
	intrvl += 200;
	setTimeout("document.bgColor='#FFFFFF';",intrvl);
   }
}
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="blinkit();">
<p class="bheader">Systems Monitor</p>
<!--<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
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
</table>-->
<%										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ReportConnection
											
											' Call the sp - listOrderTotalperday
											Set ReturnSet = ExecuteSql("procMonitorDC @MonDate=" & MakeSQLText(Request.QueryString("id")), curConnection) 
%>
<table border="0" cellspacing="1" cellpadding="2" class="tbl" width="50%">
	<tr>
		<td class="tblheader" align="center"><b>DC Name</b></td>
		<td class="tblheader" align="center"><b>Total Orders<br>per DC</b></td>
		<td class="tblheader" align="center"><b>Total Orders<br>Extracted</b></td>
		<td class="tblheader" align="center"><b>Total Orders<br>not Invoiced</b></td>
		<td class="tblheader" align="center"><b>Total Invoices/<br>Confirmations</b></td>
	</tr>
	<tr>
		<td class="tblheader" align="center" colspan="5"><b>SPAR DISTRIBUTION CENTRE (DC)</b></td>
	</tr>
<%												
												' Display the totals per DC
%>
	<tr>
		<td class="tbldata">SPAR SOUTH RAND</td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDOrdCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDOrdExtCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDNotInvCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDInvCount")%></td>
	</tr>
	<tr>
		<td class="tbldata">SPAR NORTH RAND</td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHOrdCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHOrdExtCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHNotInvCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHInvCount")%></td>
	</tr>
	<tr>
		<td class="tbldata">SPAR KWAZULU NATAL</td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLOrdCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLOrdExtCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLNotInvCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLInvCount")%></td>
	</tr>
	<tr>
		<td class="tbldata">SPAR EASTERN CAPE</td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZOrdCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZOrdExtCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZNotInvCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZInvCount")%></td>
	</tr>
	<tr>
		<td class="tbldata">SPAR WESTERN CAPE</td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTOrdCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTOrdExtCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTNotInvCount")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTInvCount")%></td>
	</tr>
<%												
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Close the connection
											curConnection.Close
											Set curConnection = Nothing
											
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_SPARDS
											
											' Call the sp - listOrderTotalperday
											Set ReturnSet = ExecuteSql("procMonitorDS @MonDate=" & MakeSQLText(Request.QueryString("id")), curConnection) 

											
%>
	<tr>
		<td class="tblheader" align="center" colspan="5"><b>SPAR DROP SHIPMENT (DS)</b></td>
	</tr>
<%												
											While not ReturnSet.EOF
%>
	<tr>
		<td class="tbldata"><%=ReturnSet("DCName")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("TotOrd")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("TotExt")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("TotNotInv")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("TotInv")%></td>
	</tr>
<%											
												ReturnSet.MoveNext
											Wend
%>
</table>
<%											
											' Close the connection
											curConnection.Close
											Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->
