<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/setuserdetails.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
										
										' Declare the variables
										dim curConnection
										dim SQL
										dim ReturnSet
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=mid(const_app_ApplicationRoot,1,len(const_app_ApplicationRoot)-9)%>";
	};
//-->
</script>								
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
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
										
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
										
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											'Response.Write SQL
											'Response.End


%>
<p class="bheader">Results</p>
<hr>
<%											
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured - Display the error message
												
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<hr>
<%

											else
											
%>

<p class="pcontent"><b>Search result: <b><p>
<table border="2" cellpadding="2" cellspacing="2" width="95%">
	<tr>
		<td class="tblheader"><center><b>EAN</center></b></td>
		<td class="tblheader"><center><b>DC</center></b></td>
		<td class="tblheader"><center><b>Name</center></b></td>
		<td class="tblheader"><center><b>User name</center></b></td>
		<td class="tblheader"><center><b>Password</center></b></td>
		<td class="tblheader"><center><b>Contact</center></b></td>
	</tr>
	
<%

										If ReturnSet("Contact") = "View" Then
										

										' Loop through the recordset
											While not ReturnSet.EOF
										
										
										
										
%>
<tr>
	<td class="tbldata" align="left"><%=ReturnSet("SearchOn")%></td><td class="tbldata" align="left"><%=ReturnSet("DC")%></td><td class="pcontent" align="left"><%=ReturnSet("SearchType")%></td><td class="pcontent" align="left"><%=ReturnSet("UserName")%></td><td class="pcontent" align="left"><%=ReturnSet("UserPassword")%></td><td class="pcontent" align="left"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=ReturnSet("BuyerID")%>"><%=ReturnSet("Contact")%></a></td>
</tr>

<%												

												ReturnSet.MoveNext
											Wend

%>											
</table>											
<%											end if





























			

			
											' Loop through the recordset
											While not ReturnSet.EOF
%>
<tr>
	<td class="tbldata" align="left"><%=ReturnSet("SearchOn")%></td><td class="tbldata" align="left"><%=ReturnSet("DC")%></td><td class="pcontent" align="left"><%=ReturnSet("SearchType")%></td><td class="pcontent" align="left"><%=ReturnSet("UserName")%></td><td class="pcontent" align="left"><%=ReturnSet("UserPassword")%></td><td class="pcontent" align="left"><%=ReturnSet("Contact")%></td>
</tr>

<%												

												ReturnSet.MoveNext
											Wend
											
%>											
</table>											
<%											end if

											
											' Close the recordset and connection
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
		<td class="pcontent" align="left"><b>Search for:</b></td>
		<td>	
		<select name="drpSearchType" id="drpSearchType" class="pcontent">
					<option value="-1">------ Search What? -----</option>
					<option value="1">EAN Number</option>
					<option selected value="2">Name</option>
		</select>		
		</td>
	</tr>
	<tr>	
		<td class="pcontent" align="left"><b>Text to Search:</b></td>
		<td class="pcontent"><input type="text" name="txtToSearch" id="txtToSearch"></td>
	</tr>
	<tr>	
		<td class="pcontent" align="left"><b>Search On:</b></td>
		<td>
		<select name="drpSearchOn" id="drpSearchOn" class="pcontent">
					<option value="-1">-------- Search On -------</option>
					<option selected value="1">Supplier</option>
					<option value="2">DC</option>
					<option value="3">Buyer</option>
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

