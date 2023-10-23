<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/genmenuitems.asp"-->
<%
	Dim Folder, StoreIds, i, ClaimCategoryId, SqlUpdate, Deleted, ButtonAction	
	
	If Session("HideMenu") <> True Then Folder = GenMenu (Session("UserType"), Session("Permission"), const_app_ApplicationRoot, Now(), 0)	
	
	Dim DCId, Selected
	Dim cnObj, rsObj
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Deleted = ""
	ButtonAction = Request.Form("ButtonAction")

	If Request.Form("InputId") <> "" Then
		StoreIds = CInt(Request.Form("InputId"))
		SqlUpdate = "MaintainSupplierClaimCaptureStoreExceptions @StoreId=" & StoreIds & ", @AddNew=1" 	
		Set rsObj = ExecuteSql(SqlUpdate, cnObj)		
	
	End If
	
	If Request.Form("chkSelect") <> "" And ButtonAction = "Delete" Then
		StoreIds = Split(Request.Form("chkSelect"),",")
		For i = 0 To UBound(StoreIds)
			SqlUpdate = "MaintainSupplierClaimCaptureStoreExceptions @StoreId=" & Trim(StoreIds(i)) & ", @Delete=1" 			
			Set rsObj = ExecuteSql(SqlUpdate, cnObj)		
			Deleted = Deleted & "<b>" & rsObj("ErrorDescription") & "</b><br />"
		Next 
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

	
	function OnDelete(obj) {
	
		// Verify at least on box selected
		for (var i = 0; i < SupplierClaimCaptureStoreExceptions.elements.length; i++ ) {
			if (SupplierClaimCaptureStoreExceptions.elements[i].type == 'checkbox') {
				if (SupplierClaimCaptureStoreExceptions.elements[i].checked == true) {
					if (confirm('This will disable the selected store(s)\nfor claim capture override\nYes to confirm\n') == 6)
						return true;
					else
						return false;
				}
			}
		}
		
		alert('You have not selected any stores to be deleted');
		
		return false;
	}

	$(function() {    
		$("select#cboDc").change(function(){
			$( "#store" ).val( '' );
			$("#SupplierClaimCaptureStoreExceptions").submit();
		});
	
	
		function log( message ) {  
			$( "#store" ).flushCache();
			$( "#store" ).val('');
		}
		$( "#store" ).autocomplete({
			source:  function(request, response) {
				$.getJSON("SearchStores.asp", { storename: $('#store').val(), dcId: $("select#cboDc").val() }, response);
			},
			timeout : 1000,
			delay: 750,
			focus: function( event, ui ) {
				$( "#store" ).val( ui.item.value );
				return false;
			},
			minLength: 3,
			select: function( event, ui ) {
				if (ui.item.id != "-1")
				{		
					$("#InputId").val(ui.item.id)
					$("#SupplierClaimCaptureStoreExceptions").submit()
				}
			}
		});
	});
</script>
</head>

	<table border="0" class="pcontent">
		<br /><br />
		<tr>
			<td class="bheader" align="left" valign="top">SUPPLIER CLAIM CAPTURE - STORE EXCEPTIONS</td>
		</tr>
	</table>
<form name="SupplierClaimCaptureStoreExceptions" id="SupplierClaimCaptureStoreExceptions" method="post" action="SupplierClaimCaptureStoreExceptions.asp" >
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
		<table>
			<tr>
				<td>
					<input class="button" type="submit" name="ButtonAction" id="btnRefresh" style="width: 98px" value="Refresh"/>
				</td>
				<td>
					<input class="button" type="submit" name="ButtonAction" onclick="javascript:return OnDelete(this)" style="width: 98px" value="Delete"/>
					
				</td>
			</tr>
			<tr>
				<td colspan="3" class="pcontent">
					DC:&nbsp;&nbsp;&nbsp;&nbsp;	
						<select name="cboDc" id="cboDc" class="pcontent">
<%
										
										if Session("DCID") = 0 then
%>				
					<option value="0">-- All --</option>
<%
										end if

										' Set a connection
													
										' Get a list of Stores
										Set rsObj =  ExecuteSql("listDC @DC=" & Session("DCID"), cnObj)	
													
										Selected = ""
													
										' Loop through the recordset
										While Not rsObj.EOF
											If CStr(rsObj("DCID")) = Request.Form("cboDc") Then
												Selected = "selected"
											else
												Selected = ""
											end if
%>
					<option <%=Selected%> value="<%=rsObj("DCID")%>"><%=rsObj("DCcName")%></option>
<%											
											rsObj.MoveNext
										Wend
										' Close the Connection and RecordSet
%>									
				</select>


				</td>
			</tr>
			<tr>
				<td colspan="3" class="pcontent">
					<i>To add a store enter store name below</i><br />
					<label for="store">Store:</label> 
					<input id="store" />
				</td>
			</tr>
		</table>
<%	
	Dim LoadDcId 
	If Request.Form("cboDc") = "" Then
		LoadDcId = 0
	Else
		LoadDcId = Request.Form("cboDc")
	End If
	

	Set rsObj = ExecuteSql("MaintainSupplierClaimCaptureStoreExceptions @DCId=" & LoadDcId, cnObj)	    
	
	If Not (rsObj.BOF And rsObj.EOF) Then
%>	
		<table cellSpacing="2" cellPadding="4" border="0" id="storetable" name="storetable">
			<tr>
				<td></td>
			</tr>
			
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Delete</b></td>
				<td class="tdcontent" align="center"><b>DC</b></td>
				<td class="tdcontent" align="center"><b>Store</b></td>
			</tr>
		
<%
		While Not rsObj.EOF
			Response.Write "<tr>" 
			Response.Write "	<td class='pcontent'>"%><input type="checkbox" name="chkSelect" value="<%=rsObj("StoreId")%>"/></td><%
			Response.Write "	<td class='pcontent'>" & Replace(rsObj("DcName"),"SPAR ","") & "</td>"
			Response.Write "	<td class='pcontent'>" & rsObj("StoreName") & "	(" & rsObj("StoreCode") & ")" & "</td>"
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
				<td class="tdcontent" align="center">No stores</td>
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
	<input type="hidden" name="InputId" id="InputId" value="0"/>
	<input type="hidden" id="HDcId" value="-1"/>
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