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
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Check if the what type the user selected
										if Request.QueryString("type") = "1" then
%>
<p class="bheader">Seminar Totals - Suppliers Already Accepted</p>
<%
										end if

										if Request.QueryString("id") = "" or IsNull(Request.QueryString("id")) Then
											TestDate = ""
										else
											TestDate = Request.QueryString("id")
										end if

										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_CommunityConnection
										
										' Call the sp - listNotConfirmSupplier
										Set ReturnSet = ExecuteSql("listConfirmSupplier @InviteDate=" & MakeSQLDate(TestDate), curConnection) 
									
										
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display an errormessage
%>
<p class="pcontent"><b>Sorry</b></p>
<p class="errortext">There are no Suppliers on the selected date. Please try again later.</p>
<%												
										else
											' No errors
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="pcontent" align="left" class="pcontent">Below is a list of Suppliers that have accepted the invitation on <b><%=FormatLongDate(TestDate,false)%></b>.</td>
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
		<td class="tblheader" align="center"><b>Supplier Name</b></td>
		<td class="tblheader" align="center"><b>EPOCSA<br>Signed</b></td>
		<td class="tblheader" align="center"><b>Database<br>Updated</b></td>
		<td class="tblheader" align="center"><b>Data<br>Aligned</b></td>
		<td class="tblheader" align="center"><b>Sign Off</b></td>
	</tr>
<%												
											' Loop through the recordset
											While not ReturnSet.EOF
%>
	<tr>
		<td class="tbldata"><%=ReturnSet("SupplierName")%></td>
		<td class="tbldata" align="center"><%if ReturnSet("Epocsa") = 1 then Response.Write "<b>Yes</b>" else Response.Write "<b class='errortext'>No</b>" end if%></td>
		<td class="tbldata" align="center"><%if ReturnSet("DBUpdate") = 1 then Response.Write "<b>Yes</b>" else Response.Write "<b class='errortext'>No</b>" end if%></td>
		<td class="tbldata" align="center"><%if ReturnSet("DataAlign") = 1 then Response.Write "<b>Yes</b>" else Response.Write "<b class='errortext'>No</b>" end if%></td>
		<td class="tbldata" align="center"><%if ReturnSet("SignOff") = 1 then Response.Write "<b>Yes</b>" else Response.Write "<b class='errortext'>No</b>" end if%></td>
	</tr>
<%												
												ReturnSet.MoveNext
											Wend
%>
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
