<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<html>
	<head>
		<title>SPAR DS TRACK & TRACE</title>
		<link rel="stylesheet" type="text/css" href="<%=const_app_ApplicationRoot%>/layout/css/Afr_Style.css">
	</head>
	<body marginheight="0" leftmargin="0" topmargin="0" vlink="#27408B" alink="#27408B" link="#27408B">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tbody>
						<tr>
						<!--	<td rowspan="2" align="left" background="<%=const_app_ApplicationRoot%>/layout/images/hdrbg01.gif" height="93" valign="top" width="242">
								<a href="http://www.vodacom.co.za/business/" target="_NEW">
									<img src="<%=const_app_ApplicationRoot%>/layout/images/newgatelogo1.gif" border="0" height="75">
								</a>
							</td>-->
							<td background="<%=const_app_ApplicationRoot%>/layout/images/hdrbg02.gif" height="11"></td>
						</tr>
						<tr>
							<td align="right" background="<%=const_app_ApplicationRoot%>/layout/images/hdrbg03.gif" height="82">
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tbody>
										<tr>
											<td width="60%" align="center"><H1>SPAR DROP SHIPMENT:<br>TRACKING FACILITY</H1></td>
											<td width="20%" align="right"><img src="<%=const_app_ApplicationRoot%>/layout/images/SparLogoBuild.jpg" border="0">&nbsp;&nbsp;</td>
											<td width="20%" align="right"><img src="<%=const_app_ApplicationRoot%>/layout/images/sparlogo1.gif" border="0">&nbsp;&nbsp;</td>
										</tr>
									</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tbody>
			<tr>
				<td align="left" background="<%=const_app_ApplicationRoot%>/layout/images/hdrbg04.gif" height="25">
<%
										if Session("Permission") = 2 Then
%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="<%=const_app_ApplicationRoot%>/layout/images/bulletcca.gif">&nbsp;<a class="search" target="frmcontent" href="<%=const_app_ApplicationRoot%>/tracktrace/buyer/search/default.asp">Search Orders</a>
<%
										end if
%>
				</td>
				<td align="right" background="<%=const_app_ApplicationRoot%>/layout/images/hdrbg04.gif" height="25">&nbsp;&nbsp;<img src="<%=const_app_ApplicationRoot%>/layout/images/bulletcca.gif">&nbsp;<font color="#ffffff">Welcome back&nbsp;</font><font color="#00006A"><b><%=Session("FirstName") & " " & Session("Surname")%>&nbsp;</b></font></td>
			</tr>
		</tbody>
	</table>	
</html>
