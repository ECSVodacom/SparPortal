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
												CalcPermission = CInt(CalcPermission) + CInt(Request.Form("chkVal" & ChkCount))
											end if
										Next
										
										' Build the SQL 
										SQL = "exec editAdminUser @UserID=" & Request.Form("hidUserID") & _
											", @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @UserPassword=" & MakeSQLText(Request.Form("txtPassword")) & _
											", @UserFirstName=" & MakeSQLText(Request.Form("txtName")) & _
											", @UserSurname=" & MakeSQLText(Request.Form("txtSurname")) & _
											", @UserMail=" & MakeSQLText(Request.Form("txtMail")) & _
											", @UserPermission=" & CalcPermission

											'Response.Write SQL
											'Response.End

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
		<td class="subheader">Update User Detail</td>
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
%>
<p class="pcontent">The User <b><%=Request.Form("txtName") & " " & Request.Form("txtSurname")%></b> has been updated successfully.</p>

<p class="pcontent"><b>Option:</b>
	<ul>
		<li class="pcontent"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/users/item.asp?id=<%=Request.Form("hidUserID")%>">View User detail just updated</a></li>
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
