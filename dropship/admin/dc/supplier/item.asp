<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the User is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")

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
										
											' Build the SQL 
											SQL = "exec itemSupplier @SPID=" & Request.QueryString("id")
										
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
												txtSupplierID = ReturnSet("SupplierID")
												txtUserName = ReturnSet("UserName")
												txtPassword = ReturnSet("UserPassword")
												txtSupplierName = ReturnSet("SupplierName")
												txtSupplierMail = ReturnSet("SupplierMail")
												txtAddress = ReturnSet("SupplierAddr")
												txtDisable = ReturnSet("Disable")
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
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user entered a username
		if	(obj.txtUserName.value=='') {
				window.alert ('Please enter a UserName.');
				obj.txtUserName.focus();
				return false;
		};

		if (obj.hidAction.value == '0') {
			// Check if the user entered a password
			if	(obj.txtPassword.value=='') {
					window.alert ('Please enter a password.');
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
			window.alert ('Please enter a supplier name.');
			obj.txtName.focus();
			return false;
		};
		
		var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
		var charpos = obj.txtMail.value.indexOf('@');
		var checkcount=0;
		if (obj.txtMail.value=='') {
			checkcount++;
		};
		if (obj.txtMail.value=='') {
			// Ensure that Field Filled in
			if ((obj.txtMail.value=='')||
				(charpos==-1)||
				(obj.txtMail.value.indexOf('.', charpos)==-1)||
				(obj.txtMail.value.indexOf('@', charpos+1)!=-1)||
				(obj.txtMail.value[obj.txtMail.length-1]=='.')) {
							
				window.alert('Please enter a valid e-mail address');
				obj.txtMail.focus();
				return false;
			};
						
			// Ensure that Illegal Characters not Entered
			if (obj.txtMail.value.search(TestExp)!=-1) {
				window.alert('Please enter a valid e-mail address.');
				obj.txtMail.focus();
				return false;
			};
		};
		
		// Check if the suppliername is supplied
		if	(obj.txtAddress.value=='') {
			window.alert ('Please enter a supplier address.');
			obj.txtAddress.focus();
			return false;
		};
		
		if (obj.hidAction.value == '0') {
			for (var i=1;i<=3;i++) {
				// Check if the suppliercode is supplied
				if	((obj.txtSupplierCode1.value=='')&&(obj.txtSupplierCode2.value=='')&&(obj.txtSupplierCode3.value=='')) {
					window.alert ('You have to supply at least one supplier EAN Number.');
					obj.txtSupplierCode1.focus();
					return false;
				};
			};
		};
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
<!--#include file="includes/subsuppliermenu.asp"-->
<p class="pcontent">Below is the detail for supplier <b><%=txtSupplierName%></b>.</p>
<%
										end if
%>
<p class="sheader">Personal Detail</p>
<form name="EditSupplier" id="EditSupplier" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellspacing="2" cellpadding="2">
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
		<td class="pcontent"><b>Supplier Name:</b></td>
		<td><input type="text" name="txtName" id="txtName" value="<%=txtSupplierName%>" size="30" maxlength="100" class="pcontent"></td>
	</tr>
	<tr>
			<td>&nbsp;</td>
			<td class="pcontent" colspan="2">Seperate e-mail addresses with a semicolon (;), if more than one e-mail address is added.</td>
	</tr>
	<tr>
		<td class="pcontent"><b>Supplier Email:</b></td>
		<td><input type="text" name="txtMail" id="txtMail" value="<%=txtSupplierMail%>" size="30" maxlength="8000" class="pcontent"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>Supplier Address:</b></td>
		<td class="pcontent"><textarea rows="5" cols="25" id="txtAddress" name="txtAddress" class="pcontent"><%=txtAddress%></textarea></td>
	</tr>
	<tr>
		<td class="pcontent"><b>Disable Account?</b></td>
		<td><input type="checkbox" name="chkDisable" id="chkDisable" <%if txtDisable = 1 then Response.Write "checked" end if%> class="pcontent"></td>
	</tr>
</table>
<%
										' Display this only if the buyer is added
										if DoAdd then
%>
<br>
<p class="sheader">Supplier EAN Numbers</p>
<p class="pcontent">Please add the supplier EAN Numbers below. You can only add a maximum of three EAN Numbers with for a new supplier. <br>You will be able to add more EAN Numbers for this supplier
	in the <b>"Edit Supplier EAN Numbers"</b> section, after you successfully added this supplier to the system.</p>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent">&nbsp;</td>
		<td class="pcontent"><b>EAN Number</b></td>
	</tr>
<%
											' Create three supplier codes
											For Counter = 1 to 3
%>	
	<tr>
		<td class="pcontent" align="right"><b><%=Counter%>.</b></td>
		<td><input type="text" name="txtSupplierCode<%=Counter%>" id="txtSupplierCode<%=Counter%>" size="20" maxlength="30" class="pcontent"></td>
	</tr>
<%
											Next
%>	
</table>
<%
										end if
%>

<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td colspan="3"><br>
			<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidSupplierID" id="hidSupplierID" value="<%=txtSupplierID%>">
			<input type="hidden" name="hidAction" id="hidAction" value="<%=txtSupplierID%>">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->
