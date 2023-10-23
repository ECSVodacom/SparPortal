<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
Function GenMail (FromAddress, ToAddress, CCAddress, BCcAddress, Subject, BodyText, Importance, MailFormat, BodyFormat)
	Dim Command	

	Command = "sp_send_cdosysmail " _
	& "@From='" & FromAddress _
	& "', @To='" & ToAddress _
	& "',@Cc='" &  CCAddress  _
	& "',@Subject='" & Replace(Subject,"'","''") _
	& "',@Body='" & Replace(BodyText,"'","''") & "'"

	Dim MailConnection
	Set MailConnection= CreateObject ("ADODB.Connection")
	MailConnection.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=ECsqlOnline!;Initial Catalog=SparDS;Data Source=192.168.101.36,1433"
	
	
	
	ExecuteSql Command, MailConnection
	
	MailConnection.Close
	Set MailConnection = Nothing
	
	
End Function

										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>								
<%
										
										PageTitle = "Generate E-Mail"
										
										dim curConnection
										dim ReturnSet
										dim SQL
										dim oMail
										dim strTo
										dim ToCount
										dim strMail
										dim delim
																				
										' Check if the user posted a form
										if Request.Form("hidAction") = "1" Then
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Add the txtTo value to an array
											strTo = split(Request.Form("txtTo"),";")
											
											' Loop through the array
											For ToCount = 0 to UBound(strTo)
												' Determine what was selected
												Select Case CStr(strTo(ToCount))
												Case "Eastern Cape Group" 
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=4 AND USiDisable=0"
												Case "KZN Group"
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=3 AND USiDisable=0"
												Case "North Rand Group"
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=2 AND USiDisable=0"
												Case "South Rand Group"
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=1 AND USiDisable=0"
												Case "Supplier Group" 
													' Set the SQL Satement
													SQL = "SELECT DISTINCT SPcEmail AS Email FROM Supplier" & _
														  " INNER JOIN Users ON SPiUserID = USID" & _
														  " WHERE USiDisable = 0"
												Case "Western Cape Group"
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=5 AND USiDisable=0"
												Case "Low Veld Group"
													SQL = "SELECT DISTINCT BEcEMailAddress AS Email FROM Buyer" & _
														" INNER JOIN BuyerEmail ON BRID = BEID" & _
														" INNER JOIN Users ON BRiUserID = USID" & _
														" WHERE BRiCompanyID = 7 AND USiDisable = 0"
												Case Else
													strMail = strTo(ToCount)
												End Select
												
												'Response.Write SQL & "<br>"
												
												if SQL <> "" then
													' Execute the SQL
													Set ReturnSet =  ExecuteSql(SQL, curConnection)  
												
													' Loop through the recordset
													While not ReturnSet.EOF
														
													
														'strMail = strMail & delim & ReturnSet("Email")
														strMail = ReturnSet("Email")
														'delim = ";"
														
														'Response.Write strMail & "<br>"

														' Send the email
														'Set oMail = Server.CreateObject("CDONTS.NewMail")
											
														Call GenMail(Request.Form("txtFrom"), strMail, "", "", Request.Form("txtSubject"), Request.Form("txtBody"), 1, 1, 1)
											
														'oMail.From = Request.Form("txtFrom")
														'oMail.To = strMail
														'oMail.Subject = Request.Form("txtSubject")
														'oMail.AttachFile "d:\uploads\DebbieMails\MigratingSuppliers2310.xls","Migrating_Suppliers_2310"									
														'oMail.MailFormat = 0
														'oMail.BodyFormat = 1
														'oMail.Body = Request.Form("txtBody")
														'oMail.Send

														ReturnSet.MoveNext
													Wend
													
													' Close the recordset
													Set ReturnSet = Nothing
												else
'													'Response.Write strMail & "; <br>"
													' Send the email
													'Set oMail = Server.CreateObject("CDONTS.NewMail")
											
											
													Call GenMail (Request.Form("txtFrom"), strMail, "", "", Request.Form("txtSubject"), Request.Form("txtBody"), 1, 1, 1)
													'oMail.From = Request.Form("txtFrom")
													'oMail.To = strMail
													'oMail.Subject = Request.Form("txtSubject")
													'oMail.AttachFile "d:\uploads\DebbieMails\MigratingSuppliers2310.xls","Migrating_Suppliers_2310"									
													'oMail.MailFormat = 0
													'oMail.BodyFormat = 1
													'oMail.Body = Request.Form("txtBody")
													'oMail.Send
												end if
											Next
											
											' Close the Connection
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="Bheader">Generate an E-Mail</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<%
										if Request.Form("hidAction") = "1" Then
%>
<p class="pcontent"><b>The E-Mail has been sent successfully.</b></p>			
<%										
										end if
%>
<p class="pcontent">In the form below you can constuct your own e-mail and send it to whoever you select.</p>
<form name="email" id="email" method="post" action="default.asp">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>From:</b></td>
		<td class="pcontent"><input type="text" name="txtFrom" id="txtFrom" size="40">&nbsp;
			<input type="button" name="btnSelect" id="btnSelect" value="Select" class="button" onclick="javascript:newWindow = openWin('list.asp?action=1', 'SelectFrom', 'width=550,height=300,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');">
		
		</td>
	</tr>
	<tr>
		<td class="pcontent"><b>To:</b></td>
		<td class="pcontent"><input type="text" name="txtTo" id="txtTo" size="40">&nbsp;
			<input type="button" name="btnSelect" id="btnSelect" value="Select" class="button" onclick="javascript:newWindow = openWin('list.asp?action=2', 'SelectTo', 'width=550,height=300,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>Subject:</b></td>
		<td class="pcontent"><input type="text" name="txtSubject" id="txtSubject" size="40"></td>
	</tr>
	<tr>
		<td class="pcontent" valign="top"><b>Body Text:</b></td>
		<td class="pcontent">
			<textarea name="txtBody" id="txtBody" rows="15" cols="100">
<%
										if request.querystring("txtBody") <> "" then
											response.write request.querystring("txtBody")				
										else
%>
Dear SPAR Buyers,

Gateway Communications is unable to collect Orders from the SPAR DC's at the moment.  Our 2nd line technical support are attending to the problem. The Call Centre will notify you shortly if any action needs to be taken on your side to place orders via fax.

Kind Regards,

Wendy Cuthill
e-mail: wendy.cuthill@vodacom.co.za
Office: +27 11 848-8542
Call Center +27 11 797-3300
<%
										end if
%>
			</textarea>
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