<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->

<%
								'Check if the user is logged on
								
								
								Call LoginCheck (const_app_ApplicationRoot & "/password/default.asp")
								
								'Declare variables
								dim SQL
								dim curConnection
								dim ReturnSet
								dim Counter
								'dim SearchType
								'dim SearchOn
								
								PageTitle = "Lookup"
								
								Counter = 0
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->

<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user selected a Search Type
		if (obj.SearchType.value=='-1') {
			window.alert ('Please select a search type.');
			obj.SearchType.focus();
			return false;
		};
	
		// Check if the user selected a entity to search on
		if (obj.txtSearchOn.value=='-1') {
			window.alert ('Please enter a value to search for.');
			obj.SearchOn.focus();
			return false;
		};
		
		// Check if the user entered a user name
		if (obj.txtUserName.value=='') {
			window.alert ('Please enter a User Name.');
			obj.txtUserName.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->


<%
								if Request.Form("hidAction") = 1 then
									'Build SQL
									SQL = "exec procPassword @ToSearch=" & MakeSQLText(Request.Form("txtToSearch")) & _
										", @SearchType=" & MakeSQLText(Request.Form("drpSearchType")) & _
										", @SearchOn=" & MakeSQLText(Request.Form("drpSearchOn"))
																				
									'Response.Write SQL
									'Response.End	
									
									'Create a Connection
									Set curConnection = Server.CreateObject("ADODB.Connection")
									curConnection.Open const_db_ConnectionString
									
									'Execute SQL
									Set ReturnSet = ExecuteSql(SQL, curConnection)  
									
									'Response.Write SQL
%>
<p class="bheader">Results</p>
<hr>
<%
									'Check the return value
									if ReturnSet("returnvalue") <> 0 then
										'An error occured - display an error message
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<hr>
<%
									else
%>



<p class="pcontent"><b>Search result: <b><p>
<table border="2" cellpadding="2" cellspacing="2" colspan="3" width="65%">
	<tr>
		<td class="tblheader"><center><b>EAN</center></b></td>
		<td class="tblheader"><center><b>Name</center></b></td>
		<td class="tblheader"><center><b>Username</center></b></td>
		<td class="tblheader"><center><b>Password</center></b></td>
	</tr>

<%							
									' Loop through the recordset
									While not ReturnSet.EOF
																
%>

	<tr>
		<td class="tbldata" align="left"><%=ReturnSet("SearchOn")%></td><td class="pcontent" align="left"><%=ReturnSet("SearchType")%></td><td class="pcontent" align="left"><%=ReturnSet("UserName")%></td><td class="pcontent" align="left"><%=ReturnSet("UserPassword")%></td>
	
	</tr>	
	
<%										
									ReturnSet.MoveNext
											Wend
											
%>
</table>
<%											
											
									end if
								
									'Close the recordset and connection
									Set ReturnSet = Nothing
									curConnection.Close 
									Set curConnection = Nothing
								end if
%>
<p class="bheader">Lookup</p>
<p class="pcontent">Enter the search string into the field below and click on the <b>search</b> button.</p>
<form name="PwdSearch" id="PwdSearch" method="post" action="default.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	
	
	<tr>
		<!--<td class="pcontent" align="left"><b>Search for:</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="1"><b>Name Description</b></td>-->
		<!--<td class="pcontent"><input type="radio" id="radSearchWhat" name="radSearchWhat" value="2"><b>EAN Number</b></td>-->
		
		
		<td class="pcontent" align="left"><b>Search for:</b></td>
		<td>	
		<select name="drpSearchType" id="drpSearchType" class="pcontent">
					<option value="-1">------ Search What? -----</option>
					<option value="1">EAN</option>
					<option value="2">Name</option>
		</select>		
		</td>
			
		
	</tr>
	
	<tr>	
		<td class="pcontent" align="left"><b>Text to search:</b></td>
		<td class="pcontent"><input type="text" name="txtToSearch" id="txtToSearch"></td>
	</tr>
	
	<tr>
		<td class="pcontent" align="left"><b>Search On:</b></td>
		<td>	
		<select name="drpSearchOn" id="drpSearchOn" class="pcontent">
					<option value="-1">-------- Search On -------</option>
					<option value="1">Store</option>
					<option value="2">Supplier</option>
					<option value="3">DC</option>
		</select>		
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<input type="submit" name="btnSearch" id="btnSearch" value="Search" class="button">&nbsp;
			<input type="reset" name="btnReset" id="btnReset" value="Reset" class="button">
			<input type="hidden" name="hidAction" id="hidAction" value="1">
		</td>
	</tr>
</table>
</form>
<!--#include file="../layout/end.asp"-->

