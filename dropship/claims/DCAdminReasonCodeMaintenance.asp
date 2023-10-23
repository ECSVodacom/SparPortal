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
	Dim sqlUpdate, cnObj, ClaimCategoryId , RecordSet, HiddenAction, DoAction, Selected, rsObj, Message
	
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
	
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	
	If Request.Form("chkActiveInactiveIndicator") <> "" Then
		chkActiveInactiveIndicator = Request.Form("chkActiveInactiveIndicator")
	End If
	
	If Request.QueryString("action") = "save" Then
		ClaimCategoryId = Request.Form("cboClaimCategory")
		ClaimCategoryId = Split(ClaimCategoryId,",")(0)

		
		
		
		SqlUpdate = "MaintainClaimCategoryReasonCodes @ClaimCategoryId=" & ClaimCategoryId _
			& ", @ClaimReasonDescription='" & Request.Form("txtClaimReasonDescription") _
			& "', @Action=" & HiddenAction _
			& ", @ClaimReasonId=" & ClaimReasonId _
			& ", @ClaimTypeId=2" _
			& ",@ActiveInactiveIndicator=" & chkActiveInactiveIndicator 
		
		
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
	If (ClaimReasonId <> 0)Then
		Set rsObj =  ExecuteSql("GetClaimCategoryReasonCodes @ReasonCodeId=" & ClaimReasonId, cnObj)      
		
		If Not (rsObj.EOF And rsObj.BOF) Then
			ClaimCategoryId = rsObj("ClaimCategoryId")
			txtClaimReasonCode = rsObj("ReasonCode")
			txtClaimReasonDescription = rsObj("ReasonCodeDescription")
			chkActiveInactiveIndicator = rsObj("ActiveInactiveIndicator")
		End If
		rsObj.Close
	End If
	
	
%>
<script type="text/javascript">
	function OnSave()
	{
		if (document.getElementById("cboClaimCategory").value == "-1,Not Selected")
		{
			alert("Please select claim category");
			document.getElementById("cboClaimCategory").focus();
			
			return false;
		}
		
		/*if (document.getElementById("txtClaimReasonCode").value == "")
			{
				alert("Please enter claim reason code");
				document.getElementById("txtClaimReasonCode").focus();
			
				return false;
			}
		*/	
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
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="DCAdminReasonCodeMaintenance" method="post" action="DCAdminReasonCodeMaintenance.asp?action=save" onsubmit="return OnSave();"">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">ADMIN DC CLAIM REASONS</td>
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
						Set RecordSet = ExecuteSql("ListClaimsCategories @ClaimTypeId=2", cnObj)
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If (RecordSet("ClaimCategoryId") & "," & RecordSet("ClaimCategory") = Request.Form("cboClaimCategory")) _
									Or  (RecordSet("ClaimCategoryId") = ClaimCategoryId) Then
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
		<!--<tr>
			<td>Claim Reason Code*</td>
			<td width="65%" >
				<input type="text" name="txtClaimReasonCode" value="<%=txtClaimReasonCode%>" maxlength="2"/>
			</td>
		</tr>-->
		<tr>
			<td>Claim Reason Description*</td>
			<td width="65%">
				<textarea type="text" class="pcontent" col="4" rows="3" name="txtClaimReasonDescription"><%=txtClaimReasonDescription%></textarea>
			</td>
		</tr>
		<tr>
			<td>Active / Inactive Indicator</td>
			<td>
				<% If (chkActiveInactiveIndicator) Then %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1" checked="true" <!--disabled='disabled' -->Active 
					<input type="radio" name="chkActiveInactiveIndicator"  value="0" <!--disabled='disabled'-->Inactive
				<% Else %>
					<input type="radio" name="chkActiveInactiveIndicator" value="1"/>Active
					<input type="radio" name="chkActiveInactiveIndicator"  value="0" checked="true" />Inactive
				<% End If %>
			</td>
			<td></td>
		</tr>
        <tr>
            <td colspan="2">&nbsp</td>
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
	<input type="hidden" name="hiddenClaimReasonId" value="<%=ClaimReasonId%>">
	<input type="hidden" name="hiddenAction" value="<%=HiddenAction%>">
</form>
<%
	cnObj.Close	
	Set cnObj = Nothing
%>

