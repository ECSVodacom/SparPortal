<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="rootnode/pmmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Supplier Purchase Order Tracking Report</td>
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
					<td width="50%" class="pcontent" valign="middel" colspan="4">
						<a class="textnav" href="javascript:window.print();">Print&#160;Report</a>&#160;|
						<a class="textnav" href="JavaScript: newWindow = openWin('@@Download', 'Download', 'width=500,height=280,toolbar=0,location=0,directories=0,status=1,menuBar=1,scrollBars=1,resizable=0');">Download&#160;tab&#160;file</a>
					</td>
				</tr>
				<tr>
					<td class="bheader" align="left" valign="top"><br/>Supplier Purchase Order Tracking Report</td>
					<td class="pcontent" align="right"><b>@@Date</b></td>
				</tr>
			</table><br/>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">

				 <xsl:apply-templates select="rootnode/pmmessage/detail"/>
			</table>
		</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="detail">
	<tr>
		<td class="sDCName" colspan="8"><xsl:value-of select="dcname"/></td>
	</tr>
	<xsl:apply-templates select="buyer"/>
</xsl:template>

<xsl:template match="buyer">
	<tr>
		<td>&#160;</td>
		<td class="pheader" colspan="6" bgcolor=""><xsl:value-of select="firstname"/>&#160;<xsl:value-of select="surname"/></td>
	</tr>
	<tr>
		<td>&#160;</td>
		<th class="pcontent" align="left">
			<b><i>PO No</i></b><br/>
		</th>
		<th class="pcontent" align="left">
			<b><i>Format</i></b><br/>
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
			<b><i>Mailbox</i></b>
		</th>
		<th class="pcontent" align="center">
			<b><i>Extracted by</i></b><br/>
			<b><i>Supplier</i></b>
		</th>
		<th class="pcontent" align="center">
			<b><i>Confirmation</i></b><br/>
			<b><i>One</i></b>
		</th>
		<th class="pcontent" align="center">
			<b><i>Confirmation</i></b><br/>
			<b><i>Two</i></b>
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
		<td class="pcontent">
			<xsl:choose>
				<xsl:when test="firstconfirmdate!=''">
					<a class="stextnav" target="_blank" href="@@ApplicationRoot/orders/buyer/default.asp?id={xmlref}&amp;type=1"><xsl:value-of select="displaynumber"/></a>
					<!-- Add "View" link to redirect to view page -->
					<a class="stextnav" target="_blank" href="@@ApplicationRoot/orders/supplier/default.asp?id={xmlref}&amp;type=1&amp;doAction=view">
						View
					</a>
					<!-- End of "View" link -->
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="//rootnode/pmmessage/checkorder='1'">
							<xsl:value-of select="displaynumber"/>
								<!-- Add "View" link to redirect to view page -->
								<a class="stextnav" target="_blank" href="@@ApplicationRoot/orders/supplier/default.asp?id={xmlref}&amp;type=1&amp;doAction=view">
									View
								</a>
								<!-- End of "View" link -->
								<br/>
						</xsl:when>
						<xsl:otherwise>
							<a class="stextnav" target="_blank" href="@@ApplicationRoot/orders/supplier/default.asp?id={xmlref}&amp;type=2"><xsl:value-of select="displaynumber"/></a>
								<!-- Add "View" link to redirect to view page -->
								<a class="stextnav" target="_blank" href="@@ApplicationRoot/orders/supplier/default.asp?id={xmlref}&amp;type=1&amp;doAction=view">
									View
								</a>
								<!-- End of "View" link -->
							<br/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="receiverean"/>
		</td>
		<td class="pcontent">@@Format</td>
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
					<td class="pcontent" align="center"><b>Extracted<br/>[no date supplied]</b></td>
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
		<td>&#160;</td>
		<td colspan="9"><hr color="lightgrey"/></td>
	</tr>
</xsl:template>
</xsl:stylesheet>