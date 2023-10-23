<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="NavLink" bgcolor="#333366" align="center"><a href="@@ApplicationRoot/track/dc/frmcontent.asp?action=1&amp;id=@@Date" class="NavLink" target="frmcontent">Orders</a></td>
			<td class="NavLink" bgcolor="#333366" align="center"><a href="@@ApplicationRoot/track/dc/frmcontent.asp?action=2&amp;id=@@Date" class="NavLink" target="frmcontent">Electronic Invoices</a><!--&#160;/&#160;
				<a href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/new.asp', 'GenInvoice', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');" class="NavLink" target="frmcontent">Generate Blank Invoice</a>-->
			</td>
			<td class="NavLink" bgcolor="#333366" align="center"><a href="@@ApplicationRoot/search/" class="NavLink" target="frmcontent">Search</a></td>
		</tr>
	</table><br/>
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Electronic Invoice Tracking Report</td>
					<td class="pcontent" align="left" rowspan="3">
						<table border="0" cellpadding="2" cellspacing="2">
							<tr>
								<td class="pcontent" valign="middle">
									<a class="stextnav" href="JavaScript: newWindow = openWin('@@ApplicationRoot/includes/help.asp', 'Help', 'width=300,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=0');"><img src="@@ApplicationRoot/layout/images/help.gif" border="0" alt="Help..."/>&#160;Help</a><br/>
									<a class="stextnav" href="javascript:if ( window.confirm('Are you sure you want to log out?')) window.location.href='@@ApplicationRoot/logout/progressbar.asp';"><img src="@@ApplicationRoot/layout/images/logout.gif" border="0" alt="Logout..."/>&#160;Logout</a>
								</td>
							</tr>
						</table>
					</td>
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
					<td class="bheader" align="left">Electronic Invoice Tracking Report</td>
					<td class="pcontent" align="right" rowspan="3">
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
					</td>
				</tr>
				<tr>
					<td class="pcontent"><br/>Invoices received per Store per Supplier for <b>@@Date</b>.</td>
				</tr>
				<tr>
					<td class="pcontent"><br/><b>Notes:</b></td>				
				</tr>
				<tr>
					<td class="pcontent">
						<ul>
							<li>Click on the <b>Invoice Number</b> link to view the Invoice.</li>
							<li>Click on the <b>Order Number</b> link to view the order.</li>
						</ul>
					</td>
				</tr>
			</table>
			<br/>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				 <xsl:apply-templates select="rootnode/spmessage/dc/store"/>
			</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="store">
	<tr>
		<td colspan="6"></td>
	</tr>
	<tr bgcolor="#333366">
		<td class="gheader" colspan="6" width="100%"><xsl:value-of select="name"/></td>
	</tr>
	<xsl:apply-templates select="supplier"/>
</xsl:template>

<xsl:template match="supplier">
	<tr>
		<td colspan="5"></td>
	</tr>
	<tr>
		<td>&#160;</td>
		<td class="nheader" colspan="5" bgcolor="#6699FF"><xsl:value-of select="name"/>&#160;[<xsl:value-of select="eannumber"/>]</td>
	</tr>
	<tr>
		<td>&#160;</td>
		<td colspan="4">
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Invoice Number</i></b><br/>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Application</i></b><br/>
						<b><i>Reference</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>File</i></b><br/>
						<b><i>Received</i></b><br/>
						<b><i>by Gateway</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Translation</i></b><br/>
						<b><i>To</i></b><br/>
						<b><i>FLAT or XML</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Posted to</i></b><br/>
						<b><i>Comms Centre</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Order</i></b><br/>
						<b><i>Number</i></b>
					</th>
				</tr>
				<xsl:apply-templates select="invoice"/>
			</table>
		</td>
	</tr>
</xsl:template>

<xsl:template match="invoice">	
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/default.asp?item={@id}&amp;success=0', 'InvoiceDetail', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resisable=1');"><xsl:value-of select="invoicenumber"/></a></td>
		<td class="pcontent" align="center">TAXCPY</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="receivedtime"/>]</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="transdate"/>]</td>	
		<xsl:choose>
			<xsl:when test="postdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="postdate"/><br/>[<xsl:value-of select="posttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ordernumber!=''">
				<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/order/default.asp?item={orderid}', 'OrderDetail', 'width=700,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="substring-before(ordernumber,'.')"/></a></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
</xsl:template>
</xsl:stylesheet>