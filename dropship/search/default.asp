<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
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
										dim NewDate
										dim IsXML
										dim Folder
										dim txtDC
										dim dcID
										Dim dcName
										
										dcID = 0
										
										
										
										Select Case Session("UserType")
										Case 1, 4
											FolderName = "supplier"
											UserID = Session("ProcID")
											UserType = 1
											dcID = Session("DCID")
										Case 2
											FolderName = "dc"
											UserID = 0
											UserType = 2
											
											if Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE")then
												dcID = 0
											else
												dcID = Session("DCID")
											end if
										Case 3
											FolderName = "store"									
											UserID = Session("ProcID")
											UserType = 3
											dcID = Session("DCID")
										End Select
										
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
										
										if Request.QueryString("id") = "" Then
											NewDate = Year(Now) & "/" & Month(Now) & "/" & Day(Now)
										else
											NewDate = Year(Request.QueryString("id")) & "/" & Month(Request.QueryString("id")) & "/" & Day(Request.QueryString("id"))
										end if

										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Call the menu items generation function
										iF Session("HideMenu") <> True Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, NewDate, IsXML)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#<script type="text/javascript" src="../includes/jquery.min.js"></script>-->
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style>
.ui-datepicker-trigger { position:absolute; height:16px; cursor: pointer }
 </style>
<script type="text/javascript" language="JavaScript" src="../includes/calendar1.js"></script>
<% If  Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE") OR Session("UserType") = 1 OR Session("UserType") = 4 Then%>
<script type="text/javascript" charset="utf-8">
$(function(){
	
	$("#loading").bind("ajaxSend", function() {
		$(this).show();
	}).bind("ajaxComplete", function() {
		$(this).hide();
	});
	
	$("select#drpDC").change(function(){
	
		$.getJSON("../includes/JQueryDataSetSuppliers.asp",{id: $(this).val()}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + ',' + j[i].optionVendorCode + '">' + j[i].optionDisplay + '</option>'
			}
			$('#drpSupplier').html(options);
			$('#drpSupplier option:first').attr('selected', 'selected');
		})
		$.getJSON("../includes/JQueryDataSetStores.asp",{id: $(this).val()}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + '">' + j[i].optionDisplay + '</option>'
			}
			$('#drpStore').html(options);
			$('#drpStore option:first').attr('selected', 'selected');
		})
		
		$('#cboClaimType').trigger("change");	
	})	
})
</script>

<% End If %>
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
		
	};
	
	//function validate(obj) {
		// validate the FromDate
	//	if (!validateDate(obj.txtFromDate, obj.txtFromDate.value, "From Date")) return false;
		// validate the ToDate
	    //if (!validateDate(obj.txtToDate, obj.txtToDate.value, "To Date")) return false;
	//};
	
	function validateDate(str_obj, str_date, str_type) {
		var RE_NUM = /^\-?\d+$/;
		var arr_date = str_date.split('-');

		
	};
//-->
</script>
 <script type="text/javascript">
  function partialSupSearch() {
		if (document.FrmSearch.elements['txtPartialSup'].value==''){
			window.alert('You have to enter partial supplier name.');
			document.FrmSearch.elements['txtPartialSup'].focus();
			return false;	
		}
		
		var dcId = document.FrmSearch.elements['drpDC'].value;
		dcId = dcId.split(",");
		
		var parNameSearch = document.FrmSearch.elements['txtPartialSup'].value;
		window.open('partial_search.asp?value=' + parNameSearch + '&type=Search&id=' + dcId[0],'PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
		
		return false;
	}

	function setSupplierSelectedVal() {
		// Set the selected supplier index
		document.FrmSearch.elements['hidSupplier'].value = document.FrmSearch.drpSupplier.options[document.FrmSearch.elements['drpSupplier'].selectedIndex].value;
		//window.alert(document.FrmSearch.drpSupplier.options[document.FrmSearch.elements['drpSupplier'].selectedIndex].value);
	}
  </script>  
  
    <script>
	
	
  $( function() {
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
  } );
  </script>
    <style type="text/css">
	.example-select {
    padding-top: 10px;
    padding-bottom: 10px;
    border-bottom: 1px dotted #CCC;
	FONT-SIZE: 11px;
    COLOR: black;
    FONT-FAMILY: Arial;
  }
  .example p {
    margin: 0;
    padding: 0;
  }
  .last {
    margin-bottom: 10px;
  }
  #comment-form {
    width: 100%;
  }
  </style>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="setSupplierSelectedVal();">
<br><br>
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
												
												'Session("DCID") = Session("DCID")
												dcID = Session("DCID")
												dcName = Session("DCName")	
												'Session("DCName") = Session("DCName")												
												
												Session("SupplierID") = Session("SupplierID")
												Session("SupplierName") = Session("SupplierName")
												Session("StoreID") = Session("StoreID")
												Session("StoreName") = Session("StoreName")
												'Session("Date") = Session("Date")
												Session("FromDate") = Session("FromDate")
												Session("ToDate") = Session("ToDate")
											end if
												
											if Request.Form("hidAction") = "1" Then
												txtDC = split(Request.Form("drpDC"),",")
												'txtSupplier = split(Request.Form("drpSupplier"),",")
												txtSupplier = split(Request.Form("hidSupplier"),",")
												txtStore = split(Request.Form("drpStore"),",")
												
																							
												Session("Check") = 1
												Session("SearcType") = Request.Form("drpType")
												Session("TraceNumber") = Request.Form("txtTraceNum")
												
												
												'Session("DCID") = txtDC(0)
												'Session("DCName") = txtDC(1)
												dcName = txtDC(1)
												dcID =  txtDC(0)
												'response.Write "SupplierID=" & txtSupplier(0) & "<br>"
												
												Session("SupplierID") = txtSupplier(0)
												Session("SupplierName") = txtSupplier(1)
												Session("StoreID") = txtStore(0)
												Session("StoreName") = txtStore(1)
												
												Dim FromDateArray, ToDateArray
												FromDateArray = Split(Request.Form("txtFromDate"),"/")
												If (UBound(FromDateArray) > 0 ) Then
												'Session("FromDate") = Request.Form("txtFromDate")
													Session("FromDate") = FromDateArray(2) & "-" & FromDateArray(1) & "-" & FromDateArray(0)
												Else
													Session("FromDate") =  ""
												End If
												
												'Session("ToDate") = Request.Form("txtToDate")
												ToDateArray = Split(Request.Form("txtToDate"),"/")
												If (UBound(ToDateArray) > 0 )  Then
													Session("ToDate") = ToDateArray(2) & "-" & ToDateArray(1) & "-" & ToDateArray(0)
												Else
													Session("ToDate") = ""
												End If
												'Session("ToDate") = Request.Form("txtToDate")
											end if
											
											'response.Write "SupplierID=" & Session("SupplierID") & "<br>"
											
											' check the recordbands
											if CStr(Request.QueryString("page")) = "" or IsNull(CStr(Request.QueryString("page")))	Then
												Band = 1
											else
												If IsNumeric(Request.QueryString("page")) Then
													Band = CInt(Request.QueryString("page"))
												End If
												
											end if
											
											'Response.Write Session("SearcType")
											' Build the SQL
											Select Case Session("SearcType")
											Case 1
												SQL = "procSearch_New @SearchType=" & Session("SearcType") & _
													", @TraceNumber=" & MakeSQLText(Session("TraceNumber")) & _
													", @SupplierID=" & Session("SupplierID") & _
													", @StoreID=" & Session("StoreID") & _
													", @DCID=" & dcId & _ 
													", @FromDate=" & MakeSQLText(Session("FromDate")) & _
													", @ToDate=" & MakeSQLText(Session("ToDate")) & _
													", @RecordBand=" & Band 
											
													
												'Response.Write "<br>SQL1=" & SQL
												'response.end
											Case 2
												if Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE")then
													SQL = "procSearch_New @SearchType=" & Session("SearcType") & _
														", @TraceNumber=" & MakeSQLText(Session("TraceNumber")) & _
														", @SupplierID=" & Session("SupplierID") & _
														", @StoreID=" & Session("StoreID") & _
														", @DCID=" & dcId & _
														", @FromDate=" & MakeSQLText(Session("FromDate")) & _
														", @ToDate=" & MakeSQLText(Session("ToDate")) & _
														", @RecordBand=" & Band 
														
														
												'Response.Write "<br>SQL2=" & SQL
												'response.end
												else
													SQL = "procSearch_New @SearchType=" & Session("SearcType") & _
														", @TraceNumber=" & MakeSQLText(Session("TraceNumber")) & _
														", @SupplierID=" & Session("SupplierID") & _
														", @StoreID=" & Session("StoreID") & _
															", @DCID=" & dcId & _
														", @FromDate=" & MakeSQLText(Session("FromDate")) & _
														", @ToDate=" & MakeSQLText(Session("ToDate")) &_
														", @RecordBand=" & Band 

														
														
												'Response.Write "<br>SQL3=" & SQL
												'response.end
												end if
											Case 3, 4, 7, 5, 6
												SQL = "procSearch_New @SearchType=" & Session("SearcType") & _
												", @TraceNumber=" & MakeSQLText(Session("TraceNumber")) & _
												", @SupplierID=" & Session("SupplierID") & _
												", @StoreID=" & Session("StoreID") & _
													", @DCID=" & dcId & _
												", @FromDate=" & MakeSQLText(Session("FromDate")) & _
											    ", @ToDate=" & MakeSQLText(Session("ToDate")) & _
												", @RecordBand=" & Band 
												
												
												
												
											
												
											End Select
											
											'response.Write "SupplierID=" & Session("SupplierID") & "<br>"
																				
							
											curConnection.CommandTimeout = 0
											' Execute the SQL
											'Response.Write SQL
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
							<li class="pcontent">Search Type = <b><%if Session("SearcType") = 1 then Response.Write "Order/s" end if%><%if Session("SearcType") = 2 then Response.Write "Invoice/s" end if%><%if Session("SearcType") = 3 then Response.Write "Claim/s" end if %><%if Session("SearcType") = 4 then Response.Write "Credit Note/s" end if %><%if Session("SearcType") = 5 then Response.Write "Recon Report/s" end if %><%if Session("SearcType") = 6 then Response.Write "Electronic Schedules" end if %><%if Session("SearcType") = 7 then Response.Write "Electronic Remittance Advices" end if %></b></li>
							<li class="pcontent">Document Number = <b><%if Session("TraceNumber") = "" then Response.Write "Not Supplied" else Response.Write Session("TraceNumber") end if%></b></li>
							<li class="pcontent">DC = <b><%=dcName%></b></li>
							<li class="pcontent">Supplier = <b><%=Session("SupplierName")%></b></li>
							<li class="pcontent">Store = <b><%=Session("StoreName")%></b></li>
							<li class="pcontent">From Date = <b><%If Request.Form("txtFromDate") = "" Then Response.Write "Not Supplied"  Else Response.Write Request.Form("txtFromDate") End If %></b></li>
							<li class="pcontent">To Date = <b><%If Request.Form("txtToDate") = "" Then Response.Write "Not Supplied"  Else Response.Write Request.Form("txtToDate") End If %></b></li>
						</ul>
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
		<!--<td class="pcontent" valign="middle"><b>Note:</b> Click on the Order Number link to view the Order details and /or click on the Invoice number to view the invoice details.</td>-->
		<td class="pcontent" valign="middle"><b>Note:</b> Click on the <%if Session("SearcType") = 1 then Response.Write "Order Number"%><%if Session("SearcType") = 2 then Response.Write "Invoice Number"%><%if Session("SearcType") = 3 then Response.Write "Claim Number"%><%if Session("SearcType") = 4 then Response.Write "Credit Note"%><%if Session("SearcType") = 5 then Response.Write "Recon Report"%> link to view the details</td>
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
												'Call PageNav (const_app_ApplicationRoot & "/search/default.asp", "pcontent", RecordCount, MaxRecords, RecordFrom, RecordTo, TotPages, Band, Request.QueryString("id"))

												Select Case Session("SearcType")
												Case 1
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>Order Number</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI/XML</b></td>
		<td class="tdcontent" align="center"><b>Delivered to<br>Mailbox</b></td>
		<td class="tdcontent" align="center"><b>Extracted by<br> Supplier</b></td>
		<td class="tdcontent" align="center"><b>Invoice Generated<br> by Supplier</b></td>
		<td class="tdcontent" align="center"><b>Invoices</b></td>
	</tr>
<%
												Case 2
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>Invoice Number</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI/XML</b></td>
		<td class="tdcontent" align="center"><b>Posted to<br>Comms Centre</b></td>
		<td class="tdcontent" align="center"><b>Received By<br>Spar DC</b></td>
		<td class="tdcontent" align="center"><b>Order Number</b></td>
		<td class="tdcontent" align="center"><b>Claim</b></td>
		<td class="tdcontent" align="center"><b>CreditNote</b></td>
	</tr>
<%												
												Case 3
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>Claim Number</b></td>
		<td class="tdcontent" align="center"><b>Claim Type</b></td>
		<td class="tdcontent" align="center"><b>Claim Reason</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI or XML</b></td>
		<td class="tdcontent" align="center"><b>Delivery to<br>Mailbox</b></td>
		<td class="tdcontent" align="center"><b>Extracted<br>by Supplier</b></td>
		<td class="tdcontent" align="center"><b>Manual<br>Claim Number</b></td>
		<td class="tdcontent" align="center"><b>Manual<br>Claim Date</b></td>
		<td class="tdcontent" align="center"><b>Invoice<br>Number</b></td>
		<td class="tdcontent" align="center"><b>Invoice<br>Date</b></td>
		<td class="tdcontent" align="center"><b>Credit Note<br>Number</b></td>
		<td class="tdcontent" align="center"><b>Credit Note<br>Date</b></td>
	</tr>
<%												
												Case 4
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>Credit Note <br> Number</b></td>
		<td class="tdcontent" align="center"><b>Credit Note <br/>Type</b></td>
		<td class="tdcontent" align="center"><b>Claim Reason</b></td>
		<td class="tdcontent" align="center"><b>File<br>Received<br>By Gateway</b></td>
		<td class="tdcontent" align="center"><b>Translated<br>to<br>EDI/XML</b></td>
		<td class="tdcontent" align="center"><b>Posted to<br>SPAR DC</b></td>
		<td class="tdcontent" align="center"><b>Received by <br>SPAR DC</b></td>
		<td class="tdcontent" align="center"><b>Invoice Number</b></td>
		<td class="tdcontent" align="center"><b>List Referenced Claims</b></td>
		<td class="tdcontent" align="center"><b>Credit Value Incl</b></td>
	</tr>
<%												Case 5
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="pcontent" align="center" ><b>Supplier</b></td>
		<td class="pcontent" align="center" ><b>Recon Report</b></td>
		<td class="pcontent" align="center" ><b>Recon Report Summary</b></td>
		<td class="pcontent" align="center" ><b>Mail sent</b></td>
		<td class="pcontent" align="center" ><b>Last viewed</b></td>
		<td class="pcontent" align="center" ><b>Last downloaded</b></td>
		<td class="pcontent" align="center" ><b>Download</b></td>
	</tr>
<%	
                                                Case 6
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>File Name</b></td>
	    <td class="tdcontent" align="center"><b>File Size</b></td>
	    <td class="tdcontent" align="center"><b>DC</b></td>
	    <td class="tdcontent" align="center"><b>Supplier</b></td>
	    <td class="tdcontent" align="center"><b>Date Created</b></td>
	    <td class="tdcontent" align="center"><b>Date Validated</b></td>
	    <td class="tdcontent" align="center"><b>Date Released</b></td>
	    <td class="tdcontent" align="center"><b>Date Updated</b></td>
	    <td class="tdcontent" align="center"><b>Total Amount</b></td>
	    <td class="tdcontent" align="center"><b>Number Of Documents</b></td>
	    <td class="tdcontent" align="center"><b>Status</b></td>
	    <td class="tdcontent" align="center"><b>User</b></td>
	</tr>
<%	                                                	
                                                Case 7
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr bgcolor="#4C8ED7">
	<td class="tdcontent" align="center"><b>DC</b></td>
	    <td class="tdcontent" align="center"><b>Supplier</b></td>
	    <td class="tdcontent" align="center"><b>Last Viewed</b></td>
	    <td class="tdcontent" align="center"><b>RA Date</b></td>
	    <td class="tdcontent" align="center"><b>Payment Number</b></td>
	    <td class="tdcontent" align="center"><b>Recieved By Gateway</b></td>
	    <td class="tdcontent" align="center"><b>Options</b></td>
	</tr>
<%	 
												End Select
												
												' Loop through the recordset
												While not ReturnSet.EOF
													Select Case  Session("SearcType")
													Case 1
														OrdNum = split(ReturnSet("OrderNumber"),".")
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/order/default.asp?item=<%=ReturnSet("TraceID")%>', 'OrderDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=OrdNum(0)%></a></td>
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
																If ReturnSet("Id") = 0 Then
	%>
							<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/list.asp?item=<%=ReturnSet("TraceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">list invoices</a>
	<%
																Else
	%>
							<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/default.asp?item=<%=ReturnSet("Id")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">list invoice</a>

	<%
																End If
							%>
		</td>
	</tr>
<%			
														end if
													Case 2
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/default.asp?item=<%=ReturnSet("InvoiceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=ReturnSet("InvoiceNumber")%></a></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceiveDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("PostDate"),true)%></td>
		<td class="pcontent" align="center"><%if ReturnSet("AckDate") = "" or isNull(ReturnSet("AckDate")) then response.Write "-" else response.Write FormatLongDate(ReturnSet("AckDate"),true) end if%></td>
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
%>		
		
	
	<td class="pcontent" align="center"><b><% If ReturnSet("ClaimNumber") = "" Or IsNull(ReturnSet("ClaimNumber")) Then Response.Write "-"  Else %> 
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/claim/default.asp?item=<%=ReturnSet("ClaimId")%>', 'ClaimDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=ReturnSet("ClaimNumber")%></a>
		<td class="pcontent" align="center"><b><% If ReturnSet("CreditNoteNumber") = "" Or IsNull(ReturnSet("CreditNoteNumber")) Then Response.Write "-"  Else %> 
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/creditnote/default.asp?item=<%=ReturnSet("CreditNoteId")%>', 'CreditNoteDetail', 'width=1200,height=900,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=ReturnSet("CreditNoteNumber")%></a>
		

	</tr> 
<%
													Case 3
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/claim/default.asp?item=<%=ReturnSet("ClaimID")%>', 'ClaimDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("ClaimNumber")%></a></td>
		<td class="pcontent" align="center"><%=ReturnSet("Type")%></td>
		<td class="pcontent" align="center"><%if ReturnSet("ClaimReason") = "" or IsNull(ReturnSet("ClaimReason")) then response.write GetReason(ReturnSet("Type"), ReturnSet("ClaimReasonHead")) else response.write GetReason(ReturnSet("Type"), ReturnSet("ClaimReason")) end if%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceivedDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%if IsNull(ReturnSet("ExtractDate")) then Response.Write "-" else Response.Write FormatLongDate(ReturnSet("ExtractDate"),true) end if%></td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("ManNum") = "" or isNull(ReturnSet("ManNum")) Then
															Response.Write "-"
														else
															Response.Write ReturnSet("ManNum")
														end if
%>	
		</td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("ManDate") = "" or isNull(ReturnSet("ManDate")) Then
															Response.Write "-"
														else
															Response.Write FormatLongDate(ReturnSet("ManDate"),false)
														end if
%>	
		</td>																
		<td class="pcontent" align="center">
<%
														if ReturnSet("InvoiceNumber") = "" or isNull(ReturnSet("InvoiceNumber")) Then
															Response.Write "-"
														else
															if ReturnSet("InvoiceID") = "" or isNull(ReturnSet("InvoiceID")) Then
																Response.Write ReturnSet("InvoiceNumber")
															else
%>			
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/default.asp?item=<%=ReturnSet("InvoiceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("InvoiceNumber")%></a>
<%
															end if
														end if
%>			
		</td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("InvoiceDate") = "" or isNull(ReturnSet("InvoiceDate")) Then
															Response.Write "-"
														else
															Response.Write FormatLongDate(ReturnSet("InvoiceDate"),false)
														end if
%>	
		</td>			
		<td class="pcontent" align="center">
<%
														if ReturnSet("CreditNoteNumber") = "" or isNull(ReturnSet("CreditNoteNumber")) Then
															Response.Write "-"
														else
															if ReturnSet("CNoteID") = "" or isNull(ReturnSet("CNoteID")) Then
																Response.Write ReturnSet("CreditNoteNumber")
															else
%>			
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/creditnote/default.asp?item=<%=ReturnSet("CNoteID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("CreditNoteNumber")%></a>
		</td>		
<%														
															end if
														end if
%>														
		<td class="pcontent" align="center">
<%
														if ReturnSet("CNDate") = "" or isNull(ReturnSet("CNDate")) Then
															Response.Write "-"
														else
															Response.Write FormatLongDate(ReturnSet("CNDate"),false)
														end if
%>	
		</td>
	</tr> 																	
<%		
													Case 4
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/creditnote/default.asp?item=<%=ReturnSet("CreditNoteID")%>', 'CreditNoteDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("CreditNoteNumber")%></a></td>
		<td class="pcontent" align="center"><%=ReturnSet("Type")%></td>
		<td class="pcontent" align="center"><%=GetReason(ReturnSet("Type"), ReturnSet("CreditReason"))%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("ReceivedDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("TransDate"),true)%></td>
		<td class="pcontent" align="center"><%=FormatLongDate(ReturnSet("PostDate"),true)%></td>
		<td class="pcontent" align="center"><%if ReturnSet("AckDate") = "" or isNull(ReturnSet("AckDate")) then response.Write "-" else response.Write FormatLongDate(ReturnSet("AckDate"),true) end if%></td>
		<td class="pcontent" align="center">
<%
														if not isnull(ReturnSet("InvoiceID")) then
															if CStr(ReturnSet("InvoiceID")) = "" or CStr(ReturnSet("InvoiceID")) = "0" Then
																if ReturnSet("InvoiceNumber") = "" or IsNull(ReturnSet("InvoiceNumber")) then
																	Response.Write "-"
																else
																	Response.Write ReturnSet("InvoiceNumber") 
																end if
															else
%>			
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/invoice/default.asp?item=<%=ReturnSet("InvoiceID")%>', 'InvoiceDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><%=ReturnSet("InvoiceNumber")%></a>
<%
															end if
														else
															Response.Write "-"
														end if
%>			
		</td>
		<td class="pcontent" align="center">
<%
														if ReturnSet("TotalClaims") = 0 Then
															Response.Write "-"
														else
%>			
			<a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/creditnote/default.asp?item=<%=ReturnSet("CreditNoteID")%>', 'CreditNoteDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');">List Referenced Claims</a>
		</td>		
<%														
														end if	
%>														
		<td class="pcontent" align="center">R&nbsp;<%=ReturnSet("CostIncl")%></td>
	</tr> 
<%			
													Case 5
%>
	<tr>
		<td class="pcontent" align="center"><%=ReturnSet("SPcName")%></td>
		<td class="pcontent" align="center"><a class="links" href="<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/viewfile.asp?RRID=<%=ReturnSet("RRID")%>|<%=ReturnSet("RRcFilepath")%>|view" target="about.blank"><%=ReturnSet("RRcFileName")%></a></td>
		<td class="pcontent" align="center"><a class="links" href="<%=const_app_ApplicationRoot%>/track/<%=FolderName%>/viewfile.asp?RRID=<%=ReturnSet("RRID")%>|<%=ReturnSet("RRcFilepath")%>|detail" target="about.blank">Click here for summary</a></td>
		<td class="pcontent" align="center">
<%
														if isnull(ReturnSet("RRdDateMailSent")) Then
															Response.write("-")
														else
															%><%=FormatLongDate(ReturnSet("RRdDateMailSent"), true)%><%
														end if
%>
		</td>
		<td class="pcontent" align="center">
<%
														if isnull(ReturnSet("RRdDateViewed")) Then
															Response.write("-")
														else
															%><%=FormatLongDate(ReturnSet("RRdDateViewed"),true)%><%
														end if
%>
		</td>
		<td class="pcontent" align="center">
<%
														if isnull(ReturnSet("RRdDateDownloaded")) Then
															Response.write("-")
														else
															%><%=FormatLongDate(ReturnSet("RRdDateDownloaded"),true)%><%
														end if
%>
		</td>
		<td class="pcontent" align="center"><a class="links" href="<%=const_app_ApplicationRoot%>/Includes/downloadfile.asp?ref=<%=ReturnSet("RRcFilepath")%>" >Download XML</a></td>
	</tr> 
<%																
													
													Case 6
%>
 <tr>
        <td class="pcontent"><a class="links" href="JavaScript: newWindow = openWin('<%=const_app_ApplicationRoot%>/schedule/edit/default.asp?id=<%=ReturnSet("ScheduleID")%>&amp;statusid=<%=ReturnSet("StatusID")%>', 'ScheduleDetail', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><%=ReturnSet("FileName")%></a></td>
        <td class="pcontent" align="center"><%=ReturnSet("FileSize")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("DCName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("CreateDate")) then response.Write "-" else response.Write ReturnSet("CreateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ValidateDate")) then response.Write "-" else response.Write ReturnSet("ValidateDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("ReleaseDate")) then response.Write "-" else response.Write ReturnSet("ReleaseDate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("EditDate")) then response.Write "-" else response.Write ReturnSet("EditDate") end if%></td>
        <td class="pcontent" align="center"><%=ReturnSet("TotalAmt")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("NumberOfDoc")%></td>
        <td class="pcontent" align="left">
<%
                                                if ReturnSet("StatusID") = 4 or ReturnSet("StatusID") = 5 then
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/right.gif" alt="" height="10" width="10"/>
<%
                                                else
%>
            <img src="<%=const_app_ApplicationRoot%>/layout/images/wrong.gif" alt="" height="10" width="10"/>
<%                                                
                                                end if
%>                                                     
            &nbsp;<%=ReturnSet("StatusDescrip")%>
        </td>
        <td class="pcontent" align="center"><%=ReturnSet("UserName")%></td>
    </tr>
<%               
													
													Case 7
														Dim RemittanceAdviceId
														RemittanceAdviceId = Mid(ReturnSet("Id"),2,Len(ReturnSet("Id"))-2)
%>
    <tr>
        <td class="pcontent" align="center"><%=ReturnSet("DCName")%></td>
        <td class="pcontent" align="center"><%=ReturnSet("SupplierName")%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("LastViewed")) then response.Write "-" else response.Write FormatDateTime(ReturnSet("LastViewed"),0) end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("RADate")) then response.Write "-" else response.Write ReturnSet("RADate") end if%></td>
        <td class="pcontent" align="center"><%if IsNull(ReturnSet("PaymentNumber")) then response.Write "-" else response.Write ReturnSet("PaymentNumber") end if%></td>
        <td class="pcontent" align="center"><%=ReturnSet("CreatedAt")%></td>
		<td class="pcontent" align="center">
		<a href=<%=const_app_ApplicationRoot%>/track/dc/viewDownload.asp?rid={<%=RemittanceAdviceId%>} target="_blank">Download</a>
		<br />
		<a href="<%=const_app_ApplicationRoot%>../../remittanceadvice/viewreport.aspx?id=<%=RemittanceAdviceId%>" target="_blank">View report</a>
	  </td>
    </tr>
	   
<%               

													End Select 									
												
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
%><p><hr></p><%											
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										end if
%><table border="0" cellpadding="2" cellspacing="2" width="100%">

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

<form name="FrmSearch" id="FrmSearch" method="post" action="default.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);" autocomplete="off">

	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Search Type:</b></td>
			<td>
			<!--ANCO CHANGED CLASS FROM pCONTENT to editable-select-->
				<select name="drpType" id="drpType" class="pcontent">
					<option value="-1">-- Select a Search Type --</option>
					<option value="1">Order/s</option>
					<option value="2">Invoice/s</option>
					<option value="3">Claim/s</option>
					<option value="4">Credit Note/s</option>
					
					<% If Session("UserType") <> 3 Then %>
						<option value="5">Recon Report/s</option>
						<option value="6">Electronic Schedules</option>
						<option value="7">Electronic Remittance Advices</option>
					<% End If %>
					
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
			<td class="pcontent"><b>DC:</b></td>
			<td>
				<select name="drpDC" id="drpDC" class="pcontent">
<%
						
										If Session("ProcEAN") = "6004930000677" Then ' SSBU User
											dcID  = 0
										End If
										
										if Session("DCId") = 0 then
%>				
					<option value="0,Not Selected">-- Select a DC --</option>
<%
										end if

										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
								
										
										Set ReturnSet = ExecuteSql("listDC @DC=" & Session("DCId"), curConnection)  
													
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											if dcId = ReturnSet("DCID") Or (ReturnSet("DCID") & "," & ReturnSet("DCcName") = Request.Form("drpDC")) Then
												Selected = "selected"
											else
												'If ReturnSet("DCId") = 1 And Request.Form("cboDC") = "" Then 
												'	selected = "selected"
												'Else
													selected = ""
												'End If
											end if
%>
					<option <%=Selected%> value="<%=ReturnSet("DCID")%>,<%=ReturnSet("DCcName")%>"><%=ReturnSet("DCcName")%></option>
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
			<td class="pcontent"><b>Supplier:</b></td>
			<td>

				<select name="drpSupplier" id="drpSupplier" class="pcontent" language="javascript" onchange="setSupplierSelectedVal();">
<%
                                if Session("UserType") <> 1 AND Session("UserType") <> 4 then                  
%>
					<option value="-1,Not Selected">-- Select a Supplier --</option>
<%
                                end if

										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
		

										Set ReturnSet = ExecuteSql("listSupplier @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCId=" & Session("DCId"), curConnection)  
									

										
										Selected = ""
													
										' Loop through the recordset
										While not ReturnSet.EOF
											if (UserID = ReturnSet("SupplierID") And (UserType = 1 Or UserType =4)) OR Request.Form("drpSupplier") = ReturnSet("SupplierID") & "," & ReturnSet("SupplierName") Then
												Selected = "selected"
											else
												Selected = ""
											end if%><option <%=Selected%> value="<%=ReturnSet("SupplierID")%>,<%=ReturnSet("SupplierName")%>"><%=ReturnSet("SupplierName")%></option><%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>									
				</select>
			</td>
<%
									If CInt(Session("UserType")) <> 1 and CInt(Session("UserType")) <> 4 then
%>			
			<td class="pcontent"><b>OR</b></td>
			<td class="pcontent"><b>Supplier Partial Name</b></td>
			<td><input type="text" name="txtPartialSup" id="txtPartialSup" class="pcontent" size="60"><button name="btnFilter" id="btnFilter" value="Find" class="button" OnClick="return partialSupSearch();">Find</button></td>
<%
									end if
%>			
		<tr>
		</tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Store:</b></td>
			<td>
				<select name="drpStore" id="drpStore" class="pcontent">
					<option value="-1,Not Selected">-- Select a Store --</option><%
										' Set a connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
													
										' Get a list of Stores
										
										If  dcId = 0 And Request.Form("drpDC") = "" Then 
											Set ReturnSet = ExecuteSql("listStores @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCID=1", curConnection)  
										Else
											Set ReturnSet = ExecuteSql("listStores @SupplierID=" & UserID & ", @UserType=" & UserType & ", @DCID=" & Session("DCId"), curConnection) 
										End If

										
										Selected = ""
										While not ReturnSet.EOF
											if UserID = ReturnSet("StoreID") and UserType = 3 Then
												Selected = "selected"
											else
												Selected = ""
											end if%><option <%=Selected%> value="<%=ReturnSet("StoreID")%>,<%=ReturnSet("StoreName")%>"><%=ReturnSet("StoreName")%></option><%											
											ReturnSet.MoveNext
										Wend
													
										' Close the Connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
					%></select>
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>From&nbsp;Date:</b></td>
			<td class="pcontent" ><input type="text" name="txtFromDate" id="txtFromDate" size="10" class="pcontent" value="<%=Request.Form("txtFromDate")%>"></td>
			<td class="pcontent"><b>To&nbsp;Date:</b></td>
			<td class="pcontent" ><input type="text" name="txtToDate" id="txtToDate" size="10" class="pcontent" value="<%=Request.Form("txtToDate")%>"></td>
			
		</tr>
		
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Search" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
				<input type="hidden" name="hidSupplier" id="hidSupplier" value="-1,Not Selected">
			</td>
		</tr>
	</table>
</form>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	

		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>

<!--#include file="../layout/end.asp"-->
