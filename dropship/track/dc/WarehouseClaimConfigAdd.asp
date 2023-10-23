<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincookie.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
	Dim SqlCommand, cnObj, rsObj
	Dim IsSaved, Selected
	Dim DCId
	Dim Guid
	Dim IsGuid
	Dim AllowClaimEmails
	Dim SavedDCId 
	Dim ClaimTypeId
	Dim SavedClaimType
	
	
	If Request.Form("cboClaimType") <> "" Then
		ClaimTypeId = Split(Request.Form("cboClaimType"),",")(0)
	ElseIf Request.QueryString("typeId") <>  "" Then
		ClaimTypeId = Request.QueryString("typeId")
	Else
		ClaimTypeId = 0
	End If
	
	If Request.QueryString("guid") = "0" Or  Request.QueryString("guid") =  "" Then
		IsGuid = False
	Else
		Guid = Request.QueryString("guid")
		IsGuid = True
	End If
	
	
	
	DCId = Session("DCId")
	If Request.Form("cboDC") <> "" Then
		DCId = Split(Request.Form("cboDC"),",")(0)
	ElseIf Request.QueryString("DC")  <> "" Then
		DCId = Request.QueryString("DC")
	End If
	
	
	
	If Request.Form("cboClaimType") <> "" Then
		ClaimTypeId = Split(Request.Form("cboClaimType"),",")(0)
	ElseIf Request.QueryString("ClaimType")  <> "" Then
		ClaimTypeId = Request.QueryString("ClaimType")
	End If
	'response.write  ClaimTypeId
	SavedDCId = 0
	AllowClaimEmails = False
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If IsGuid Then
		SqlCommand = "ListWarehouseClaimConfigurations @ClaimTypeId=" & ClaimTypeId 	& ", @DCId=" & DCId 	& ", @Guid='" & Guid & "'"
		'response.write SqlCommand
		Set rsObj = ExecuteSql(SqlCommand, cnObj)
		If Not (rsObj.EOF And rsObj.BOF) Then
			SavedDCId = rsObj("DCId")
			SavedClaimType = rsObj("ClaimType")
			ClaimTypeId  = SavedClaimType 
		End If
	End If
	
	
		
		
		
%><!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta content="text/html;charset=utf-8" http-equiv="Content-Type">
	<meta content="utf-8" http-equiv="encoding">
	<title>SPAR</title>
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
	<script type="text/javascript" src="../../includes/jquery.min.js"></script>
	<script type="text/javascript" src="includes/warehouseclaimconfiguration.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
	<%
	If Not (Session("ProcEAN") = "SPARHEADOFFICE" Or Session("IsWarehouseUser")) Then %>
		<table border="0" class="pcontent">
			<tr>
				<td class="warning" align="left" style="font-size:15px" valign="top" ><b>You are not authorised to view this page</b></td>
			</tr>
		</table>
	<%
		
		Response.End
	End If %>
</head>

<form name="dcClaimOptions" method="post" onsubmit="return fOnSave();">
	
	<table border="0" class="pcontent">
		<tr>
			<td class="bheader" align="left" valign="top">Add New Claim Configuration</td>
		</tr>
		<tr>
			<td>
				<br />
			</td>
		</tr>
	</table>
	<table class="pcontent" width="50%">
		<tr>
			<td>DC</td>
			<td>		
				<select name="cboDC" id="cboDC" class="pcontent" onchange="form.submit();">
					<% If Session("DCId") = 0 Then %>				
						<option value="0,Not Selected">-- Select a DC --</option>
					<%
						End If
						
						selected = ""
						SqlCommand = "exec listDC @DC=" & Session("DCId")
						Set rsObj = ExecuteSql(SqlCommand, cnObj)
						If Not (rsObj.EOF And rsObj.BOF) Then
							While NOT rsObj.EOF
								If Request.Form("cboDC") = "" And rsObj("DCId") = SavedDCId Then
									selected = "selected"
								ElseIf rsObj("DCId") & "," & rsObj("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
								ElseIf CInt(Request.QueryString("DC")) = rsObj("DCId") Then
									selected = "selected"
								Else
									selected = ""
								End If
				%>
							<option <%=selected%> value="<%=rsObj("DCID")%>,<%=rsObj("DCcName")%>"><%=rsObj("DCcName")%></option>
					<%
								rsObj.MoveNext
							Wend
						End If
					%>
				</select>
			</td>
			
			<%
				Dim IsAllClaimTypes
				Dim IsWarehouse
				Dim IsDCVendor
				
				If CInt(Request.QueryString("ClaimType")) <> 0 then
					SavedClaimType =Request.QueryString("ClaimType") 
				end if
					
				Select Case SavedClaimType
					Case 0
						IsAllClaimTypes = "selected"
					Case 3
						IsWarehouse = "selected"
					Case 5
						IsDCVendor = "selected"
				End Select
				
				'Response.Write Request.form("cboClaimType")
				Select Case Request.form("cboClaimType")
					Case "0,All Claim Types"
						IsAllClaimTypes = "selected"
						IsWarehouse = ""
						IsDCVendor = ""
					Case "3,Warehouse"
						IsWarehouse = "selected"
						IsAllClaimTypes = ""
						IsDCVendor = ""
					Case "5,DC Vendor"
						IsDCVendor = "selected"
						IsAllClaimTypes = ""
						IsWarehouse = ""
				End Select
				
			%>
			<td><b>Claim Type:</b>
				<select name="cboClaimType" id="cboClaimType" onchange="form.submit();"  class="pcontent" >
					<option <%=IsAllClaimTypes%> value="0,All Claim Types">-- All Claim Types --</option>
					<option <%=IsWarehouse%> value="3,Warehouse">Warehouse</option>
					<option <%=IsDCVendor%> value="5,DC Vendor">DC Vendor</option>
				</select>
				
			</td>
		</tr>
		
		
	</table>
		
	<table id="WarehouseClaimConfigurationsGrid" class="pcontent" border="0" width="100%">
		
		<tr><td colspan="3"><br /><b>Claim Category</b></td></tr>
		<tr><td width="15%">&nbsp;</td><td width="25%">
		<%
				If SavedDCId = 0 Then 
					SavedDCId = Session("DCId")
				End If
				
				If Request.Form("cboDC") <> "" Then
					SqlCommand = "ListWClaimsCategories @DCId=" & Split(Request.Form("cboDC"),",")(0) &",@ClaimTypeId=" & ClaimTypeId
				Else
					SqlCommand = "ListWClaimsCategories @DCId=" & SavedDCId &",@ClaimTypeId=" & ClaimTypeId
				End If
				
				
				If IsGuid Then
					SqlCommand = SqlCommand & ", @Guid='" & Guid & "'"
				End If
				'Response.Write SqlCommand
				Set rsObj = ExecuteSql(SqlCommand, cnObj)
				If Not (rsObj.EOF And rsObj.BOF) Then
					AllowClaimEmails = rsObj("AllowClaimEmails")
					While NOT rsObj.EOF
					
						If rsObj("ClaimCategoryId") <> -1 Then %>
							<input <%=rsObj("IsChecked")%> type="checkbox" name="ClaimCategory" id="ClaimCategory" 
								onclick="fClaimCategoryClick(this);" value="<%=RTrim(rsObj("ClaimCategoryId"))%>" /><%=rsObj("ClaimCategory")%><br /><%
						End If
						
						rsObj.MoveNext
					Wend
				End If				
				%><br /></td>
				
		<td>&nbsp;</td></tr>
		<tr><td colspan="3"><b>Claim Sub Category</b></td>
		<tr>
		<td>&nbsp;</td>
			<td>
				<div id="divClaimSubCategories"></div>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr><td colspan="3"><b>Claim Reason</b></td></tr>
		<tr>
			<td>&nbsp;</td>
			<td><div id="divClaimReasons">
			</div>
			</td>
			<td>&nbsp;</td>
		</tr>	
		<tr><td colspan="3"><b>Claim Sub Reason</b></td></tr>
		<tr>
			<td>&nbsp;</td>
			<td><div id="divClaimSubReasons"><input name="chkClaimSubReasons" id="chkClaimSubReasons" value="-1" type="checkbox" onclick="fClaimSubReasonClick(this);" checked/>All Claim Sub Reasons</div>
			</td>
			<td>&nbsp;</td>
		</tr>		
		<tr>
		<td><b>Statuses Applicable</b></td>
			<td>&nbsp;</td>
			<td ><b><%If  AllowClaimEmails  Then Response.Write "E-mail addresses" Else Response.Write "E-mail addresses disabled"%></b></td>
		</tr>
		<%
				If IsGuid Then
					SqlCommand = "ListWarehouseClaimConfigStatus @Guid='" & Guid & "'," &" @ClaimTypeId=" & ClaimTypeId
				Else
					SqlCommand = "ListWarehouseClaimConfigStatus " &" @ClaimTypeId=" & ClaimTypeId
				End If
				'Response.Write SqlCommand
				Dim ShowManagementAuthorisations
				ShowManagementAuthorisations = False
				
				Set rsObj = ExecuteSql(SqlCommand, cnObj)
				If Not (rsObj.EOF And rsObj.BOF) Then 
					While NOT rsObj.EOF
						If rsObj("Id") = 24 And rsObj("IsChecked") = "checked" Then
							ShowManagementAuthorisations = True
						End If
						
						'If rsObj("Id") = 28 And rsObj("IsChecked") = "checked" Then
					'		rsObj("IsChecked")
				'		End If
						
						
					
					%>
						<tr>
							<td>&nbsp;</td>
							<td>
								<% If rsObj("IsReadOnly") Then %> 
									<input type="checkbox" disabled name="chkStatusApplicable" id="chkStatusApplicable" value="<%=rsObj("Id")%>" <%=rsObj("IsChecked")%> /><%=rsObj("Value")%>
								
								<% Else %>
									
									<input type="checkbox" onclick="fStatusApplicableOnClick(this);" name="chkStatusApplicable" id="chkStatusApplicable" value="<%=rsObj("Id")%>" <%=rsObj("IsChecked")%> /><%=rsObj("Value")%>
								<% End If %>
							</td>
							
							<td>
							<% If AllowClaimEmails And rsObj("Id") <> 24 Then 
									Dim EmailAddressTitle, IsReadOnly
									EmailAddressTitle = ""
									IsReadOnly = ""
									
									Select Case CInt(rsObj("Id"))
										Case 4 	
											EmailAddressTitle = "Acknowledger's E-mail address"
											IsReadOnly = "readonly"
										Case 19 
											EmailAddressTitle = "Buyer's E-mail address"
										Case 23	
											EmailAddressTitle = "Payment Controller's E-mail address"
										Case 25 
											EmailAddressTitle = "Category Manager's E-mail address"
										Case 8 
											EmailAddressTitle = "E-mail address of recipient of store rejection Disputes"
										Case 9
											EmailAddressTitle = "E-mail address of recipient of store resolution disputes"
										Case 28
											EmailAddressTitle = "Supplier Email On Database will be used"
											IsReadOnly = "readonly"
									End Select
									
									Dim IsHidden
									If rsObj("IsChecked") = ""   Then 
										IsHidden = "hidden"
										
									Else
										IsHidden = ""
									End If
									
									If rsObj("Id") <> 28 then
										
									
									
							%>
							
								<input <%=IsReadOnly%> type="text" <%=IsHidden%> title="<%=EmailAddressTitle%>" <%If rsObj("Id") =4  Then Response.Write "style='color: grey'" End If%> name="txtStatusApplicableEmail_<%=rsObj("Id")%>" id="txtStatusApplicableEmail_<%=rsObj("Id")%>" size="60" class="pcontent" value="<%=rsObj("EmailAddresses")%>"/>&nbsp;&nbsp;&nbsp;
								<label id="lblStatusApplicableEmail_<%=rsObj("Id")%>" <%=IsHidden%> ><%=EmailAddressTitle%></label>
								
							<%
								end if
							%>
							</td>
								
							<% 
							
							
							   Else %> 
							   <br
								&nbsp;
							<% End If %>
							
					</tr><%
						rsObj.MoveNext
					Wend
				End If%>
			
			<% If False Then %>
				<tr><td><br /><b>Management Authorisations:</b></td></tr>
				<tr>
					<td><br />
						<b>Claim levels</b><br />
						<input type="button" class="button" onclick="fAddClaimLevel();" value="Add level"/>
					</td>
				</tr>
			<% End If %>
	</table>
	<table>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">
				<input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/>
				<input class="button" name="Action" style="width: 98px" type="submit" value="Save"/>
			</td>
			
			
		</tr>
		<tr>
			<td colspan="4" id="savedResult" class="warning"><% 	
				If Request.QueryString("s") Then 
						Response.Write "<b>Config Saved Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
				End If%></td>
		</tr>
	</table><%
		cnObj.Close
		Set cnObj = Nothing%>
	
	<input type="hidden" id="token" value="<%=Guid%>" readonly />
	<input type="hidden" id="allowClaimEmails" value="<%=AllowClaimEmails%>" readonly />
	<input type="hidden" id="showManagementAuthorisations" value="<%=ShowManagementAuthorisations%>" readonly />
	<input type="hidden" id="rangeCount" value="0" readonly />
</form>

