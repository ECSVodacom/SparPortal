<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 02 Sept 2002
	' Purpose: This page will update then relationships for the selected buyer.

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
										dim ErrorText
										dim SupplierArray
										dim Counter
										dim txtSupplier
										dim NewBuyerID
										dim BuyerCount
										dim MailCount
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if
										
										' Build the SQL for updating the User detail
										SQL = "exec addBuyer @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @Password=" & MakeSQLText(Request.Form("txtConfirmPassword")) & _
											", @FirstName=" & MakeSQLText(Request.Form("txtFirstName")) & _
											", @Surname=" & MakeSQLText(Request.Form("txtSurname")) & _
											", @Disable=" & IsDisable & _
											", @CompanyID=" & Request.Form("lstDC")
											
											'response.write SQL
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
		<td class="bheader">Add a New Buyer</td>
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
											' Now we need to add the buyercodes
											' Get the New buyer ID
											NewBuyerID = ReturnSet("NewBuyerID")
											ErrorCount = 0
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Loop through the code fields
											For BuyerCount = 1 to 3
												' Check if the form field is filled in
												if Request.Form("txtBuyerCode" & BuyerCount) <> "" then
													' Build the SQL to delete all the relationships for the selected buyer
													SQL = "exec addBuyerCode @BuyerID=" & NewBuyerID & _
														", @Code=" & MakeSQLText(Request.Form("txtBuyerCode" & BuyerCount))

													' Execute the SQL
													Set ReturnSet = ExecuteSql(SQL, curConnection)
											
													' Check the returnvalue
													if ReturnSet("returnvalue") <> 0 then
														' An error occured - increment the count and set the errormessage
														ErrorCount = ErrorCount + 1
														ErrorText = ErrorText & "BuyerCode <b>" & Request.Form("txtBuyerCode" & BuyerCount) & "</b> was not added successfully.<br>"
													end if
												end if
											Next

											' Close the recordset
											Set ReturnSet = Nothing
											
											' Loop through the Email form fields
											For MailCount = 1 to 3
												' Check if the form field is filled in
												if Request.Form("txtBuyerMail" & MailCount) <> "" then
													' Build the SQL to delete all the relationships for the selected buyer
													SQL = "exec addBuyerMail @BuyerID=" & NewBuyerID & _
														", @EMail=" & MakeSQLText(Request.Form("txtBuyerMail" & MailCount))

													' Execute the SQL
													Set ReturnSet = ExecuteSql(SQL, curConnection)
											
													' Check the returnvalue
													if ReturnSet("returnvalue") <> 0 then
														' An error occured - increment the count and set the errormessage
														ErrorCount = ErrorCount + 1
														ErrorText = ErrorText & "Buyer Email<b> " & Request.Form("txtBuyerCode" & BuyerCount) & "</b> was not added successfully.<br>"
													end if
												end if
											Next
											
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Get the supplier Id's in the supplier assigned list box
											txtSupplier = Request.Form("lstAssign")
												
											SupplierArray = Split(txtSupplier,",")												
	
											' Loop through the Supplier Array
											For Counter = 0 to UBound(SupplierArray)
												' Add the new relationships to the database
												SQL = "exec addRelationship @BuyerID=" & NewBuyerID & _
													", @SupplierID=" & SupplierArray(Counter)

												' Execute the SQL
												Set ReturnSet = ExecuteSql(SQL, curConnection)
													
												' Check the returnvalue
												if ReturnSet("returnvalue") <> 0 then
													' an error occured - increment the errorcount
													ErrorCount = ErrorCount + 1
													ErrorText = ErrorText & "Some of the relationships was nor added successfully.<br>"
												end if
													
												' Close thre recordset
												Set ReturnSet = Nothing
											Next
												
											' Check if there are any errors
											if ErrorCount > 0 then
												' Some errors occured with the supplier assignments
%>
<p class="errortext">Errors</p>
<p class="pcontent"><%=ErrorText%></p>
<br>
<%													
											end if
%>
<p class="pcontent">The Detail for buyer <b><%=Request.Form("txtFirstName") & " " & Request.Form("txtSurname")%></b> has been updated successfully.</p>
<%		
										end if
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
