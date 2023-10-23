<!DOCTYPE html>
<%@ Language=VBScript %>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<%
	Dim txtNewBuyerName_0
	Dim txtNewBuyerEmail_0
	
	IsUpdated = False
	IsAdded = False
	
	Function MakeSqlSafe(InputText)

		MakeSqlSafe = Replace(InputText,"'","''")
	End Function
	
	Set SqlConnection = Server.CreateObject("ADODB.Connection")
	SqlConnection.Open const_db_ConnectionString
	
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		SelectedDcId = Split(Request.Form("cboDC"),",")(0)
	
		If Request.Form("Action") = "Save" Then
			BuyerIdsToUpdate = Split(Request.Form("BuyerIds"),",")
			
			For Each BuyerId In BuyerIdsToUpdate
				Name = MakeSqlSafe(Request.Form("txtNewBuyerName_" & BuyerId))
				Email = MakeSqlSafe(Request.Form("txtNewBuyerEmail_" & BuyerId))
				IsActive = Request.Form("BuyerActiveInactive_" & BuyerId)
				
				SqlCommand = "MaintainBuyers " _
					& "@BuyerId=" & BuyerId _
					& ",@Name='" & Name _
					& "',@Email='" & Email _
					& "',@IsActive=" & IsActive
					
				ExecuteSql SqlCommand, SqlConnection

			Next
			
			IsUpdated = True
		ElseIf Request.Form("Action") = "Add"  Then
			Name = MakeSqlSafe(Request.Form("txtNewBuyerName_0"))
			Email = MakeSqlSafe(Request.Form("txtNewBuyerEmail_0"))
		
			SqlCommand = "MaintainBuyers " _
				& "@BuyerId=0 " _
				& ",@Name='" & Name _
				& "',@Email='" & Email _
				& "',@DcId=" & SelectedDcId
				
			ExecuteSql SqlCommand, SqlConnection
			
			
			IsAdded = True
		End If
	End If
	
	If SelectedDcId = "" Then SelectedDcId = Session("DCId")
	
	
%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>SPAR</title>
		<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css">
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
		function SetDcSelectedVal()
		{
			document.forms["default"].submit();
		}
		
		function ValidateName(NameTextBox)
		{			
			var id = NameTextBox.name.split('_')[1];
			if(NameTextBox.value.length == 0)
			{
				document.getElementById("namemessage_"+id).innerHTML = "Enter a name";
				return false;
			}
			
			if(NameTextBox.value.length <= 30)
				document.getElementById("namemessage_"+id).innerHTML = "";
			else
			{
				document.getElementById("namemessage_"+id).innerHTML = "Maximum 30 characters";	
				return false;				
			}
			
			return true;
		}
		
		function ValidateEmail(emailTextBox) 
		{
			var email = emailTextBox.value;
			var id = emailTextBox.name.split('_')[1];
			document.getElementById("emailmessage_"+id).innerHTML = "Invalid email";
			var regEx = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$/  
			
			var emailArray = email.split(';');
			if(emailArray[0].trim().length == 0)
			{
				document.getElementById("emailmessage_"+id).innerHTML = "Enter an email";
				return false;
			}
			
			for (var idx = 0; idx < emailArray.length; idx++) {
				if (emailArray[idx].trim().match(regEx))
					document.getElementById("emailmessage_"+id).innerHTML = "";
				else
				{
					document.getElementById("emailmessage_"+id).innerHTML = "Invalid email";
					return false;
				}
			}
			return true;
		}
		

		
		function OnSave(action)
		{
			var form = document.default;
			var isValid = false;

			if (form.cboDC.value == '-1,Not Selected')
			{
				document.getElementById("selectDCmessage").innerHTML = "Select a DC";
				return false;
			}
			
			if (action == "add")
			{
				isValid = ValidateName(form.txtNewBuyerName_0) && ValidateEmail(form.txtNewBuyerEmail_0);
			}
			else if (action == "save")
			{
				
				var id = form.BuyerIds.value.split(",");

				for (var idx = 0; idx < id.length; idx++) {
					var txtNewBuyerName = document.getElementById("txtNewBuyerName_"+id[idx]);
					var txtNewBuyerEmail = document.getElementById("txtNewBuyerEmail_"+id[idx]);
					
					isValid = ValidateName(txtNewBuyerName) && ValidateEmail(txtNewBuyerEmail);
					if (isValid == false) return false;
				}
			}	
			
			if (isValid) 
					document.getElementById["default"].submit();
			
			return isValid;
		}
		</script>
	</head>
	<body>
		<table border="0" class="pcontent">
			<tr>
				<td class="bheader" align="left" valign="top">MANAGE BUYER</td>
			</tr>
		</table>
		<form id="default" name="default" method="post" action="default.asp" >
			<table class="pcontent" border="0" width="100%">
				<tr>
					<td>DC</td>
					<td>		
						<select name="cboDC" id="cboDC" class="pcontent" onchange="SetDcSelectedVal();">
							<%
								If Session("DCId") = 0 Then %>				
									<option value="-1,Not Selected">-- Select a DC --</option>
							<%
									'SelectedDcId = -1
								End If
								
								selected = ""
								SqlCommand = "listDC @DC="  & Session("DCId")
								
								Set RecordSet = ExecuteSql(SqlCommand, SqlConnection)
								If Not (RecordSet.EOF And RecordSet.BOF) Then
									While NOT RecordSet.EOF
										If RecordSet("DCId") & "," & RecordSet("DCcName") = Request.Form("cboDC") Then
											selected = "selected"
											'Response.Write RecordSet("DCId") & "," & RecordSet("DCcName") & " = "  & Request.Form("cboDC")
										Else 	
											selected = ""
										End If%>
									<option <%=selected%> value="<%=RecordSet("DCID")%>,<%=RecordSet("DCcName")%>"><%=Replace(RecordSet("DCcName"),"SPAR ","")%></option><%
										RecordSet.MoveNext
									Wend
								End If
							%>
						</select>
						<div id="selectDCmessage" class="warning"></div>
					</td>
				</tr>
			</table>
			<table>
				<%
					Set rsBuyers =  ExecuteSql("ListBuyers @DcId=" & SelectedDcId, SqlConnection)  
					If (Not (rsBuyers.BOF And rsBuyers.EOF)) And (SelectedDcId>0) Then
					
				%>
			
				<tr bgcolor="#4c8ed7">
					<td align="center" class="tdcontent" cellspacing="2"><b>Name</b></td>
					<td align="center" class="tdcontent" cellspacing="2"><b>Email</b></td>
					<td align="center" class="tdcontent"><b>Active/ Inactive</b></td>
					
				</tr>
				<tr>
					<td align="center" class="pcontent" cellspacing="2"><i>Max length (30)</i></td>
					<td align="center" class="pcontent" cellspacing="2"><i>More than one email must be seperated by <b>;</b></i></td>
					<td align="center" class="pcontent"><b></b></td>
					
				</tr>
				
				<%
					While Not rsBuyers.EOF
						BuyerIds = BuyerIds & rsBuyers("BUID") & ","
				%>
				
				<tr>
					<td><input type="text"  name="txtNewBuyerName_<%=rsBuyers("BUID")%>" id="txtNewBuyerName_<%=rsBuyers("BUID")%>" maxlength="30" onkeypress="ValidateName(this)" class="pcontent" value="<%=rsBuyers("BuyerName")%>" ><div id="namemessage_<%=rsBuyers("BUID")%>" class="warning"></div></td>
					<td><input type="text" name="txtNewBuyerEmail_<%=rsBuyers("BUID")%>" id="txtNewBuyerEmail_<%=rsBuyers("BUID")%>" onkeypress="ValidateEmail(this);" style="width:100%" class="pcontent" value="<%=rsBuyers("BuyerEmailAddress")%>" ><div id="emailmessage_<%=rsBuyers("BUID")%>" class="warning"></div></td>
					
					<td class="pcontent" >
						<% If rsBuyers("IsActive") Then %>
							<input type="radio" name="BuyerActiveInactive_<%=rsBuyers("BUID")%>" id="BuyerActiveInactive_<%=rsBuyers("BUID")%>" value="1" checked="true"/>Yes
							<input type="radio" name="BuyerActiveInactive_<%=rsBuyers("BUID")%>" id="BuyerActiveInactive_<%=rsBuyers("BUID")%>" value="0" />No
						<% Else %>
							<input type="radio" name="BuyerActiveInactive_<%=rsBuyers("BUID")%>" id="BuyerActiveInactive_<%=rsBuyers("BUID")%>" value="1" />Yes
							<input type="radio" name="BuyerActiveInactive_<%=rsBuyers("BUID")%>" id="BuyerActiveInactive_<%=rsBuyers("BUID")%>" value="0" checked="true"/>No
						<% End If %>	
					</td>
					
				
				</tr>
					<%
						rsBuyers.MoveNext
					Wend
					BuyerIds = Mid(BuyerIds,1,Len(BuyerIds)-1)
					
						CanUpdate = True
					Else
						CanUpdate = False
				%>
				
				<tr bgcolor="#4c8ed7">
					<td align="center" class="tdcontent" cellspacing="2"><b>No buyers listed for this DC</b></td>
				</tr>
				
				<%
					End If
					rsBuyers.Close
					Set rsBuyers = Nothing
				%>
			</table>
			<table>
				<tr>
					<td><br/><br/><input class="button" onclick="javascript:window.close();" type="button" name="Action" style="width: 98px" value="Close Window"/></td>
					<% If CanUpdate Then %>
					<td><br/><br/><input class="button" type="submit" name="Action" onclick="return OnSave('save');" style="width: 98px" value="Save"/></td>
					<% End If %>
				</tr>
				<tr>
					<td colspan="3" class="warning">
					
						<% 	
							If IsUpdated Then
								Response.Write "<b>Updated Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
							End If
						%>
					</td>
				</tr>
			</table>
			<table border="0" class="pcontent" >
				<tr>
					<td colspan="5" class="bheader" align="left" valign="top">ADD NEW BUYER</td>
				</tr>
				
				<tr >
					<td> Name&nbsp;</td><td><input type="text"  name="txtNewBuyerName_0" id="txtNewBuyerName_0" onkeypress="ValidateName(this)" maxlength="30" style="width: 200px" class="pcontent" ></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email&nbsp;</td><td><input type="text" name="txtNewBuyerEmail_0" id="txtNewBuyerEmail_0" onkeypress="ValidateEmail(this);" style="width: 200px" class="pcontent" ></td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td><div id="namemessage_0" class="warning"></div></td>
					<td></td>
					<td><div id="emailmessage_0" class="warning"></div></td>
				</tr>
				<tr>
					<td colspan="5" class="warning">
					
						<% 	
							If IsAdded Then
								Response.Write "<b>Saved Successfully - " & Year(Now) & "/" & Month(Now) & "/" & Day(Now) & " " & Hour(Now) & ":" & Minute(Now) & ":" & Second(Now) & "</b>"
							End If
						%>
					</td>
				</tr>

				<tr>
					<td colspan="5"><br/><br/><input class="button" type="submit" name="Action" onclick="return OnSave('add');"  style="width: 100px" value="Add"/></td>
				</tr>
			</table>
			
			<input type="hidden" id="BuyerIds" name="BuyerIds" value="<%=BuyerIds%>">
		</form> 
		
	</body>
</html> 
<%
	SqlConnection.Close
	Set SqlConnection = Nothing

%>