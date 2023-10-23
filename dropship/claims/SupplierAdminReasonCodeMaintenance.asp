<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->

<%	if Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	end if %>
<script type="text/javascript">
if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	}
</script>

<%
	Dim txtClaimCategory, txtClaimReasonCode, chkActiveInactiveIndicator, txtClaimReasonDescription, ClaimReasonId, ErrorMessage 
	Dim sqlUpdate, cnObj, ClaimCategoryId , RecordSet, HiddenAction, DoAction, Selected, rsObj, Message, DoAllowSubReasons, chkAllowSubReasons
	Dim ClaimTypeId , ClaimCategoryTypeId
	
	ErrorMessage = ""
	Message = ""
	chkActiveInactiveIndicator = true
	
	ClaimReasonId = Request.QueryString("ClaimReasonId")
	If ClaimReasonId = "" Then
		ClaimReasonId = Request.Form("HiddenClaimReasonId")
	End If
	If ClaimReasonId = 0 Then
		' Add new
		HiddenAction = 3
	Else
		' Update existing
		HiddenAction = 2
	End If
	
	If Request.Form("cboClaimType") = "" Then
		ClaimTypeId = 3
	Else 
		ClaimTypeId = Split(Request.Form("cboClaimType"),",")(0)
	End If
	
	
	
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If Request.QueryString("action") = "save" Then
		ClaimCategoryId = Request.Form("cboClaimCategory")
		ClaimCategoryId = Split(ClaimCategoryId,",")(0)
		
		SqlUpdate = "MaintainClaimCategoryReasonCodes @ClaimCategoryId=" & ClaimCategoryId _
			& ", @ClaimReasonCode='" & Request.Form("txtClaimReasonCode") _
			& "', @ClaimReasonDescription='" & Request.Form("txtClaimReasonDescription") _
			& "', @Action=" & HiddenAction _
			& ", @ClaimReasonId=" & ClaimReasonId _
			& ", @ClaimTypeId=1" _
			& ", @AllowSubReasons=" &  Request.Form("chkAllowSubReasons") 
			
		Set rsObj = ExecuteSql(SqlUpdate, cnObj) 
		If (rsObj("ErrorCode") = "-1") Then 
			ErrorMessage = rsObj("ErrorDescription") 
		Else
			If HiddenAction = 3 Then
				Message = "Added "
			Else
				Message = "Updated "
			End If
			Message = Message & "Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now)
		End If
		rsObj.Close
	End If
	
	' Load category details
	If (ClaimReasonId <> 0)Then
		Set rsObj = ExecuteSql("GetClaimCategoryReasonCodes @ReasonCodeId=" & ClaimReasonId, cnObj)  
		
		If Not (rsObj.EOF And rsObj.BOF) Then
			ClaimCategoryId = rsObj("ClaimCategoryId")
			ClaimCategoryTypeId = rsObj("CategoryTypeId")
			txtClaimReasonCode = rsObj("ReasonCode")
			txtClaimReasonDescription = rsObj("ReasonCodeDescription")
			chkActiveInactiveIndicator = rsObj("ActiveInactiveIndicator")
			chkAllowSubReasons = rsObj("AllowSubReasons")
			ClaimTypeId = ClaimCategoryTypeId
		End If
		rsObj.Close
	End If
%><!DOCTYPE html>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script type="text/javascript">
$(function() {
	$("select#cboClaimType").change(function(){
		$.getJSON("../includes/json_claimcategories.asp",{id: $(this).val(), doSearch: false, dcid: 0, isCodeMaintenance: true }, function(k){
			var options = '';
			
			for (var i = 0; i < k.length; i++) {
				if (k[i].optionValue == -1)
					options += '<option value="-1,Not Selected">-- Claim Category --</option>'
				else
					options += '<option value="' + k[i].optionValue + ',' + k[i].optionDisplay + '">' + k[i].optionDisplay + '</option>'
			}
			
			$('#cboClaimCategory').html(options);
			$('#cboClaimCategory option:first').attr('selected', 'selected');
			
		})
	})
})
</script>
<script type="text/javascript">
	function OnSave()
	{
		if (document.getElementById("cboClaimCategory").value == "-1,Not Selected")
		{
			alert("Please select claim category");
			document.getElementById("cboClaimCategory").focus();
			
			return false;
		}
		
		if (document.getElementById("txtClaimReasonCode").value == "")
			{
				alert("Please enter claim reason code");
				document.getElementById("txtClaimReasonCode").focus();
			
				return false;
			}

		if (document.getElementById("txtClaimReasonDescription").value == "")
		{
			alert("Please enter claim reason description");
			document.getElementById("txtClaimReasonDescription").focus();
			
			return false;
		}

		return true;
	}
</script>
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
	<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
	<title>SPAR</title>
</head>
<form name="SupplierAdminReasonCodeMaintenance" method="post" action="SupplierAdminReasonCodeMaintenance.asp?action=save" onsubmit="return OnSave();">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">SUPPLIER CLAIM REASONS</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="40%">
		<tr>

			<td>Claim&nbsp;Type:</td>
			<td>
				<select name="cboClaimType" id="cboClaimType" class="pcontent">
					<option <%If ClaimTypeId = 3 Or ClaimCategoryTypeId = 3 Then Response.Write "selected "%>value="3,Warehouse Claim">Warehouse Claim</option>
					<option <%If ClaimTypeId = 5 Or ClaimCategoryTypeId = 5 Then Response.Write "selected "%>value="5,DC Claims">DC Vendor Claims</option>
				</select>
			</td>
		</tr>
		
		
		<tr>
			<td>Claim Category*</td>
			<td>
				<select name="cboClaimCategory" id="cboClaimCategory" class="pcontent">
						<option value="-1,Not Selected">-- Claim Category --</option>
					<%
						Selected = ""
						
						Set RecordSet = ExecuteSql("ListClaimsCategories @ClaimTypeId=" & ClaimTypeId & ",@IsCodeMaintenance=1", cnObj)  'changed from 1 to 3 - dropdown was displaying duplicate categories
						
					
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If (RecordSet("ClaimCategoryId") & "," & RecordSet("ClaimCategory") = Request.Form("cboClaimCategory")) _
									Or  (CInt(RecordSet("ClaimCategoryId")) = CInt(ClaimCategoryId)) Then
									Selected = "selected"
								Else 	
									Selected = ""
								End If
					%>
							<option <%=Selected%> value="<%=RecordSet("ClaimCategoryId")%>,<%=RecordSet("ClaimCategory")%>"><%=RecordSet("ClaimCategory")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If
						
						RecordSet.Close
						Set RecordSet = Nothing
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td>Claim Reason Code*</td>
			<td width="65%" ><input type="text" class="pcontent" name="txtClaimReasonCode" value="<%=txtClaimReasonCode%>" maxlength="2"/>
			</td>
		</tr>
		<tr>
			<td>Claim Reason Description*</td>
			<td width="65%">
				<textarea type="text" col="3" rows="3" name="txtClaimReasonDescription"><%=txtClaimReasonDescription%></textarea>
			</td>
		</tr>
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
			<td>Allow sub reasons</td>
			<td>
				<% If (chkAllowSubReasons) Then %>
					<input type="radio" name="chkAllowSubReasons" value="1" checked="true" />Yes
					<input type="radio" name="chkAllowSubReasons" value="0" />No
				<% Else %>
					<input type="radio" name="chkAllowSubReasons" value="1"/>Yes
					<input type="radio" name="chkAllowSubReasons" value="0" checked="true"/>No
				<% End If %>
			<td>
		</tr>

		<tr>
            <td colspan="2">&nbsp;</td>
        </tr>
     </table>
	 <table>
		<tr>
			<td>
				<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="window.opener.document.getElementById(name='btnRefresh').click(); window.open('close.html', '_self');">
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

	<input type="hidden" name="hiddenClaimReasonId" value="<%=ClaimReasonId%>">
	<input type="hidden" name="hiddenAction" value="<%=HiddenAction%>">
</form>
<%
	cnObj.Close	
	Set cnObj = Nothing
%>

