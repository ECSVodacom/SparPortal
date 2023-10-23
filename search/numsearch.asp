<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<%
										dim curConnection
										dim SQL
										dim ReturnSet
										dim Error
%>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../includes/validation.js"></script>
<script language="javascript">
<!--
	function validate(obj) {
		// Check if the user supplied a trace #
		if (obj.txtInvNum.value == '') {
			window.alert('You have to supply an Invoice Number.');
			obj.txtInvNum.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif">
<%
										' Check if the user selected to search
										if Request.Form("hidAction") = "1" Then
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
										
											' Build the SQL
											SQL = "exec procValidateInvNumber @InvoiceNumber=" & MakeSQLText(Request.Form("txtInvNum"))
											
											
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
										
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												Error = 1
											else
												Error = 0
											end if
										
											' Close the recordset
											Set ReturnSet = Nothing
												
											' Close the connection
											curConnection.Close
											Set curConnection = Nothing
										
										end if
%>
<p class="bheader">Validate Invoice Number</p>
<p class="pcontent">Enter the Invoice Number to be checked into the field below.</p>
<form name="FrmSearch" id="FrmSearch" method="post" action="numsearch.asp?item=<%=Request.QueryString("item")%>" onsubmit="return validate(this);">
	<table border="0" cellpadding="2" cellspacing="2">
		<tr>
			<td class="pcontent"><b>Invoice Number:</b></td>
			<td><input type="text" name="txtInvNum" id="txtInvNum" value="<%=Request.QueryString("item")%>"></td>
<%
										if Request.Form("hidAction") = 1 then
											' Check if there was an error or not
											if Error = 0 Then
%>
			<td class="pcontent">
				<table border="0" cellpadding="2" cellspacing="2">
					<tr>
						<td class="pcontent" align="center"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilihappy.gif"></td>
					</tr>
					<tr>
						<td class="pcontent">[<b>Valid Invoice Number</b>]</td>
					</tr>
				</table>
			</td>
<%			
											else
%>
			<td class="pcontent">
				<table border="0" cellpadding="2" cellspacing="2">
					<tr>
						<td class="pcontent" align="center"><img src="<%=const_app_ApplicationRoot%>/layout/images/smilicry.gif"></td>
					</tr>
					<tr>
						<td class="pcontent">[<b>Invalid Invoice Number</b>]<br>
													[Enter alternative Invoice Number]</td>
					</tr>
				</table>
			</td>
<%										
											end if
										end if
%>										
		</tr>
		<tr>
			<td colspan="2">
				<input type="submit" name="btnSubmit" id="btnSubmit" value="Validate" class="button">&nbsp;
				<input type="reset" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();">&nbsp;
				<input type="hidden" name="hidAction" id="hidAction" value="1">
			</td>
		</tr>
	</table>
</form>
<!--#include file="../layout/end.asp"-->
