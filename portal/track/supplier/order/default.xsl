<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
<xsl:key name="values-by-currency" match="nettcost" use="//rootnode/smmessage/ordline/nettcost"/>
<xsl:output method="html" indent="yes"/>

<xsl:template match="/" xml:space="preserve">
<xsl:choose>
	<xsl:when test="//rootnode/smmessage/returnvalue!='0'">
		<p><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></p>
		<p class="pcontent"><b>ERROR:</b></p>
		<p class="errortext"><xsl:value-of select="//rootnode/smmessage/errormessage"/></p>
		<p class="pcontent" align="center"><b>[<a class="stextnav" href="javascript:window.close ();">Close this Window</a>]</b></p>
	</xsl:when>
	<xsl:otherwise>
	<form action="doorder.asp?id=@@XMLFile" method="post" name="updateorder" id="updateorder" onsubmit="return validate(this);">
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="left">ORDER&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
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
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/suppliername"/></b><br/><br/>
								@@Address
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#333366">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/storename"/></b><br/><br/>
								<b>PHONE: </b><xsl:value-of select="//rootnode/smmessage/storetel"/><br/>
								<b>FAX: </b><xsl:value-of select="//rootnode/smmessage/storeFax"/><br/><br/>
								<b>DELIVERY INSTRUCTIONS:</b><br/>
								<xsl:if test="//rootnode/smmessage/storeaddress!=''">
									<xsl:value-of select="//rootnode/smmessage/storeaddress"/><br/><br/>
								</xsl:if>
								<b>DELIVERY DATE: </b><br/>
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/delivdate!=''">
										<xsl:value-of select="//rootnode/smmessage/delivdate"/><br/>
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
										<xsl:when test="//rootnode/smmessage/ordernumber!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/ordernumber"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>	
									<b>ORDER DATE: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/receivedate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/receivedate"/><br/>
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
		</table>
		<br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Create the Buttons -->
			<tr>
				<td class="pcontent" align="center">
					<xsl:if test="//rootnode/smmessage/isxml='1'">
						<input type="button" name="btnInvoice" id="btnInvoice" value="Generate Invoice" onclick="javascript: location.href='@@ApplicationRoot/track/supplier/order/geninv.asp?item=@@OrdID'" class="button"/>&#160;
						<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@OrdID&amp;type=xml'"/>&#160;
						<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@OrdID&amp;type=txt'"/>&#160;
					</xsl:if>
					<input type="button" name="btnPrint" id="btnPrint" value="Print Order" class="button"  onclick="javascript:window.print();"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
				</td>
			</tr>
			<!-- End Create the Buttons -->		
		</table><br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%">
			<tr bgcolor="#333366">
				<td class="tdcontent"><b>Consumer Barcode</b><br/>
					<b>Order Barcode</b><br/>
					<b>Supp Prod Code</b>
				</td>
				<td class="tdcontent"><b>Description</b></td>
				<td class="tdcontent"><b>Ord<br/>Qty</b></td>
				<td class="tdcontent"><b>UOMeasure</b></td>
				<td class="tdcontent"><b>Suppl<br/>Pack</b></td>
				<td class="tdcontent"><b>List<br/>Cost</b></td>
				<td class="tdcontent"><b>Deal1 %</b></td>
				<td class="tdcontent"><b>Deal2 %</b></td>
				<td class="tdcontent"><b>Total<br/>(excl VAT)</b></td>
				<td class="tdcontent"><b>VAT %</b></td>
				<td class="tdcontent"><b>VAT R</b></td>
				<td class="tdcontent" align="center" width="10%"><b>Total<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Free Goods<br/> Qty</b></td>
			</tr>
			<xsl:apply-templates select="//rootnode/smmessage/ordline"/>
			<tr>
				<td colspan="13" class="pcontent">&#160;</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="8"><b>Sub Totals:</b></td>
				<td class="pcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (sum(//rootnode/smmessage/ordline/nettcost),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (sum(//rootnode/smmessage/ordline/vatr),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td class="pcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (sum(//rootnode/smmessage/ordline/total),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="8">TRADE 1: (%)</td>
				<td class="pcontent" align="right">
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/trade1='0'">
							0.00&#160;&#160;
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number (//rootnode/smmessage/trade1,'DDD,DDD.00', 'staff')"/>&#160;&#160;
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="8">TRADE 2: (%)</td>
				<td class="pcontent" align="right">
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/trade1='0'">
							0.00&#160;&#160;
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number (//rootnode/smmessage/trade1,'DDD,DDD.00', 'staff')"/>&#160;&#160;
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
			</tr>
			<!--<tr>
				<td class="pcontent" colspan="8"><b>Grand Totals:</b></td>
				<td class="pcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/ordline/grandtotalexl,'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/ordline/vatr),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td class="pcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/ordline/total),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>-->
			<tr>
				<td class="pcontent" colspan="8">SETTLEMENT DISCOUNT:</td>
				<td class="pcontent" align="right">0.00&#160;&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
				<td>&#160;</td>
			</tr>
		</table>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="ordline" >
 	<tr>
 		<td class="pcontent">
 			<xsl:choose>
 				<xsl:when test="barcode!=''">
 					<xsl:value-of select="barcode"/><br/>
 				</xsl:when>
 				<xsl:otherwise>
 					&#160;&#160;&#160;-<br/>
 				</xsl:otherwise>
 			</xsl:choose>
 			<xsl:choose>
 				<xsl:when test="ordbarcode!=''">
	 				<xsl:value-of select="ordbarcode"/><br/>
	 			</xsl:when>
	 			<xsl:otherwise>
 						&#160;&#160;&#160;-<br/>
 				</xsl:otherwise>
 			</xsl:choose>
 			<xsl:choose>
 				<xsl:when test="prodcode!=''">
	 				<xsl:value-of select="prodcode"/>
	 			</xsl:when>
	 			<xsl:otherwise>
 						&#160;&#160;&#160;-
 				</xsl:otherwise>
 			</xsl:choose>
 		</td>
 		<td class="pcontent" align="center"><xsl:value-of select="proddescr"/></td>
 		<td class="pcontent" align="center"><xsl:value-of select="qty"/></td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="measure!=' '">
			 		<xsl:value-of select="measure"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					-	 	
			 	</xsl:otherwise>
			 </xsl:choose>
		  </td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="supplpack!=''">
			 		<xsl:value-of select="supplpack"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					-	 
			 	</xsl:otherwise>
			 </xsl:choose>
		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="linecost='0'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (linecost,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			<xsl:choose>
 				<xsl:when test="deal1='0'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (deal1,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="deal2='0'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (deal2,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="nettcost='0'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (nettcost,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="vat='0' or vat='0.00'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (vat,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		 		
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="vatr='0' or vatr='0.00'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (vatr,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		 		 		
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="total='0' or total='0.00'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (total,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		 		 		 		
 		</td>
 		<td class="pcontent" align="center">
 		<xsl:choose>
 			<xsl:when test="free!=''">
 				<xsl:value-of select="free"/>
 			</xsl:when>
 			<xsl:otherwise>
 				0
 			</xsl:otherwise>
 		</xsl:choose>
 		</td>
 	</tr>
 </xsl:template>
</xsl:stylesheet>

