<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<xsl:choose>
			<xsl:when test="rootnode/smmessage/returnvalue!='0'">
				<table border="0" cellpadding="2" cellspacing="2" width="150%">
					<tr>
						<br />
						<br />
						<td class="bheader" align="left" valign="top">Electronic Remittance Advices</td>
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
				<table border="0" cellpadding="2" cellspacing="2" width="150%">
					<tr>
						<br />
						<br />

						<td class="bheader" align="left">Electronic Remittance Advices</td>
					</tr>
					<tr>
						<td class="pcontent">
							<br/>Electronic Remittance Advices Received on <b>@@Date</b>.</td>
					</tr>
				</table>
				<table border="0" cellpadding="2" cellspacing="2" width="65%">
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
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Report File Name</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Last Viewed</i></b></th>
<!--						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Report</i></b></th>-->
<!--						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Last viewed</i></b></th>-->
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>RA Date</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Payment Number</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Recieved By GateWay</i></b></th>
						<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Options</i></b></th>
					</tr>
					<xsl:apply-templates select="file"/>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="file">
		<tr>
			<td class="pcontent" align="center">
				<xsl:value-of select="filename"/>
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
	<!--		<td class="pcontent" align="center" width="15%">
				<a href="{viewfile}|{location}|era" target="about.blank">
					Remittance Statement
				</a>
				<a href="{viewfile}|{location}|era|headerAndDetails" target="about.blank">
					Header and Details<br></br>
				</a>
				<a href="{viewfile}|{location}|era|totals" target="about.blank">
					Totals<br></br>
				</a>
				<a href="{viewfile}|{location}|ti" target="about.blank">
					Tax Invoice
				</a>
			</td>-->
			<!--<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="tax_invoice_viewed =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="tax_invoice_viewed"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>-->
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="RADate =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="RADate"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="PaymentNumber =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="PaymentNumber"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="DateRecievedByGateWay =''">
						-
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="DateRecievedByGateWay"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
				<td class="pcontent" align="center">
				<a href="https://spar.gatewayec.co.za/sqlreports/viewDownload.asp?rid={viewSQLReport}" target="_blank">Download options</a>
				<!--<br></br>
				<a href="{viewPrintReportOptions}" target="_blank">View / Print report options</a>-->
				<br></br>
				<a href="https://spar.gatewayec.co.za/sqlreports/viewSQLReport.aspx?rid={viewSQLReport}" target="_blank">View SQL report</a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
