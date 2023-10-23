<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="constants.asp"-->
<!--#include file="formatfunctions.asp"-->
<%
										
Function GenMail (FromAddress, ToAddress, CCAddress, BCcAddress, Subject, BodyText, Importance, MailFormat, BodyFormat)
	Dim Command	

	Command = "sp_send_cdosysmail " _
		& "@From='" & FromAddress _
		& "', @To='" & ToAddress _
		& "',@Cc='" &  CCAddress _
		& "',@Subject='" & Replace(Subject,"'","''") _
	 	& "',@Body='" & Replace(BodyText,"'","''") & "'"

	Dim MailConnection
	
	Set MailConnection= CreateObject ("ADODB.Connection")
	MailConnection.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=ECsqlOnline!;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	
	ExecuteSql Command, MailConnection
	
End Function
										
										dim curConnection
										dim SQL
										dim objMail
										dim BodyText
										dim BodyText1

										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript">
 var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";
   var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){
      function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/next/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t
   }({
      instrumentationKey:"e6f725a4-085b-453a-9d38-2196d845a2ac"
   });

   window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
</script>
<script type="text/javascript" language="JavaScript" src="validation.js"></script>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};

	function validate(obj) {
		// Check if the user selected a search type
		if (obj.drpType.value=='-1') {
			window.alert('Select what type of feedback you are about to sent.');
			obj.drpType.focus();
			return false;
		};
		if (obj.txtAbout.value=='') {
			window.alert('Enter an About text.');
			obj.txtAbout.focus();
			return false;
		};
		if (obj.txtComment.value=='') {
			window.alert('Enter your Comment.');
			obj.txtComment.focus();
			return false;
		};
		if (obj.txtName.value=='') {
			window.alert('Enter your Name.');
			obj.txtName.focus();
			return false;
		};
		if (obj.txtSurname.value=='') {
			window.alert('Enter your Surname.');
			obj.txtSurname.focus();
			return false;
		};
		if (obj.txtTelCountryCode.value=='') {
			window.alert('Enter a contact telephone country code.');
			obj.txtTelCountryCode.focus();
			return false;
		};
		if (obj.txtTelCode.value=='') {
			window.alert('Enter a contact telephone area code.');
			obj.txtTelCode.focus();
			return false;
		};
		if (obj.txtTelNo.value=='') {
			window.alert('Enter a contact telephone number.');
			obj.txtTelNo.focus();
			return false;
		};
		var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
		var charpos = obj.txtMail.value.indexOf('@');
		var checkcount=0;
		if (obj.txtMail.value=='') {
			checkcount++;
		};
		if (obj.txtMail.value=='') {
			// Ensure that Field Filled in
			if ((obj.txtMail.value=='')||
				(charpos==-1)||
				(obj.txtMail.value.indexOf('.', charpos)==-1)||
				(obj.txtMail.value.indexOf('@', charpos+1)!=-1)||
				(obj.txtMail.value[obj.txtMail.length-1]=='.')) {
							
				window.alert('Enter a valid E-Mail address.');
				obj.txtMail.focus();
				return false;
			};
						
			// Ensure that Illegal Characters not Entered
			if (obj.txtMail.value.search(TestExp)!=-1) {
				window.alert('Enter a valid E-Mail address.');
				obj.txtMail.focus();
				return false;
			};
		};
	};
	
	function checkLenText(Target,MaxLength,Item) {
		StrLen = Target.value.length;
		if (StrLen > MaxLength ) {
			Target.value = Target.value.substring(0,MaxLength);
			charsLeft = 0;
		} else {
			charsLeft = MaxLength - StrLen;
		};
		charsLeft.value = charsLeft;
		document.forms('FrmSearch').item('CharsLeft' + Item.toString()).value = charsLeft;
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="<%if Request.Form("hidAction") <> "1" Then Response.Write "desc.innerHTML='Enter Store Name:'" end if%>">
<p class="bheader">SPAR Drop Shipment - Feedback Form<br><hr color="#4C8ED7"></p>
<%
										' Check if the user submited the form
										if Request.Form("hidAction") = "1" Then
											' Generate the email to the call centre
											BodyText = "Hello Vodacom Call Centre Analyst<br /><br />"'  & vbcrlf & vbcrlf
											BodyText = BodyText & "I'm " & Request.Form("txtName") & "  " & Request.Form("txtSurname") & "<br /><br />" '& vbcrlf & vbcrlf
											BodyText = BodyText & "I am a " & Request.Form("rdType") & " (" & Request.Form("txtDesc") & ")" & " and using the SPAR DropShipment 'Report a Bug' facility, I have a " & Request.Form("drpType") & " about a " & Request.Form("txtAbout") & " as below: <br /><br />" ' & vbcrlf & vbcrlf
											BodyText = BodyText & Request.Form("txtComment")  & "<br /><br />" '& vbcrlf & vbcrlf
											BodyText = BodyText & "My contact details are as follows: <br />" '& vbcrlf
											BodyText = BodyText & "Telephone Number: " & Request.Form("txtTelCountryCode") & " (" & Request.Form("txtTelCode") & ") " & Request.Form("txtTelNo") & "<br />" '& vbcrlf
											BodyText = BodyText & "Cellphone Number: " & Request.Form("txtCellCountryCode") & " (" & Request.Form("txtCellCode") & ") " & Request.Form("txtCellNo") & "<br />" '& vbcrlf
											BodyText = BodyText & "E-Mail Address: " & Request.Form("txtMail") & "<br /><br />" '& vbcrlf & vbcrlf
											BodyText = BodyText & "Thank You"
											
											' Create the Mail Object
											' Set objMail = Server.CreateObject("CDONTS.NewMail")
		
											'Build the rest of the mail object properties
											' objMail.From = Request.Form("txtMail")
											' objMail.To = "chris.kennedy@vodacom.co.za; 0821951@vodacom.co.za"
											' objMail.Subject = "SPAR DROP SHIPMENT - REPORT A BUG"
											' objMail.MailFormat = 1
											' objMail.BodyFormat = 1
											' objMail.Body = BodyText
											' objMail.Send
		
											'Close the mail Object
											' Set objMail = Nothing
											
											
											
											Call GenMail (Request.Form("txtMail"), "0821951@vodacom.co.za", "petrus.daffue@vodacom.co.za; chris.kennedy@vodacom.co.za", "", "SPAR DROP SHIPMENT - REPORT A BUG", BodyText, 1, 1, 1)
											
											' Send back an auto response to the sender
											BodyText1 = "Dear " & Request.Form("txtName") & "<br /><br />"'  & vbcrlf & vbcrlf
											BodyText1 = BodyText1 & "Thank you for taking the time to complete our SPAR Drop Shipment Feedback Form.<br /><br />" '& vbcrlf & vbcrlf
											BodyText1 = BodyText1 & "A Gateway Communications Call Centre Analyst will be in contact with you shortly to provide you with a Call Reference number.<br /><br />" '& vbcrlf & vbcrlf
											BodyText1 = BodyText1 & "Regards<br />" '& vbcrlf
											BodyText1 = BodyText1 & "Gateway Communications Site Administrator"
											
											' Create the Mail Object
											'Set objMail = Server.CreateObject("CDONTS.NewMail")
		
											' Build the rest of the mail object properties
											' objMail.From = "spar@gatewaycomms.co.za"
											' objMail.To = Request.Form("txtMail")
											' objMail.Subject = "SPAR DROP SHIPMENT - REPORT A BUG"
											' objMail.MailFormat = 1
											' objMail.BodyFormat = 1
											' objMail.Body = BodyText1
											' objMail.Send
		
											' Close the mail Object
											'Set objMail = Nothing
											
											Call GenMail ("spar@gatewaycomms.co.za", Request.Form("txtMail"), "", "", "SPAR DROP SHIPMENT - REPORT A BUG", BodyText1, 1, 1, 1)

%>
<table border="0" cellspacing="2" cellpadding="2" width="70%">
	<tr>
		<td class="feedback">Dear <%=Request.Form("txtName")%></td>
		<td class="feedback" valign="top" align="right"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif"></td>
	</tr>
</table>
<p class="feedback" valign="top">Thank you for taking the time to complete our SPAR Drop Shipment Feedback Form.<br><br>
	A Gateway Communications Call Centre Analyst will be in contact with you shortly.<br><br>
	Regards<br>
	Gateway Communications Site Administrator
</p>
<%											
										else
											' Continue
%>
<p class="pcontent">In order for us to best respond to you, please complete the following form, and one of our Call Centre operators will contact you as soon as possible.</p>
<p class="pcontent"><b>Note:</b> Fields marked with <b>[*]</b> are mandatory.</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="bugreport.asp" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<td class="nheader" colspan="3"  bgcolor="#4C8ED7">Your Feedback</td>
		</tr>
		<tr>
			<td class="pcontent" valign="top"><b>*</b></td>
			<td class="pcontent" valign="top"><b>I have a:</b></td>
			<td>
				<select name="drpType" id="drpType" class="pcontent" size="6" class="pcontent">
					<option selected value="-1">-- Select --</option>
					<option value="Bug">Bug</option>
					<option value="Comment/Suggestion">Comment/Suggestion</option>
					<option value="Complaint">Complaint</option>
					<option value="Praise">Praise</option>
					<option value="Request/Query">Request/Query</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>About:</b> (e.g. Order, Invoice, etc.)</td>
			<td class="pcontent"><input type="text" name="txtAbout" id="txtAbout" size="41" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent" valign="top"><b>*</b></td>
			<td class="pcontent" valign="top"><b>Comments:</b></td>
			<td class="pcontent"><textarea rows="8" cols="60" id="txtComment" name="txtComment" onFocus="checkLenText(this,1000,1);" onKeydown="checkLenText(this,1000,1);" onKeyup="checkLenText(this,1000,1);" onKeyPress="checkLenText(this,1000,1);" onBlur="checkLenText(this,1000,1);" onChange="checkLenText(this,1000,1);" onClick="checkLenText(this,1000,1)" class="pcontent"></textarea><br>
				<input type="text" id="CharsLeft1" name="CharsLeft1" value="1000" size="5" readonly="true" class="pcontent">&nbsp;(characters left)<br><br>
			</td>
		</tr>
		<tr>
			<td class="nheader" colspan="3"  bgcolor="#4C8ED7">Your Details</td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Name:</b></td>
			<td class="pcontent"><input type="text" name="txtName" id="txtName" size="41" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Surname:</b></td>
			<td class="pcontent"><input type="text" name="txtSurname" id="txtSurname" size="41" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Contact telephone Number:</b></td>
			<td class="pcontent">
				<input type="text" name="txtTelCountryCode" id="txtTelCountryCode" size="3" value="+27" class="pcontent">&nbsp;
				<input type="text" name="txtTelCode" id="txtTelCode" size="3" class="pcontent">&nbsp;
				<input type="text" name="txtTelNo" id="txtTelNo" size="20" class="pcontent">
			</td>
		</tr>
		<tr>
			<td class="pcontent">&nbsp;</td>
			<td class="pcontent"><b>Cellphone Number:</b></td>
			<td class="pcontent">
				<input type="text" name="txtCellCountryCode" id="txtCellCountryCode" size="3" value="+27" class="pcontent">&nbsp;
				<input type="text" name="txtCellCode" id="txtCellCode" size="3" class="pcontent">&nbsp;
				<input type="text" name="txtCellNo" id="txtCellNo" size="20" class="pcontent">
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>E-Mail Address:</b></td>
			<td class="pcontent"><input type="text" name="txtMail" id="txtMail" size="41" class="pcontent"></td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b>Are you a:</b></td>
			<td class="pcontent" valign="top">
				<input type="radio" name="rdType" id="rdType" checked="true" value="Store" onclick="desc.innerHTML='Enter Store Name:';">&nbsp;Store&nbsp;
				<input type="radio" name="rdType" id="rdType" value="Supplier" onclick="desc.innerHTML='Enter Supplier Name:';">&nbsp;Supplier&nbsp;
				<input type="radio" name="rdType" id="rdType" value="SPAR Distribution Centre" onclick="desc.innerHTML='Enter DC Name:';">&nbsp;SPAR Distribution Centre&nbsp;
			</td>
		</tr>
		<tr>
			<td class="pcontent"><b>*</b></td>
			<td class="pcontent"><b><span id="desc"></span></b></td>
			<td class="pcontent"><input type="text" name="txtDesc" id="txtDesc" size="41" class="pcontent"></td>
		</tr>
		<tr>
			<td colspan="3" bgcolor="#4C8ED7" align="center">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
				<input type="reset" name="btnReset" id="btnReset" value="Reset " class="button">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
			</td>
		</tr>
	</table>
<%
										end if
%>	
</form>
<!--#include file="../layout/end.asp"-->
