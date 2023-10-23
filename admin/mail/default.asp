<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/clearuserdetails.asp"-->
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
													SQL = "SELECT SPcEMail AS Email FROM Supplier"
												Case "Western Cape Group"
													' Set the SQL Satement
													SQL = "SELECT DISTINCT BEcEmailAddress AS Email FROM BuyerEmail" & _
														" INNER JOIN Buyer ON BRID = BEID" & _
														" INNER JOIN Users ON USID = BRID" & _
														" WHERE BRiCompanyID=5 AND USiDisable=0"
												
												Case Else
													strMail = strTo(ToCount)
												End Select
												
																	
												if SQL <> "" then
													' Execute the SQL
													Set ReturnSet = ExecuteSql(SQL, curConnection) 

													'Response.Write SQL
													'Response.End
												
													' Loop through the recordset
													While not ReturnSet.EOF
														'strMail = strMail & delim & ReturnSet("Email")
														'strMail = 'jkingsley@gatewaycomms.co.za'
														
														strMail = ReturnSet("Email")
														
														'delim = ";"
														
														'Response.Write strMail & "; <br>"

														' Send the email
														Set oMail = Server.CreateObject("CDONTS.NewMail")
											
														oMail.From = Request.Form("txtFrom")
														oMail.To = strMail
														
														'Response.Write(strMail)
														'Response.end
														
														oMail.Subject = Request.Form("txtSubject")
														'oMail.AttachFile "d:\uploads\DebbieMails\MigratingSuppliers2310.xls","Migrating_Suppliers_2310"									
														oMail.MailFormat = 0
														oMail.BodyFormat = 1
														oMail.Body = Request.Form("txtBody")
														oMail.Send

														ReturnSet.MoveNext
													Wend
													
													' Close the recordset
													Set ReturnSet = Nothing
												else
													'Response.Write strMail & "; <br>"
													' Send the email
													Set oMail = Server.CreateObject("CDONTS.NewMail")
											
													oMail.From = Request.Form("txtFrom")
													oMail.To = strMail
													oMail.Subject = Request.Form("txtSubject")
													'oMail.AttachFile "d:\uploads\DebbieMails\MigratingSuppliers2310.xls","Migrating_Suppliers_2310"									
													oMail.MailFormat = 0
													oMail.BodyFormat = 1
													oMail.Body = Request.Form("txtBody")
													oMail.Send
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
	<!--<tr>
		<td class="pcontent"><b>Attach File:</b></td>
		<td class="pcontent"><input type="file" name="txtFile" id="txtFile"></td>
	</tr>-->
	<tr>
		<td class="pcontent" valign="top"><b>Body Text:</b></td>
		<td class="pcontent">
			<textarea name="txtBody" id="txtBody" rows="15" cols="100">
Dear SPAR Buyers,

Gateway Communications is unable to collect Orders from the SPAR DC's at the moment.  Our 2nd line technical support are attending to the problem. The Call Centre will notify you shortly if any action needs to be taken on your side to place orders via fax.

Kind Regards,

Marius van Heerden
Gateway Communication Call Centre Supervisor
e-mail: mvanheerden@gatewaycoms.co.za
Office: +27 11 322-5421
Cell: +27 83 296-1208
Tollfree: 0821951
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