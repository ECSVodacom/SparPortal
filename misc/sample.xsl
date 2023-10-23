<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/" xml:space="preserve">

<form action="doorder.asp?id=@@XMLFile" method="post" name="updateorder" id="updateorder" onsubmit="return validate(this);">
	<table border="1" cellPadding="4" cellSpacing="2" width="100%">
    		<table border="0" cellPadding="4" cellSpacing="0" width="100%">
			 <tr>
			      <!-- <td width="50%" align="left"><img src="http://10.34.49.131/Spar/images/spar/sparlogo.gif"></img></td>-->
			       <td width="50%" align="left"><img src="https://spar.gatewayec.co.za/Spar/images/spar/sparlogo.gif"></img></td>
			       <td>
				       <table width="100%" align="right" valign="middle">
					       <tr>
						       <td><xsl:value-of select="/DOCUMENT/UNB/Sender/SenderReg"/></td>
					       </tr>
					       <tr>
						       <td><xsl:value-of select="DOCUMENT/UNB/Sender/SenderAddress"/></td>
					       </tr>
					       <tr>
						       <td><xsl:value-of select="DOCUMENT/UNB/Sender/SenderTel"/></td>
					       </tr>
					       <tr>
						       <td>VAT Reg.No. <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR2"/></td>
					       </tr>
				       </table>
				</td>
			</tr>
	    	</table>
		<table border="0" cellPadding="2" cellSpacing="0" width="100%">
			<tr>
				<td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverID"/></td>
				<td width="33%" VALIGN = "TOP">Delivery Instructions:</td>
				<td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR1"/></td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverAddress"/></td>
				<td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<td width="33%" VALIGN = "TOP">PO NR: <xsl:value-of select="DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/>
					<input type="hidden" name="txtOrderNumber" id="txtOrderNumber" value="{DOCUMENT/UNB/UNH/ORD/ORNO/ORNU}"/>
				</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP">DELIVERY DATE:<xsl:value-of select="DOCUMENT/UNB/UNH/DIN/EDAT"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP">RAIL TO SIDING <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/CLO/CDPN"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
		</table>
	</table>
	<table  style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
		<tr bgColor="#ccccc2">
			<td><i>Consumer Barcode<br>Order Barcode</br>Supp Prod Code</i></td>
			<td><i>Description</i></td>
			<td><i>Order<br/>Quantity<br/></i></td>
			<td><i>Store<br/>Pack<br/></i></td>
			<td><i>Vendor<br/>Pack<br/></i></td>
			<td><i>List<br/>Cost<br/></i></td>
			<td><i>Dea1 1<br/>Deal 3<br/>Deal 5</i></td>
			<td><i>Deal 2<br/>Deal 4<br/>Deal 6</i></td>
			<td><i>Discount<br/>Calculation<br/>Method</i></td>
			<td><i>Order<br/>Value<br/></i></td>
		</tr>
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<tr>
				<td align="left" valign="top"><xsl:value-of select="PROC/EANC"/>
					<br><xsl:value-of select="PROC/EANC2"/></br>
					<xsl:value-of select="PROC/SUPC"/>
				</td>
				<td align="left" valign="middle"><xsl:value-of select="PROC/PROD"/>
					<input type="hidden" name="txtDesc{@id}" id="txtDesc{@id}" size="5" value="{PROC/PROD}"/>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="QNTO/NROUC=''">
							<input type="text" name="txtQuantity{@id}" id="txtQuantity{@id}" size="5" value="{QNTO/NROU}" onchange="getTotal({@id});"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtQuantity{@id}" id="txtQuantity{@id}" size="5" value="{QNTO/NROUC}" onchange="getTotal({@id});"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="right" valign="middle">
					<xsl:choose>
						<xsl:when test="QNTO/CONU[. != ' ']">
							<xsl:value-of select="QNTO/CONU"/></xsl:when>
						<xsl:otherwise>
							&#160;
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="right" valign="middle">
					<xsl:choose>
						<xsl:when test="QNTO/TMEA[. !=' ']">
							<xsl:value-of select="QNTO/TMEA"/></xsl:when>
						<xsl:otherwise>
							1	
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="COST/COSPC=''">
							<input type="text" name="txtPrice{@id}" id="txtPrice{@id}" value="{COST/COSP}" size="5" onchange="getTotal({@id});"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtPrice{@id}" id="txtPrice{@id}" value="{COST/COSPC}" size="5" onchange="getTotal({@id});"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="top">
					<xsl:choose>
						<xsl:when test="CRAD/ADJI1[. != ' ']">
							<xsl:value-of select="CRAD/ADJI1"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC1[. != '0000000' and  . != '000.0000']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
									<xsl:when test="CRAD/VALU1[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					<br>   
					<xsl:choose>
						<xsl:when test="CRAD/ADJI3[. !='']">
							<xsl:value-of select="CRAD/ADJI3"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC3[. != '0000000' and . != '000.0000']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
									<xsl:when test="CRAD/VALU3[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</br>
					<xsl:choose>
						<xsl:when test="CRAD/ADJI5[. > ' ']">
							<xsl:value-of select="CRAD/ADJI5"/>
							<xsl:choose>
								<xsl:when test="CRAD/PERC5[. != '0000000' and . != '000.0000']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
								<xsl:when test="CRAD/VALU5[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="top">
					<xsl:choose>
						<xsl:when test="CRAD/ADJI2[. > ' ']">
							<xsl:value-of select="CRAD/ADJI2"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC2[. != '0000000' and . != '000.0000']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
									<xsl:when test="CRAD/VALU2[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					<br>   
					<xsl:choose>
						<xsl:when test="CRAD/ADJI4[. > ' ']">
							<xsl:value-of select="CRAD/ADJI4"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC4[. != '0000000' and . != '000.0000']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
									<xsl:when test="CRAD/VALU4[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					</br>
					<xsl:choose>
						<xsl:when test="CRAD/ADJI6[. > ' ']">
							<xsl:value-of select="CRAD/ADJI6"/>
								<xsl:choose>
									<xsl:when test="CRAD/PERC6[. != '0000000' and . != '000.0000']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
									<xsl:when test="CRAD/VALU6[. != '000000000000' and . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
								</xsl:choose>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left" valign="middle">
					<xsl:choose>
						<xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
						<xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
						<xsl:otherwise>Unknown</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="right" valign="middle">
					<xsl:choose>
						<xsl:when test="NELCC=''">
							<input type="text" name="txtTotalPrice{@id}" id="txtTotalPrice{@id}" size="10" value="{NELC}" onfocus="NoType({@id});"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtTotalPrice{@id}" id="txtTotalPrice{@id}" size="10" value="{NELCC}" onfocus="NoType({@id});"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td><i>Comments: </i></td>
				<td colspan = "13">
					<input type="text" name="txtComment{@id}" id="txtComment{@id}" value="{NARR}" size="100"/>	
					<input type="hidden" name="hidLineNumber{@id}" id="hidLineNumber{@id}" value="{@id}"/>	
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="FREE/NROU[.!= ' ']">
					<tr>
						<td colspan="14" bgcolor="#ffd700">
							<i>---Free Goods: <xsl:value-of select="FREE/PROD"/>  Qty: <xsl:value-of select="FREE/NROU"/>---</i>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<tr>
			<td colspan="5">&#160;</td>
			<td colspan="6" align="right"><b>Total</b>&#160;<input type="text" name="txtGrandTotal" id="txtGrandTotal" size="10" value="" onfocus="NoType(0);"/></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="submit" value="Save/Send Message" name="btnSubmit1" onclick="document.updateorder.hidAction.value=1;"></input></td>
			<td colspan="6"><i>This will save the changes to the database and send an email to the buyer</i></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="submit" value="Download XML File" name="btnSubmit2" onclick="document.updateorder.hidAction.value=2; document.updateorder.action='default.asp?id=@@XMLFile'"></input></td>
			<td colspan="6"><i>This will download the xml file to your local drive C:\Saved Files</i></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="submit" value="Download Tab Delimited File" name="btnSubmit2" onclick="document.updateorder.hidAction.value=3; document.updateorder.action='dotabfile.asp?id=@@XMLFile'"></input></td>
			<td colspan="6"><i>This will download a Tab Delimited File to your local drive C:\Saved Files</i></td>
		</tr>
		<tr>
			<td><input type="hidden"><xsl:attribute name="id">hidTotalCount</xsl:attribute><xsl:attribute name="name">hidTotalCount</xsl:attribute><xsl:attribute name="value"><xsl:value-of select="count(DOCUMENT/UNB/UNH/OLD/@id)"/></xsl:attribute></input>
				<input type="hidden" name="hidAction" id="hidAction" value=""/>
			</td>
		</tr>
	</table>
  </form>
 </xsl:template>
</xsl:stylesheet>

