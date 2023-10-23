<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<%
	 Function isEmailValid(email) 
		Dim regEx
        Set regEx = New RegExp 
        regEx.Pattern = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w{2,}$" 
        isEmailValid = regEx.Test(trim(email)) 
    End Function 
	
	
	Dim IsOrderEmailDisabled
	Function IsSelected(a,b)
		If a = b Then 
			Response.Write "selected" 
		
		End If
	End Function
	
	LoginCheck("OrderConfigurations.asp")
	
	Dim SqlCommand, RecordSet, SqlConnection, Selected
	Dim SupplierEan
	Dim DCId, SupplierId
	Dim Id
	Dim Message
	Dim VendorIds
	Dim idx 
	Dim VendorIdsArray
	Dim StoreOrderMethod
	Dim SupplierOrderMethod
	Dim EmailAddress
	Dim IsSaved
	Dim SupplierOrderMethodReadOnly
	Dim PreviousSelectedDCId
	
	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	
	PreviousSelectedDCId = Request.Form("PreviousSelectedDCId")
	If Request.Form("cboDC") <> "" Then
		DCId = Split(Request.Form("cboDC"),",")(0)
	Else
		DCId = Session("DCId")
		
	End if
	
	If Request.Form("cboSupplier") <> "" Then
		SupplierId = Split(Request.Form("cboSupplier"),",")(0)
	Else 
		If Session("UserType") = 1 OR Session("UserType") = 4 Then
			SupplierId = Session("ProcID")
		Else
			SupplierId = -100
		End If
	
	End If
	
	If Request.Form("cboSupplier") <> "" Then
		Set RecordSet = ExecuteSql("GetSupplierById @Id="&SupplierId, SqlConnection)    
		If Not (RecordSet.EOF And RecordSet.BOF) Then
			SupplierEan = RecordSet("SPcEANNumber")
		End If
		RecordSet.Close
	End If
	
	
	
	
	If Request.Form("Action") = "Save" Then
		Dim VendorId, DoUpdateVendor, emailCount
		DoUpdateVendor = True
		If Request.Form("VendorIds") <> "" Then
			VendorIdsArray = Split(Request.Form("VendorIds"),",")
			
			For idx = 0 To UBound(VendorIdsArray) 
				VendorId = VendorIdsArray(idx)

				'If Request.Form("txtOrderEmailAddress_" & VendorId) <> "" Then
					Dim emailsArray
					emailsArray = Split(Request.Form("txtOrderEmailAddress_" & VendorId),";")
					For emailCount = 0 To UBound(emailsArray)
						If Not isEmailValid(emailsArray(emailCount)) Then
							Message = Message & "E-mail address """ & emailsArray(emailCount) & """ not a valid e-mail address<br />" 
							
							DoUpdateVendor = False
						Else
							DoUpdateVendor = True
						End If
						
					Next
				'End If
				
				'If Not isEmailValid(Request.Form("txtOrderEmailAddress_" & VendorId)) And Request.Form("txtOrderEmailAddress_" & VendorId) <> "" Then
				'	Message = Message & "E-mail address """ & Request.Form("txtOrderEmailAddress_" & VendorId) & """ not a valid e-mail address<br />" 
				'Else
				If DoUpdateVendor Then
					SqlCommand = "UpdateDcOrderConfiguration @Id=" & VendorId _
						& ", @SupplierOrderMethod='" & Request.Form("cboSupplierOrderMethod_" & VendorId) _
						& "', @OrderEmailAddress='" & Request.Form("txtOrderEmailAddress_" & VendorId) _
						& "'"
					'Response.Write SqlCommand
					
					Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)
					If RecordSet("Message") <> "" Then
						Message = Message & RecordSet("Message") & "<br />"
					End If
				End If
			Next 			
			Set RecordSet = Nothing
		End If
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
	function validateEmail(email) 
	{  
		var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/  
		return email.match(regEx) 
	}
	
	function OnSave()
	{
		var vendorIds =  document.OrderConfiguration.elements['VendorIds'].value.split(',');
		for (var idx = 0; idx < vendorIds.length; idx++)
		{
			if (document.OrderConfiguration.elements['txtOrderEmailAddress_' + vendorIds[idx]] != null)
			{
				var email = document.OrderConfiguration.elements['txtOrderEmailAddress_' + vendorIds[idx]].value;
				var supplierOrderMethod = document.OrderConfiguration.elements['cboSupplierOrderMethod_' + vendorIds[idx]].value;
				
				if (supplierOrderMethod == "E-mail") 
				{
					var emailArray = email.split(';');

					for (var emailIdx = 0; emailIdx < emailArray.length; emailIdx++)
					{
						if (!validateEmail(emailArray[emailIdx]))
						{
							alert("Invalid e-mail. A valid email address is required when supplier order method is email");
							document.OrderConfiguration.elements['txtOrderEmailAddress_' + vendorIds[idx]].focus();
						};
					}
				}
			}
		}
		
		return true;
	}
	
	/*function emailtoggle(obj)
	{
		var id = obj.id.split('_')[1];
		if (obj.value == "EDI")
			document.OrderConfiguration.elements['txtOrderEmailAddress_' + id].disabled = true;
		else
			document.OrderConfiguration.elements['txtOrderEmailAddress_' + id].disabled = false;
	}*/
	
</script>
<script type="text/javascript" src="../../includes/jquery.min.js"></script>
<% If  Session("UserName") = UCase("GATEWAYCALLCEN") OR Session("UserName") = UCase("SPARHEADOFFICE") Then%>
<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#cboDC").change(function(){
		$.getJSON("../../includes/JQueryDataSetSuppliers.asp",{id: $(this).val()}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {
				if  (j[i].optionValue != -1)
					options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + ',' + j[i].optionVendorCode + '">' + j[i].optionDisplay + '</option>'
				else
					options += '<option value="-1,SelectSupplier,-1">-- Please Select --</option>'
					
			
			}
			$('#cboSupplier').html(options);
			$('#cboSupplier').val("-1,SelectSupplier,-1");
			//$('#cboSupplier option:first').attr('selected', 'selected');
			$('#cboSupplier').change();
		})
	})	
});

</script>
<% End If %>
<script type="text/javascript" charset="utf-8">
$(function(){
	$("select#cboSupplier").change(function(){
		$.getJSON("../../includes/JQueryDataSetSupplierInfo.asp",{id: $(this).val()}, function(j){
			var options = '';
			
			for (var i = 0; i < j.length; i++) {		
					options += '<option value="' + j[i].optionValue + ',' + j[i].optionDisplay + ',' + j[i].optionVendorCode + '">' + j[i].optionDisplay + '</option>'
			}
			$('#cboSupplier').html(options);
			$('#cboSupplier option:first').attr('selected', 'selected');
		})
	})	
});

</script>
<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
<form name="OrderConfiguration" method="post" action="OrderConfigurations.asp" onsubmit="return OnSave();">
    <table border="0" class="pcontent">
        <tr>
            <td class="bheader" align="left" valign="top">DC ORDER CONFIGURATION</td>
        </tr>
		<tr>
			<td>
				
			</td>
		</tr>
    </table>
    <table class="pcontent" border="0" width="100%">
		<col width="50">
		<col width="400">
		<col width="100">
		<tr>
			<td><b>DC:</b></td>
			<td>		
				<select name="cboDC" id="cboDC" class="pcontent">
					<% If Session("DCId") = 0 Then %>				
						<option value="-1,Not Selected">-- All DC's --</option>
					<%
						End If
						
						selected = ""
						SqlCommand = "listDC @DC="  & Session("DCId")
						
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If RecordSet("DCId") & "," & RecordSet("DCcName") = Request.Form("cboDC") Then
									selected = "selected"
								Else 	
									selected = ""
								End If
					%>
							<option <%=selected%> value="<%=RecordSet("DCID")%>,<%=RecordSet("DCcName")%>"><%=RecordSet("DCcName")%></option>
					<%
								RecordSet.MoveNext
							Wend
						End If
						RecordSet.Close
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td><b>Supplier:</b></td>
			<td> 
				<select name="cboSupplier" id="cboSupplier" class="pcontent" onchange="form.submit()"> <%
					
						If Session("UserType") <> 1 And Session("UserType") <> 4  Then
							If Request.Form("cboDC") = "" Then
								SqlCommand = "listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & Session("DCId")
							Else
								SqlCommand = "listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & Replace(Split(Request.Form("cboDC"),",")(0),"-1","0")
							End If
							
							Response.Write "<option value=""-1,SelectSupplier,-1"">-- Please Select --</option>"
							
						Else
							If Session("UserType") = 4 Then
								SqlCommand = "listScheduleSupplier @SupplierID=" & Session("ProcID")  & ",  @DCId=" & Session("DCId")
							Else
								SqlCommand = "listSupplier @SupplierID=" & Session("ProcID") & ", @UserType=" & Session("UserType") & ", @DCId=" & Session("DCId")
							End If
						
						End If
						
						Selected = ""
						Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)
						If Not (RecordSet.EOF And RecordSet.BOF) Then
							While NOT RecordSet.EOF
								If (RecordSet("SupplierId") & "," & RecordSet("SupplierName") & "," & RecordSet("VendorCode") = Request.Form("cboSupplier")) Or _
									(RecordSet("SupplierId") & "," & RecordSet("SupplierName") & "," & RecordSet("VendorCode") = Request.Form("hidSupplier")) Then
									
									selected = "selected"
								Else
									selected = ""
								End If %>
							<option <%=selected%> value="<%=RecordSet("SupplierId")%>,<%=RecordSet("SupplierName")%>,<%=RecordSet("VendorCode")%>"><%=RecordSet("SupplierName")%></option> <%
								RecordSet.MoveNext
							Wend
						End If %>
				</select>&nbsp;
			</td><td><b>Vendor EAN:</b></td><td><%=SupplierEan%></td>
		</tr>
    </table>
	<table>
		<col width="100">
		<col width="100">
		<col width="80">	
		<col width="300">
		<col width="80">
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center"><b>DC</b></td>
			<td class="tdcontent" align="center"><b>Vendor Code</b></td>
			<td class="tdcontent" align="center"><b>Supplier Order&nbsp;Method</b></td>
			<td class="tdcontent" align="center"><b>Order receipt e-mail address</b></td>
			<td class="tdcontent" align="center"><b>Store Order&nbsp;Method</b></td>
		</tr> <%
		VendorIds = ""
		SqlCommand = "DcOrderConfiguration @DCId=" & DCId & ",@SupplierId=" & SupplierId
		Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)
		If Not (RecordSet.EOF And RecordSet.BOF) Then
			While NOT RecordSet.EOF
				Id = RecordSet("SID")
				VendorIds = VendorIds & RecordSet("SID") & ","
				selected = "selected" 
				
				If RecordSet("StoreOrderMethod") <> "M" Then
					IsOrderEmailDisabled = ""
				Else
					IsOrderEmailDisabled = "disabled"
				End If
				
				%>
				<tr>
					<td class="pcontent" ><%=RecordSet("DC")%></td>
					<td class="pcontent" align="center"><%=RecordSet("VendorCode")%></td> <%  
					If RecordSet("StoreOrderMethod")  = "M" Then %>
						<td class="pcontent" align="center"><%=RecordSet("SupplierOrderMethod")%></td>
						<td class="pcontent" align="center"><input type="text" readonly name="txtOrderEmailAddress_<%=Id%>" id="txtOrderEmailAddress_<%=Id%>" style="width: 100%" value="<%=RecordSet("OrderEmailAddress")%>" /></td>
						<td class="pcontent" align="center"><%=RecordSet("StoreOrderMethod")%></td>
				<% 	ElseIf RecordSet("StoreOrderMethod")  = "E"  Then 
						If Session("UserType") = 1 Or Session("UserType") = 4 Or (Session("UserType") = 2 AND Session("ProcEAN") <> "SPARHEADOFFICE")Then %>
							<td class="pcontent" align="center"><% 
								If IsNull(RecordSet("SupplierOrderMethod")) Or Trim(RecordSet("SupplierOrderMethod")) = "" Then 
									Response.Write "Not specified" 
								Else
									Response.Write RecordSet("SupplierOrderMethod") 
								End If
						%></td>
					<%  Else
					%>
							<td class="pcontent" align="center">
								<select <%=SupplierOrderMethodReadOnly%> name="cboSupplierOrderMethod_<%=Id%>" id="cboSupplierOrderMethod_<%=Id%>" class="pcontent" onchange="emailtoggle(this);">
									<option <%IsSelected "EDI",RecordSet("SupplierOrderMethod")%> value="EDI">EDI</option>
									<option <%IsSelected "E-mail",RecordSet("SupplierOrderMethod")%> value="E-mail">E-mail</option>
									<option <%IsSelected "None",RecordSet("SupplierOrderMethod")%> value="None">None</option>
								</select>
							</td>
						<% End If %>
						<td class="pcontent" align="center"><input type="text" <%=IsOrderEmailDisabled%>  name="txtOrderEmailAddress_<%=Id%>" id="txtOrderEmailAddress_<%=Id%>" style="width: 100%" value="<%=RecordSet("OrderEmailAddress")%>" /></td>
						<td class="pcontent" align="center"><%=RecordSet("StoreOrderMethod")%></td>
				<% 	
					Else %>
						<td class="pcontent" align="center"><%=RecordSet("SupplierOrderMethod")%></td>
						<td class="pcontent" align="center"><%=RecordSet("OrderEmailAddress")%></td>
						<td class="pcontent" align="center">Not specified</td>
				<%	End If %>
				
				
					
				</tr>
		<%		RecordSet.MoveNext
			Wend
			
			VendorIds = Mid(VendorIds,1,Len(VendorIds)-1)
		Else
		%>
			
		<tr bgcolor="#4C8ED7">
			<td class="tdcontent" align="center" colspan="5">
				<b>No vendors</b>
			</td>
		</tr>
		<% End If %>
	</table>
	
	<table>
		<tr>
			<td><input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/></td>
            <td><input class="button" type="submit" name="Action" style="width: 98px" value="Save"/></td>
			<td><input class="button" type="submit" name="Action" style="width: 98px" value="Load"/></td>
        </tr>
		<tr>
			<td colspan="3" class="warning">
				<% 	
					'If IsSaved Then 
					'	Response.Write "<b>Updated Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
					'End If
					Response.Write Message

				%>
			</td>
		</tr>

		
	</table>
    <%
	SqlConnection.Close
	Set SqlConnection = Nothing
	Set RecordSet = Nothing
	%>
    
	<input type="hidden" id="VendorIds" name="VendorIds" value="<%=VendorIds%>" />
	<input type="hidden" id="PreviousSelectedDCId" name="PreviousSelectedDCId" value="<%=PreviousSelectedDCId%>" />
</form>

