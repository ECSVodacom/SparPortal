<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	Dim cnObj, Message, rsObj

	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If Request.Form("btnSave") = "Save" Then
		Response.Write "Save Clickerd"
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
<script type="text/javascript">
	function OnSave()
	{
		return false;
	}
</script>

</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="SupplierSubCategoryNew" method="post" action="SupplierSubCategoryNew.asp?action=save" onsubmit="return OnSave();"">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">Claim Sub Category Add</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="40%">
		<tr>
			<td>Claim Sub Category</td>
			<td width="65%">
				<input type="text" col="3" rows="3" name="txtClaimReasonDescription"></input>
			</td>
		</tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
		<tr>
			<td>
				<input type="button"align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="window.open('close.html', '_self');">
			</td>
            <td>
				<input class="button" type="submit" style="width: 98px" id="btnSave" value="Save" />
			</td>
	    </tr>
     </table>
	 <br />
	 <table>
		
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><b>Claim Sub Category</b></td>
		</tr>
		
		<%
			Set rsObj = ExecuteSql(GetClaimSubCategories, cnObj)  
			If Not (rsObj.BOF And rsObj.EOF) Then
				While Not rsObj.EOF
		%>
			<tr>
				<td class="pcontent" align="center"><%=rsObj("ClaimSubCategoryName")%></td>
			</tr>
		<%	
					rsObj.MoveNext
				Wend
			Else %>
			
		<%  End If
			rsObj.Close
		%>
	</table>
	<table>
		<tr>
			<td class="warning" colspan="2"><b><%Response.Write Message%></b></td>
		</tr>
	</table>
</form>
<%
	Set rsObj = Nothing
	
	cnObj.Close	
	Set cnObj = Nothing
%>

