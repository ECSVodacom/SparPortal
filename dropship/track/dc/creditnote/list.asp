<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%
										dim curConnection
										dim ReturnSet 
										dim SQL
										dim ClaimID
%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<%						
										' Check if there is a creditnoteid is provided
										if Request.QueryString("item") = "" then
											ClaimID = 0
										else
											ClaimID = Request.QueryString("item")
										end if

										' Biuld the SQL Statement for orders
										SQL = "exec listCreditNote @ClaimID=" & ClaimID
										
										Response.Write SQL
										Response.End
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_DB_ConnectionString
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<p class="bheader">Electronic Credit Note List</p>
<p class="pcontent">Below is a list of Electronic Credit Notes for the selected Claim <b><%=ReturnSet("ClaimNum")%></b>.
	<ul>
		<li class="pcontent">Click on the <b>Credit Note Number</b> link to view the credit note detail.</li>
		<li class="pcontent">Click on the <b>Print List</b> link at the bottom of the page, to print this list to your printer.</li>
	</ul>
</p>
<%
										if ReturnSet("returnvalue") <> 0 Then
%>
<p class="pcontent"><b>Error:</b><br>
	An error was returned from the SPAR database. The following error message was returned:
	
	<b class="errortext"><%=ReturnSet("errormessage")%></b>
</p>
<%										
										else
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Credit Note <br> Number</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>File</i></b><br>
			<b><i>Received</i></b><br>
			<b><i>by Gateway</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Translation</i></b><br>
			<b><i>To</i></b><br>
			<b><i>FLAT or XML</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>Posted to</i></b><br>
			<b><i>SPAR DC</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>View</i></b><br>
			<b><i>Invoice</i></b>
		</th>
		<th class="pcontent" align="center" bgcolor="#ccccc2">
			<b><i>View</i></b><br>
			<b><i>Claim</i></b>
		</th>
	</tr>
<%
											' Loop through the recordset
											While Not ReturnSet.EOF
%>
	<tr>
		<td class="pcontent" align="center"><a class="links" href="<%=const_app_ApplicationRoot%>/track/dc/creditnote/default.asp?item=<%=ReturnSet("CreditNoteID")%>"><%=ReturnSet("CreditNoteNum")%></a></td>
		<td class="pcontent" align="center"><%=ReturnSet("ReceivedDate") & "<br>[" & ReturnSet("ReceivedTime") & "]"%></td>
		<td class="pcontent" align="center"><%=ReturnSet("TransDate") & "<br>[" & ReturnSet("TransTime") & "]"%></td>	
		<td class="pcontent" align="center"><%if ReturnSet("PostDate") <> "" Then Response.Write ReturnSet("PostDate") & "<br>[" & ReturnSet("PostTime") & "]" else Response.Write "-" end if%></td>
		<td class="pcontent" align="center"><%if ReturnSet("InvID") <> "" or CStr(ReturnSet("InvID")) <> "0" Then Response.Write "<a class=" & Chr(34) & "links" & Chr(34) & " href=" & Chr(34) & const_app_ApplicationRoot & "/track/dc/invoice/default.asp?item=" & ReturnSet("invID") & Chr(34) & ">" & ReturnSet("InvNum") & "</a>" else Response.Write "-" end if%></td>								
		<td class="pcontent" align="center"><%if ReturnSet("ClaimID") <> "" Then Response.Write "<a class=" & Chr(34) & "links" & Chr(34) & " href=" & Chr(34) & const_app_ApplicationRoot & "/track/dc/claim/default.asp?item=" & ReturnSet("ClaimID") & Chr(34) & ">" & ReturnSet("ClaimNum") & "</a>" else Response.Write "-" end if%></td>								
	</tr>
<%										
										
												ReturnSet.MoveNext
											Wend
%>
</table><br>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<!-- Create the Buttons -->
	<tr>
		<td class="pcontent" align="center">
			<input type="button" name="btnPrint" id="btnPrint" value="Print List" class="button"  onclick="javascript:window.print();"/>&#160;
			<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
		</td>
	</tr>
	<!-- End Create the Buttons -->		
</table>
<%
										end if
										
										' Close the Recordset and Connection
										Set ReturnSet = Nothing
										
										curConnection.Close
										Set curConnection = Nothing
%>
<!--#include file="../../../layout/end.asp"-->
