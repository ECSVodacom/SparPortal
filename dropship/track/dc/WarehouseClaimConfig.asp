<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!DOCTYPE html>
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
</script>
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script type="text/javascript" src="../../includes/jquery.min.js"></script>
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
	End If

	LoginCheck("WarehouseClaimConfig.asp")
	
	
	Function FormatNumber(input)
		Dim LoopCounter
		FormatNumber = ""
		For LoopCounter =  1 To 4 - Len(input)
			FormatNumber = "0" & FormatNumber
		Next
		
		FormatNumber = FormatNumber  & input
	End Function
			
			
	Dim SqlCommand, cnObj, rsObj
	Dim IsSaved, Selected
	Dim DCId
	Dim Guid
	Dim ClaimTypeId
	
	If Request.Form("cboClaimType") <> "" Then
		ClaimTypeId = Split(Request.Form("cboClaimType"),",")(0)
	Else
		ClaimTypeId = 0
	End If
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	
	If Request.Form("Action") = "Delete" Then
		Dim ConfigurationItem
		For Each ConfigurationItem In Split(Request.Form("chkConfigurationId"),",")
			SqlCommand = "MaintainWClaimConfiguration @Guid='" & Trim(Replace(ConfigurationItem,"'","''")) & "', @DoAction=1"
			
			ExecuteSql SqlCommand, cnObj
		Next
	End If
	

	
		
%>

<form name="WarehouseClaimConfig" method="post" action="WarehouseClaimConfig.asp" >
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">Warehouse Claim Configuration</td>
        </tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
    </table>
    <table class="pcontent" border="0" width="45%">
		<tr>
			
			<td  ><b>DC:</b>
				<select name="cboDC" id="cboDC" onchange="form.submit();" class="pcontent"><% If Session("DCId") = 0 Then %><option value="0,Not Selected">-- All DC's --</option><%End If
					Selected = ""
					
					DCId = Session("DCId")
					If Request.Form("cboDC") <> "" Then
						DCId = Split(Request.Form("cboDC"),",")(0)
					End If
					
					
					Set rsObj = ExecuteSql("listDC @DC=" & Session("DCId"), cnObj) 
					
					If Not (rsObj.EOF And rsObj.BOF) Then
						While NOT rsObj.EOF
							If rsObj("DCId") & "," & rsObj("DCcName") = Request.Form("cboDC") Then
								Selected = "selected"
							Else 	
								Selected = ""
							End If%><option <%=Selected%> value="<%=rsObj("DCID")%>,<%=rsObj("DCcName")%>"><%=rsObj("DCcName")%></option><%
							rsObj.MoveNext
						Wend
					End If
					rsObj.Close
					
				%>
				</select>
				
			</td>
			<%
				Dim IsAllClaimTypes
				Dim IsWarehouse
				Dim IsDCVendor

				Select Case Request.form("cboClaimType")
					Case "0,All Claim Types"
						IsAllClaimTypes = "selected"
					Case "3,Warehouse"
						IsWarehouse = "selected"
					Case "5,DC Vendor"
						IsDCVendor = "selected"
				End Select
				
			%>
			<td><b>Claim Type:</b>&nbsp;
				<select name="cboClaimType" id="cboClaimType" onchange="form.submit();"  class="pcontent" >
					<option <%=IsAllClaimTypes%> value="0,All Claim Types">-- All Claim Types --</option>
					<option <%=IsWarehouse%> value="3,Warehouse">Warehouse</option>
					<option <%=IsDCVendor%> value="5,DC Vendor">DC Vendor</option>
				</select>
				
				
			</td>

	<% 
		If ClaimTypeId=0 Or DCId=0 Then 
		Else
	%>
	<td>
		<p  class="pcontent"><b>Claim&nbsp;Category:</b>
		<select style="width:200px"  class="pcontent" name="cboWarehouseClaimCategories" onchange="form.submit()">
			<option value="0">-- Select Claim Category --</option>
			<%
				
				Dim SelectedCategoryId,IsSelected,ClaimCategoryID

				ClaimCategoryID = request.form("cboWarehouseClaimCategories")
				
				Set rsObj = ExecuteSql("ListClaimsCategories @ClaimTypeId="& ClaimTypeID &", @ClaimCategoryType=0, @DCId=" & DCId, cnObj)    
				If Not (rsObj.BOF And rsObj.EOF) Then
					While Not rsObj.EOF
						If Request.Form("cboWarehouseClaimCategories") = CStr(rsObj("ClaimCategoryId")) Then
							IsSelected = "selected"
							SelectedCategoryId = rsObj("ClaimCategoryId")
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
		</select>
	</td>	
	<%
		End If
	%>

			
			
			
			
		</tr>
		
	</table>
	

	<table>
		<tr>
			<td><input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/>
            <input class="button" type="submit" name="Action" style="width: 98px" value="New" onclick="window.open('WarehouseClaimConfigAdd.asp?guid=0&DC=<%=DCId%>&ClaimType=<%=ClaimTypeId%>');"/>
			<input class="button" type="submit" name="Action" style="width: 98px" value="Delete" onclick="return confirm('Are you sure you would like to remove the selected configuration(s)\r\nOK to confirm');"/>
			<input class="button" type="submit" name="Action" style="width: 98px" value="Refresh" name="btnRefresh" id="btnRefresh"/></td>
        </tr>
		<tr>
			<td colspan="3" class="warning"></td>
		</tr>
    </table>
	<table border="1" class="pcontent" width="100%">
		<%	
			Dim rsClaimLevels, FirstClaimLevel, RowSpan
			
			If SelectedCategoryId = "" then SelectedCategoryId = 0
				
			
			Set rsObj = ExecuteSql("ListWarehouseClaimConfigurations @DCId=" & DCId & ",@ClaimTypeId=" & ClaimTypeId & ",@CategoryId=" & SelectedCategoryId, cnObj)   
			
			
			If Not (rsObj.EOF And rsObj.BOF) Then
			%>	
				<col width="1%">
				<col width="5%">
				<col width="5%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="20%">
				<col width="5%">
				<col width="20%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center"><b>Select</b></td>
					<td class="tdcontent" align="center"><b>DC</b></td>
					<td class="tdcontent" align="center"><b>Claim Type</b></td>
					<td class="tdcontent" align="center"><b>Category</b></td>
					<td class="tdcontent" align="center"><b>Sub Category</b></td>
					<td class="tdcontent" align="center"><b>Reason</b></td>
					<td class="tdcontent" align="center"><b>Sub Reason</b></td>
					<td class="tdcontent" align="center"><b>Status</b></td>
					<td class="tdcontent" align="center"><b>Range</b></td>
					<td class="tdcontent" align="center"><b>Email Address</b></td>
				</tr><%
				While NOT rsObj.EOF
					Guid = Trim(Mid(rsObj("Guid"),2,Len(rsObj("Guid"))-2))
					
					
				%>	<tr>
						<td width="3%" class="pcontent" align="center"><input type="checkbox" name="chkConfigurationId" value="<%=Guid%>" />&nbsp;&nbsp;<a href="WarehouseClaimConfigAdd.asp?guid=<%=Guid%>" 
							target="_blank"><%=FormatNumber(rsObj("WarehouseClaimConfigurationId"))%></a></td>
						<td class="pcontent" width="5%" align="center"><%=Replace(rsObj("DCcName"),"SPAR ","")%></td>
						<td class="pcontent" width="5%" align="center"><%=Replace(rsObj("ClaimType")," Claim","")%></td>
						<td class="pcontent" align="center"><%=rsObj("Category")%></td>
						<td class="pcontent" align="center"><%=rsObj("SubCategory")%></td>
						<td class="pcontent" align="center"><%=rsObj("Reason")%></td>
						<td class="pcontent" align="center"><%=rsObj("SubReason")%></td>
						<td class="pcontent" align="center"><%=rsObj("StatusesApplicable")%><%=rsObj("RangeStatusesApplicable")%></td>
						<td class="pcontent" align="center" valign="bottom"><%=rsObj("Range")%></td>
						<td class="pcontent" align="center"><%=rsObj("EmailAddress")%><%=rsObj("RangeEmailAddress")%></td>
					</tr>
					 
					<%
					rsObj.MoveNext
				Wend
			Else%>
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center" colspan="10">
						<b>No Configurations</b>
					</td>
				</tr><%
			End If
			rsObj.Close%>
	</table>
</form>
<%
	Set rsObj = Nothing
	cnObj.Close
	Set cnObj = Nothing
%>