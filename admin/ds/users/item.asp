<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/generatepassword.asp"-->
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
										dim txtFirstName
										dim txtSurname
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
										dim txtUserID
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" or isNull(Request.QueryString("UserID")) then
											DoAdd = True
											FormAction = "doadditem.asp"
											txtStoreID = 0
											PageTitle = "Add a New Store"
											txtUserName = ""
											txtPassword = ""
											txtStoreName = ""
											txtStoreMail = ""
											txtAddress = ""
											txtDisable = 0
											txtStoreEAN = ""
											txtStorePhone = ""
											txtStoreFax = ""
											txtStoreCode = ""
											txtIsLive = 0
											txtDCID = 0
										else
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit Store"
											txtUserID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "exec itemUser @UserID=" & Request.QueryString("id")
										'response.write SQL
										'response.end
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
										
											' Execute the SQL
											Set ReturnSet = curConnection.Execute (SQL)
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - Display the error message
												ErrorCount = 1
											else
												' No error occured - Continue
												txtFirstName = ReturnSet("FirstName")
												txtSurname = ReturnSet("Surname")
												txtPassword = ReturnSet("Password")
												txtUserName = ReturnSet("UserName")
												txtDCID = ReturnSet("DCID")
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

	//function validate(obj) {
		// Check if the user entered a username
	//	if	(obj.txtUserName.value=='') {
	//			window.alert ('Enter a UserName.');
	//			obj.txtUserName.focus();
	//			return false;
	//	};

		if (obj.hidAction.value == '0') {
			// Check if the user entered a password
			if	(obj.txtPassword.value=='') {
					window.alert ('Enter a password.');
					obj.txtPassword.focus();
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
		<td class="bheader">Add a new User</td>
<%
										else
%>
		<td class="bheader">Update User Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if ErrorCount > 0 then
%>
<p class="pcontent">There is no detail for the selected User. Please try again later.</p>
<%										
										else
											if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new user.</p>
<%
											else
%>
<p class="pcontent">Below is the detail for store <b><%=txtStoreName%></b>.</p>
<%
											end if
%>
<form name="EditStore" id="EditStore" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="0" bordercolor="#333366" width="70%">
	<tr>
		<td>
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#333366" width="100%">
				<tr>
					<td class="sheader">Personal Detail</td>
				</tr>
				<tr>
					<td>
						<table border="0" cellspacing="2" cellpadding="2" width="100%">
							<tr>
								<td class="pcontent"><b>First Name:</b></td>
								<td><input type="text" name="txtFirstName" id="txtUserName" value="<%=txtFirstName%>" size="30" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Surname:</b></td>
								<td><input type="text" name="txtSurname" id="txtSurname" value="<%=txtSurname%>" size="20" maxlength="100" class="pcontent"></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Username:</b></td>
								<td><input type="text" name="txtUserName" id="txtUserName"  value="<%=txtUserName%>" size="20" maxlength="100" class="pcontent" disabled ></td>
							</tr>
							
						<%
							dim GeneratedPassword
							dim Password
							dim ReadonOnlyPassword
							
							if txtPassword <> "" then
								Password = txtPassword
								ReadonOnlyPassword = "false"
							else
								Password = GeneratePassword()
								ReadonOnlyPassword = "true"
							end if
							
							
							
						%>	
						
							<tr>
								<td class="pcontent"><b>Password:</b></td>
								<td><input type="text" name="txtPassword" id="txtPassword" value="<%=Password%>" size="20" maxlength="100" class="pcontent" readonly="<%if ReadonOnlyPassword = "true" then response.write "true" else response.write "false"%>" ></td>
							</tr>
							<tr>
								<td class="pcontent"><b>Confirm Password:</b></td>
								<td><input type="text" name="txtConfirmPassword" id="txtConfirmPassword"  value="<%=Password%>" size="20" maxlength="100" class="pcontent" readonly="<%if ReadonOnlyPassword = "true" then response.write "true" else response.write "false"%>"></td>
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
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#333366" width="100%">
				<tr>
					<td class="sheader">Link User to a Distribution Centre</td>
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
										<option <%if txtDCID = 8 then Response.Write "selected" end if%> value="8">SPAR LOWVELD</option>
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
												Case 8
%>
										<option selected value="8">SPAR LOWVELD</option>
<%

												Case Else
%>
										<option value="1">SPAR SOUTH RAND</option>
										<option value="2">SPAR NORTH RAND</option>
										<option value="3">SPAR KZN</option>
										<option value="4">SPAR EASTERN CAPE</option>
										<option value="5">SPAR WESTERN CAPE</option>											
										<option value="8">SPAR LOWVELD</option>											
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
			<table border="1" cellpadding="2" cellspacing="0" bordercolor="#333366" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="2" cellspacing="2" align="center">
							<tr>
								<td colspan="3">
									<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
									<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
									<input type="hidden" name="hidUserID" id="hidUserID" value="<%=txtUserid%>">
									<input type="hidden" name="hidAction" id="hidAction" value="<%=txtUserid%>">
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
<%
										end if
%>
<!--#include file="../layout/end.asp"-->
