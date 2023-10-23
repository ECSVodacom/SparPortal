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
										' Declare the variables
										dim curConnection
										dim SQL
										dim ReturnSet
										dim DCName
										
										' Set the page header
										PageTitle = "List Buyers"
										
										' Create the Connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Build the SQL
										SQL = "exec listDCBuyers @DCID=" & Session("UserID")

										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<!--#include file="../layout/bodystart.asp"-->
<table border="0" cellpadding="2" cellspacing="2" width="100%">
	<tr>
		<td class="bheader">Buyer Section</td>
	</tr>
</table>
<%
										' Check if there are an error
										if ReturnSet("returnvalue") <> 0 Then
											' An error occured - Display the erorrmessage
%>
<p class="errortext"><%=ReturnSet("errormessage")%></p>
<%											
										else
											' No error occured - Display the header
%>
<p class="pcontent">Below is a list of buyers for <b><%=Session("CLientName")%></b>
	<ul>
		<li class="pcontent">Click on a Buyer Name to edit the detail.</li>
	</ul>
</p>
<table border="0" cellpadding="1" cellspacing="2">
	<tr>
		<th class="tblheader" align="center">DC Name</th>
		<th class="tblheader" align="center">Buyer Name</th>
	</tr>
<%											
											DCName = ""
																						
											'Loop throug the recordset
											While not ReturnSet.EOF
%>
	<!--<tr>-->
<%
												' Check if the DCName = DCName from the recordset
												if DCName = ReturnSet("DCName") Then
													' Display a blank table data
%>
		<!--<td></td>-->
<%					
												else
													' Display the DCName								
%>	
	<tr>
		<td class="tbldata"><b><%=ReturnSet("DCName")%></b></td>
	</tr>
<%
												end if
%>		
	<tr>
		<td></td>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=ReturnSet("BuyerID")%>"><%=UCase(ReturnSet("FirstName"))%>&nbsp;<%=UCase(ReturnSet("Surname"))%></a></td>
	</tr>
<%											
												' Set the DCName
												DCName = ReturnSet("DCName")

												ReturnSet.MoveNext
											Wend
%>
</table>
<%											
										end if
										
										' Close the Recordset and connection
										Set ReturnSet = Nothing
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../layout/end.asp"-->