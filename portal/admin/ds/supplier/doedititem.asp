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
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
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
										dim IsDisable
										dim ErrorCount
										dim SupplierArray
										dim Counter
										dim txtSupplier
										dim IsLive
										dim DoDelete
										Dim UserType
										Dim Integrated
										
										' Check if the user disabled the selected buyer
										if Request.Form("chkDisable") = "checked" or Request.Form("chkDisable") = "on" Then
											IsDisable = 1
										else
											IsDisable = 0
										end if
										
										if Request.Form("chkIntegrate") = "checked" or Request.Form("chkIntegrate") = "on" Then
											Integrated = 1
										else
											Integrated = 0
										end if
										
										If Request.Form("chkDropshipmentSupplier") = "checked" Or Request.Form("chkDropshipmentSupplier") = "on" Then
											UserType = 4
										Else 
											UserType = 1
										End If
										
										' Build the SQL for updating the User detail
										SQL = "exec editSupplier @SupplierID=" & Request.Form("hidSupplierID") & _
											", @UserName=" & MakeSQLText(Request.Form("txtUserName")) & _
											", @Password=" & MakeSQLText(Request.Form("txtPassword")) & _
											", @SupplierName=" & MakeSQLText(Request.Form("txtName")) & _
											", @SupplierEAN=" & MakeSQLText(Request.Form("txtEAN")) & _
											", @SupplierVatNo=" & MakeSQLText(Request.Form("txtVat")) & _
											", @SupplierAddress=" & MakeSQLText(Request.Form("txtAddress")) & _
											", @Disable=" & IsDisable & _
											", @UserType=" & UserType & _
											", @Comments=" & MakeSQLText(Request.Form("txtComments")) & _
											", @Integrated=" & Integrated
										' Set the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										'response.write curConnection
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
		<td class="bheader">Update Supplier Detail</td>
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
											' Now we need to update the supplier relationships
											' Close the recordset
											Set ReturnSet = Nothing
											
											' Call the sp - delLinkedSuppliers
											Set ReturnSet = curConnection.Execute ("exec delLinkedSuppliers @SupplierID=" & Request.Form("hidSupplierID"))
											' Close the Recordset
											Set ReturnSet = Nothing
											
											' Get the list of assigned suppliers
											Assign = Split(Request.Form("lstAssign"),",")
											
											' Loop through the Assign array
											For AsCount = 0 to UBound(Assign)
												' Call the sp - editLinkedSuppliers
												SQL = "exec editLinkedSuppliers	@ParentSupplierID=" & Request.Form("hidSupplierID") & _
													", @ChildSupplierID=" & Assign(AsCount)
												
												' Execute the SQL	
												Set ReturnSet = curConnection.Execute (SQL)	
											Next
											
											' Close the Recordset
											Set ReturnSet = Nothing
											
											ErrorCount = 0
											DoDelete = 0
											VendorID = 0
											
											' Loop through the Store Emails
											For Counter = 1 to Request.Form("hidTotalCount")
												' Check if must delete
												if Request.Form("chkDel" & Counter) = "checked" or Request.Form("chkDel" & Counter) = "on" then
													DoDelete = 1
												else
													DoDelete = 0
												end if
												
												VendorID = Request.Form("txtVendorID" & Counter)
												
												' Check if the User is adding or updating vendors
												if Request.Form("txtVendorID" & Counter) <> "0" then
													' Edit thew Vendor details
													SQL = "exec editVendorDetail @VendorID=" & VendorID & _
														", @VendorCode=" & MakeSQLText(Request.Form("txtVendorCode" & Counter)) & _
														", @VendorName=" & MakeSQLText(Request.Form("txtVendorName" & Counter)) & _
														", @Delete=" & DoDelete
												else
													' Add a new vendor
													SQL = "exec addVendorDetail @SupplierID=" & Request.Form("hidSupplierID") & _
														", @VendorCode=" & MakeSQLText(Request.Form("txtVendorCode" & Counter)) & _
														", @VendorName=" & MakeSQLText(Request.Form("txtVendorName" & Counter))
												end if

												' Execute the SQL
												Set ReturnSet = curConnection.Execute (SQL)
													
												' Check the returnvalue
												if ReturnSet("returnvalue") <> 0 then
													ErrorCount = ErrorCount + 1
												else
													' no errors occured - start updating the email addresses
													' Check if the VendorID is zero
													if VendorID = 0 then
														VendorID = ReturnSet("NewVendorID")
													end if
													
													' Close the Recordset
													Set ReturnSet = Nothing
													
													' Check if the user did not select to delete the vendor
													if DoDelete = 0 then
														' Remove the Email Addresses for the selected vendor
														Set ReturnSet = curConnection.Execute ("exec delVendorMail @VendorID=" & VendorID)
													
														' Close the Recordset
														Set ReturnSet = Nothing
														
														' Set the email address to an array
														MailArray = Split(Request.Form("txtVendorMail" & Counter),";")
													
														' Loop through the MailArray
														For MailCount = 0 to UBound(MailArray)
															' Call the SP - editVendorMail
															SQL = "exec editVendorMail @VendorID=" & VendorID & _
																", @VendorMail=" & MakeSQLText(MailArray(MailCount))
															
															' Exec the SQL
															Set ReturnSet = curConnection.Execute (SQL)
															
															' Close thre recordset
															Set ReturnSet = Nothing
														Next
													end if
												end if
											Next
%>
<p class="pcontent">The Detail for Supplier <b><%=Request.Form("txtName")%></b> has been updated successfully.</p>
<%													
											' Check if there are any errors
											if ErrorCount > 0 then
												' Some errors occured with the supplier assignments
%>
<p class="pcontent"><b>NOTE:</b>Some errors occured during the process of adding, updating or deleting the linked suppliers and vendors.<br><br>
	Please <a class="stextnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=Request.Form("hidSupplierID")%>"> return to the previous page and try again.</a></p>
<%													
											end if
%>
<p class="pcontent"><b>Option:</b>
	<ul>
		<li class="pcontent"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=Request.Form("hidSupplierID")%>">View Changes made</a></li>
	</ul>
</p>
<%											
										end if
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>										
<!--#include file="../layout/end.asp"-->
