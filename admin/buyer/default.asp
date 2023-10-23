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
										SQL = "exec listDCBuyers @DCID=" & Session("DCID")
										
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
		<td class="pheader">Buyer Section</td>
		<td class="pcontent" align="right"><b>Welcome <%=Session("FirstName")%>&nbsp;<%=Session("Surname")%></b></td>
	</tr>
</table>
<!--#include file="../includes/mainmenubar.asp"-->
<!--#include file="includes/buyermenu.asp"-->
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
<p class="pcontent">Below is a list of buyers for <b><%=Session("DCName")%></b>
	<ul>
		<li class="pcontent">Click on one of the Buyer Names to edit the buyer's detail.</li>
	</ul>
</p>
<table border="0" cellpadding="5" cellspacing="2">
	<tr>
		<th class="pcontent" align="left">Buyer Name</th>
		<th class="pcontent" align="left">DC Name</th>
	</tr>
<%											
											DCName = ""
																						
											'Loop throug the recordset
											While not ReturnSet.EOF
%>
	<tr>
<%
												' Check if the DCName = DCName from the recordset
												if DCName = ReturnSet("DCName") Then
													' Display a blank table data
%>
		<td>&nbsp;</td>
<%					
												else
													' Display the DCName								
%>	
		<td class="pcontent"><b><%=ReturnSet("DCName")%></b></td>
<%
												end if
%>		
		<td><a class="textnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=ReturnSet("BuyerID")%>"><%=LCase(ReturnSet("FirstName"))%>&nbsp;<%=LCase(ReturnSet("Surname"))%></a></td>
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