<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<p class="pheader">Supplier Tracking Report</p>
			<p class="errortext"><xsl:value-of select="rootnode/spmessage/errormessage"/></p>
			<p class="pcontent">Please choose another date from the tree menu on the left hand side of the page.</p>
		</xsl:when>
		<xsl:otherwise>
		
		<table border="0" cellpadding="0" cellspacing="0" width="20%">
			<tr>
				<td class="NavLink" bgcolor="#333366" align="center"><a href="@@ApplicationRoot/track/supplier/frmcontent.asp?action=1&amp;id=@@Date" class="NavLink" target="frmcontent">Orders</a></td>
				<td class="NavLink" bgcolor="#333366" align="center"><a href="@@ApplicationRoot/track/supplier/frmcontent.asp?action=2&amp;id=@@Date" class="NavLink" target="frmcontent">Invoices</a></td>
			</tr>
		</table>
		
		
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td width="50%" class="bheader">Supplier Tracking Report</td>
					<td class="pcontent" align="right" width="50%"><b><xsl:value-of select="rootnode/spmessage/suppliername"/><br/><br/>
						<xsl:value-of select="rootnode/spmessage/supplierean"/> </b>
					</td>	
				</tr>
			</table>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="pcontent" align="right" colspan="9"><b>@@Date</b></td>
				</tr>
				 <xsl:apply-templates select="rootnode/spmessage/store"/>
			</table>
		</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="store">
	<tr bgcolor="#333366">
		<td class="nheader" colspan="8"><xsl:value-of select="name"/></td>
	</tr>
	<tr>
		<td>&#160;</td>
		<th class="pcontent" align="left" bgcolor="#ccccc2">
			<b><i>Trace Number</i></b><br/>
		</th>
		<th class="pcontent" align="left" bgcolor="#ccccc2">
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
	</tr>
	<tr>
		<td>&#160;</td>
		<td colspan="8"><hr color="black"/></td>
	</tr>
	<xsl:apply-templates select="order"/>
</xsl:template>

<xsl:template match="order">	
	<tr>
		<td>&#160;</td>
		<td class="pcontent"><xsl:value-of select="tracenumber"/></td>
		<xsl:choose>
			<xsl:when test="type='1'">
				<td class="pcontent">Order</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent">Invoice</td>
			</xsl:otherwise>			
		</xsl:choose>
		<td class="pcontent" align="center"><xsl:value-of select="receivedtime"/></td>
		<td class="pcontent" align="center"><xsl:value-of select="transdate"/></td>	
		<td class="pcontent" align="center"><xsl:value-of select="mailboxtime"/></td>				
		<xsl:choose>
			<xsl:when test="extractdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="extractdate"/><br/>[<xsl:value-of select="extracttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="confirmdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="confirmdate"/><br/>[<xsl:value-of select="confirmtime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
	</tr>
	<tr>
		<td>&#160;</td>
		<td colspan="9"><hr color="lightgrey"/></td>
	</tr>
</xsl:template>
</xsl:stylesheet>