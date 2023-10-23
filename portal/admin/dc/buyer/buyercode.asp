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
										
										PageTitle = "Edit Buyer Codes"
										
										' Build the SQL
										SQL = "exec listBuyerCodes @BuyerID=" & Request.QueryString("id")
										
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
		<td class="bheader">Edit Buyer Codes</td>
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
<p class="sheader">Update Existing Codes</p>
<p class="pcontent">Below is a list of Buyer Codes for <b><%=ReturnSet("FirstName") & " " & ReturnSet("Surname")%></b>.
	<ul>
		<li class="pcontent">Check the <b>Delete</b> checkboxes for the codes you wish to delete and click on the <b>"Delete"</b> button.</li>
		<li class="pcontent">If you wish to edit the buyer codes, click inside a text box and change the buyer code and then click on the <b>"Update"</b> button.</li>
		<li class="pcontent">You can also <a class="stextnav" href="#Add">Add</a> a new Buyer Code on this page.</li>
	</ul>
</p>
<form name="EditBuyerCodes" id="EditBuyerCodes" method="post" action="doeditbuyercode.asp?id=<%=Request.QueryString("id")%>" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>Delete?</b></td>
		<td class="pcontent"><b>Buyer Code</b></td>
	</tr>
<%
											Counter = 0
										
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1
%>
	<tr>
		<td><input type="checkbox" name="chkDelete<%=Counter%>" id="chkDelete<%=Counter%>" class="pcontent"></td>
		<td><input type="text" name="txtCode<%=Counter%>" id="txtCode<%=Counter%>" value="<%=ReturnSet("BuyerCode")%>" size="7" maxlength="20" class="pcontent">
			<input type="hidden" name="hidBuyerCodeID<%=Counter%>" id="hidBuyerCodeID<%=Counter%>" value="<%=ReturnSet("BuyerCodeID")%>">
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
			<input type="submit" name="btnUpdate" id="btnUpdate" value="Update" class="button" onclick="document.EditBuyerCodes.hidAction.value=1;">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">&nbsp;
			<input type="submit" name="btnDelete" id="btnDelete" value="Delete" class="button" onclick="document.EditBuyerCodes.hidAction.value=2;">&nbsp;
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
<p class="sheader">Add a New Buyer Code<a name="Add"></p>
<p class="pcontent">Please enter a new buyer code in the text box below and click on the <b>"Add"</b> button.</p>
<form name="" id="" method="post" action="doaddbuyercode.asp">
<table border="0" cellspacing="2" cellpadding="2">
	<tr>
		<td class="pcontent"><b>Buyer Code:</b></td>
		<td><input type="text" name="txtBuyerCode" id="txtBuyerCode" size="7" maxlength="20" class="pcontent"></td>
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