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
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../includes/validation.js"></script>
<!--#include file="../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="document.FrmSearch.hidMonthName.value=document.FrmSearch.drpMonth[document.FrmSearch.drpMonth.selectedIndex].innerText;">
<%
										' Check if the user selected a month
										if Request.Form("hidAction") = "1" then
%>
<p class="bheader">Monthly Order Statistics</p>
<%										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ReportConnection
											
											' Call the sp - listOrderTotalperday
											Set ReturnSet = ExecuteSql("listOrderTotalperday @Month=" & Request.Form("drpMonth"), curConnection)    
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - display an errormessage
%>
<p class="pcontent"><b>Sorry</b></p>
<p class="errortext">There are no statistical data for the selected month. Select another month from the dropdown box and try again.</p>
<%												
											else
												' No errors
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="pcontent" align="left" class="pcontent">Below are the Distribution Centre Total EC Orders for the month of <b><%=Request.Form("hidMonthName")%></b>
			<ul>
				<li class="pcontent">Click on the <b>DC Name</b> to drill down</li>
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
		<td class="tblheader" align="center"><b>DC Name</b></td>
		<td class="tblheader" align="center"><b>Total Orders<br>per DC</b></td>
		<td class="tblheader" align="center"><b>Total Orders<br>Extracted</b></td>
		<td class="tblheader" align="center"><b>Total Price<br>Confirmations</b></td>
		<td class="tblheader" align="center"><b>Total Quantity<br>Confirmations</b></td>
	</tr>
<%												
												' Display the totals per DC
%>
	<tr>
		<td class="tbldata"><%if Session("UserName") = "GATEWAYCALLCEN" OR Session("UserName") = "SPARHEADOFFICE" OR Session("UserType") = 1 then Response.Write "<a href=" & chr(34) & const_app_ApplicationRoot & "/report/stats/rollovertots.asp?id=erd&month=" & Request.Form("drpMonth")  & chr(34) & " class=" & chr(34) & "stextnav" & chr(34) & ">SPAR SOUTH RAND</a>" else Response.Write "SPAR SOUTH RAND" end if%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDExtTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDPriceTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("ERDQtyTot")%></td>
	</tr>
	<tr>
		<td class="tbldata"><%if Session("UserName") = "GATEWAYCALLCEN" OR Session("UserName") = "SPARHEADOFFICE" OR Session("UserType") = 2 then Response.Write "<a href=" & chr(34) & const_app_ApplicationRoot & "/report/stats/rollovertots.asp?id=nth&month=" & Request.Form("drpMonth")  & chr(34) & " class=" & chr(34) & "stextnav" & chr(34) & ">SPAR NORTH RAND</a>" else Response.Write "SPAR NORTH RAND" end if%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHExtTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHPriceTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTHQtyTot")%></td>
	</tr>
	<tr>
		<td class="tbldata"><%if Session("UserName") = "GATEWAYCALLCEN" OR Session("UserName") = "SPARHEADOFFICE" OR Session("UserType") = 3 then Response.Write "<a href=" & chr(34) & const_app_ApplicationRoot & "/report/stats/rollovertots.asp?id=ntl&month=" & Request.Form("drpMonth")  & chr(34) & " class=" & chr(34) & "stextnav" & chr(34) & ">SPAR KWAZULU NATAL</a>" else Response.Write "SPAR KWAZULU NATAL" end if%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLExtTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLPriceTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("NTLQtyTot")%></td>
	</tr>
	<tr>
		<td class="tbldata"><%if Session("UserName") = "GATEWAYCALLCEN" OR Session("UserName") = "SPARHEADOFFICE" OR Session("UserType") = 4 then Response.Write "<a href=" & chr(34) & const_app_ApplicationRoot & "/report/stats/rollovertots.asp?id=plz&month=" & Request.Form("drpMonth")  & chr(34) & " class=" & chr(34) & "stextnav" & chr(34) & ">SPAR EASTERN CAPE</a>" else Response.Write "SPAR EASTERN CAPE" end if%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZExtTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZPriceTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("PLZQtyTot")%></td>
	</tr>
	<tr>
		<td class="tbldata"><%if Session("UserName") = "GATEWAYCALLCEN" OR Session("UserName") = "SPARHEADOFFICE" OR Session("UserType") = 5 then Response.Write "<a href=" & chr(34) & const_app_ApplicationRoot & "/report/stats/rollovertots.asp?id=cpt&month=" & Request.Form("drpMonth") & chr(34) & " class=" & chr(34) & "stextnav" & chr(34) & ">SPAR WESTERN CAPE</a>" else Response.Write "SPAR WESTERN CAPE" end if%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTExtTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTPriceTot")%></td>
		<td class="tbldata" align="center"><%=ReturnSet("CPTQtyTot")%></td>
	</tr>
	<tr>
		<td class="tbldata"><b>GRAND TOTAL</b></td>
		<td class="tbldata" align="center"><b><%=ReturnSet("OrdGrandTot")%></b></td>
		<td class="tbldata" align="center"><b><%=ReturnSet("ExtGrandTot")%></b></td>
		<td class="tbldata" align="center"><b><%=ReturnSet("PriceGrandTot")%></b></td>
		<td class="tbldata" align="center"><b><%=ReturnSet("QtyGrandTot")%></b></td>
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
<p><hr color="#333366"></p>
<%										
										end if
%>
<p class="bheader">Monthly Statistical Data</p>
<p class="pcontent">Select a month from the dropdown box below</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>Month:</b></td>
			<td>
				<select name="drpMonth" id="drpMonth" class="pcontent" onchange="document.FrmSearch.hidMonthName.value=document.FrmSearch.drpMonth[document.FrmSearch.drpMonth.selectedIndex].innerText;">
					<option value="-1">-- Select a Month --</option>
<%
										TestDate = DateAdd("m",-6,Date())

										For MCount = 1 to 6
											NewDate = DateAdd("m",MCount,TestDate)
%>					
					<option <%if Month(Date()) = Month(NewDate) Then Response.Write "selected" end if%> value="<%=Month(NewDate)%>"><%=Mid(FormatLongDate(NewDate,False),3,Len(FormatLongDate(NewDate,False)))%></option>
<%
										Next
%>					
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Generate" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
				<input type="hidden" name="hidMonthName" id="hidMonthName" value="">
			</td>
		</tr>
	</table>
</form>
<!--#include file="../../layout/end.asp"-->
