<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
<xsl:output method="html" indent="yes"/>

<xsl:template match="/" xml:space="preserve">
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="left">ORDER&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
				<td class="pcontent" align="right">
					<table border="0" cellpadding="2" cellspacing="2">
						<tr>
							<td class="pcontent" valign="middle">
								<a class="stextnav" href="javascript:window.print();"><img src="@@ApplicationRoot/layout/images/print_new.gif" border="0" alt="Print this Order..."/>&#160;Print this Order</a><br/>
								<a class="stextnav" href="javascript:window.close();"><img src="@@ApplicationRoot/layout/images/close.gif" border="0" alt="Close this Order..."/>&#160;Close this Order</a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table><br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#333366">
			<tr>
				<td valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#333366"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#333366"><b class="tdcontent">TO:&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#333366"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#333366"><b class="tdcontent">FROM:&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#333366"><b class="tdcontent">&#160; </b></td>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#333366">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//DOCUMENT/UNB/Receiver/ReceiverName"/></b><br/><br/>
								<xsl:value-of select="//DOCUMENT/UNB/Receiver/ReceiverAddress"/>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#333366">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//DOCUMENT/UNB/Sender/SenderName"/></b><br/><br/>
								<b><xsl:value-of select="//DOCUMENT/UNB/Sender/SenderTel"/></b><br/>
								<b>DELIVERY INSTRUCTIONS:</b><br/>
									<xsl:value-of select="//DOCUMENT/UNB/Sender/SenderAddress"/><br/><br/>
								<b>DELIVERY DATE: </b><br/>
								<xsl:choose>
									<xsl:when test="//DOCUMENT/UNB/UNH/DIN/LDAT!=''">
										<xsl:value-of select="//DOCUMENT/UNB/UNH/DIN/LDAT"/><br/>
									</xsl:when>
									<xsl:otherwise>
										<b>Not Supplied</b><br/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#333366">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><br/><br/>
									<b>ORDER NR:</b>&#160;
									<xsl:choose>
										<xsl:when test="//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU!=''">
											&#160;<xsl:value-of select="//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>	
									<b>ORDER DATE: </b>
									<xsl:choose>
										<xsl:when test="//DOCUMENT/UNB/UNH/ORD/ORNO/DATE!=''">
											&#160;<xsl:value-of select="//DOCUMENT/UNB/UNH/ORD/ORNO/DATE"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>		
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table><br/>
		<table  border="1" cellPadding="2" cellSpacing="0" width="100%">
			<tr bgcolor="#333366">
					<td class="tdcontent"><b>Consumer Barcode</b><br/>
						<b>Order Barcode</b><br/>
						<b>Supp Prod Code</b>
					</td>
					<td class="tdcontent" align="center"><b>Description</b></td>
					<td class="tdcontent" align="center"><b>Order<br/>Qty</b></td>
					<td class="tdcontent" align="center"><b>UOM</b></td>
					<td class="tdcontent" align="center"><b>Supplr<br/>Pack</b></td>
					<td class="tdcontent" align="center"><b>List<br/>Cost</b></td>
					<td class="tdcontent" align="center"><b>Dea1 1<br/>Deal 3<br/>Deal 5</b></td>
					<td class="tdcontent" align="center"><b>Deal 2<br/>Deal 4<br/>Deal 6</b></td>
					<td class="tdcontent" align="center"><b>Discount<br/>Calculation<br/>Method</b></td>
					<td class="tdcontent" align="center"><b>Order<br/>Value</b></td>
				</tr>
		
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<tr>
				<td align="left" valign="top" class="pcontent"><xsl:value-of select="PROC/EANC"/>
					<br><xsl:value-of select="PROC/EANC2"/></br>
					<xsl:value-of select="PROC/SUPC"/>
				</td>
				<td align="left" valign="middle" class="pcontent"><xsl:value-of select="PROC/PROD"/></td>
				<td class="pcontent">
					<xsl:choose>
						<xsl:when test="QNTO/NROUC=''">
							<xsl:value-of select="QNTO/NROU"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="QNTO/NROUC"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="right" valign="middle" class="pcontent">
					<xsl:choose>
						<xsl:when test="QNTO/CONU[. != ' ']">
							<xsl:value-of select="QNTO/CONU"/></xsl:when>
						<xsl:otherwise>
							&#160;
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="right" valign="middle" class="pcontent">
					<xsl:choose>
						<xsl:when test="QNTO/TMEA[. !=' ']">
							<xsl:value-of select="QNTO/TMEA"/></xsl:when>
						<xsl:otherwise>
							1	
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td class="pcontent"><input type="hidden" name="hidPrice{@id}" id="hidPrice{@id}" size="5" value="{COST/COSP}"/>
					<xsl:choose>
						<xsl:when test="COST/COSPC=''">
							<xsl:value-of select="format-number(COST/COSP, 'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number(COST/COSPC, 'DDD,DDD.00', 'staff')"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="top" class="pcontent">
					<xsl:choose>
						<xsl:when test="CRAD/ADJI1[. != ' ']">
							<xsl:value-of select="CRAD/ADJI1"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC1[. != '0000000' and  . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
									<xsl:when test="CRAD/VALU1[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					<br>   
					<xsl:choose>
						<xsl:when test="CRAD/ADJI3[. !=' ']">
							<xsl:value-of select="CRAD/ADJI3"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC3[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
									<xsl:when test="CRAD/VALU3[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</br>
					<xsl:choose>
						<xsl:when test="CRAD/ADJI5[. != ' ']">
							<xsl:value-of select="CRAD/ADJI5"/>
							<xsl:choose>
								<xsl:when test="CRAD/PERC5[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
								<xsl:when test="CRAD/VALU5[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="top" class="pcontent">
					<xsl:choose>
						<xsl:when test="CRAD/ADJI2[. != ' ']">
							<xsl:value-of select="CRAD/ADJI2"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC2[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
									<xsl:when test="CRAD/VALU2[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					<br>   
					<xsl:choose>
						<xsl:when test="CRAD/ADJI4[. != ' ']">
							<xsl:value-of select="CRAD/ADJI4"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC4[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
									<xsl:when test="CRAD/VALU4[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</br>
					<xsl:choose>
						<xsl:when test="CRAD/ADJI6[. != ' ']">
							<xsl:value-of select="CRAD/ADJI6"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC6[. != '0000000' and . != '000.0000' and .!='']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
									<xsl:when test="CRAD/VALU6[. != '000000000000' and . != '00000000.0000' and .!='']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="middle" class="pcontent">
					<xsl:choose>
						<xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
						<xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
						<xsl:otherwise>Unknown</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="middle" class="pcontent" width="20"><xsl:value-of select="format-number(NELC,'RDDD,DDD,DDD.00','staff')"/></td>
			</tr>
		</xsl:for-each>
		<tr>
			<td colspan="5" align="left">&#160;</td>
			<td colspan="5" class="pcontent" align="right"><i><b>Total&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="format-number(sum(DOCUMENT/UNB/UNH/OLD/NELC),'R DDD,DDD,DDD.00','staff')"/></b></i></td>
		</tr>
	</table>
 </xsl:template>
</xsl:stylesheet>

