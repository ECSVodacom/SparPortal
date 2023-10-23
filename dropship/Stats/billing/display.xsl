<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<xsl:choose>
			<xsl:when test="rootnode/spmessage/returnvalue!='0'">
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
					<td class="pcontent" align="left" valign="top"><b>@@ReportType</b></td>
					</tr>
					<tr>
						<td class="errortext">
							<br/>
							<xsl:value-of select="rootnode/spmessage/errormessage"/>
							<br/>
						</td>
					</tr>
					<tr>
						<td class="pcontent">Select different criteria from the menus below.</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
			
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
					<td class="pcontent" align="left" valign="top"><b>@@ReportType</b></td>
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td class="pcontent" align="left" valign="top">
							<ul>
				<xsl:choose>
					<xsl:when test="rootnode/spmessage/drildown!=''">
						<li class="pcontent">Click on the <b>values in blue</b> to drill down</li>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="rootnode/spmessage/drildown2!=''">
						<li class="pcontent">Click on the <b>detail link</b> to view a full detail</li>
					</xsl:when>
				</xsl:choose>
							</ul>
						</td>
					</tr>
				</table>
				<xsl:apply-templates select="rootnode/spmessage/Main"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Main">
		<table border="1" cellpadding="0" cellspacing="0" width="100%">
			<xsl:apply-templates select="HeadingRow"/>
			<xsl:apply-templates select="DetailRow"/>
			<xsl:apply-templates select="FinalRow"/>
		</table>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="HeadingRow">
		<tr><xsl:apply-templates select="Header"/></tr>
	</xsl:template>
	<xsl:template match="Header">
		<xsl:choose>
			<xsl:when test="Multi!=''">
			<!--#4c8ed7-->
				<td class="pcontent" align="center" bgcolor="#4c8ed7" colspan="2"><b><font color="#ffffff"><xsl:value-of select="Header_Value"/></font></b></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center" bgcolor="#4c8ed7"><b><font color="#ffffff"><xsl:value-of select="Header_Value"/></font></b></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="DetailRow">
		<tr><xsl:apply-templates select="Detail"/></tr>
	</xsl:template>
	<xsl:template match="Detail">
		<xsl:choose>
			<xsl:when test="Detail_URL !=''">
				<xsl:choose>
					<xsl:when test="Multi!=''">
					<!--#4c8ed7-->
						<td class="pcontent" align="center" colspan="2">
							<a href="JavaScript: newWindow = openWin('@@FirstLocation{Detail_URL}', 'Stats', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="Detail_Value"/></a>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="center" >
							<a href="JavaScript: newWindow = openWin('@@FirstLocation{Detail_URL}', 'Stats', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="Detail_Value"/></a>
						</td>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise> <!-- No Detail URL -->
				<xsl:choose> <!-- URL -->
					<xsl:when test="URL !=''">
						<xsl:choose> <!-- special -->
							<xsl:when test="Special !=''">
								<td class="pcontent" align="center" bgcolor="#c0c0c0" >
								<b><a href="JavaScript: newWindow = openWin('@@Location{URL}', 'Stats', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="Detail_Value"/></a></b>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="pcontent" align="center" >
								<a href="JavaScript: newWindow = openWin('@@Location{URL}', 'Stats', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="Detail_Value"/></a>
								</td>
							</xsl:otherwise>
						</xsl:choose> <!-- special -->
					</xsl:when>
					<xsl:otherwise> <!-- No URL -->
						<xsl:choose> <!-- special -->
							<xsl:when test="Special !=''">
								<xsl:choose><!--multi-->
									<xsl:when test="Multi!=''"> 
										<td class="pcontent" colspan="2" align="center" bgcolor="#c0c0c0">
										<b><xsl:value-of select="Detail_Value"/></b>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td class="pcontent" align="center" bgcolor="#c0c0c0">
										<b><xsl:value-of select="Detail_Value"/></b>
										</td>
									</xsl:otherwise>
								</xsl:choose> <!--multi-->
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose><!--multi-->
									<xsl:when test="Multi!=''"> 
										<td class="pcontent" align="center" colspan="2"><xsl:value-of select="Detail_Value"/></td>
									</xsl:when>
									<xsl:otherwise>
										<td class="pcontent" align="center" ><xsl:value-of select="Detail_Value"/></td>
									</xsl:otherwise>
								</xsl:choose> <!--multi-->
							</xsl:otherwise>
						</xsl:choose> <!-- special -->
					</xsl:otherwise> <!-- No URL -->
				</xsl:choose> <!-- URL -->
			</xsl:otherwise> <!-- No Detail URL -->
		</xsl:choose>
	</xsl:template>
	<xsl:template match="FinalRow">
		<tr><xsl:apply-templates select="Final"/></tr>
	</xsl:template>
	<xsl:template match="Final">
		<xsl:choose>
			<xsl:when test="Multi!=''">
				<td class="pcontent" colspan="2" align="center" bgcolor="#c0c0c0"><b>
					<xsl:choose>
						<xsl:when test="Special !=''">
							<font color="red"><xsl:value-of select="Final_Value"/></font>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="Final_Value"/>
						</xsl:otherwise>
					</xsl:choose>
				</b></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center" bgcolor="#c0c0c0"><b>
					<xsl:choose>
						<xsl:when test="Special !=''">
							<font color="red"><xsl:value-of select="Final_Value"/></font>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="URL !=''">
									<a href="JavaScript: newWindow = openWin('@@Location{URL}', 'Stats', 'width=900,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="Final_Value"/></a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="Final_Value"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</b></td>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
