<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincookie.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
	Dim WebOrderNotificationEmailAddres
	Dim CatalogRequestEmailAddres
	
	Dim SqlUpdate
	Dim cnObj, rsObj, SqlSelect
	Dim DCId
	Dim selected
	Dim Recordset
	Dim IsSaved
	Dim SqlCommand
	
	If Request.Form("cboDC") = "" Then
		DCId = Session("DCId")
	Else
		DCId = Split(Request.Form ("cboDC"),",")(0)
	End If
	
	Set cnObj = Server.CreateObject("ADODB.Connection")
	cnObj.Open const_db_ConnectionString
	If (Trim(Request.Form("Action")) = "Save") And DCId <> -1 Then
		ExecuteSql "UpdateWebOrderConfiguration @WebOrderNotificationEmailAddres='" & Request.Form("txtWebOrderNotificationEmailAddres") & "', @CatalogRequestEmailAddres='" & Request.Form("txtCatalogRequestEmailAddres") & "',@DCId=" & DCId, cnObj
		
		IsSaved = True
	End If
	
	' Read the values from database
	Set RecordSet = ExecuteSql("GetDcById @Id=" & DCId, cnObj) 
	If Not (RecordSet.BOF And RecordSet.EOF) Then
		WebOrderNotificationEmailAddres = RecordSet("WebOrderNotification")
		CatalogRequestEmailAddres = RecordSet("WebCatalogRequestNotification")
	End If
		
%>
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
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script type="text/javascript">
	function fValidateEmail(emailList) 
	{  
		if (emailList == "")
			return true;
		
		var emails = emailList.split(";");
		var valid = true;
		var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

		for (var i = 0; i < emails.length; i++) {
			 if( emails[i] == "" || ! regex.test(emails[i])){
				 valid = false;
			 }
		}
		
		return valid;
	}
			
	function OnSave(obj)
	{
		if (!fValidateEmail(obj.txtWebOrderNotificationEmailAddres.value))
		{
			alert("Invalid email address");
			obj.txtWebOrderNotificationEmailAddres.focus();
			return false;
		}

		if (!fValidateEmail(obj.txtCatalogRequestEmailAddres.value))
		{
			alert("Invalid email address");
			obj.txtCatalogRequestEmailAddres.focus();
			return false;
		}

		
		if (document.WebOrderingConfig.cboDC.value == '-1,Not Selected')
		{
			alert('Please select a DC');
		
			return false;
		}
	
		
		return true;
	}
</script>
<body>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="WebOrderingConfig" method="post" action="WebOrderingConfig.asp" onsubmit="return OnSave(this);">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">Web Ordering Configuration</td>
        </tr>
		<tr>
			<td>
				&nbsp;
			</td>
		</tr>
    </table>
    <table class="pcontent" border="0" width="100%">
		<tr>
			<td>DC</td>
			<td>		
				<select name="cboDC" id="cboDC" class="pcontent" onchange="form.submit();">
					<% If Session("DCId") = 0 Then %><option value="-1,Not Selected">-- Select a DC --</option><% End If

						selected = ""
						SqlCommand = "listDC @DC=" & Session("DCId")
						Set RecordSet =  ExecuteSql(SqlCommand, cnObj)   
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("DCId") & "," & RecordSet("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
								Else 	
									selected = ""
								End If %> <option <%=selected%> value="<%=RecordSet("DCID")%>,<%=RecordSet("DCcName")%>"><%=RecordSet("DCcName")%></option> <%
								RecordSet.MoveNext
							Wend
						End If %>
				</select>
			</td>
			<td><br/></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="pcontent" colspan="2">Seperate e-mail addresses with a semicolon (;), if more than one e-mail address is added.</td>
		</tr>
		<tr>
			<td class="pcontent"><b>Order Notification E-mail Addresses:</b></td>
			<td><input type="text" width="100%" name="txtWebOrderNotificationEmailAddres" id="txtWebOrderNotificationEmailAddres" value="<%=WebOrderNotificationEmailAddres%>" size="50" maxlength="8000" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent"><b>Catalog Request E-mail Addresses:</b></td>
			<td><input type="text" width="100%" name="txtCatalogRequestEmailAddres" id="txtCatalogRequestEmailAddres" value="<%=CatalogRequestEmailAddres%>" size="50" maxlength="8000" class="pcontent"></td>
		</tr>
		<tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
	<table>
		<tr>
			<td><input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/></td>
            <td><input class="button" type="submit" name="Action" style="width: 98px" value="Save"/></td>
        </tr>
		<tr>
			<td colspan="3" class="warning"> <% 	
				If IsSaved Then 
					Response.Write "<b>Updated Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
				End If
			%> </td>
		</tr>
	</table> <%
	cnObj.Close
	Set cnObj = Nothing %>
</form>
</body>

