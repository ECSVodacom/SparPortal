<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<%
	' Author & Date: Chris Kennedy, 21 June 2002
	' Purpose: 
										
										PageTitle = "Generate E-Mail"
										
										dim curConnection
										dim ReturnSet
										dim SQL
										dim oMail
										dim strTo
										dim ToCount
										dim strMail
										dim delim
										dim doSend
										
										doSend = 0
																				
										' Check if the user posted a form
										if Request.Form("hidAction") = "1" Then
											' Send the email
											Set oMail = Server.CreateObject("CDONTS.NewMail")
											
											oMail.From = Request.Form("txtFrom")
											oMail.To = Request.Form("txtTo")
											oMail.Subject = Request.Form("txtSubject")
											oMail.MailFormat = 0
											oMail.BodyFormat = 0
											'oMail.AttachURL "E:\Inetpub\wwwroot\Spar\portal\admin\ack\layout\images\topbanner1.gif", "topbanner1.gif"
											'oMail.AttachURL "E:\Inetpub\wwwroot\Spar\portal\admin\ack\layout\images\gototop.bmp", "gototop.bmp"
											oMail.Body = Request.Form("txtContent")
											oMail.Send
											
											' Close the mail object
											Set oMail = Nothing
											
											doSend = 1
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/yusasp_ace.js"></script>
<script type="text/javascript" language="JavaScript" src="../includes/yusasp_color.js"></script>
<script language="javascript">
<!--
	function validate(obj) {
		if	(obj.txtFrom.value=='') {
			window.alert ('Enter a From address.');
			obj.txtFrom.focus();
			return false;
		};
		if	(obj.txtTo.value=='') {
			window.alert ('Enter a To address.');
			obj.txtTo.focus();
			return false;
		};
		if	(obj.txtSubject.value=='') {
			window.alert ('Enter a Submit.');
			obj.txtSubject.focus();
			return false;
		};
		
		//must not in HTML view.
		if(obj1.displayMode == "HTML"){
			window.alert('Uncheck HTML view');
			return false;
		};
		
		document.email.txtContent.value = obj1.getContentBody();
	};
	
	function LoadContent(){
		obj1.putContent(document.email.idTextarea.value); 
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Generate an E-Mail</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<%
										if Request.Form("hidAction") = "1" Then
%>
<p class="pcontent"><b>The E-Mail has been sent successfully.</b></p>			
<%										
										end if
%>
<p class="pcontent">In the form below you can constuct your own e-mail and send it to whoever you select.</p>
<form name="email" id="email" method="post" action="default.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>From:</b></td>
		<td class="pcontent"><input type="text" name="txtFrom" id="txtFrom" size="40" class="pcontent" value="0821951@vodacom.co.za"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>To:</b></td>
		<td class="pcontent"><input type="text" name="txtTo" id="txtTo" size="40" class="pcontent">&nbsp;
			<input type="button" name="btnSelect" id="btnSelect" value="Select" class="button" onclick="javascript:newWindow = openWin('list.asp?action=2', 'SelectTo', 'width=550,height=300,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');">
		</td>
	</tr>
	<tr>
		<td class="pcontent"><b>Subject:</b></td>
		<td class="pcontent"><input type="text" name="txtSubject" id="txtSubject" size="40" class="pcontent"></td>
	</tr>
	<!--<tr>
		<td class="pcontent"><b>Attach File:</b></td>
		<td class="pcontent"><input type="file" name="txtFile" id="txtFile"></td>
	</tr>-->
	<tr>
		<td class="pcontent" valign="top"><b>Body Text:</b></td>
		<td class="pcontent">
			<input type="hidden" name="txtContent" id="txtContent" value=""><br>
<script>
	var obj1 = new ACEditor("obj1")
	obj1.width = "100%" //set editor dimension
	obj1.height = 300
	obj1.useStyle = false //here is how to enable/disable toolbar buttons
	obj1.useAsset = false
	obj1.useImage = true
	obj1.ImagePageURL = "<%=const_app_Applicationroot%>/includes/default_image.asp"
	obj1.usePageProperties = false
	obj1.RUN() //run & show the editor
</script>
			<textarea rows="7" cols="40" id="idTextarea" name="idTextarea" style="display:none"></textarea>
		</td>
		
	</tr>
	<tr>
		<td colspan="2"><input type="submit" name="btnSubmit" id="btnSubmit" value="Send Mail" class="button">&nbsp;
		<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->