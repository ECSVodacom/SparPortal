<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<br/>
		<br/>
		<xsl:choose>
			<xsl:when test="rootnode/smmessage/returnvalue!='0'">
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
						<td class="bheader" align="left" valign="top">Recon Report</td>
					</tr>
					<tr>
						<td class="errortext">
							<br/>
							<xsl:value-of select="rootnode/smmessage/errormessage"/>
							<br/>
						</td>
					</tr>
					<tr>
						<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
						<td class="bheader" align="left">Recon Report</td>
					</tr>
					<tr>
						<td class="pcontent">
							<br/>Recon Reports Received on <b>@@Date</b>.</td>
					</tr>
				</table>
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<xsl:apply-templates select="rootnode/smmessage/DC"/>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="DC">
		<tr>
			<td class="gheader" colspan="12" bgcolor="#333366" width="100%"><xsl:value-of select="name"/></td>
			
		</tr>
		<xsl:apply-templates select="supplier"/>
		<tr></tr>
		<tr></tr>
	</xsl:template>
	<xsl:template match="supplier">
		<tr>
			<td>&#160;</td>
			<td class="nheader" colspan="10" bgcolor="#6699FF">Supplier: <xsl:value-of select="name"/></td>
		</tr>
		<tr>
			<td>&#160;</td>
			<td>
				<table border="1" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Recon Report</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Recon Report Summary</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Mail sent</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Last viewed</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Last downloaded</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Download</i></b></th>
					</tr>
					<xsl:apply-templates select="file"/>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="file">
		<tr>
			<td class="pcontent" align="center"><a href="{viewfile}|{location}|view" target="about.blank"><xsl:value-of select="filename"/></a></td>
			<td class="pcontent" align="center"><a href="{viewfile}|{location}|detail" target="about.blank">Click here for summary</a></td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="mailed =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="mailed"/>
					</xsl:otherwise>
					</xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="viewed =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="viewed"/>
					</xsl:otherwise>
					</xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="downloaded =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="downloaded"/>
					</xsl:otherwise>
					</xsl:choose>
			</td>
			<td class="pcontent" align="center"><a href="{path}">Download</a></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
