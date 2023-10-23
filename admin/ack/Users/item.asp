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
		top.location.href = "<%=const_app_ApplicationRoot%>/default.asp?urlafter=<%=const_app_ApplicationRoot%>/users/item.asp?id=<%=request.querystring("id")%>";
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
										dim txtUserID
										dim txtUserName
										dim txtPassword
										dim txtFirstName
										dim txtSurname
										dim txtMail
										dim txtPermission
										dim Counter
										dim ErrorCount
										
										' Check if the id was supplied in the querystring
										if Request.QueryString("id") = "" or isNull(Request.QueryString("id")) then
											DoAdd = True
											FormAction = "doadditem.asp"
											txtUserID = 0
											PageTitle = "Add a New User"
											txtUserName = ""
											txtPassword = ""
											txtFirstName = ""
											txtSurname = ""
											txtMail = ""
											txtPermission = 0
										else
											DoAdd = False
											FormAction = "doedititem.asp"
											PageTitle = "Edit User"
											txtUserID = Request.QueryString("id")
										
											' Build the SQL 
											SQL = "exec itemAdminUsers @UserID=" & txtUserID
										
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
												txtSurname = ReturnSet("Surname")
												txtMail = ReturnSet("UserMail")
												txtPermission = ReturnSet("UserPermission")
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
		
		var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
		var charpos = obj.elements['txtMail'].value.indexOf('@');
		var checkcount=0;

		// Ensure that Field Filled in
		if ((obj.elements['txtMail'].value=='')||
			(charpos==-1)||
			(obj.elements['txtMail'].value.indexOf('.', charpos)==-1)||
			(obj.elements['txtMail'].value.indexOf('@', charpos+1)!=-1)||
			(obj.elements['txtMail'].value[obj.elements['txtMail'].length-1]=='.')) {
							
			window.alert('Please enter a valid e-mail address');
			obj.elements['txtMail'].focus();
			return false;
		};
						
		// Ensure that Illegal Characters not Entered
		if (obj.elements['txtMail'].value.search(TestExp)!=-1) {
			window.alert('Please enter a valid e-mail address.');
			obj.elements['txtMail'].focus();
			return false;
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
			// Check if the user entered a password with a length not more than 6 chars
			if	(obj.txtPassword.value.length>8) {
					window.alert ('The Password must not be longer than 8 characters.');
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
				if	(obj.txtPassword.value.length>8) {
						window.alert ('The Password must not be longer than 8 characters.');
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
		// Check if the store ean is supplied
		if	(obj.txtSurname.value=='') {
			window.alert ('Enter a Surname.');
			obj.txtSurname.focus();
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
		<td class="pheader">Users</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/submenu.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
<%
										if DoAdd Then
%>
		<td class="subheader">Add a New User</td>
<%
										else
%>
		<td class="subheader">Update User Detail</td>
<%
										end if
%>
	</tr>
</table>
<%
										if ErrorCount > 0 then
%>
<p class="pcontent">There is no detail for the selected user. Please try again later.</p>
<%										
										else
											if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new User.</p>
<%
											else
%>
<p class="pcontent">Below is the detail for User <b><%=txtFirstName & " " & txtSurname%></b>.</p>
<%
											end if
%>
<form name="EditUser" id="EditUser" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
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
									<td><input type="text" name="txtUserName" id="txtUserName" value="<%=txtUserName%>" size="30" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Password:</b></td>
									<td><input type="password" name="txtPassword" id="txtPassword" size="20" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Confirm Password:</b></td>
									<td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" size="20" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>First Name:</b></td>
									<td><input type="text" name="txtName" id="txtName" value="<%=txtFirstName%>" size="30" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Surname:</b></td>
									<td><input type="text" name="txtSurname" id="txtSurname" value="<%=txtSurname%>" size="30" maxlength="100" class="pcontent"></td>
								</tr>
								<tr>
									<td class="pcontent"><b>Email Address:</b></td>
									<td><input type="text" name="txtMail" id="txtMail" value="<%=txtMail%>" size="30" maxlength="200" class="pcontent"></td>
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
				<legend class="legend"><b>Permissions</b></legend>
				<table border="0" cellpadding="2" cellspacing="0" width="100%">
					<tr>
						<td class="pcontent">Check the relevant checkboxes to allow the admin users permissions</td>
					</tr>
					<tr>
						<td>
							<table border="0" cellspacing="2" cellpadding="2" width="100%">
								<tr>
									<td class="pcontent">
										<input type="checkbox" name="chk1" id="chk1" <%if (CInt(txtPermission) AND 1) = 1 then Response.Write "checked" end if%>>&nbsp;Maintain Admin Users<input type="hidden" name="chkVal1" id="chkVal1" value="1"><br>
										<input type="checkbox" name="chk2" id="chk2" <%if (CInt(txtPermission) AND 2) = 2 then Response.Write "checked" end if%>>&nbsp;Maintain Suppliers<input type="hidden" name="chkVal2" id="chkVal2" value="2"><br>
										<input type="checkbox" name="chk3" id="chk3" <%if (CInt(txtPermission) AND 4) = 4 then Response.Write "checked" end if%>>&nbsp;Searching<input type="hidden" name="chkVal3" id="chkVal3" value="4"><br>
										<input type="checkbox" name="chk4" id="chk4" <%if (CInt(txtPermission) AND 8) = 8 then Response.Write "checked" end if%>>&nbsp;Generate E-Mails<input type="hidden" name="chkVal4" id="chkVal4" value="8"><br>
										<input type="checkbox" name="chk5" id="chk5" <%if (CInt(txtPermission) AND 16) = 16 then Response.Write "checked" end if%>>&nbsp;Do Password Look-ups<input type="hidden" name="chkVal5" id="chkVal5" value="16"><br>
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
											<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
											<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
											<input type="hidden" name="hidUserID" id="hidUserID" value="<%=txtUserID%>">
											<input type="hidden" name="hidAction" id="hidAction" value="<%=txtUserID%>">
											<input type="hidden" name="hidTotal" id="hidTotal" value="5">
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
