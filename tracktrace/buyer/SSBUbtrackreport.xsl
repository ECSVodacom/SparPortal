<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="rootnode/pmmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">SSBU Order Tracking Report</td>
				</tr>
				<tr>
					<td class="errortext"><br/><xsl:value-of select="rootnode/pmmessage/errormessage"/><br/></td>
				</tr>
				<tr>
					<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
				</tr>
			</table>
		</xsl:when>
		<xsl:otherwise>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<br />
					<br />
					<td class="bheader" align="left" valign="top">SSBU Order Tracking Report</td>
				</tr>
				<tr>
					<td class="errortext"><br/><xsl:value-of select="rootnode/pmmessage/errormessage"/><br/></td>
				</tr>
				<tr>
					<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
				</tr>
			</table>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					
					<th class="pcontent" align="left">
						<b><i>PO No</i></b><br/>
						<b><i>Receiver EAN</i></b>
					</th>
					<th class="pcontent" align="center">
						<b><i>File</i></b><br/>
						<b><i>Received</i></b><br/>
						<b><i>by Gateway</i></b>
					</th>
					<th class="pcontent" align="center">
						<b><i>Translation</i></b><br/>
						<b><i>To</i></b><br/>
						<b><i>EDI</i></b>
					</th>
					<th class="pcontent" align="center">
						<b><i>Delivery to</i></b><br/>
						<b><i>SSBU</i></b><br/>
						
					</th>
					<th class="pcontent" align="center">
						<b><i>Extracted</i></b><br/>
						<b><i>by</i></b><br/>
						<b><i>SSBU</i></b>
					</th>
					
				</tr>
				<tr>
					<td colspan="8"><hr color="black"/></td>
				</tr>
				 <xsl:apply-templates select="rootnode/pmmessage/order"/>
			</table>
		</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="order">
	<tr>
		
		<td class="pcontent">
			<xsl:choose>
				<xsl:when test="firstconfirmdate!=''">
					<a class="textnav" target="_blank" href="@@ApplicationRoot/orders/buyer/default.asp?id={xmlref}&amp;type=1">
						@@Order<xsl:number count="order"/>Number
					</a>


					<!-- Add "View" link that links to the invoice, there is a link on the order number -->
					<a class="textnav" target="_blank">
						<xsl:attribute name="href">
							@@ApplicationRoot/orders/supplier/default.asp?id=<xsl:value-of select="xmlref"/>&amp;type=1&amp;check=0&amp;doAction=view
						</xsl:attribute>
						 View
					</a>
					<!-- End of "View" link -->

					<br/>
					<xsl:value-of select="receiverean"/>
					
				</xsl:when>
				<xsl:otherwise>
					
					@@Order<xsl:number count="order"/>Number
					
					<!-- Add "View" link that links to the invoice, even if there is no link on the order number -->
					<a class="textnav" target="_blank">
						<xsl:attribute name="href">
							@@ApplicationRoot/orders/supplier/default.asp?id=<xsl:value-of select="xmlref"/>&amp;type=1&amp;check=0&amp;doAction=view
						</xsl:attribute>
						 View
					</a>
					<!-- End of "View" link -->
					
					<br/><xsl:value-of select="receiverean"/>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:choose>
			<xsl:when test="receiveddate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="receiveddate"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="transdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="transdate"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="mailboxdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="mailboxdate"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="extractdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="extractdate"/><br/>[<xsl:value-of select="extracttime"/>]</td>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="firstconfirmdate!=''">
					<td class="pcontent" align="center"><b>Extracted - Supplier could not<br/>provide date</b></td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">N/A</td>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</tr>
	<tr>
		<td colspan="8" width="100%"><hr color="green"/></td>
	</tr>
</xsl:template>
</xsl:stylesheet>