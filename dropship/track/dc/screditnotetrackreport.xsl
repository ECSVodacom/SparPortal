<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<br/>
		<br/>
		<xsl:choose>
			<xsl:when test="rootnode/spmessage/returnvalue!='0'">
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
						<td class="bheader" align="left" valign="top">Credit Note Tracking Report</td>
					</tr>
					<tr>
						<td class="errortext">
							<br/>
							<xsl:value-of select="rootnode/spmessage/errormessage"/>
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
						<td class="bheader" align="left">Credit Note Tracking Report</td>
					</tr>
					<tr>
						<td class="pcontent">
							<br/>Credit Notes received per Distribution Centre per Store per Supplier for <b>@@Date</b>.</td>
					</tr>
					<tr>
						<td class="pcontent">
							<ul>
								<li class="errortext">NOTE: Only the first 200 records will be displayed due to the increased volume on credit notes. If you are looking for a specific credit note, click on the "search" menu item.</li>
								<li>Click on the <b>Credit Note Number</b> or  <b>List Referenced Claims</b> link to view the Credit Note detail or a list of references inside the selected Credit Note</li>
								<li>Click on the <b>Invoice Number</b> link to view the linked Invoice.</li>
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
		<tr>
			<td class="gheader" colspan="12" bgcolor="#333366" width="100%">
				<xsl:value-of select="name"/>&#160;DC&#160;(<xsl:value-of select="eannumber"/>)</td>
			<xsl:apply-templates select="store"/>
		</tr>
	</xsl:template>
	<xsl:template match="store">
		<tr>
			<td class="mheader" colspan="12" bgcolor="#ccccc2">SPAR Store: <xsl:value-of select="name"/>
			</td>
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
							<b>
								<i>Credit Note<br/>Number</i>
							</b>
							<br/>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Credit Note<br/>Type</i>
							</b>
							<br/>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>CRN Reason</i>
							</b>
							<br/>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>File</i>
							</b>
							<br/>
							<b>
								<i>Received</i>
							</b>
							<br/>
							<b>
								<i>by Gateway</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Translation</i>
							</b>
							<br/>
							<b>
								<i>To</i>
							</b>
							<br/>
							<b>
								<i>EDI or XML</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Posted to</i>
							</b>
							<br/>
							<b>
								<i>SPAR DC</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Received by</i>
							</b>
							<br/>
							<b>
								<i>SPAR DC</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Invoice Number</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>List Referenced Claims</i>
							</b>
						</th>
						<th class="pcontent" align="center" bgcolor="#ccccc2">
							<b>
								<i>Credit Value Incl</i>
							</b>
						</th>
					</tr>
					<xsl:apply-templates select="cnote"/>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="cnote">
		<tr>
			<td class="pcontent" align="center">
				<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/default.asp?item={@id}&amp;reason={reasoncode}', 'CreditNoteDetail', 'width=1200,height=900,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
					<xsl:value-of select="cnnumber"/>
				</a>
			</td>
			<td class="pcontent" align="center">
					<xsl:value-of select="type"/>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
				  <xsl:when test="reasoncode[.='SD']">Quantity</xsl:when>
				  <xsl:when test="type[.='DFC'] and reasoncode[.='GR']">Quantity</xsl:when>
				  <xsl:when test="type[.='RFC'] and reasoncode[.='GR']">Returns</xsl:when>
				  <xsl:when test="reasoncode[.='PD' or .='DD' or .='DR' or .='RB' or .='DU']">Pricing</xsl:when>
				  <xsl:when test="reasoncode[.='RC']">Returns (Crates)</xsl:when>
				  <xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:value-of select="receiveddate"/>
				<br/>[<xsl:value-of select="receivedtime"/>]</td>
			<td class="pcontent" align="center">
				<xsl:value-of select="transdate"/>
				<br/>[<xsl:value-of select="transtime"/>]</td>
			<xsl:choose>
				<xsl:when test="postdate!=''">
					<td class="pcontent" align="center">
						<xsl:value-of select="postdate"/>
						<br/>[<xsl:value-of select="posttime"/>]</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">-</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="dcpostdate!=''">
					<td class="pcontent" align="center">
						<xsl:value-of select="dcpostdate"/>
						<br/>[<xsl:value-of select="dcposttime"/>]</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">-</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="invid!='0'">
					<td class="pcontent" align="center">
						<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/default.asp?item={invid}', 'InvoiceDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
							<xsl:value-of select="invnum"/>
						</a>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">
						<xsl:choose>
							<xsl:when test="invnum!=''"><xsl:value-of select="invnum"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="totclaim!='0'">
					<td class="pcontent" align="center">
						<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/default.asp?item={@id}', 'CreditNoteDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">List Referenced Claims</a>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center">-</td>
				</xsl:otherwise>
			</xsl:choose>
			<td class="pcontent" align="center">R&#160;<xsl:value-of select="format-number (totcost,'DDD,DDD.00', 'staff')"/></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
