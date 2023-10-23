<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/setuserdetails.asp"-->
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
										PageTitle = "Track a Buyer"
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
		if (obj.txtMail.value=='') {
			window.alert ('Enter an email address');
			obj.txtMail.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<%
										if Request.Form("hidAction") = "1" then
											' Create the Connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
										
											' Build the SQL
											SQL = "exec procSearchBuyerMail @Mail=" & MakeSQLText(Request.Form("txtMail"))

											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
%>
<p class="bheader">Track a Buyer - Results</p>
<%											
											' Check the return value
											if ReturnSet("returnvalue") <> 0 then
												' Error returned
%>
<p class="errortext">The email address you specified does not exist in the database.</p>
<hr>
<%					
											else
												' Records returned
%>
<p class="pcontent">Below is the search results on the email address <b><%=Request.Form("txtMail")%></b>
	<ul>	
		<li class="pcontent">Click on the Buyer Name to edit the selected buyer</li>	
	</ul>
</p>
<table border="" cellspacing="1" cellpadding="2">
	<tr>
		<th class="tblheader" align="center">Buyer Name</th>
		<th class="tblheader" align="center">Email address</th>
	</tr>
<%												
												While Not Returnset.EOF
%>
	<tr>
		<td class="tbldata"><a class="stextnav" href="<%=const_app_ApplicationRoot%>/buyer/item.asp?id=<%=ReturnSet("BuyerID")%>"><%=ReturnSet("BuyerName") & " " & ReturnSet("BuyerSurname")%></a></td>
		<td class="tbldata"><%=ReturnSet("Email")%></td>
	</tr>
<%												
													ReturnSet.MoveNext
												Wend
%>
</table>
<br><hr>
<%												
											end if	
											
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing						
										end if
%>
<p class="bheader">Track a Buyer</p>
<p class="pcontent">Enter the buyer e-mail address in the field provided below.</p>
<form name="frmTrack" id="frmTrack" method="post" action="default.asp" onsubmit="return validate(this);">
<table border="0" cellpadding="2" cellspacing="2">
	<tr>
		<td class="pcontent"><b>E-mail address:</b></td>
		<td class="pcontent"><input type="text" name="txtMail" id="txtMail" size="40" class="pcontent"></td>
	</tr>
	<tr>
		<td class="pcontent"><input type="submit" name="btnSubmit" id="btnSubmit" value="submit" class="button">
			<input type="hidden" name="hidAction" id="hidActiontnSubmit" value="1">
		</td>
	</tr>
</table>
</form>
<!--#include file="../../layout/end.asp"-->