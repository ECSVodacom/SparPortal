<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%

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
	Dim SupplierOrDC
	
	
	
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
	ElseIf Request.Form("cboClaimType") = "1,Supplier Claim" Or Request.Form("cboClaimType") = "3,Warehouse Claim" Or Request.Form("cboClaimType") = "-1,All Claim Types" Then
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
	
	
	If InStr(DCEanCodes, Session("ProcEAN")) > 0 And Session("UserType") = 1 Then
		OnlyWarehouse = True
		ShowWarehouseClaimType = True
		SupplierOrDC = "WarehouseSupplier"
	End If

		
	
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
	
	'Check if the user is logged on
	Call LoginCheck (const_app_ApplicationRoot & "/password/default.asp")

	'Declare variables
	dim SQL
	dim curConnection
	dim ReturnSet
	dim Counter
	'dim SearchType
	'dim SearchOn

	PageTitle = "Lookup"

	Counter = 0
%>
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	if ('<%=Session("UserName")%>'=='GATEWAYCALLCEN') {
		setTimeout('document.location=document.location',180000);	
	};
//-->
</script>
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script type="text/javascript" src="../includes/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">

$(function(){
	$("select#drpSearchProfileType").change(function(){
		var options = "<option value='-1'>-------- Search On -------</option>"
		if ($(this).val() != "2") {
			options += "<option value='1'>Store</option>" 
			if ('<%=Session("ProcName")%>' == 'SPAR HEAD OFFICE' || '<%=session("UserType")%>' != '2')
			{
				options += "<option value='3'>DC</option>"				
			}		
		}
		options += "<option value='2'>Supplier</option>"
		options += "<option value='4'>DC USer</option>"
		
		$("#drpSearchOn").html(options);
	})
})
</script>

<script language="javascript">
	function validate(obj) {
		// Check if the user selected a Search Type
		if (obj.SearchType.value=='-1') {
			window.alert ('Please select a search type.');
			obj.SearchType.focus();
			return false;
		};
	
		// Check if the user selected a entity to search on
		if (obj.txtSearchOn.value=='-1') {
			window.alert ('Please enter a value to search for.');
			obj.SearchOn.focus();
			return false;
		};
		
		// Check if the user entered a user name
		if (obj.txtUserName.value=='') {
			window.alert ('Please enter a User Name.');
			obj.txtUserName.focus();
			return false;
		};
	};
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" >


<%
								if Request.Form("hidAction") = 1 then
									'Build SQL
									SQL = "exec SearchUserDetails @ToSearch=" & MakeSQLText(Request.Form("txtToSearch")) & _
										", @SearchType=" & MakeSQLText(Request.Form("drpSearchType")) & _
										", @SearchOn=" & MakeSQLText(Request.Form("drpSearchOn")) _
										& ", @DCid=" & Session("DCID") _
										& ", @SearchProfileType=" & MakeSQLText(Request.Form("drpSearchProfileType"))
										
									
								
									'.write SQL
									'response.write ReturnSet("returnvalue")
									'Execute SQL
									Set ReturnSet =  ExecuteSql(SQL, SQLConnection) 
%>

	
<p class="bheader">Results</p>

<hr>
<%
									'Check the return value
									
									'response.write "test"
									if ReturnSet("returnvalue") <> 0 then
									
										'An error occured - display an error message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<hr>
<%
									else   
%>



<p class="pcontent"><b>Search result: <b><p>
<table border="2" cellpadding="2" cellspacing="2" colspan="3" width="65%">
	<tr>
	    <td class="tblheader"><center><b>DC</center></b></td>
		<td class="tblheader"><center><b>EAN</center></b></td>
		<td class="tblheader"><center><b>Name</center></b></td>
		<td class="tblheader"><center><b>Username</center></b></td>
		<td class="tblheader"><center><b>Password</center></b></td>
	</tr>

<%							
									' Loop through the recordset
									While not ReturnSet.EOF
																
%>

	<tr>
		<td class="tbldata" align="left"><%=ReturnSet("DCcName")%></td>
		<td class="tbldata" align="left"><%=ReturnSet("SearchOn")%></td>
		<td class="pcontent" align="left"><%=ReturnSet("SearchType")%></td>
		<td class="pcontent" align="left"><%=ReturnSet("UserName")%></td>
		<td class="pcontent" align="left"><%=ReturnSet("UserPassword")%></td>
	
	</tr>	
	
<%										
									ReturnSet.MoveNext
											Wend
											
%>
</table>
<%											
											
									end if
								
									'Close the recordset and connection
									Set ReturnSet = Nothing
									SQLConnection.Close 
									Set curConnection = Nothing
								end if
%>
<p class="bheader">Lookup</p>
<p class="pcontent">Enter the search string into the field below and click on the <b>search</b> button.</p>
<form name="PwdSearch" id="PwdSearch" method="post" action="usernames.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	
	<tr>
		<!--<td class="pcontent" align="left"><b>Search for:</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="1"><b>Name Description</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="2"><b>EAN Number</b></td>-->
		
		
		<td class="pcontent" align="left"><b>Profile Type:</b></td>
		<td>	
			<select name="drpSearchProfileType" id="drpSearchProfileType" class="pcontent">
				<option value="-1">------ Search What? -----</option>
				<option value="1">Dropshipment</option>
				<option value="2">Warehouse</option>
			</select>		
		</td>
			
		
	</tr>
	
	
	
	<tr>
		<!--<td class="pcontent" align="left"><b>Search for:</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="1"><b>Name Description</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="2"><b>EAN Number</b></td>-->
		
		
		<td class="pcontent" align="left"><b>Search for:</b></td>
		<td>	
		<select name="drpSearchType" id="drpSearchType" class="pcontent">
					<option value="-1">------ Search What? -----</option>
					<option value="1">EAN</option>
					<option value="2">Name</option>
		</select>		
		</td>
			
		
	</tr>
	
	<tr>	
		<td class="pcontent" align="left"><b>Text to search:</b></td>
		<td class="pcontent"><input type="text" name="txtToSearch" id="txtToSearch"></td>
	</tr>
	  
	<tr>
		<td class="pcontent" align="left"><b>Search On:</b></td>
		<td>	
		<select name="drpSearchOn" id="drpSearchOn" class="pcontent">
					<option value="-1">-------- Search On -------</option>
					<option value="1">Store</option>
					<option value="2">Supplier</option>
					<option value="4">DC User</option>
					
<%
				
				IF Session("ProcName") = "SPAR HEAD OFFICE" or session("UserType") <> 2  THEN
				
				 
%>
					<option value="3">DC</option>
					
<%
				END IF
%>
%>

		</select>		
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="submit" name="btnSearch" id="btnSearch" value="Search" class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->

