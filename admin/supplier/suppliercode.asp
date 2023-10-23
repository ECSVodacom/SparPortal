<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/supplier/default.asp")
										
										' Check if the id parameter is passed in the querystring
										if Request.QueryString("id") = "" Then
											Response.Redirect const_app_ApplicationRoot & "/supplier/default.asp"
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
										
										PageTitle = "Edit Supplier EAN Numbers"
										
										' Build the SQL
										SQL = "exec listSupplierCode @SupplierID=" & Request.QueryString("id")
										
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
	
	};
//-->
</script>

<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="pheader">Edit Supplier EAN Numners</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/suppliermenu.asp"-->
<!--#include file="includes/subsuppliermenu.asp"-->
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
<p class="subheader">Update Existing EAN Numbers</p>
<p class="pcontent">Below is a list of Supplier EAN Numbers <b><%=ReturnSet("SupplierName")%></b>.
	<ul>
		<li class="pcontent">Check the <b>Delete</b> checkboxes for the EAN Numbers you wish to delete and click on the <b>"Delete"</b> button.</li>
		<li class="pcontent">If you wish to edit the EAN Numbers, click inside a text box and change the buyer code and then click on the <b>"Update"</b> button.</li>
		<li class="pcontent">You can also <a class="textnav" href="#Add">Add</a> a new Supplier EAN Number on this page.</li>
	</ul>
</p>
<form name="EditSupplierCodes" id="EditSupplierCodes" method="post" action="doeditsuppliercode.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>Delete?</b></td>
		<td class="pcontent"><b>Supplier EAN Number</b></td>
	</tr>
<%
											Counter = 0
										
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1
%>
	<tr>
		<td><input type="checkbox" name="chkDelete<%=Counter%>" id="chkDelete<%=Counter%>"></td>
		<td><input type="text" name="txtCode<%=Counter%>" id="txtCode<%=Counter%>" value="<%=ReturnSet("SupplierCode")%>" size="20" maxlength="50">
			<input type="hidden" name="hidSupplierCodeID<%=Counter%>" id="hidSupplierCodeID<%=Counter%>" value="<%=ReturnSet("SupplierCodeID")%>">
		</td>
	</tr>
<%										
										
												ReturnSet.MoveNext
											Wend
										
											' Close the recordset
											Set ReturnSet = Nothing
%>
	<tr>
		<td colspan="2">
			<input type="submit" name="btnUpdate" id="btnUpdate" value="Update" class="button" onclick="document.EditSupplierCodes.hidAction.value=1;">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">&nbsp;
			<input type="submit" name="btnDelete" id="btnDelete" value="Delete" class="button" onclick="document.EditSupplierCodes.hidAction.value=2;">&nbsp;
			<input type="hidden" name="hidSupplierID" id="hidSupplierID" value="<%=Request.QueryString("id")%>">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
			<input type="hidden" name="hidTotal" id="hidTotal" value="<%=Counter%>">
		</td>
	</tr>
</table>
</form>
<%
										end if
%>
<p class="subheader">Add a New Supplier EAN Number<a name="Add"></p>
<p class="pcontent">Please enter a new EAN Number in the text box below and click on the <b>"Add"</b> button.</p>
<form name="AddSupplierCode" id="AddSupplierCode" method="post" action="doaddsuppliercode.asp">
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td class="pcontent"><b>Buyer Code:</b></td>
		<td><input type="text" name="txtSupplierCode" id="txtSupplierCode" size="20" maxlength="50"></td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="submit" name="btnAdd" id="btnAdd" value="  Add  " class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" class="button">
			<input type="hidden" name="hidSupplierID" id="hidSupplierID" value="<%=Request.QueryString("id")%>">
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