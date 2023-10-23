<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<br/><br/><table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Electronic Invoice Tracking Report</td>
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
			<br/><br/><table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left">Electronic Invoice Tracking Report</td>
				</tr>
				<tr>
					<td class="pcontent"><br/>Invoices received per Distribution Centre per Store per Supplier for <b>@@Date</b>.</td>
				</tr>
				<tr>
					<td class="pcontent"><br/><b>Notes:</b></td>				
				</tr>
				<tr>
					<td class="pcontent">
						<ul>
							<li class="errortext">NOTE: Only the first 200 records will be displayed due to the increased volume on invoices. If you are looking for a specific invoice, click on the "search" menu item.</li>
							<li>Click on the <b>Invoice Number</b> link to view the Invoice.</li>
							<li>Click on the <b>Order Number</b> link to view the Order.</li>
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
	<!--<tr><td colspan="12"><br/></td></tr>-->
	<tr>
		<td class="gheader" colspan="12" bgcolor="#333366" width="100%"><xsl:value-of select="name"/> DC (<xsl:value-of select="eannumber"/>)</td>
		 <xsl:apply-templates select="store"/>
	</tr>
</xsl:template>

<xsl:template match="store">
	<tr>
		<td class="mheader" colspan="12" bgcolor="#ccccc2">Store Name:&#160; <xsl:value-of select="name"/></td>
	</tr>
	 <xsl:apply-templates select="supplier"/>
</xsl:template>

<xsl:template match="supplier">
	<tr>
		<td>&#160;</td>
		<td>&#160;</td>
		<td class="nheader" colspan="10" bgcolor="#6699FF">Supplier Name:&#160; <xsl:value-of select="name"/> (<xsl:value-of select="eannumber"/>)</td>
	</tr>
	<tr>
		<td>&#160;</td>
		<td>&#160;</td>
		<td>
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
						<b><i>SPAR DC</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Received by</i></b><br/>
						<b><i>SPAR DC</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Order</i></b><br/>
						<b><i>Number</i></b>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Claim</i></b><br/>
					</th>
					<th class="pcontent" align="center" bgcolor="#ccccc2">
						<b><i>Credit Note</i></b><br/>
					</th>
				</tr>
				<xsl:apply-templates select="invoice"/>
			</table>
		</td>
	</tr>
</xsl:template>

<xsl:template match="invoice">	
	<tr>
		<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/default.asp?item={@id}&amp;success=0', 'InvoiceDetail', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="invoicenumber"/></a></td>
		<td class="pcontent" align="center">TAXCPY</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="receivedtime"/>]</td>
		<td class="pcontent" align="center">@@Date<br/>[<xsl:value-of select="transdate"/>]</td>	
		<xsl:choose>
			<xsl:when test="postdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="postdate"/><br/>[<xsl:value-of select="posttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="dcpostdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="postdate"/><br/>[<xsl:value-of select="dcposttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ordernumber!=''">
				<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/order/default.asp?item={orderid}', 'OrderDetail', 'width=750,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="substring-before(ordernumber,'.')"/></a></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ClaimNumber!=''">
				<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/claim/default.asp?item={ClaimId}', 'ClaimDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="ClaimNumber"/></a></td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="CreditNoteNumber!=''">
				<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/default.asp?item={CreditNoteId}', 'CreditNoteDetail', 'width=1200,height=900,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="CreditNoteNumber"/></a></td>							
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
</xsl:template>
</xsl:stylesheet>