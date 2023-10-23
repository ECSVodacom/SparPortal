<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	Dim NewDate, Folder
	Dim cnObj, SqlSelect, rsObj
	Dim CurrentPageNumber 
	
	CurrentPageNumber = 1
	
	if Request.QueryString("id") = "" Then
		NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
	else
		NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
	end if
	Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate)
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	Set rsObj = Server.CreateObject("ADODB.Recordset")
	cnObj.Open const_db_ConnectionString
	
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		Dim ValuesArray, SearchTypeId, SearchTypeDisplay
		Dim SearchDCId, SearchDCName
		Dim SearchSupplierId, SearchSupplierName, SearchSupplierVendorCode
		Dim DocumentNumber 
		Dim FromDate, ToDate
		
		CurrentPageNumber = Request.Form("CurrentPageNumber")
		
		ValuesArray = Split(Request.Form("cboSearchType"),",")
		SearchTypeId = ValuesArray(0)
		SearchTypeDisplay = ValuesArray(1)
		
		
		
		DocumentNumber = Replace(Request.Form("txtDocumentNumber"),"'","''")
		
		SearchDCId = Split(Request.Form("cboDC"),",")(0)
		SearchDCName = Split(Request.Form("cboDC"),",")(1)

		SearchSupplierId = Split(Request.Form("cboSupplier"),",")(0)
		SearchSupplierName = Split(Request.Form("cboSupplier"),",")(1)
		SearchSupplierVendorCode =Split(Request.Form("cboSupplier"),",")(2)
		
		
		FromDate = Request.Form("txtFromDate") 
		ToDate = Request.Form("txtToDate") 
%>
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<br/><br/>
					<td class="bheader" align="left">Search Results</td>
				</tr>
				<tr>
					<td class="pcontent"><br>Below is the search results on the following criteria:
						<ul>
							<li class="pcontent">Search Type = <b><%=SearchTypeDisplay%></b></li>
							<li class="pcontent">Document Number = <b><%if DocumentNumber = "" then Response.Write "Not Supplied" else Response.Write DocumentNumber end if%></b></li>
							<li class="pcontent">DC = <b><%=SearchDCName%></b></li>
							<li class="pcontent">Supplier = <b><%=SearchSupplierName%></b></li>
							<li class="pcontent">From Date = <b><%if FromDate = "" then Response.Write "Not Supplied" else Response.Write FromDate  end if%></b></li>
							<li class="pcontent">To Date = <b><%if ToDate = "" then Response.Write "Not Supplied" else Response.Write ToDate  end if%></b></li>
						</ul>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
		<%
		Dim FromDateArray, ToDateArray
		Dim SearchFromDate, SearchToDate
		FromDateArray = Split(Request.Form("txtFromDate"),"/")
		If (UBound(FromDateArray) > 0 ) Then
			SearchFromDate = FromDateArray(2) & "-" & FromDateArray(1) & "-" & FromDateArray(0)
		Else
			SearchFromDate =  ""
		End If
		
		ToDateArray = Split(Request.Form("txtToDate"),"/")
		If (UBound(ToDateArray) > 0 )  Then
			SearchToDate = ToDateArray(2) & "-" & ToDateArray(1) & "-" & ToDateArray(0)
		Else
			SearchToDate = ""
		End If
		
		Dim IsSSBU
		IsSSBU = 0
		
		If Mid(Session("UserName"),1,4)= "SSBU" Then
			IsSSBU = 1
		End If
		
		If CurrentPageNumber = "" Then CurrentPageNumber = 1
		SqlSelect = "Search @SearchTypeId=" & SearchTypeId _
			& ", @DocumentNumber='" & DocumentNumber & "'" _
			& ", @DcId=" & SearchDCId  _
			& ", @SupplierId=" & SearchSupplierId _
			& ", @FromDate=" & MakeSQLText(SearchFromDate) _
			& ", @ToDate=" & MakeSQLText(SearchToDate) _
			& ", @PageNumber=" & CurrentPageNumber _
			& ", @IsSSBU="  & IsSSBU
		Response.Write SqlSelect 
		
		Set rsObj = ExecuteSql(SqlSelect, cnObj)  
		If Not (rsObj.BOF And rsObj.EOF) Then
		%>
		<table border="0" cellpadding="2" cellspacing="2" bordercolor="red">
			<tr>
				<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif"></td>
				<td class="pcontent" valign="middle"><b>Note:</b> Click on the <%=SearchTypeDisplay%> link to view the details</td>
			</tr>
		</table>

		<p class="pcontent">
			Displaying <b><%
				Dim ActualCount 
				ActualCount = rsObj("RecordCount") - rsObj("RecordsFrom")  + 1
				If ActualCount < rsObj("PageSize")  Then
					Response.Write ActualCount
				Else
					Response.Write  rsObj("PageSize") 
				End If
			
			%></b> records out of a total of <b><%=rsObj("RecordCount")%></b> records.<br/>
			Records <b><%=rsObj("RecordsFrom")%></b> to <b><%
				If rsObj("RecordsTo") > rsObj("RecordCount") Then
					Response.Write rsObj("RecordCount")
				Else
					Response.Write rsObj("RecordsTo")
				End If
			%></b> is currently displayed.
		</p>
		<p class="pcontent">
			<a class="stextnav" href="javascript:fSetPage(1);">First Page |</a>
		
		<%
			Dim iPage , DisplayPageRangeFrom, DisplayPageRangeTo
			Dim PreviousPageNumber, NextPageNumber
			
			PreviousPageNumber = CurrentPageNumber - 1
			NextPageNumber = CurrentPageNumber + 1
		
			If NextPageNumber <= rsObj("TotalPages")  Then
		%>
			<a class="stextnav" href="javascript:fSetPage(<%=NextPageNumber%>);">Next Page |</a>
		<%
			End If
			
			'DisplayPageRangeFrom = 1
			'DisplayPageRangeTo = 5		
			
			DisplayPageRangeFrom = CurrentPageNumber - 2
			DisplayPageRangeTo = CurrentPageNumber + 2
			
			If DisplayPageRangeFrom < 1 Then
				DisplayPageRangeTo = 5
				DisplayPageRangeFrom = 1
			End If
			
			If CInt(DisplayPageRangeTo) > CInt(rsObj("TotalPages")) Then
				DisplayPageRangeTo = rsObj("TotalPages") 
				DisplayPageRangeFrom = DisplayPageRangeTo - 4
				If DisplayPageRangeFrom < 0 Then DisplayPageRangeFrom = 1
			End If
			
			For iPage = DisplayPageRangeFrom To DisplayPageRangeTo
				If CInt(iPage) = CInt(CurrentPageNumber) Then 
				
				%>
					<b>Page <%=iPage%> |</b>
				<%
				ElseIf iPage>0 Then
				%>
					<a class="stextnav" href="javascript:fSetPage(<%=iPage%>);">Page <%=iPage%> |</a>
				<%
				End If
			Next
			
			If PreviousPageNumber > 0 Then
		%>
			<a class="stextnav" href="javascript:fSetPage(<%=PreviousPageNumber%>);">Previous Page |</a>
		<%
			End If
		%>	
			<a class="stextnav" href="javascript:fSetPage(<%=rsObj("TotalPages")%>);">Last Page</a>
		</p>
<!--<hr>-->
	<%
			Dim BuyerOrSupplier
			If Session("UserType") = 1 Then
				BuyerOrSupplier = "buyer"
			ElseIf Session("UserType") = 2 Then
				BuyerOrSupplier = "supplier"
			End If
		
			Select Case SearchTypeId
				Case 1 ' Search orders
		%>
					<table border="1" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#4C8ED7">
						
						<td class="tdcontent" align="center"><b>Received Name</td>
						<td class="tdcontent" align="center"><b>PO No<br/>Receiver EAN</b></td>
						<td class="tdcontent" align="center"><b>File<br/>Received<br/>by Gateway</b></td>
						<td class="tdcontent" align="center"><b>Translation<br/>To<br/>EDI or XML</b></td>
						<td class="tdcontent" align="center"><b>Delivery to<br/>Supplier<br/>Mailbox</b></td>
						<td class="tdcontent" align="center"><b>Extracted<br/>by<br/>Supplier</b></td>
						<td class="tdcontent" align="center"><b>Options</b></td>
						
					</tr>
				<%
					While Not rsObj.EOF
				%>
					<tr>
						<td class="pcontent" align="center"><%=rsObj("ReceiverName")%></td>
						<td class="pcontent" align="center"><%=rsObj("OrderNumber")%><br/><%=rsObj("ReceiverEan")%></td>
						<td class="pcontent" align="center"><%=rsObj("ReceivedByGateway")%></td>
						<td class="pcontent" align="center"><%=rsObj("TranlationToEdi")%></td>
						<td class="pcontent" align="center"><%=rsObj("DeliveryToMailbox")%></td>
						<td class="pcontent" align="center"><%=rsObj("ExtractedBySupplier")%></td>
						<td class="pcontent" align="center"><a target="_blank" href="<%=const_app_ApplicationRoot%>/orders/<%=BuyerOrSupplier%>/default.asp?id=<%=rsObj("XMLRef")%>&type=1&check=0&doAction=view">View</a></td>
					</tr>
				<%
						rsObj.MoveNext
					Wend
				%>
					</table>
				<%					
				Case 2 ' Search remittances
			
				%>
					<table border="1" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#4C8ED7">
						<td class="tdcontent" align="center"><b>DC</b></td>
						<td class="tdcontent" align="center"><b>Supplier</b></td>
						<td class="tdcontent" align="center"><b>RA Date</b></td>
						<td class="tdcontent" align="center"><b>Payment Number</b></td>
						<td class="tdcontent" align="center"><b>RA Type</b></td>
						<td class="tdcontent" align="center"><b>Recieved By Gateway</b></td>
						<td class="tdcontent" align="center"><b>Options</b></td>
					</tr>
				<%
					While Not rsObj.EOF
				%>
					<tr>
						<td class="pcontent" align="center"><%=rsObj("DCName")%></td>
						<td class="pcontent" align="center"><%=rsObj("SupplierName")%></td>
						<td class="pcontent" align="center"><%=rsObj("RADate")%></td>
						<td class="pcontent" align="center"><%=rsObj("PaymentNumber")%></td>
						<td class="pcontent" align="center"><%=rsObj("RAType")%></td>
						<td class="pcontent" align="center"><%=rsObj("CreatedAt")%></td>
						<td class="pcontent" align="center">
							<a target="_blank" href="<%=const_app_ApplicationRoot%>/tracktrace/<%=BuyerOrSupplier%>/viewDownload.asp?rid=<%=Replace(Replace(rsObj("Id"),"}",""),"{","")%>">Download options</a>
							<br/>
							<a target="_blank" href="<%=const_app_ApplicationRoot%>/remittanceadvice/viewreport.aspx?id=<%=Replace(Replace(rsObj("Id"),"}",""),"{","")%>">View report</a>
						</td>
					</tr>
				<%
						rsObj.MoveNext
					Wend
				%>
				
				
					</table>
				<%
				Case 3 '  Search SSBU Invoices
				%>
					<table border="1" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#4C8ED7">
						
						
						<td class="tdcontent" align="center"><b>Invoice Number</td>
						<td class="tdcontent" align="center"><b>Invoice<br/>Date</b></td>
						<td class="tdcontent" align="center"><b>Invoice<br/>Received<br/>by Gateway</b></td>
						<td class="tdcontent" align="center"><b>Translation<br/>To<br/>EDI or XML</b></td>
						<td class="tdcontent" align="center"><b>Delivery to<br/>Supplier<br/>Mailbox</b></td>
						<td class="tdcontent" align="center"><b>Posted<br/>Date</b></td>
						
						
					</tr>
				<%
					While Not rsObj.EOF
				%>
					<tr>
						
						<td class="pcontent" align="center"><a target="_blank" href="<%=const_app_ApplicationRoot%>/tracktrace/buyer/invoice/default.asp?item=<%=rsObj("INID")%>&amp;success=0"><%=rsObj("IncInvoiceNumber")%></a></td>
						<td class="pcontent" align="center"><%=rsObj("INdInvoiceDate")%></td>
						<td class="pcontent" align="center"><%=rsObj("INdReceivedDate")%></td>
						<td class="pcontent" align="center"><%=rsObj("INdTranslateDate")%></td>
						<td class="pcontent" align="center"><%=rsObj("INdRecDcBackDate")%></td>
						<td class="pcontent" align="center"><%=rsObj("INdPostDate")%></td>
						
						
					</tr>
				<%
						rsObj.MoveNext
					Wend
				%>
					</table>
					
				<%					
			End Select
		Else
		%>
		<table border="0" cellpadding="0" cellspacing="0" bordercolor="red">
			<tr>
				<td class="pcontent" valign="top"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilicry.gif"></td>
				<td class="pcontent" valign="middle"><font color="red"><b>No match found: Select an alternative search criteria.</b></font></td>
			</tr>
		</table>
		<%
		End If
	Else
		Response.Write "<br/><br/>"
	End If
	
	
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
.ui-datepicker-trigger { position:absolute; height:16px; cursor: pointer }
 </style>
 <script>
  $( function() {
		$("#cboDC").change(function() {
			$.getJSON("getsuppliers.asp",{ dcId: $(this).val().split(',')[0] }, function(s) {
				var options = '';
				
				for (var idx = 0; idx < s.length; idx++) {
					options += '<option value="' + s[idx].SPID + ',' + s[idx].VendorName + ',' + s[idx].VendorCode + '">' + s[idx].Vendor + '</option>'
				}

				$("#cboSupplier").html(options);
			});
		});
  
  
		$("#btnReset").click(function() {
			$("#cboSearchType").val("0,Select a Search Type");
			$("#txtDocumentNumber").val("");
			$("#txtFromDate").val("");
			$("#txtToDate").val("");
			$("#CurrentPageNumber").val("1");
		});
		
		$(document).on('input',function () { 
			$("#CurrentPageNumber").val("1");
		});
		
		
		$.datepicker.setDefaults({
			showOn: 'button', 
			buttonImage: 'calendar.gif', 
			buttonImageOnly: true,
			dateFormat:"dd/mm/yy",
			changeMonth:true,
			changeYear:true
		});

		$( "#txtFromDate" ).datepicker(
		{
			onSelect: function(selectedDate) {
				$('#txtToDate').datepicker('option', 'minDate', selectedDate);
				$("#CurrentPageNumber").val("1");
			}
		});

		$( "#txtToDate" ).datepicker(
		{
			onSelect: function(selectedDate) {
				$('#txtFromDate').datepicker('option', 'maxDate', selectedDate);
				$("#CurrentPageNumber").val("1");
			}
		});
	});
  </script>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	function validate(obj) {
		// Check if the user selected a search type
		if (obj.cboSearchType.value.split(',')[0] == '0') {
			window.alert('You have to select a search type.');
			obj.cboSearchType.focus();
			return false;
		};
		
		
	};
	
	function fSetPage(pagenumber)
	{
		document.FrmSearch.elements['currentPageNumber'].value = pagenumber;
		window.document.FrmSearch.submit();
	}
//-->
</script>
<!--#include file="../../layout/headclose.asp"-->
<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp" onsubmit="return validate(this);" autocomplete="off">
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<td align="left">
				<table border="0" cellpadding="2" cellspacing="2">
					<tr>
						<td class="bheader" align="left">Search</td><td><div id="loading" class="pcontent" style="display:none">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img style=" vertical-align:middle; text-align:center" src="ajax-loader.gif"  height="21" width="21" alt="Loader"/><br />Loading...please wait.</div></td>
					</tr>
					<tr>
						<td class="pcontent" align="left"><br>Enter search criteria below.</td>
					</tr>
					<tr>
						<td class="pcontent" align="left"><b>Note:</b> Fields marked with <b>[*]</b> are mandatory.</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Search Type:</b></td>
			<td>
				<select name="cboSearchType" id="cboSearchType" class="pcontent">
					<option value="0,Select a Search Type">-- Select a Search Type --</option>
					<option <%If SearchTypeId = 1 Then Response.Write "selected=""selected""" End If%>value="1,Order/s">Order/s</option>
					<option <%If SearchTypeId = 2 Then Response.Write "selected=""selected""" End If%>value="2,Electronic Remittance Advices">Electronic Remittance Advices</option>
					<option <%If SearchTypeId = 3 Then Response.Write "selected=""selected""" End If%>value="3,SSBU Invoices">SSBU Invoices</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Document Number:</b></td>
			<td><input type="text" name="txtDocumentNumber" id="txtDocumentNumber" value="<%=DocumentNumber%>" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>DC:</b></td>
			<td>
				<select name="cboDC" id="cboDC" class="pcontent">
					<% 
					
						Dim DcId 
						If Session("UserName") = "SSBU" Then
							DCId = 0
						Else
							DCId = Session("DCID")
						End If
						
						
						If DCId = 0 Then 
							Response.Write "<option value=""0,All DCs"">-- All DCs --</option>"
						End If
						
					
						
						Set rsObj =  ExecuteSql("ListDCs @DcId=" & DcId, cnObj)   
						If Not (rsObj.BOF And rsObj.EOF) Then
							While Not rsObj.EOF 
								If rsObj("CMID") = CInt(SearchDCId) Then %>
									<option selected="selected" value="<%=rsObj("CMID")%>,<%=rsObj("CMcName")%>"><%=rsObj("CMcName")%></option> <%
								Else %>
									<option value="<%=rsObj("CMID")%>,<%=rsObj("CMcName")%>"><%=rsObj("CMcName")%></option>
							<%	End If
								rsObj.MoveNext
							Wend
						End If
						rsObj.Close
						
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Supplier:</b></td>
			<td>
				<select name="cboSupplier" id="cboSupplier" class="pcontent">
				
					<%
						Dim SqlCommand 
						SqlCommand = ""

						If SearchDcId = "" Then SearchDcId = Session("DcId")
						If Session("UserType") = 1 Then 
							
							SqlCommand = "ListSuppliers @DcId=" & SearchDcId
							Response.Write "<option value=""0,All Suppliers,Vendor Code"">-- All Suppliers --</option>"
						End If

						If Session("UserType") = 2 Then SqlCommand = "ListSuppliers @DcId=" & SearchDcId & ",@SupplierId=" & Session("ProcId")
						
						'Response.Write SqlCommand
						'response.end
						Set rsObj =  ExecuteSql(SqlCommand, cnObj)   
						If Not (rsObj.BOF And rsObj.EOF) Then
							While Not rsObj.EOF 
								If rsObj("SPID") = CInt(SearchSupplierId) And rsObj("VendorCode") = SearchSupplierVendorCode Then %>
									<option selected="selected" value="<%=rsObj("SPID")%>,<%=Replace(rsObj("VendorName"),",","")%>,<%=rsObj("VendorCode")%>"><%=rsObj("Vendor")%></option> <%
								Else %>
									<option value="<%=rsObj("SPID")%>,<%=Replace(rsObj("VendorName"),",","")%>,<%=rsObj("VendorCode")%>"><%=rsObj("Vendor")%></option>
							<%	End If
								rsObj.MoveNext
							Wend
						End If
						rsObj.Close
				
					%>
					
					
				</select>
			<td>
		</tr>	
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>From Date:</b></td>
			<td class="pcontent" colspan="3">
				<input type="text" name="txtFromDate" readonly id="txtFromDate" size="10" class="pcontent" value="<%=Request.Form("txtFromDate")%>">
				&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>To&nbsp;Date:</b>
				<input type="text" name="txtToDate" readonly id="txtToDate" size="10" class="pcontent" value="<%=Request.Form("txtToDate")%>">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnAction" id="btnSubmit" value="Search" class="button">&nbsp;
				<input type="button" name="btnAction" id="btnReset" value="Reset" class="button">&nbsp;
				<input type="hidden" name="currentPageNumber" id="CurrentPageNumber" value="<%=currentPageNumber%>">
			</td>
			
		</tr>
		
</form>
<%
		cnObj.Close
		Set cnObj = Nothing
%>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/tracktrace/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/tracktrace/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	
		
		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>

<!--#include file="../../layout/end.asp"-->        
