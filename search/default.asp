<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
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
										
										Select Case Session("UserType")
										Case 1
											FolderName = "supplier"
											UserID = Session("ProcID")
											UserType = 1
										Case 2
											FolderName = "dc"
											UserID = 0
											UserType = 2
										Case 3
											FolderName = "store"									
											UserID = Session("ProcID")
											UserType = 3
										End Select
										
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/validation.js"></script>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	function validate(obj) {
		// Check if the user selected a search type
		if (obj.drpType.value == '-1') {
			window.alert('You have to select a search type.');
			obj.drpType.focus();
			return false;
		};
		
		// Check if this is a valid date
		if (obj.txtDate.value!='') {
			if (chkdate(obj.txtDate) == false) {
				obj.txtDate.select();
				window.alert('Please enter a valid date.');
				obj.txtDate.focus();
				return false;
			};
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/frmcontent.asp?action=1&amp;id=<%=Request.QueryString("id")%>" class="NavLink" target="frmcontent">Orders</a></td>
		<td class="NavLink" bgcolor="#333366" align="center">
			<a href="<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/frmcontent.asp?action=2&amp;id=<%=Request.QueryString("id")%>" class="NavLink" target="frmcontent">Electronic Invoices</a>
<%
										if Session("UserType") = 1 AND IsNumeric(Session("ProcEAN")) = False then
%>
			&nbsp;|&nbsp;<a href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/new.asp', 'GenInvoice', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');" class="NavLink" target="frmcontent">Generate Blank Invoice</a>
<%										
										end if
%>		
			
		</td>
		<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/search/default.asp?id=<%=Request.QueryString("id")%>" class="NavLink" target="frmcontent">Search</a></td>
	</tr>
</table><br>
<%
										' Check if the user selected to search
										if Request.Form("hidAction") = "1" or Request.QueryString("page") <> "" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
																					
											'	Set the session variables
											if Session("Check") = 1 Then
												Session("SearcType") = Session("SearcType")
												Session("TraceNumber") = Session("TraceNumber")
												Session("SupplierID") = Session("SupplierID")
												Session("SupplierName") = Session("SupplierName")
												Session("StoreID") = Session("StoreID")
												Session("StoreName") = Session("StoreName")
												Session("Date") = Session("Date")
											end if
												
											if Request.Form("hidAction") = "1" Then
												txtSupplier = split(Request.Form("drpSupplier"),",")
												txtStore = split(Request.Form("drpStore"),",")
												
												Session("Check") = 1
												Session("SearcType") = Request.Form("drpType")
												Session("TraceNumber") = Request.Form("txtTraceNum")
												Session("SupplierID") = txtSupplier(0)
												Session("SupplierName") = txtSupplier(1)
												Session("StoreID") = txtStore(0)
												Session("StoreName") = txtStore(1)
												Session("Date") = Request.Form("txtDate")
											end if
											
											' check the recordbands
											if CStr(Request.QueryString("page")) = "" or IsNull(CStr(Request.QueryString("page")))	Then
												Band = 1
											else
												Band = CInt(Request.QueryString("page"))
											end if
											
											' Build the SQL
											SQL = "procSearch_New @SearchType=" & Session("SearcType") & _
												", @TraceNumber=" & MakeSQLText(Session("TraceNumber")) & _
												", @SupplierID=" & Session("SupplierID") & _
												", @StoreID=" & Session("StoreID") & _
												", @Date=" & MakeSQLText(Session("Date")) & _
												", @RecordBand=" & Band 
												
												'Response.Write SQL
	
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
					<td class="pcontent"><br>Below is the search results on the following criteria:
						<ul>
							<li class="pcontent">Search Type = <b><%if Session("SearcType") = 1 then Response.Write "Order/s" else Response.Write "Invoice/s" end if%></b></li>
							<li class="pcontent">Document Number = <b><%if Session("TraceNumber") = "" then Response.Write "Not Supplied" else Response.Write Session("TraceNumber") end if%></b></li>
							<li class="pcontent">Supplier = <b><%=Session("SupplierName")%></b></li>
							<li class="pcontent">Store = <b><%=Session("StoreName")%></b></li>
							<li class="pcontent">Date = <b><%if Session("Date") = "" then Response.Write "Not Supplied" else Response.Write Session("Date") end if%></b></li>
						</ul>
					</td>
				</tr>
			</table>
		</td>
		<td class="pcontent" align="right" valign="top" rowspan="3">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="pcontent" valign="middle">
						<a class="stextnav" href="javascript:window.print();"><img src="<%=const_app_ApplicationRoot%>/layout/images/print_new.gif" border="0" alt="Print this page..."/>&#160;Print this page</a><br/>
						<a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/includes/help.asp', 'Help', 'width=300,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="<%=const_app_ApplicationRoot%>/layout/images/help.gif" border="0" alt="Help..."/>&#160;Help</a><br/>
						<a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/includes/bugreport.asp', 'BugReport', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="<%=const_app_ApplicationRoot%>/layout/images/bug.gif" border="0" alt="Report a Bug..."/>&#160;Report a Bug</a><br>
						<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) self.parent.location.href='<%=const_app_ApplicationRoot%>/logout/';"><img src="<%=const_app_ApplicationRoot%>/layout/images/logout.gif" border="0" alt="Logout..."/>&#160;Logout</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<%
											' Check the returnvalue
											if ReturnSet("returnvalue") < 0 then
												' an error occured - display
%>
<table border="0" cellpadding="0" cellspacing="0" bordercolor="red">
	<tr>
		<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilicry.gif"></td>
		<td class="pcontent" valign="middle"><font color="red"><b>No match found: Select an alternative search criteria.</b></font></td>
	</tr>
</table>
<%												
											else
												' no error occured
%>
<table border="0" cellpadding="2" cellspacing="2" bordercolor="red">
	<tr>
		<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif"></td>
		<td class="pcontent" valign="middle"><b>Note:</b> Click on the Order Number link to view the Order details and /or click on the Invoice number to view the invoice details.</td>
	</tr>
</table>
<%
												' Set the variables
												RecordCount = ReturnSet("RecordCount")
												MaxRecords = ReturnSet("MaxRecords")
												RecordFrom = ReturnSet("RecordFrom")
												RecordTo = ReturnSet("RecordTo")
												BandSize = ReturnSet("BandSize")
												
												' Calculate the number of pages - Call function CalcNumPages
												TotPages = CalcNumPages(MaxRecords, BandSize)

												' Display the page head navigation
												Call PageHeadNav ("pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo)
												
												' Display the page navigation
												Call PageNav (const_app_ApplicationRoot & "/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))

												if Session("SearcType") = 1 Then												
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Order Number</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI/XML</b></td>
		<td class="tdcontent" align="center"><b>Delivered to<br>Mailbox</b></td>
		<td class="tdcontent" align="center"><b>Extracted by<br> Supplier</b></td>
		<td class="tdcontent" align="center"><b>Invoice Generated<br> by Supplier</b></td>
		<td class="tdcontent" align="center"><b>Invoices</b></td>
	</tr>
<%
												else
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Invoice Number</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI/XML</b></td>
		<td class="tdcontent" align="center"><b>Posted to<br>Comms Centre</b></td>
		<td class="tdcontent" align="center"><b>Order Number</b></td>
	</tr>
<%												
												end if
												' Loop through the recordset
												While not ReturnSet.EOF
													if Session("SearcType") = 1 Then	
														OrdNum = split(ReturnSet("OrderNumber"),".")
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/order/default.asp?item=<%=ReturnSet("TraceID")%>', 'OrderDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=OrdNum(0)%></a></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceiveDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("MailboxDate"),true)%></td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("ExtractDate") = "" or isNull(ReturnSet("ExtractDate")) then
															' Check if there is a confirmation date
															if ReturnSet("InvoiceDate") = "" or isNull(ReturnSet("InvoiceDate")) Then
																Response.Write "-" 
															else
																Response.Write "<b>Extracted [no date supplied]</b>"
															end if
														else 
															Response.Write FormatLongDate(ReturnSet("ExtractDate"),true) 
														end if
%>
		</td> 
		<td class="pcontent" align="center"><%if ReturnSet("InvoiceDate") = "" or isNull(ReturnSet("InvoiceDate")) then	Response.Write "-" else Response.Write FormatLongDate(ReturnSet("InvoiceDate"),true) end if%></td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("InvoiceNumber") = 0 then	
															Response.Write "-" 
														else 
															'Response.Write ReturnSet("InvoiceNumber")
%>
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/list.asp?item=<%=ReturnSet("TraceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');">list invoices</a>
		</td>
	</tr>
<%			
														end if
													else
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/default.asp?item=<%=ReturnSet("InvoiceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("InvoiceNumber")%></a></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceiveDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("PostDate"),true)%></td>
		<td class="pcontent" align="center">
<%
														if Trim(ReturnSet("OrderNumber")) = "" or isNull(ReturnSet("OrderNumber")) Then
															Response.Write "-"
														else
															OrdNum = split(ReturnSet("OrderNumber"),".")
%>			
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/order/default.asp?item=<%=ReturnSet("TraceID")%>', 'OrderDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=OrdNum(0)%></a>
		</td>
<%														
														end if
													end if									
												
													ReturnSet.MoveNext
												Wend
%>	
</table>
<%
											' Display the page navigation
											Call PageNav (const_app_ApplicationRoot & "/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))
												
											end if
											
											' Close the recordset
											Set ReturnSet = Nothing
%>
<p><hr></p>
<%											
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										end if
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="bheader" align="left">Search</td>
				</tr>
				<tr>
					<td class="pcontent" align="left"><br>Enter search criteria below.</td>
				</tr>
				<tr>
					<td class="pcontent" align="left"><b>Note:</b> Fields marked with <b>[*]</b> are mandatory.</td>
				</tr>
			</table>
		</td>
		<td class="pcontent" align="right" valign="top" rowspan="3">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td class="pcontent" valign="middle">
						<a class="stextnav" href="javascript:window.print();"><img src="<%=const_app_ApplicationRoot%>/layout/images/print_new.gif" border="0" alt="Print this page..."/>&#160;Print this page</a><br/>
						<a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/includes/help.asp', 'Help', 'width=300,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="<%=const_app_ApplicationRoot%>/layout/images/help.gif" border="0" alt="Help..."/>&#160;Help</a><br/>
						<a class="stextnav" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/includes/bugreport.asp', 'BugReport', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="<%=const_app_ApplicationRoot%>/layout/images/bug.gif" border="0" alt="Report a Bug..."/>&#160;Report a Bug</a><br>
						<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) self.parent.location.href='<%=const_app_ApplicationRoot%>/logout/';"><img src="<%=const_app_ApplicationRoot%>/layout/images/logout.gif" border="0" alt="Logout..."/>&#160;Logout</a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<!--<p class="bheader">Search</p>
<p class="pcontent">Enter search criteria below.</p>
<p class="pcontent"><b>Note:</b> Fields marked with <b>[*]</b> are mandatory.</p>-->
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Search Type:</b></td>
			<td>
				<select name="drpType" id="drpType" class="pcontent">
					<option value="-1">-- Select a Search Type --</option>
					<option value="1">Order/s</option>
					<option value="2">Invoice/s</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Document Number:</b></td>
			<td><input type="text" name="txtTraceNum" id="txtTraceNum" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Supplier:</b></td>
			<td>
				<select name="drpSupplier" id="drpSupplier" class="pcontent">
					<option value="-1,Not Selected">-- Select a Supplier --</option>
<%
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										Set ReturnSet =  ExecuteSql("listSupplier @SupplierID=" & UserID & ", @UserType=" & UserType, curConnection)   
													
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											if UserID = ReturnSet("SupplierID") Then
												Selected = "selected"
											else
												Selected = ""
											end if
%>
					<option <%=Selected%> value="<%=ReturnSet("SupplierID")%>,<%=ReturnSet("SupplierName")%>"><%=ReturnSet("SupplierName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Store:</b></td>
			<td>
				<select name="drpStore" id="drpStore" class="pcontent">
					<option value="-1,Not Selected">-- Select a Store --</option>
<%
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										Set ReturnSet = ExecuteSql("listStores @SupplierID=" & UserID & ", @UserType=" & UserType, curConnection)   
										
							
													
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											if UserID = ReturnSet("StoreID") and UserType = 3 Then
												Selected = "selected"
											else
												Selected = ""
											end if
%>
					<option <%=Selected%> value="<%=ReturnSet("StoreID")%>,<%=ReturnSet("StoreName")%>"><%=ReturnSet("StoreName")%></option>
<%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Date:</b></td>
			<td class="pcontent"><input type="text" name="txtDate" id="txtDate" size="10" class="pcontent">&nbsp;<b>[dd/mm/yyyy]</b></td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Search" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
			</td>
		</tr>
	</table>
</form>
<!--#include file="../layout/end.asp"-->
