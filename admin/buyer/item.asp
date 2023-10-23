<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/buyer/default.asp")

										' Declare the variables
										dim DoAdd
										dim curConnection
										dim SQL
										dim ReturnSet
										dim ErrorMessage
										dim txtBuyerID
										dim txtUserName
										dim txtPassword
										dim txtFirstName
										dim txtSurName
										dim IsChangePwd
										dim txtCompanyID
										dim txtDisable
										dim Counter
										dim FormAction
										
										' Set the page header
										PageTitle = "Buyer Detail"
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString		
										
										' Check if the user is updateing or adding
										if Request.QueryString("id") = "" or IsNull(Request.QueryString("id")) THen
											' The user is adding a new Buyer
											' Set the page header
											PageTitle = "Add New Buyer"
											DoAdd = True
											txtBuyerID = 0
											FormAction = "doadditem.asp"
										else
											' Then user is updating an existing buyer
											' Set the page header
											PageTitle = "Update Buyer Detail"
											DoAdd = False
											txtBuyerID = Request.QueryString("id")
											FormAction = "doedititem.asp"
										end if
										
										if DoAdd Then
											' The user is adding - Set the default values to blank
											txtUserName = ""
											txtPassword = ""
											txtFirstName = ""
											txtSurName = ""
											IsChangePwd = 0
											txtCompanyID = ""
											txtDisable = 0
										else
											' Build the SQL
											SQL = "exec itemBuyers @BRID=" & txtBuyerID
										
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Check if there are an error
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Display the erorrmessage
												ErrorMessage = ReturnSet("errormessage")								
											else
												' No error occured - Set the values
												txtUserName = ReturnSet("LoginName")
												txtPassword = ReturnSet("LoginPassword")
												txtFirstName = ReturnSet("FirstName")
												txtSurName = ReturnSet("Surname")
												IsChangePwd = ReturnSet("ChangePwd")
												txtCompanyID = ReturnSet("DCID")
												txtDisable = ReturnSet("Disable")
											end if
											
											' Close the Recordset and connection
											Set ReturnSet = Nothing
										end if
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="JavaScript">
<!--
	function move(fbox, tbox) {
		var arrFbox = new Array();
		var arrTbox = new Array();
		var arrLookup = new Array();
		var i;

		for (i = 0; i < tbox.options.length; i++) {
			arrLookup[tbox.options[i].text] = tbox.options[i].value;
			arrTbox[i] = tbox.options[i].text;
		}
		
		var fLength = 0;
		var tLength = arrTbox.length;

		for(i = 0; i < fbox.options.length; i++) {
			arrLookup[fbox.options[i].text] = fbox.options[i].value;
		
			if (fbox.options[i].selected && fbox.options[i].value != "") {
				arrTbox[tLength] = fbox.options[i].text;
				tLength++;
			} else {
				arrFbox[fLength] = fbox.options[i].text;
				fLength++;
		   }
		}

		arrFbox.sort();
		arrTbox.sort();
		fbox.length = 0;
		tbox.length = 0;
		var c;

		for(c = 0; c < arrFbox.length; c++) {
			var no = new Option();
			no.value = arrLookup[arrFbox[c]];
			no.text = arrFbox[c];
			fbox[c] = no;
		}
		
		for(c = 0; c < arrTbox.length; c++) {
			var no = new Option();
			no.value = arrLookup[arrTbox[c]];
			no.text = arrTbox[c];
			tbox[c] = no;
	   }
	}
	
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
		
		// Check if the firstname is supplied
		if	(obj.txtFirstName.value=='') {
			window.alert ('Please enter a firstname.');
			obj.txtFirstName.focus();
			return false;
		};
		
		// Check if the surname is supplied
		if	(obj.txtSurname.value=='') {
			window.alert ('Please enter a surname.');
			obj.txtSurname.focus();
			return false;
		};
		
		// Check if the email address is supplied
		if	(obj.txtSurname.value=='') {
			window.alert ('Please enter a surname.');
			obj.txtSurname.focus();
			return false;
		};
		
		// Check if the email address is supplied
		if	(obj.lstDC.value=='-1') {
			window.alert ('You have to allocate a DC to this Buyer.');
			obj.lstDC.focus();
			return false;
		};
		
		if (obj.hidAction.value == '0') {
			// Check if the buyercode is supplied
			if	((obj.txtBuyerCode1.value=='')&&(obj.txtBuyerCode2.value=='')&&(obj.txtBuyerCode3.value=='')) {
				window.alert ('You have to supply at least one buyer code.');
				obj.txtBuyerCode1.focus();
				return false;
			};
				
			for (i=1;i<=3;i++) {
				var TestExp = /[,"<>:;]|\]|\[|\(|\)|\\/g
				var charpos = obj.elements['txtBuyerMail' + i].value.indexOf('@');
				var checkcount=0;
				if (obj.elements['txtBuyerMail' + i].value=='') {
					checkcount++;
				};
				if (obj.elements['txtBuyerMail' + 1].value=='') {
					// Ensure that Field Filled in
					if ((obj.elements['txtBuyerMail' + i].value=='')||
						(charpos==-1)||
						(obj.elements['txtBuyerMail' + i].value.indexOf('.', charpos)==-1)||
						(obj.elements['txtBuyerMail' + i].value.indexOf('@', charpos+1)!=-1)||
						(obj.elements['txtBuyerMail' + i].value[obj.elements['txtBuyerMail' + i].length-1]=='.')) {
							
						window.alert('Please enter a valid e-mail address');
						obj.elements['txtBuyerMail' + i].focus();
						return false;
					};
						
					// Ensure that Illegal Characters not Entered
					if (obj.elements['txtBuyerMail' + i].value.search(TestExp)!=-1) {
						window.alert('Please enter a valid e-mail address.');
						obj.elements['txtBuyerMail' + i].focus();
						return false;
					};
				};
			};
		
			if (checkcount==0) {
				window.alert('You have to enter at least one email address.');
				obj.elements['txtBuyerMail' + 1].focus();
				return false;
			};
		};
		
		// Check if the user assigned suppliers to this buyer
		if (obj.lstAssign.options.length==0) {
			window.alert('You have to assign at least one supplier.');
			obj.lstAssign.focus();
			return false;
		};
		
		for (i = 0; i < obj.lstAssign.options.length; i++) {
			obj.lstAssign.options[i].selected = true;
		};
	};
	
	function validatedel(obj) {
		// Check if the user confirmed the deletion
		if (obj.chkDelete.checked==false) {
			window.alert ('Please confirm the deletion by checking the "Confirm Deletion" checkbox first.');
			return false;
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
		<td class="pheader">Add a New Buyer</td>
<%
										else
%>
		<td class="pheader">Update Buyer Detail</td>
<%
										end if
%>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/buyermenu.asp"-->
<%
										if DoAdd Then
%>
<p class="pcontent">Please complete the form below to add a new buyer for <b><%=Session("DCName")%></b></p>
<%
										else
%>
<!--#include file="includes/subbuyermenu.asp"-->
<p class="pcontent">Below is the detail for buyer <b><%=txtFirstName & "&nbsp;" & txtSurname%></b></p>
<%
										end if
%>
<p class="subheader">Personal Detail</p>
<form name="EditBuyer" id="EditBuyer" method="post" action="<%=FormAction%>?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>UserName:</b></td>
		<td><input type="text" name="txtUserName" id="txtUserName" value="<%=txtUserName%>" size="20" maxlength="100"></td>
	</tr>
<%
										if DoAdd = False Then
%>	
	<tr>
		<td>&nbsp;</td>
		<td class="pcontent" colspan="2"><b>Note:</b> Only confirm the new password if you wish to change it.</td>
	</tr>
<%
										end if
%>	
	<tr>
		<td class="pcontent"><b>Password:</b></td>
		<td><input type="password" name="txtPassword" id="txtPassword" value="" size="20" maxlength="100"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>Confirm Password:</b></td>
		<td><input type="password" name="txtConfirmPassword" id="txtConfirmPassword" value="" size="20" maxlength="100"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>FirstName:</b></td>
		<td><input type="text" name="txtFirstName" id="txtFirstName" value="<%=txtFirstName%>" size="20" maxlength="100"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>Surname:</b></td>
		<td><input type="text" name="txtSurname" id="txtSurname" value="<%=txtSurname%>" size="20" maxlength="100"></td>
	</tr>
	<tr>
		<td class="pcontent"><b>DC:</b></td>
		<td>
			<select name="lstDC" name="lstDC">
				<option value="-1">-- Allocate a DC --</option>
<%
										if Session("Permission") = 0 Then
											Select Case CStr(Session("DCID"))
											Case "1"
%>											
												<option selected value="1">South Rand</option>
<%												
											Case "2"
%>											
												<option selected value="2">North Rand</option>
<%			
											Case "3"
%>											
												<option selected value="3">Kwazulu Natal</option>
<%												
											Case "4"
%>											
												<option selected value="4">Eastern Cape</option>
<%												
											Case "5"
%>											
												<option selected value="5">Western Cape</option>
<%												
												End Select
										else
%>		
				<option <%if CStr(txtCompanyID) = "1" Then Response.Write "selected" end if%> value="1">South Rand</option>
				<option <%if CStr(txtCompanyID) = "2" Then Response.Write "selected" end if%> value="2">North Rand</option>
				<option <%if CStr(txtCompanyID) = "3" Then Response.Write "selected" end if%> value="3">Kwazulu Natal</option>
				<option <%if CStr(txtCompanyID) = "4" Then Response.Write "selected" end if%> value="4">Eastern Cape</option>
				<option <%if CStr(txtCompanyID) = "5" Then Response.Write "selected" end if%> value="5">Western Cape</option>
<%
										end if
%>			
			</select>
		</td>
	</tr>
	<tr>
		<td class="pcontent"><b>Disable Account?</b></td>
		<td><input type="checkbox" name="chkDisable" id="chkDisable" <%if txtDisable = 1 then Response.Write "checked" end if%>></td>
	</tr>
</table>
<%
										' Display this only if the buyer is added
										if DoAdd then
%>
<br>
<p class="subheader">Buyer Codes</p>
<p class="pcontent">Please add the buyer codes below. You can only add a maximum of three buyer codes with for a new buyer. <br>You will be able to add more buyer codes for this buyer
	in the <b>"Edit Buyer Codes"</b> section, after you successfully added this buyer to the system.</p>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent">&nbsp;</td>
		<td class="pcontent"><b>BuyerCode</b></td>
	</tr>
<%
											' Create three buyer codes
											For Counter = 1 to 3
%>	
	<tr>
		<td class="pcontent" align="right"><b><%=Counter%>.</b></td>
		<td><input type="text" name="txtBuyerCode<%=Counter%>" id="txtBuyerCode<%=Counter%>" size="5" maxlength="10"></td>
	</tr>
<%
											Next
%>	
</table>
<br>
<p class="subheader">Buyer E-Mail Addresses</p>
<p class="pcontent">Please add the buyer and assistant e-mail addresses below. You can only add a maximum of three email addresses for a new buyer. <br>You will be able to add more email addresses for this buyer
	in the <b>"Edit Buyer EMail Addresses"</b> section, after you successfully added this buyer to the system.</p>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent">&nbsp;</td>
		<td class="pcontent"><b>Buyer E-Mail Address</b></td>
	</tr>
<%
											' Create three buyer email addresses
											For Counter = 1 to 3
%>	
	<tr>
		<td class="pcontent" align="right"><b><%=Counter%>.</b></td>
		<td><input type="text" name="txtBuyerMail<%=Counter%>" id="txtBuyerMail<%=Counter%>" size="30" maxlength="100"></td>
	</tr>
<%
											Next
%>	
</table>
<%
										end if
%>
<p class="subheader">Assign Suppliers</p>
<p class="pcontent">Please assign or unassign suppliers for this buyer below.
	<ul>
		<li class="pcontent">While holding the <b>"Ctrl"</b> key on your keyboard, click with your mouse pointer on the suppliers you wish to select.</li>
		<li class="pcontent">Click on the <b>">>"</b> button to assign the selected suppliers to the selected buyer. <b>OR</b></li>
		<li class="pcontent">Click on the <b>"<<"</b> button to Unassign the selected suppliers from the selected buyer.</li>
	</ul>
</p>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<th class="pcontent">Unassigned Suppliers</th>
		<th>&nbsp;</th>
		<th class="pcontent">Assigned Suppliers</th>
	</tr>
	<tr>
		<td>
			<select multiple size="10" name="lstUnassign" id="lstUnassign" style="width:300">
<%
										' Call the sp - listUnassignSupplier 
										SQL = "exec listUnassignSupplier @BRID=" & txtBuyerID
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										' Check the returnvalue
										if ReturnSet("returnvalue") = 0 Then
											' There are unassigned suppliers - Loop through the recordset
											While not ReturnSet.EOF
%>
				<option value="<%=ReturnSet("SupplierID")%>"><%=ReturnSet("SupplierName")%></option>
<%											
												ReturnSet.MoveNext
											Wend
										end if
										' Close the recordset
										Set ReturnSet = Nothing
%>				
			</select>
		</td>
		<td align="center" valign="middle">
			<input type="button" onClick="move(this.form.lstAssign,this.form.lstUnassign)" value="<<" class="button"><br><br>
			<input type="button" onClick="move(this.form.lstUnassign,this.form.lstAssign)" value=">>" class="button">
		</td>
		<td>
			<select multiple size="10" name="lstAssign" id="lstAssign" style="width:300">
<%
										if DoAdd = False Then
											' Call the sp - listUnassignSupplier 
											SQL = "exec listAssignSupplier @BRID=" & txtBuyerID
										
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
	<tr>
		<td colspan="3"><br>
			<input type="submit" name="btnSubmit" id="btnSubmit" value="Submit" class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidBuyerID" id="hidBuyerID" value="<%=txtBuyerID%>">
			<input type="hidden" name="hidAction" id="hidAction" value="<%=txtBuyerID%>">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->
<%
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
%>