<%@ Language=VBScript %>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<link rel="stylesheet" type="text/css" href="jquery-ui.css">
<style>

	
.alert-danger {
    color: #a94442;
    background-color: #f2dede;
    border-color: #ebccd1;
    padding: 10px;
    border: 1px solid;
    border-radius: 2px;
}
</style>
<script type="text/javascript" src="jquery-1.7.2.min.js"></script>
<script src="jquery-ui.min.js"></script>

<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/claimstatusfunctions.asp"-->
<!--#include file="../includes/logincookie.asp"-->
<%	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if %>
<script type="text/javascript">
if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	}
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


<%
	Dim SqlConnection
	Dim RecordSet
	Dim rsBuyers
	Dim SqlCommand 
	Dim DCId, SupplierId, StoreId, ClaimStatusId, ClaimTypeId
	Dim IsReadOnly,IsOutcomeReasonReadOnly
	Dim CurrentClaimStatusId
	Dim IsHistory
	Dim ClaimTypeName
	Dim BuyerEmail

		
		

	'LoginCheck(const_app_ApplicationRoot & "/claims/ManageClaim.asp")
	
	' If this claim is assigned to history, you must only be able to view, no changes allowed
	IsHistory = Request.QueryString("h")
	
	IsReadOnly = False
	
	
	
	
	
	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	LoadClaimStatusDescriptions(SqlConnection)

	'ClaimTypeName = Request.QueryString("tname")
	ClaimId = Request.QueryString("cid")
	If ClaimId = "" Then
		ClaimId = Request.Form("ClaimId")
	End If
	
	
	' If SaveButton, add entries to auditlog
	If Request.Form("DoSave") = "True" Then
		Dim AddToLogCommand
		
		' Get new claims status
		ClaimStatusId = Request.Form("radAction")

		If ClaimStatusId <> "" Then
			ActionTaken = "S"
		ElseIf ClaimStatusId = "" And Request.Form("Comments") <> "" Then
			ActionTaken = "C"
		End If		
		
		
		If ClaimStatusId = "" Then
			'ClaimStatusId = CurrentClaimStatusId
			ClaimStatusId = Request.Form("hidCurStatus")
		End If
		
		if Request.form("txtCreditNoteAmount") = "" then
			CreditNoteAmount = "0.00"
		else
			CreditNoteAmount = Request.Form("txtCreditNoteAmount")
		end if
		
		
		Dim ClaimCategoryId 
		Dim ClaimReasonId
		Dim ClaimSubCategoryId
		Dim AuthorisedByRepId
		
		If Request.Form("cboClaimSubCategory") = "" Then
			ClaimSubCategoryId = 0
			ClaimSubCategoryName = ""
		Else
			ClaimSubCategoryId = Split(Request.Form("cboClaimSubCategory"),",")(0)
			ClaimSubCategoryName = Split(Request.Form("cboClaimSubCategory"),",")(1)
		End IF
		
		If Request.Form("cboClaimReason") = "" Then
			ClaimReasonId = 0
			ClaimReasonName = ""
		Else
			ClaimReasonId = Split(Request.Form("cboClaimReason"),",")(0)
			ClaimReasonName = Split(Request.Form("cboClaimReason"),",")(1)
		End If
		
		If Request.Form("cboClaimCategory") = "" Then
			ClaimCategoryId = 0 
			ClaimCategoryName = ""
		Else
			ClaimCategoryId = Split(Request.Form("cboClaimCategory"),",")(0)
			ClaimCategoryName = Split(Request.Form("cboClaimCategory"),",")(1)
		End If
		
		
		If Request.Form("cboClaimSubReason") = "" Then
			ClaimSubReasonId = 0
			ClaimSubReasonName = ""
		Else
			ClaimSubReasonId = Split(Request.Form("cboClaimSubReason"),",")(0)
			ClaimSubReasonName = Split(Request.Form("cboClaimSubReason"),",")(1)
		End If
		
		
		If Request.Form("cboOutcomeReasonCode") = "" Then
			OutcomeReasonCodeId = 0
		Else
			OutcomeReasonCodeId = Split(Request.Form("cboOutcomeReasonCode"),",")(0)
		End If
		
		
		If Request.Form("cboBuyerName") = "" Then
			BuyerId = 0
		Else
			BuyerId = Split(Request.Form("cboBuyerName"),",")(0)
		End If
		
	'If  (Request.Form("cboAuthorisedByRep")) or Request.Form("cboAuthorisedByRep") = ""  Then
	'		AuthorisedByRepId = 0
	'	Else
	'		AuthorisedByRepId = Request.Form("cboAuthorisedByRep")
	'	End If
		
		
		If Request.Form("cboAuthorisedByRep") <>  ""  Then
			AuthorisedByRepId = Request.Form("cboAuthorisedByRep")
		Else
			AuthorisedByRepId = -1
		End If
		
		If Request.Form("txtManualInvoiceNumber") <>  ""  Then
			ManualInvoiceNumber = Replace(Request.Form("txtManualInvoiceNumber"),"'","''")
		Else
			ManualInvoiceNumber = ""
		End If
		
		
		Dim CurrentUser
		If Request.Form("txtUserName") = "" Then
			CurrentUser = Request.Form("txtUserLoggedIn")
		Else
			CurrentUser = Request.Form("txtUserName")
		End If
		
		If CurrentUser = "" Then CurrentUser = Session("UserName")
		
		IsAllowSubReason = 0
		If Request.Form("IsAllowSubReason") = True Then IsAllowSubReason = 1
		
		
		
		AddToLogCommand = "AddToClaimsAuditLog @ClaimId=" & CLng(Request.Form("ClaimId")) _
			& ",@ClaimStatusId=" &  CInt(ClaimStatusId) _
			& ",@StatusChangedByUserId=" & CInt(Session("UserId")) _
			& ",@SupplierComments='" & Replace(Request.Form("txtComments"),"'","''") _
			& "',@CreditNoteNo='" & Request.Form("txtCrediteNoteNo") _
			& "',@CreditNoteAmount=" & CreditNoteAmount _
			& ",@ActionTaken='" & ActionTaken _
			& "',@UserName='" & Replace(CurrentUser,"'","''") _
			& "',@ClaimCategoryId=" & ClaimCategoryId  _
			& ",@ClaimReasonId=" & ClaimReasonId _
			& ",@ClaimSubCategoryId=" & ClaimSubCategoryId _
			& ",@ClaimSubReasonId=" & ClaimSubReasonId _
			& ",@OutcomeReasonCode=" & OutcomeReasonCodeId _
			& ",@AuthorisedByRep=" & AuthorisedByRepId _
			& ",@UpliftNo='" & Replace(Request.form("txtUpliftNo"),"'","''") _
			& "',@AllowSubReason=" & IsAllowSubReason _
			& ",@Buyer_Id=" & BuyerId 
			
		If Session("UserType") = 2 Or Session("UserType") = 3 Then AddToLogCommand = AddToLogCommand & ",@ManualInvoiceNumber='" & ManualInvoiceNumber & "'"
		
	'Response.Write AddToLogCommand
		
		Set rsAddToLog = ExecuteSql(AddToLogCommand, SqlConnection) 
		If rsAddToLog("ErrorCode") <> 0 Then
			ErrorMessage = rsAddToLog("ErrorDescription")
			IsReadOnly = False
		End If
		
		Set rsAddToLog = Nothing
	End If
	 
	
	SqlCommand = "ClaimsManageView @ClaimId=" & ClaimId & ", @UserLoggedInId=" & CInt(Session("UserId"))
	
	
	Set RecordSet = ExecuteSql(SqlCommand, SqlConnection) 
	
	If (RecordSet.EOF And RecordSet.BOF) Then
%>
		<table border="1" cellpadding="0" cellspacing="0" width="100%">
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center">
				
				<b>No log available for this claim at this time</b>
			</td>
		</tr>
		</table>

<%
		Response.End
	End If
	
	DIM ClaimConfig
	
	' response.write "njar" 
	IF IsNull(RecordSet("Guid")) or IsNull(RecordSet("Guid")) = 0  then
		ClaimConfig = 0
	else 
		ClaimConfig = 1
	

	
		
		
	end if
	CurrentClaimStatusId = RecordSet("ClaimStatusId")
	
	ClaimTypeId = RecordSet("ClaimTypeId")
	 
	If RecordSet("AssignedToHistory") = "Y" Then
		IsReadOnly = True
	End If
			 
	' If Claim Status, is credit received from supplier, do not show 2nd part
	If CurrentClaimStatusId = 10 Then
		IsReadOnly = True
	End If
'njar
	DIM IsAuthorisedDisabled
	DIM IsUpliftDisabled
	IsOutcomeReasonReadOnly = False
	
	 If (Session("Usertype") = 2 and ClaimTypeId = 3 ) or (Session("Usertype") = 2 and Not RecordSet("AllowDCManageBuildIt") AND ClaimTypeId = 4) Then
			IsReadOnly = True
			'response.write "Apple"
			'Response.write RecordSet("AllowDCManageBuildIt")
			'response.write ClaimTypeId
	Else If Session("Usertype") = 2 and RecordSet("AllowDCManageBuildIt") then
			IsReadOnly = False
			'Response.Write "Grape"
			'Response.write RecordSet("AllowDCManageBuildIt")
			
		End If
	End if
	
	
	If Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
		IsReadOnly = True
	End If
'response.write ClaimTypeId
'response.write Session("Usertype")

	If Session("Usertype") = 2   then
		if  RecordSet("ClaimTypeId") = 4 or RecordSet("ClaimTypeId") = 2  then
				IsOutcomeReasonReadOnly = True
				IsAuthorisedDisabled = "Disabled"
				IsUpliftDisabled = True
				'response.write "AA"
				
		else
				IsOutcomeReasonReadOnly = False
				IsAuthorisedDisabled = ""
				IsUpliftDisabled = False
				'Response.write "AB"
				
		end if
	end if
	
	
	
	If Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
		IsOutcomeReasonReadOnly = True
		IsAuthorisedDisabled = "Disabled"
		IsUpliftDisabled = True
		'response.write "AC"
	End If
	
	If  RecordSet("IsWarehouseUser") = 1 and RecordSet("ClaimTypeId") = 2 then
		IsOutcomeReasonReadOnly = False
		IsAuthorisedDisabled = ""
		IsUpliftDisabled = False
		'response.write "AC"
	end if
	
	If Session("Usertype") = 1 or Session("Usertype") = 4 then
		if RecordSet("DCVendorPrimaryEan") = "6004930012137" then
			IsOutcomeReasonReadOnly = False
			IsAuthorisedDisabled = ""
			IsUpliftDisabled = False
		'	response.write "Q"
		elseif  Recordset ("IsWarehouseUser") = 1 then
			IsOutcomeReasonReadOnly = False
			IsAuthorisedDisabled = ""
			IsUpliftDisabled = False
			'response.write "B"
		else
			IsOutcomeReasonReadOnly = True
			IsAuthorisedDisabled = "Disabled"
			IsUpliftDisabled = True
		'	response.write "x"
		End if
	End IF
	
	If  (Session("Usertype") = 3 )  then
		IsOutcomeReasonReadOnly = True
		IsAuthorisedDisabled  = "Disabled"
		IsUpliftDisabled = True
		'response.write "C"
	end if

	
	Dim ForceCreditInEffect 
	ForceCreditInEffect = RecordSet("ForceCreditInEffect")
	
	Dim AllowChangeCategory, IsDcUser
	AllowChangeCategory = False
	
	ClaimTypeName = RecordSet("ClaimTypeName")
	
	' If the supplier has DC ean code, then Warehouse
	Const DCEanCodes = "6001008999932,6001008999925,6001008999895,6001008999918,6001008999901,SPARHEADOFFICE,GATEWAYCALLCEN,6001008090011,6004930005184,6004930005207,6004930005214"'
	If InStr(DCEanCodes, Session("ProcEAN")) > 0 and RecordSet("ClaimTypeId") = 3 and RecordSet("IsWarehouseUser") = 0  Then
		IsOutcomeReasonReadOnly = True
		IsAuthorisedDisabled = "Disabled"
		IsUpliftDisabled = True
		'response.write "DC Profile should not have access to Uplift, Authorised and Outcome"
	End If
	
	'response.write "ClaimTypeId " & RecordSet("ClaimTypeId") & "<br/>"
	'response.write "UserType " &  Session("Usertype")  & "<br/>"
	'response.write "IsWarehouseUser" & RecordSet("IsWarehouseUser") & "<br/>"
	
	
	If Session("IsWarehouseUser") and (RecordSet("ClaimTypeId")  = 3 or RecordSet("ClaimTypeId")  = 5)  Then 
		IsDcUser = True
		AllowChangeCategory = True
	End If

	
	Dim RealClaimTypeId 
	RealClaimTypeId = ClaimTypeId
	
	If ClaimTypeId  = 3 Then ClaimTypeId  = 1
	'response.write ClaimTypeId
	'Session("ProcEAN")

	' All except
	' 2	DC Admin Claim	DCL
	' 3	Warehouse Claim	WCL
	' Fix to Allow Store
	If (RealClaimTypeId = 1 Or RealClaimTypeId = 3 ) Then
		If Session("UserType") = 3 Then
			IsUpliftDisabled = False
		End If
	End If
	
%>
<script type="text/javascript" >
	$(function(){ 
	
		$("select#cboBuyerName").change(function(e){
			$.getJSON("GetBuyerDetail.asp", { BuyerId: $(this).val() }, function(buyer) {
				$("#BuyerEmail").html("<a href=\"mailto:"+buyer.Email+"\">"+buyer.Email+"</a>");
			})
		})
	
		$("select#cboClaimCategory").change(function(e){
			$.getJSON("../includes/json_claimcategoryreasons.asp",{id: $(this).val(), typeid: 1, a: 1, icms: 1}, function(l){
				
				
				$('input[name="radAction"]').prop('checked', false);
			
				
				var options = '';
				var count = 0;
				var savedReasonId = $("#txtClaimReasonId").val();
				var savedReasonName = $("#txtClaimReasonName").val();
				var isFound = false;
				
				
				for (var i = 0; i < l.length; i++) {
					if (l[i].optionValue != '-1') {
						count += 1;
						if (savedReasonName != "" && savedReasonName.toLowerCase().trim() == l[i].optionDisplay.toLowerCase().trim()) {
							$("#ClaimReasonError").html('');
							isFound = true;
							options += '<option  selected="selected" value="' + l[i].optionValue + ',' + l[i].optionDisplay + '">' + l[i].optionDisplay + '</option>'
						}
						else if (l[i].optionValue + ',' + l[i].optionDisplay == <%If Request.Form("hidClaimReason") = "" Then Response.Write "''" Else Response.Write "'" & Request.Form("hidClaimReason") & "'"%>)
							options += '<option selected="selected" value="' + l[i].optionValue + ',' + l[i].optionDisplay + '">' + l[i].optionDisplay + '</option>'
						else
							options += '<option value="' + l[i].optionValue + ',' + l[i].optionDisplay + '">' + l[i].optionDisplay + '</option>'
					}
				}
				
				if (!isFound && savedReasonName != "" ) {
					options += '<option  selected="selected" value="' + savedReasonId + ',' + savedReasonName + ',0">' + savedReasonName + '</option>'
					$("#ClaimReasonError").html(savedReasonName + ' is not<br/>linked to the selected<br/>claim category');
					if (count == 0) { options += '<option value="-1,None">No Reason</option>' };
				}	
				else if (count == 0) {
					$("#ClaimReasonError").html('');
					options += '<option value="-1,None">No Reason</option>'
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
			
			$.getJSON("../includes/json_wclaimsubcategories.asp",{categoryIds: $(this).val().split(",")[0], dcId: <%=Session("DCID")%>}, function(l){
				var options = '';
				var count = 0;
				var savedSubCategoryId = $("#txtClaimSubCategoryId").val();
				var savedsubCategoryName = $("#txtClaimSubCategoryName").val();
				var isFound = false;
				
				
				for (var i = 0; i < l.length; i++) {
					if (l[i].subCategoryId != -1)
					{ 
						count += 1;
						if (savedsubCategoryName != "" && savedsubCategoryName.toLowerCase().trim() == l[i].subCategoryDisplay.toLowerCase().trim()) {
							$("#ClaimSubCategoryError").html('');
						
							isFound = true;
							options += '<option  selected="selected" value="' + l[i].subCategoryId + ',' + l[i].subCategoryDisplay + '">' + l[i].subCategoryDisplay + '</option>'
						}
						else
							options += '<option  value="' + l[i].subCategoryId + ',' + l[i].subCategoryDisplay + '">' + l[i].subCategoryDisplay + '</option>'
					}
					
					
				}
				
				
				if (!isFound && savedsubCategoryName!="" ) {
					options += '<option  selected="selected" value="' + savedSubCategoryId + ',' + savedsubCategoryName + ',0">' + savedsubCategoryName + '</option>'
					$("#ClaimSubCategoryError").html(savedsubCategoryName + ' is not<br/>linked to the selected<br/>category');
					if (count == 0) { options += '<option value="-1,None">No SubCategory</option>' };
				}		
				else if (count == 0) {
					$("#ClaimSubCategoryError").html('');
					options += '<option value="-1,None">No SubCategory</option>'
					$('#txtClaimSubCategoryId').val(0);
				}
					
				$('#cboClaimSubCategory').html(options);
				getClaimSubReasons($('#cboClaimReason').val());
			})
			
			
		})			
	
		$("select#cboClaimSubReason").change(function(){
			var claimSubReasonArray = $(this).val().split(',');
			if (claimSubReasonArray.length==2)
				$("#ClaimSubReasonError").html('');
			else
				$("#ClaimSubReasonError").html(claimSubReasonArray[1] + ' is not linked to the selected claim reason');
				
		});
	
		$("select#cboClaimSubCategory").change(function(){
			$('input[name="radAction"]').prop('checked', false);
			
			var claimSubCategoryArray = $(this).val().split(',');
			if (claimSubCategoryArray.length==2)
			
				$("#ClaimSubCategoryError").html('');
				
			else
				$("#ClaimSubCategoryError").html(claimSubCategoryArray[1] + ' is not linked to the selected claim category');
			
				
			getClaimSubReasons($('#cboClaimReason').val());
		})
		
		$("select#cboClaimReason").change(function(){
			$('input[name="radAction"]').prop('checked', false);
			$('#hidClaimReason').val($('#cboClaimReason').val());
			
			var claimReasonArray = $(this).val().split(',');
			if (claimReasonArray.length==2)
				$("#ClaimReasonError").html('');
			else
				$("#ClaimReasonError").html(claimReasonArray[1] + ' is not linked to the selected claim category');
			
			getClaimSubReasons($('#cboClaimReason').val());
		})
			
		
	})			

	
	function getClaimSubReasons(claimReasonId) {
			claimReasonId = claimReasonId.split(',')[0];
			
			$.getJSON("../includes/json_wclaimsubreasons.asp",{categoryIds: $("#cboClaimCategory").val().split(",")[0], dcId: <%=Session("DCID")%>,  crid: claimReasonId}, function(l){
				var options = '';
				var count = 0;
				var savedSubReasonId = $("#txtClaimSubReasonId").val();
				var savedSubReasonName = $("#txtClaimSubReasonName").val();
				if (savedSubReasonName == "None") savedSubReasonName = "";
				var isFound = false;
				
				//xander if error on selection dont save
				var IsErrorOnSelection = false;
				
				
				
				for (var i = 0; i < l.length; i++) {
					if (l[i].claimSubReasonId != -1)
					{
						count += 1;
						if (savedSubReasonName != "" && savedSubReasonName.toLowerCase().trim() == l[i].description.toLowerCase().trim()) {
							$("#ClaimSubReasonError").html('');
							isFound = true;
							options += '<option  selected="selected" value="' + l[i].claimSubReasonId + ',' + l[i].description + '">' + l[i].description + '</option>'
						}
						else
							options += '<option value="' + l[i].claimSubReasonId + ',' + l[i].description + '">' + l[i].description + '</option>'
					}
				}
					
				if (!isFound && savedSubReasonName != "") {
					options += '<option  selected="selected" value="' + savedSubReasonId + ',' + savedSubReasonName + ',0">' + savedSubReasonName + '</option>'
					$("#ClaimSubReasonError").html(savedSubReasonName + ' is not<br/>linked to the selected<br/>claim reason');
					if (count == 0)  { options += '<option value="-1,None">No ClaimSubReason</option>' };
				}				
				else if (count == 0) {
					$("#ClaimSubReasonError").html('');
					options += '<option value="-1,None">No ClaimSubReason</option>'
				}
				
				
				$('#cboClaimSubReason').html(options);
				
			})
	}
	function ValidateMoney(obj) 
	{ 
		if (obj == null) return true;

		var amount = obj.value;
		var regEx = /^[0-9\.]+$/; 

		if (amount.length == 0 || regEx.test(amount)) 
		{ 
			$('#validation_result').text('');
		}
		else if (amount.length != 0 && !regEx.test(amount))
		{
			$('#validation_result').text('Amount not valid, must be > 0, numeric');
				
			return false;
		}

		return true;
	}


	
	function determineshowhide(status)
	{
		if ('<%=Session("UserType")%>' == '3')
		{
			enabledisable('hide');
		}
		
		window.resizeTo(screen.width, screen.height)
	}
	
	
	function enabledisablex (action)
	{
		enabledisable (action);
		
		if (document.ManageClaim.elements['txtCreditNoteNo'] != null)
				document.ManageClaim.elements['txtCreditNoteNo'].style.display = "none";
	}
	
	function clearRad()
	{
		$( "#radAction" ).prop( "checked", false );
	}
	
	function enabledisable (action)
	{
		var obj = document.ManageClaim;
		if (document.ManageClaim.elements['cboClaimCategory'] != null)
			if (obj.cboClaimCategory.value.split(',')[0] != obj.txtClaimCategoryId.value)
			{
		
				alert('Claim category was changed, save new category first');
				clearRad();

				return false;
			}
		
		
		
		
		var ClaimConfig = '<%=RecordSet("Guid")%>';	

		if (ClaimConfig == "" && ('<%=Session("Usertype")%>' != '3'  && '<%=RecordSet("ClaimTypeId")%>' == '3' ) ) //RealClaimTypeId) BLEH
		{
			alert('Could not find Matching Claim Config, Please change Claim Category');
			clearRad();

			return false;
		}
		
		if (document.ManageClaim.elements['cboClaimSubCategory'] != null)
			if (obj.cboClaimSubCategory.value.split(',')[0] != obj.txtClaimSubCategoryId.value && obj.txtClaimSubCategoryId.value != '')
			{
				//alert('Claim sub-category was changed, save new sub-category first');
				alert('Please update sub-category first, then save changes before choosing an action');
				clearRad();
				
				return false;
			}
		
		if (document.ManageClaim.elements['cboClaimReason'] != null)
			if (obj.cboClaimReason.value.split(',')[0] != obj.txtClaimReasonId.value && obj.cboClaimReason.value.split(',')[0] != 0)
			{
				//alert('Claim reason was changed, save new reason first');
				alert('Please update claim reason first, then save changes before choosing an action');
				clearRad();
				
				return false;
			}
				
		if (document.ManageClaim.elements['cboClaimSubReason'] != null && obj.txtClaimSubReasonId.value != "")
			if (obj.cboClaimSubReason.value.split(',')[0] != obj.txtClaimSubReasonId.value)
			{
				alert('Please update claim sub reason first, then save changes before choosing an action');
				//alert('Claim sub reason was changed, save new sub-reason first');
				clearRad();
				
				return false;
			}
				
		
		if (action == 'show')
		{
			if (document.ManageClaim.elements['txtCreditNoteNo'] != null)
				document.ManageClaim.elements['txtCreditNoteNo'].style.display = "block";
			if (document.ManageClaim.elements['txtCreditNoteAmount'] != null)
				document.ManageClaim.elements['txtCreditNoteAmount'].style.display = "block";			
		}
		if (action == 'hide')
		{
			if (document.ManageClaim.elements['txtCreditNoteNo'] != null)
				document.ManageClaim.elements['txtCreditNoteNo'].style.display = "none";
			if (document.ManageClaim.elements['txtCreditNoteAmount'] != null)
				document.ManageClaim.elements['txtCreditNoteAmount'].style.display = "none";			
		}
	}

	function validate (obj){
		var count = -1;
		
		if (obj.cboBuyerName != null) {
			//If warehouse claim or reason is pricing then this field is mandatory
			var isActive = obj.cboBuyerName.value.split(',')[2].toLowerCase();
			if (isActive == "false")
			{
				alert("This buyer is no longer active, please select new buyer");
				return false;
			}
			
			if ((obj.txtRealClaimTypeId.value == 3) && (obj.txtClaimReasonName.value.toLowerCase().indexOf("pricing") > 0 || obj.cboClaimReason.value.toLowerCase().indexOf("pricing") > 0 )) {
				
				var id = obj.cboBuyerName.value.split(',')[0];
				if (id == 0) {
					alert("Please select a buyer");
					
					return false;
				}
				
			}
		}
		
		if (obj.txtRealClaimTypeId.value == 5 && obj.IsWarehouseUser.value == 1) {
			if ($("#ClaimSubCategoryError").html() != "") {
				alert("Please select a valid claim sub category");
				return false;
			}
					
			if ($("#ClaimReasonError").html() != "") {
				alert("Please select a valid claim reason");
				return false;
			}
				
			if ($("#ClaimSubReasonError").html() != "") {
				alert("Please select a valid claim sub reason");
				return false;
			}
			
			
			
		}
		
		
		
		if (obj.cboClaimCategory != null)
			if (obj.cboClaimCategory.value == "-2,None") {
				alert('Choose Claim Category');
				obj.cboClaimCategory.focus();
				return false;
			}
		
		if (obj.cboClaimSubCategory != null)
			if (obj.cboClaimSubCategory.value == "-2,None") {
				alert('Choose Claim Sub Category');
				obj.cboClaimSubCategory.focus();
				return false;
			}
			
			if (obj.cboClaimReason != null)
				if (obj.cboClaimReason.value == "-2,None") {
					alert('Choose Claim Reason');
					obj.cboClaimReason.focus();
					return false;
				}
			
			if (<%=LCase(RecordSet("AllowSubReasons"))%>) {
				if (obj.cboClaimSubReason != null)
					if (obj.cboClaimSubReason.value == "-2,None") {
						alert('Choose Claim Sub Reason');
						obj.cboClaimSubReason.focus();
						return false;
					}
					/*else if (obj.cboClaimSubReason.value == "0,None" && obj.txtClaimSubReasonId.value != 0 && obj.txtClaimSubReasonId.value != -1 )
					{
						alert('Claim Cannot be saved, this Sub Reason is not linked to the selected Category');
						obj.cboClaimSubReason.focus();
						return false;
					}*/
			}	

//if error on page do not save - xander2

			if ('<%=RecordSet("IsWarehouseUser")%>' == '1') {
				if ($("#ClaimSubCategoryError").html() != null) 
					if ($("#ClaimSubCategoryError").html() != "" || $("#ClaimReasonError").html() != "" || $("#ClaimSubReasonError").html() != "" ) 
					{
						alert("Please correct selection errors before claim can be saved");
						return false;
					}
			}
		
			
		
		if (obj.txtCreditNoteAmount != null)
			if (!ValidateMoney(obj.txtCreditNoteAmount))
			{
				alert('Please correct the credit note amount!');
				return false;
			}
		
		/*if (document.ManageClaim.elements['cboClaimSubCategory'] != null && obj.cboClaimSubCategory.value.split(',')[0] == -1)
		{
			alert('Please select a Claim Sub Category');
			obj.cboClaimSubCategory.focus();
			return false;
		}*/

		
		
			
		if (document.ManageClaim.elements['txtCreditNoteAmount'] != null) {
			obj.txtCreditNoteAmount.value = obj.txtCreditNoteAmount.value.replace(/^\s+|\s+$/g, "");
		
			if (obj.txtCreditNoteAmount.value != "" && obj.txtRealClaimTypeId.value != 3)
			{
				if (obj.txtCreditNoteNo.value == "")
				{
					alert("Please enter credit note no!");
					obj.txtCreditNoteNo.focus();
					return false;
				}
			}
		}
		
		if (document.ManageClaim.elements['txtCreditNoteNo'] != null) {
			obj.txtCreditNoteNo.value = obj.txtCreditNoteNo.value.replace(/^\s+|\s+$/g, "");
			if (document.ManageClaim.elements['txtCreditNoteNo'] != null)
				if (obj.txtCreditNoteNo.value != "")
				{
					if (obj.txtCreditNoteAmount.value == "")
					{
						alert("Please enter credit note amount!")
						obj.txtCreditNoteAmount.focus();
						return false;
					}
					if (obj.txtCreditNoteAmount.value < 0)
					{
						alert("Credit note value must be greater than 0");
						obj.txtCreditNoteAmount.focus();
						return false;
					}
				}
			}
		
		if (document.ManageClaim.elements['txtUserName'] != null)
		{
			if (obj.txtUserName.value == "") {
				alert("Please provide username");
				obj.txtUserName.focus();
				return false;
			}
			
			if (obj.txtUserName.value.toUpperCase() == "SYSTEM USER") {
				alert("You are not allowed to use user name 'SYSTEM USER'");
				obj.txtUserName.focus();
				return false;
			}
		}

		if (document.ManageClaim.elements['radAction'] != null) {
		if (obj.radAction.checked)
		{
			if (obj.radAction.value == 8 || obj.radAction.value == 9 || obj.radAction.value == 22|| obj.radAction.value == 13)
			{
				if (obj.txtComments.value == '') {
					window.alert("Please enter a comment!");
					obj.txtComments.focus();
					return false;
				}
			}
		}
		else
		{
			for (var i = 0; i < obj.radAction.length; i++) { 
					if (obj.radAction[i].checked) 
					{ 
						if (obj.hidUserType.value == 1 || obj.hidUserType.value == 4) {
						
							if (obj.txtComments.value == '') {
								if (obj.radAction[i].value == 13)
								{
									window.alert("Please enter a comment!");
									obj.txtComments.focus();
									return false;
								}
							}
						
							if (obj.hidCurStatus.value == 11 || obj.hidCurStatus.value == 12) {
								if (obj.radAction[i].value == 6 || obj.radAction[i].value == 22){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.radAction[i].value == 6) {
								if (obj.elements['txtCreditNoteNo'].value == ''){
									window.alert("Please enter a credit note number!");
									obj.elements['txtCreditNoteNo'].focus();
									return false;
								}						
								if (obj.elements['txtCreditNoteAmount'].value == ''){
									window.alert("Please enter a credit amount	!");
									obj.elements['txtCreditNoteAmount'].focus();
									return false;
								}						
							}
							if (obj.hidCurStatus.value == 1) {
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 3) {
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 4) {
									
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 7) {
									
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 6) {
								
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 8) {
									
								if (obj.radAction[i].value == 5){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 8) {
									
								if (obj.radAction[i].value == 7){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 9) {
								if (obj.radAction[i].value == 7){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
							if (obj.hidCurStatus.value == 19) {
								if (obj.radAction[i].value == 4 || obj.radAction[i].value == 5 || obj.radAction[i].value == 6 ){
									if (obj.txtComments.value == '') {
										window.alert("Please enter a comment!");
										obj.txtComments.focus();
										return false;
									}
								}
							}
		
						}
					
							
						if (obj.hidUserType.value == 2){
							<!-- DC Supplier Management -->
							
							
							
							if (obj.hidTypeId.value = 1)
							{
								if (obj.hidCurStatus.value == 1 || obj.hidCurStatus.value == 3 || obj.hidCurStatus.value == 4 || obj.hidCurStatus.value == 7 || obj.hidCurStatus.value == 14){
									if (obj.radAction[i].value == 11 || obj.radAction[i].value == 13 || obj.radAction[i].value == 19){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}

								if (obj.hidCurStatus.value == 5 || obj.hidCurStatus.value == 11 || obj.hidCurStatus.value == 13){
									if (obj.radAction[i].value == 14){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}
								

								if (obj.hidCurStatus.value == 6){
									if (obj.radAction[i].value == 11){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}

								if (obj.hidCurStatus.value == 19){
									if (obj.radAction[i].value == 11 || obj.radAction[i].value == 13){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}


								
								if (obj.hidCurStatus.value == 8 || obj.hidCurStatus.value == 9){
									if (obj.radAction[i].value == 11 || obj.radAction[i].value == 13 || obj.radAction[i].value == 14){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}
								
								
								if (obj.hidCurStatus.value == 22){
									if (obj.radAction[i].value == 13 || obj.radAction[i].value == 14 || obj.radAction[i].value == 12){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}

							}
							else
							{
								<!-- DC DC Management -->
								if (obj.hidCurStatus.value == 3 || obj.hidCurStatus.value == 15 || obj.hidCurStatus.value == 14 || obj.hidCurStatus.value == 16 || obj.hidCurStatus.value == 9){
									if (obj.radAction[i].value == 13){
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
											}
										}
								}

								if (obj.hidCurStatus.value == 8 || obj.hidCurStatus.value == 9)
								{
									if (obj.radAction[i].value == 13 || obj.radAction[i].value == 14 || obj.radAction[i].value == 16) {
										if (obj.txtComments.value == '') {
												window.alert("Please enter a comment!");
												obj.txtComments.focus();
												return false;
										}
									}
								}
							}
						}
					}
				
			}
		}
		}
		
		obj.btnSubmit.disabled=true;
		
		obj.btnSubmit.value="Saving changes ... please wait.";
		
		/*var indexForm = window.opener.document.getElementById("Index");
		indexForm.submit();*/
		
		return true;
	}	
	
<% 

		If IsReadOnly And Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE" Then
			
		ElseIf IsReadOnly Then
			
		Else 
		%>$(function(){
			$("#txtUserName").autocomplete({
				source: function(request, response)
				{
					$.ajax({ 
						url: "json_getUserNames.asp",
						data: { u: request.term }, 
						dataType: "json",
						success: function(json)
						{
							response(json); 
						},
					
					});
				},
				minLength: 2
			})})
		<%End If %>
</script>

		
<title>SPAR</title>
<%
'response.write RecordSet("Guid")  
'response.write"Usertype:"& Session("UserType")
'response.write "ClaimTypeID: " &ClaimTypeId
'response.write RealClaimTypeId 

%>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background=""  onload="javascript:determineshowhide();">
<form name="ManageClaim" id="ManageClaim" action="ManageClaim.asp?cid=<%=ClaimId%>" onsubmit="return validate(this);"  method="POST">
	
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top"><h3>Claim Status Management <% If IsHistory = "True" Then Response.Write "History"%></h3>
			
			</td>
        </tr>
	
		<tr>
			<td class="warning" colspan="3" wrap="virtual"><b><noscript>Your javascript is disabled. For a better website experience, please enable javascript<br />Uploaded attachments will not automaticaly appear in the list below, please refresh the page or save changes after any uploads<br /></noscript></b>
			<% If ErrorMessage <> "" Then %>
				<div class="alert alert-danger alert-dismissible fade in"><strong><%=ErrorMessage%></strong></div></td>
			<% End If %>
		</tr>
    </table>
    <table class="pcontent" border="0" width="70%">
	
		<tr>

			<td><b>Claim&nbsp;Type</b></td>
			<td><%=ClaimTypeName%></td>
		</tr>
		<tr>
			<td><b>Store&nbsp;Name</b></td>
			<td><%=RecordSet("StoreName")%></td>
			<td><b>Store&nbsp;Code</b></td>
			<td><%=RecordSet("StoreCode")%></td>
			<td><b>Store&nbsp;EAN&nbsp;Number</b></td>
			<td><%=RecordSet("StoreEan")%></td>
		</tr>
		<tr>
			<tr>
			<td><b>Store&nbsp;Email&nbsp;Address</b></td>
			<td><a href="mailto:<%=RecordSet("StoreEmail")%>"><%=RecordSet("StoreEmail")%></a></td>
			
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><b>Supplier&nbsp;Name</b></td>
			<td><%=RecordSet("SupplierName")%></td>
		
			<td><b>DC&nbsp;Vendor&nbsp;Code</b></td>
			<td><%=RecordSet("DCVendorCode")%></td>
			<td><b>DC&nbsp;Vendor&nbsp;Primary&nbsp;EAN</b></td>
			<td><%=RecordSet("DCVendorPrimaryEan")%></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><b>Supplier&nbsp;Email&nbsp;Address</b></td>
			<td><a href="mailto:<%=RecordSet("EmailAddress")%>"><%=RecordSet("EmailAddress")%></a></td>
		
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr>
			<td><b>Claim&nbsp;Number</b></td>
			<td class="pcontent"><a href="<%=const_app_ApplicationRoot%>/track/dc/claim/default.asp?item=<%=ClaimId%>" target="_blank"><%=RecordSet("ClaimNumber")%></a></td>
			<td><b>Manual&nbsp;Claim&nbsp;Number</b></td>
			<td><%=RecordSet("ManualClaimNumber")%></td>
			<td><b>Invoice Number</b></td>
			<td>
			<%	If (Session("UserType") = 2 And Session("ProcEan") <> "SPARHEADOFFICE") Or Session("UserType") = 3 Then %>
					<input class="pcontent" maxlength="13" name="txtManualInvoiceNumber" id="txtManualInvoiceNumber" value='<%=RecordSet("ManualInvoiceNumber")%>'>
			<%	Else 
					Response.Write RecordSet("ManualInvoiceNumber")
				End If 
			%>
			</td>
			<td><b>Force&nbsp;Credit&nbsp;In&nbsp;Effect</b></td>
			<td><%
		
					If (ForceCreditInEffect) Then
						Response.Write "Yes"
					Else
						Response.Write "No"
					End If
				%>
			</td>
		</tr>
		<tr>
			<td><b>Claim&nbsp;Category</b></td>
			
			<% 'Response.Write "AllowChangeCategory" & AllowChangeCategory
			
				If AllowChangeCategory = False Then %>
				<td><%=RecordSet("ClaimCategory")%></td>
			<% Else %>
				<td class="warning"  wrap="virtual">
					<select name="cboClaimCategory" id="cboClaimCategory" class="pcontent">
						<%
							selected = ""
							Dim OldClaimCategoryIdFound
							OldClaimCategoryIdFound = False
						
							SqlCommand = "ListClaimsCategories @ClaimTypeId=" & RealClaimTypeId  & ", @IsManageScreen=1, @DCId=" & Session("DCID")' & ClaimTypeId  
							
							Set RecordSetClaimCategories = ExecuteSql(SqlCommand, SqlConnection)  
							If Not (RecordSetClaimCategories.EOF And RecordSetClaimCategories.BOF) Then
								While NOT RecordSetClaimCategories.EOF
									If Request.Form("cboClaimCategory") = RTrim(RecordSetClaimCategories("ClaimCategoryId")) & "," & RTrim(RecordSetClaimCategories("ClaimCategory")) _
										Or RTrim(RecordSetClaimCategories("ClaimCategoryId")) & "," & RTrim(RecordSetClaimCategories("ClaimCategory")) = RecordSet("ClaimCategoryId") & "," & RecordSet("ClaimCategory") Then
										selected = "selected"
										ClaimCategoryId = RecordSetClaimCategories("ClaimCategoryId")
										ClaimCategoryName = RecordSetClaimCategories("ClaimCategory")
										OldClaimCategoryIdFound = True
									Else
										selected = ""
									End If
						%><option <%=selected%> value="<%=RTrim(RecordSetClaimCategories("ClaimCategoryId"))%>,<%=RTrim(RecordSetClaimCategories("ClaimCategory"))%>"><%=RecordSetClaimCategories("ClaimCategory")%></option><%
									RecordSetClaimCategories.MoveNext
								Wend
								
								If Not OldClaimCategoryIdFound Then
									%><option selected value="-2,None">Please Select</option><%
								End If
							End If		
							RecordSetClaimCategories.Close
							Set RecordSetClaimCategories = Nothing
						%>
					</select>
					
					<%
					If Not OldClaimCategoryIdFound Then  Response.Write "<br/>There is no workflow set up for <b>" & RecordSet("ClaimCategory") & "</b>.<br/> Please select a different category"
					
					'Response.Write SqlCommand
					%>
				</td>
				
			<% End If 
										'Response.Write SqlCommandaaaaaaa

			%>
			<td><b>Claim&nbsp;Sub Category</b></td>
			
			<% If AllowChangeCategory = False Then %>
				<td><%=RecordSet("ClaimSubCategoryName")%></td>
			<% Else %>
				<td>
					<select name="cboClaimSubCategory" id="cboClaimSubCategory" class="pcontent">
						<%
							selected = ""
							
							SqlCommand = "ListClaimSubCategories @ClaimCategoryIds = " & RecordSet("ClaimCategoryId") & " , @DCId=" & Session("DCID")' & ClaimTypeId  
'							Response.Write SqlCommand
							Dim Counter 
							Counter = 0
							Set RecordSetClaimSubCategories = ExecuteSql(SqlCommand, SqlConnection)  
							If Not (RecordSetClaimSubCategories.EOF And RecordSetClaimSubCategories.BOF) Then
								
								While NOT RecordSetClaimSubCategories.EOF
									If RecordSetClaimSubCategories("SubCategoryId") <> -1 Then
										Counter = Counter + 1
										If Request.Form("cboClaimSubCategory") = RTrim(RecordSetClaimSubCategories("SubCategoryId")) & "," & RTrim(RecordSetClaimSubCategories("ClaimSubCategoryName")) _
											Or RTrim(RecordSetClaimSubCategories("SubCategoryId")) & "," & RTrim(RecordSetClaimSubCategories("ClaimSubCategoryName")) = RecordSet("ClaimSubCategoryId") & "," & RecordSet("ClaimSubCategoryName") Then
											selected = "selected"
											ClaimSubCategoryId = RecordSet("ClaimSubCategoryId")
											ClaimSubCategoryName = RecordSet("ClaimSubCategoryName")
										Else
											selected = ""
										End If
										
							%><option <%=selected%> value="<%=RTrim(RecordSetClaimSubCategories("SubCategoryId"))%>,<%=RTrim(RecordSetClaimSubCategories("ClaimSubCategoryName"))%>"><%=RecordSetClaimSubCategories("ClaimSubCategoryName")%></option><%
							
									End If
									
									RecordSetClaimSubCategories.MoveNext
								Wend
							End If
							RecordSetClaimSubCategories.Close
							Set RecordSetClaimSubCategories = Nothing
							
							If Counter = 0 Then
							%>
								<option value="-1,None">No SubCategory</option>
								<%
							ElseIf IsNull(RecordSet("ClaimSubCategoryId")) OR RecordSet("ClaimSubCategoryId") = -1 OR  RecordSet("ClaimSubCategoryId") = ""  Or RecordSet("ClaimSubCategoryId") = 0 Then	%>
								<option selected value="-2,None">Please Select</option>
							<%
							Else %>
								<option value="-2,None">Please Select</option>
							<%
							End If
						
							
						%>
					</select>
					<div id="ClaimSubCategoryError" name="ClaimSubCategoryError" class="warning"></div>
				</td>
			<% End If %>
		
			<td><b>Claim&nbsp;Reason</b></td>
			<% If AllowChangeCategory = False Then %>
				<td><%=RecordSet("ClaimReason")%></td>
			<% Else %>
				<td colspan="2">
					<select name="cboClaimReason" id="cboClaimReason" class="pcontent">
						<%
							selected = ""
							SqlCommand = "ListClaimsCategoriesReasonCodes @ClaimTypeId=" & ClaimTypeId & ", @ClaimCategoryId=" & RecordSet("ClaimCategoryId") & ", @IsClaimManageScreen=1"
							'Response.Write SqlCommand
							Counter = 0
							Set RecordSetClaimReasons = ExecuteSql(SqlCommand, SqlConnection)  
							If Not (RecordSetClaimReasons.EOF And RecordSetClaimReasons.BOF) Then
								While NOT RecordSetClaimReasons.EOF
									If RecordSetClaimReasons("ClaimReasonId") <> -1 Then
										Counter = Counter + 1
										
										
										If (Request.Form("cboClaimReason") = RTrim(RecordSetClaimReasons("ClaimReasonId")) & "," & RTrim(RecordSetClaimReasons("ClaimReasonDescription"))) _
											Or (RecordSetClaimReasons("ClaimReasonId") = RecordSet("ClaimReasonId")) Then
											selected = "selected"
											ClaimReasonId = RecordSetClaimReasons("ClaimReasonId")
											ClaimReasonName = RecordSetClaimReasons("ClaimReasonDescription")
										Else
											selected = ""
										End If
									
									
									
						%>
								<option <%=selected%> value="<%=RTrim(RecordSetClaimReasons("ClaimReasonId"))%>,<%=RTrim(RecordSetClaimReasons("ClaimReasonDescription"))%>"><%=RecordSetClaimReasons("ClaimReasonDescription")%></option>
						<%
									End If
									
									
									RecordSetClaimReasons.MoveNext
								Wend
							Else %>
								<!-- <option value="-1,No Reasons">No Reasons</option>-->
						<%
							End If		
							RecordSetClaimReasons.Close
							Set RecordSetClaimReasons = Nothing
							
							If Counter = 0 Then %> 
								<option value="-1,None">No Reason</option> <%
							ElseIf IsNull(RecordSet("ClaimReasonId")) OR RecordSet("ClaimReasonId") = -1 OR  RecordSet("ClaimReasonId") = ""  Or RecordSet("ClaimReasonId") = 0 Then	%>
								<option selected value="-2,None">Please Select</option> <%
							Else %>
								<option value="-2,None">Please Select</option> <%
							End If
							
							
						%>							
					</select>
					<div id="ClaimReasonError" name="ClaimReasonError" class="warning"></div>
				</td>
			<% End If %>
			
		</tr>
		<tr>
		
			<td><b>Claim&nbsp;Sub&nbsp;Reason</b></td>
			<% If AllowChangeCategory = False Then %>
				<td><%=RecordSet("ClaimSubReason")%></td>
			<% Else %>
				<td>
					<select name="cboClaimSubReason" id="cboClaimSubReason" class="pcontent"> <%
						Counter = 0
						NoSelectMatch = True
						SqlSelect = "ListWClaimSubReasons @ClaimCategoryIds=" & RecordSet("ClaimCategoryId") & ", @ClaimReasonId=" & RecordSet("ClaimReasonId") & ",  @DCId=" & Session("DCId")
					'	Response.Write SqlSelect
		
						Set RecordSetClaimSubReasons = ExecuteSql(SqlSelect, SqlConnection)  
						If Not (RecordSetClaimSubReasons.EOF And RecordSetClaimSubReasons.BOF) Then
							While NOT RecordSetClaimSubReasons.EOF 
								If RecordSetClaimSubReasons("ClaimSubReasonId") <> -1 Then
									Counter = Counter + 1
									
									If RecordSetClaimSubReasons("ClaimSubReasonId") = RecordSet("ClaimSubReasonId") Then
										selected = "selected"
										NoSelectMatch = False
										ClaimSubReasonId = RecordSet("ClaimSubReasonId")
										ClaimSubReasonName = RecordSet("ClaimSubReason")
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
						
						If Counter = 0 Then %> 
							<option value="-1,None">No ClaimSubReason</option> <%
						ElseIf IsNull(RecordSet("ClaimSubReasonId")) OR RecordSet("ClaimSubReasonId") = -1 OR  RecordSet("ClaimSubReasonId") = ""  Or RecordSet("ClaimSubReasonId") = 0 Or NoSelectMatch Then	%>
							<option selected value="-2,None">Please Select</option> <%
						Else %>
							<option value="-2,None">Please Select</option> <%
						End If
					%>
					</select>
				
					<div id="ClaimSubReasonError" name="ClaimSubReasonError" class="warning"></div>
				</td>
			<% End If%>
			
			
			<td><b>Uplift/DC Ref No:</b></td>
			<td>
			<%
			If IsUpliftDisabled = True then%>
			
			<%=RecordSet("UpliftRef")%>&nbsp;&nbsp;
			
			<%Else%><input class="pcontent" maxlength="15" name="txtUpliftNo" id="txtUpliftNo" value='<%=RecordSet("UpliftRef")%>'> <%End If%>
						
			<td><b>Authorised by Rep:</b></td>
			<td>
			<%
			Dim SelectedAuthorisedByRepYes, SelectedAuthorisedByRepNo
			If RecordSet("AuthorisedByRep") Or Request.Form("cboAuthorisedByRep") = 1 then
				SelectedAuthorisedByRepYes = "Selected"
			Else
				SelectedAuthorisedByRepNo = "Selected"
			end If
		'response.write RecordSet("AuthorisedByRep")
				'Response.Write IsAuthorisedDisabled
				If (RealClaimTypeID=1 Or RealClaimTypeID=3) And Session("UserType")  = 3 Then
					IsAuthorisedDisabled = ""
				End If
			
			if IsAuthorisedDisabled = "" then %>
				<select <%=IsAuthorisedDisabled%>  name="cboAuthorisedByRep" id="cboAuthorisedByRep" class="pcontent">
					<option <%=SelectedAuthorisedByRepYes%>  value='1'>YES</option> 		
					<option <%=SelectedAuthorisedByRepNo%>  value='0'>NO</option> 
				</select>
			
			<%
			Else
			
				If RecordSet("AuthorisedByRep") = False then 
					response.write "No" 
				Else 
					Response.write "Yes" 
				End if 
			
			End if%>

			</td>
			<td><b>Buyer&nbsp;Name:</b></td>
			<td>
				<% 
					BuyerName = RecordSet("BuyerName")
	
					If IsNull(BuyerName) or (BuyerName = "") Then 
						BuyerName = "&nbsp;&nbsp;&nbsp;&nbsp;"
					End If
					BuyerEmail = RecordSet("BuyerEmailAddress")
					BuyerId = RecordSet("BUID")
					If (Session("UserType") = 2 AND Session("UserName") <> "SPARHEADOFFICE") Or (Session("UserType") = 1 AND Session("IsWarehouseUser")) Then 
					'If True Then 
					%>	
					<select name="cboBuyerName" id="cboBuyerName" class="pcontent">
						
						<option value="0,Not Selected,true">-- Select a Buyer --</option>
							<%
								selected = ""
								SqlCommand = "ListBuyers @DcId="  & Session("DCId")
								Set rsBuyers = ExecuteSql(SqlCommand, SqlConnection) 
								
								If Not (rsBuyers.EOF And rsBuyers.BOF) Then
									While NOT rsBuyers.EOF
										If rsBuyers("BUID") & "," & rsBuyers("BuyerName") & "," & rsBuyers("IsActive") = Request.Form("cboBuyerName") Then
											selected = "selected"
											BuyerEmail = rsBuyers("BuyerEmailAddress")
										ElseIf rsBuyers("BUID") & "," & rsBuyers("BuyerName") & "," & rsBuyers("IsActive") = BuyerId & "," & BuyerName & ","  & rsBuyers("IsActive") Then
											selected = "selected"
										Else													
											selected = ""
										End If%>
									<option <%=selected%> value="<%=rsBuyers("BUID")%>,<%=rsBuyers("BuyerName")%>,<%=rsBuyers("IsActive")%>"><%=rsBuyers("BuyerName")%></option><%
							
										rsBuyers.MoveNext
									Wend
								End If
							%>
					</select>
				<% 
					Else
						Response.Write BuyerName
					End If %>
			</td>
			<td><b>Buyer&nbsp;Email&nbsp;Address</b></td>
			<td><div id="BuyerEmail" ><a href="mailto:<%=BuyerEmail%>"><%=BuyerEmail%></a></div></td>
		</tr>
		
		
		<tr>
			<td><b>Claim&nbsp;Status</b></td>
			<td><%=RecordSet("ClaimStatus")%></td>
			<td><b>Date&nbsp;Received</b></td>
			<td>
			<%=Replace(RecordSet("DateReceived")," ","&nbsp;")%>&nbsp;&nbsp;
			</td>
			<td><b>Outcome of DC's Investigation:</b></td>

			<% 
				If IsOutcomeReasonReadOnly = True Then
			%>
			<td>
				<%=RecordSet("OutcomeReasonCodeV")%>&nbsp;&nbsp;
			</td>
			<%
			
				Else
			%>
			<td>
		
				<select name="cboOutcomeReasonCode" id="cboOutcomeReasonCode" class="pcontent">
					<% If Session("DCId") > 0 or RecordSet("DCVendorPrimaryEan") = "6004930012137" Then %>				
						<option value="0,Not Selected">-- Select a Reason --</option>
					<%
						End If
						If RecordSet("DCVendorPrimaryEan") = "6004930012137" then 
						  Session("DCId") =  RecordSet("StoreDcID")	
						end if
						'response.write Session("DCId")
						selected = "test"
						SqlCommand = "ListClaimOutcomeReason @DCID="  & Session("DCId") & ",@ReturnOnlyActive=1"
						'response.write SqlCommand
						'response.write  Session("DCId")
						Set ListClaimOutcomeReason = ExecuteSql(SqlCommand, SqlConnection) 
						If Not (ListClaimOutcomeReason.EOF And ListClaimOutcomeReason.BOF) Then
							While NOT ListClaimOutcomeReason.EOF
								If ListClaimOutcomeReason("Id") & "," & ListClaimOutcomeReason("Value") = Request.Form("cboOutcomeReasonCode") _
									Or ListClaimOutcomeReason("Id") = RecordSet("OutcomeReasonCode") Then
									selected = "selected"
								Else 	
									selected = ""
								End If
						'		response.write SqlCommand
					%>
							<option <%=selected%> value="<%=ListClaimOutcomeReason("Id")%>,<%=ListClaimOutcomeReason("value")%>"><%=ListClaimOutcomeReason("Value")%></option>
					<%
								ListClaimOutcomeReason.MoveNext
							Wend
						End If
						ListClaimOutcomeReason.Close
						Set ListClaimOutcomeReason = Nothing
					%>
				</select>
			</td>
			<%
				End If
			%>
			<td>&nbsp;
			<%'response.write RecordSet("OutcomeReasonCodeV")
			
			'response.write Session("UserType")
			%>
			</td>
			<td>&nbsp;</td>
						<%
			'response.write RecordSet("OutcomeReasonCodeV")
			'response.write SqlCommand
			'response.write Session("UserType")
			%>
			
			
		</tr>
		
		
<% 
	
	If Not IsReadOnly Then %>
		<tr>
			<td><b>User&nbsp;Name</b></td>
			<td>
		
				<% 	If Not IsReadOnly Then 		
						If RecordSet("UserLoggedIn") <> "" Then 
							Response.Write RecordSet("UserLoggedIn")
						Else
				%>	
						<input class="pcontent" name="txtUserName" id="txtUserName" value='<%=Request.Form("txtUserName")%>'>
				<%		End If
					Else
						Response.Write RecordSet("UserName")
					End If
					'response.write RecordSet("StoreIsLive")
				%>
			</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="pcontent"><b>Action</b></td>

			<td class="pcontent" colspan="2"> 
				<%
					dim radCnt
					radCnt = 0
				
					Dim DoHideCreditNoteAndAmount
					DoHideCreditNoteAndAmount = False
					Select Case CurrentClaimStatusId
						Case 1,8,4,7,14,3,5,9,13,14,15,19,22,25,26
							DoHideCreditNoteAndAmount = True
					End Select 
					
									
					
					'response.write "<br/>RealClaimTypeId: "&  RealClaimTypeId
					'response.write Session("IsWarehouseUser") 

					'response.write RealClaimTypeId
					'response.write "<br/>Current Status:"& CurrentClaimStatusId
					'Response.Write "<br/>Selected guid: " & RecordSet("Guid")
					'response.write "<br/>StatusesApplicableIds "& RecordSet("StatusesApplicableIds") & "<br />"
					'Response.Write "nOW " & ForceCreditInEffect
					'Response.Write (Session("IsWarehouseUser") And RealClaimTypeId <> 2) 
					'Response.Write  (Session("UserType") = 1 Or Session("UserType") = 4  Or (Session("UserType") = 2 and RealClaimTypeId = 5 ) And (Not Session("IsWarehouseUser") Or RealClaimTypeId = 3)) 
				'	If (Session("IsWarehouseUser") And RealClaimTypeId <> 2)
				
					If ((Session("IsWarehouseUser") And RealClaimTypeId <> 2) Or (Session("UserType") = 1 Or Session("UserType") = 4  Or (Session("UserType") = 2 and RealClaimTypeId = 5 ) And (Not Session("IsWarehouseUser") Or RealClaimTypeId = 3)))  Then
						' Supplier logged in
						
						If RealClaimTypeId = 3 And  Session("IsWarehouseUser") Then ' Warehouse Claim (DC Dummy Supplier)
							' Add new ClaimStatus' here
							
							Select Case CurrentClaimStatusId
								Case 1,3,29
									RadCnt = 1
										
									
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|4|") > 0 Then
										
										RadCnt = RadCnt + 1  %>
										<input type="radio" name="radAction" id="radAction" value="4"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(4)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|15|") > 0  And (RealClaimTypeId = 5 Or RealClaimTypeId = 3) Then
										RadCnt = RadCnt + 1
									%>

										<input type="radio" name="radAction" id="radAction" value="15" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(15)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>

										<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
										
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 And ClaimTypeId <> 5 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 And ClaimTypeId = 5 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(28)%><br/><%
										
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 4,15
									RadCnt = 1
									
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>	<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|23|") > 0 And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0  Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								
								Case 19
									RadCnt = 1
									
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|23|") > 0 And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								
								Case 25
									RadCnt = 1
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|23|") > 0  And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0   Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 24
									RadCnt = 2
									%>	<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/>
										<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 23
									RadCnt = 2
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/><%
								Case 13
									RadCnt = 1
									
									%>
										<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
								Case 8
									RadCnt = 2
								%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
								Case 14
									RadCnt = 2
								
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|4|") > 0  Then
										RadCnt = RadCnt + 1  %>
										<input type="radio" name="radAction" id="radAction" value="4"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(4)%><br/>
										<%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(23)%><br/><%
									End If
									
									%>
										<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<!--<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>-->
									<%
									
									DoHideCreditNoteAndAmount = True
								Case 16
									RadCnt =1
									%>	<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
									
								Case 9
									RadCnt = 3
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
										<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/><%
								Case Else
									DoHideCreditNoteAndAmount = True
							End Select

								
							
'Xander Copied Warehouse replaced status 4 with status 15 and replaced status 23 with status 28
						else If  RealClaimTypeId = 5 and Session("IsWarehouseUser")  Then 'DC Vendor Claim
							' Add new ClaimStatus' here
							'Response.Write "DC Vendor Claim "
							'Response.Write CurrentClaimStatusId
							Select Case CurrentClaimStatusId
								Case 3,29
									RadCnt = 1
																			
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|15|") > 0  Then
										RadCnt = RadCnt + 1
									%>

										<input type="radio" name="radAction" id="radAction" value="15" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(15)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>

										<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
										
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 And ClaimTypeId <> 5 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="23" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(23)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 And ClaimTypeId = 5 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
										
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 15
									RadCnt = 1
									
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>	<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|28|") > 0 And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0  Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								
								Case 19
									RadCnt = 1
									
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|28|") > 0 And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								
								Case 25
									RadCnt = 1
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|28|") > 0  Then 'And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0   Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									End If
									
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 24
									RadCnt = 1
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|28|") > 0  Then 'And InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0   Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									End If
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/><%
								Case 23
									RadCnt = 2
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(16)%><br/><%
								Case 13
									RadCnt = 1
									
									%>
										<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
								Case 8
									RadCnt = 2
								%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
								Case 14
									RadCnt = 2
								
									If InStr("|" & RecordSet("StatusesApplicableIds"),"|15|") > 0  Then
										RadCnt = RadCnt + 1  %>
										<input type="radio" name="radAction" id="radAction" value="15"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(15)%><br/>
										<%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|19|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|25|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="25" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(25)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") = 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									ElseIf InStr("|" & RecordSet("StatusesApplicableIds"),"|24|") > 0 Then
										RadCnt = RadCnt + 1
									%>
										<input type="radio" name="radAction" id="radAction" value="28" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(28)%><br/><%
									End If
									
									%>
										<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<!--<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>-->
									<%
									
									DoHideCreditNoteAndAmount = True
								Case 16
									RadCnt =1
									%>	<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/><%
									
								Case 9
									RadCnt = 3
									%>	<input type="radio" name="radAction" id="radAction" value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
										<input type="radio" name="radAction" id="radAction" value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
										<input type="radio" name="radAction" id="radAction" value="16" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(16)%><br/><%
								Case Else
									DoHideCreditNoteAndAmount = True
							End Select								
						
						Elseif  Not Session("IsWarehouseUser") Then 'Recordset("IsWarehouseUser") = 0 then 'working If Not Session("IsWarehouseUser")  Then 
							
							
							Select Case CurrentClaimStatusId
								Case 30
									radCnt = 2 %>
									<input type="radio" name="radAction" id="radAction" value="5" onclick="javascript:enabledisable('hide');" /><%=GetClaimStatusDescription(5)%><br/>
									<input type="radio" name="radAction" id="radAction" value="6" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>
									
								<%
								
								Case 1,3,19
									radCnt = 3
								
					%>
									<input type="radio" name="radAction" id="radAction" value="4"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(4)%><br/>
									<input type="radio" name="radAction" id="radAction" value="5" onclick="javascript:enabledisable('hide');" /><%=GetClaimStatusDescription(5)%><br/>
									<input type="radio" name="radAction" id="radAction" value="6" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>
					<%					
								Case 4
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="5"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(5)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="6"  onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>	
					<%
								Case 5,13
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="7"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(7)%><br/>
					<%
								Case 7
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="5"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(5)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="6"  onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>
					<%
								Case 6
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="5"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(5)%><br/>
					<%
								Case 8
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="5"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(5)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="7"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(7)%><br/>
					<%
								Case 9
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="6"  onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="7"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(7)%><br/>
					<%
								Case 14 
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="6"  onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(6)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="5"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(5)%><br/>
					<%
								Case 11
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="22"  onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(22)%><br/>
					<%
					
									If ForceCreditInEffect  And CurrentClaimStatusId <> 12 And IsDCUser  Then 
												radCnt = radCnt + 1%>
									<input type="radio" name="radAction" id="radAction"  value="12" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(12)%><br/><%
									End If
							End Select
						End If
					End If
				end if
					'Response.Write "BEfore 3  check"
					If Session("UserType") = 3 Then
						' This is the store
						
						
						Select Case CurrentClaimStatusId
							Case 1,3
								If RealClaimTypeId <> 5 Then
									radCnt = 1 
					%>
									<input type="radio" name="radAction" id="radAction" value="31"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(31)%><br/>
					<%
								End If
							Case 5,13
								If (RealClaimTypeId = 3 And InStr("|" & RecordSet("StatusesApplicableIds"),"|8|") > 0) Or RealClaimTypeId <> 3 Then
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction" value="8"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(8)%><br/>
					<%
								End If
							Case 6,16
								If (RealClaimTypeId = 3 And InStr("|" & RecordSet("StatusesApplicableIds"),"|9|") > 0) Or RealClaimTypeId <> 3 Then
									radCnt = 1 
					%>
									<input type="radio" name="radAction" id="radAction" value="9"  onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(9)%><br/>
					<%
								End If
						End Select
					
					
					End If
				
					
					If (Session("UserType") = 2 Or (Session("IsWarehouseUser") and (RealClaimTypeId = 1 Or RealClaimTypeId=4 )))  Then 
						'Response.Write " DC using supplier management system, DC is doing capture on behalf of the Supplier"
						
						If  (ClaimTypeId = 1) or (ClaimTypeId = 4) Or (ClaimTypeId = 5 And Session("IsWarehouseUser")) and RecordSet("StoreIsLive") = 1 Then ' DC using supplier management system, DC is doing capture on behalf of the Supplier
							Select Case CurrentClaimStatusId
						
								Case 19
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="11" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(11)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
					<%
								Case 1,8,4,7,14,3 
									radCnt = 4
									
									DoHideCreditNoteAndAmount = True
									
								
									
									
					%>
									<input type="radio" name="radAction" id="radAction"  value="11" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(11)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>
						
					<%
								Case 5, 11, 13 
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(14)%><br/>
					<%
								Case 8,9, 22 
									radCnt = 3
					%>
									<input type="radio" name="radAction" id="radAction"  value="11" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(11)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
					<%
									If CurrentClaimStatusId = 22  Then
										radCnt = radCnt + 2
						%>
										<input type="radio" name="radAction" id="radAction"  value="18" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(18)%><br/>
										<input type="radio" name="radAction" id="radAction"  value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/>
						<%
									End If
					
								Case 6
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="11" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(11)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
					<%
								Case 12,66 'Changed by Xander , was 1266????
									radCnt = 3
									
									
					%>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="19" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(19)%><br/>
					<%
					
								Case 26
									radCnt = 3
									
					%>
									<input type="radio" name="radAction" id="radAction"  value="12" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(12)%><br/>
									
					<%		
							
								Case 10, 16, 31
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="14"/><%=GetClaimStatusDescription(14)%><br/>
									
					<%		
							End Select
							
							
							
							If ForceCreditInEffect = True And CurrentClaimStatusId <> 26  and RecordSet("StoreIsLive") <> 0 Then ' Only DC user is allowed to see this
	
								radCnt = radCnt + 1%>
								<input type="radio" name="radAction" id="radAction"  value="26" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(26)%><br/>
					<%	
								If CurrentClaimStatusId <> 12  and RecordSet("StoreIsLive") = 1 Then
									radCnt = radCnt + 1%>
									<input type="radio" name="radAction" id="radAction"  value="12" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(12)%><br/>
						<%
								End If
								
							End If
						End If
						
					End If
					
					If Session("UserType") = 2 Or (Session("IsWarehouseUser") And Session("UserType") = 1) Then
						Select Case CurrentClaimStatusId
							Case 31
								radCnt = 1 %>
 									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
								<%
						End Select
					End If
					If ((Session("UserType") = 2 And RealClaimTypeId = 2) Or (Session("IsWarehouseUser") And RealClaimTypeId = 2)) Then ' DC using DC management system
					'If (RealClaimTypeId = 2 And UserType = )   Then 
							
		
							Select Case CurrentClaimStatusId
								Case 3 
								DoHideCreditNoteAndAmount = True
									radCnt = 3	
					%>
									<input type="radio" name="radAction" id="radAction"  value="15" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(15)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>
					<%
								Case 15,14
									radCnt = 2
					%>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>
					<%
								Case 13
									radCnt = 1
					%>
 									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
					<%
								Case 16
									radCnt = 1
					%>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
					<%
								Case 8,9
									radCnt = 3
					%>
									<input type="radio" name="radAction" id="radAction"  value="13" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(13)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="16" onclick="javascript:enabledisable('show');"/><%=GetClaimStatusDescription(16)%><br/>
									<input type="radio" name="radAction" id="radAction"  value="14" onclick="javascript:enabledisable('hide');"/><%=GetClaimStatusDescription(14)%><br/>
					<%
							End Select
						End If
				%>
				
			</td>
		
<% 

If Not IsReadOnly And Not DoHideCreditNoteAndAmount Then %>
	<td><b>Credit&nbsp;Note&nbsp;No:</b><br /><input type="text" class="pcontent" size="15" id="txtCreditNoteNo" name="txtCrediteNoteNo" ></td>
	<td><b>Amount:</b><br /><input type="text" class="pcontent" id="txtCreditNoteAmount" size="15" name="txtCreditNoteAmount" onkeyup="ValidateMoney(this)" /><b><span colspan="5" id="validation_result" class="warning"></span></b></td>
<%
	ElseIf DoHideCreditNoteAndAmount Then
%>
	<td><b>Credit&nbsp;Note&nbsp;No:</b><br /><input type="text" style="display: none" class="pcontent" size="15" id="txtCreditNoteNo" name="txtCrediteNoteNo" ></td>
	<td><b>Amount:</b><br /><input type="text" style="display: none" class="pcontent" id="txtCreditNoteAmount" size="15" name="txtCreditNoteAmount" onkeyup="ValidateMoney(this)" /><b><span colspan="5" id="validation_result" class="warning"></span></b></td>
	
<%	End If %>			
		</tr>
		
		<tr>
			<td><b>Comments</b></td>
			<td colspan="4"><textarea class="pcontent" id="txtComments" name="txtComments" cols="100" rows="5"></textarea></td>
		</tr> 
		<tr>
			<td></td>
		
			<td colspan="2"><input type="submit" name="btnSubmit" id="btnSubmit" value="Save changes" class="button">&nbsp;</td>
		
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
<%
	End If
	
	'debug
	'Response.Write IsOutcomeReasonReadOnly
	'Response.Write Len(IsAuthorisedDisabled)
	'Response.Write IsUpliftDisabled
	
	'response.write Recordset("IsWarehouseUser")
	'Response.write "is warehouse :"&session("IsWarehouseUser")
	'Response.Write "usertype :"&Session("UserType")
	'Response.Write "realclaimtypeid :"&RealClaimTypeId
	'response.write "claimtype OD : " &ClaimTypeId
	If (IsOutcomeReasonReadOnly = False OR IsAuthorisedDisabled = "" OR IsUpliftDisabled = False) And (Session("UserType")=2 And RealClaimTypeId = 3) Then %>
	
		<tr>
			<td><b>Comments</b></td>
			<td colspan="4"><textarea class="pcontent" id="txtComments" name="txtComments" cols="100" rows="5"></textarea></td>
		</tr> 
		<tr>
			<td></td>
		
			<td colspan="2"><input type="submit" name="btnSubmit" id="btnSubmit" value="Save changes" class="button">&nbsp;</td>
		
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<%
			' Show save button
	End If
	%> 
		
	</table><br/>
	
	<input type="hidden" name="ClaimId" id="ClaimId" value="<%=ClaimId%>" />
	<input type="hidden" name="ClaimStatusId" id="ClaimStatusId" value="<%=RecordSet("ClaimStatusId")%>" />
	<input type="hidden" name="DoSave" id="DoSave" value="True" />
	<input type="hidden" name="hidRadCnt" id="hidRadCnt" value="<%=radCnt%>" />
	<input type="hidden" name="hidCurStatus" id="hidCurStatus" value="<%=CurrentClaimStatusId%>" />
	<input type="hidden" name="hidUserType" id="hidUserType" value="<%=Session("UserType")%>" />
	<input type="hidden" name="hidTypeId" id="hidTypeId" value="<%=ClaimTypeId%>" />
	<input type="hidden" name="hidClaimReason" id="hidClaimReason" value="<%=Request.Form("hidClaimReason")%>" />
	<input type="hidden" name="txtUserLoggedIn" id="txtUserLoggedIn" value="<%=RecordSet("UserLoggedIn")%>" />
	<input type="hidden" name="txtRealClaimTypeId" id="txtRealClaimTypeId" value="<%=RealClaimTypeId%>" />
	
	<input type="hidden" name="txtClaimCategoryId" id="txtClaimCategoryId" value="<%=ClaimCategoryId%>" />
	<input type="hidden" name="txtClaimSubCategoryId" id="txtClaimSubCategoryId" value="<%=ClaimSubCategoryId%>" />
	<input type="hidden" name="txtClaimReasonId" id="txtClaimReasonId" value="<%=ClaimReasonId%>" />
	<input type="hidden" name="txtClaimSubReasonId" id="txtClaimSubReasonId" value="<%=ClaimSubReasonId%>" />
	<input type="hidden" name="IsAllowSubReason" id="IsAllowSubReason" value="<%=RecordSet("AllowSubReasons")%>" />
	<input type="hidden" name="IsWarehouseUser" id="IsWarehouseUser" value="<%=Session("IsWarehouseUser")%>" />
	
	<input type="hidden" name="txtClaimCategoryName" id="txtClaimCategoryName" value="<%=ClaimCategoryName%>" />
	<input type="hidden" name="txtClaimSubCategoryName" id="txtClaimSubCategoryName" value="<%=ClaimSubCategoryName%>" />
	<input type="hidden" name="txtClaimReasonName" id="txtClaimReasonName" value="<% If ClaimReasonName = "" Then Response.Write RecordSet("ClaimReason")%>" />
	<input type="hidden" name="txtClaimSubReasonName" id="txtClaimSubReasonName" value="<%=ClaimSubReasonName%>" />
	
	
	<table border="1" cellpadding="0" cellspacing="0" width="100%">
	
<%
	Dim rsGrid 
	Dim NewConnection
	Dim CommandText
	
	Set NewConnection = Server.CreateObject ("ADODB.Connection")
	NewConnection.Open const_db_ConnectionString
	CommandText = "ClaimsAuditLogGrid @ClaimId=" & ClaimId
	'Response.Write CommandText
	Set rsGrid = ExecuteSql(CommandText, NewConnection)  
			
	If Not (rsGrid.EOF And rsGrid.BOF) Then
%>
	
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><input type="button" name="btnPrintClaimLog" id="btnPrintClaimLog" style="width: 100%" value="Print Claim Log" class="button" onclick="javascript:window.print();"></td>
			<td>
			<% If RecordSet("AssignedToHistory") = "Y" Then %>
				<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" style="width: 100%" value="Close Window" class="button" onclick="window.close();">
			<% Else 
			%>
				<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" style="width: 100%" value="Close Window" class="button" onclick="try { window.opener.document.getElementById(name='btnSubmit').click(); } finally { window.open('', '_self', ''); window.close(); }">
			<% End If %>
			</td>
		</tr>
	

			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Status</b></td>
				<td class="tdcontent" align="center"><b>Status Changed by</b></td>
				<td class="tdcontent" align="center"><b>Status Change Date</b></td>
				<td class="tdcontent" align="center"><b>Comments</b></td>
				<td class="tdcontent" align="center"><b>Invoice/Credit No</b></td>
				<td class="tdcontent" align="center"><b>Invoice/Credit Amount</b></td>
			</tr><%
		While NOT rsGrid.EOF
		  %><tr>
				<td class="pcontent" align="center"><%if rsGrid("ClaimStatus") = "" then response.write "-" else response.write rsGrid("ClaimStatus") end if%></td>
				<td class="pcontent" align="center"><%if rsGrid("StatusChangedBy") = "" then response.write "-" else response.write rsGrid("StatusChangedBy") end if%></td>
				<td class="pcontent" align="center"><%=rsGrid("StatusChangedDate")%></td>
				<td class="pcontent" align="center"><%if Trim(rsGrid("SupplierComments")) = "" then response.write "-" else response.write rsGrid("SupplierComments") end if%></td>
				<td class="pcontent" align="center"><%
					If rsGrid("CreditNoteNo") = "" Then 
						response.write "-" 
					ElseIf rsGrid("CreditNoteId") = 0 Then
						response.write rsGrid("CreditNoteNo")
					ElseIf rsGrid("LinkEnabled") = 1 Then
					%><a href="<%=const_app_ApplicationRoot%>/track/dc/creditnote/default.asp?item=<%=rsGrid("CreditNoteId")%>&amp;reason=" target="_blank"><%=rsGrid("CreditNoteNo")%></a>
					<%Else
						response.write rsGrid("CreditNoteNo")
					End If%></td>
				<td class="pcontent" align="center"><%if rsGrid("CreditNoteAmount") = "" Or rsGrid("CreditNoteAmount") = "0" Or IsNull(rsGrid("CreditNoteAmount")) then response.write "-" else response.write FormatNumber(rsGrid("CreditNoteAmount"),2) end if%></td>
			</tr><%
			rsGrid.MoveNext
		Wend

	Else
%>
	<tr bgcolor="#4C8ED7">
		<td class="tdcontent" align="center"><b>No audit log available for this claim</b></td>
	</tr>
<%
	
	End If
	
	
%>
	</table>
</form>
<a href="ClaimDocuments.asp?cid=<%=ClaimId%>" target="_blank"><img src='/dropship/claims/icons/paperclip.jpg' id='paperclip' class="paperclip" width='24' height='24' border='0'  ,'_blank');"/></a>

<form name="attachments" id="attachments" action="ManageClaim.asp?cid=<%=ClaimId%>"  method="POST">
<script type="text/javascript">
function SetBuyerSelectedVal(){
			document.forms["ManageClaim"].submit();
}
		
function fListAttachments() {
	$.getJSON("json_listattachments.asp",{cid: <%=ClaimId%>}, function(l){
		var links = '';
				console.log(l);
		for (var i = 0; i < l.length; i++) {
			links += l[i].filelink
		}
		
		$('#document_list').html(links);
	})
}


$(function(){
	fListAttachments();
	
	$(window).focus(function() {
	   fListAttachments();
	});
})
</script>
	<table cellpadding='0' cellspacing='0' width='40%'>
			<div id="document_list" name="document_list"><%
				SqlSelect = "GetClaimAttachments @Claim_Id=" & ClaimId
				
				Set rsObj = ExecuteSql(SqlSelect, NewConnection)  
				If Not (rsObj.BOF And rsObj.EOF) Then 
					While Not rsObj.EOF
						UserFileName = rsObj("UserFileName")
						
					
						
						If Session("UserName") = "SPARHEADOFFICE" Then
							Response.Write "<p></p>"
						End If
						
						%>
						<tr><td class="pcontent" align="left" colspan="2">
						<a target="_blank"  href="<%=const_app_DocumentRoot & GetDocumentPath(rsObj("SystemGeneratedFileName"))%>"><%=UserFileName%>
						</a>
						</td></tr>
						<%
					
						rsObj.MoveNext
					Wend
				Else
					
				End If
				rsObj.Close
			%></div>
			<input type="hidden" value="<%=ClaimId%>" />
	</table>
</form>


<%
	NewConnection.Close
	Set NewConnection = Nothing
	
	Function GetDocumentPath(path)
		GetDocumentPath = ""
		Dim docPath 
		docPath = Replace(ServerShare & "\" & path, "documents\", "")
		'Dim docPathBackup 
		'docPathBackup = Replace(Const_App_ClaimsUploadDirBackupWhack & path, "documents\", "")
		Dim docPathAws
		docPathAws = Replace(AwsServerShare &  "\" & path, "documents\", "")
	
		Dim fs 
		Set fs=Server.CreateObject("Scripting.FileSystemObject")
		
		If fs.FileExists(docPath) Then
			GetDocumentPath = path
		ElseIf fs.FileExists(docPathAws) Then
			GetDocumentPath = Replace(path, "documents", "awsDocumentsBackup")
		Else
			GetDocumentPath = Replace(path, "documents", "awsDocumentsBackup")
			'GetDocumentPath = Replace(path, "documents", "documentsBackup")
		End If
	End Function
%>
