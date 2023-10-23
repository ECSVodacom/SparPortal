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
				<td class="iheader" align="center">Electronic Invoice</td>
			</tr>
		</table><br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#b9b9b9">
			<tr>
				<td valign="top" bgcolor="#4C8ED7">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b>&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">FROM:&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent" bgcolor="#4C8ED7">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b>&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">TO:&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent" bgcolor="#4C8ED7">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">&#160; </b></td>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/suppliername"/></b><br/><br/>
								<b class="pcontent">VAT NO: <xsl:value-of select="//rootnode/smmessage/suppliervatno"/></b>
								<input type="hidden" name="hidSupplierVatNo" id="hidSupplierVatNo" value="{//rootnode/smmessage/suppliervatno}"/>
								<br/><br/>
								@@Address
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/storename"/></b><br/><br/>
								<b>PHONE: </b><xsl:value-of select="//rootnode/smmessage/storetel"/><br/>
								<b>FAX: </b><xsl:value-of select="//rootnode/smmessage/storeFax"/><br/>
								<b>VAT NO: </b><xsl:value-of select="//rootnode/smmessage/storevatno"/><input type="hidden" name="hidStoreVatNo" id="hidStoreVatNo" value="{//rootnode/smmessage/storevatno}"/><br/><br/>
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
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><br/><br/>
									<b>INVOICE NUMBER:</b>&#160;<xsl:value-of select="//rootnode/smmessage/invoicenumber"/><br/>
									<b>INVOICE DATE:</b>&#160;<xsl:value-of select="//rootnode/smmessage/invoicedate"/><br/><br/>
									<b>ORDER NR:</b>&#160;
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/ordernumber!=''">
											&#160;<a href="../order/default.asp?item={//rootnode/smmessage/orderid}" target="_blank"><xsl:value-of select="//rootnode/smmessage/ordernumber"/></a><br/>
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
					<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button"/>&#160;
					<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" />&#160;
					<input type="button" name="btnPrint" id="btnPrint" value="Print Invoice" class="button"  onclick="javascript:window.print();"/>&#160;
					<input type="button" name="btnPrintCopy" id="btnPrintCopy" value="Print Copy Tax Invoice" class="button"  onclick="javascript: validatePrint(document.updateorder);"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
				</td>
			</tr>
			<!-- End Create the Buttons -->		
		</table><br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent"><b>Consumer Barcode</b><br/>
					<b>Order Barcode</b><br/>
					<b>Supp Prod Code</b>
				</td>
				
				<td class="tdcontent" align="center"><b>Description</b></td>
				<td class="tdcontent" align="center"><b>Ordered<br/>Qty</b></td>
				<td class="tdcontent" align="center"><b>Invoiced<br/>Qty</b></td>
				<td class="tdcontent" align="center"><b>Unit of<br/>Measure</b></td>
				<td class="tdcontent" align="center"><b>Supplier<br/>Pack</b></td>
				<td class="tdcontent" align="center"><b>Order<br />List<br/>Cost</b></td>
				<td class="tdcontent" align="center"><b>Invoice<br />List<br/>Cost</b></td>
				<td class="tdcontent" align="center"><b>Deal1<br/>%/R</b></td>
				<td class="tdcontent" align="center"><b>Deal2<br/>%/R</b></td>
				<td class="tdcontent" align="center"><b>Total<br/>(excl VAT)</b></td>
				<td class="tdcontent" align="center"><b>VAT %</b></td>
				<td class="tdcontent" align="center"><b>VAT R</b></td>
				<td class="tdcontent" align="center"><b>Total Order<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center"><b>Total Invoice<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Qty of<br/>Free Goods</b></td>
			</tr>
			<xsl:apply-templates select="//rootnode/smmessage/invline"/>
			<tr>
				<td colspan="14" class="pcontent"></td>
			</tr>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Total:</b></td>
				<td>&#160;</td>
				<!--<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/subtotexcl,'###,##0.00', 'staff')"/></b>&#160;&#160;</td>-->
				<td class="tdcontent" align="right"><b>R&#160;@@TotNettCost</b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/subtotvat,'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (sum(//rootnode/smmessage/invline/total),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- Start Trade 1 Discount -->
			<tr>
				<td class="pcontent" colspan="9">Trade 1: &#160;
					<xsl:choose>
							<xsl:when test="//rootnode/smmessage/trade1perc!=''">
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/trade1perc='0'">
										0.00 %
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="format-number (//rootnode/smmessage/trade1perc,'DDD,DDD.00', 'staff')"/>&#160;%
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/trade1rand!=''">
										<xsl:value-of select="format-number (//rootnode/smmessage/trade1rand,'DDD,DDD.00', 'staff')"/>&#160;R
									</xsl:when>
									<xsl:otherwise>
										0.00 %
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade1TotExcl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade1TotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade1TotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Trade 1 Discount -->
			
			<!-- Start Trade 2 Discount -->
			<tr>
				<td class="pcontent" colspan="9">Trade 2: 	&#160;
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/trade2perc!=''">
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/trade2perc='0'">
									0.00 %
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number (//rootnode/smmessage/trade2perc,'DDD,DDD.00', 'staff')"/>&#160;%
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/trade2rand!=''">
									<xsl:value-of select="format-number (//rootnode/smmessage/trade2rand,'DDD,DDD.00', 'staff')"/>&#160;R
								</xsl:when>
								<xsl:otherwise>
									0.00 %
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade2TotExcl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade2TotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@Trade2TotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Trade 2 Discount -->
			
			<!-- Start Additional Discount -->
			<tr>
				<td class="pcontent" colspan="9">Additional Discount: &#160;
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/additionalperc!=''">
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/additionalperc='0'">
									0.00 %
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number (//rootnode/smmessage/additionalperc,'DDD,DDD.00', 'staff')"/>&#160;%
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/trade2rand!=''">
									<xsl:value-of select="format-number (//rootnode/smmessage/additionalrand,'DDD,DDD.00', 'staff')"/>&#160;R
								</xsl:when>
								<xsl:otherwise>
									0.00 %
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@AddTotExcl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@AddTotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@AddTotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Additional Discount -->
			<!-- Start Sub Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Sub Total:</b></td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@SubTotExl</b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@SubTotVat</b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@SubTotIncl</b>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Sub Totals -->
			<!-- Start Transport Discounts -->
			<tr>
				<td class="pcontent" colspan="9">Transport : 
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/transperc!=''">
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/transperc='0'">
									0.00 %
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number (//rootnode/smmessage/transperc,'DDD,DDD.00', 'staff')"/>&#160;%
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/transrand!=''">
									<xsl:value-of select="format-number (//rootnode/smmessage/transrand,'DDD,DDD.00', 'staff')"/>&#160;R
								</xsl:when>
								<xsl:otherwise>
									0.00 %
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@TransTotExl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@TransTotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@TransTotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Transport Discounts -->
			
			<!-- Start Duty/Levy Discounts -->
			<tr>
				<td class="pcontent" colspan="9">Duty/Levy: 
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/dutlevperc!=''">
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/dutlevperc='0'">
									0.00 %
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number (//rootnode/smmessage/dutlevperc,'DDD,DDD.00', 'staff')"/>&#160;%
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/dutlevrand!=''">
									<xsl:value-of select="format-number (//rootnode/smmessage/dutlevrand,'DDD,DDD.00', 'staff')"/>&#160;R
								</xsl:when>
								<xsl:otherwise>
									0.00 %
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@DutTotExl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@DutTotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;@@DutTotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Duty/Levy Discounts -->

			<!-- Start Invoice Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Invoice Total:</b></td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/grandtotexcl,'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/grandtotvat,'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (//rootnode/smmessage/grandtotincl,'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Invoice Totals -->
			
			<!-- Start Settlement Discount -->
			<tr>
				<td class="pcontent" colspan="9">Settlement Discount:
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/setdiscperc!=''">
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/setdiscperc='0'">
									0.00 %
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="format-number (//rootnode/smmessage/setdiscperc,'DDD,DDD.00', 'staff')"/>&#160;%
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							0.00 %
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@SetTotExl&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@SetTotVat&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;@@SetTotIncl&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Nett Due to DC:</b></td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@NettTotExcl&#160;&#160;</b></td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@NettTotVat&#160;&#160;</b></td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;@@NettTotIncl&#160;&#160;</b></td>
				<td>&#160;</td>
			</tr>
			<!-- End Settlement Discount -->
		</table>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="invline" >
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
 				<xsl:when test="ordunit!=''">
	 				<xsl:value-of select="ordunit"/><br/>
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
		<xsl:choose>
			<xsl:when test="orderqty!=''">
		 		<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="orderqty"/></b></td>
		 	</xsl:when>
		 	<xsl:otherwise>
		 		<td class="pcontent" align="center">-</td>
		 	</xsl:otherwise>
	 	</xsl:choose>
 		<!-- Check if the Order Quantity is the same as the invoice qty-->
 			<xsl:choose>
				<xsl:when test="orderqty!=''">
					<xsl:choose>
	 					<xsl:when test="orderqty = qty">
				 			<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="qty"/></b></td>
				 		</xsl:when>
			 			<xsl:otherwise>
			 				<td class="pcontent" bgcolor="red" align="center"><b><xsl:value-of select="qty"/></b></td>
					 	</xsl:otherwise>
					 </xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<td class="pcontent" align="center"><xsl:value-of select="qty"/></td>
				</xsl:otherwise>
		 	</xsl:choose>
 		<td class="pcontent" align="center">
 			<xsl:choose>
				<xsl:when test="measure!=''">
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
 		<xsl:choose>
			<xsl:when test="orderlinecost!=''">
				<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="format-number (orderlinecost,'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="orderlinecost!=''">
				<xsl:choose>
					<xsl:when test="orderlinecost = linecost">
						<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="linecost"/></b></td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" bgcolor="red" align="center"><b><xsl:value-of select="linecost"/></b></td>
					</xsl:otherwise>
				 </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center"><xsl:value-of select="linecost"/></td>
			</xsl:otherwise>
		</xsl:choose>
 		<td class="pcontent" align="right">
			<xsl:choose>
				<xsl:when test="deal1perc!=''">
					<xsl:choose>
						<xsl:when test="deal1perc='0' or deal1perc='0.00'">
							0.00&#160;&#160;
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number (deal1perc,'DDD,DDD.00', 'staff')"/>&#160;%&#160;&#160;						
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="deal1rand!='0' or deal1rand='0.00'">
							<b>R</b>&#160;<xsl:value-of select="format-number (deal1rand,'DDD,DDD.00', 'staff')"/>&#160;&#160;
						</xsl:when>
						<xsl:otherwise>
							0.00&#160;&#160;
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
			<xsl:choose>
				<xsl:when test="deal2perc!=''">
					<xsl:choose>
						<xsl:when test="deal2perc='0' or deal2perc='0.00'">
							0.00&#160;&#160;
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number (deal2perc,'DDD,DDD.00', 'staff')"/>&#160;%&#160;&#160;						
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="deal2rand!='0' or deal2rand='0.00'">
							<b>R</b>&#160;<xsl:value-of select="format-number (deal2rand,'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							0.00&#160;&#160;
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			<xsl:choose>
 				<xsl:when test="nettcost='0' or nettcost='0.00'">
 					0.00&#160;&#160;
 				</xsl:when>
 				<xsl:otherwise>
 					<xsl:value-of select="format-number (nettcost,'DDD,DDD.00', 'staff')"/>&#160;&#160;
 				</xsl:otherwise>
 			</xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			<xsl:choose>
 				<xsl:when test="vat='0'">
 					0.00&#160;&#160;
 				</xsl:when>
 				<xsl:otherwise>
 					<xsl:value-of select="format-number (vat,'DDD,DDD.00', 'staff')"/>&#160;&#160;
 				</xsl:otherwise>
 			</xsl:choose>
 		</td>
 		<td class="pcontent" align="right">
 			<xsl:choose>
 				<xsl:when test="vatr='0'">
 					0.00&#160;&#160;
 				</xsl:when>
 				<xsl:otherwise>
 					<xsl:value-of select="format-number (vatr,'DDD,DDD.00', 'staff')"/>&#160;&#160;
 				</xsl:otherwise>
 			</xsl:choose>
 		</td>
		
 		<xsl:choose>
			<xsl:when test="totalorder!=''">
				<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="format-number (totalorder,'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center">-</td>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="totalorder!=''">
				<xsl:choose>
					<xsl:when test="totalorder = total">
						<td class="pcontent" bgcolor="#FFFF00" align="center"><b><xsl:value-of select="format-number (total,'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" bgcolor="red" align="center"><b><xsl:value-of select="format-number (total,'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
					</xsl:otherwise>
				 </xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center"><xsl:value-of select="format-number (total,'###,##0.00', 'staff')"/></td>
			</xsl:otherwise>
		</xsl:choose>
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

