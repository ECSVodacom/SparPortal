<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	If Session("IsLoggedIn") <> 1 Then
		Session("IsLoggedIn") = 0
	End If
%>
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->


	function fValidate(obj)
	{
		if (obj.btnIsSaveClick.value != 'true')
		{
		
			if (obj.cboDC.value == -1) {
				alert('No DC selected');
				obj.cboDC.focus();
				return false;
			}
			
			if (obj.cboWarehouseClaimCategories.value == -1)
			{
				alert('No claim category selected');
				obj.cboWarehouseClaimCategories.focus();
				return false;
			}
			
	
		}
		return true;
	}
	
	function fDefault(obj)
	{
		if ('<%=Request.Form("firstLoad")%>' != '1')
			WarehouseClaimCategoryManagement.submit();
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
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<body>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Warehouse Claim Category Management</td>
	</tr>
</table>
<%
	Dim cnObj, rsObj
	Dim IsSelected
	Dim SubCategoryIds
	Dim AssignedIds
	Dim UnAssignedIds
	Dim ClaimCategoryId
	Dim Message
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	Dim firstLoad 
	
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		firstLoad = 1
	Else
		firstLoad = 0
	End If
	
	
	If Request.Form("cboWarehouseClaimCategories") <> "" Then 
		ClaimCategoryId = CInt(Request.Form("cboWarehouseClaimCategories"))
	Else
		ClaimCategoryId  = 0
	End If
	
	
	Dim ButtonClicked
	ButtonClicked = Request.Form("btnClicked")
	
	Dim DCId
	DCId = Session("DCId")
	If Request.Form("cboDC") <> "" Then
		DCId = Split(Request.Form("cboDC"),",")(0)
		'Response.Write Request.Form("cboDC")
	End If
	
	If Request.Form("btnSave") = "Save" Then
		Set rsObj = ExecuteSql("MaintainSubCategories @Action=3, @ClaimSubCategoryName='" & Replace(Request.Form("txtSubCategory"),"'","''") & "'", cnObj)
		If Not (rsObj.BOF And rsObj.EOF) Then
			Message = rsObj("Result")
		Else
			Message = "Unknow error occured"
		End If
	Else
		Dim SubCategoryIdsToUnAssign, SubCategoryIdsToAssign
		SubCategoryIdsToUnAssign = Split(Request.Form("lstAssign"),",")
		SubCategoryIdsToAssign = Split(Request.Form("lstUnassign"),",")
		
		Dim  SubCategoryId
		SubCategoryId = ""
		If Request.Form("btnMoveRight") = ">>" Then
			For Each SubCategoryId In SubCategoryIdsToAssign
				Set rsObj = ExecuteSql("MaintainSubCategories @Action=1, @ClaimCategoryId=" & ClaimCategoryId & ", @SubCategoryId=" & SubCategoryId & ",@DCId=" & DCId, cnObj)
			Next
		ElseIf Request.Form("btnMoveLeft") = "<<" Then
			For Each SubCategoryId In SubCategoryIdsToUnAssign
				Set rsObj = ExecuteSql("MaintainSubCategories @Action=2, @ClaimCategoryId=" & ClaimCategoryId & ", @SubCategoryId=" & SubCategoryId & ",@DCId=" & DCId, cnObj)
			Next
		End If
	End If
		
		
	
	
%>
<form name="WarehouseClaimCategoryManagement" id="WarehouseClaimCategoryManagement" method="post"  onsubmit="return fValidate(this);">
<body onload="fDefault();">
	<table border="0" cellpadding="2" cellspacing="0" bordercolor="#333366" width="70%">

	<tr><td><p class="pcontent">DC</td><td>
	<select style="width:200px" name="cboDC" id="cboDC" class="pcontent" onchange="form.submit()">
		<% 
			
			Set rsObj = ExecuteSql("listDC @DC="  & Session("DCId"), cnObj)
			If Not (rsObj.EOF And rsObj.BOF) Then
				While NOT rsObj.EOF
					If rsObj("DCId") & "," & rsObj("DCcName") = Request.Form("cboDC") Then
						IsSelected = "selected"
					Else 	
						IsSelected = ""
					End If
		%>
				<option <%=IsSelected%> value="<%=rsObj("DCID")%>,<%=rsObj("DCcName")%>"><%=rsObj("DCcName")%></option>
		<%
					rsObj.MoveNext
				Wend
			End If
			rsObj.Close
			Set rsObj = Nothing 
		%>
	</select></td></tr>
	<%
				Dim IsAllClaimTypes
				Dim IsWarehouse
				Dim IsDCVendor
				Dim ClaimTypeId
				Dim previousClaimType
				
				If Request.Form("previousClaimType") <> Request.form("cboClaimType") Then
					ClaimCategoryId = 0
					previousClaimType = Request.form("cboClaimType")
				Else
					previousClaimType = Request.Form("previousClaimType")
				End If
				
				Select Case Request.form("cboClaimType")
					Case "0,All Claim Types"
						ClaimTypeId = 0
						IsAllClaimTypes = "selected"
					Case "3,Warehouse"
						IsWarehouse = "selected"
						ClaimTypeId = 3
					Case "5,DC Vendor"
						IsDCVendor = "selected"
						ClaimTypeId = 5
					Case Else
						ClaimTypeId = 0
				End Select
				
			%>
	<tr><td><p   class="pcontent">Claim Type</td><td>
				<select style="width:200px"  name="cboClaimType" id="cboClaimType" onchange="form.submit();"  class="pcontent" >
					<option <%=IsAllClaimTypes%> value="0,All Claim Types">-- All Claim Types --</option>
					<option <%=IsWarehouse%> value="3,Warehouse">Warehouse</option>
					<option <%=IsDCVendor%> value="5,DC Vendor">DC Vendor</option>
				</select>
				
			</td>
			</tr>


	<tr><td><p  class="pcontent">Claim Category</td><td>
	<select style="width:200px"  class="pcontent" name="cboWarehouseClaimCategories" onchange="form.submit()">
		<option value="0">-- Select Claim Category --</option>
		<%
			
			Dim SelectedId
	
			
			
			Set rsObj = ExecuteSql("ListClaimsCategories @ClaimTypeId="& ClaimTypeID &", @ClaimCategoryType=0, @DCId=" & DCId, cnObj) 
			If Not (rsObj.BOF And rsObj.EOF) Then
				While Not rsObj.EOF
					If Request.Form("cboWarehouseClaimCategories") = CStr(rsObj("ClaimCategoryId")) Then
						IsSelected = "selected"
						SelectedId = rsObj("ClaimCategoryId")
					Else
						IsSelected = ""
					End If 
					%><option <%=IsSelected%> value="<%=rsObj("ClaimCategoryId")%>"><%=rsObj("ClaimCategory")%></option><%
				
					rsObj.MoveNext
				Wend
			Else 
					%><option value="-1">-- No claim categories --</option><%
			End If
			rsObj.Close
			Set rsObj = Nothing
			
		%>
	</select></td></tr>
	
	
	
	
	<tr>
		<td class="warning" colspan="2"><b><%=Message%></b></td>
	</tr>
	
	<table border="0" cellpadding="2" cellspacing="0" bordercolor="#333366" width="70%">
		<tr>
		<td><br>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#333366" width="100%">
				<tr>
					<td class="sheader">Link Sub-Categories</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellspacing="2" cellpadding="2" align="center">
							<tr>
								<td class="pcontent" align="center"><b>Unassigned Sub-Categories</b></td>
								<td>&nbsp;</td>
								<td class="pcontent" align="center"><b>Assigned Sub-Categories</b></td>
							</tr>
							<tr>
								<td>
									<select multiple size="10" name="lstUnassign" id="lstUnassign" style="width:200" class="pcontent"><%
										Set rsObj = ExecuteSql("ListUnAssignedSubCategories @ClaimTypeId=" & ClaimTypeId & ", @ClaimCategoryId=" & ClaimCategoryId & ",@DCId=" & DCId, cnObj)
										
										'response.write "ListUnAssignedSubCategories @ClaimTypeId=" & ClaimTypeId & ", @ClaimCategoryId=" & ClaimCategoryId & ",@DCId=" & DCId
										While Not rsObj.EOF%><option value="<%=rsObj("SubCategoryId")%>"><%=rsObj("ClaimSubCategoryName")%></option><%					
											rsObj.MoveNext
										Wend
										rsObj.Close
										Set rsObj = Nothing%></select>
								</td>
								<td align="center" valign="middle">
									<input type="submit" value=">>" class="button" id="btnMoveRight" name="btnMoveRight"><br><br>
									<input type="submit" value="<<" class="button" id="btnMoveLeft" name="btnMoveLeft">
								</td>
								
								<td>
									<select multiple size="10" name="lstAssign" id="lstAssign" style="width:200" class="pcontent">
								<%
										Dim txtSupplierID
										
										Set rsObj =  ExecuteSql("ListAssignedSubCategories @ClaimCategoryId=" & ClaimCategoryId & ",@DCId=" & DCId, cnObj) 
												
										While Not rsObj.EOF %>
									<option value="<%=rsObj("SubCategoryId")%>"><%=rsObj("ClaimSubCategoryName")%></option><%
											rsObj.MoveNext
										Wend
										rsObj.Close
										Set rsObj = Nothing
						%>				
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br />
		</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="0" bordercolor="#333366" width="70%">
	<tr>
		<td class="sheader" colspan="2">Add new Sub-Category</td>
	</tr>
	<tr>
		<td width="30%" class="pcontent">
			<input class="pcontent" type="text" placeholder="Sub-Category" id="txtSubCategory" name="txtSubCategory" size="50%"></input>
			<input class="button"  type="submit" id="btnSave" name="btnSave" value="Save" onclick="btnIsSaveClick.value='true'" />
			<input class="pcontent"  type="hidden" id="btnIsSaveClick" name="btnIsSaveClick" value="" readonly />
			<input type="hidden" value="<%=firstLoad%>" id="firstLoad" name="firstLoad" />
			<input type="hidden" value="<%=previousClaimType%>" id="previousClaimType" name="previousClaimType" />
			<input type="button" align="center" name="btnCloseWindow" id="btnCloseWindow" value="Close Window" class="button" onclick="window.open('close.html', '_self');">
		</td>
	</tr>
	
</table>
</br>

</body>
</form>
<%
	cnObj.Close
	Set cnObj = Nothing
	Set rsObj = Nothing
%>
<!--#include file="../layout/end.asp"-->
