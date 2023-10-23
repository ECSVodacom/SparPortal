<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">

	<br/><br/>
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Order Tracking Report</td>
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
					<!--<td class="pcontent" align="left" rowspan="3">
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
					<td class="pcontent"><br/>Orders received per Distribution Centre per Store per Supplier for <b>@@Date</b>.</td>
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
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				 <xsl:apply-templates select="rootnode/spmessage/dc"/>
			</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="dc">
	<!--<tr><td colspan="12"></td></tr>-->
	<tr>
		<td class="gheader" colspan="12" bgcolor="#333366" width="100%"><xsl:value-of select="name"/>&#160;DC&#160;(<xsl:value-of select="eannumber"/>)</td>
		 <xsl:apply-templates select="store"/>
	</tr>
</xsl:template>

<xsl:template match="store">
	<tr>
		<td class="mheader" colspan="12" bgcolor="#ccccc2">SPAR Store: <xsl:value-of select="name"/></td>
	</tr>
	 <xsl:apply-templates select="supplier"/>
</xsl:template>

<xsl:template match="supplier">
	<tr>
		<td>&#160;</td>
		<td>&#160;</td>
		<td class="nheader" colspan="10" bgcolor="#6699FF">Supplier: <xsl:value-of select="name"/> (<xsl:value-of select="eannumber"/>)</td>
	</tr>
	<tr>
		<td>&#160;</td>
		<td>&#160;</td>
		<td>
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Order Number</i></b><br/>
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
</xsl:template>

<xsl:template match="order">	
	<tr>
		<td class="pcontent" align="center">
			<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/order/default.asp?item={@id}', 'OrderDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
			<xsl:value-of select="tracenumber"/></a></td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="receivedtime"/>]</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="transdate"/>]</td>	
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="mailboxtime"/>]</td>			
		<xsl:choose>
			<xsl:when test="extractdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="extracttime"/><br/>[<xsl:value-of select="extractdate"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="confirmdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="confirmtime"/><br/>[<xsl:value-of select="confirmdate"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="invoicecount='1'">
				<td class="pcontent" align="center">
					<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/list.asp?item={@id}', 'InvoiceDetail', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">list invoices</a>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
</xsl:template>
</xsl:stylesheet>