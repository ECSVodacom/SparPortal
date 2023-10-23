<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	Dim txtClaimCategory, txtDCEmailAddressForClaimCategories, chkActiveInactiveIndicator
	Dim sqlUpdate, cnObj, ClaimCategoryId , rsObj, HiddenAction, DoAction, ErrorMessage, Message
	
	ErrorMessage = ""
	Message = ""
	chkActiveInactiveIndicator = true

	ClaimCategoryId = Request.QueryString("ClaimCategoryId")
	If ClaimCategoryId = "" Then
		ClaimCategoryId = Request.Form("HiddenClaimCategoryId")
	End If
	If ClaimCategoryId = 0 Then
		HiddenAction = 3
	Else
		HiddenAction = 2
	End If
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString

	If Request.Form("chkActiveInactiveIndicator") <> "" Then
		chkActiveInactiveIndicator = Request.Form("chkActiveInactiveIndicator")
	End If
	
	LinkedDCs = ""
	' Check is save button was clicked
	If (Request.QueryString("action") = "save") Then
		sqlUpdate = "MaintainClaimCategory @ClaimCategoryId=" & ClaimCategoryId _
			& ", @ClaimCategory='" & Request.Form("txtClaimCategory") _
			& "',@DCEmailAddressForClaimCategory='" & Request.Form("txtDCEmailAddressForClaimCategories") _
			& "',@Action=" & HiddenAction _
			& ",@ActiveInactiveIndicator=" & chkActiveInactiveIndicator _
			& ",@ClaimTypeId=2"
		
		'Response.Write sqlUpdate
		Set rsObj = ExecuteSql(sqlUpdate, cnObj) 
		
		If ClaimCategoryId = 0 Then ClaimCategoryId = CInt(rsObj("ClaimCategoryId"))
		
		Dim sqlDoLink, iSelected, SelectedDCsArray, ReplaceSpaces
		Dim AllDcsArray, AllDcs
		ReplaceSpaces = Replace(Request.Form("chkSelect")," ","")
		SelectedDCsArray = Split(ReplaceSpaces,",")
		AllDcs = Mid(Request.Form("LinkedDCs"),1,Len(Request.Form("LinkedDCs"))-1)
		AllDcsArray = Split(AllDcs,",")
		
		' Selected needs to be updated
		For iSelected = 0 To UBound(SelectedDCsArray) 
			sqlDoLink = "LinkUnlink @ClaimCategoryId=" & ClaimCategoryId _
				 & ",@Link=1" _
				 & ",@DCId=" & SelectedDCsArray(iSelected) _
				 & ",@EmailDCClaim='" & Request.Form("EmailAddressForDCClaim_" & SelectedDCsArray(iSelected)) _
				 & "',@EmailCreditReceived='" & Request.Form("EmailToNotifyIfCreditReceivedForDeductedClaims_" & SelectedDCsArray(iSelected)) _
				 & "',@ConvertToSupplierClaim=" & Request.Form("cboConvertToSupplierClaim_" & SelectedDCsArray(iSelected))
				 
			ExecuteSql sqlDoLink, cnObj 
		Next
		
		Dim idx, idx2, IsInArray, sqlDoUnlink
		For idx = 0 To UBound(AllDcsArray)
			For idx2 = 0 To UBound(SelectedDCsArray)
				If (SelectedDCsArray(idx2) = AllDcsArray(idx)) Then
					IsInArray = True
					Exit For
				End If
			Next 
			
			If Not IsInArray Then
				sqlDoUnlink = "LinkUnlink @ClaimCategoryId=" & ClaimCategoryId _
					& ",@Link=0" _
					& ",@DCId=" & AllDcsArray(idx)
				
				ExecuteSql sqlDoUnlink, cnObj
			End If
			
			IsInArray = False
		Next
		
		
		
		
		If (Trim(rsObj("ErrorCode")) = "-1") Then 
			ErrorMessage = rsObj("ErrorDescription") 
		Else
			If HiddenAction = 3 Then
				Message = "Added "
			Else
				Message = "Updated "
			End If
			Message = Message & "Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now)
		End If
		
		
	End If

	' Load category details
	
	If (ClaimCategoryId <> 0)Then
		Set rsObj =  ExecuteSql("GetClaimCategory @ClaimCategoryId=" & ClaimCategoryId, cnObj)     
		If Not (rsObj.EOF And rsObj.BOF) Then
			txtClaimCategory = rsObj("ClaimCategory")
			txtDCEmailAddressForClaimCategories = rsObj("DCEmailAddressForClaimCategory")
			chkActiveInactiveIndicator = rsObj("ActiveInactiveIndicator")
		End If
		rsObj.Close
	End If
	
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
	function validateEmail(email) 
	{  
		var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
		return email.match(regEx) 
	}
	
	function trim(str) { 
        return str.replace(/^\s+|\s+$/g,""); 
	} 
	
	function OnSave()
	{
		if (document.getElementById("txtClaimCategory").value == "")
		{
			alert("Please enter at claim category");
			document.getElementById("txtClaimCategory").focus();

			return false;
		}
		
		if (document.getElementById("txtDCEmailAddressForClaimCategories").value == "")
		{
			var emailText = document.getElementById("txtDCEmailAddressForClaimCategories");
			if (!validateEmail(emailText.value))
			{
				alert("Please enter at least one valid email address");
				emailText.focus();
		
				return false;
			}
		}
		
		var emails = document.getElementById("txtDCEmailAddressForClaimCategories").value.split(';');
		for (i = 0; i < emails.length; i++) {
			if (!validateEmail(trim(emails[i])))
			{
				alert('"' + emails[i] + '" is not a valid email address.\nPlease ensure that email addresses are seperated by ;\nPlease correct and try again');
				
				return false;
			}
		};
		
		return true;
	}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="DCAdminClaimsCategoriesMaintain" method="post" action="DCAdminClaimsCategoriesMaintain.asp?action=save" onsubmit="return OnSave();">
    <table border="0" class="pcontent">
	
        <tr>
            <td class="bheader" align="left" valign="top">ADMIN DC CLAIM CATEGORIES</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="40%">
		<tr>
			<td>Claim Category*</td>
			<td width="65%">
				<input type="text" class="pcontent" name="txtClaimCategory" value="<%=txtClaimCategory%>"/>
			</td>
		</tr>
		<!-- <tr>
			' <td>DC E-mail address for Claim Category*<br /><i><b>You can add multiple email addresses seperated with ;</b></i></td>
			' <td width="65%">
				' <textarea type="text" rows="4" cols="30" name="txtDCEmailAddressForClaimCategories"/><%=txtDCEmailAddressForClaimCategories%></textarea>
			' </td>
		' </tr> -->
		<tr>
			<td>Active / Inactive Indicator</td>
			<td>
				<% If (chkActiveInactiveIndicator) Then %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1" checked="true" disabled='disabled'/>Active
					<input type="radio" name="chkActiveInactiveIndicator"  value="0" disabled='disabled'/>Inactive
				<% Else %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1" />Active
					<input type="radio" name="chkActiveInactiveIndicator"  value="0" checked="true" />Inactive
				<% End If %>
			</td>
			<td></td>
		</tr>
        <tr>
			<td>&nbsp;</td>
        </tr>
    </table>
		
	
	<table cellSpacing="2" cellPadding="4" border="0">
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><b>Link</b></td>
			<td class="tdcontent" align="center"><b>DC</b></td>
			<td class="tdcontent" align="center"><b>Email notification:<br />DC Claim</b></td>
			<td class="tdcontent" align="center"><b>Email notification: Credit<br />received for deducted claims</b></td>
			<td class="tdcontent" align="center"><b>Convert to supplier claim</b></td>
		</tr>
<%

			    
			
			
			
			Set rsObj = ExecuteSql("GetDCsLinkedToClaimCategory @ClaimCategoryId=" & ClaimCategoryId, cnObj)     
			Dim Selected, LinkedDCs 
			Selected = ""
			LinkedDCs = ""
				
			' Loop through the recordset
			While Not rsObj.EOF
				LinkedDCs = LinkedDCs & rsObj("DCId")  & "," 
	%>
		<tr>
			<td class='pcontent'>
				<% If rsObj("Linked") Then %>
					<input type="checkbox" name="chkSelect" class="pcontent" checked value="<%=rsObj("DCId")%>"/>
				<%Else%>
					<input type="checkbox" name="chkSelect" class="pcontent" value="<%=rsObj("DCId")%>"/>
				<%End If%>
			</td>
			<td class='pcontent'><%=rsObj("DCName")%></td>
			<td class='pcontent'><input type="text" class="pcontent" id="EmailAddressForDCClaim_<%=rsObj("DCId")%>" name="EmailAddressForDCClaim_<%=rsObj("DCId")%>" value='<%=rsObj("EmailForAdminDCClaims")%>' width="100%"/></td>
			<td class='pcontent'><input type="text" class="pcontent" id="EmailToNotifyIfCreditReceivedForDeductedClaims_<%=rsObj("DCId")%>" name="EmailToNotifyIfCreditReceivedForDeductedClaims_<%=rsObj("DCId")%>" value='<%=rsObj("EmailToNotifyIfCreditReceivedForDeductedClaims")%>' width="100%"/></td>
			<td class='pcontent'>
				<select name="cboConvertToSupplierClaim_<%=rsObj("DCId")%>" id="cboConvertToSupplierClaim_<%=rsObj("DCId")%>" class="pcontent">
					<% If rsObj("ConvertToSupplierClaim") Then %>
						<option selected="selected" value="1">Yes</option>
						<option value="0">No</option>
					<% Else %>
						<option value="1">Yes</option>
						<option selected="selected" value="0">No</option>
					<% End If %>
				</select>
			</td>
		</tr>
	<%											
				rsObj.MoveNext
			Wend
			
			cnObj.Close
			Set cnObj = Nothing
%>									

	<table>
	


	<table>
		<tr>
			<td>
				<input type="button"align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="window.opener.document.getElementById(name='btnRefresh').click(); window.open('close.html', '_self');">
			</td>
            <td>
				<input class="button" type="submit" style="width: 98px" value="Save" onclick="window.opener.document.getElementById(name='btnRefresh').click();"/>
			</td>
	    </tr>
	</table>
	<table>
		<tr>
			<td class="warning" colspan="2"><b><%Response.Write ErrorMessage%></b></td>
		</tr>
		<tr>
			<td class="warning" colspan="2"><b><%Response.Write Message%></b></td>
		</tr>
	</table>
	<input type="hidden" name="hiddenClaimCategoryId" value="<%=ClaimCategoryId%>">
	<input type="hidden" name="hiddenAction" value="<%=HiddenAction%>">
	<input type="hidden" name="LinkedDCs" value="<%=LinkedDCs%>">
	
	
	
</form>

