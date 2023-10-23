<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../includes/constants.asp"-->
<!--#include file="../includes/logincheck.asp"-->
<!--#include file="../includes/formatfunctions.asp"-->
<!--#include file="../includes/xmlfunctions.asp"-->
<!--#include file="includes/makeorders.asp"-->
<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		window.alert ('You have not accessed the facility for 15 minutes, therefore your session has expired. You are required to login again.');
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<!--#include file="../layout/start.asp"-->
<!--#include file="../layout/title.asp"-->
<!--#include file="../layout/headstart.asp"-->
<!--#include file="../layout/globaljavascript.asp"-->
<!--#include file="../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10">
<%
										' Determine what screen should be displayed
										Select Case Request.QueryString("id")
										Case "Home"
%>
<p class="bheader" valign="middle">Welcome to Spar Reporting<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%										
										Case "DC"
%>
<p class="bheader" valign="middle">SPAR Distribution Centre<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%										
										Case "DCReport"
%>
<p class="bheader" valign="middle">SPAR Distribution Centre - Reports<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%											
										Case "DCAdmin"
%>
<p class="bheader" valign="middle">SPAR Distribution Centre - Administration<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%											
										Case "DS"
%>
<p class="bheader" valign="middle">SPAR Drop Shipment<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%											
										Case "DSReport"
%>
<p class="bheader" valign="middle">SPAR Drop Shipment - Reports<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%											
										Case "DSAdmin"
%>
<p class="bheader" valign="middle">SPAR Drop Shipment - Administration<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%											
										Case "AckAdmin"
%>
<p class="bheader" valign="middle">Ackermans - Administration<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%
										Case "Monitor"
%>
<p class="bheader" valign="middle">Systems Monitor<br><br></p>
<!--<table border="1" cellspacing="0" cellpadding="0" align="center" valign="middle">
	<tr>
		<td class="pcontent">Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered here Text to be entered hereText to be entered hereText to be entered hereText to be entered hereText to be entered here</td>
	</tr>
</table>-->
<%
										End Select
%>
<!--#include file="../layout/end.asp"-->
