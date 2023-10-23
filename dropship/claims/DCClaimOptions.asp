<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
	Dim SqlUpdate
	Dim cnObj, rsObj, SqlSelect
	Dim AllowCaptureClaimForSupplier, AllowCaptureClaimForDC, DCEmailAddressForDCClaims
	Dim DCId
	
	DCId = Session("ProcID")
	
	
	AllowCaptureClaimForSupplier = ""
	AllowCaptureClaimForDC = ""
	DCEmailAddressForDCClaims = ""
	Set cnObj = Server.CreateObject("ADODB.Connection")

	cnObj.Open const_db_ConnectionString

		If (Request.QueryString("action") = "save") Then
			SqlUpdate = "SetDcConfiguration @DCId=" DCId _
				& "@AllowCaptureClaimForSupplier=" & Request.Form("AllowCaptureClaimForSupplier")  _
				& "@AllowCaptureClaimForDC=" & Request.Form("AllowCaptureClaimForDC") _
				& "@DCEmailAddressForDCClaims=" & Request.Form("DCEmailAddressForDCClaims")
				
			ExecuteSql SqlUpdate, cnObj 
		End If
		

		Set rsObj = ExecuteSql("GetDcConfiguration @DCId=" & DCId, cnObj)  
		If Not (rsObj.EOF and rsObj.BOF) Then
			AllowCaptureClaimForSupplier = CBool(rsObj("AllowCaptureClaimForSupplier"))
			AllowCaptureClaimForDC = CBool(rsObj("AllowCaptureClaimForDC"))
			DCEmailAddressForDCClaims = rsObj("DCEmailAddressForDCClaims")
		End if
		rsObj.Close
		Set rsObj = Nothing		


		

		
	cnObj.Close
	Set cnObj = Nothing
										
%>
<script type="text/javascript">
	function validateEmail(email) 
	{  
		var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
		return email.match(regEx) 
	}
	
	function OnSave()
	{
		if (document.dcClaimOptions.AllowCaptureClaimForSupplier[0].checked || document.getElementById("DCEmailAddressForDCClaims").value != "")
		{
			var emailText = document.getElementById("DCEmailAddressForDCClaims");
			if (!validateEmail(emailText.value))
			{
				alert("E-mail address for DC claims\nPlease enter a valid E-mail address");
				emailText.focus();
				return false;
			}
		}
		return true;
	}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SPAR</title>

</head>

<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="dcClaimOptions" method="post" action="dcclaimoptions.asp?action=save" onsubmit="return OnSave();"">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">CLAIMS SEARCH AND LIST</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="70%">
        <tr>&nbsp;</tr>
		<tr>
			<td>Allow Capture Claim for Supplier</td>
			<td>
				<% If (AllowCaptureClaimForSupplier) Then %>
					<input type="radio" name="AllowCaptureClaimForSupplier" value="1" checked="true"/>Yes
					<input type="radio" name="AllowCaptureClaimForSupplier"  value="0" />No
				<% Else %>
					<input type="radio" name="AllowCaptureClaimForSupplier" value="1" />Yes
					<input type="radio" name="AllowCaptureClaimForSupplier"  value="0" checked="true"/>No
				<% End If %>
			</td>
			<td></td>
		</tr>
		<tr>
			<td>Allow Capture Claim for DC</td>
			<td>
				<% If (AllowCaptureClaimForDC) Then %>
					<input type="radio" name="AllowCaptureClaimForDC" value="1" checked="true"/>Yes
					<input type="radio" name="AllowCaptureClaimForDC" value="0" />No
				<% Else %>
					<input type="radio" name="AllowCaptureClaimForDC" value="1" />Yes
					<input type="radio" name="AllowCaptureClaimForDC" value="0" checked="true" />No
				<% End If %>
			</td>
			<td></td>
			test
		</tr>
		<!--<tr>
			<td>DC E-Mail address for DC claims</td>
			<td width="65%">
				<input type="text" name="DCEmailAddressForDCClaims" value="<%=DCEmailAddressForDCClaims%>"/>
			</td>
		</tr>-->
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><input class="button" type="submit" style="width: 98px" value="Save"/></td>
        </tr>
    </table>
    
    
</form>

