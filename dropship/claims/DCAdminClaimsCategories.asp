<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	Dim Folder, ClaimCategoryIds, i, ClaimCategoryId, SqlUpdate, Deleted, ButtonAction	
	
	If Session("HideMenu") <> True Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, Now(), 0)	
	
	Dim cnObj, rsObj
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Deleted = ""
	ButtonAction = Request.Form("ButtonAction")

	If Request.Form("chkSelect") <> "" And  ButtonAction = "Delete" Then
		ClaimCategoryIds = Split(Request.Form("chkSelect"),",")
		For i = 0 To UBound(ClaimCategoryIds)
			SqlUpdate = "MaintainClaimCategory @ClaimCategoryId=" & Trim(ClaimCategoryIds(i)) & ", @Action=1, @ClaimTypeId=2" 			
			
			Set rsObj = ExecuteSql(SqlUpdate, cnObj)  
			
			Deleted = Deleted & "<b>" & rsObj("ErrorDescription") & "</b><br />"
		Next 
	End If
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
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
	
	function OnDelete(obj) {
	
		// Verify at least on box selected
		for (var i = 0; i < DCAdminClaimsCategories.elements.length; i++ ) {
			if (DCAdminClaimsCategories.elements[i].type == 'checkbox') {
				if (DCAdminClaimsCategories.elements[i].checked == true) {
					if (confirm('This will delete the selected categories'))
						return true;
					else
						return false;
				}
			}
		}
		
		alert('You have not selected any categories to be deleted');
		
		return false;
	}

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="DCAdminClaimsCategories" method="post" action="DCAdminClaimsCategories.asp" >
	<table border="0" class="pcontent">
		<br /><br />
		<tr>
			<td class="bheader" align="left" valign="top">ADMIN DC CLAIM CATEGORIES</td>
		</tr>
	</table>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
	<table>
		<tr>
			<td>
				<input class="button" type="button" onclick="window.open('<%=const_app_ApplicationRoot%>/claims/dcadminclaimscategoriesmaintain.asp?ClaimCategoryId=0')" style="width: 98px" value="Add New"/>
			</td>
			<td>
				<input class="button" type="submit" name="ButtonAction" id="btnRefresh" style="width: 98px" value="Refresh"/>
			</td>
			
			<td>
				<input class="button" type="submit" name="ButtonAction" onclick="javascript:return OnDelete(this)" style="width: 98px" value="Delete"/>
			</td>
		</tr>
		<tr>
			<td colspan="3" class="pcontent">
				<i>To update a category, click on the name of the category</i>
			</td>
		</tr>
	</table>
<%	
	Set rsObj = ExecuteSql("ListClaimsCategories " _ 
		& "@ClaimTypeId=2",	cnObj)  
	If Not (rsObj.BOF And rsObj.EOF) Then
%>	
		<table cellSpacing="2" cellPadding="4" border="0">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Delete</b></td>
				<td class="tdcontent" align="center"><b>Claim Category</b></td>
				<!--<td class="tdcontent" align="center"><b>DC E-mail address for Claim Category</b></td>-->
				<td class="tdcontent" align="center"><b>Active / Inactive Indicator</b></td>
			</tr>
		
<%
		Dim ActiveInactiveIndicator
		
		ActiveInactiveIndicator = "Active"
		While Not rsObj.EOF
			
			If (rsObj("ActiveInactiveIndicator")) Then 
				ActiveInactiveIndicator = "Active"
			Else
				ActiveInactiveIndicator = "Inactive"
			End If
			
			
			Response.Write "<tr>"
			
			If ActiveInactiveIndicator = "Active" Then
				Response.Write "	<td class='pcontent'>"%><input type="checkbox" name="chkSelect" value="<%=rsObj("ClaimCategoryId")%>"/></td><%
			Else
				Response.Write "	<td class='pcontent'>"%><input type="checkbox" name="chkSelect" disabled="disabled" value="<%=rsObj("ClaimCategoryId")%>"/></td><%
			End If
			
			
			Response.Write "	<td class='pcontent'>"%><a href='<%=const_app_ApplicationRoot%>/claims/dcadminclaimscategoriesmaintain.asp?claimcategoryid=<%=rsObj("ClaimCategoryId")%>' target='_blank'><%=rsObj("ClaimCategory")%></a></td><%
			'Response.Write "	<td class='pcontent'>" & rsObj("DCEmailAddressForClaimCategory") & "</td>"
			Response.Write "	<td class='pcontent'>" & ActiveInactiveIndicator & "</td>"
			Response.Write "</tr>"
		
			rsObj.MoveNext
		Wend
%>
		</table>

<%
	Else
%>
		<table border="1" cellpadding="0" cellspacing="0" width="50%">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center">No DC admin claims categories available</td>
			</tr>
		</table>
<%	
	End If
	cnObj.Close
	
	If Deleted <> "" Then
%>	
		<table>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="3" class="warning">
					<%=Deleted%>
					<input type="hidden" name="IsSubmit" id="IsSubmit" value="1"/>
				</td>
				
			</tr>
		</table>
<%
	End If
%>
</form>
<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/menu.css">
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu.js"></script>
<script language="JavaScript" src="<%=const_app_ApplicationRoot%>/includes/menu_tpl.js"></script>
<script language="JavaScript">
	<!--		
		<%=Folder%>	

		new menu (MENU_ITEMS, MENU_POS);
	//-->
</script>
<!--#include file="../layout/end.asp"-->