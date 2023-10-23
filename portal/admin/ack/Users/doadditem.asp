<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=const_app_ApplicationRoot%>/default.asp?urlafter=<%=const_app_ApplicationRoot%>/users/item.asp%>";
	};
//-->
</script>					
<%
										' Set the page header
										PageTitle = "User Detail"
										
										' Check if this page is accessed from the item page
										if Request.Form("btnSubmit") <> "Submit" Then
											' redirect to the default page
											Response.Redirect const_app_ApplicationRoot & "/users/default.asp"
										end if
					
										' Declare the variables
										dim SQL
										dim ReturnSet
										dim curConnection
										dim CalcPermission
										
										CalcPermission = 0
											
										' Calculate the Users permissions - Loop through the check boxes
										For ChkCount = 1 to Request.Form("hidTotal")
											if Request.Form("chk" & ChkCount) = "checked" or Request.Form("chk" & ChkCount) = "on" Then
												CalcPermission = CalcPermission + Request.Form("chkVal" & ChkCount)
											end if
										Next

										' Build the SQL 
										SQL = "exec addAdminUser @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @UserPassword=" & MakeSQLText(Request.Form("txtPassword")) & _
											", @UserFirstName=" & MakeSQLText(Request.Form("txtName")) & _
											", @UserSurname=" & MakeSQLText(Request.Form("txtSurname")) & _
											", @UserMail=" & MakeSQLText(Request.Form("txtMail")) & _
											", @UserPermission=" & CalcPermission

										' Set the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Users</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/submenu.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="subheader">Add New User</td>
	</tr>
</table>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display the message
											' Close the recordset
											Set ReturnSet = Nothing
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again. Please contact the <a href="mailto:spar@firstnet.co.za">System Administrator</a> if you encounter the same problem.</p>
<%											
										else
											' No error occured - Continue
											
											' Send out the mail
											BodyText = "<html><head><style>body{margin-left:0;margin-right:0;margin-top:0;margin-bottom:0;margin-width:0;margin-height:0;background-color:#ffffff;}table.menu{background-color:#cccccc;}tr.none{background-color:#ffffff;}tr.menu{background-color:#cccccc;}tr.lite{background-color:#eeeeee;}tr.dark{background-color:#dddddd;}td{font-family:Verdana,Arial,Helvetica;font-size:11px;color:#000000;}small{font-size:11px;}big{font-size:13px;font-weight:bold;}kbd{font-family:Monospace;font-size:12px;}input{font-family:Monospace;font-size:12px;}textarea{font-family:Monospace;font-size:12px;}select{font-family:Monospace;font-size:12px;}b{font-weight:bold;}i{font-style:normal;color:#ff6600;}a:link{color:#3333cc;}a:active{color:#3333cc;}a:visited{color:#3333cc;}a:hover{color:#ff6600}</style></head><body marginwidth='0' marginheight='0'><table width='500' border='0' cellspacing='12' cellpadding='0' align='left'><tr>"
											BodyText = BodyText & "<td width='588' valign='top' bgcolor='#ffffff'><big>Dear " & Request.Form("txtName") & " " & Request.Form("txtSurname") & "</big><br/><i>Please do not reply to this message, as it was sent from an unattended mailbox.</i>"
											BodyText = BodyText & "<p>Herewith your administration login details as registered on the Ackermans Administration website. Remember to keep this message in a safe place, as it contains your username and password."
											BodyText = BodyText & "<ul><li>Username: " & Request.Form("txtName") & "</li><li>Password: " & Request.Form("txtPassword") & "</li><li>URL: <a href='http://ecommerce.gatewayec.co.za/ackermans/admin'>http://ecommerce.gatewayec.co.za/ackermans/admin</a></li></ul></p>"
											BodyText = BodyText & "<p>If you have any queries, contact Gateway Communications on <b>0821951</b><br/>"
											BodyText = BodyText & "<a href='mailto:helpdesk@gatewaycomms.co.za'>Gateway Communications Helpdesk</a><br/></p>"
											BodyText = BodyText & "</td></tr></table></body></html>"
												
											' Send the email
											Set oMail = Server.CreateObject("CDONTS.NewMail")
											
											oMail.From = "ackermans@gatewayec.co.za"
											oMail.To = Request.Form("txtMail")
											oMail.Subject = "Registration Details for Ackermans Administration"
											oMail.MailFormat = 0
											oMail.BodyFormat = 0
											oMail.Body = BodyText
											oMail.Send
												
											' Close the mail
											Set oMail = Nothing
%>
<p class="pcontent">The User <b><%=Request.Form("txtName") & " " & Request.Form("txtSurname")%></b> has been added successfully.</p>

<p class="pcontent"><b>Option:</b>
	<ul>
		<li class="pcontent"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/users/item.asp?id=<%=ReturnSet("NewUserID")%>">View User detail just added</a></li>
	</ul>
</p>
<%											
										end if
										
										' Close the connection and RecordSet
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
