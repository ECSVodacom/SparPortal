<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 02 Sept 2002
	' Purpose: This page will update then relationships for the selected buyer.
					
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/buyer/default.asp")
										
										' Set the page header
										PageTitle = "Buyer Detail"
										
										' Check if this page is accessed from the item page
										if Request.Form("btnSubmit") <> "Submit" Then
											' redirect to the default page
											Response.Redirect const_app_ApplicationRoot & "/buyer/default.asp"
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
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if
										
										' Build the SQL for updating the User detail
										SQL = "exec editBuyer @BuyerID=" & Request.Form("hidBuyerID") & _
											", @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @Password=" & MakeSQLText(Request.Form("txtConfirmPassword")) & _
											", @FirstName=" & MakeSQLText(Request.Form("txtFirstName")) & _
											", @Surname=" & MakeSQLText(Request.Form("txtSurname")) & _
											", @Disable=" & IsDisable
											
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
		<td class="pheader">Update Buyer Detail</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/buyermenu.asp"-->
<!--#include file="includes/subbuyermenu.asp"-->
<%
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured - display the message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again. Please contact the <a href="mailto:spar@firstnet.co.za">System Administrator</a> if you encounter the same problem.</p>
<%											
											' Close the recordset
											Set ReturnSet = Nothing
										else
											' No error occured - Continue
											' Now we need to update the supplier relationships
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Build the SQL to delete all the relationships for the selected buyer
											SQL = "exec delRelationship @BuyerID=" & Request.Form("hidBuyerID")
											
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
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
												' No error occured continue
												' Close the recordset
												Set ReturnSet = Nothing
												
												' Get the supplier Id's in the supplier assigned list box
												txtSupplier = Request.Form("lstAssign")
												
												SupplierArray = Split(txtSupplier,",")												
												ErrorCount = 0
												
												' Loop through the Supplier Array
												For Counter = 0 to UBound(SupplierArray)
													' Add the new relationships to the database
													SQL = "exec addRelationship @BuyerID=" & Request.Form("hidBuyerID") & _
														", @SupplierID=" & SupplierArray(Counter)

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
												
												' Check if there are any errors
												if ErrorCount > 0 then
													' Some errors occured with the supplier assignments
%>
<p class="errortext">An error occured while one of the selected suppliers were assignd to this buyer.</p>
<p class="pcontent">Please <a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=Request.Form("hidBuyerID")%>"> return to the previous page and try again.</a></p>
<%													
												else
													' No errors occured - Display the success message
%>
<p class="pcontent">The Detail for buyer <b><%=Request.Form("txtFirstName") & " " & Request.Form("txtSurname")%></b> has been updated successfully.</p>
<p class="pcontent"><b>Options:</b>
	<ul>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/">List Buyers</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp">Add a New Buyer</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=Request.Form("hidBuyerID")%>">View the Buyer details just updated</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/buyercode.asp?id=<%=Request.Form("hidBuyerID")%>">Edit Buyer Codes</a></li>
		<li class="pcontent"><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/buyeremail.asp?id=<%=Request.Form("hidBuyerID")%>">Edit Buyer Email Addresses</a></li>
	</ul>
</p>
<%		
												end if											
											end if
										end if
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
