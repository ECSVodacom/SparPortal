<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
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
										' Declare the variables
										dim SQL
										dim curConnection
										dim ReturnSet
										dim DoAdd
										dim FormAction
										dim txtSupplierID
										dim txtUserName
										dim txtPassword
										dim txtSupplierName
										dim txtSupplierMail
										dim txtAddress
										dim txtDisable
										dim txtVatNumber
										dim txtEANNumber
										dim Counter
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" or isNull(Request.QueryString("id")) then
											DoAdd = True
											FormAction = "doadditem.asp"
											txtSupplierID = 0
											PageTitle = "Add a New Supplier"
											txtSupplierID = 0
											txtUserName = ""
											txtPassword = ""
											txtSupplierName = ""
											txtSupplierMail = ""
											txtAddress = ""
											txtDisable = 0
										else
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit Supplier"
											txtSupplierID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "itemSupplier @SupplierID=" & txtSupplierID
										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
										
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - Display the error message
												ErrorCount = 1
											else
												' No error occured - Continue
												txtUserName = ReturnSet("SupplierUserName")
												txtPassword = ReturnSet("SupplierPassword")
												txtSupplierName = ReturnSet("SupplierName")
												txtAddress = ReturnSet("SupplierAddress")
												txtVatNumber = ReturnSet("SupplierVatNumber")
												txtEANNumber = ReturnSet("SupplierEAN")
												txtDisable = ReturnSet("Disabled")
											end if
											
											' Close the recordset and connection
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/move.js"></script>
<script type="text/javascript" language="JavaScript" src="../includes/calc.js"></script>
<script language="javascript">
<!--
	function valemail(obj) {
		// loop through the line items
		for (var i=1;i<=obj.hidTotalCount.value;i++) {
			// Check if the user supplied a vendor code and email
			if (obj.elements('txtVendorCode' + i).value=='') {
				window.alert ('You have to supply a Vendor Code on line number ' + i);
				obj.elements('txtVendorCode' + i).focus();
				return false;
			};
			if (obj.elements('txtVendorMail' + i).value=='') {
				window.alert ('You have to supply a Vendor E-Mail Address on line number ' + i);
				obj.elements('txtVendorMail' + i).focus();
				return false;
			};
		};
	};

	function validate(obj) {
		// Check if the user entered a username
		if	(obj.txtUserName.value=='') {
				window.alert ('Enter a UserName.');
				obj.txtUserName.focus();
				return false;
		};

		if (obj.hidAction.value == '0') {
			// Check if the user entered a password
			if	(obj.txtPassword.value=='') {
					window.alert ('Enter a password.');
					obj.txtPassword.focus();
					return false;
			};
			
			// Check if the confirm password is = password
			if (obj.txtConfirmPassword.value!=obj.txtPassword.value) {
				window.alert ('Your confirm password does not match your password. Please try again.');
				obj.txtConfirmPassword.focus();
				return false;
			};
		} else {
			if (obj.txtPassword.value!='') {
				if (obj.txtConfirmPassword.value!=obj.txtPassword.value) {
					window.alert ('Your confirm password does not match your password. Please try again.');
					obj.txtConfirmPassword.focus();
					return false;
				};
			};
		};
		// Check if the suppliername is supplied
		if	(obj.txtName.value=='') {
			window.alert ('Enter a Supplier Name.');
			obj.txtName.focus();
			return false;
		};
		// Check if the supplierEAN is supplied
		if	(obj.txtEAN.value=='') {
			window.alert ('Enter a Supplier EAN Number.');
			obj.txtEAN.focus();
			return false;
		};
		// Check if the supplieraddress is supplied
		if	(obj.txtAddress.value=='') {
			window.alert ('Enter a Supplier Address.');
			obj.txtAddress.focus();
			return false;
		};
		for (i = 0; i < obj.lstAssign.options.length; i++) {
			obj.lstAssign.options[i].selected = true;
		};
		return valemail(obj);
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
<%
										if DoAdd Then
%>
		<td class="bheader">Add a New Supplier</td>
<%
										else
%>
		<td class="bheader">Update Supplier Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new supplier.</p>
<%
										else
%>
<p class="pcontent">Below is the detail for supplier <b><%=txtSupplierName%></b>.</p>
<%
										end if
%>
<form name="EditSupplier" id="EditSupplier" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="70%">
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Personal Detail</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellspacing="2" cellpadding="2" width="100%">
							<tr>
								<td class="pcontent"><b>User Name:</b></td>
								<td>&nbsp;</td>
								<td><input type="text" name="txtUserName" id="txtUserName" value="<%=txtUserName%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Password:</b></td>
								<td>&nbsp;</td>
								<td><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Confirm Password:</b></td>
								<td>&nbsp;</td>
								<td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" size="20" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Supplier Name:</b></td>
								<td>&nbsp;</td>
								<td><input type="text" name="txtName" id="txtName" value="<%=txtSupplierName%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Supplier Vat Number:</b></td>
								<td>&nbsp;</td>
								<td><input type="text" name="txtVat" id="txtVat" value="<%=txtVatNumber%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Supplier EAN Number:</b></td>
								<td>&nbsp;</td>
								<td><input type="text" name="txtEAN" id="txtEAN" value="<%=txtEANNumber%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Supplier Address:</b></td>
								<td>&nbsp;</td>
								<td class="pcontent"><textarea rows="5" cols="33" id="txtAddress" name="txtAddress" class="pcontent"><%=txtAddress%></textarea></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Disable Account?</b></td>
								<td>&nbsp;</td>
								<td><input type="checkbox" name="chkDisable" id="chkDisable" <%if txtDisable = 1 then Response.Write "checked" end if%> class="pcontent"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><br>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Link Suppliers</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellspacing="2" cellpadding="2" align="center">
							<tr>
								<td class="pcontent" align="center"><b>Unassigned Suppliers</b></td>
								<th>&nbsp;</th>
								<td class="pcontent" align="center"><b>Assigned Suppliers</b></td>
							</tr>
							<tr>
								<td>
									<select multiple size="10" name="lstUnassign" id="lstUnassign" style="width:200" class="pcontent">
						<%
																' Create a connection
																Set curConnection = Server.CreateObject("ADODB.Connection")
																curConnection.Open const_db_ConnectionString
																		
																' Call the sp - listUnassignSupplier 
																SQL = "exec listUnassignSupplier @SupplierID=" & txtSupplierID
																		
																' Execute the SQL
																Set ReturnSet = ExecuteSql(SQL, curConnection)
																		
																' Check the returnvalue
																if ReturnSet("returnvalue") = 0 Then
																	' There are unassigned suppliers - Loop through the recordset
																	While not ReturnSet.EOF
																		if CInt(ReturnSet("SupplierID")) <> CInt(txtSupplierID) Then
						%>
										<option value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></option>
						<%											
																		end if
																		
																		ReturnSet.MoveNext
																	Wend
																end if
																' Close the recordset
																Set ReturnSet = Nothing
						%>				
									</select>
								</td>
								<td align="center" valign="middle">
									<input type="button" onClick="move(this.form.lstAssign,this.form.lstUnassign)" value="<<" class="button" id=button1 name=button1><br><br>
									<input type="button" onClick="move(this.form.lstUnassign,this.form.lstAssign)" value=">>" class="button" id=button2 name=button2>
								</td>
								<td>
									<select multiple size="10" name="lstAssign" id="lstAssign" style="width:200" class="pcontent">
						<%
																if DoAdd = False Then
																	' Call the sp - listUnassignSupplier 
																	SQL = "exec listAssignSupplier @SupplierID=" & txtSupplierID
																			
																	' Execute the SQL
																	Set ReturnSet = ExecuteSql(SQL, curConnection)
																		
																	' Check the returnvalue
																	if ReturnSet("returnvalue") = 0 Then
																		' There are assigned suppliers - Loop through the recordset
																		While not ReturnSet.EOF
						%>
										<option value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></option>
						<%											
																				ReturnSet.MoveNext
																		Wend
																	end if
																	' Close the recordset
																	Set ReturnSet = Nothing
																end if
						%>						
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<br>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="70%">
				<tr>
					<td class="sheader">Supplier Vendor Details</td>
				</tr>
				<tr>
					<td class="pcontent"><b>Note:</b> If more than one email address, seperate with semicolon(;)</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<th class="tblheader" align="left">Line No</th>
								<th class="tblheader" align="left">Delete?</th>
								<th class="tblheader" align="left">Vendor Code</th>
								<th class="tblheader" align="left">Vendor Name</th>
								<th class="tblheader" align="left">E-Mail Address</th>
							</tr>
						<%	
																' Exec the sp - listVendorDetail
																Set ReturnSet = ExecuteSql("exec listVendorDetail @SupplierID=" & txtSupplierID, curConnection) 
																

																' Check the returnvalue
																if ReturnSet("returnvalue") < 0 Then
																	' No vendors - Set the VendorCode and Email values to blank
																	Counter = 1
						%>
							<tr>
								<td class="tbldata" align="center"><%=Counter%>.</td>
								<td class="tbldata" align="center"><input type="checkbox" name="chkDel1" id="chkDel1" class="pcontent"><input type="hidden" name="txtVendorID1" id="txtVendorID1" value="0"></td>
								<td class="tbldata"><input type="text" name="txtVendorCode1" id="txtVendorCode1" class="pcontent" size="5" maxlength="10"></td>
								<td class="tbldata"><input type="text" name="txtVendorName1" id="txtVendorName1" class="pcontent" size="40" maxlength="50"></td>
								<td class="tbldata"><input type="text" name="txtVendorMail1" id="txtVendorMail1" class="pcontent" size="40" maxlength="100"></td>
							</tr>
						<%	
																else
																	Counter = 0
																	
																	' Loop through the recordset
																	While not ReturnSet.EOF
																		Counter = Counter + 1
						%>
							<tr>
								<td class="tbldata" align="center"><%=Counter%>.</td>
								<td class="tbldata" align="center"><input type="checkbox" name="chkDel<%=Counter%>" id="chkDel<%=Counter%>" class="pcontent"><input type="hidden" name="txtVendorID<%=Counter%>" id="txtVendorID<%=Counter%>" value="<%=ReturnSet("VendorID")%>"></td>
								<td class="tbldata"><input type="text" name="txtVendorCode<%=Counter%>" id="txtVendorCode<%=Counter%>" value="<%=ReturnSet("VendorCode")%>" class="pcontent" size="5" maxlength="10"></td>
								<td class="tbldata"><input type="text" name="txtVendorName<%=Counter%>" id="txtVendorName<%=Counter%>" value="<%=ReturnSet("VendorName")%>" class="pcontent" size="40" maxlength="50"></td>
								<td class="tbldata"><input type="text" name="txtVendorMail<%=Counter%>" id="txtVendorMail<%=Counter%>" value="<%=ReturnSet("VendorMail")%>" class="pcontent" size="40" maxlength="100"></td>
							</tr>
						<%												
																		ReturnSet.MoveNext
																	Wend
																end if
																
																' Close the Recordset
																Set ReturnSet = Nothing
																
																' Close the Connection
																curConnection.Close
																Set curConnection = Nothing
						%>
							<TBODY id="addNew"></TBODY>
							<tr>
								<td colspan="6" align="center">
									<input type="button" name="btnAdd" id="btnAdd" value="Add Line" class="button" onclick="if (valemail(document.EditSupplier) != false) addRows('EditSupplier',document.EditSupplier.hidTotalCount.value)">&nbsp;
									<input type="button" name="btnSelect" id="btnSelect" value="Select All" class="button" onclick="for (var i=1;i<=document.EditSupplier.hidTotalCount.value;i++) document.EditSupplier.elements('chkDel' + i).checked=true">&nbsp;
									<input type="button" name="btnUnSelect" id="btnUnSelect" value="UnSelect All" class="button" onclick="for (var i=1;i<=document.EditSupplier.hidTotalCount.value;i++) document.EditSupplier.elements('chkDel' + i).checked=false">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table><br>
		</td>
	</tr>
	<tr>
		<td><br>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="2" cellspacing="2" align="center">
							<tr>
								<td colspan="3">
									<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
									<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
									<input type="hidden" name="hidSupplierID" id="hidSupplierID" value="<%=txtSupplierID%>">
									<input type="hidden" name="hidAction" id="hidAction" value="<%=txtSupplierID%>">
									<input type="hidden" name="hidTotalCount" id="hidTotalCount" value="<%=Counter%>">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->
