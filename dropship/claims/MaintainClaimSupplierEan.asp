<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	Dim Folder, ButtonAction, cnObj, RecordSet
	If Session("HideMenu") <> True Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, Now(), 0)	

	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString


	ButtonAction = Trim(Request.Form("ButtonAction"))
	
	If (TRIM(ButtonAction) = "Replace") Then
		Set RecordSet = ExecuteSql("MaintainClaimSupplierEan @ActionId=2, @SupplierEan='" & Replace(Request.Form("txtSupplierEan"),"'","''") & "',@NewSupplierEan='" & Replace(Request.Form("txtSupplierEanNew"),"'","''") & "'", cnObj)
		If RecordSet("ErrorCode")<> 0 Then
			Deleted = RecordSet("ErrorMessage")
		End If
	End If
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>SPAR</title>
	<meta charset="utf-8" />
	<link rel="stylesheet" href="../includes/jquery-ui.css" />
	<script src="../includes/jquery.min.js"></script>
	<script src="../includes/jquery-ui.js"></script>
	
	<link rel="stylesheet" href="style.css" />
	<style>
		.ui-autocomplete-loading {    
			background: white url('ui-anim_basic_16x16.gif') right center no-repeat;  
		}  
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

	
	function ValidateSearch(obj)
	{
		if (MaintainClaimSupplierEan["txtSupplierEan"].value == '')
		{
			alert('Please enter the old supplier ean for claim');
			
			return false;
		};	
			
		return true;
	}
			
	function ValidateReplace(obj)
	{
		if (MaintainClaimSupplierEan["txtSupplierEan"].value == '')
		{
			alert('Please enter the old supplier ean for claim');
			
			return false;
		}
		
		if (MaintainClaimSupplierEan["txtSupplierEanNew"].value == '')
		{
			alert('Please enter the replacement ean');
				
			return false;
		};
		
		if (MaintainClaimSupplierEan["txtSupplierEan"].value != '' && MaintainClaimSupplierEan["txtSupplierEanNew"].value != '')
		{
			var c = confirm("Replace " + MaintainClaimSupplierEan["txtSupplierEan"].value + " with " + MaintainClaimSupplierEan["txtSupplierEanNew"].value);
			if (c == 6 || c == true) // yes
			{
				//alert('it will be done');
				return true;
			}
		}
		
		return false;
	}
	
		
	
	function OnDelete(obj) {
	
		// Verify at least on box selected
		for (var i = 0; i < MaintainClaimSupplierEan.elements.length; i++ ) {
			if (MaintainClaimSupplierEan.elements[i].type == 'checkbox') {
				if (MaintainClaimSupplierEan.elements[i].checked == true) {
					if (confirm('This will update supplier eans\n') == 6)
						return true;
					else
						return false;
				}
			}
		}
		
		alert('You have not selected any claims to update');
		
		return false;
	}

	
</script>
</head>

	<table border="0" class="pcontent">
		<br /><br />
		<tr>
			<td class="bheader" align="left" valign="top">MAINTAIN CLAIM EAN</td>
		</tr>
	</table>
<form name="MaintainClaimSupplierEan" id="MaintainClaimSupplierEan" method="post" action="MaintainClaimSupplierEan.asp" >
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
		<table>
			<tr>
				<td colspan="3" class="pcontent">
					<label for="txtSupplierEan">Old Ean</label> 
				</td>
				<td colspan="3" class="pcontent">
					<input id="txtSupplierEan" name="txtSupplierEan" value="<%=Request.Form("txtSupplierEan")%>" />
				</td>					
				<td><input class="button" type="submit" name="ButtonAction" id="btnSearch" style="width: 98px" value="Search" onclick="return ValidateSearch(this);"/></td>
			</tr>
			<tr>
				<td colspan="3" class="pcontent">
					<label for="txtSupplierEanNew">Replacement Ean</label> 
				</td>
				<td colspan="3" class="pcontent">
					<input id="txtSupplierEanNew" name="txtSupplierEanNew" value="<%=Request.Form("txtSupplierEanNew")%>" />
				</td>
				<td><input class="button" type="submit" name="ButtonAction" id="btnReplace" style="width: 98px" value="Replace" onclick="return ValidateReplace(this);"//></td>
			</tr>
			<tr>
				<td colspan="7" class="pcontent">
					<label><i>Only top 10 in the search results will be displayed</i></label> 
				</td>
			</tr>

		</table>
<%	
	Dim SupplierEan, Deleted
	SupplierEan = Request.Form("txtSupplierEan")
	If SupplierEan = "" Then
		If Request.Form("IsSubmitted") = 1 Then
%>
			<table border="1" cellpadding="0" cellspacing="0" width="50%" id="storetable" name="storetable">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center">Please enter supplier ean for claims</td>
				</tr>
			</table>
<%		
		End If
	Else
		Dim rsObj
	
		Set rsObj = ExecuteSql("MaintainClaimSupplierEan @ActionId=1, @SupplierEan='" & Replace(SupplierEan,"'","''") & "'", cnObj)
		If Not (rsObj.BOF And rsObj.EOF) Then
	%>	
			<table cellSpacing="2" cellPadding="4" border="0" id="claimtable" name="claimtable">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center"><b>Claim Number</b></td>
					<td class="tdcontent" align="center"><b>Ean</b></td>
				</tr>
	<%
			While Not rsObj.EOF
				Response.Write "<tr>" 
				Response.Write "	<td class='pcontent'>" & rsObj("CLcClaimNumber") & "</td>"
				Response.Write "	<td class='pcontent'>" & rsObj("CLcSupplierEan") & "</td>"
				Response.Write "</tr>"
			
				rsObj.MoveNext
			Wend
	%>
			</table>
	<%
		Else
	%>
			<table border="1" cellpadding="0" cellspacing="0" width="50%" id="storetable" name="storetable">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center">No claims found</td>
				</tr>
			</table>
	<%	
		End If
		cnObj.Close
		Set cnObj = Nothing
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
	End If
	%>	
	<input type="hidden" name="InputId" id="InputId" value="0"/>
	<input type="hidden" id="HDcId" value="-1"/>
	<input type="hidden" id="IsSubmitted" value="1"/>
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