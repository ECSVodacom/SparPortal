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
		top.location.href = "<%=const_app_ApplicationRoot%>/default.asp?urlafter=<%=const_app_ApplicationRoot%>/supplier/item.asp?id=<%=request.querystring("id")%>";
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
										dim txtFirstName
										dim txtDisable
										dim txtChangePwd
										dim txtMail
										dim txtPermission
										dim Counter
										dim ErrorCount
										dim txtRollOutMail
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" then
											DoAdd = True
											FormAction = "doadditem.asp"
											txtSupplierID = 0
											PageTitle = "Add a New Supplier"
											txtUserName = ""
											txtPassword = ""
											txtFirstName = ""
											txtMail = ""
											txtDisable = 0
											txtChangePwd = 0
											txtPermission = 0
											txtRollOutMail = ""
										else
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit Supplier"
											txtSupplierID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "exec itemSupplier @SupplierID=" & txtSupplierID
										
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
												txtUserName = ReturnSet("UserName")
												txtPassword = ReturnSet("UserPassword")
												txtFirstName = ReturnSet("FirstName")
												txtMail = ReturnSet("UserMail")
												txtDisable = ReturnSet("Disable")
												txtChangePwd = ReturnSet("ChangePwd")
												txtPermission = ReturnSet("Permission")
												txtRollOutMail = ReturnSet("RollOutMail")
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
		
		//var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
		//var charpos = obj.elements['txtMail'].value.indexOf('@');
		//var checkcount=0;

		// Ensure that Field Filled in
		//if ((obj.elements['txtMail'].value=='')||
		//	(charpos==-1)||
		//	(obj.elements['txtMail'].value.indexOf('.', charpos)==-1)||
		//	(obj.elements['txtMail'].value.indexOf('@', charpos+1)!=-1)||
		//	(obj.elements['txtMail'].value[obj.elements['txtMail'].length-1]=='.')) {
		//					
		//	window.alert('Please enter a valid e-mail address');
		//	obj.elements['txtMail'].focus();
		//	return false;
		//};
		
		if (obj.elements['txtMail'].value == '') {
			window.alert('Please enter a valid e-mail address');
			obj.elements['txtMail'].focus();
			return false;
		};
						
		// Ensure that Illegal Characters not Entered
		//if (obj.elements['txtMail'].value.search(TestExp)!=-1) {
		//	window.alert('Please enter a valid e-mail address.');
		//	obj.elements['txtMail'].focus();
		//	return false;
		//};
	};

	function validate(obj) {
		// Check if the user entered a username
		if (obj.hidAction.value == '0') {
			// Check if the user entered a username
			if	(obj.txtUserName.value=='') {
					window.alert ('Enter a User Name.');
					obj.txtUserName.focus();
					return false;
			};
			// Check if the user entered a password
			if	(obj.txtPassword.value=='') {
					window.alert ('Enter a password.');
					obj.txtPassword.focus();
					return false;
			};
			// Check if the user entered a password with a length not more than 6 chars
			if	(obj.txtPassword.value.length>10) {
					window.alert ('The Password must not be longer than 10 characters.');
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
				// Check if the user entered a password with a length not more than 6 chars
				if	(obj.txtPassword.value.length>6) {
						window.alert ('The Password must not be longer than 6 characters.');
						obj.txtPassword.focus();
						return false;
				};
			
				if (obj.txtConfirmPassword.value!=obj.txtPassword.value) {
					window.alert ('Your confirm password does not match your password. Please try again.');
					obj.txtConfirmPassword.focus();
					return false;
				};
			};
		};
		// Check if the store name is supplied
		if	(obj.txtName.value=='') {
			window.alert ('Enter a First Name.');
			obj.txtName.focus();
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
		<td class="pheader">Suppliers</td>
	</tr>
</table>
<!--include file="../includes/mainmenubar.asp"-->
<%
										if (Session("Permission") AND 2) = 2 then
%>
<!--#include file="includes/submenu.asp"-->
<%
										end if
%>
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
<%
										if DoAdd Then
%>
		<td class="subheader">Add a New Supplier</td>
<%
										else
%>
		<td class="subheader">Update Supplier Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if ErrorCount > 0 then
%>
<p class="pcontent">There is no detail for the selected supplier. Please try again later.</p>
<%										
										else
											if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new Supplier.</p>
<%
											else
%>
<p class="pcontent">Below is the detail for Supplier <b><%=txtFirstName%></b>.</p>
<%
											end if
%>
<form name="EditSupplier" id="EditSupplier" method="post" action="<%=FormAction%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="0" bordercolor="#333366" width="70%">
	<tr>
		<td>
			<fieldset>
				<legend class="legend"><b>Personal Detail</b></legend>
				<table border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td>
							<table border="0" cellspacing="2" cellpadding="2" width="100%">
								<tr>
									<td class="pcontent"><b>User Name:</b></td>
									<td class="pcontent">
<%
											if DoAdd Then
%>									
										<input type="text" name="txtUserName" id="txtUserName" size="20" maxlength="14" class="pcontent">
<%
											else
%>										
									<b><%=txtUserName%></b>
<%
											end if
%>									
								</tr>
<%
											if Not DoAdd Then
%>								
								<tr>
									<td class="pcontent">&nbsp;</td>
									<td class="pcontent" colspan="2"><b>Note:</b> Only add a password and confirm password if you have to change the Supplier's password</td>
								</tr>
<%
											end if
%>								
								<tr>
									<td class="pcontent"><b>Password:</b></td>
									<td><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Confirm Password:</b></td>
									<td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" size="20" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Name:</b></td>
									<td><input type="text" name="txtName" id="txtName" value="<%=txtFirstName%>" size="50" maxlength="255" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent">&nbsp;</td>
									<td class="pcontent" colspan="2"><b>Note:</b> If you need to add multiple addresses, seperate them with a semicolon (;)</td>
								</tr>
								<tr>
									<td class="pcontent"><b>Email Address:</b></td>
									<td><input type="text" name="txtMail" id="txtMail" value="<%=txtMail%>" size="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Rollout Team E-Mail:</b></td>
									<td><input type="text" name="txtRollMail" id="txtRollMail" value="<%=txtRollOutMail%>" size="100" maxlength="800" class="pcontent"></td>
								</tr>								
								<tr>
									<td class="pcontent"><b>Disable Account:</b></td>
									<td>
										<input type="checkbox" name="chkDisable" id="chkDisable" class="pcontent" value="<%=txtDisable%>" <%if txtDisable = 1 then Response.Write "checked" end if%> onclick="if (document.EditSupplier.chkDisable.checked==true) { document.EditSupplier.hidDisable.value=1 } else { document.EditSupplier.hidDisable.value=0};">
										<input type="hidden" name="hidDisable" id="hidDisable" value="<%=txtDisable%>">
									</td>
								</tr>
								<tr>
									<td class="pcontent"><b>Change Pwd:</b></td>
									<td>
										<input type="checkbox" name="chkPwdChange" id="chkPwdChange" class="pcontent" value="<%=txtChangePwd%>" <%if txtChangePwd = 1 then Response.Write "checked" end if%> onclick="if (document.EditSupplier.chkPwdChange.checked==true) { document.EditSupplier.hidPwdChange.value=1 } else { document.EditSupplier.hidPwdChange.value=0};">
										<input type="hidden" name="hidPwdChange" id="hidPwdChange" value="<%=txtChangePwd%>">
									</td>
								</tr>
								<tr>
									<td class="pcontent"><b>Enable PFO:</b></td>
									<td>
										<input type="checkbox" name="chkPFO" id="chkPFO" class="pcontent" <%if (txtPermission AND 1) = 1 then Response.Write "checked" end if%> onclick="if (document.EditSupplier.chkPFO.checked==true) { document.EditSupplier.hidPFO.value=1 } else { document.EditSupplier.hidPFO.value=0};">
										<input type="hidden" name="hidPFO" id="hidPFO" value="1">
									</td>
								</tr>		
								<tr>
									<td class="pcontent"><b>Enable QA:</b></td>
									<td>
										<input type="checkbox" name="chkQA" id="chkQA" class="pcontent" <%if (txtPermission AND 2) = 2 then Response.Write "checked" end if%> onclick="if (document.EditSupplier.chkQA.checked==true) { document.EditSupplier.hidQA.value=2 } else { document.EditSupplier.hidQA.value=2};">
										<input type="hidden" name="hidQA" id="hidQA" value="2">
									</td>
								</tr>								
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
	<tr>
		<td><br>
			<fieldset>
				<legend class="legend"><b>Submition</b></legend>
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<td>
								<table border="0" cellpadding="2" cellspacing="2" align="center">
									<tr>
										<td colspan="3">
											<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button" <%if (Session("Permission") AND 2) <> 2 then Response.Write "disabled=true" end if%>>&nbsp;
											<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button" <%if (Session("Permission") AND 2) <> 2 then Response.Write "disabled=true" end if%>>
											<input type="hidden" name="hidSupplierID" id="hidSupplierID" value="<%=txtSupplierID%>">
											<input type="hidden" name="hidAction" id="hidAction" value="<%=txtSupplierID%>">
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</fieldset>
		</td>
	</tr>
</table>
</form>
<%
										end if
%>
<!--#include file="../layout/end.asp"-->
