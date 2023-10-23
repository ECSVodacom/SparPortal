<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	Dim txtClaimCategory, txtDCEmailAddressForClaimCategories, chkActiveInactiveIndicator, txtWarehouseCategoryId
	Dim sqlUpdate, cnObj, ClaimCategoryId , rsObj, HiddenAction, DoAction, ErrorMessage, Message
	Dim IsDisabled
	
	
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

	' Check is save button was clicked
	'If (Request.QueryString("action") = "save") Then
	
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then 
		Dim WarehouseCategoryId , ClaimCategoryType
		If IsNumeric(Request.Form("txtWarehouseCategoryId")) Then
			WarehouseCategoryId = CLng(Request.Form("txtWarehouseCategoryId"))
		Else
			WarehouseCategoryId = -1
		End If
		'response.write  Request.Form("cboClaimCategoryType")

		ClaimCategoryType = Split(Request.Form("cboClaimCategoryType"),",")(0)		

		sqlUpdate = "MaintainClaimCategory @ClaimCategoryId=" & ClaimCategoryId _
			& ", @ClaimCategory='" & Request.Form("txtClaimCategory") _
			& "',@Action=" & HiddenAction _
			& ",@ActiveInactiveIndicator=" & chkActiveInactiveIndicator _
			& ",@ClaimTypeId=1" _
			& ",@WarehouseCategoryId=" & WarehouseCategoryId _
			& ",@ClaimCategoryType=" & ClaimCategoryType 
		'response.write sqlUpdate	
		'response.end
		Set rsObj = ExecuteSql(sqlUpdate, cnObj)  
		If rsObj("ClaimCategoryId") <> "" Then
			ClaimCategoryId = rsObj("ClaimCategoryId")
		End If
		'Response.Write "New ClaimCategoryId : " & ClaimCategoryId
'' TODO: Update
		 Dim sqlDoLink, iSelected, LinkedDCsCount, DCArray, ReplaceSpaces, LinkedDCs, NewDcCategoryName, NewDCEmail
		 'ReplaceSpaces = Replace(Request.Form("chkSelect")," ","")
		 'DCArray = Split(ReplaceSpaces,",")
		 LinkedDCs = Request.Form("LinkedDCs")
		 DCArray = Split(LinkedDCs,",")
		 LinkedDCsCount = UBound(DCArray) - 1
		 If LinkedDCsCount <> - 1 Then
			''Update DCs
			For iSelected = 0 To LinkedDCsCount
				NewDcCategoryName = Trim(Replace(Request.Form("DCCategoryName_" & DCArray(iSelected)),"'","''"))
				
				If NewDcCategoryName = "" Then
					NewDcCategoryName = Request.Form("txtClaimCategory")
				End If
				If (NewDcCategoryName <> "") Then
				
					sqlDoLink = "LinkUnlinkWarehouseClaimCategories @ClaimCategoryId=" & ClaimCategoryId _
						& ",@Link=1" _
						& ",@DCId=" & DCArray(iSelected) _
						& ",@DCCategoryName='" & NewDcCategoryName & "'" _
						& ",@DCCategoryEmail='" & Replace(Request.Form("DCCategoryEmail_" & DCArray(iSelected)),"'","''") & "'" _
						& ",@DCCategoryPricingEmail='" & Replace(Request.Form("DCCategoryPricingEmail_" & DCArray(iSelected)),"'","''") & "'" _
						& ",@AllowZeroClaims='" & Request.form("AllowZeroClaims_" & DCArray(iSelected)) & "'" 
					
					ExecuteSql sqlDoLink, cnObj 

				Else
					sqlDoLink = "LinkUnlinkWarehouseClaimCategories @ClaimCategoryId=" & ClaimCategoryId _
						& ",@Link=0" _
						& ",@DCId=" & DCArray(iSelected) 
					'response.write sqlDoLink

					ExecuteSql sqlDoLink, cnObj
				End If
			Next 
		End If
		
		
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
	If (CInt(ClaimCategoryId) <> 0)Then
		Set rsObj = ExecuteSql("GetClaimCategory @ClaimCategoryId=" & ClaimCategoryId, cnObj) 
		
		If Not (rsObj.EOF And rsObj.BOF) Then
			txtClaimCategory = rsObj("ClaimCategory")
			txtWarehouseCategoryId = rsObj("WarehouseCategoryId")
			chkActiveInactiveIndicator = rsObj("ActiveInactiveIndicator")
			ClaimCategoryType = rsObj("CategoryTypeId")
			
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
	
	function IsNumeric(input)
	{
		return (input - 0) == input && (input+'').replace(/^\s+|\s+$/g, "").length > 0;
	}
	
	function ShowHideMe(claimCategoryType)
	{
		var dcIds = document.getElementsByName('LinkedDCs')[0].value.split(",");
		var showHide = ""
		
		if (claimCategoryType.value == "2,Warehouse") {
			document.getElementById("DCCategoryNameHeader").style.display="block"; 
			showHide = "block";
		}
		else {
			document.getElementById("DCCategoryNameHeader").style.display="none"; 
			showHide = "none";
		}
		
		if (claimCategoryType.value == "2,Warehouse" || claimCategoryType.value == "3,Both" ) {
			document.getElementById("DCCategoryPricingEmailHeader").style.display="block"; 
			showHidePricingEmail = "block";
		}
		else {
			document.getElementById("DCCategoryPricingEmailHeader").style.display="none"; 
			showHidePricingEmail = "none";
		}
		
		for (var idx = 0; idx < dcIds.length -1; idx++)
		{
			document.getElementById("DCCategoryColumn_" + dcIds[idx]).style.display=showHide; 	
			document.getElementById("DCCategoryPricingColumn_" + dcIds[idx]).style.display=showHidePricingEmail; 
		}
	}
	
	function OnSave()
	{
		if (document.getElementById("txtClaimCategory").value == "")
		{
			alert("Please enter a claim category");
			document.getElementById("txtClaimCategory").focus();

			return false;
		}
		
		if (document.getElementById("txtWarehouseCategoryId").value != '' && !IsNumeric(document.getElementById("txtWarehouseCategoryId").value))
		{
			alert("Please enter a valid numeric warehouse category id");
			document.getElementById("txtWarehouseCategoryId").focus();
			
			return false;
		}
		
		return true;
	}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="SupplierAdminClaimsCategoriesMaintain" method="post" action="SupplierAdminClaimsCategoriesMaintain.asp?claimcategoryid=<%=claimcategoryid%>" onsubmit="return OnSave();">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">SUPPLIER CLAIM CATEGORIES</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="40%">
		<tr>
			<td>Claim Category*</td>
			<td width="65%">
				<input type="text" name="txtClaimCategory" id="txtClaimCategory" value="<%=txtClaimCategory%>"/>
			</td>
		</tr>
		<tr>
			<td>Warehouse Category Id</td>
			<td width="65%">
				<input type="text" name="txtWarehouseCategoryId" id="txtWarehouseCategoryId" maxlength="10" value="<%=txtWarehouseCategoryId%>"/>
			</td>
		</tr>
		<%
'		response.write ClaimCategoryType
		%>
		
		<tr>
			<td>Claim Category Type</td>
			<td width="65%">
				<select name="cboClaimCategoryType" id="cboClaimCategoryType" onChange="ShowHideMe(this);">
					<%
						If ClaimCategoryType = 1 Then
					%>
							<option selected="selected" value="1,Supplier">Supplier</option>
							<option value="2,Warehouse">Warehouse</option>
							<option value="4,Both">Build It DC</option>
							<option value="5,Both">DC Vendor</option>
							<option value="3,Both">Both</option>
					<%
						ElseIf ClaimCategoryType = 2 Then
					%>
							<option value="1,Supplier">Supplier</option>
							<option selected="selected" value="2,Warehouse">Warehouse</option>
							<option value="4,Both">Build It DC</option>
							<option value="5,Both">DC Vendor</option>
							<option value="3,Both">Both</option>

					<%
						ElseIf ClaimCategoryType = 3 Then
					%>
							<option value="1,Supplier">Supplier</option>
							<option value="2,Warehouse">Warehouse</option>
							<option value="4,Both">Build It DC</option>
							<option value="5,Both">DC Vendor</option>
							<option selected="selected" value="3,Both">Both</option>
					<%
						ElseIf ClaimCategoryType = 4 Then
					%>
							<option value="1,Supplier">Supplier</option>
							<option value="2,Warehouse">Warehouse</option>
							<option selected="selected" value="4,Both">Build It DC</option>
							<option value="5,Both">DC Vendor</option>
							<option value="3,Both">Both</option>
					<%
						ElseIf ClaimCategoryType = 5 Then
					%>
							<option value="1,Supplier">Supplier</option>
							<option value="2,Warehouse">Warehouse</option>
							<option value="4,Both">Build It DC</option>
							<option selected="selected" value="5,Both">DC Vendor</option>
							<option value="3,Both">Both</option>
					<%
					Else
					%>
					
							<option value="1,Supplier">Supplier</option>
							<option value="2,Warehouse">Warehouse</option>
							<option value="4,Both">Build It DC</option>
							<option value="5,Both">DC Vendor</option>
							<option selected="selected" value="3,Both">Both</option>
					<%
						End If
					%>
					
				</select>
			</td>
		</tr>

		<tr>
			<td>Active / Inactive Indicator</td>
			<td>
				<% If (chkActiveInactiveIndicator) Then %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1" disabled='disabled' checked="true" />Active
					<input type="radio" name="chkActiveInactiveIndicator"  value="0" disabled='disabled' />Inactive
				<% Else %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1"  />Active
					<input type="radio" name="chkActiveInactiveIndicator"  value="0"   checked="true"/>Inactive
				<% End If %>
			</td>
			<td></td>
		</tr>
        <tr>
			<td>&nbsp;</td>
        </tr>
    </table>
	
		<%
			Dim ToDisplayOrBlock
			If ClaimCategoryType = 2 or ClaimCategoryType = 4  or ClaimCategoryType = 5  Then
				ToDisplayOrBlock = "block"
			Else
				ToDisplayOrBlock = "none"
			End If
			
			Dim HidePricingEmail
			If ClaimCategoryType = 3 Or ClaimCategoryType = 2 Then
				HidePricingEmail = "block"
			Else
				HidePricingEmail = "none"
			End If
			
		%>
		
		
		<div id="DCCategoryNames" name="DCCategoryNames">
			<table cellSpacing="2" cellPadding="4" border="0">
				<tr bgcolor="#4C8ED7">
					<!--<td class="tdcontent" align="center"><b>Update</b></td>-->
					<td class="tdcontent" align="center"><b>DC</b></td>
					<td style="display: <%=ToDisplayOrBlock%>" id="DCCategoryNameHeader" name="DCCategoryNameHeader" class="tdcontent" align="center"><b>DC Category Name</b></td>
					<td class="tdcontent" align="center"><b>Email</b></td>
					<td style="display: <%=HidePricingEmail%>" id="DCCategoryPricingEmailHeader" class="tdcontent" align="center"><b>Pricing Email</b></td>
					<td class="tdcontent" align="center"><b>Allow Zero Value Claims</b></td>
				</tr>
		<%
					Set rsObj = 	ExecuteSql("GetWarehouseDCsClaimCategories @ClaimCategoryId=" & ClaimCategoryId, cnObj) 
					LinkedDCs = ""
					'Response.Write "exec GetWarehouseDCsClaimCategories @ClaimCategoryId=" & ClaimCategoryId
					
					' Loop through the recordset
					While Not rsObj.EOF
						LinkedDCs = LinkedDCs & rsObj("DCId") & ","
						
						
			%>
				<tr>
					<td class='pcontent'><%=rsObj("DCName")%></td>
					<td class='pcontent' style="display: <%=ToDisplayOrBlock%>" id="DCCategoryColumn_<%=rsObj("DCId")%>"><input type="text" class="pcontent" id="DCCategoryName_<%=rsObj("DCId")%>" name="DCCategoryName_<%=rsObj("DCId")%>" value='<%=rsObj("DCCategoryName")%>' width="100%"/></td>
					<td class='pcontent' ><input type="text" size="50%" class="pcontent" id="DCCategoryEmail_<%=rsObj("DCId")%>" name="DCCategoryEmail_<%=rsObj("DCId")%>" value='<%=rsObj("DCEmailToNotifyForceCreditDisputed")%>' width="100%"/></td>
					<td class='pcontent' style="display: <%=HidePricingEmail%>" id="DCCategoryPricingColumn_<%=rsObj("DCId")%>"><input type="text" size="50%" class="pcontent" id="DCCategoryPricingEmail_<%=rsObj("DCId")%>" name="DCCategoryPricingEmail_<%=rsObj("DCId")%>" value='<%=rsObj("DCCategoryPricingEmail")%>' width="100%"/></td>
					
					<td class='pcontent'>
						<% 
						  If rsObj("AllowZeroClaims") Then %>
							<input type="radio" name="AllowZeroClaims_<%=rsObj("DCId")%>" id="AllowZeroClaims_<%=rsObj("DCId")%>" value="1" checked="true"<%=IsDisabled%>/>Yes
							<input type="radio" name="AllowZeroClaims_<%=rsObj("DCId")%>" id="AllowZeroClaims_<%=rsObj("DCId")%>" value="0" <%=IsDisabled%>/>No
						<% Else %>
							<input type="radio" name="AllowZeroClaims_<%=rsObj("DCId")%>" id="AllowZeroClaims_<%=rsObj("DCId")%>" value="1" <%=IsDisabled%>/>Yes
							<input type="radio" name="AllowZeroClaims_<%=rsObj("DCId")%>" id="AllowZeroClaims_<%=rsObj("DCId")%>" value="0" checked="true" <%=IsDisabled%>/>No
						<% End If %>
					</td>
				</tr>
			<%											
						rsObj.MoveNext
					Wend
		%>									
			</table>
		</div>
	
	<table>
		<tr>
			<td>
				<input type="button"align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="window.opener.document.getElementById(name='btnRefresh').click(); window.open('close.html', '_self');">
			</td>
            <td>
				<input class="button" type="submit" style="width: 98px" value="Save" name="btnSaved" id="btnSaved" onclick="return OnSave();"/>
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
	<input type="hidden" id="LinkedDCs" name="LinkedDCs" value="<%=LinkedDCs%>">
</form>