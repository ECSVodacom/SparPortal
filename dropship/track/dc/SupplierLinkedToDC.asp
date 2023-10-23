<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>SPAR</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
	function DoSubmit()
	{
		chosen = ""
		len = document.dcClaimOptions.PrintOption.length

		for (i = 0; i < len ; i++) {
			if (document.dcClaimOptions.PrintOption[i].checked) {
				chosen = document.dcClaimOptions.PrintOption[i].value;
			}
		}
		window.open("<%=const_app_ApplicationRoot%>/../dropship/suppliers/default.aspx?DCId=" + document.getElementById("DCId").value + "&PrintOption=" + chosen + "&ExcludeInactiveSuppliers=" + document.getElementById("ExcludeInactiveSuppliers").checked , "Report", "width=800,height=500,toolbar=1,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1");
		
	}
</script>
</head>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/../layout/css/classes.css">
<form name="dcClaimOptions" method="post">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">Suppliers linked to DC</td>
        </tr>
    </table>
    <table class="pcontent" border="0" width="70%">
        <tr>&nbsp;</tr>
		<tr>
			<td>DC</td>
			<td>
				<select id="DCId" name="DCId">
					<%
							Dim cnObj, rsObj, SqlSelect
							Set cnObj = CreateObject("ADODB.Connection")
							cnObj.Open const_db_ConnectionString
							
							
							If (Session("ProcEAN") = "GATEWAYCALLCEN" or Session("ProcEAN") = "SPARHEADOFFICE") Then
								SqlSelect = "GetDcById @Id=0"
							Else
								SqlSelect = "GetDcById @Id=" & Session("DCID")
							End If
								
							'response.write SqlSelect
							'response.end
							
							Set rsObj = ExecuteSql(SqlSelect, cnObj)   
							If Not (rsObj.EOF and rsObj.BOF) Then
								While Not rsObj.EOF
									Response.Write("<option value='" & rsObj("DCID") & "'>" & rsObj("DCcName") & "</option>")

									rsObj.MoveNext
								Wend
							End if
							rsObj.Close
							Set rsObj = Nothing		
					%>
				</select>
			</td>
			<td></td>
		</tr>
		<tr>
			<td><input type="radio" name="PrintOption" value="AllSuppliers" checked="true"/></td>
			<td>Print all suppliers</td>
			<td></td>
		</tr>
		<tr>
			<td><input type="radio" name="PrintOption" value="PrintOnlySuppliersEnabledForCaptureClaimForSupplier"/></td>
			<td>Print only suppliers enabled for Capture Claim for Supplier</td>
			
			<td></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</td>
		<tr>
			<td><input id="ExcludeInactiveSuppliers" name="ExcludeInactiveSuppliers" type="checkbox" checked="true"></input></td>
			<td>Exclude inactive suppliers</td>
			<td></td>
		</td>
        <tr>
            <td colspan="2">&nbsp</td>
        </tr>
        <tr>
            <td>&nbsp</td>
            <td><input class="button" target="_blank" type="button" onclick="DoSubmit();" style="width: 98px" value="Report"/></td>
			
        </tr>
    </table>
    
    
</form>

