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
		top.location.href = "<%=const_app_ApplicationRoot%>";
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
										dim GrandTotInvited
										dim GrandTotConfirm
										dim GrandTotUnConfirm
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<p class="bheader">Seminar Totals - Phase 2</p>
<%										
	
									
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_CommunityConnection
										
									
										' Call the sp - listOrderTotalperday
										Set ReturnSet = ExecuteSql("procSeminarTotalPhase2 @DCID=" & Request.QueryString("dc"), curConnection)   
										
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display an errormessage
%>
<p class="pcontent"><b>Sorry</b></p>
<p class="errortext">There are no seminar totals available. Please try again later.</p>
<%												
										else
											' No errors
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="pcontent" align="left" class="pcontent">Below is a list of totals per seminar date
			<ul>
				<li class="pcontent">Click on the <b>Total Invited</b> coloum to list the Supplier Invited to the relevant seminar</li>
				<li class="pcontent">Click on the <b>Total Unconfirmed</b> coloum to drill down on the list of suppliers that did not accepted the invitation yet</li>
				<li class="pcontent">Click on the <b>Total Confirmed</b> coloum to drill down on the list of suppliers that have accepted the invitation</li>
			</ul>
		</td>
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
											' Display the grand total orders for the selected month
%>
<table border="0" cellspacing="1" cellpadding="2" class="tbl">
	<tr>
		<td class="tblheader" align="center"><b>Seminar Date</b></td>
		<td class="tblheader" align="center"><b>Total Invited</b></td>
		<td class="tblheader" align="center"><b>Total Unconfirmed</b></td>
		<td class="tblheader" align="center"><b>Total Confirmed</b></td>
	</tr>
<%												
											' Display the totals per DC
											GrandTotInvited = 0
											GrandTotUnConfirm = 0
											GrandTotConfirm = 0
											
											' Loop through the recordset
											While not ReturnSet.EOF
												GrandTotInvited = GrandTotInvited + ReturnSet("TotInvited")
												GrandTotUnConfirm = GrandTotUnConfirm + ReturnSet("TotUnConfirm")
												GrandTotConfirm = GrandTotConfirm + ReturnSet("TotConfirm")
%>
	<tr>
		<td class="tbldata"><%=FormatLongDate(ReturnSet("InviteDate"),False)%></td>
		<td class="tbldata" align="center"><a class="diffnav" href="<%=const_app_ApplicationRoot%>/report/seminar_phase2/notconfirm.asp?id=<%=ReturnSet("InviteDate")%>&type=2&dc=<%=Request.QueryString("dc")%>"><%=ReturnSet("TotInvited")%></a></td>
		<td class="tbldata" align="center"><%if ReturnSet("TotUnConfirm") <> 0 then%><a class="diffnav" href="<%=const_app_ApplicationRoot%>/report/seminar_phase2/notconfirm.asp?id=<%=ReturnSet("InviteDate")%>&type=1&dc=<%=Request.QueryString("dc")%>"><%=ReturnSet("TotUnConfirm")%></a><%else Response.Write ReturnSet("TotConfirm") end if%></td>
		<td class="tbldata" align="center"><%if ReturnSet("TotConfirm") <> 0 then%><a class="diffnav" href="<%=const_app_ApplicationRoot%>/report/seminar_phase2/confirm.asp?id=<%=ReturnSet("InviteDate")%>&type=1&dc=<%=Request.QueryString("dc")%>"><%=ReturnSet("TotConfirm")%></a><%else Response.Write ReturnSet("TotConfirm") end if%></td>
	</tr>
<%												
												ReturnSet.MoveNext
											Wend
%>
	<tr>
		<td class="tbldata"><b>Totals</b></td>
		<td class="tbldata" align="center"><b><%=GrandTotInvited%></b></td>
		<td class="tbldata" align="center"><b><%=GrandTotUnConfirm%></b></td>
		<td class="tbldata" align="center"><b><%=GrandTotConfirm%></b></td>
	</tr>
</table>
<%
										' Close the recordset
										Set ReturnSet = Nothing
											
										end if
											
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../../layout/end.asp"-->
