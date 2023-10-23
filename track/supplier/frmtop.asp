<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link rel="stylesheet" href="<%=const_app_ApplicationRoot%>/layout/css/classes.css" type="text/css">
		<title>Drop Shipment : Track and Trace</title>
	</head>
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ><a name="top"></a>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- TOPBAR CONTENT -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0" height="55">
						<tr>
							<td valign="top" align="left" height="5" width="100%"><!--<img name="TopStrap_r1_c2" src="<%=const_app_ApplicationRoot%>/layout/images/TopStrap_r1_c2.gif" width="299" height="5" border="0">--></td>
							<td></td>
							<td rowspan="3" align="right" valign="top"><a target="_blank" href="http://www.gatewaycomms.co.za" target="_top"><img src="<%=const_app_ApplicationRoot%>/layout/images/TopStrap_r1_c6.gif" width="171" height="55" border="0" alt="Gateway Communications"></a></td>
						</tr>
						<tr>
							<td bgcolor="#003366" valign="middle" class="topheadnav">
								<!-- BREADCRUMB BAR -->
								<table border="0" cellpadding="2" cellspacing="0" width="100%">
									<tr>
										<td class="pheader" align="top">Drop Shipment - Track and Trace</td>
									</tr>
								</table>
								<!-- /BREADCRUMB BAR -->
							</td>
							<td><img name="TopStrap_r2_c3" src="<%=const_app_ApplicationRoot%>/layout/images/TopStrap_r2_c3.gif" width="149" height="45" border="0"></td>
						</tr>
						<tr>
							<td valign="top" align="left" width="100%" height="5"></td>
							<td></td>
						</tr>
					</table>
					<!-- /TOPBAR CONTENT -->
				</td>
			</tr>
		</table>
		<!-- /TOPBAR CONTAINER -->
		<!-- NAVBAR CONTAINER -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td  valign="top">
								<table  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<!-- MAIN NAVIGATION -->
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr bgcolor="#ccccc2">
													<!--<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/orders/"class="NavLink" target="frmcontent">Orders</a></td>
													<td width="1" bgcolor="#333366"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/invoice/"class="NavLink" target="frmcontent">Invoices</a></td>
													<td width="1" bgcolor="#333366"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/notes/"class="NavLink" target="frmcontent">Credit Notes</a></td>												
													<td width="1" bgcolor="#333366"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/claims/"class="NavLink" target="frmcontent">Claims</a></td>
													<td width="1" bgcolor="#333366"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td class="NavLink" bgcolor="#333366" align="center"><a href="<%=const_app_ApplicationRoot%>/search/"class="NavLink" target="frmcontent">Search</a></td>-->
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
													<td width="1" bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/navline.gif" width="1" height="51"></td>
												</tr>
											</table>
											<!-- /MAIN NAVIGATION -->
										</td>
									</tr>
								</table>
							</td>
							<td width="100%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
									<tr>
										<td bgcolor="#ccccc2"><img src="<%=const_app_ApplicationRoot%>/layout/images/spacer.gif" width="10" height="51"></td>
										
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td bgcolor="#ccccc2" class="welcome" width="15%" height="51" align="left" valign="middel"><br>Welcome<br> <%=Session("ProcName")%></td>
			</tr>
		</table>
		<!-- /NAVBAR CONTAINER -->														
	</body>
</html>
