<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<!--<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="NavLink" bgcolor="#4C8ED7" align="center"><a href="@@ApplicationRoot/track/supplier/frmcontent.asp?action=1&amp;id=@@Date" class="NavLink" target="frmcontent">Orders</a></td>
			<td class="NavLink" bgcolor="#4C8ED7" align="center"><a href="@@ApplicationRoot/track/supplier/frmcontent.asp?action=2&amp;id=@@Date" class="NavLink" target="frmcontent">Electronic Invoices</a>@@GenInv
				&#160;/&#160;<a href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/supplier/invoice/new.asp', 'GenInvoice', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');" class="NavLink" target="frmcontent">Generate Blank Invoice</a>
			</td>
			<td class="NavLink" bgcolor="#4C8ED7" align="center"><a href="@@ApplicationRoot/search/" class="NavLink" target="frmcontent">Search</a></td>
		</tr>
	</table>--><br/><br/>
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
										<td bgcolor="red" colspan="2" align="center">KZN will be cutting over to SAP 28th - 29th January. The Spar portal is unavailable to all users during this period while changes are being implemented for this cutover and will be available again on Monday 30th..</td>
									</tr>
				<tr>
					<td class="bheader" align="left" valign="top">Order Tracking Report</td>
					<!--<td class="pcontent" align="left" rowspan="3">
						<table border="0" cellpadding="2" cellspacing="2">
							<tr>
								<td class="pcontent" valign="middle">
									<a class="stextnav" href="JavaScript: newWindow = openWin('@@ApplicationRoot/includes/help.asp', 'Help', 'width=300,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="@@ApplicationRoot/layout/images/help.gif" border="0" alt="Help..."/>&#160;Help</a><br/>
									<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) window.location.href='@@ApplicationRoot/logout/progressbar.asp';"><img src="@@ApplicationRoot/layout/images/logout.gif" border="0" alt="Logout..."/>&#160;Logout</a>
								</td>
							</tr>
						</table>
					</td>-->
				</tr>
				<tr>
					<td class="errortext"><br/><xsl:value-of select="rootnode/spmessage/errormessage"/><br/></td>
				</tr>
				<tr>
					<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
				</tr>
			</table>
		</xsl:when>
		<xsl:otherwise>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left">Order Tracking Report</td>
					<!--<td class="pcontent" align="right" rowspan="3">
						<table border="0" cellpadding="2" ceespacing="2">
							<tr>
								<td class="pcontent" valign="middle">
									<a class="stextnav" href="javascript:window.print();"><img src="@@ApplicationRoot/layout/images/print_new.gif" border="0" alt="Print this page..."/>&#160;Print this page</a><br/>
									<a class="stextnav" href="JavaScript: newWindow = openWin('@@ApplicationRoot/includes/help.asp', 'Help', 'width=300,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="@@ApplicationRoot/layout/images/help.gif" border="0" alt="Help..."/>&#160;Help</a><br/>
									<a class="stextnav" href="JavaScript: newWindow = openWin('@@ApplicationRoot/includes/bugreport.asp', 'BugReport', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="@@ApplicationRoot/layout/images/bug.gif" border="0" alt="Report a Bug..."/>&#160;Report a Bug</a><br/>
									<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) window.location.href='@@ApplicationRoot/logout/progressbar.asp';"><img src="@@ApplicationRoot/layout/images/logout.gif" border="0" alt="Logout..."/>&#160;Logout</a>
								</td>
							</tr>
						</table>
					</td>-->
				</tr>
				<tr>
					<td class="pcontent"><br/>Orders received per Supplier per Store for <b>@@Date</b>.</td>
				</tr>
				<tr>
					<td class="pcontent"><br/><b>Notes:</b></td>				
				</tr>
				<tr>
					<td class="pcontent">
						<ul>
							<li>Click on the <b>Order Number</b> link to view the Order.</li>
							<li>Click on the <b>List Invoices</b> link to view the Invoice.</li>
						</ul>
					</td>
				</tr>
			</table>
			<xsl:apply-templates select="rootnode/spmessage/supplier"/>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="supplier">
	<p class="sheader" colspan="9"><xsl:value-of select="name"/> (<xsl:value-of select="eannumber"/>)</p>
	<xsl:apply-templates select="store"/>
</xsl:template>

<xsl:template match="store">
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr bgcolor="#4C8ED7">
					<td class="nheader" colspan="9"><xsl:value-of select="name"/></td>
				</tr>
				<tr>
					<td>
						<table border="1" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Trace Number</i></b><br/>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>File</i></b><br/>
									<b><i>Received</i></b><br/>
									<b><i>by Gateway</i></b>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Translation</i></b><br/>
									<b><i>To</i></b><br/>
									<b><i>EDI or XML</i></b>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Delivery to</i></b><br/>
									<b><i>Mailbox</i></b>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Extracted by</i></b><br/>
									<b><i>Supplier</i></b>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Invoice Generated</i></b><br/>
									<b><i>by Supplier</i></b>
								</th>
								<th class="pcontent" align="center" bgcolor="#ccccc2">
									<b><i>Invoices</i></b>
								</th>
							</tr>
							<xsl:apply-templates select="order"/>
						</table>
					</td>
				</tr>
			</table>
		</tr>
	</table>
</xsl:template>

<xsl:template match="order">	
	<tr>
		<td class="pcontent" align="center">
			<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/supplier/order/default.asp?item={@id}', 'OrderDetail', 'width=700,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
			<xsl:value-of select="tracenumber"/></a></td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="receivedtime"/>]</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="transdate"/>]</td>	
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="mailboxtime"/>]</td>	
		<xsl:choose>
			<xsl:when test="extractdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="extractdate"/><br/>[<xsl:value-of select="extracttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="confirmdate!=''">
						<td class="pcontent" align="center"><b>Extracted [no date supplied]</b></td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="center">-</td>	
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="confirmdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="confirmdate"/><br/>[<xsl:value-of select="confirmtime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="invoicecount='1'">
				<td class="pcontent" align="center">
					<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/supplier/invoice/list.asp?item={@id}', 'OrderDetail', 'width=700,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">list invoices</a>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
</xsl:template>
</xsl:stylesheet>