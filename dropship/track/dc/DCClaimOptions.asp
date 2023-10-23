<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincookie.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
	Dim SqlUpdate
	Dim cnObj, rsObj, SqlSelect
	Dim DCId
	
	Dim AllowClaimCaptureForSupplier, AllowClaimCaptureForAdminDC, AllowDCsToMaintainSupplierClaims, DCEmailAddressForAdminDCClaims, DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims
	Dim Selected, RecordSet
	Dim IsDCAllowedToUploadForceCredits, IsDCAllowedToUploadForceCreditsReadOnly, IsDCToCaptureAdminDCClaims
	Dim AllowClaimEmails
	Dim AllowDCManageBuildIt, AllowDCGenerateForceCredits, IsDCAllowedToChangeClaimNumberOnSchedule
	Dim IsdcAllowedAutoMatchingOfAdminClaim, radioIsdcAllowedAutoMatchingOfAdminClaim
	
	Dim txtWarehouseTollerance
	Dim txtSupplierTollerance
	Dim txtBulditDCTollerance
	Dim txtDcVendorTollerance
	Dim Ids
	
	
	
	Dim IsSaved
	Dim DisplayMessage
	Dim IsDisabled
	IsDisabled = "disabled"
	DisplayMessage = ""
	If (Session("ProcEAN") = "GATEWAYCALLCEN" Or Session("ProcEAN") = "SPARHEADOFFICE") And Request.Form("cboDC") <> "-1,Not Selected" Then
		 IsDisabled = ""
	End If
	
	
	If Request.Form("cboDC") = "" And (Request.Form("DCId") = 6 Or Request.Form("DCId") = 7) Then
		DCId = -1
	ElseIf Request.Form("cboDC") <> "" Then
		DCId = Split(Request.Form("cboDC"),",")(0)
	Else
		DCId = Session("DCId")
	End If
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
		If (Trim(Request.Form("Action")) = "Save") And DCId <> -1 Then
			
			txtWarehouseTollerance = Request.Form("txtWarehouseTollerance")
			
			If Not IsNumeric(txtWarehouseTollerance) Then txtWarehouseTollerance = NULL

			txtSupplierTollerance = Request.Form("txtSupplierTollerance")
			If Not IsNumeric(txtSupplierTollerance) Then txtSupplierTollerance = NULL

			txtBulditDCTollerance = Request.Form("txtBulditDCTollerance")
			If Not IsNumeric(txtBulditDCTollerance) Then txtBulditDCTollerance = NULL
			
			txtDcVendorTollerance = Request.Form("txtDcVendorTollerance")
			If Not IsNumeric(txtDcVendorTollerance) Then txtDcVendorTollerance = NULL
	
			radioIsdcAllowedAutoMatchingOfAdminClaim = Request.Form("IsdcAllowedAutoMatchingOfAdminClaim")
			Response.Write radioIsdcAllowedAutoMatchingOfAdminClaim
			
			
			If radioIsdcAllowedAutoMatchingOfAdminClaim = "" Then radioIsdcAllowedAutoMatchingOfAdminClaim = 0
	
			Dim SqlCommand 	
			Set SqlCommand = Server.CreateObject("ADODB.Command")

			SqlCommand.ActiveConnection = cnObj
			SqlCommand.CommandText = "UpdateDcConfiguration"
			SqlCommand.CommandType = adCmdStoredProc
			SqlCommand.Parameters("@AllowClaimCaptureForSupplier") = Request.Form("AllowClaimCaptureForSupplier")
			SqlCommand.Parameters("@AllowClaimCaptureForAdminDC") = Request.Form("AllowClaimCaptureForAdminDC")
			SqlCommand.Parameters("@AllowDCsToMaintainSupplierClaims") = Request.Form("AllowDCsToMaintainSupplierClaims")
			SqlCommand.Parameters("@DCEmailAddressForAdminDCClaims") = "" 'Trim(Replace(Request.Form("DCEmailAddressForAdminDCClaims"),"''","'"))
			SqlCommand.Parameters("@DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims") = Trim(Replace(Request.Form("DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims"),"'","''"))
			SqlCommand.Parameters("@DCId") = DCId
			SqlCommand.Parameters("@AllowClaimEmails") = Request.Form("AllowClaimEmails")	
			SqlCommand.Parameters("@AllowDCManageBuildIt") = Request.Form("AllowDCManageBuildIt")
			SqlCommand.Parameters("@WarehouseClaimTollerence")= txtWarehouseTollerance
			SqlCommand.Parameters("@SupplierClaimTollerence") = txtSupplierTollerance
			SqlCommand.Parameters("@BuilditDcClaimTollerence") = txtBulditDCTollerance
			SqlCommand.Parameters("@DcVendorClaimTollerance") = txtDcVendorTollerance
			SqlCommand.Parameters("@AllowDCGenerateForceCredits") = Request.Form("AllowDCGenerateForceCredits")
			SqlCommand.Parameters("@IsDCAllowedToChangeClaimNumberOnSchedule") = Request.Form("IsDCAllowedToChangeClaimNumberOnSchedule")
			SqlCommand.Parameters("@IsdcAllowedAutoMatchingOfAdminClaim") = radioIsdcAllowedAutoMatchingOfAdminClaim
			
			
			
			If Request.Form("IsDCAllowedToUploadForceCredits") <> "" Then
				SqlCommand.Parameters("@IsDCAllowedToUploadForceCredits") = Request.Form("IsDCAllowedToUploadForceCredits")
			End If
			
			
			If Request.Form("IsDCToCaptureAdminDCClaims") <> "" Then
				SqlCommand.Parameters("@IsDCToCaptureAdminDCClaims") = Request.Form("IsDCToCaptureAdminDCClaims")
			End If
			
			
			SqlCommand.Execute
			
	
			Dim txtOutcomeReasonCode
			Dim IdsArray
			IdsArray =  Split(Request.Form("Ids"),",")
			Dim Id
			For Each Id In IdsArray
				Set SqlCommand = Server.CreateObject("ADODB.Command")
				SqlCommand.ActiveConnection = cnObj
				SqlCommand.CommandText = "UpdateClaimOutcomeReason"
				SqlCommand.CommandType = adCmdStoredProc
				SqlCommand.Parameters("@ActiveInactive")= Request.Form("cboIsActiveInactive_" & Id)
				SqlCommand.Parameters("@ActionId")= 2
				SqlCommand.Parameters("@Id")= Id
				SqlCommand.Parameters("@DCId")= DCId
				SqlCommand.Execute
			Next 
			
			Set SqlCommand = Nothing
			IsSaved = True
			
		ElseIf (Trim(Request.Form("Action")) = "Add") And DCId <> -1 Then
			'response.write "Add Outcome Reason working"
			Set SqlCommand = Server.CreateObject("ADODB.Command")
			SqlCommand.ActiveConnection = cnObj
			SqlCommand.CommandText = "UpdateClaimOutcomeReason"
			SqlCommand.CommandType = adCmdStoredProc
			SqlCommand.Parameters("@OutcomeReasonCode")= Request.Form("txtOutcomeReasonCode")
			SqlCommand.Parameters("@ActionId")= 1
			Set rsObj = SqlCommand.Execute 
			If rsObj("ErrorCode") <> 0 Then
				DisplayMessage =  rsObj("ErrorMessage")
			End If
			
			'response.write SqlCommand
			'response.end
			rsObj.Close
			
			Set rsObj = Nothing
		Else
			txtWarehouseTollerance = "1.00"
			txtSupplierTollerance = "1.00"
			txtBulditDCTollerance = "1.00"
			txtDcVendorTollerance = "1.00"
				
			
		End if
		
		Dim SqlSelectCommand 
		Set SqlSelectCommand = Server.CreateObject("ADODB.Command")
		SqlSelectCommand.ActiveConnection = cnObj
		SqlSelectCommand.CommandText = "GetDcConfiguration"
		SqlSelectCommand.CommandType = adCmdStoredProc
		SqlSelectCommand.Parameters("@DCId") = DCid
			Set rsObj = SqlSelectCommand.Execute 
			If Not (rsObj.EOF And rsObj.BOF) Then
				AllowClaimCaptureForSupplier = rsObj("AllowClaimCaptureForSupplier")
				AllowClaimCaptureForAdminDC = rsObj("AllowClaimCaptureForAdminDC")
				AllowDCsToMaintainSupplierClaims = rsObj("AllowDCsToMaintainSupplierClaims")
				DCEmailAddressForAdminDCClaims = rsObj("DCEmailAddressForAdminDCClaims")
				DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims = rsObj("DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims")
				IsDCAllowedToUploadForceCredits = rsObj("IsDCAllowedToUploadForceCredits")
				IsDCToCaptureAdminDCClaims = rsObj("IsDCToCaptureAdminDCClaims")
				AllowClaimEmails = rsObj("AllowClaimEmails")
				AllowDCManageBuildIt = rsObj("AllowDCManageBuildIt")
				AllowDCGenerateForceCredits = rsObj("AllowDCGenerateForceCredits")
				IsDCAllowedToChangeClaimNumberOnSchedule = rsObj("IsDCAllowedToChangeClaimNumberOnSchedule")
				IsdcAllowedAutoMatchingOfAdminClaim = rsObj("IsdcAllowedAutoMatchingOfAdminClaim")
				txtWarehouseTollerance = rsObj("WarehouseClaimTollerence")
					If txtWarehouseTollerance = "" then txtWarehouseTollerance = "1.00"
				txtSupplierTollerance = rsObj("SupplierClaimTollerence")
					If txtSupplierTollerance = "" then txtSupplierTollerance = "1.00"
				txtBulditDCTollerance = rsObj("BuilditDcClaimTollerance")
					If txtBulditDCTollerance = "" then  txtBulditDCTollerance = "1.00"
				txtDcVendorTollerance = rsObj("DcVendorClaimTollerance")
					If txtDcVendorTollerance = "" then  txtDcVendorTollerance = "1.00"
				
			End If
			
		SET SqlSelectCommand = Nothing
		
		
%>
<style>
.warning
{
    BORDER-RIGHT: #eeeeee 1px;
    BORDER-TOP: #eeeeee 1px;
    FONT-SIZE: 8pt;
    BACKGROUND: #ffffff;
    BORDER-LEFT: #eeeeee 1px;
    COLOR: red;
    BORDER-BOTTOM: #eeeeee 1px;
    FONT-FAMILY: Arial, Helvetica, sans-serif
}
</style>
<script type="text/javascript">


	function fValidateT(t) {
		var messageText = '';
		
		if (t.value >= 100) {
			messageText = 'Tolerance Level for ';
			switch(t.name) {
				case "txtWarehouseTollerance":
					messageText += 'warehouse';
					break;
				case "txtSupplierTollerance":
					messageText += 'supplier';
					break;
				case "txtBulditDCTollerance":
					messageText += 'build it dc';
					break;
				case "txtDcVendorTollerance":
					messageText += 'dc vendor';
					break;
			}
			 messageText +=  ' May not be higher than R99.99';
		}
		
		
		if (messageText != "") alert(messageText);
	}

	function validateEmail(email) 
	{  
		var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
		return email.match(regEx) 
	}
	
	
	function SetDcSelectedVal()
	{
		
		document.forms["dcClaimOptions"].submit();
	}
	
	function onRadioChange(input)
	{
		console.log(document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim);
		if (document.dcClaimOptions.AllowClaimCaptureForAdminDC.value == 0 && document.dcClaimOptions.IsDCToCaptureAdminDCClaims.value == 0)
		{
			document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim.value = 0;
			document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim[0].disabled = true;
			document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim[1].disabled = true;
		}
		else
		{
			document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim[0].disabled = false;
			document.dcClaimOptions.IsdcAllowedAutoMatchingOfAdminClaim[1].disabled = false;
		}
	}
	
	
	function OnSave()
	{
		
		if (document.dcClaimOptions.cboDC.value == '0,Not Selected')
		{
			alert('Please select a DC');
		
			return false;
		
		}
		
		
		var stop = false;
		var toleranceArray = ['txtWarehouseTollerance','txtSupplierTollerance','txtBulditDCTollerance','txtDcVendorTollerance'];
		for (var idx = 0; idx < toleranceArray.length; idx++) {
				var e = document.getElementsByName(toleranceArray[idx]);
				if (e[0].value >= 100) { 
					alert('Tolerance Level May not be higher than R99.99');
		
					
					stop = true;
				}
				
				if (stop) break;
		}
		
		
		if (stop) return false;
      /*   if (document.getElementById('Tolerance').value >= 100)
		 
			{
			alert('Tolerance Level May not be higher than R99.99' + txtBulditDCTollerance);
			
			return false;
			}
			return false;
		*/	
	
		

	}
	
	
		
	
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="dcClaimOptions" method="post" action="dcclaimoptions.asp" onsubmit="return OnSave(this);">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">DC CLAIM CONFIGURATION</td>
        </tr>
		<tr>
			<td>
				
			</td>
		</tr>
    </table>
    <table class="pcontent" border="0" width="100%">
		<tr>
			<td>DC</td>
			<td>		
				<select name="cboDC" id="cboDC" class="pcontent" onchange="SetDcSelectedVal();">
					<% If Session("DCId") = 0 Then %>				
						<option value="0,Not Selected">-- Select a DC --</option>
					<%
						End If

						selected = ""
						
						Set RecordSet = ExecuteSql("listDC @DC=" & Session("DCId"), cnObj)    
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("DCId") & "," & RecordSet("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
								Else 	
									selected = ""
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
			<td></td>
		</tr>
		<tr>
			<td>Allow Claim Capture for Supplier</td>
			<td>
				<% If (AllowClaimCaptureForSupplier) Then %>
					<input type="radio" name="AllowClaimCaptureForSupplier" id="AllowClaimCaptureForSupplierYes" value="1" checked="true" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowClaimCaptureForSupplier" id="AllowClaimCaptureForSupplierNo" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="AllowClaimCaptureForSupplier" id="AllowClaimCaptureForSupplierYes" value="1" <%=IsDisabled%> />Yes
					<input type="radio" name="AllowClaimCaptureForSupplier" id="AllowClaimCaptureForSupplierNo" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		<tr>
			<td>Allow Claim Capture for Admin DC</td>
			<td>
				<% If (AllowClaimCaptureForAdminDC) Then %>
					<input type="radio" name="AllowClaimCaptureForAdminDC" id="AllowClaimCaptureForAdminDCYes" onclick="onRadioChange(this);" value="1" checked="true" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowClaimCaptureForAdminDC" id="AllowClaimCaptureForAdminDCNo" onclick="onRadioChange(this);" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="AllowClaimCaptureForAdminDC" id="AllowClaimCaptureForAdminDCYes" onclick="onRadioChange(this);" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowClaimCaptureForAdminDC" id="AllowClaimCaptureForAdminDCNo" onclick="onRadioChange(this);" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		<!--<tr>
			<td>DC E-Mail address for Admin DC claims</td>
			<td width="65%" colspan="2">
				
				<input width="100%" type="text" name="DCEmailAddressForAdminDCClaims" id="DCEmailAddressForAdminDCClaims" size="60" value="<%=DCEmailAddressForAdminDCClaims%>"/>
			</td>
			
		</tr>-->
		<tr>
			<td>Allow DC to Maintain Supplier Claims</td>
			<td>
				<% If (AllowDCsToMaintainSupplierClaims) Then %>
					<input type="radio" name="AllowDCsToMaintainSupplierClaims" id="AllowDCsToMaintainSupplierClaimsYes" value="1" checked="true" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCsToMaintainSupplierClaims" id="AllowDCsToMaintainSupplierClaimsNo" value="0" <%=IsDisabled%> />No
				<% Else %>
					<input type="radio" name="AllowDCsToMaintainSupplierClaims" id="AllowDCsToMaintainSupplierClaimsYes" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCsToMaintainSupplierClaims" id="AllowDCsToMaintainSupplierClaimsNo" value="0" checked="true"  <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		
		<tr>
			<td>Allow DC to Upload Force Credits via Schedules</td>
			<td>
				<% If (IsDCAllowedToUploadForceCredits) Then %>
					<input type="radio" name="IsDCAllowedToUploadForceCredits" id="IsDCAllowedToUploadForceCredits" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCAllowedToUploadForceCredits" id="IsDCAllowedToUploadForceCredits" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="IsDCAllowedToUploadForceCredits" id="IsDCAllowedToUploadForceCredits" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCAllowedToUploadForceCredits" id="IsDCAllowedToUploadForceCredits" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		
		<tr>
			<td>DC to Capture Admin DC Claims</td>
			<td>
				<% If (IsDCToCaptureAdminDCClaims) Then %>
					<input type="radio" name="IsDCToCaptureAdminDCClaims" id="IsDCToCaptureAdminDCClaims" onclick="onRadioChange(this);" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCToCaptureAdminDCClaims" id="IsDCToCaptureAdminDCClaims" onclick="onRadioChange(this);" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="IsDCToCaptureAdminDCClaims" id="IsDCToCaptureAdminDCClaims" onclick="onRadioChange(this);" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCToCaptureAdminDCClaims" id="IsDCToCaptureAdminDCClaims" onclick="onRadioChange(this);" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		
		<tr>
			<td>Allow Claim Emails</td>
			<td>
				<% If (AllowClaimEmails) Then %>
					<input type="radio" name="AllowClaimEmails" id="AllowClaimEmails" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="AllowClaimEmails" id="AllowClaimEmails" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="AllowClaimEmails" id="AllowClaimEmails" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowClaimEmails" id="AllowClaimEmails" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		<tr>
			<td>Allow DC to Manage Build it Claims</td>
			<td>
				<% If (AllowDCManageBuildIt) Then %>
					<input type="radio" name="AllowDCManageBuildIt" id="AllowDCManageBuildIt" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCManageBuildIt" id="AllowDCManageBuildIt" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="AllowDCManageBuildIt" id="AllowDCManageBuildIt" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCManageBuildIt" id="AllowDCManageBuildIt" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		<tr>
			<td>Allow DC to generate force credit notes from Manage screen</td>
			<td>
				<% If (AllowDCGenerateForceCredits) Then %>
					<input type="radio" name="AllowDCGenerateForceCredits" id="AllowDCGenerateForceCredits" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCGenerateForceCredits" id="AllowDCGenerateForceCredits" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="AllowDCGenerateForceCredits" id="AllowDCGenerateForceCredits" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="AllowDCGenerateForceCredits" id="AllowDCGenerateForceCredits" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		<tr>
			<td>DC allowed to change claim no. on Schedule</td>
			<td>
				<% If (IsDCAllowedToChangeClaimNumberOnSchedule) Then %>
					<input type="radio" name="IsDCAllowedToChangeClaimNumberOnSchedule" id="IsDCAllowedToChangeClaimNumberOnSchedule" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCAllowedToChangeClaimNumberOnSchedule" id="IsDCAllowedToChangeClaimNumberOnSchedule" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="IsDCAllowedToChangeClaimNumberOnSchedule" id="IsDCAllowedToChangeClaimNumberOnSchedule" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="IsDCAllowedToChangeClaimNumberOnSchedule" id="IsDCAllowedToChangeClaimNumberOnSchedule" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		
		<!--
		
		Admin claims change request - Lesley
		03/08/2020 - Xander/Petrus
		
		AllowClaimCaptureforAdminDC
		IsDCToCaptureAdminDCClaims
		
		The value may only be ‘Yes’ if either the ‘Allow Claim Capture for Admin DC’ parameter is ‘Yes’ 
		or if the ‘Capture Admin DC Claims’ is ‘Yes’ for the current DC.
		
		-->
		<tr>
			<td>Allow auto matching of Admin Claims</td>
			<% If (AllowClaimCaptureforAdminDC Or IsDCToCaptureAdminDCClaims) Then %>
			<td>
				<% If (IsdcAllowedAutoMatchingOfAdminClaim) Then %>
					<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="1" checked="true"<%=IsDisabled%>/>Yes
					<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="0" <%=IsDisabled%>/>No
				<% Else %>
					<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="1" <%=IsDisabled%>/>Yes
					<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="0" checked="true" <%=IsDisabled%>/>No
				<% End If %>
			</td>
			
			<% Else %>
			<td>
				<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="1" disabled/>Yes
				<input type="radio" name="IsdcAllowedAutoMatchingOfAdminClaim" id="IsdcAllowedAutoMatchingOfAdminClaim" value="0" checked="true" disabled/>No
			</td>
			<% End If %>
			
			<td></td>
		</tr>
		<!--
		<tr>
			<td>DC email address to notify if force credit has been disputed by supplier</td>
			<td width="65%" colspan="2">
				<input type="text" name="DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims" id="DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims" size="60" value="<%=DCEmailAddressToNotifyIfCreditReceivedForDeductedClaims%>"/>
			</td>
		</tr>-->
		
		<tr>
            <td colspan="2">&nbsp;</td>
        </tr>
		<tr>
            <td class="bheader" align="left" valign="top">Claim Tolerance Parameter</td>
        </tr>
		<tr>
		<td>Warehouse</td>
			<td>
				R&nbsp;<input id="Tolerance" type="text" class="pcontent" style="width:20%" name="txtWarehouseTollerance" onblur="fValidateT(this);" value="<%=txtWarehouseTollerance%>"<%=IsDisabled%> />
			</td>
		</tr>
		<tr>		
		<td>Supplier</td>
			<td>
				R&nbsp;<input id="Tolerance"  type="text" class="pcontent" style="width:20%" name="txtSupplierTollerance" onblur="fValidateT(this);" value="<%=txtSupplierTollerance%>" <%=IsDisabled%> />
			</td>
		</tr>	
		<tr>		
		<td>Build it DC</td>
			<td>
				R&nbsp;<input id="Tolerance"  type="text" class="pcontent" style="width:20%" name="txtBulditDCTollerance" onblur="fValidateT(this);" value="<%=txtBulditDCTollerance%>"<%=IsDisabled%>  />
			</td>
		</tr>
		<tr>		
		<td>DC Vendor</td>
			<td>
				R&nbsp;<input  id="Tolerance"  type="text" class="pcontent" style="width:20%" name="txtDcVendorTollerance" onblur="fValidateT(this);" value="<%=txtDcVendorTollerance%>"<%=IsDisabled%>  />
			</td>
		</tr>			
		
    </table>
	
	<table border="0" class="pcontent">
		<br /><br />
		
		
		
		
	</table>
	
	<table cellpadding="2" cellspacing="0" bordercolor="#333366" width="30%" class="pcontent">
		<%if IsDisabled = "" then%>
		
			<tr>
				<td class="bheader" colspan="2">Add new Outcome Reason codes</td>
			</tr>
			
			<tr>
				<td>
					<input class="pcontent" type="text" placeholder="Outcome Reason Code" id="txtOutcomeReasonCode" name="txtOutcomeReasonCode" value="<%=txtOutcomeReasonCode%>" <%=IsDisabled%>  size="50%"></input>
					<input class="button" <%=IsDisabled%>  type="submit" id="btnAddReasonCode" name="Action" value="Add"/>
					
					
					<br/>
				</td>
			</tr>
		<%Else %>
			<tr>
				<td class="bheader" colspan="2">Outcome Reason codes</td>
			</tr>
		<%end if%>
		
		<tr>
			<td colspan="3" class="warning">
				<%
					Response.Write DisplayMessage
				%>
			</td>
		</tr>
<%	

		Set rsObj =  ExecuteSql("ListClaimOutcomeReason @DCId=" & DCId, cnObj)   


	If Not (rsObj.BOF And rsObj.EOF) Then
%>	
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" cellSpacing="2" align="center"><b>Outcome Reason Code</b></td>
			<td class="tdcontent" align="center"><b>Active/ Inactive</b></td>
		</tr>
	
	
<%
		While Not rsObj.EOF
			Ids = Ids & rsObj("LinkedId") & ","
		
		
			Response.Write "<tr>"
			Response.Write "	<td class='pcontent' align='center'>" & rsObj("Value") & "</td>"

			Dim IsActiveSelected, IsInactiveSelected
			IsActiveSelected = ""
			IsInactiveSelected = ""
			If rsObj("IsActiveInactive")  Then
				IsActiveSelected = "selected"
			Else
				IsInactiveSelected = "selected"
			End If
			Response.Write "	<td class='pcontent' align='center'>"
			%>
				<select name="cboIsActiveInactive_<%=rsObj("LinkedId")%>" id="cboIsActiveInactive_<%=rsObj("LinkedId")%>" <%=IsDisabled%>  class="pcontent" >
					<option <%=IsActiveSelected%>  value="1">Active</option>
					<option <%=IsInactiveSelected%>  value="0">Inactive</option>
				</select>
				</br>
				
			<%
			
			Response.Write "	</td>"
			
			Response.Write "</tr>"
		
			rsObj.MoveNext
		Wend
		Ids = Mid(Ids,1,Len(Ids)-1)
%>

<%
	end if
%>	

	</table>
	<table>
		<tr>
			<td>
			<input class="button" type="hidden" name="Ids" style="width: px" value="<%=Ids%>"/>
			</td>
		
			<td><br/><br/><input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/></td>
			<% If IsDisabled <> "" then  %>
			<td></td>
			<%Else %>
            <td><br/><br/><input class="button" type="submit" name="Action" style="width: 98px" value="Save"/></td>
			<%End If%>
		</tr>
		<tr>
			<td colspan="3" class="warning">
			
				<% 	
					If IsSaved Then 
						Response.Write "<b>Updated Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
					End If
				%>
			</td>
		</tr>

		
	</table>
	
    <%
		
		cnObj.Close
		Set cnObj = Nothing
		
	%>
    
</form>

