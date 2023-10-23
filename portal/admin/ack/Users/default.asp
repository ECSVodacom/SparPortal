<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
										dim curConnection
										dim ReturnSet
										dim SQL
										dim Counter
										dim ErrorCount
										
										' Check if the user is logged in
										Call LoginCheck (const_app_ApplicationRoot & "/users/default.asp")
										
										' Set the page header
										PageTitle = "Users"
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function valdel (obj) {
		if (window.confirm('Are you sure that you want to delete this User?')) { return true;} else { return false; };
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
<%
										' Create a Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										ErrorCount = 0
										
										' Check if the user selected to delete a user
										if Request.Form("hidAction") = "1" then
											' Execute the delAdminUser SP
											Set ReturnSet = ExecuteSql("exec delAdminUser @UserID=" & Request.Form("hidUserID"), curConnection)   
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = 1
											else
												ErrorCount = 2
											end if
										end if
										
										' Set the SQL Statement
										SQL = "exec listUsers @UserID=" & Session("UserID")

										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										' Check the returnvalue
										if ReturnSet("returnvalue") <> 0 Then
											' An error occured - Display
%>
<p class="pcontent"><b>SORRY:</b><br>
	There are currently no registered adminnistration users. Try again later.
</p>
<%											
										else
											' No error occured
%>
<script language="javascript">
<!--
	if (<%=ErrorCount%>==2) {
		window.alert ('The selected User was deleted successfully.');
	};
//-->
</script>
<p class="pcontent">Below is a list of administration users.<br><br>
	<b>NOTE:</b>
	<ul>
		<li class="pcontent">Click on the <b>User Name</b> to edit.</li>
		<li class="pcontent">Click on the <b>Delete</b> button to delete the selected User.</li>
	</ul>
</p>
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="tblheader" align="center"><b>User Name</b></td>
		<td class="tblheader" align="center"><b>Email Address</b></td>
		<td class="tblheader" align="center"><b>Action</b></td>
	</tr>
<%
											Counter = 0
											
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1
%>
	<tr>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/users/item.asp?id=<%=ReturnSet("UserID")%>"><%=ReturnSet("FirstName") & " " & ReturnSet("Surname")%></a></td>
		<td class="tbldata"><%=ReturnSet("UserMail")%></td>
		<form name="Del<%=Counter%>" id="Del<%=Counter%>" method="post" action="default.asp" onsubmit="return valdel(this);">
 			<td class="tbldata">
 				<input type="submit" name="btnDel" id="btnDel" value="Delete" class="button" <%if Session("UserID") = ReturnSet("UserID") then Response.Write "disabled=true" end if%>>
 				<input type="hidden" name="hidUserID" id="hidUserID" value="<%=ReturnSet("UserID")%>">
 				<input type="hidden" name="hidAction" id="hidAction" value="1">
 			</td>
 		</form>
	</tr>
<%											
											
												ReturnSet.MoveNext
											Wend
%>	
</table>
<%											
										end if
										
										' Close the Connection and Recordset
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->