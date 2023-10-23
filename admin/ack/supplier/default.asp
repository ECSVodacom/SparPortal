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
										' Set the page header
										PageTitle = "Supplier"
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
		<td class="pheader">Supplier</td>
	</tr>
</table>
<!--include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/submenu.asp"-->
<%
										' Create a Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString

										
										ErrorCount = 0
										
										' Check if the user selected to delete a user
										if Request.Form("hidAction") = "1" then
											' Execute the delAdminUser SP
											Set ReturnSet =  ExecuteSql("exec delAdminUser @UserID=" & Request.Form("hidUserID"), curConnection)   
											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												ErrorCount = 1
											else
												ErrorCount = 2
											end if
										end if
										
										' Set the SQL Statement
										SQL = "exec listSupplier"
										
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
		window.alert ('The selected Supplier was deleted successfully.');
	};
//-->
</script>
<p class="pcontent">Below is a list of Ackermans Suppliers.<br><br>
	<b>NOTE:</b>
	<ul>
		<li class="pcontent">Select a <b>Supplier Name</b> from the dropdown box below to edit.</li>
	</ul>
</p>
<form name="lstSupplier" id="lstSupplier" method="post" action="item.asp">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent" align="center"><b>Supplier Name:</b></td>
		<td class="pcontent" align="center">
			<select name="drpSupplier" id="drpSupplier" class="pcontent" onchange="document.lstSupplier.action='item.asp?id=' + document.lstSupplier.drpSupplier.value; document.lstSupplier.submit();">
				<option value="-1"> -- Select a Supplier --</option>
<%
											' Loop through the recordset
											While not ReturnSet.EOF
												Counter = Counter + 1
%>
				<option value="<%=ReturnSet("UserID")%>"><%=ReturnSet("FirstName") & " (" & ReturnSet("UserName") & ") "%></option>
<%											
												ReturnSet.MoveNext
											Wend
%>		
			</select>
		</td>
	</tr>
</table>
</form>
<%											
										end if
										
										' Close the Connection and Recordset
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->