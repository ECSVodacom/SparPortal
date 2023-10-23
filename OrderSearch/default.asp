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
										dim txtSupplier
										
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
		// Check if the user supplied a trace #
		if ((obj.txtOrdNum.value == '')&&(obj.drpSupplier.value == '-1')) {
			window.alert('You have to select at least one of the search criteria below');
			obj.txtOrdNum.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">

<%
										' Check if the user selected to search
										if Request.Form("hidAction") = "1" or Request.QueryString("page") <> "" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ReportConnection
											
											'Response.Write "Suppl = " & Session("Suppl")
											
											if Session("Check") = 1 Then
												Session("OrderNumber") = Session("OrderNumber")
												Session("Suppl") = Session("Suppl")
												Session("SupplName") = Session("SupplName")
											end if
											
											if Request.Form("hidAction") = "1" Then
												txtSupplier = split(Request.Form("drpSupplier"),",")											
												Session("OrderNumber") = Request.Form("txtOrdNum")
												Session("Suppl") = txtSupplier(0)
												Session("SupplName") = txtSupplier(1)
											end if
											
											' check the recordbands
											if CStr(Request.QueryString("page")) = "" or IsNull(CStr(Request.QueryString("page")))	Then
												Band = 1
											else
												Band = CInt(Request.QueryString("page"))
											end if
											
											' Build the SQL
											SQL = "exec procSearch @OrderNumber=" & MakeSQLText(Session("OrderNumber")) & _
												", @SupplierID=" & Session("Suppl") & _
												", @RecordBand=" & Band & _
												", @Permission=" & Session("Permission") & _
												", @ProcID=8" & _
												", @UserType=1"

'response.Write(sql)
'response.End 
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="bheader" align="left">Search Results</td>
	</tr>
	<tr>
		<td class="pcontent"><br>Below is the search results on the following criteria:
			<ul>
				<li class="pcontent">Document Number = <b><%if Session("OrderNumber") = "" then Response.Write "Not Supplied" else Response.Write Session("OrderNumber") end if%></b></li>
				<li class="pcontent">Supplier = <b><%=Session("SupplName")%></b></li>
			</ul>
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
		<td class="pcontent"><br><font color="red"><b>ERROR:</b></font><br><br>
			&nbsp;&nbsp;&nbsp;<b>Reason: </b><%=ReturnSet("errormessage")%><br><br>
		</td>
	</tr>
</table>
<%												
											else
												' no error occured

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
												'response.Write(const_app_DCRoot & "/buyer/search/default.asp, pcontent, " & RecordCount & ", " & MaxRecords & ", " & RecordFrom & ", " & RecordTo & ", " & TotPages & ", " & Band & ", 1")
												'response.End 
												Call PageNav (const_app_ApplicationRoot & "/Ordersearch/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band,1)
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#333366">
		<td class="tdcontent" align="center"><b>Receiver Name</b><br><b>Message Format</b></td>
		<td class="tdcontent" align="center"><b>PO No</b><br><b>Receiver EAN</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI or XML</b></td>
		<td class="tdcontent" align="center"><b>Delivery to<br>Supplier<br>Mailbox</b></td>
		<td class="tdcontent" align="center"><b>Extracted<br>by<br>Supplier</b></td>
		<td class="tdcontent" align="center"><b>First Confir<br>mation</b></td>
		<td class="tdcontent" align="center"><b>Second Confir<br>mation</b></td>
	</tr>
<%												
												' Loop through the recordset
												While not ReturnSet.EOF
%>
	<tr>
		<td class="pcontent" align="center"><%=ReturnSet("SupplierName")%><br><%if IsNumeric(Replace(ReturnSet("OrderNumber"),Right(ReturnSet("OrderNumber"),4),"")) then Response.Write "EDI" else Response.Write "XML" end if%>&nbsp;<%=ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname") & " (" & ReturnSet("BuyerEAN") & ")"%></td>
		<td class="pcontent" align="center">
<%
													if ReturnSet("FirstConfirmDate") = "" or isNull(ReturnSet("FirstConfirmDate")) then	


%>
			
			<b><%=Mid(ReturnSet("OrderNumber"),1,InStr(UCase(ReturnSet("OrderNumber")),"S")-1)	%></b>
<%					
													else
%>
			<a class="textnav" target="_blank" href="<%=const_app_DCRoot%>/orders/buyer/default.asp?id=<%=ReturnSet("XMLRef")%>&amp;type=1"><%=Replace(ReturnSet("OrderNumber"),Right(ReturnSet("OrderNumber"),4),"")%></a>
<%													
													end if
%>			
			<br><%=ReturnSet("SupplierEAN")%>																			
		</td>
														
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceiveDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("MailboxDate"),true)%></td>
		<td class="pcontent" align="center">
<%
													if ReturnSet("ExtractDate") = "" or isNull(ReturnSet("ExtractDate")) then
														' Check if there is a confirmation date
														if ReturnSet("FirstConfirmDate") = "" or isNull(ReturnSet("FirstConfirmDate")) Then
															Response.Write "N/A" 
														else
															Response.Write "<b>Extracted [no date supplied]</b>"
														end if
													else 
														Response.Write FormatLongDate(ReturnSet("ExtractDate"),true) 
													end if
%>
		</td> 
		<td class="pcontent" align="center"><%if ReturnSet("FirstConfirmDate") = "" or isNull(ReturnSet("FirstConfirmDate")) then	Response.Write "N/A" else Response.Write FormatLongDate(ReturnSet("FirstConfirmDate"),true) end if%></td>
		<td class="pcontent" align="center"><%if ReturnSet("SecondConfirmDate") = "" or isNull(ReturnSet("SecondConfirmDate")) then	Response.Write "N/A" else Response.Write FormatLongDate(ReturnSet("SecondConfirmDate"),true) end if%></td>
	</tr>
<%			
													ReturnSet.MoveNext
												Wend
%>	
</table>
<%
												' Display the page navigation
												Call PageNav (const_app_ApplicationRoot & "/Ordersearch/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band,1)
												
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
<p class="bheader">Search</p>
<p class="pcontent">Enter your search criteria below to search for a specific order.</p>
<p class="pcontent"><b>Note:</b> You can search on an Order Number <b>OR</b> a Supplier Name.</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>Order Number:</b></td>
			<td><input type="text" name="txtOrdNum" id="txtOrdNum" class="pcontent"></td>
		</tr>
		</tr>
			<td class="pcontent"><b>Supplier Name:</b></td>
			<td>
				<select name="drpSupplier" id="drpSupplier" class="pcontent">
					<option selected value="-1,Not Selected">-- Select a Supplier --</option>
<%
										' Create a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ReportConnection
										
										Set ReturnSet = ExecuteSql("listUnassignSupplier", curConnection)    
										
										' Loop through the recordset
										While not ReturnSet.EOF
%>
					<option value="<%=ReturnSet("SupplierID") & "," & ReturnSet("SupplierName")%>"><%=ReturnSet("SupplierName")%></option>
<%										
											ReturnSet.MoveNext
										Wend										
										
										' Close the Connection & Recordset
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>					
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2"><br>
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Search" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
			</td>
		</tr>
	</table>
</form>
<!--#include file="../layout/end.asp"-->
