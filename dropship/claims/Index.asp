<!DOCTYPE html>
<%@ Language=VBScript %>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<style>
.slidingDiv {
	.pcontent
}

.show_hide {
    display:none;
}
#loading
 {
   position:fixed; 
   _position:absolute;
   top: 0;
   left:47%; 
   padding:2px 5px;
   z-index: 5000;
   background-color:#fff;
   color: #333366;
 }
 
 #ui-datepicker-div{
 animation-name:ease-in;
 }
 
</style>
<%
	Dim token
	
	token = ""

	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if
	
	Dim ClaimReasonPost 
	ClaimReasonPost = Request.Form("cboClaimReason")
	
	Dim SqlConnection
	Dim RecordSet
	Dim SqlCommand 
	Dim DCId, SupplierId, StoreId, ClaimStatusId, ClaimReasonId, IsHistory
	Dim CurrentPageNumber
	Dim Folder
	
	If Request.Form("cboClaimType") <> "" Then
		ClaimTypeId = Split(Request.Form("cboClaimType"),",")(0)
	Else
		ClaimTypeId = 0
	End If
	
	Select Case Session("UserType") 
		Case 1,4
			Folder = "supplier"
		Case 2
			Folder = "dc"
		Case 3	
			Folder = "store"
		Case Else
			Folder = "dc"
	End Select
	
	
	'1,Supplier Claim 
	If Request.QueryString("id") = 1 Then
		SupplierOrDC = "Supplier"
	ElseIf Request.Form("cboClaimType") = "1,Supplier Claim" Or Request.Form("cboClaimType") = "3,Warehouse Claim" Or Request.Form("cboClaimType") = "-1,All Claim Types" _
		Or Request.Form("cboClaimType") = "4,Build It DC" Or Request.Form("cboClaimType") = "5,DC Vendor" Then
		SupplierOrDC = "Supplier"
	Else 
		SupplierOrDC = "DC"
	End If
	
	CurrentPageNumber = Request.Form("hidCurrentPageNumber")
	If CurrentPageNumber = "" Then
		CurrentPageNumber = 1
	End If
		
		
	Dim ShowWarehouseClaimType, OnlyWarehouse
	ShowWarehouseClaimType = False
	OnlyWarehouse = False
	Const DCEanCodes = "6001008999932,6001008999925,6001008999895,6001008999918,6001008999901,SPARHEADOFFICE,GATEWAYCALLCEN,6001008090011,6004930005184,6004930005207,6004930005214"
	If (Session("UserType") = 3 Or Session("UserType") = 2 ) Then
		ShowWarehouseClaimType = True
	End If
	If Session("UserType") = 1 Or Session("UserType") = 4 Then
		ShowWarehouseClaimType = False
	End If
	
	
	If InStr(DCEanCodes, Session("ProcEAN")) > 0 And Session("UserType") = 1 And Session("IsWarehouseUser") = 1 Then
		OnlyWarehouse = True
		ShowWarehouseClaimType = True
		SupplierOrDC = "WarehouseSupplier"
	End If
	'Response.Write ShowWarehouseClaimType 
	'ShowWarehouseClaimType
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	IsHistory =  Request.QueryString("h")
	If IsHistory = "" Then
		IsHistory = Request.Form("hidIsHistory")
	End If
	
	
	
	SupplierId = "-1,Not Selected,-1"
	
	if request.form("hidSupplier") <> "" then
		SupplierId = request.form("hidSupplier")
	end if
%>
	

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SPAR</title>
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script type="text/javascript" language="JavaScript" src="../includes/calendar1.js"></script>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	
	
	function validate(obj) {
		// validate the FromDate
		if (!validateDate(obj.txtFromDate, obj.txtFromDate.value, "From Date")) return false;
		// validate the ToDate
		if (!validateDate(obj.txtToDate, obj.txtToDate.value, "To Date")) return false;
	};
	
	function validateDate(str_obj, str_date, str_type) {
		var RE_NUM = /^\-?\d+$/;
		var arr_date = str_date.split('-');

		
	};

	function partialSupSearch(){
		var selectedDCId = document.Index.elements['cboDC'].value;
		var selectedClaimTypeId = document.Index.elements['cboClaimType'].value.split(',')[0];
		if (document.Index.elements['txtPartialSup'] != null)
		{
			if (document.Index.elements['txtPartialSup'].value==''){
				window.alert('You have to enter partial supplier name.');
				document.Index.elements['txtPartialSup'].focus();
				return false;	
			}
			var parNameSearch = document.Index.elements['txtPartialSup'].value;
		
			
			window.open('../search/partial_search.asp?value=' + parNameSearch + '&type=Claims&dcid=' + selectedDCId + '&ClaimTypeId='+selectedClaimTypeId,'PartialSearch', 'width=600,height=400,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');
			
			// reset supplier dropdown
			document.Index.cboSupplier.options[0].selected = '-1,Not Selected';
		}
		
		return false;
	}

	
	
	function setSupplierSelectedVal(ispostback) {
		if (document.Index.cboSupplier != null)
		{
			document.Index.elements['hidSupplier'].value = document.Index.cboSupplier.options[document.Index.elements['cboSupplier'].selectedIndex].value;
			if (document.Index.elements['txtPartialSup'] != null)
			{
				document.Index.elements['txtPartialSup'].value = '';
			}
		}
	}
	
	
	
	function SetPage(pagenumber)
	{
		document.Index.elements['hidCurrentPageNumber'].value = pagenumber;
		window.document.Index.submit();
	}
	
	
//-->
</script>

<script type="text/javascript" src="../includes/jquery.min.js"></script>
 <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  
   <script>
  $( function() {
  
	let mDate = new Date().setMonth(new Date().getMonth() - 60);
	let nDate = new Date(mDate);
	let newMinDate = nDate.getDate() + "/" + (nDate.getMonth() + 1) + "/" + nDate.getFullYear();

	$( "#txtFromDate" ).datepicker(
	{
dateFormat:"dd/mm/yy",
changeMonth:true,
changeYear:true,
minDate: newMinDate,
maxDate: new Date()
	});
	//to Date
	$( "#txtToDate" ).datepicker(
	{
dateFormat:"dd/mm/yy",
changeMonth:true,
changeYear:true,
minDate: newMinDate,
maxDate: new Date()
	}
	);
  } );
  </script>
<% If  Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE") Then%>
<script type="text/javascript" charset="utf-8">
$(function(){
	

	
	
})
</script>
<% End If %>

  <script>
  $( function() {
  
	let mDate = new Date().setMonth(new Date().getMonth() - 60);
	let nDate = new Date(mDate);
	let newMinDate = nDate.getDate() + "/" + (nDate.getMonth() + 1) + "/" + nDate.getFullYear();
	
    //from date
	$( "#txtFromDate" ).datepicker(
	{
dateFormat:"dd/mm/yy",
changeMonth:true,
changeYear:true,
minDate: newMinDate,
maxDate: new Date()
	});
	//to Date
	$( "#txtToDate" ).datepicker(
	{
dateFormat:"dd/mm/yy",
changeMonth:true,
changeYear:true,
minDate: newMinDate,
maxDate: new Date()
	}
	);
  } );
  </script>

<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#cboDC").change(function(){
		$.getJSON("../includes/JQueryDataSetStores.asp",{id: $(this).val(), storeformat: $("#cboStoreFormat").val()}, function(j){
			var options = '';

			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + '">' + j[i].optionDisplay + '</option>'
			}
			$('#cboStore').html(options);
			$('#cboStore option:first').attr('selected', 'selected');
			$('#cboStore').val(j[0].optionValue + ',' + j[0].optionDisplay);
		})
		
		$.getJSON("GetBuyerDetailsByDcid.asp",{ DcId: $(this).val()}, function(j){
			var options = '';

			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + '">' + j[i].optionDisplay + '</option>'
			}
			$('#cboBuyerName').html(options);
			$('#cboBuyerName option:first').attr('selected', 'selected');
			$('#cboBuyerName').val(j[0].optionValue + ',' + j[0].optionDisplay);
		})
		
		$.getJSON("getoutcomereasons.asp",{ dcId: $(this).val()}, function(j){
			var options = '<option value="0,None">All Outcome Reasons</option>';

			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].Id + ',' + j[i].Value + '">' + j[i].Value + '</option>'
			}
			$('#cboOutcomeReason').html(options);
			$('#cboOutcomeReason option:first').attr('selected', 'selected');
		})
		
		
		$('#cboClaimType').trigger("change");	
	})	
		
	
	$("select#cboStoreFormat").change(function(){	
		$.getJSON("../includes/JQueryDataSetStores.asp",{id: $("#cboDC").val(), storeformat: $("#cboStoreFormat").val()}, function(j){
			var options = '';

			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + '">' + j[i].optionDisplay + '</option>'
			}
			$('#cboStore').html(options);
			$('#cboStore option:first').attr('selected', 'selected');
			$('#cboStore').val(j[0].optionValue + ',' + j[0].optionDisplay);
		})
	})
	
	
	$("select#cboClaimType").change(function(){
		$.getJSON("../includes/JQueryDataSetSuppliers.asp",{id: $("#cboDC").val(), ClaimTypeId: $(this).val()}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + ',' + j[i].optionVendorCode + '">' + j[i].optionDisplay + '</option>'
			}
			$('#cboSupplier').html(options);
			$('#cboSupplier option:first').attr('selected', 'selected');
			$('#hidSupplier').val(j[0].optionValue + ',' + j[0].optionDisplay + ',' + j[0].optionVendorCode);
		})
		
		$.getJSON("../includes/json_claimcategories.asp",{id: $(this).val(), doSearch: true, dcid: $("select#cboDC").val() }, function(k){
			var options = '';
			
			for (var i = 0; i < k.length; i++) {
				 options += '<option value="' + k[i].optionValue + ',' + k[i].optionDisplay + '">' + k[i].optionDisplay + '</option>'
			}
			
			$('#cboClaimCategory').html(options);
			$('#cboClaimCategory option:first').attr('selected', 'selected');
			
			$('#cboClaimCategory').trigger("change");
		})
		
	})			
})

$(function(){
	$("select#cboClaimCategory").change(function(){
		$('#hidClaimReason').val('-1,All');
		$.getJSON("../includes/json_claimcategoryreasons.asp",{id: $(this).val(), typeid: $("select#cboClaimType").val() }, function(l){
			var options = '';
			
			for (var i = 0; i < l.length; i++) {
				options += '<option value="' + l[i].optionValue + ',' + l[i].optionDisplay + '">' + l[i].optionDisplay + '</option>'
			}
			
			$('#cboClaimReason').html(options);
			
			$('#cboClaimReason').each(function() {
				var selectedValue = $(this).val();
				
				$(this).html($("option", $(this)).sort(function(a, b) {
					return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
				}));
 
				$(this).val(selectedValue);
			});

		})
	
	
		$.getJSON("../includes/json_wclaimsubcategories.asp",{categoryIds: $(this).val().split(",")[0], dcId: $("#cboDC").val().split(",")[0]}, function(l){
					var options = '';
					
					for (var i = 0; i < l.length; i++) {
						if (l[i].subCategoryId != -1)
							options += '<option value="' + l[i].subCategoryId + ',' + l[i].subCategoryDisplay + '">' + l[i].subCategoryDisplay + '</option>'
					}
					
					
					options += '<option selected value="-1,All Sub Categories">All Sub Categories</option>'
					
					$('#cboClaimSubCategory').html(options);
					
					$('#cboClaimSubCategory').each(function() {
						var selectedValue = $(this).val();
		 
						$(this).html($("option", $(this)).sort(function(a, b) {
							return a.text == b.text ? 0 : a.text < b.text ? -1 : 1
						}));
		 
						$(this).val(selectedValue);
					});
					
					
					
					
				})
				
				
				$.getJSON("../includes/json_wclaimsubreasons.asp",{categoryIds: $("#cboClaimCategory").val().split(",")[0], dcId: <%=Session("DCID")%>}, function(l){
				var options = '';
				var count = 0;
				
				for (var i = 0; i < l.length; i++) {
					if (l[i].claimSubReasonId != -1)
					{
						count += 1;
						options += '<option value="' + l[i].claimSubReasonId + ',' + l[i].description + '">' + l[i].description + '</option>'
					}
				}
					
					
				options += '<option value="0,None" selected>All Claim Sub-Reasons</option>'
					
					
				$('#cboClaimSubReason').html(options);
				
			})
	
	
	})			
})



$(function(){
	$("select#cboClaimReason").change(function(){
			$('#hidClaimReason').val($('#cboClaimReason').val());
		})
})			
</script>

</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="setSupplierSelectedVal(false);">
<form name="Index" id="Index" action="Index.asp<% If Request.QueryString("id") <> "" Then Response.Write "?id=1" %>" method="post" autocomplete = "off" > 
	<script type="text/javascript">
		$().ready(function() {
			$("#loading").bind("ajaxSend", function() {
				$(this).show();
			}).bind("ajaxComplete", function() {
				$(this).hide();
			});
		});
	</script>
	<div id="loading" class="pcontent" style="display:none">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img style=" vertical-align:middle; text-align:center" src="ajax-loader.gif"  height="21" width="21" alt="Loader"/><br />Loading...please wait.</div>
	<table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top"><h3>CLAIMS SEARCH AND LIST <% If IsHistory <> "" Then Response.Write("History") %></h3></td>
			
        </tr>
    </table>
    <table class="pcontent" border="0" width="100%">
		
		<tr>
		
			<td>DC:</td>
			<td>		
				
				<select name="cboDC" id="cboDC" class="pcontent">
					<% If Session("DCId") = 0 Then %>				
						<option value="-1,Not Selected">-- Select a DC --</option>
					<%
						End If
						
						selected = ""
						SqlCommand = "exec listDC @DC="  & Session("DCId")
						
						Set RecordSet = ExecuteSql("exec listDC @DC="  & Session("DCId"), SqlConnection) 
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("DCId") & "," & RecordSet("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
									'Response.Write RecordSet("DCId") & "," & RecordSet("DCcName") & " = "  & Request.Form("cboDC")
								Else 
									'If RecordSet("DCId") = 1 And Request.Form("cboDC") = "" Then 
									'	selected = "selected"
									'Else
										selected = ""
									'End If
								End If
					%>
							<option <%=selected%> value="<%=RecordSet("DCID")%>,<%=RecordSet("DCcName")%>"><%=RecordSet("DCcName")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If
					%>
				</select>

			</td>
			
			
		</tr>
		<tr>

			<td>Claim&nbsp;Type:</td>
			<td>
				<select name="cboClaimType" id="cboClaimType" class="pcontent">
					<%  If (IsHistory = "true" And (Request.Form("cboClaimType") = "1,Supplier Claim" And SupplierOrDC="Supplier")) Then  %>
							<option selected="selected" value="1,Supplier Claim">Supplier Claim</option>
							<option value="2,DC Claims">DC Claims</option>
							<option value="3,Warehouse Claim">Warehouse Claim</option>
					<%  ElseIf (IsHistory = "true" And (Request.Form("cboClaimType") = "2,DC Claims" Or SupplierOrDC="DC")) Then r %>
							<option value="1,Supplier Claim">Supplier Claim</option>
							<option selected="selected" value="2,DC Claims">DC Claims</option>
							<option value="3,Warehouse Claim">Warehouse Claim</option>
					<%	ElseIf (IsHistory = "true" And (Request.Form("cboClaimType") = "3,Warehouse Claim" And SupplierOrDC="Supplier")) Then  %>
							<option value="1,Supplier Claim">Supplier Claim</option>
							<option value="2,DC Claims">DC Claims</option>
							<option selected="selected" value="3,Warehouse Claim">Warehouse Claim</option>
					<%	ElseIf (SupplierOrDC = "Supplier" Or SupplierOrDC="WarehouseSupplier") Then 
							If (ShowWarehouseClaimType And Not OnlyWarehouse) And (Request.Form("cboClaimType") = "-1,All Claim Types") Then
							
					%>
								<option selected="selected" value="-1,All Claim Types">All Claim Types</option>
					<%
							ElseIf (ShowWarehouseClaimType And Not OnlyWarehouse) Then
					%>
								<option value="-1,All Claim Types">All Claim Types</option>
					<%
							End If

							If (OnlyWarehouse = False And (Request.Form("cboClaimType") = "1,Supplier Claim")) Then
								
					%>	
								<option selected="selected" value="1,Supplier Claim">Supplier Claim</option>
					<%		
							ElseIf (OnlyWarehouse = False) Then
					%>
								<option value="1,Supplier Claim">Supplier Claim</option>
					<%					
							End If
							' If DCEan is same as supplier ean, this is Warehouse
							If (ShowWarehouseClaimType And Request.Form("cboClaimType") = "3,Warehouse Claim") Or Session("IsWarehouseUser") Then %>
									
									
									<option <%If Request.Form("cboClaimType") = "3,Warehouse Claim" Then Response.Write "selected='selected'" %> value="3,Warehouse Claim">Warehouse Claim</option>
							<%  ElseIf ShowWarehouseClaimType Then %>
									<option value="3,Warehouse Claim">Warehouse Claim</option>
								
					<%		End If 
					  
					  
							If Session("StoreFormat") = "Build-It" Or Session("ProcEAN") = "6004930012137" Or Session("ProcEAN") = "SPARHEADOFFICE" Or Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("IsWarehouseUser") Or Session("UserType") = 2 Then 
					  
								If Request.Form("cboClaimType") = "4,Build It DC" Then %>
									<option selected="selected" value="4,Build It DC">Build It DC</option> <%		
								Else  %>
									<option value="4,Build It DC">Build It DC</option> <%
								End If
							End If
						
							If Session("ProcEAN") <> "6004930012137"  Then
								If Request.Form("cboClaimType") = "5,DC Vendor" And Session("UserType") <> 3  Then %>	
									<option selected="selected" value="5,DC Vendor">DC Vendor</option> <%
								ElseIf Not (Session("StoreFormat") = "Build-It") And Session("UserType") <> 3 Then %>
									<option value="5,DC Vendor">DC Vendor</option> 
						<%		End If
							End If
						ElseIf SupplierOrDC = "DC" Then %>
							<option selected="selected" value="2,DC Claims">DC Claims</option> <%
						
						End If %>
				</select>
			</td>
		</tr>
		<tr>
		
			<td>Claim&nbsp;Category:</td>
			<td colspan="3">
			<%
				'Response.Write Request.Form("cboClaimType") 
			%>
				<select name="cboClaimCategory" id="cboClaimCategory" class="pcontent">
						<option value="-1,All">All Categories</option>
					<%	
					'njar
						ClaimTypeId = -1
						
					
						
						
						If (Request.Form("cboClaimType") = "3,Warehouse Claim") Then
							ClaimTypeId = 3
						ElseIf Request.Form("cboClaimType") = "4,Build It DC" Then
							ClaimTypeId = 4
						ElseIf Request.Form("cboClaimType") = "5,DC Vendor" Then
							ClaimTypeId = 5
							
						ElseIf (SupplierOrDC = "Supplier" Or Request.Form("cboClaimType") = "1,Supplier Claim") Then
							ClaimTypeId = 1
						Else
							ClaimTypeId = 2
						End If
						
						If Request.Form("cboClaimType") = "-1,All Claim Types" Or (Request.Form("cboClaimType") = "" And (ClaimTypeId = 1 Or ClaimTypeId = 3) And ShowWarehouseClaimType And Not OnlyWarehouse) Then
							ClaimTypeId  = -1	
						End If
						
						selected = ""
						'If ClaimTypeId = 2 Then
							If Request.Form("cboDC") <> "" Then
								DCId = Split(Request.Form("cboDC"),",")(0)
							Else 
								DCId = Session("DCId")
							End If
							
							SqlCommand = "ListClaimsCategories @ClaimTypeId = " & ClaimTypeId  & ",@DCId=" & DCId 
							'If DCId <> "" Then
							'	SqlCommand = "ListClaimsCategories @ClaimTypeId = " & ClaimTypeId  & ",@DCId=" & Split(DCId,",")(0)
							'Else
							'	SqlCommand = "ListClaimsCategories @ClaimTypeId = " & ClaimTypeId  & ",@DCId=-1" 
							'End If
						'Else

						
						'End If
						Dim SelectedCategoryId 
						SelectedCategoryId = 0
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)   
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If Request.Form("cboClaimCategory") = RTrim(RecordSet("ClaimCategoryId")) & "," & RTrim(RecordSet("ClaimCategory")) Then
									selected = "selected"
									SelectedCategoryId = RecordSet("ClaimCategoryId")
								Else
									selected = ""
								End If
								
					%>
							<option <%=selected%> value="<%=RTrim(RecordSet("ClaimCategoryId"))%>,<%=RTrim(RecordSet("ClaimCategory"))%>"><%=RecordSet("ClaimCategory") %></option>
					<%
								RecordSet.MoveNext
							Wend
						End If				
					%>
				</select><%%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Claim&nbsp;Sub Category: <select name="cboClaimSubCategory" id="cboClaimSubCategory" class="pcontent">
					<% 
						If Request.Form("cboClaimSubCategory") <> "" Then
							Set RecordSet =  ExecuteSql("ListClaimSubCategories @ClaimCategoryIds=" _
								& SelectedCategoryId _
								& " , @DCId=" & DCId, SqlConnection)   
							
							selected = ""
							If Not (RecordSet.BOF And RecordSet.EOF) Then
								While Not RecordSet.EOF 
									If RecordSet("SubCategoryId") = CInt(Split(Request.Form("cboClaimSubCategory"),",")(0)) Then
										Selected = "selected"
									Else
										Selected = ""
									End If
								%>
									<option <%=Selected%> value="<%=RecordSet("SubCategoryId")%>,<%=RecordSet("ClaimSubCategoryName")%>"><%=RecordSet("ClaimSubCategoryName")%></option>
								<%
									RecordSet.MoveNext
								Wend
							End If
						Else
							%>
								<option selected value="-1,All Sub Categories">All Sub Categories</option>
							<%
						End If
					'SqlCommand = 
					%>
				</select>
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Claim&nbsp;Reason:
				<select name="cboClaimReason" id="cboClaimReason" class="pcontent">
					
					<% 
						Dim SelectedClaimReasonId 
						SelectedClaimReasonId = 0
						If Request.Form("cboClaimReason") <> "" Then 
							Set RecordSet =  ExecuteSql("ListClaimsCategoriesReasonCodes @ClaimTypeId=0, @ClaimCategoryId=" & Split(Request.Form("cboClaimCategory"),",")(0), SqlConnection)   
							If Not (RecordSet.BOF And RecordSet.EOF) Then
								If RecordSet("RecordCount") > 1 Then
					%>
								<option value="-1,All">All Reasons</option> 
					<%
								
								End If
								While Not RecordSet.EOF
									If Request.Form("cboClaimReason") = RTrim(RecordSet("ClaimReasonId")) & "," & RTrim(RecordSet("ClaimReasonDescription")) Then
										selected = "selected"
										'20171011ClaimCategoryId = RecordSet("ClaimReasonId")
										SelectedClaimReasonId = RecordSet("ClaimReasonId")
									Else
										selected = ""
									End If
					%>
									<option <%=selected%> value="<%=RTrim(RecordSet("ClaimReasonId"))%>,<%=RTrim(RecordSet("ClaimReasonDescription"))%>"><%=RecordSet("ClaimReasonDescription")%></option>
					<%
								
									RecordSet.MoveNext
								Wend
							Else
						%>
								<option value="-1,All">All Reasons</option> 
						<%
							End If
						
						Else
												%>
								<option value="-1,All">All Reasons</option> 
						<%

						End If
							
					
					%>
				</select>
				
			</td>
		
		
		</tr>
		<tr>
		
			<td>Claim&nbsp;Sub&nbsp;Reason</td>
				<td colspan="1">
					<select name="cboClaimSubReason" id="cboClaimSubReason" class="pcontent"> <%
						Counter = 0
						NoSelectMatch = True
						SqlSelect = "ListWClaimSubReasons @ClaimCategoryIds=" & SelectedCategoryId & ", @DCId=" & Session("DCId") & ", @ClaimReasonId=" & SelectedClaimReasonId
						
						Set RecordSetClaimSubReasons = ExecuteSql(SqlSelect, SqlConnection)
						If Not (RecordSetClaimSubReasons.EOF And RecordSetClaimSubReasons.BOF) Then
							While NOT RecordSetClaimSubReasons.EOF 
								If RecordSetClaimSubReasons("ClaimSubReasonId") <> -1 Then
									Counter = Counter + 1
									
									If RecordSetClaimSubReasons("ClaimSubReasonId") = CInt(Split(Request.Form("cboClaimSubReason"),",")(0)) Then
										selected = "selected"
										NoSelectMatch = False
									Else
										selected = ""
									End If
									%>
										<option <%=selected%> value='<%=RecordSetClaimSubReasons("ClaimSubReasonId")%>,<%=RecordSetClaimSubReasons("Description")%>'><%=RecordSetClaimSubReasons("Description")%></option>
									<%
								End If
								RecordSetClaimSubReasons.MoveNext
							Wend
						End If
						RecordSetClaimSubReasons.Close
						Set RecordSetClaimSubReasons = Nothing
						
						If NoSelectMatch Then
							selected = "selected"
						Else
							selected = ""
						End If
						%> 
						<option value="0,None" <%=selected%>>All Claim Sub-Reasons</option> 
					</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Outcome&nbsp;Reason:&nbsp;&nbsp;&nbsp;&nbsp; 
				<select name="cboOutcomeReason" id="cboOutcomeReason" class="pcontent">
				<option value="0,None" <%=selected%>>All Outcome Reasons</option> 
					<% 
						
						selected = ""
						SqlCommand = "exec ListClaimOutcomeReason @DCid="  & DCId  & ",@ReturnOnlyActive=1"
						
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection) 
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("ID") & "," & RecordSet("Value") = Request.Form("cboOutcomeReason") Then
									selected = "selected"
									'Response.Write RecordSet("DCId") & "," & RecordSet("DCcName") & " = "  & Request.Form("cboDC")
								Else 	
									selected = ""
								End If
					%>
							<option <%=selected%> value="<%=RecordSet("ID")%>,<%=RecordSet("Value")%>"><%=RecordSet("Value")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If
					%>
					
				</select>
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Buyer:&nbsp;<select name="cboBuyerName" id="cboBuyerName" class="pcontent">
					<option value="0,Not Selected">All Buyers</option>
						<%
							If Request.Form("cboDC") <> "" Then
								DCId =  Replace(Split(Request.Form("cboDC"),",")(0),"-1","0")
							Else
								DCId = Session("DCId")
							End If 
						
						
							selected = ""
							SqlCommand = "ListBuyers @DcId="  & DCId
							Set rsBuyers = ExecuteSql(SqlCommand, SqlConnection)     
							
							If Not (rsBuyers.EOF And rsBuyers.BOF) Then
								While NOT rsBuyers.EOF
									If rsBuyers("BUID") & "," & rsBuyers("BuyerName") = Request.Form("cboBuyerName") Then
										selected = "selected"
									ElseIf rsBuyers("BUID") & "," & rsBuyers("BuyerName") = BuyerId & "," & BuyerName Then
										selected = "selected"
									Else													
										selected = ""
									End If%>
								<option <%=selected%> value="<%=rsBuyers("BUID")%>,<%=rsBuyers("BuyerName")%>"><%=rsBuyers("BuyerName")%></option><%
						
									rsBuyers.MoveNext
								Wend
							End If
						%>
					</select>
				</td>
				
				
			<td><b></b></td>
			<td>
			</td>
			
		</tr>
		

		<tr class="slidingDiv">
			<td>Supplier:</td>
			<td colspan="3">
		
				<select name="cboSupplier" id="cboSupplier" class="pcontent" onchange="setSupplierSelectedVal(true);">
<%
						
						If Request.Form("cboDC") <> "" Then
							DCId =  Replace(Split(Request.Form("cboDC"),",")(0),"-1","0")
						Else
							DCId = Session("DCId")
						End If 
						
						If (Session("UserType") <> 1 And Session("UserType") <> 4)  Then ' Or ClaimTypeId=5 
%>
					<option value="-1,Not Selected,-1">All suppliers</option>
<%
							SqlCommand = "exec listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & DCId 
						Else
							If Session("UserType") = 4 Then
								SqlCommand = "exec listScheduleSupplier @SupplierID=" & Session("ProcID")  & ",  @DCId=" & DCId
							Else
								If Session("IsWarehouseUser")  Then
									SqlCommand = "exec listSupplier @SupplierID=0, @UserType=" & Session("UserType") & ", @DCId=" & DCId 
								Else
									SqlCommand = "exec listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & DCId
								End If
							End If
							
							
						End If
						
						
						SqlCommand = SqlCommand &",@ClaimTypeId=" & ClaimTypeId
						
						
						'response.end
						Selected = ""
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)       
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							'If RecordSet("RecordCount") > 1 Then
							If  Session("IsWarehouseUser") And Session("ProcEan") <> "6004930012137" Then
							 %>
								<option value="-1,All suppliers,-1" selected="selected">All suppliers</option>
							
							<%
							End If
						
							While NOT RecordSet.EOF
								If (RecordSet("SupplierId") & "," & RecordSet("SupplierName") & "," & RecordSet("VendorCode") = Request.Form("cboSupplier")) Or _
									(RecordSet("SupplierId") & "," & RecordSet("SupplierName") & "," & RecordSet("VendorCode") = Request.Form("hidSupplier")) Then
									selected = "selected"
								Else
									selected = ""
								End If
					%>
							<option <%=selected%> value="<%=RecordSet("SupplierId")%>,<%=RecordSet("SupplierName")%>,<%=RecordSet("VendorCode")%>"><%=RecordSet("SupplierName")%></option>
					<%
								RecordSet.MoveNext
							Wend
						Else
					%>
							<option selected="selected" value="0,No suppliers available,0">No suppliers available</option>
					<%
						End If				
					%>
				</select>&nbsp;
				
				<%
				'response.write  SqlCommand
				%>
			</td>
		
		</tr>	
		<tr class="slidingDiv">
			<td></td>
			<td colspan="3">
					<%
					'	If CInt(Session("UserType")) <> 1 and CInt(Session("UserType")) <> 4 then
					%>
					
					<b class="pcontent">OR</b>&nbsp;Supplier&nbsp;Partial&nbsp;Name:&nbsp;
			</td>
		</tr>
		<tr class="slidingDiv">
			<td>
			</td>
			<td colspan="3">
					<input type="text" name="txtPartialSup" id="txtPartialSup" class="pcontent" size="60" value="<%=Request.Form("txtPartialSup")%>">
					<button name="btnFilter" id="btnFilter" value="Find" class="button" type="button" OnClick="javascript:partialSupSearch();">Find</button>
					<%
					'	end if
					%>
			</td>
		</tr>
		<tr>
			<td>Store&nbsp;Format:</td>
			<td>
				<select name="cboStoreFormat" id="cboStoreFormat" class="pcontent">
				
				<% 	
					If Session("ProcEan") = "6004930012137" Then %>
						<option selected value="Build-It" >Build-It</option>
				<%	
					ElseIf Session("UserType") <> 3 Then 
						SqlCommand = "GetStoreFormats @StoreId=0"
				%>
						<option value="All Formats">All Formats</option>	
					
				<% 
					Else
						SqlCommand = "GetStoreFormats @StoreId=" & Session("ProcID") 
					End If 
						
						
					If Session("ProcEan") <> "6004930012137" Then
						selected = ""
						'Response.Write Session("ProcID") 
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)  
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If Trim(RecordSet("StoreType")) = Trim(Request.Form("cboStoreFormat")) Then 
									selected = "selected"
								Else
									selected = ""
								End If 
					%>
							<option <%=selected%> value="<%=RecordSet("StoreType")%> " ><%=RecordSet("StoreType")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If				
					End If
					%>
				</select>
			</td>
		</tr>
		
        <tr>
            <td>Store:</td>
			<td>
				<select name="cboStore" id="cboStore" class="pcontent">
				<% If Session("UserType") <> 3 Then %>
					<option value="-1">All Stores</option>	
				<% End If %>
				<%
						If Session("UserType") = 1 Or Session("UserType") = 4 Then
							If Request.Form("cboDC") = "" Then
								SqlCommand = "listStores @SupplierID="  & Session("ProcID") & ", @UserType=" & Session("UserType")  & ", @DCID="  & Session("DCID") & ", @SupplierEan='" & Session("ProcEAN") & "'"
							Else
								SqlCommand = "listStores @SupplierID="  & Session("ProcID") & ", @UserType=" & Session("UserType")  & ", @DCID=" & Split(Request.Form("cboDC"),",")(0) & ", @SupplierEan='" & Session("ProcEAN") & "'"
							End If
						ElseIf Session("UserType") = 3 Then
							If Request.Form("cboDC") = "" Then
								SqlCommand = "listStores @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCID=0" 
							Else
								SqlCommand = "listStores @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCID=" & Replace(Split(Request.Form("cboDC"),",")(0),-1,0)								
							End If
						Else
							If Request.Form("cboDC") = "" Then
								SqlCommand = "listStores @SupplierID=0, @UserType=" & Session("UserType")  & ", @DCID=" & Session("DCId")
							Else
								SqlCommand = "listStores @SupplierID=0, @UserType=" & Session("UserType")  & ", @DCID=" & Replace(Split(Request.Form("cboDC"),",")(0),-1,0)
							End If
						End If
						selected = ""
						

						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)   
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("StoreId") & "," & RecordSet("StoreName") & " (" & RecordSet("StoreCode") & ")" = Request.Form("cboStore") Then
									selected = "selected"
								Else
									selected = ""
								End If
								
								
					%>
							<option <%=selected%> value="<%=RecordSet("StoreId")%>,<%=RecordSet("StoreName")%> (<%=RecordSet("StoreCode")%>)" ><%=RecordSet("StoreName") & " (" & RecordSet("StoreCode") & ")"%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If				

					%>
				
					
				</select>
			</td>
		<%
		'Response.write SqlCommand
						'response.write "test"
		%>
        </tr>
		
		<tr>
            <td>Claim&nbsp;Status:</td>
			<td>
				<select name="cboClaimStatus" id="cboClaimStatus" class="pcontent">
					<% If IsHistory <>  "" Then %>
						<% If Trim(Request.Form("cboClaimStatus")) = "-7,All claims assigned to history" Then %>
							<option selected value="-7,All claims assigned to history">All claims assigned to history</option>	
						<% Else %>
							<option value="-7,All claims assigned to history">All claims assigned to history</option>	
						<% End If %>
						
						<% If Trim(Request.Form("cboClaimStatus")) = "-3,All closed claims < 30 days" Then %>
							<option selected value="-3,All closed claims < 30 days">All closed claims < 30 days</option>	
						<% Else %>
							<option value="-3,All closed claims < 30 days">All closed claims < 30 days</option>	
						<% End If %>

						<% If Trim(Request.Form("cboClaimStatus")) = "-6,All closed claims > 30 days" Then %>
							<option selected value="-6,All closed claims > 30 days">All closed claims > 30 days</option>	
						<% Else %>
							<option value="-6,All closed claims > 30 days">All closed claims > 30 days</option>	
						<% End If %>

						
						<% If Trim(Request.Form("cboClaimStatus")) = "5,Rejected by supplier" Then %>
							<option selected value="5,Rejected by supplier">Rejected by supplier</option>	
						<% Else %>
							<option value="5,Rejected by supplier">Rejected by supplier</option>	
						<% End If %>

						<% If Trim(Request.Form("cboClaimStatus")) = "10,Credit received from supplier" Then %>
							<option selected value="10,Credit received from supplier">Credit received from supplier</option>	
						<% Else %>
							<option value="10,Credit received from supplier">Credit received from supplier</option>	
						<% End If %>
					<%
					Else
						selected = ""
						SqlCommand = "GetClaimStatus"  
						
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)   
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If Trim(Request.Form("cboClaimStatus")) = Trim(RecordSet("Id")) & "," & Trim(RecordSet("Value")) Or (Request.Form("cboClaimStatus") = "" And Trim(RecordSet("Id")) & "," & Trim(RecordSet("Value")) = "-1,All Open Claims < than 30 days") Then
									selected = "selected"
								Else
									selected = ""
								End If
								
								%>
								<option <%=selected%> value="<%=RecordSet("Id")%>,<%=RecordSet("Value")%>"><%=RecordSet("Value")%></option>
								<%
								
								RecordSet.MoveNext
							Wend
						End If				
					End If 
					%>
				</select>
			</td>
		</tr>	
		<tr>
			<td>Claim&nbsp;Number:</td>
			<td>
				<input type="text" name="txtClaimNumber" id="txtClaimNumber" size="10" class="pcontent" value="<%=Request.Form("txtClaimNumber")%>"/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				Manual&nbsp;Claim&nbsp;Number:
				<input type="text" name="txtManualClaimNumber" id="txtManualClaimNumber" size="10" class="pcontent" value="<%=Request.Form("txtManualClaimNumber")%>"/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Discount&nbsp;Note&nbsp;Number:
				<input type="text" name="txtCreditNoteNumber" id="txtCreditNoteNumber" size="10" class="pcontent" value="<%=Request.Form("txtCreditNoteNumber")%>"/>
			</td>
		</tr>
		<tr>
            <td>From&nbsp;Date:</td>
			<td class="pcontent" colspan="3">
				<input type="text" name="txtFromDate" id="txtFromDate" size="10" class="pcontent" value="<%=Request.Form("txtFromDate")%>"><b>[dd/mm/yyyy]</b>
				&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To&nbsp;Date:
				<input type="text" name="txtToDate" id="txtToDate" size="10" class="pcontent" value="<%=Request.Form("txtToDate")%>"><b>[dd/mm/yyyy]</b>
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Attachment:&nbsp;<%
					WithWithoutAttachment = ""
					WithAttachment = ""
					WithoutAttachment = ""
					Select Case Request.Form("cboClaimWithOrWithoutAttachment")
						Case "-1"
							WithWithoutAttachment = "selected"
						Case "1"
							WithAttachment = "selected"
						Case "0"
							WithoutAttachment = "selected"
					End Select
				
				%><select id="cboClaimWithOrWithoutAttachment" name="cboClaimWithOrWithoutAttachment" class="pcontent">
					<option <%=WithWithoutAttachment%> value="-1">Claims with and without document attachments</option>
					<option <%=WithAttachment%> value="1">Claims with document attachments</option>
					<option <%=WithoutAttachment%> value="0">Claims without document attachments</option>
				</select>&nbsp;</td>
        </tr>
		<tr>
			<td></td>
			<td style="color: red"><i><strong>Please note: You cannot search for claims older that 5 years from the current date.<strong></i></td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Search" class="button"/>&nbsp;
				<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="javascript:window.close();"/>
				<input type="hidden" name="DoSearch" id="DoSearch" value="True"/>
				<input type="hidden" name="hidSupplier" id="hidSupplier" value="<%=SupplierId%>" />
				<input type="hidden" name="hidIsHistory" id="hidIsHistory" value="<%=IsHistory%>" />
				<input type="hidden" name="hidCurrentPageNumber" id="hidCurrentPageNumber" value="<%=CurrentPageNumber%>" />
				<input type="hidden" name="hidSupplierOrDC" id="hidSupplierOrDC" value="<%=SupplierOrDC%>" />
				<input type="hidden" name="hidClaimReason" id="hidClaimReason" value="<%=Request.Form("hidClaimReason")%>" />
			</td>
		</tr>
    </table>
	
	<%
	
	%>
	<table border="1" id="claims" name="claims" cellpadding="0" cellspacing="0" width="100%">
	
<%
	Dim rsGrid 
	Dim NewConnection
	Dim CommandText
	
	
	Set NewConnection = Server.CreateObject ("ADODB.Connection")
	NewConnection.Open const_db_ConnectionString
	'Response.Write const_db_ConnectionString
	
	If Request.Form("DoSearch") = "True" Then
		Dim ClaimReasonIdSearch
		ClaimReasonIdSearch = -1
		
		If InStr(Request.Form("hidClaimReason"),",") > 0 Then
			ClaimReasonIdSearch = Split(Request.Form("hidClaimReason"),",")(0)
		End If
		
		Dim ClaimCategoryReasonId
		ClaimCategoryReasonId = Split(Request.Form("cboClaimReason"),",")(0)
		 
		
		Dim VendorCodeArray, VendorCodeIdx
		VendorCodeArray = Split(Request.Form("hidSupplier"),",")
		VendorCodeIdx = UBound(VendorCodeArray)
		
		Dim ClaimSubCategoryId
		Dim ClaimWithOrWithoutAttachment
		
		ClaimWithOrWithoutAttachment = CStr(Request.Form("cboClaimWithOrWithoutAttachment"))
		ClaimSubCategoryId = Split(Request.Form("cboClaimSubCategory"),",")(0)
		ClaimSubReasonId = Split(Request.Form("cboClaimSubReason"),",")(0)
		StoreFormat = Replace(Request.Form("cboStoreFormat"),"'","''")
		SelectedBuyer = split(Request.Form("cboBuyerName"),",")(0)
		If StoreFormat = "All Formats" Then StoreFormat = ""
		
		
		
		CommandText = "SearchAndListClaimsGrid @DCId='" & Split(Request.Form("cboDC"),",")(0) _
			& "',@SupplierId='" & Split(Request.Form("hidSupplier"),",")(0) _
			& "',@VendorCode='" &  VendorCodeArray(VendorCodeIdx) _
			& "',@StoreId='" & Split(Request.Form("cboStore"),",")(0) _
			& "',@ClaimStatusId='" & Split(Request.Form("cboClaimStatus"),",")(0) _
			& "',@ClaimCategoryId='" & Split(Request.Form("cboClaimCategory"),",")(0) _
			& "',@FromDate='" & Replace(Request.Form("txtFromDate"),"'","''") _
			& "',@ToDate='" & Replace(Request.Form("txtToDate"),"'","''") _
			& "',@PageNumber=" & CurrentPageNumber _
			& ",@ClaimTypeId=" & CInt(Split(Request.Form("cboClaimType"),",")(0)) _
			& ",@ClaimNumber='" & Replace(Request.Form("txtClaimNumber"),"'","''") _
			& "',@ManualClaimNumber='" & Replace(Request.Form("txtManualClaimNumber"),"'","''") _
			& "',@CreditNoteNumber='" & Replace(Request.Form("txtCreditNoteNumber"),"'","''") _
			& "',@ClaimReasonId=" & ClaimCategoryReasonId _
			& ", @ClaimSubCategoryId=" & ClaimSubCategoryId _
			& ", @ClaimSubReasonId=" & ClaimSubReasonId _
			& ", @StoreFormat='" & StoreFormat _
			& "',@OutcomeReason='" & Split(Request.Form("cboOutcomeReason"),",")(0) & "'" _
			& ", @HasAttachments=" & ClaimWithOrWithoutAttachment _
			& ", @BuyerId=" & SelectedBuyer
			
			'Response.Write CommandText

			If IsHistory = "true"  Then
				CommandText = CommandText & ",@IsHistoryYN='Y'"
			End If
	Else
		Dim LoggedInSupplierId
		LoggedInSupplierId = -1
		If Session("UserType") = 4 Or Session("UserType") = 1 Then
			LoggedInSupplierId = Session("ProcId")
		End If
		
		Dim LoggedInStoreId
		LoggedInStoreId = -1
		If Session("UserType") = 3 Then
			LoggedInStoreId = Session("ProcId")
		End If
		
		Dim SelectedDCId 
		SelectedDCId = -1
		If CInt(Session("DCId")) <> 0 Then
			SelectedDCId = CInt(Session("DCId"))
		End If
		
		If (ShowWarehouseClaimType And Not OnlyWarehouse And SupplierOrDC = "Supplier") Then
			ClaimTypeId = -1
		ElseIf OnlyWarehouse  Then
			ClaimTypeId = 3
		ElseIf Session("UserType") = 1 Or  Session("UserType") = 4 OR SupplierOrDC = "Supplier" Then
			ClaimTypeId = 1
		Else
			ClaimTypeId = 2
		End If
		

		CommandText = "SearchAndListClaimsGrid @DCId=" & SelectedDCId _
			& ",@SupplierId=" & LoggedInSupplierId _
			& ",@VendorCode=-1" _
			& ",@StoreId=" & LoggedInStoreId _
			& ",@ClaimStatusId=-7" _
			& ",@ClaimReasonId=-1" _
			& ",@PageNumber=1" _
			& ",@ClaimTypeId=" & ClaimTypeId _
			& ",@ClaimCategoryId=-1" 
			
				
		
		If IsHistory = "true"  Then
			CommandText = CommandText & ",@IsHistoryYN='Y'"
		End If

	End If
		
	'Response.Write CommandText
	Set rsGrid = NewConnection.Execute(CommandText)  'ExecuteSql(CommandText, NewConnection)  
			
	
			
	If Not (rsGrid.EOF And rsGrid.BOF) Then
%>
	<input type="button" name="btnPrintClaimLog" id="btnPrintClaimLog" value="Print Claim Log" class="button" onclick="javascript:window.print();">
	<tr>
	<%response.write AuthorisedByRep %>
		<td class="pcontent" align="center">Displaying <%If rsGrid("PageSize") > rsGrid("TotalRecords") Then Response.Write rsGrid("TotalRecords") Else Response.Write rsGrid("PageSize")%> records out of a total of <%=rsGrid("TotalRecords")%> records.</td>
		<td class="pcontent" align="center">Records <%=rsGrid("RowNumber")%> to 
		<%
			If CLng(rsGrid("RowNumber")) + CLng(rsGrid("PageSize")) > rsGrid("TotalRecords") Then
				Response.Write rsGrid("TotalRecords")
			Else
				Response.Write CLng(rsGrid("RowNumber")) - 1 + CLng(rsGrid("PageSize"))
			End If
		%> are currently displayed.</td>
		<td class="pcontent" align="left" colspan="50">
		<%
			If Not IsNumeric(Request.Form("hidCurrentPageNumber")) Or Request.Form("hidCurrentPageNumber") = "" Then
				hidCurrentPageNumber = 1
			Else
				hidCurrentPageNumber = CInt(Request.Form("hidCurrentPageNumber"))
			End If
		
			If hidCurrentPageNumber > 1 Then
				Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber - 1 & ")'>Previous Page</a>" & " | " 
			End If
		
			If hidCurrentPageNumber < Int(rsGrid("TotalRecords") / rsGrid("PageSize") + 1) Then
				Response.Write "<a href='javascript: SetPage(" & hidCurrentPageNumber + 1 & ")'>Next Page</a>" & " | " 
			End If

			Dim TotalPages 
			TotalPages = Int(rsGrid("TotalRecords") / rsGrid("PageSize") + 1)
			FromPage = hidCurrentPageNumber - 4
			ToPage = hidCurrentPageNumber + 4
			If FromPage < 1 Then
				FromPage = 1
			End If
			If ToPage > TotalPages Then
				ToPage = TotalPages - 4
			End If

			Response.Write "<a href='javascript: SetPage(1)'>First Page</a>" & " | "
			If hidCurrentPageNumber = 0 Then
				Response.Write "<b>Page 1 |</b> "
			End If
			For i = FromPage To ToPage + 4
				If i <= TotalPages Then 
					If Cint(hidCurrentPageNumber) = i Then
						Response.Write "<b>Page " & i & " |</b> "
					Else
						Response.Write "<a href='javascript: SetPage(" & i & ")'>Page " & i & "</a>" & " | "
					End If
				Else
					Exit For
				End If
			Next
			Response.Write "<a href='javascript: SetPage(" &  TotalPages & ")'>Last Page</a>" & " | "
		%>
		</td>
		
	</tr>

	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>DC</b></td>
		<td class="tdcontent" align="center"><b>Supplier</b></td>
		<td class="tdcontent" align="center"><b>Vendor Name</b></td>
		<td class="tdcontent" align="center"><b>Vendor Code</b></td>
		<td class="tdcontent" align="center"><b>Store</b></td>
		<td class="tdcontent" align="center"><b>Format</b></td>
		<td class="tdcontent" align="center"><b>Claim Number</b></td>
		<td class="tdcontent" align="center"><b>Date Received</b></td>
		<td class="tdcontent" align="center"><b>Claim Status</b></td>
		<td class="tdcontent" align="center"><b>Attachment</b></td>    <!--Column name in grid for attachments -->
		<td class="tdcontent" align="center"><b>Manage Claim</b></td>
		<td class="tdcontent" align="center"><b>Date last updated</b></td>
		<td class="tdcontent" align="center"><b>Claim Type</b></td>
		<td class="tdcontent" align="center"><b>Claim Category</b></td>
		<td class="tdcontent" align="center"><b>Claim Sub-Category</b></td>
		<td class="tdcontent" align="center"><b>Claim Reason</b></td>
		<td class="tdcontent" align="center"><b>Claim Sub Reason</b></td>
		<td class="tdcontent" align="center"><b>Buyer Name</b></td> <!--Column name in grid for buyer name-->
		<td class="tdcontent" align="center"><b>Buyer Email</b></td> <!--Column name in grid for buyer email-->
		<td class="tdcontent" align="center"><b>Outcome Reason</b></td>
		<td class="tdcontent" align="center"><b>Authorised by Rep</b></td>
		<td class="tdcontent" align="center"><b>Uplift/ DC Ref</b></td>
		
		<td class="tdcontent" align="center"><b>Manual Claim Number</b></td>
		<td class="tdcontent" align="center"><b>Invoice Number</b></td>
		<td class="tdcontent" align="center"><b>Invoice Date</b></td>
		<td class="tdcontent" align="center"><b>DC Credit/Pro-Forma Credit Note</b></td>
		<td class="tdcontent" align="center"><b>DC Credit/Pro-Forma Credit Note Amount</b></td>
		<td class="tdcontent" align="center"><b>Supplier Credit Note</b></td>
		<td class="tdcontent" align="center"><b>Supplier Credit Note Amount</b></td>
	</tr>
<%
	While NOT rsGrid.EOF
%>
			<tr>
				<td class="pcontent" align="center" width="50px" ><%=Replace(rsGrid("DCcName"),"SPAR ","")%></td>
				<td class="pcontent" align="center"><%=rsGrid("SPcName")%></td>
				<td class="pcontent" align="center"><%=rsGrid("VendorName")%></td>
				<td class="pcontent" align="center"><%=rsGrid("VendorCode")%></td>
				<td class="pcontent" align="center"><%=rsGrid("STcName")%></td>
				<td class="pcontent" align="center"><%=rsGrid("STcFormatTypeDesc")%></td>
				<td class="pcontent" align="center"><a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/claim/default.asp?item=<%=rsGrid("CLID")%>" target="_blank"><%=rsGrid("CLcClaimNumber")%></a></a></td>
				<td class="pcontent" align="center"><%=rsGrid("CLdReceivedDate")%></td>
				<td class="pcontent" align="center"><%=rsGrid("ClaimStatus")%></td>
				
				<!--If the claim has attachments insert a paperclip in the column, else column is empty-->
<%
				If rsGrid("HasAttachments")  Then
%>			
					<td class="pcontent" align="center"><a href="ClaimDocuments.asp?cid=<%=rsGrid("CLID")%>" target="_blank"><img src='/dropship/claims/icons/paperclip.jpg' id='paperclip' class="paperclip" width='20' height='20' border='0' "/></a></td>
<%
				Else	
%>	
					<td class="pcontent" align="center">-</td>	
					
<%
				End if	
%>	
				<td class="pcontent" align="center"><a href="<%=const_app_ApplicationRoot%>/claims/manageclaim.asp?cid=<%=rsGrid("CLID")%>&h=<%=IsHistory%>&tid=<%=ClaimTypeId%>" target="_blank">Manage</a></td>
				<td class="pcontent" align="center"><%If IsNull(rsGrid("LastUpdated")) Then Response.Write "-" Else Response.Write(rsGrid("LastUpdated")) End If %></td>
				<td class="pcontent" align="center"><%=rsGrid("CLcClaimType")%></td>
				<td class="pcontent" align="center"><%=rsGrid("ClaimCategory")%></td>
				<td class="pcontent" align="center"><%=rsGrid("ClaimSubCategoryName")%></td>
				<td class="pcontent" align="center"><%=rsGrid("ClaimReason")%></td>
				<td class="pcontent" align="center"><%If IsNull(rsGrid("ClaimSubReason")) Then Response.Write "-" Else Response.Write(rsGrid("ClaimSubReason")) End If%></td>
				<td class="pcontent" align="center"><%If IsNull(rsGrid("BuyerName")) Then Response.Write "-" Else Response.Write(rsGrid("BuyerName")) End If%></td>
				<td class="pcontent" align="center"><div id="BuyerEmail" >
				  <%If IsNull(rsGrid("BuyerEmailAddress")) Then 
						Response.Write "-" 
					Else%>
						<a href="mailto:<%=rsGrid("BuyerEmailAddress")%>"><%=rsGrid("BuyerEmailAddress")%></a>
				<% End If%></div></td>
				<td class="pcontent" align="center"><%=rsGrid("OutcomeReasonValue")%></td>
				<td class="pcontent" align="center"><%if rsGrid("Authorised") then response.write "Yes" else response.write "No"  end if%></td>
				<td class="pcontent" align="center"><%=rsGrid("UpliftRef")%></td>
				<td class="pcontent" align="center"><%If IsNull(rsGrid("ManualClaimNumber")) Or Trim(rsGrid("ManualClaimNumber")) = "" Then Response.Write "-" Else Response.Write(rsGrid("ManualClaimNumber")) End If %></td>
				<td class="pcontent" align="center">
<%
													If IsNull(rsGrid("CLcInvoiceNumber")) Or  rsGrid("CLcInvoiceNumber") = "" Then 
														Response.Write "-" 
													Else 
														if rsGrid("CLiInvoiceID") = "" or IsNull(rsGrid("CLiInvoiceID")) then
															Response.Write(rsGrid("CLcInvoiceNumber")) 
														else
%>
					<a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/invoice/default.asp?item=<%=rsGrid("CLiInvoiceID")%>" target="_blank"><%=rsGrid("CLcInvoiceNumber")%></a>
<%														
														end if
													End If
%>
				</td>
				<td class="pcontent" align="center"><%If IsNull(rsGrid("CLdInvoiceDate")) Or rsGrid("CLdInvoiceDate") = "" Then Response.Write "-" Else Response.Write rsGrid("CLdInvoiceDate") End If%></td>
				
				<%If rsGrid("ForceCreditInEffect") = 1 Then
					If IsNull(rsGrid("ProFormaCreditNoteNumber")) Or Trim(rsGrid("ProFormaCreditNoteNumber")) = "" Then
						' Display Actual Credit Note
					%><td class="pcontent" align="center">-</td><td class="pcontent" align="center">-</td><td class="pcontent" align="center"><%
						If IsNull(rsGrid("CLiCNID")) Or rsGrid("CLiCNID") = "" Or rsGrid("CLiCNID") = 0  Then 
							Response.Write "-" 
						Else %>
							<a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/creditnote/default.asp?item=<%=rsGrid("CLiCNID")%>&reason=" target="_blank"><%=rsGrid("CreditNoteNumber")%></a>
<%						End If%></td>
						<td class="pcontent" align="center"><%If IsNull(rsGrid("CreditNoteAmount")) or rsGrid("CreditNoteAmount") = "" Then Response.Write "-" Else Response.Write(FormatNumber(rsGrid("CreditNoteAmount"),2)) End If%></td><%
					Else 
						If rsGrid("CreditNoteIsForceCredit") = 0 Then
						%><td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditNoteNumber")) Or rsGrid("ProFormaCreditNoteNumber") = "" Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditNoteNumber")) End If%></td>
					  <td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditAmount")) or rsGrid("ProFormaCreditAmount") = "" Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditAmount")) End If%></td><td class="pcontent" align="center"><%
							If IsNull(rsGrid("CLiCNID")) Or rsGrid("CLiCNID") = "" Or rsGrid("CLiCNID") = 0  Then 
								Response.Write "-" 
							Else %>
								<a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/creditnote/default.asp?item=<%=rsGrid("CLiCNID")%>&reason=" target="_blank"><%=rsGrid("CreditNoteNumber")%></a>
	<%						End If%></td>
							<td class="pcontent" align="center"><%If IsNull(rsGrid("CreditNoteAmount")) or rsGrid("CreditNoteAmount") = "" Then Response.Write "-" Else Response.Write(FormatNumber(rsGrid("CreditNoteAmount"),2)) End If%></td><%
						Else
					%><td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditNoteNumber")) Or rsGrid("ProFormaCreditNoteNumber") = "" Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditNoteNumber")) End If%></td>
					  <td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditAmount")) or rsGrid("ProFormaCreditAmount") = "" Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditAmount")) End If%></td>
					  <td class="pcontent" align="center">-</td><td class="pcontent" align="center">-</td><%
						End If
					End If
				Else
					If IsNull(rsGrid("CLiCNID")) Or rsGrid("CLiCNID") = "" Or rsGrid("CLiCNID") = 0 Then 
					  %><td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditNoteNumber")) Or rsGrid("ProFormaCreditNoteNumber") = "" Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditNoteNumber")) End If%></td>
						<td class="pcontent" align="center"><%If IsNull(rsGrid("ProFormaCreditAmount")) Or rsGrid("ProFormaCreditAmount") = "" Or rsGrid("ProFormaCreditAmount") = "0"  Then Response.Write "-" Else Response.Write(rsGrid("ProFormaCreditAmount")) End If%></td>
						<td class="pcontent" align="center">-</td><td class="pcontent" align="center">-</td><%
					Else %>
						<td class="pcontent" align="center">-</td><td class="pcontent" align="center">-</td>
						<td class="pcontent" align="center"><a href="<%=const_app_ApplicationRoot%>/track/<%=Folder%>/creditnote/default.asp?item=<%=rsGrid("CLiCNID")%>&reason=" target="_blank"><%=rsGrid("CreditNoteNumber")%></a></td>
						<td class="pcontent" align="center"><%If IsNull(rsGrid("CreditNoteAmount")) or rsGrid("CreditNoteAmount") = "" Then Response.Write "-" Else Response.Write(FormatNumber(rsGrid("CreditNoteAmount"),2)) End If%></td>
<%					End If
				End If%>
			</tr>
<%
			rsGrid.MoveNext
		Wend
	Else
%>
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center">
			<b>No claims that match your search criteria</b>
		</td>
	</tr>
<%
	End If

	
%>
	</table>

</form>
<script language="JavaScript">
<!-- // create calendar object(s) just after form tag closed
	 // specify form element as the only parameter (document.forms['formname'].elements['inputname']);
	 // note: you can have as many calendar objects as you need for your application
	var cal1 = new calendar1(document.forms['Index'].elements['txtFromDate']);
	cal1.year_scroll = false;
	cal1.time_comp = false;		
	var cal2 = new calendar1(document.forms['Index'].elements['txtToDate']);
	cal2.year_scroll = false;
	cal2.time_comp = false;
//-->
</script>

<script>
// there's nothing we can do if the browser doesn't have localStorage
if (window.localStorage) {
    var ls = window.localStorage;
    // timeout needed to fire after harlowe resets document   
    // scrollTop position to 0 rather than before
    window.setTimeout(function() {
        // sets the scroll to the previous, saved value, or to 0 if no value is saved.
        var val = Number(ls['zcwScrollPosition']);
        $(document).scrollTop(val);
    }, 50);
    
    // updates the saved value whenever the user scrolls.
    $(document).scroll(function(e) {
        ls['zcwScrollPosition'] = $(document).scrollTop();
    });
    
    // remove the event when the user navigates to a different passage.
    $('tw-link, tw-icon.undo, tw-icon.redo').click(function() {
        $(document).off('scroll');
    });
}
</script>

</body>
</html>

