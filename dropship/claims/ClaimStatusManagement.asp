<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	Dim IsSaved
	
	Dim Folder, Ids, i, ClaimCategoryId, SqlUpdate, ButtonAction	, Deleted
	
	If Session("HideMenu") <> True Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, Now(), 0)	
	
	Dim cnObj, rsObj
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Deleted = ""
	ButtonAction = Request.Form("Action")
	
	If ButtonAction = "Save" Then
		Dim IdsArray, UpdateId
		IdsArray = Split(Request.Form("Ids"),",")
		

	
		For i = 0 To UBound(IdsArray)
			UpdateId = Trim(IdsArray(i))
			If TRIM(Replace(Request.Form("txtStatusName_" & UpdateId),"'","''")) <> "" Then
				SqlUpdate = "UpdateClaimStatus @Id=" & UpdateId & ", @NewStatusDescription='" & TRIM(Replace(Request.Form("txtStatusName_" & UpdateId),"'","''")) & "', @OpenOrClosed=" & Request.Form("cboOpenOrClosed_" & UpdateId)
		
				Set rsObj = ExecuteSql(SqlUpdate, cnObj)
			Else
				Deleted = "<br/>Change to blank status ignored"
			End If
		Next 
		IsSaved = True
	
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

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="ClaimStatusManagement" method="post" action="ClaimStatusManagement.asp" >
	<table border="0" class="pcontent">
		<br /><br />
		<tr>
			<td class="bheader" align="left" valign="top">CLAIM STATUS MANAGEMENT</td>
		</tr>
	</table>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
	<table>
		<tr>
		</tr>
		<tr>
			<td colspan="3" class="pcontent">
				<i></i>
			</td>
		</tr>
	</table>
<%	
	Set rsObj = ExecuteSql("ListClaimStatus", cnObj)   
	If Not (rsObj.BOF And rsObj.EOF) Then
%>	
		<table cellSpacing="2" cellPadding="4" border="0">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Status</b></td>
				<td class="tdcontent" align="center"><b>Open / Closed</b></td>
				<td class="tdcontent" align="center"><b>Last Updated</b></td>
			</tr>
<%
		While Not rsObj.EOF
			Ids = Ids & rsObj("Id") & ","
		
		
			Response.Write "<tr>"
			Response.Write "	<td class='pcontent' align='center'><input width='100%'  class='pcontent'  type='text' name='txtStatusName_" & rsObj("Id") & "' id='txtStatusName_" & rsObj("Id") & "' size='60' value='" & rsObj("Value") & "'/></td>"

			Dim IsOpenSelected, IsClosedSelected
			IsOpenSelected = ""
			IsClosedSelected = ""
			If rsObj("IsOpenOrCLosed")  Then
				IsOpenSelected = "selected"
			Else
				IsClosedSelected = "selected"
			End If
			Response.Write "	<td class='pcontent' align='center'>"
			%>
				<select name="cboOpenOrClosed_<%=rsObj("Id")%>" id="cboOpenOrClosed_<%=rsObj("Id")%>" class="pcontent" >
					<option <%=IsOpenSelected%> value="1">Open</option>
					<option <%=IsClosedSelected%> value="0">Closed</option>
				</select>
			<%
			Response.Write "	</td>"
			Response.Write "	<td class='pcontent' align='center'>" & rsObj("LastUpdated") & "</td>"
			Response.Write "</tr>"
		
			rsObj.MoveNext
		Wend
		Ids = Mid(Ids,1,Len(Ids)-1)
%>
		</table>

<%
	Else
%>
		<table border="1" cellpadding="0" cellspacing="0" width="50%">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center">No claim status to maintain</td>
			</tr>
		</table>
<%	
	End If
	cnObj.Close
%>
<table>
		<tr>
            <td><input class="button" type="submit" name="Action" style="width: 98px" value="Save"/></td>
			<td><input type="hidden" name="Ids" value="<%=Ids%>"/></td>
        </tr>
		<tr>
			<td colspan="3" class="warning">
				<% 	
					If IsSaved Then 
						Response.Write "<b>Updated Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
					End If
					
					If Deleted <> "" Then
						Response.Write "<b>" & Deleted & "</b>"
					End If
				%>
			</td>
		</tr>
</table>	

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