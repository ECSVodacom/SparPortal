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
										dim strDC
										dim strDCName
										dim strBuyerName
										dim strSupplierName
										dim trcolor
										
										Select Case Session("UserType")
										Case 1
											strDC = "ERD"
										Case 2
											strDC = "NTH"
										Case 3
											strDC ="NTL"
										Case 4
											strDC = "PLZ"
										Case 5
											strDC = "CPT"
										Case Else
											strDC = ""
										End Select
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
<p class="bheader">Supplier Performance: Results</p>
<%										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ReportConnection
											
											' Call the sp - listOrderTotalperday
											Set ReturnSet = ExecuteSql("listSupplierPerform @Month=" & Request.Form("drpMonth") & ", @DC=" & MakeSQLText(strDC), curConnection)  
 
											
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - display an errormessage
%>
<p class="pcontent"><b>Sorry</b></p>
<p class="errortext">There are no repformance results for the selected month. Select another month from the dropdown box and try again.</p>
<%												
											else
												' No errors
%>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="pcontent" align="left" valign="top" class="pcontent">Below is the list of Buyers and their Suppliers that did not extract their Orders for the month of <b><%=Request.Form("hidMonthName")%></b> per Distribution Centre</td>
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
<table border="1" cellspacing="0" cellpadding="2">
	<!--<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>DC Name</b></td>
		<td class="tdcontent" align="center"><b>Buyer Name</b></td>
		<td class="tdcontent" align="center"><b>Supplier Name</b></td>
	</tr>-->
<%												
												strDCName = ""
												strBuyerName = ""
												strSupplierName = ""	
												trcolor = "#cccccc"
												
												' Display the details
												While not ReturnSet.EOF
											
													if ReturnSet("DCName") <> strDCName then
%>
	<tr bgcolor="<%=trcolor%>">
		<td class="pcontent" colspan="2" align="center"><b><%=ReturnSet("DCName")%></b></td>
	</tr>
	<tr>
		<td colspan="2"></td>
	</tr>
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Buyer Name</b></td>
		<td class="tdcontent" align="center"><b>Supplier Name</b></td>
	</tr>
<%													
													end if
													
													if ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname") <> strBuyerName then
%>
	<tr>
		<td class="pcontent"><b><%=ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname")%></b></td>
<%
													else
%>
		<td class="pcontent">&nbsp;</td>
<%														
													end if
													
													if ReturnSet("SupplierName") <> strSupplierName then
%>		
		<td class="pcontent"><%=UCase(ReturnSet("SupplierName"))%></td>
<%	
													end if
%>
	</tr>
<%																										
													strDCName = ReturnSet("DCName")
													strBuyerName = ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname")
													strSupplierName = ReturnSet("SupplierName") 
													
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
<p><hr color="#333366"></p>
<%										
										end if
%>
<p class="bheader">Supplier Performace</p>
<p class="pcontent">Select a month from the dropdown box below</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>Month:</b></td>
			<td>
				<select name="drpMonth" id="drpMonth" class="pcontent" onchange="document.FrmSearch.hidMonthName.value=document.FrmSearch.drpMonth[document.FrmSearch.drpMonth.selectedIndex].innerText;">
					<option value="-1">-- Select a Month --</option>
<%
										TestDate = DateAdd("m",-2,Date())

										For MCount = 1 to 2
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
