<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorFlag
										dim strName
										dim BodyText
										dim oMail
										dim BuyerCode
										dim PMMail
										dim Delimiter

										ErrorFlag = 0
%>
<html>
<title>SPAR Reporting - User Registration</title>
<head>
<link rel="stylesheet" type="text/css" href="../layout/css/classes.css">
<script language="javascript">
<!--
	function validate(obj) {
		if (obj.txtUserName.value=='') {
			window.alert ('Enter your User Name into the User Name field.');
			obj.txtUserName.focus();
			return false;
		};
		if (obj.txtPassword.value=='') {
			window.alert ('Enter your Password into the Password field.');
			obj.txtPassword.focus();
			return false;
		};
		if ((obj.txtPassword.value.length<6)||(obj.txtPassword.value.length>8)) {
			window.alert ('Your Password is not allowed to be less than 6 characters and not greater than 8 characters.');
			obj.txtPassword.focus();
			return false;
		};
		/*if (obj.txtPassword.value!=obj.txtConfPassword.value) {
			window.alert ('The Password and Confirm Password does not match.');
			obj.txtConfPassword.focus();
			return false;
		};*/
		if (obj.txtFirstName.value=='') {
			window.alert ('Enter your First Name into the First Name field.');
			obj.txtFirstName.focus();
			return false;
		};
		if (obj.txtSurname.value=='') {
			window.alert ('Enter your Surname into the Surname field.');
			obj.txtSurname.focus();
			return false;
		};
		if (obj.txtTelNum.value=='') {
			window.alert ('Enter your Telephone Number into the Telephone Number field.');
			obj.txtTelNum.focus();
			return false;
		};
		if (obj.txtFaxNum.value=='') {
			window.alert ('Enter your Fax Number into the Fax Number field.');
			obj.txtFaxNum.focus();
			return false;
		};
		var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
		var charpos = obj.elements['txtMail'].value.indexOf('@');
		var checkcount=0;
		// Ensure that Field Filled in
		if ((obj.elements['txtMail'].value=='')||
			(charpos==-1)||
			(obj.elements['txtMail'].value.indexOf('.', charpos)==-1)||
			(obj.elements['txtMail'].value.indexOf('@', charpos+1)!=-1)||
			(obj.elements['txtMail'].value[obj.elements['txtMail'].length-1]=='.')) {
							
			window.alert('Please enter a valid Email Address');
			obj.elements['txtMail'].focus();
			return false;
		};
						
		// Ensure that Illegal Characters not Entered
		if (obj.elements['txtMail'].value.search(TestExp)!=-1) {
			window.alert('Please enter a valid Email Address.');
			obj.elements['txtMail'].focus();
			return false;
		};
		if (obj.drpType.value=='-1') {
			window.alert ('Select a Distribution Centre.');
			obj.drpType.focus();
			return false;
		};
		/*if (obj.txtBuyerCode.value=='') {
			window.alert ('You have to enter your Buyer Code.');
			obj.txtBuyerCode.focus();
			return false;
		};*/
	};
//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="" link="#FF0000" vlink="#FF0000" alink="#FF0000" text="#000000" onLoad="window.defaultStatus='Enter your details in the form above to register...';if ('<%=Request.Form("hidAction")%>'=='') {document.frmRegister.txtUserName.focus();};">
<br><br><br><br><center>
<table border="0" cellpadding="2" cellspacing="2" bgcolor="#666699" width="40%">
	<tr>
		<td>
			<table border="0" cellpadding="2" cellspacing="2">
				<tr>
					<td><a target="_blank" href="http://www.gatewaycomms.co.za"><img src="<%=const_app_ApplicationRoot%>/layout/images/backbig.gif" border="0" alt="Visit out web site..."></a></td>
				</tr>
			</table>
		</td>
		<td align="left">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td colspan="3" valign="top" class="gheader"><b><u>SPAR Reporting: Registration Form</u></b><br><br></td>
				</tr>
<%
										' Check if the user selected to login
										if Request.Form("hidAction") = "1" Then
											strName = Request.Form("txtFirstName") & " " & Request.Form("txtSurname")
											
											' Set the connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ReportConnection

											' Firstly, we need to determine if this is a registered buyer for SPAR at the selected DC
											SQL = "exec procCheckRegisteredBuyer @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
												", @DCID=" & Request.Form("drpType")
												
											' Execute the SQL statement
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												
												' Send out the mail
												BodyText = "<html><head><style>body{margin-left:0;margin-right:0;margin-top:0;margin-bottom:0;margin-width:0;margin-height:0;background-color:#ffffff;}table.menu{background-color:#cccccc;}tr.none{background-color:#ffffff;}tr.menu{background-color:#cccccc;}tr.lite{background-color:#eeeeee;}tr.dark{background-color:#dddddd;}td{font-family:Verdana,Arial,Helvetica;font-size:11px;color:#000000;}small{font-size:11px;}big{font-size:13px;font-weight:bold;}kbd{font-family:Monospace;font-size:12px;}input{font-family:Monospace;font-size:12px;}textarea{font-family:Monospace;font-size:12px;}select{font-family:Monospace;font-size:12px;}b{font-weight:bold;}i{font-style:normal;color:#ff6600;}a:link{color:#3333cc;}a:active{color:#3333cc;}a:visited{color:#3333cc;}a:hover{color:#ff6600}</style></head><body marginwidth='0' marginheight='0'><table width='500' border='0' cellspacing='12' cellpadding='0' align='left'><tr>"
												BodyText = BodyText & "<td width='588' valign='top' bgcolor='#ffffff'><big>Dear Purchasing Manager</big><br/><i>Please do not reply to this message, as it was sent from an unattended mailbox.</i>"
												BodyText = BodyText & "<p>An attempt was made from an unregistered Buyer ( UserName:" & Request.Form("txtUserName") & " - " & strName & ") at your DC to register onto the statistical website</p>"
												BodyText = BodyText & "<p>If you have any queries, contact Gateway Communications on <b>0821951</b><br/>"
												BodyText = BodyText & "<a href='mailto:0821951@vodacom.co.za'>Gateway Communications Helpdesk</a><br/></p>"
												BodyText = BodyText & "</td></tr></table></body></html>"
												
												'Response.Write BodyText
												'Response.End
													
												' Send the email to the purchacing manager
												Set oMail = Server.CreateObject("CDONTS.NewMail")
											
												oMail.From = "spar@gatewayec.co.za"
												oMail.To = "hannes.kingsley@gatewaycomms.com;chris.kennedy@gatewaycomms.com"
												oMail.Subject = "SPAR Reporting Registration - Unregistered Buyer Attempt"
												oMail.MailFormat = 0
												oMail.BodyFormat = 0
												oMail.Body = BodyText
												oMail.Send
													
												' Close the mail
												Set oMail = Nothing
												
												' Close the Recordset and Connection
												Set ReturnSet = Nothing
												curConnection.Close
												Set curConnection = Nothing
%>
				<tr>
					<td class="whitecontent" colspan="3"><br>An attempt was made from an unregistered Buyer to register onto the statistical website.<br><br>
						Please return to the <b><a class="forgot" href="javascript:history.back(1);">previous screen</a></b> and try again. 
					<br><br><br></td>
				</tr>
<%		
											else
												' This is a registered buyer for the selected DC - Continue to register him
												' Set the BuyerCode for the selected User
												BuyerCode = ReturnSet("BuyerCode")
												' Close the Recordset and Connection
												Set ReturnSet = Nothing
												curConnection.Close
												Set curConnection = Nothing
																								
												' Set the SQL Statement
												SQL = "exec procRegister @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
													", @Password=" & MakeSQLText(Request.Form("txtPassword")) & _
													", @FirstName=" & MakeSQLText(strName) & _
													", @TelNum=" & MakeSQLText(Request.Form("txtTelNum")) & _
													", @FaxNum=" & MakeSQLText(Request.Form("txtFaxNum")) & _
													", @Mail=" & MakeSQLText(Request.Form("txtMail")) & _
													", @Type=" & Request.Form("drpType")
												
												'Response.Write SQL
												'Response.End
												
												' Set the connection
												Set curConnection = Server.CreateObject("ADODB.Connection")
												curConnection.Open const_db_ConnectionString
											
												' Execute the SQL
												Set ReturnSet = ExecuteSql(SQL, curConnection)
											
												' Check the returnvalue
												if ReturnSet("returnvalue") <> 0 Then
													' An error occured - Display the error
%>
				<tr>
					<td class="whitecontent" colspan="3"><br><%=ReturnSet("errormessage")%><br><br>
						Please return to the <b><a class="forgot" href="javascript:history.back(1);">previous screen</a></b> and try again. 
					<br><br><br></td>
				</tr>
<%												
												else
													' No error occured - Display a success message to the user
													' Send out the mail to the registered buyer
													BodyText = "<html><head><style>body{margin-left:0;margin-right:0;margin-top:0;margin-bottom:0;margin-width:0;margin-height:0;background-color:#ffffff;}table.menu{background-color:#cccccc;}tr.none{background-color:#ffffff;}tr.menu{background-color:#cccccc;}tr.lite{background-color:#eeeeee;}tr.dark{background-color:#dddddd;}td{font-family:Verdana,Arial,Helvetica;font-size:11px;color:#000000;}small{font-size:11px;}big{font-size:13px;font-weight:bold;}kbd{font-family:Monospace;font-size:12px;}input{font-family:Monospace;font-size:12px;}textarea{font-family:Monospace;font-size:12px;}select{font-family:Monospace;font-size:12px;}b{font-weight:bold;}i{font-style:normal;color:#ff6600;}a:link{color:#3333cc;}a:active{color:#3333cc;}a:visited{color:#3333cc;}a:hover{color:#ff6600}</style></head><body marginwidth='0' marginheight='0'><table width='500' border='0' cellspacing='12' cellpadding='0' align='left'><tr>"
													BodyText = BodyText & "<td width='588' valign='top' bgcolor='#ffffff'><big>Dear " & Request.Form("txtFirstName") & " " & Request.Form("txtSurname") & "</big><br/><i>Please do not reply to this message, as it was sent from an unattended mailbox.</i>"
													BodyText = BodyText & "<p>Herewith your login details as registered on the SPAR Reporting website. Remember to keep this message in a safe place, as it contains your username and password."
													BodyText = BodyText & "<ul><li>Username: " & Request.Form("txtUserName") & "</li><li>Password: " & Request.Form("txtPassword") & "</li></ul></p>"
													BodyText = BodyText & "<p>If you have any queries, contact Gateway Communications on <b>0821951</b><br/>"
													BodyText = BodyText & "<a href='mailto:helpdesk@gatewaycomms.co.za'>Gateway Communications Helpdesk</a><br/></p>"
													BodyText = BodyText & "</td></tr></table></body></html>"
													
													' Send the email
													Set oMail = Server.CreateObject("CDONTS.NewMail")
											
													oMail.From = "spar@gatewayec.co.za"
													oMail.To = Request.Form("txtMail")
													oMail.Subject = "Registration Details for SPAR Reporting"
													oMail.MailFormat = 0
													oMail.BodyFormat = 0
													oMail.Body = BodyText
													oMail.Send
													
													' Close the mail
													Set oMail = Nothing
													
													' Set the Purchacing managers emails
													PMMail = ""
													
													' Loop through the recordset
													While not ReturnSet.EOF
														PMMail = PMMail & Delimiter & ReturnSet("PmEmail")
														Delimiter = ";"
														ReturnSet.MoveNext
													Wend
													
													if PMMail = "" then
														PMMail = "sparmon@gatewaycomms.co.za"
													end if
													
													' Send the mail to the list of purchasing managers
													BodyText = Request.Form("txtFirstName") & " " & Request.Form("txtSurname") & " (buyer code " & BuyerCode & " ) registered to use the SPAR Statistical Reporting website"
													
													' Send the email
													Set oMail = Server.CreateObject("CDONTS.NewMail")
											
													oMail.From = "spar@gatewayec.co.za"
													oMail.To = PMMail
													oMail.Subject = "New Registration on SPAR Statistical Reporting"
													oMail.MailFormat = 0
													oMail.BodyFormat = 0
													oMail.Body = BodyText
													oMail.Send
													
													
													' Close the mail
													Set oMail = Nothing
%>
				<tr>
					<td class="whitecontent" colspan="3">Thank you for taking the time to register. Your User Name and Password has been send to you via Email. You will receive it shortly.</td>
				</tr>
<%												
												end if
												
												' Close the Recodset
												Set ReturnSet = Nothing
																						
												' Close the connection
												curConnection.Close
												Set curConnection = Nothing												
												
											end if
										else
%>		
			<form name="frmRegister" id="frmRegister" method="post" action="default.asp" onsubmit="return validate(this);">
				<tr>
					<td class="whitecontent" colspan="3">ALL FIELDS TO BE COMPLETED.<br><br></td>
				</tr>
				<tr>
					<td class="whitecontent" colspan="2"><b>You require your Buyer User Name ans Password that you use for the DC Track & Trace facility to register.</b></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>User Name</b></td>
					<td class="pcontent"><input type="text" name="txtUserName" id="txtUserName" size="20" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Password</b></td>
					<td class="pcontent"><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="8" class="pcontent"></td>
				</tr>
				<!--<tr>
					<td class="whitecontent">*</td>
					<td class="whitecontent"><b>Confirm Password</b></td>
					<td class="pcontent"><input type="password" name="txtConfPassword" id="txtConfPassword" size="20" maxlength="8" class="pcontent"></td>
				</tr>-->
				<tr>
					<td class="whitecontent"><b>First Name</b></td>
					<td class="pcontent"><input type="text" name="txtFirstName" id="txtFirstName" size="20" maxlength="50" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Surname</b></td>
					<td class="pcontent"><input type="text" name="txtSurname" id="txtSurname" size="20" maxlength="50" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Telephone Number</b></td>
					<td class="pcontent"><input type="text" name="txtTelNum" id="txtTelNum" size="20" maxlength="50" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Fax Number</b></td>
					<td class="pcontent"><input type="text" name="txtFaxNum" id="txtFaxNum" size="20" maxlength="50" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Email Address</b></td>
					<td class="pcontent"><input type="text" name="txtMail" id="txtMail" size="20" maxlength="50" class="pcontent"></td>
				</tr>
				<tr>
					<td class="whitecontent"><b>Where are you from?</b></td>
					<td class="pcontent">
						<select name="drpType" id="drpType" class="pcontent">
							<option value="-1">-- Select a Distribution Centre --</option>
							<option value="1">SPAR SOUTH RAND</option>
							<option value="2">SPAR NORTH RAND</option>
							<option value="3">SPAR KWAZULU NATAL</option>
							<option value="4">SPAR EASTERN CAPE</option>
							<option value="5">SPAR WESTERN CAPE</option>
						</select>
					</td>
				</tr>
				<!--<tr>
					<td class="whitecontent">*</td>
					<td class="whitecontent"><b>What is your Buyer Code</b></td>
					<td class="pcontent"><input type="text" name="txtBuyerCode" id="txtBuyerCode" size="20" maxlength="50" class="pcontent"></td>
				</tr>-->
				<tr>
					<td class="whitecontent">&nbsp;</td>
					<td class="pcontent"><br>
						<input type="submit" name="btnSubmit" id="btnSubmit" value="Register" class="button">&nbsp;&nbsp;&nbsp;
						<input type="hidden" name="hidAction" id="hidAction" value="1">
					</td>
				</tr>
			</table>
		</form>
<%
										end if
%>		
		</td>
	</tr>
	<tr>
		<td class="whitecontent" colspan="2" align="left" width="100%">Please contact the Vodacom Call Centre on <b>0821951</b> should you encounter any problems.</td>
	</tr>
	<tr>
		<td class="whitecontent" colspan="2" align="center" width="100%">[<a class="forgot" href="<%=const_app_ApplicationRoot%>/">Return to the Logon Page</a>]</td>
	</tr>
</table>
</center>
</body>
