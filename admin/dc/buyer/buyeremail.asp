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
										' Check if the id parameter is passed in the querystring
										if Request.QueryString("id") = "" Then
											Response.Redirect const_app_ApplicationRoot & "/buyer/default.asp"
										end if
										
										' Declare the variables
										dim DoAdd
										dim curConnection
										dim SQL
										dim ReturnSet
										dim Counter
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString		
										
										PageTitle = "Edit Buyer Email addresses"
										
										' Build the SQL
										SQL = "exec listBuyerMail @BuyerID=" & Request.QueryString("id")
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="JavaScript">
<!--
	
	function validate(obj) {
		for (var i=1;i<=obj.hidTotal.value;i++) {
			if (obj.elements('txtMail' + i).value=='') {
				window.alert("Add a valid e-mail address at line " + i);
				obj.elements('txtMail' + i).focus();
				return false;
			};
		};
	};

	function valadd(obj) {
		if (obj.txtEmail.value=='') {
			window.alert("Add a valid e-mail address");
			obj.txtEmail.focus();
			return false;
		};
	};
//-->
</script>

<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Edit Buyer Emails</td>
	</tr>
</table>
<!--#include file="includes/subbuyermenu.asp"-->
<%
										' Check if there are an error
										if ReturnSet("returnvalue") <> 0 Then
											' An error occured - Display the erorrmessage
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<%
										else
											' No error occured - display the form
%>
<p class="sheader">Update Existing Emails</p>
<p class="pcontent">Below is a list of Email Addresses for <b><%=ReturnSet("FirstName") & " " & ReturnSet("Surname")%></b>.
	<ul>
		<li class="pcontent">Check the <b>Delete</b> checkboxes for the emails you wish to delete and click on the <b>"Delete"</b> button.</li>
		<li class="pcontent">If you wish to edit the email addresses, click inside a text box and change the emails and then click on the <b>"Update"</b> button.</li>
		<li class="pcontent">You can also <a class="stextnav" href="#Add">Add</a> a new Buyer Email address on this page.</li>
	</ul>
</p>
<form name="EditEmail" id="EditEmail" method="post" action="doeditmail.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>Delete?</b></td>
		<td class="pcontent"><b>Email Address</b></td>
	</tr>
<%
											Counter = 0
										
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1
%>
	<tr>
		<td><input type="checkbox" name="chkDelete<%=Counter%>" id="chkDelete<%=Counter%>" class="pcontent"></td>
		<td><input type="text" name="txtMail<%=Counter%>" id="txtMail<%=Counter%>" value="<%=ReturnSet("BuyerEmail")%>" size="40" maxlength="100" class="pcontent">
			<input type="hidden" name="hidMailID<%=Counter%>" id="hidMailID<%=Counter%>" value="<%=ReturnSet("BuyerEmailID")%>">
		</td>
	</tr>
<%										
										
												ReturnSet.MoveNext
											Wend
										
											' Close the recordset
											Set ReturnSet = Nothing
%>
	<tr>
		<td colspan="2"><br>
			<input type="submit" name="btnUpdate" id="btnUpdate" value="Update" class="button" onclick="document.EditEmail.hidAction.value=1;">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">&nbsp;
			<input type="submit" name="btnDelete" id="btnDelete" value="Delete" class="button" onclick="document.EditEmail.hidAction.value=2;">&nbsp;
			<input type="hidden" name="hidBuyerID" id="hidBuyerID" value="<%=Request.QueryString("id")%>">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
			<input type="hidden" name="hidTotal" id="hidTotal" value="<%=Counter%>">
		</td>
	</tr>
</table>
</form>
<%
										end if
%>
<p class="sheader">Add a New Buyer Email<a name="Add"></p>
<p class="pcontent">Please enter a new buyer email in the text box below and click on the <b>"Add"</b> button.</p>
<form name="AddMail" id="AddMail" method="post" action="doaddmail.asp" onsubmit="return valadd(this);">
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td class="pcontent"><b>Buyer E-mail Address:</b></td>
		<td><input type="text" name="txtEmail" id="txtEmail" size="40" maxlength="100" class="pcontent"></td>
	</tr>
	<tr>
		<td colspan="2"><br>
			<input type="submit" name="btnAdd" id="btnAdd" value="  Add  " class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" class="button">
			<input type="hidden" name="hidBuyerID" id="hidBuyerID" value="<%=Request.QueryString("id")%>">
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