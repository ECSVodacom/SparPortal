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
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>					
<%
										' Set the page header
										PageTitle = "Store Detail"
										
										' Check if this page is accessed from the item page
										if Request.Form("btnSubmit") <> "Submit" Then
											' redirect to the default page
											Response.Redirect const_app_ApplicationRoot & "/store/default.asp"
										end if
					
										' Declare the variables
										dim SQL
										dim ReturnSet
										dim curConnection	
										dim IsDisable
										dim ErrorCount
										dim SupplierArray
										dim Counter
										dim txtSupplier
										dim IsLive
										dim DoDelete
										dim StoreID
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if
										
										if Request.Form("chkLive") = "checked" or Request.Form("chkLive") = "on" then
											IsLive = 1
										else
											IsLive = 0
										end if
										
										' Build the SQL for updating the User detail
										SQL = "exec AddUser @FirstName=" & MakeSQLText(Request.Form("txtFirstName")) & _
											", @Surname=" & MakeSQLText(Request.Form("txtSurname")) & _
											", @Password=" & MakeSQLText(Request.Form("txtPassword")) & _
											", @Username=" & MakeSQLText(Request.Form("txtUsername")) & _
											", @LinkDC=" & Request.Form("drpDC") 
											
									'response.write SQL
									'response.end
										'Set the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										'response.write SQL
										'response.end
										' Execute the SQL
										Set ReturnSet = curConnection.Execute (SQL)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Add New User</td>
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
											' Now we need to update the supplier relationships
											User = ReturnSet("NewUser")
											' Close the recordset
											Set ReturnSet = Nothing
											
											ErrorCount = 0
											DoDelete = 0
											
											' Loop through the Store Emails
											
%>
<p class="pcontent">The Detail for User <b><%=Request.Form("txtName")%></b> has been added successfully.</p>
<%													
											' Check if there are any errors
											if ErrorCount > 0 then
												' Some errors occured with the supplier assignments
%>
<p class="pcontent"><b>NOTE:</b> One of the Email address was not added, deleted or updated successfully.<br><br>
	Please <a class="stextnav" href="<%=const_app_ApplicationRoot%>/users/item.asp?id=<%=NewUser%>"> return</a> to the previous page and try again.</p>
<%													
											end if
%>

<%											
										end if
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
