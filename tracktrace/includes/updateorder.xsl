<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="https://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
<xsl:output method="html" indent="yes"/>

<xsl:template match="/" xml:space="preserve">

<form action="doorder.asp?id=@@XMLFile" method="post" name="updateorder" id="updateorder" onsubmit="return validate(this);">
	<table border="1" cellPadding="4" cellSpacing="2" width="100%">
    		<table border="0" cellPadding="4" cellSpacing="0" width="100%">
			 <tr>
			       <td width="50%" align="left"><img src="@@ApplicationRoot/images/spar/sparlogo.gif"></img></td>
			       <td>
				       <table width="100%" align="right" valign="middle">
					       <tr>
						       <td class="pcontent"><xsl:value-of select="/DOCUMENT/UNB/Sender/SenderReg"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Sender/SenderAddress"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Sender/SenderTel"/></td>
					       </tr>
					       <tr>
						       <td class="pcontent"><b>VAT Reg.No.</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR2"/></td>
					       </tr>
				       </table>
				</td>
			</tr>
	    	</table>
		<table border="0" cellPadding="2" cellSpacing="0" width="100%">
			<tr>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverID"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>Delivery Instructions:</b></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR1"/></td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverAddress"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>PO NR: </b><xsl:value-of select="DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/>
					<input type="hidden" name="txtOrderNumber" id="txtOrderNumber" value="{DOCUMENT/UNB/UNH/ORD/ORNO/ORNU}"/>
				</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>Delivery Date:</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/EDAT"/></td>
				<td width="33%" VALIGN = "TOP"></td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><b>Rail To Siding</b> <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
				<td width="33%" VALIGN = "TOP" class="pcontent">@@PromItem</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP"><a href="javascript:window.print();"><img src="@@ApplicationRoot/images/spar/print_old.gif" border="0"/></a></td>
				<td width="33%" VALIGN = "TOP" class="pcontent"><xsl:value-of select="DOCUMENT/UNB/UNH/CLO/CDPN"/></td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
			<tr>
				<td width="33%" VALIGN = "TOP">&#160;</td>
				<td width="33%" VALIGN = "TOP">&#160;</td>
			</tr>
		</table>
	</table>
	<table  border="1" cellPadding="2" cellSpacing="0" width="100%">
		<tr bgColor="#ccccc2">
			<td class="pcontent"><i>Consumer Barcode<br/>Order Barcode<br/>Supp Prod Code</i></td>
			<td class="pcontent"><i>Description</i></td>
			<td class="pcontent"><i>Order<br/>Quantity<br/></i></td>
			<td class="pcontent"><i>Store<br/>Pack<br/></i></td>
			<td class="pcontent"><i>Vendor<br/>Pack<br/></i></td>
			<td class="pcontent"><i>List<br/>Cost<br/></i></td>
			<td class="pcontent"><i>Dea1 1<br/>Deal 3<br/>Deal 5</i></td>
			<td class="pcontent"><i>Deal 2<br/>Deal 4<br/>Deal 6</i></td>
			<td class="pcontent"><i>Discount<br/>Calculation<br/>Method</i></td>
			<td class="pcontent"><i>Order<br/>Value<br/></i></td>
		</tr>
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<tr>
				<td align="left" valign="top" class="pcontent"><xsl:value-of select="PROC/EANC"/><br/>
					<xsl:value-of select="PROC/EANC2"/><br/>
					<xsl:value-of select="PROC/SUPC"/>
					<xsl:if test="CDNO/CNDN != ''">
						<br/><b class="pcontent">Hi &amp; Ti:</b> <xsl:value-of select="CDNO/CNDN"/>
					</xsl:if>
				</td>
				<td align="left" valign="middle" class="pcontent"><xsl:value-of select="PROC/PROD"/>
					<input type="hidden" name="txtDesc{@id}" id="txtDesc{@id}" size="5" value="{PROC/PROD}"/>
				</td>
				<td class="pcontent">
					<xsl:choose>
						<xsl:when test="QNTO/NROUC=''">
							<input type="text" name="txtQuantity{@id}" id="txtQuantity{@id}" size="5" value="{QNTO/NROU}"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtQuantity{@id}" id="txtQuantity{@id}" size="5" value="{QNTO/NROUC}"/>
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
							<input type="text"><xsl:attribute name="name">txtPrice<xsl:value-of select="@id"/></xsl:attribute><xsl:attribute name="id">txtPrice<xsl:value-of select="@id"/></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="format-number(COST/COSP, 'DDD,DDD.00', 'staff')"/></xsl:attribute><xsl:attribute name="size">5</xsl:attribute></input>
						</xsl:when>
						<xsl:otherwise>
							<input type="text"><xsl:attribute name="name">txtPrice<xsl:value-of select="@id"/></xsl:attribute><xsl:attribute name="id">txtPrice<xsl:value-of select="@id"/></xsl:attribute><xsl:attribute name="value"><xsl:value-of select="format-number(COST/COSPC, 'DDD,DDD.00', 'staff')"/></xsl:attribute><xsl:attribute name="size">5</xsl:attribute></input>
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
				<td align="left" valign="middle" class="pcontent" width="20"><xsl:value-of select="format-number(NELC,'RDDD,DDD,DDD.00','staff')"/>
					<input type="hidden" name="hidTotalPrice{@id}" id="hidTotalPrice{@id}" value="{NELC}"/>
				</td>
			</tr>
			<tr>
				<td class="pcontent"><i>Comments: </i></td>
				<td colspan = "9" class="pcontent">
					<input type="text" name="txtComment{@id}" id="txtComment{@id}" value="{NARR}" size="100"/><br/>	
					<input type="hidden" name="hidLineNumber{@id}" id="hidLineNumber{@id}" value="{@id}"/>	
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="FREE/NROU[.!= ' ']">
					<tr>
						<td colspan="10" bgcolor="#ffd700" class="pcontent">
							<i>---Free Goods: <xsl:value-of select="FREE/PROD"/>  Qty: <xsl:value-of select="FREE/NROU"/>---</i>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<tr>
			<td colspan="5" align="left">&#160;</td>
			<td colspan="5" class="pcontent" align="right"><i><b>Total&#160;&#160;&#160;&#160;&#160;<xsl:value-of select="format-number(sum(DOCUMENT/UNB/UNH/OLD/NELC),'R DDD,DDD,DDD.00','staff')"/></b></i></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="submit" value="Save/Send Message" name="btnSubmit1" onclick="document.updateorder.hidAction.value=1;"></input></td>
			<td colspan="5" class="pcontent"><i>This will save the current xml file with the changes and send an email to the buyer</i></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="button" value="Download XML File" name="btnSubmit2" onclick="JavaScript: newWindow = openWin('@@ApplicationRoot/orders/supplier/downloadfile.asp?ref=@@XMLDownFile', 'XMLDownload', 'width=500,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=1,scrollBars=1,resizable=1');"></input></td>
			<td colspan="5" class="pcontent"><i>This will open a new window. To Save the file to your local drive, click on "File" and then the "Save As" tab in the menu bar of the new window.</i></td>
		</tr>
		<tr>
			<td colspan="5" align="left"><input type="button" value="Download Tab Delimited File" name="btnSubmit2" onclick="JavaScript: newWindow = openWin('@@ApplicationRoot/tabfile/@@TabFile', 'TabDownload', 'width=500,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=1,scrollBars=1,resizable=0');"></input></td>
			<td colspan="5" class="pcontent"><i>This will open a new window. To Save the file to your local drive, click on "File" and then the "Save As" tab in the menu bar of the new window.</i></td>
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

