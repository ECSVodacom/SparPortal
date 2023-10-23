<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="rootnode/pmmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Buyer Purchase Order Tracking Report</td>
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
					<td class="bheader" align="left">Buyer Purchase Order Tracking Report<br/><br/><br/></td>
					<td class="pcontent" valign="middel"><a href="javascript:window.print();"><img src="@@ApplicationRoot/images/spar/print_new.gif" border="0" width="25" height="25" alt="Print this report."/></a><br/> <b>Print</b></td>
				</tr>
				<tr>
					<td class="errortext">NOTE: Only the first 100 records will be displayed due to the increased volume on messages. If you are looking for a specific order number, click on the "search" menu item.</td>
				</tr>
			</table>
			<xsl:apply-templates select="rootnode/pmmessage/dc"/>
		</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="dc">
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>	
			<td class="pheader" colspan="8"><xsl:value-of select="name"/></td>
		</tr>
	</table>
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
			<th class="pcontent" width="20%" align="left">
				<i>Receiver Name</i><br/>
				<b><i>Message Format</i></b>
			</th>
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
				<b><i>EDI or XML</i></b>
			</th>
			<th class="pcontent" align="center">
				<b><i>Delivery to</i></b><br/>
				<b><i>Supplier</i></b><br/>
				<b><i>Mailbox</i></b>
			</th>
			<th class="pcontent" align="center">
				<b><i>Extracted</i></b><br/>
				<b><i>by</i></b><br/>
				<b><i>Supplier</i></b>
			</th>
			<th class="pcontent" align="center">
				<b><i>First</i></b><br/>
				<b><i>Confir-</i></b><br/>
				<b><i>mation</i></b>
			</th>
			<th class="pcontent" align="center">
				<b><i>Second</i></b><br/>
				<b><i>Confir-</i></b><br/>
				<b><i>mation</i></b>
			</th>
		</tr>
		<tr>
			<td colspan="8"><hr color="black"/></td>
		</tr>
		 <xsl:apply-templates select="order"/>
	</table>
</xsl:template>

<xsl:template match="order">
	<tr>
		<td class="pcontent" width="20%">
			<xsl:value-of select="receivername"/><br/>
			<xsl:value-of select="type"/>&#160;&#160;<xsl:value-of select="sendername"/>&#160;<xsl:value-of select="sendersurname"/>&#160;(<xsl:value-of select="sendercode"/>)
		</td>
		<td class="pcontent">
			<xsl:choose>
				<xsl:when test="firstconfirmdate!=''">
					<a class="textnav" target="_blank">
						<xsl:attribute name="href">@@ApplicationRoot/orders/buyer/default.asp?id=<xsl:value-of select="xmlref"/>&amp;type=1&amp;check=0
						</xsl:attribute>
						<xsl:value-of select="displaynumber"/>
					</a>

					<!-- Add "View" link that links to the invoice, link is on order number -->
					<a class="textnav" target="_blank">
						<xsl:attribute name="href">
							@@ApplicationRoot/orders/buyer/default.asp?id=<xsl:value-of select="xmlref"/>&amp;type=1&amp;check=0&amp;doAction=view
						</xsl:attribute>
						 View
					</a>
					<!-- End of "View" link -->

					<br/><xsl:value-of select="receivercode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="displaynumber"/>

					<!-- Add "View" link that links to the invoice, even if there is no link on the order number -->
					<a class="textnav" target="_blank">
						<xsl:attribute name="href">
							@@ApplicationRoot/orders/buyer/default.asp?id=<xsl:value-of select="xmlref"/>&amp;type=1&amp;check=0&amp;doAction=view
						</xsl:attribute>
						View
					</a>
					<!-- End of "View" link -->
					
					<br/><xsl:value-of select="receivercode"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<xsl:choose>
			<xsl:when test="receiveddate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="receivedtime"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="transdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="transtime"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="mailboxdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="mailboxtime"/></td>
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
					<td class="pcontent" align="center"><b>Extracted - Supplier could not<br/> provide date.</b></td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">N/A</td>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="firstconfirmdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="firstconfirmdate"/><br/>[<xsl:value-of select="firstconfirmtime"/>]</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="secondconfirmdate!=''">
				<td class="pcontent" align="center"><xsl:value-of select="secondconfirmdate"/><br/>[<xsl:value-of select="secondconfirmtime"/>]</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">N/A</td>							
			</xsl:otherwise>
		</xsl:choose>
	</tr>
	<tr>
		<td colspan="8" width="100%"><hr color="green"/></td>
	</tr>
	
</xsl:template>
</xsl:stylesheet>