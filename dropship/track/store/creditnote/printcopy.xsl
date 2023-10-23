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
	<form action="doorder.asp?id=@@XMLFile" method="post" name="updatecr" id="updatecr" onsubmit="return validate(this);">
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="left">Copy Tax Credit Note</td>
			</tr>
		</table><br/>
		
		<br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#4C8ED7">
			<tr>
				<td valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">FROM:&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">TO:&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent">
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
								<b class="pcontent">VAT NO: <xsl:value-of select="//rootnode/smmessage/suppliervatno"/></b><br/><br/>
								<input type="hidden" name="hidSupplierVatNo" id="hidSupplierVatNo" value="{//rootnode/smmessage/suppliervatno}"/>
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
								<b>FAX: </b><xsl:value-of select="//rootnode/smmessage/storefax"/><br/>
								<b>VAT NO: </b><xsl:value-of select="//rootnode/smmessage/storevatno"/><input type="hidden" name="hidStoreVatNo" id="hidStoreVatNo" value="{//rootnode/smmessage/storevatno}"/><br/><br/>
								<b>ADDRESS:</b><br/>
								<xsl:if test="//rootnode/smmessage/storeaddr!=''">
									<xsl:value-of select="//rootnode/smmessage/storeaddr"/><br/><br/>
								</xsl:if>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent">
									<b>CLAIM NR:</b>&#160;
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/claimnumber!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/claimnumber"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>	
									<b>CLAIM DATE: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/claimdate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/claimdate"/><br/><br/>
										</xsl:when>
											<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/><br/>
										</xsl:otherwise>
									</xsl:choose>	
									<b>INVOICE NR: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/invoicenum!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/invoicenum"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>
									<b>INVOICE DATE: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/invoicedate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/invoicedate"/><br/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/><br/>
										</xsl:otherwise>
									</xsl:choose>
									<b>MANUAL CLAIM NR: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/manualnum!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/manualnum"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>
									<b>MANUAL CLAIM DATE: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/manualdate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/manualdate"/><br/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/><br/>
										</xsl:otherwise>
									</xsl:choose>
									<b>CREDIT NOTE NR: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/cnnum!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/cnnum"/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/>
										</xsl:otherwise>
									</xsl:choose>
									<b>CREDIT NOTE DATE: </b>
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/cndate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/cndate"/><br/><br/>
										</xsl:when>
										<xsl:otherwise>
											&#160;<b>Not Supplied</b><br/><br/>
										</xsl:otherwise>
									</xsl:choose>		
								</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top"><b>TRADE DISCOUNT 1 %</b><br/>
					<b>TRADE DISCOUNT 2 %</b><br/>
					<b>TRADE DISCOUNT 3 %</b>
				</td>
				<td class="pcontent" valign="top">
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc1!=''">
							&#160;&#160;&#160;<xsl:value-of select="format-number (//rootnode/smmessage/discperc1,'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							&#160;&#160;&#160;0.00
						</xsl:otherwise>
					</xsl:choose><br/>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc2!=''">
							&#160;&#160;&#160;<xsl:value-of select="format-number (//rootnode/smmessage/discperc2,'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							&#160;&#160;&#160;0.00
						</xsl:otherwise>
					</xsl:choose><br/>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc3!=''">
							&#160;&#160;&#160;<xsl:value-of select="format-number (//rootnode/smmessage/discperc3,'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							&#160;&#160;&#160;0.00
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>	
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top"><b>CLAIM AMOUNT</b><br/>
					<b>VAT AMOUNT</b><br/>
					<b>TOTAL</b>
				</td>
				<td class="pcontent" valign="top"><!--&#160;&#160;&#160;<b>R</b>&#160-->
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/amt!='' or //rootnode/smmessage/amt!='0'">
							&#160;&#160;&#160;<b>R</b>&#160;&#160;<xsl:value-of select="format-number ((//rootnode/smmessage/amt) - (//rootnode/smmessage/vat),'DDD,DDD.00','staff') "/>
					</xsl:when>
				</xsl:choose>
				
					<br/>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/vat!='' or //rootnode/smmessage/vat!='0'">
							&#160;&#160;&#160;<b>R</b>&#160;&#160;<xsl:value-of select="format-number (//rootnode/smmessage/vat,'DDD,DDD.00', 'staff')"/>
						</xsl:when>
						<xsl:otherwise>
							&#160;&#160;&#160;<b>R</b>&#160;0.00
						</xsl:otherwise>
					</xsl:choose><br/>
							
					
					<!--<xsl:choose>-->
						&#160;&#160;&#160;<b>R</b>&#160;&#160;<xsl:value-of select="format-number ((//rootnode/smmessage/amt),'DDD,DDD.00', 'staff')"/>
					<!--</xsl:choose>-->
					
				</td>
			</tr>			
			<tr>
				<td class="pcontent" colspan="3" align="left" valign="top"><b>HEADER NARRATIVE: </b><xsl:value-of select="//rootnode/smmessage/narrative"/></td>
			</tr>
		</table>
		<br/>
		<xsl:if test="//rootnode/smmessage/numlines!=0">	
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="left"><b>Product Code<br/>Product Barcode</b></td>
					<td class="tdcontent" align="left"><b>Product<br/>Description</b></td>
					<td class="tdcontent" align="left"><b>UOM</b></td>
					<td class="tdcontent" align="left"><b>Case<br/>Qty</b></td>
					<td class="tdcontent" align="left"><b>Loose<br/>Qty</b></td>
					<td class="tdcontent" align="left"><b>Line<br/>Cost</b></td>
					<td class="tdcontent" align="left"><b>Deal1 %</b></td>
					<td class="tdcontent" align="left"><b>Deal2 %</b></td>
					<td class="tdcontent" align="left"><b>VAT %</b></td>
					<td class="tdcontent" align="left" width="10%"><b>Total</b></td>
				</tr>
				<xsl:apply-templates select="//rootnode/smmessage/claimline"/>
			</table>
		</xsl:if>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="claimline" >
 	<tr>
 		<td class="pcontent" align="left">
 			<xsl:choose>
				<xsl:when test="prodcode!=''">
 					<xsl:value-of select="prodcode"/>
 				</xsl:when>
 				<xsl:otherwise>
 					&#160;&#160;&#160;-
 				</xsl:otherwise>
 			</xsl:choose>
			<br/>
				<xsl:value-of select="prodean"/>
		</td>
 		<td class="pcontent" align="left">
			<xsl:choose>
				<xsl:when test="proddescr!=''">
					<xsl:value-of select="proddescr"/>
				</xsl:when>
				<xsl:otherwise>
					&#160;&#160;&#160;-
				</xsl:otherwise>
			</xsl:choose>	
		</td>
 		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="uom!=''">
					<xsl:value-of select="uom"/>
				</xsl:when>
				<xsl:otherwise>
					&#160;&#160;&#160;-
				</xsl:otherwise>	
			</xsl:choose> 		
 		</td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="qty!=''">
			 		<xsl:value-of select="qty"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					-	 
			 	</xsl:otherwise>
			 </xsl:choose>
		</td>
		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="looseqty!=''">
			 		<xsl:value-of select="looseqty"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					0	 	
			 	</xsl:otherwise>
			 </xsl:choose>
		  </td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="unitprice='0'">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (unitprice,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="deal1perc!='0' or deal1perc!=''">
					<xsl:value-of select="format-number (deal1perc, 'DDD,DD0.00', 'staff')"/>&#160;&#160; 				
			 	</xsl:when>
			 	<xsl:otherwise>
			 		0&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="deal2perc!=''">
 					<xsl:value-of select="format-number (deal2perc, 'DDD,DD0.00', 'staff')"/>&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
			 		0&#160;&#160;					
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="vatperc='0'">
			 		0&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="vatperc"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="subtot=''">
			 		0.00&#160;&#160;
			 	</xsl:when>
			 	<xsl:otherwise>
					<xsl:value-of select="format-number (subtot,'DDD,DDD.00', 'staff')"/>&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose> 		 		
 		</td>
 	</tr>
 	<tr>
 		<td class="pcontent">&#160;</td>
 		<td class="pcontent" colspan="9"><!--<b>Line Narrative:&#160;</b><xsl:value-of select="narrative"/>&#160;<br/>--><b>Reason:</b>&#160;
 		<xsl:choose>
 			<xsl:when test="reasondescr='Goods Returned (Physical Stock) See Code List 10'">
			 		Goods Returned (Physical Stock)
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="reasondescr"/>
			</xsl:otherwise>
		</xsl:choose> 
 		&#160;<br/><b>Goods Return Reason:</b>&#160;<xsl:value-of select="goodsdescr"/></td> 		
 	</tr>
 </xsl:template>
</xsl:stylesheet>

