<%@ Language=VBScript %>

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
										PageTitle = "Supplier Detail"
										
										' Check if this page is accessed from the item page
										if Request.Form("btnSubmit") <> "Submit" Then
											' redirect to the default page
											Response.Redirect const_app_ApplicationRoot & "/supplier/default.asp"
										end if
					
										' Declare the variables
										dim SQL
										dim ReturnSet
										dim curConnection
										dim txtPermission
										
										txtPermission = 0
										
										if Request.Form("chkPFO") = "checked" or Request.Form("chkPFO") = "on" then
											txtPermission = txtPermission + CInt(Request.Form("hidPFO"))
										end if
										
										if Request.Form("chkQA") = "checked" or Request.Form("chkQA") = "on" then
											txtPermission = txtPermission + CInt(Request.Form("hidQA"))
										end if

										' Build the SQL 
										SQL = "exec editSupplier @SupplierID=" & Request.Form("hidSupplierID") & _
											", @UserPassword=" & MakeSQLText(Request.Form("txtPassword")) & _
											", @UserFirstName=" & MakeSQLText(Request.Form("txtName")) & _
											", @UserMail=" & MakeSQLText(Request.Form("txtMail")) & _
											", @Disable=" & Request.Form("hidDisable") & _
											", @ChangePwd=" & Request.Form("hidPwdChange") & _
											", @AdminUser=1" & _
											", @Permission=" & txtPermission & _
											", @RollOutMail=" & MakeSQLText(Request.Form("txtRollMail"))
											
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
		<td class="pheader">Suppliers</td>
	</tr>
</table>
<!--include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/submenu.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="subheader">Update Supplier Detail</td>
	</tr>
</table>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display the message
											' Close the recordset
											'Set ReturnSet = Nothing
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again. Please contact the <a href="mailto:spar@firstnet.co.za">System Administrator</a> if you encounter the same problem.</p>
<%											
										else
											' No error occured - Continue
%>
<p class="pcontent">The Supplier <b><%=Request.Form("txtName")%></b> has been updated successfully.</p>

<p class="pcontent"><b>Option:</b>
	<ul>
		<li class="pcontent"><a class="stextnav" href="<%=const_app_AdminRoot%>/supplier/item.asp?id=<%=Request.Form("hidSupplierID")%>">View Supplier detail just updated</a></li>
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
