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
										dim txtStoreID
										dim txtUserName
										dim txtPassword
										dim txtStoreName
										dim txtStoreMail
										dim txtAddress
										dim txtDisable
										dim txtStoreEAN
										dim txtStorePhone
										dim txtStoreFax
										dim txtStoreCode
										dim txtIsLive
										dim txtDCID
										dim Counter
										dim ErrorCount
										dim strType
										dim txtOwner
										dim	txtManager
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" or isNull(Request.QueryString("id")) or  Request.QueryString("id") = "0" then
											strType = 0
											DoAdd = True
											FormAction = "doadditem.asp"
											txtStoreID = 0
											PageTitle = "Add a New Store"
											txtUserName = ""
											txtPassword = ""
											txtDisable = 0
											txtStoreEAN = Request.QueryString("storeean")
											txtStoreCode = ""
											txtIsLive = 0
											txtDCID = Request.QueryString("dcid")
											txtManager = ""
											
											if Request.QueryString("messid") <> "0" then
												' Create a connection
												Set curConnection = Server.CreateObject("ADODB.Connection")
												curConnection.Open const_db_ConnectionString
												
												' Execute the SQL
												Set ReturnSet =   ExecuteSql("exec itemMessageException @MessID=" & Request.QueryString("messid"), curConnection)    
												
												txtStoreName = ReturnSet("StoreName")
												txtStoreMail = ReturnSet("StoreMail")
												txtAddress = ReturnSet("StoreAddress")
												txtStorePhone = ReturnSet("TelNo")
												txtStoreFax = ReturnSet("FaxNo")
												txtOwner= ReturnSet("Contact")
												
												Set ReturnSet = Nothing
												curConnection.Close
											else
												txtStoreName = Request.QueryString("storename")
												txtStoreMail = Request.QueryString("storemail")
												txtAddress = ""
												txtStorePhone = ""
												txtStoreFax = ""
												txtOwner= ""
											end if
											
										else
											strType = 1
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit Store"
											txtStoreID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "exec itemStore @StoreID=" & txtStoreID
										
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
												txtUserName = ReturnSet("StoreUserName")
												txtPassword = ReturnSet("StorePassword")
												txtStoreName = ReturnSet("StoreName")
												txtAddress = ReturnSet("StoreAddress")
												txtDisable = ReturnSet("Disabled")
												txtStoreEAN = ReturnSet("StoreEAN")
												txtStorePhone = ReturnSet("StorePhone")
												txtStoreFax = ReturnSet("StoreFax")
												txtStoreCode = ReturnSet("StoreCode")
												txtIsLive = ReturnSet("IsLive")
												txtDCID = ReturnSet("DCID")
												txtOwner= ReturnSet("StoreOwner")
												txtManager = ReturnSet("StoreManager")
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
<script type="text/javascript" language="JavaScript" src="../includes/calc1.js"></script>
<script language="javascript">
<!--
	function valemail(obj) {
		// loop through the line items
		for (var i=1;i<=obj.hidTotalCount.value;i++) {
			// Check if the user supplied an email
			/*if (obj.elements('txtStoreMail' + i).value=='') {
				window.alert ('You have to supply a Store E-Mail Address on line number ' + i);
				obj.elements('txtStoreMail' + i).focus();
				return false;
			};*/
			
			var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
			var charpos = obj.elements['txtStoreMail' + i].value.indexOf('@');
			var checkcount=0;
			if (obj.elements['txtStoreMail' + i].value!='') {
				checkcount++;
			};
			//if (obj.elements['txtStoreMail' + 1].value=='') {
				// Ensure that Field Filled in
				if ((obj.elements['txtStoreMail' + i].value=='')||
					(charpos==-1)||
					(obj.elements['txtStoreMail' + i].value.indexOf('.', charpos)==-1)||
					(obj.elements['txtStoreMail' + i].value.indexOf('@', charpos+1)!=-1)||
					(obj.elements['txtStoreMail' + i].value[obj.elements['txtStoreMail' + i].length-1]=='.')) {
							
					window.alert('Please enter a valid e-mail address');
					obj.elements['txtStoreMail' + i].focus();
					return false;
				};
						
				// Ensure that Illegal Characters not Entered
				if (obj.elements['txtStoreMail' + i].value.search(TestExp)!=-1) {
					window.alert('Please enter a valid e-mail address.');
					obj.elements['txtStoreMail' + i].focus();
					return false;
				};
			//};
		};
		
		if (checkcount==0) {
			window.alert('You have to enter at least one email address.');
			obj.elements['txtStoreMail' + 1].focus();
			return false;
		};
	};

	function validate(obj) {
		if (obj.hidType.value!='0') {
			// Check if the user entered a username
			if	(obj.txtUserName.value=='') {
					window.alert ('Enter a UserName.');
					obj.txtUserName.focus();
					return false;
			};
		};
		if (obj.hidType.value != '0') {
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
			if (obj.hidType.value!='0') {
				if (obj.txtPassword.value!='') {
					if (obj.txtConfirmPassword.value!=obj.txtPassword.value) {
						window.alert ('Your confirm password does not match your password. Please try again.');
						obj.txtConfirmPassword.focus();
						return false;
					};
				};
			};
		};
		// Check if the store name is supplied
		if	(obj.txtName.value=='') {
			window.alert ('Enter a Store Name.');
			obj.txtName.focus();
			return false;
		};
		// Check if the store ean is supplied
		if	(obj.txtEAN.value=='') {
			window.alert ('Enter a Store EAN Number.');
			obj.txtEAN.focus();
			return false;
		};
		// Check if the store code is supplied
		if	(obj.txtCode.value=='') {
			window.alert ('Enter a Store Code.');
			obj.txtCode.focus();
			return false;
		};
		// Check if the Telephone Number is supplied
		if	(obj.txtTel.value=='') {
			window.alert ('Enter a Store Telephone Number.');
			obj.txtTel.focus();
			return false;
		};
		// Check if the Fax Number is supplied
		if	(obj.txtFax.value=='') {
			window.alert ('Enter a Store Fax Number.');
			obj.txtFax.focus();
			return false;
		};
		// Check if the storeraddress is supplied
		if	(obj.txtAddress.value=='') {
			window.alert ('Enter a Store Address.');
			obj.txtAddress.focus();
			return false;
		};
		// Check if the dc is selected
		if	(obj.drpDC.value=='') {
			window.alert ('Select a Distribution Centre.');
			obj.drpDC.focus();
			return false;
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
		<td class="bheader">Add a New Store</td>
<%
										else
%>
		<td class="bheader">Update Store Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if ErrorCount > 0 then
%>
<p class="pcontent">There is no detail for the selected store. Please try again later.</p>
<%										
										else
											if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new store.</p>
<%
											else
%>
<p class="pcontent">Below is the detail for store <b><%=txtStoreName%></b>.</p>
<%
											end if
%>
<form name="EditStore" id="EditStore" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>&type=<%=Request.QueryString("type")%>" onsubmit="return validate(this);">
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
<%
											if Request.QueryString("type") = "1" then
%>
							<tr>
								<td>
									<input type="hidden" name="txtUserName" id="txtUserName" value="<%=txtUserName%>">
									<input type="hidden" name="txtPassword" id="txtPassword" value="<%=txtPassword%>">
									<input type="hidden" name="txtConfirmPassword" id="txtConfirmPassword" value="<%=txtPassword%>">
								</td>
							</tr>
<%											
											else
%>
							<tr>
								<td class="pcontent"><b>User Name:</b></td>
								<td><input type="text" name="txtUserName" id="txtUserName" value="<%=UCase(txtUserName)%>" size="30" maxlength="100" class="pcontent" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Password:</b></td>
								<td><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="100" class="pcontent" value="<%=txtPassword%>"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Confirm Password:</b></td>
								<td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" size="20" maxlength="100" class="pcontent" value="<%=txtPassword%>"></td>
							</tr>
<%
											end if
%>							
							<tr>
								<td class="pcontent"><b>Store Name:</b></td>
								<td><input type="text" name="txtName" id="txtName" value="<%=UCase(txtStoreName)%>" size="30" maxlength="100" class="pcontent" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store EAN Number:</b></td>
								<td><input type="text" name="txtEAN" id="txtEAN" value="<%=txtStoreEAN%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Code:</b></td>
								<td><input type="text" name="txtCode" id="txtCode" value="<%=txtStoreCode%>" size="10" maxlength="10" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Telephone Number:</b></td>
								<td><input type="text" name="txtTel" id="txtTel" value="<%=txtStorePhone%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Fax Number:</b></td>
								<td><input type="text" name="txtFax" id="txtFax" value="<%=txtStoreFax%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Address:</b></td>
								<td class="pcontent"><textarea rows="5" cols="33" id="txtAddress" name="txtAddress" class="pcontent" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"><%=UCase(txtAddress)%></textarea></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Owner:</b></td>
								<td><input type="text" name="txtOwner" id="txtOwner" value="<%=UCase(txtOwner)%>" size="30" maxlength="100" class="pcontent" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Store Manager:</b></td>
								<td><input type="text" name="txtManager" id="txtManager" value="<%=UCase(txtManager)%>" size="30" maxlength="100" class="pcontent" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Status</b></td>
								<td class="pcontent">
									<select name="chkLive" id="chkLive" class="pcontent">
										<option <%if CInt(txtIsLive) = 0 then Response.Write "selected" end if%> value="0">Not Live</option>
										<option <%if CInt(txtIsLive) = 1 then Response.Write "selected" end if%> value="1">Live</option>
										<option <%if CInt(txtIsLive) = 2 then Response.Write "selected" end if%> value="2">Test</option>
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
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Link Store to a Distribution Centre</td>
				</tr>
				<tr>
					<td><br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td class="pcontent"><b>Select a Distribution Centre</b></td>
								<td class="pcontent">
									<select name="drpDC" id="drpDC" class="pcontent">
										<option id="0"> -- Select -- </option>
<%
											if Session("UserName") = "SPARHEADOFFICE" OR Session("UserName") = "GATEWAYCALLCEN" then
%>									
										<option <%if txtDCID = 1 then Response.Write "selected" end if%> value="1">SPAR SOUTH RAND</option>
										<option <%if txtDCID = 2 then Response.Write "selected" end if%> value="2">SPAR NORTH RAND</option>
										<option <%if txtDCID = 3 then Response.Write "selected" end if%> value="3">SPAR KZN</option>
										<option <%if txtDCID = 4 then Response.Write "selected" end if%> value="4">SPAR EASTERN CAPE</option>
										<option <%if txtDCID = 5 then Response.Write "selected" end if%> value="5">SPAR WESTERN CAPE</option>
<%
											else
												Select Case txtDCID
												Case 1
%>
										<option selected value="1">SPAR SOUTH RAND</option>
<%											
												Case 2
%>
										<option selected value="2">SPAR NOTH RAND</option>
<%											
												Case 3
%>
										<option selected value="3">SPAR KZN</option>
<%											
												Case 4
%>
										<option selected value="4">SPAR EASTERN CAPE</option>
<%											
												Case 5
%>
										<option selected value="5">SPAR WESTERN CAPE</option>
<%											
												Case Else
%>
										<option value="1">SPAR SOUTH RAND</option>
										<option value="2">SPAR NORTH RAND</option>
										<option value="3">SPAR KZN</option>
										<option value="4">SPAR EASTERN CAPE</option>
										<option value="5">SPAR WESTERN CAPE</option>											
<%										
												End Select
											end if
%>										
									</select>
								</td>
							</tr>
						</table><br>
					</td>
				</tr>
			</table><br>
		</td>
	</tr>
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td class="sheader">Store Email Addresses</td>
				</tr>
				<tr>
					<td><br>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th class="tblheader" align="center">Line No</th>
								<th class="tblheader" align="center">Delete?</th>
								<th class="tblheader" align="center">E-Mail Address</th>
							</tr>
						<%	
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
																
											' Exec the sp - listStoreMail
											Set ReturnSet = ExecuteSql("exec listStoreMail @StoreID=" & txtStoreID, curConnection)     

											' Check the returnvalue
											if ReturnSet("returnvalue") < 0 Then
												' No email address
												Counter = 1
						%>
							<tr>
								<td class="tbldata" align="center"><%=Counter%>.</td>
								<td class="tbldata" align="center"><input type="checkbox" name="chkDel1" id="chkDel1" class="pcontent"><input type="hidden" name="txtMailID1" id="txtMailID1" value="1"></td>
								<td class="tbldata"><input type="text" name="txtStoreMail1" id="txtStoreMail1" class="pcontent" size="40" maxlength="100" value="<%=UCase(txtStoreMail)%>" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
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
								<td class="tbldata" align="center"><input type="checkbox" name="chkDel<%=Counter%>" id="chkDel<%=Counter%>" class="pcontent"><input type="hidden" name="txtMailID<%=Counter%>" id="txtMailID<%=Counter%>" value="<%=ReturnSet("MailID")%>"></td>
								<td class="tbldata"><input type="text" name="txtStoreMail<%=Counter%>" id="txtStoreMail<%=Counter%>" value="<%=UCase(ReturnSet("StoreMail"))%>" class="pcontent" size="40" maxlength="100" onkeyup="javascript:this.value=this.value.toUpperCase();" onkeydown="javascript:this.value=this.value.toUpperCase();"></td>
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
								<td colspan="6" align="center"><br>
									<input type="button" name="btnAdd" id="btnAdd" value="Add Line" class="button" onclick="if (valemail(document.EditStore) != false) addRows('EditStore',document.EditStore.hidTotalCount.value)">&nbsp;
									<input type="button" name="btnSelect" id="btnSelect" value="Select All" class="button" onclick="for (var i=1;i<=document.EditStore.hidTotalCount.value;i++) document.EditStore.elements('chkDel' + i).checked=true">&nbsp;
									<input type="button" name="btnUnSelect" id="btnUnSelect" value="UnSelect All" class="button" onclick="for (var i=1;i<=document.EditStore.hidTotalCount.value;i++) document.EditStore.elements('chkDel' + i).checked=false">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table><br>
		</td>
	</tr>
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#4C8ED7" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="2" cellspacing="2" align="center">
							<tr>
								<td colspan="3">
									<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
									<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
									<input type="hidden" name="hidStoreID" id="hidStoreID" value="<%=txtStoreID%>">
									<input type="hidden" name="hidAction" id="hidAction" value="<%=txtStoreID%>">
									<input type="hidden" name="hidTotalCount" id="hidTotalCount" value="<%=Counter%>">
									<input type="hidden" name="hidType" id="hidType" value="<%=strType%>">
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
<%
										end if
%>
<!--#include file="../layout/end.asp"-->
