<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
	' Author & Date: Chris Kennedy, 02 Sept 2002
	' Purpose: This page will update then relationships for the selected buyer.
					
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Set the page header
										PageTitle = "Add a New Supplier"
										
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
										dim IsIntegrate
										dim ErrorCount
										dim ErrorText
										dim SupplierArray
										dim Counter
										dim txtSupplier
										dim NewSupplierID
										dim SupplierCount
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if

										' Build the SQL for updating the User detail
										SQL = "exec addSupplier @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @Password=" & MakeSQLText(Request.Form("txtConfirmPassword")) & _
											", @Name=" & MakeSQLText(Request.Form("txtName")) & _
											", @Email=" & MakeSQLText(Request.Form("txtMail")) & _
											", @Address=" & MakeSQLText(Request.Form("txtAddress")) & _
											", @Disable=" & IsDisable & _
											", @SupplierCode=" & MakeSQLText(Request.Form("txtSupplierCode1")) & _
											", @Comments='" & Replace(Request.Form("txtComments"),"'","''") & "'" 
											
											'response.write SQL
											'response.end

										' Set the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
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
		<td class="bheader">Add a New Supplier</td>
	</tr>
</table>
<!--#include file="includes/subsuppliermenu.asp"-->
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
											' Now we need to add the suppliercodes
											' Get the New supplier ID
											NewSupplierID = ReturnSet("NewSupplierID")
											ErrorCount = 0
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Loop through the code fields
											For SupplierCount = 1 to 3
				
										If Request.Form("chkIntegrated" & Counter) = "checked" or Request.Form("chkIntegrated" & SupplierCount) = "on" Then
											IsIntegrated = 1
										else
											IsIntegrated = 0
										End If
										
												' Check if the form field is filled in
												if Request.Form("txtSupplierCode" & SupplierCount) <> "" then
													' Build the SQL to delete all the relationships for the selected buyer
													SQL = "exec addSupplierCode @SupplierID=" & NewSupplierID & _
														", @Code=" & MakeSQLText(Request.Form("txtSupplierCode" & SupplierCount)) & _
														", @Integrated=" & IsIntegrated
											'response.write SQL
											'response.end
											
													' Execute the SQL
													Set ReturnSet = curConnection.Execute (SQL)
											
													' Check the returnvalue
													if ReturnSet("returnvalue") <> 0 then
														' An error occured - increment the count and set the errormessage
														ErrorCount = ErrorCount + 1
														ErrorText = ErrorText & "Supplier EAN Number <b>" & Request.Form("txtSupplierCode" & SupplierCount) & "</b> was not added successfully.<br>"
													end if
												end if
												
												' Close the recordset
												Set ReturnSet = Nothing
											Next
											%>
<p class="pcontent">The Detail for Supplier <b><%=Request.Form("txtName")%></b> has been added successfully.</p>
<%
										end if
										
											
										' Check if there are any errors
										if ErrorCount > 0 then
											' Some errors occured with the supplier codes
%>
<p class="errortext">Errors</p>
<p class="pcontent"><%=ErrorText%></p>
<br>
<%													
										end if
	
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
