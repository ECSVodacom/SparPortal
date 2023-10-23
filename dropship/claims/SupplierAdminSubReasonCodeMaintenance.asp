<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	Dim txtClaimCategory, txtClaimReasonCode, chkActiveInactiveIndicator, txtClaimReasonDescription, ClaimSubReasonId, ErrorMessage
	Dim sqlUpdate, cnObj, ClaimCategoryId , RecordSet, HiddenAction, DoAction, Selected, rsObj, Message, txtClaimSubReasonCode, ClaimReasonCodeId
	
	ErrorMessage = ""
	Message = ""
	chkActiveInactiveIndicator = true
	
	ClaimSubReasonId = Request.QueryString("ClaimSubReasonId")
	If ClaimSubReasonId = "" Then
		ClaimSubReasonId = Request.Form("ClaimSubReasonId")
	End If
	If ClaimSubReasonId = 0 Then
		' Add new
		HiddenAction = 3
	Else
		' Update existing
		HiddenAction = 2
	End If
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If Request.QueryString("action") = "save" Then
		ClaimCategoryId = Request.Form("cboClaimCategory")
		ClaimCategoryId = Split(ClaimCategoryId,",")(0)
		
		ClaimReasonCodeId = Request.Form("cboClaimReasonCode")
		ClaimReasonCodeId = Split(ClaimReasonCodeId,",")(0)
		
		SqlUpdate = "MaintainClaimCategorySubReasons @ClaimSubReasonId=" & ClaimSubReasonId _
			& ", @ClaimReasonId=" & ClaimReasonCodeId _
			& ", @Code='" & Request.Form("txtClaimSubReasonCode") _
			& "', @Description='" & Request.Form("txtClaimReasonDescription") _
			& "', @Action=" & HiddenAction
	
		Set rsObj = ExecuteSql(sqlUpdate, cnObj)  
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
	If (ClaimSubReasonId <> 0)Then
		Set rsObj =  ExecuteSql("GetClaimSubReason @ClaimSubReasonId=" & ClaimSubReasonId, cnObj)  

		If Not (rsObj.EOF And rsObj.BOF) Then
			ClaimCategoryId = rsObj("ClaimCategoryId")
			ClaimReasonCodeId = rsObj("ClaimReasonId")
			txtClaimSubReasonCode = rsObj("Code")
			txtClaimReasonDescription = rsObj("Description")
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
<script type="text/javascript" src="../includes/jquery-1.7.2.min.js"></script>
<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#cboClaimCategory").change(function(){
		$.getJSON("../includes/json.asp",{id: $(this).val()}, function(j){
			var options = '';

			for (var i = 0; i < j.length; i++) {
				 options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + '">' + j[i].optionDisplay + '</option>'
			}
			
			$('#cboClaimReasonCode').html(options);
			$('#cboClaimReasonCode option:first').attr('selected', 'selected');
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

		if (document.getElementById("cboClaimReasonCode").value == "-1,Not Selected")
		{
			alert("Please select reason code");
			document.getElementById("cboClaimReasonCode").focus();
			
			return false;
		}



		if (document.getElementById("txtClaimSubReasonCode").value == "")
		{
			alert("Please enter sub reason code");
			document.getElementById("txtClaimSubReasonCode").focus();
			
			return false;
		}
		
		
		if (document.getElementById("txtClaimReasonDescription").value == "")
		{
			alert("Please enter sub reason description");
			document.getElementById("txtClaimReasonDescription").focus();
			
			return false;
		}


		
		
		
		return true;
	}
</script>

</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="SupplierAdminSubReasonCodeMaintenance" method="post" action="SupplierAdminSubReasonCodeMaintenance.asp?action=save" onsubmit="return OnSave();"">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">SUPPLIER CLAIM SUB REASONS</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="40%">
		<tr>
		
			<td>Claim Category*</td>
			<td>
				<select name="cboClaimCategory" id="cboClaimCategory" class="pcontent">
						<option value="-1,Not Selected">-- Claim Category --</option>
					<%
						Selected = ""
						Dim ClaimCategoryIds
						ClaimCategoryIds = ""
						Set RecordSet = ExecuteSql("ListClaimsCategories @ClaimTypeId=1, @WithAllowSubReasons=1", cnObj)   
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If InStr(ClaimCategoryIds,"|" & RecordSet("ClaimCategoryId") & "|") = 0 Then ' Prevent duplicate categories
									ClaimCategoryIds  = ClaimCategoryIds & "|" & RecordSet("ClaimCategoryId") & "|"
									
									If (RecordSet("ClaimCategoryId") & "," & RecordSet("ClaimCategory") = Request.Form("cboClaimCategory")) _
										Or  (RecordSet("ClaimCategoryId") = CInt(ClaimCategoryId)) Then
										Selected = "selected"
									Else 	
										Selected = ""
									End If
							%>
									<option <%=Selected%> value="<%=RecordSet("ClaimCategoryId")%>,<%=RecordSet("ClaimCategory")%>"><%=RecordSet("ClaimCategory")%></option>
							<%
								End If
							
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
			<td width="65%" >
				<select name="cboClaimReasonCode" id="cboClaimReasonCode" class="pcontent">
					<option value="-1,Not Selected">-- Claim Reason Code --</option>
				<%
					If ClaimCategoryId <> "" Then
						Selected = ""

						Set RecordSet = ExecuteSql("ListClaimsCategories @ClaimTypeId=1, @WithAllowSubReasons=1, @ClaimCategoryId=" & ClaimCategoryId, cnObj)
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If (RecordSet("ClaimReasonId") & "," & RecordSet("ReasonCode") = Request.Form("cboClaimReasonCode")) _
									Or  (RecordSet("ClaimReasonId") = CInt(ClaimReasonCodeId)) Then
									Selected = "selected"
								Else 	
									Selected = ""
								End If
					%>
							<option <%=Selected%> value="<%=RecordSet("ClaimReasonId")%>,<%=RecordSet("ReasonCode")%>"><%=RecordSet("ReasonCode") & " - " & RecordSet("ClaimReasonDescription")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If
						
						RecordSet.Close
						Set RecordSet = Nothing
					End If
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td>Claim Sub Reason Code*</td>
			<td width="65%">
				<input type="text" class="pcontent" name="txtClaimSubReasonCode" value="<%=txtClaimSubReasonCode%>" maxlength="2"/>
			</td>
		</tr>

		<tr>
			<td>Claim Sub Reason Description*</td>
			<td width="65%">
				<textarea type="text" class="pcontent" col="3" rows="3" name="txtClaimReasonDescription"><%=txtClaimReasonDescription%></textarea>
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
            <td colspan="2">&nbsp;</td>
        </tr>
     </table>
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
	<input type="hidden" name="ClaimSubReasonId" value="<%=ClaimSubReasonId%>">
	<input type="hidden" name="hiddenAction" value="<%=HiddenAction%>">
</form>
<%
	cnObj.Close	
	Set cnObj = Nothing
%>

