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
										'if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
										'	IsDisable = 1
										'else
											IsDisable = 0
										'end if
										
										'if Request.Form("chkLive") = "checked" or Request.Form("chkLive") = "on" then
										'	IsLive = 1
										'else
										'	IsLive = 0
										'end if
										
										' Build the SQL for updating the User detail
										SQL = "exec addStore @UserName=" & MakeSQLText(Request.Form("txtEAN")) & _
											", @Password=" & MakeSQLText("password") & _
											", @StoreName=" & MakeSQLText(Request.Form("txtName")) & _
											", @StoreTelNo=" & MakeSQLText(Request.Form("txtTel")) & _
											", @StoreFaxNo=" & MakeSQLText(Request.Form("txtFax")) & _
											", @StoreEAN=" & MakeSQLText(Request.Form("txtEAN")) & _
											", @StoreCode=" & MakeSQLText(Request.Form("txtCode")) & _
											", @StoreAddress=" & MakeSQLText(Request.Form("txtAddress")) & _
											", @StoreOwner=" & MakeSQLText(Request.Form("txtOwner")) & _
											", @StoreManager=" & MakeSQLText(Request.Form("txtManager")) & _
											", @IsLive=" & Request.Form("chkLive") & _
											", @LinkDC=" & Request.Form("drpDC") & _
											", @Disable=" & IsDisable

'response.write SQL & "<br>"
'response.end

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
		<td class="bheader">Add New Store</td>
	</tr>
</table>
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display the message
											' Close the recordset
											Set ReturnSet = Nothing
%>
<p class="errortext"><%=ReturnSet("errortext")%></p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again. Please contact the <a href="mailto:spar@firstnet.co.za">System Administrator</a> if you encounter the same problem.</p>
<%											
										else
											' No error occured - Continue
											' Now we need to update the supplier relationships
											StoreID = ReturnSet("NewStoreID")
											' Close the recordset
											Set ReturnSet = Nothing
											
											ErrorCount = 0
											DoDelete = 0
											
											' Loop through the Store Emails
											For Counter = 1 to Request.Form("hidTotalCount")
												' Check if must delete
												if Request.Form("chkDel" & Counter) = "checked" or Request.Form("chkDel" & Counter) = "on" then
													DoDelete = 1
												else
													DoDelete = 0
												end if
												
												' Edit thew email addresses
												SQL = "exec editStoreMail @StoreID=" & StoreID & _
													", @StoreMailID=0" & _
													", @StoreMail=" & MakeSQLText(Request.Form("txtStoreMail" & Counter)) & _
													", @Delete=" & DoDelete
													
													'Response.Write SQL & "<br>"
													'Response.End

												' Execute the SQL
												Set ReturnSet = ExecuteSql(SQL, curConnection)
													
												' Check the returnvalue
												if ReturnSet("returnvalue") <> 0 then
													' an error occured - increment the errorcount
													ErrorCount = ErrorCount + 1
												end if
													
												' Close thre recordset
												Set ReturnSet = Nothing
											Next
%>
<p class="pcontent">The Detail for Store <b><%=Request.Form("txtName")%></b> has been added successfully.</p>
<%													
											' Check if there are any errors
											if ErrorCount > 0 then
												' Some errors occured with the supplier assignments
%>
<p class="pcontent"><b>NOTE:</b> One of the Email address was not added, deleted or updated successfully.<br><br>
	Please <a class="stextnav" href="<%=const_app_ApplicationRoot%>/store/item.asp?id=<%=StoreID%>"> return</a> to the previous page and try again.</p>
<%													
											end if
%>
<p class="pcontent"><b>Option:</b>
	<ul>
		<li class="pcontent"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/store/item.asp?id=<%=StoreID%>">View Detail of new Store</a></li>
	</ul>
</p>
<%											
										end if
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
