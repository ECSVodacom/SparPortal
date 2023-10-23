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
		<p class="pcontent" align="center"><b>[<a class="stextnav" href="window.open('close.html','_self');">Close this Window</a>]</b></p>
	</xsl:when>
	<xsl:otherwise>
	<form action="create.asp?item=@@OrdID" method="post" name="frmInvoice" id="frmInvoice" >
	<table border="0" cellpadding="2" cellspacing="2" width="100%">
		<tr>
		<td>
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="center">Order Confirmations</td>
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
				<td valign="top" width="20%">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/suppliername"/></b><br/><br/>
								@@Address
							</td>
						</tr>
					</table>
				</td>
				<td valign="top" width="40%">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
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
				<td valign="top" width="40%">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent">
								<table border="0" cellpadding="2" cellspacing="0">
									<tr>
										<td class="pcontent"><b>INVOICE NUMBER:</b></td>
										<td class="pcontent"><input type="text" name="txtInvoiceNo" id="txtInvoiceNo" value="@@InvNum" size="10" class="pcontent"/></td>
									</tr>
									<tr>
										<td class="pcontent"><b>INVOICE DATE:</b></td>
										<td class="pcontent"><input type="text" name="txtInvoiceDate" id="txtInvoiceDate" value="@@InvDate" size="6" class="pcontent"/></td>
										<td class="pcontent" colspan="2">[dd/mm/ccyy]</td>
									</tr>
									<tr>
										<td class="pcontent"><b>ORDER NR:</b></td>
										<xsl:choose>
											<xsl:when test="//rootnode/smmessage/ordernumber!=''">
												<td class="pcontent"><xsl:value-of select="//rootnode/smmessage/ordernumber"/></td>
											</xsl:when>
											<xsl:otherwise>
												<td class="pcontent"><b>Not Supplied</b></td>
											</xsl:otherwise>
										</xsl:choose>
									</tr>
									<tr>	
										<td class="pcontent"><b>ORDER DATE: </b></td>
										<xsl:choose>
											<xsl:when test="//rootnode/smmessage/receivedate!=''">
												<td class="pcontent"><xsl:value-of select="//rootnode/smmessage/receivedate"/></td>
											</xsl:when>
											<xsl:otherwise>
												<td class="pcontent"><b>Not Supplied</b></td>
											</xsl:otherwise>
										</xsl:choose>
									</tr>
								</table>		
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Create the Buttons -->
			<tr>
				<td class="pcontent" align="center">
					<xsl:choose>
					<xsl:when test="//rootnode/smmessage/isordersavedconfirmation=1">
						<select id="txtFilter" name="txtFilter" onchange="reloadSearch(this);" class="pcontent">
							<xsl:for-each select="//rootnode/smmessage/filteroption">
								<xsl:choose>
								<xsl:when test="@selected='yes'"><option value="{@value}" selected="selected"><xsl:value-of select="@name" /></option>
								</xsl:when><xsl:otherwise><option value="{@value}"><xsl:value-of select="@name" /></option></xsl:otherwise>
								</xsl:choose>	
						</xsl:for-each>
					</select></xsl:when>
					<xsl:otherwise>
						<select id="txtFilter" name="txtFilter" disabled="disabled" class="pcontent">
							<option value="-1">-- Filter only enabled on saved order confirmations --</option></select>
						</xsl:otherwise>
					</xsl:choose>
					
					
				
					
					
					
					
					<xsl:choose>
					<xsl:when test="//rootnode/smmessage/filterId=1">
						<input type="submit" name="btnSave" id="btnSave" value="Save" class="button" onclick="onlySave();"/>&#160;
						<input type="submit" name="btnSave" id="btnSave" value="Finalise" class="button" onclick="askConfirmationSend();"/>&#160;
					</xsl:when>
					<xsl:otherwise>
						<input type="submit" name="btnSave" id="btnSave" value="Save" class="button" onclick="onlySave();"/>&#160;
						<input type="submit" name="btnSave" id="btnSave" value="Finalise" class="button" disabled="true" style="background-color: gray;" onclick="askConfirmationSend();"/>&#160;</xsl:otherwise>
					</xsl:choose>
					
					<!--<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button"/>&#160;
					<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" />&#160;-->
					<input type="button" name="btnPrint" id="btnPrint" value="Print Order Confirmation" class="button"  onclick="javascript:window.print();"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="window.open('close.html','_self');"/>&#160;
				</td>
			</tr>
			<!-- End Create the Buttons -->	
			<tr>
				<td class="warning" colspan="3" wrap="virtual"><br /><b>@@SaveMessage</b></td>
			</tr>			
		</table><br/>
		<table border="2" cellpadding="0" cellspacing="0" width="100%">
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" align="center"><b>Line<br/>No</b></td>
				<td class="tdcontent" align="center"><b>Consumer&#160;Barcode</b><br/>
					<b>Supp Prod Code</b>
				</td>
				<td class="tdcontent" align="center"><b>Description</b></td>
				<td class="tdcontent" align="center"><b>Order<br/>Qty</b></td>
				<td class="tdcontent" align="center"><b>Inv<br/>Qty</b></td>
				<td class="tdcontent" align="center"><b>UOM</b></td>
				<td class="tdcontent" align="center"><b>Suppl<br/>Pack</b></td>
				<td class="tdcontent" align="center"><b>Order List<br/>Cost</b></td>
				<td class="tdcontent" align="center"><b>Inv List<br/>Cost</b></td>
				<td class="tdcontent" align="center"><b>Deal1&#160;%/R</b></td>
				<td class="tdcontent" align="center"><b>Deal2&#160;%/R</b></td>
				<td class="tdcontent" align="center"><b>Total<br/>(excl VAT)</b></td>
				<td class="tdcontent" align="center"><b>VAT %</b></td>
				<td class="tdcontent" align="center"><b>VAT R</b></td>
				<td class="tdcontent" align="center"><b>Order Total<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center"><b>Inv Total<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Qty of<br/>Free Goods</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Comments</b></td>
			</tr>
			<xsl:apply-templates select="//rootnode/smmessage/ordline"/>
			
			<xsl:choose>
			<xsl:when test="//rootnode/smmessage/filterId=1">
			<tr>
				<td colspan="18" class="pcontent"><br /></td>
			</tr>
		
		
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="11">&#160;<b>Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots1" id="txtTots1" size="5" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots1" id="hidTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots2" id="txtTots2" size="5" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots2" id="hidTots2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots3" id="txtTots3" size="5" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots3" id="hidTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<!-- Start Trade 1 Discount -->			
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Trade 1: &#160;</td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/invtottrade1value='0'">
										<input type="radio" name="rdDealOne" id="rdDealOne" value="1" checked="true" onclick="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)" />&#160;%&#160;
										<input type="radio" name="rdDealOne" id="rdDealOne" value="2" onclick="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealOne" id="txtDealOne" size="5" value="{//rootnode/smmessage/invtottrade1perc}" class="tblcontent" 
											onchange="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)" onkeyup="fNumericOnly(this);"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealOne" id="rdDealOne" value="1" onclick="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;%&#160;
										<input type="radio" name="rdDealOne" id="rdDealOne" value="2" checked="true" onclick="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealOne" id="txtDealOne" size="5" value="{//rootnode/smmessage/invtottrade1value}" class="tblcontent" 
											onchange="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)" onkeyup="fNumericOnly(this);"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/trade1='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR1" id="txtCRAdjR1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR1" id="hidCRAdjR1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat1" id="txtCRAdjRVat1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat1" id="hidCRAdjRVat1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl1" id="txtCRAdjTotIncl1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl1" id="hidCRAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR1" id="txtCRAdjR1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR1" id="hidCRAdjR1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat1" id="txtCRAdjRVat1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat1" id="hidCRAdjRVat1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl1" id="txtCRAdjTotIncl1" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl1" id="hidCRAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<!-- End Trade 1 Discount -->
			
			<!-- Start Trade 2 Discount -->
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Trade 2: &#160;</td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/invtottrade2value='0'">
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="1" checked="true" onclick="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>&#160;%&#160;
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="2" onclick="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)" />&#160;R<br/>
										<input type="text" name="txtDealTwo" id="txtDealTwo" size="5" value="{//rootnode/smmessage/invtottrade2perc}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="1" onclick="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>&#160;%&#160;
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="2" checked="true" onclick="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>&#160;R<br/>
										<input type="text" name="txtDealTwo" id="txtDealTwo" size="5" value="{//rootnode/smmessage/invtottrade2value}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/trade2='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR2" id="txtCRAdjR2" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR2" id="hidCRAdjR2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat2" id="txtCRAdjRVat2" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat2" id="hidCRAdjRVat2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl2" id="txtCRAdjTotIncl2" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl2" id="hidCRAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR2" id="txtCRAdjR2" value="{//rootnode/smmessage/trade2}	" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR2" id="hidCRAdjR2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat2" id="txtCRAdjRVat2" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat2" id="hidCRAdjRVat2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl2" id="txtCRAdjTotIncl2" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl2" id="hidCRAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose><td>&#160;</td>
			</tr>
			<!-- End Trade 2 Discount -->
			
			<!-- Start Additional Discount -->
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Additional <br/>Discount: </td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/invtotadditionaldiscvalue='0'">
										<input type="radio" name="rdDealThree" id="rdDealThree" value="1" checked="true" onclick="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)" />&#160;%&#160;
										<input type="radio" name="rdDealThree" id="rdDealThree" value="2" onclick="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>&#160;R<br/>
										<input type="text" name="txtDealThree" id="txtDealThree" size="5" value="{//rootnode/smmessage/invtotadditionaldiscperc}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealThree" id="rdDealThree" value="1" onclick="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>&#160;%&#160;
										<input type="radio" name="rdDealThree" id="rdDealThree" value="2" onclick="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)" checked="true"/>&#160;R<br/>
										<input type="text" name="txtDealThree" id="txtDealThree" size="5" value="{format-number (//rootnode/smmessage/invtotadditionaldiscvalue,'DDD.00', 'staff')}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/TRmDiscount='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR3" id="txtCRAdjR3" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR3" id="hidCRAdjR3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat3" id="txtCRAdjRVat3" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat3" id="hidCRAdjRVat3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl3" id="txtCRAdjTotIncl3" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl3" id="hidCRAdjTotIncl3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR3" id="txtCRAdjR3" value="{//rootnode/smmessage/trade2}	" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR3" id="hidCRAdjR3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat3" id="txtCRAdjRVat3" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat3" id="hidCRAdjRVat3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl3" id="txtCRAdjTotIncl3" value="0.00" size="5" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl3" id="hidCRAdjTotIncl3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose><td>&#160;</td>
			</tr>
			<!-- End Additional Discount -->
			<!-- Start Sub Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="11"><b>Sub Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots1" id="txtSubTots1" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots1" id="hidSubTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots2" id="txtSubTots2" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots2" id="hidSubTots2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots3" id="txtSubTots3" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots3" id="hidSubTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<!-- End Sub Totals -->
			<!-- Start Transport Discounts -->
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Transport: </td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/invtottransportcostval='0'">
										<input type="radio" name="rdDealFour" id="rdDealFour" value="1" checked="true" onclick="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;%&#160;
										<input type="radio" name="rdDealFour" id="rdDealFour" value="2" onclick="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealFour" id="txtDealFour" size="3" value="{//rootnode/smmessage/invtottransportcostperc}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealFour" id="rdDealFour" value="1" onclick="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;%&#160;
										<input type="radio" name="rdDealFour" id="rdDealFour" value="2" checked="true" onclick="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealFour" id="txtDealFour" size="3" value="{//rootnode/smmessage/invtottransportcostval}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjR1" id="txtDBAdjR1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjR1" id="hidDBAdjR1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjRVat1" id="txtDBAdjRVat1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjRVat1" id="hidDBAdjRVat1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjTotIncl1" id="txtDBAdjTotIncl1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjTotIncl1" id="hidDBAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<!-- End Transport Discounts -->
			
			<!-- Start Duty/Levy Discounts -->
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Duty/Levy: </td>
							<td class="pcontent" align="center">				
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/invtotdutlevval='0'">
										<input type="radio" name="rdDealFive" id="rdDealFive" value="1" checked="true" onclick="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;%&#160;
										<input type="radio" name="rdDealFive" id="rdDealFive" value="2" onclick="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;R<br/>
										<input type="text" name="txtDealFive" id="txtDealFive" size="3" value="{//rootnode/smmessage/invtotdutlevperc}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealFive" id="rdDealFive" value="1" onclick="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;%&#160;
										<input type="radio" name="rdDealFive" id="rdDealFive" value="2" checked="true" onclick="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;R<br/>
										<input type="text" name="txtDealFive" id="txtDealFive" size="3" value="{//rootnode/smmessage/invtotdutlevval}" class="tblcontent" 
											onkeyup="fNumericOnly(this);" onchange="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjR2" id="txtDBAdjR2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjR2" id="hidDBAdjR2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjRVat2" id="txtDBAdjRVat2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjRVat2" id="hidDBAdjRVat2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjTotIncl2" id="txtDBAdjTotIncl2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjTotIncl2" id="hidDBAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<!-- End Duty/Levy Discounts -->

			<!-- Start Invoice Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="11"><b>Invoice Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots1" id="txtInvTots1" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots1" id="hidInvTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots2" id="txtInvTots2" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots2" id="hidInvTots2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots3" id="txtInvTots3" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots3" id="hidInvTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<!-- End Invoice Totals -->
			
			<!-- Start Settlement Discount -->
			<tr>
				<td class="pcontent" colspan="11">
					<table>
						<tr>
							<td class="pcontent">Settlement<br/>Discount: </td>
							<td class="pcontent" align="center">	
							<xsl:choose>
								<xsl:when test="//rootnode/smmessage/invtotsettlediscval='0'">							
									<input type="radio" name="rdSettle" id="rdSettle" value="1" checked="true" onclick="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;%&#160;
									<input type="radio" name="rdSettle" id="rdSettle" value="2" onclick="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;R<br/>
									<input type="text" name="txtSettle" id="txtSettle" size="3" value="{//rootnode/smmessage/invtotsettlediscperc}" class="tblcontent" onchange="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)" onkeyup="fNumericOnly(this);"/>
								</xsl:when>
								<xsl:otherwise>
									<input type="radio" name="rdSettle" id="rdSettle" value="1" checked="true" onclick="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;%&#160;
									<input type="radio" name="rdSettle" id="rdSettle" value="2" onclick="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;R<br/>
									<input type="text" name="txtSettle" id="txtSettle" size="3" value="{//rootnode/smmessage/invtotsettlediscval}" class="tblcontent" onchange="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)" onkeyup="fNumericOnly(this);"/>
								</xsl:otherwise>
							</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotExl" id="txtSetTotExl" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotExl" id="hidSetTotExl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotVat" id="txtSetTotVat" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotVat" id="hidSetTotVat" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotIncl" id="txtSetTotIncl" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotIncl" id="hidSetTotIncl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td><td>&#160;</td>
			</tr>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="11"><b>Nett Due to DC:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotExcl" id="txtNettTotExcl" size="5" value="0.00" class="tblcontent" disabled="true"/>
				<input type="hidden" name="hidNettTotExcl" id="hidNettTotExcl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotVat" id="txtNettTotVat" size="3" value="0.00" class="tblcontent" disabled="true"/><input type="hidden" name="hidNettTotVat" id="hidNettTotVat" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotIncl" id="txtNettTotIncl" size="3" value="0.00" class="tblcontent" disabled="true"/><input type="hidden" name="hidNettTotIncl" id="hidNettTotIncl" value="0.00"/>&#160;&#160;
					
				</td>
				<td>&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Settlement Discount -->
			
			</xsl:when><xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<tr><input><xsl:attribute name="type">hidden</xsl:attribute><xsl:attribute name="name">hidTotalCount</xsl:attribute><xsl:attribute name="id">hidTotalCount</xsl:attribute><xsl:attribute name="value"><xsl:value-of select="count(rootnode/smmessage/ordline)"/></xsl:attribute></input>
					<input type="hidden" name="hidAction" id="hidAction" value="1"/>
					<input type="hidden" name="hidSupVat" id="hidSupVat" value="{rootnode/smmessage/suppliervat}"/>
					<input type="hidden" name="hidSupEAN" id="hidSupEAN" value="{rootnode/smmessage/supplierean}"/>
					<input type="hidden" name="hidStoreEAN" id="hidStoreEAN" value="{rootnode/smmessage/storerean}"/>
					<input type="hidden" name="hidDCEAN" id="hidDCEAN" value="{rootnode/smmessage/dcean}"/>
					<input type="hidden" name="hidStoreName" id="hidStoreName" value="{rootnode/smmessage/storename}"/>
					<input type="hidden" name="hidStoreAddr" id="hidStoreAddr" value="{rootnode/smmessage/storeaddress}"/>
					<input type="hidden" name="hidOrdNo" id="hidOrdNo" value="{rootnode/smmessage/ordernumber}"/>
					<input type="hidden" name="hidSupAction" id="hidSupAction" value="2"/>
					<input type="hidden" name="hidNew" id="hidNew" value="0"/>
					<input type="hidden" name="DoSendOrderConfirmation" id="DoSendOrderConfirmation" value="0"/>
					<input type="hidden" name="ButtonClick" id="ButtonClick" value=""/></tr>
					<input type="hidden" name="txtInvoiceId" id="txtInvoiceId" value="{rootnode/smmessage/invoiceid}"/>
		</table>
		</td>
	</tr>
	</table>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="ordline" >
 	<tr>
		
		<input type="hidden" name="txtInvoiceLineId{position()}" id="txtInvoiceLineId{position()}" value="{invoiceLineId}"/>
		<input type="hidden" name="txtOrderLineId{position()}" id="txtOrderLineId{position()}" value="{trackid}"/>
 		<td class="pcontent" align="center"><xsl:value-of select="position()"/><input type="hidden" name="hidChkDelete{position()}" id="hidChkDelete{position()}" value="0"/></td>
		<td class="pcontent" align="left">
			<input type="text" name="txtBarCode{position()}" id="txtBarCode{position()}" size="15" value="{barcode}" class="tblcontent" readonly="readonly"/><br/>
			<input type="text" name="txtProdCode{position()}" id="txtProdCode{position()}" size="10" value="{prodcode}" class="tblcontent" readonly="readonly"/>
		</td>
		<td class="pcontent" align="center"><input type="text" name="txtDescr{position()}" id="txtDescr{position()}" value="{proddescr}" size="25" class="tblcontent" readonly="readonly"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtOrderQty{position()}" id="txtOrderQty{position()}" value="{qty}" size="3" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtQty{position()}" id="taxqty{position()}" value="{taxqty}" size="2" class="tblcontent" onblur="calcTotalExcl({position()});"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtMeasure{position()}" id="txtMeasure{position()}" size="2" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtSupPackDisplay{position()}" id="txtSupPackDisplay{position()}" value="{taxsupplierpack}" size="2" readonly="readonly" disabled="true" class="tblcontent"/>
		<input type="hidden" name="txtSupPack{position()}" id="txtSupPack{position()}" value="{taxsupplierpack}" size="2" readonly="readonly" class="tblcontent"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtOrderListCost{position()}" id="txtOrderListCost{position()}" value="{format-number (linecost,'DDD.00', 'staff')}" size="3" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="linecost='0'">
					<input type="text" name="txtListCost{position()}" id="txtListCost{position()}"  value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtListCost{position()}" id="txtListCost{position()}"  value="{format-number (taxlistcost,'DDD.00', 'staff')}" size="3" class="tblcontent" onchange="calcTotalExcl({position()});"/>
				</xsl:otherwise>
			</xsl:choose>			
		</td>
		<td class="pcontent" align="center" valign="top">
			<xsl:choose>
				<xsl:when test="deal1perc='0' or deal1perc='0.00' or deal1perc=''">
					<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne{position()}" value="1" class="tblcontent" onclick="calcTotalExcl({position()});"/>%&#160;
					<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne{position()}" value="2" checked="true" class="tblcontent" onclick="calcTotalExcl({position()});"/>&#160;R<br/>
					<input type="hidden" name="hidDealpercOne{position()}" id="hidDealpercOne{position()}" value="2" />
					<xsl:choose>
						<xsl:when test="deal1rand!='0' and deal1rand!='0.00' and deal1rand!=''">
							<input type="text" name="txtDealpercOne{position()}" id="txtDealpercOne{position()}" size="3" value="{format-number (deal1rand,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtDealpercOne{position()}" id="txtDealpercOne{position()}" size="3" value="0" class="tblcontent" onblur="calcTotalExcl({position()});"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne{position()}" value="1" checked="true" class="tblcontent" onclick="calcTotalExcl({position()});"/>%&#160;
					<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne{position()}" value="2" class="tblcontent" onclick="calcTotalExcl({position()});"/>&#160;R<br/>
					<input type="text" name="txtDealpercOne{position()}" id="txtDealpercOne{position()}" size="3" value="{format-number (deal1perc,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercOne{position()}" id="hidDealpercOne{position()}" value="0" />
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidrdTradeOne{position()}" id="hidrdTradeOne{position()}" value="1" />
		</td>
		<td class="pcontent" align="center" valign="top">
			<xsl:choose>
				<xsl:when test="deal2perc='0' or deal2perc='0.00' or deal2perc=''">
					<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="1" class="tblcontent" onclick="calcTotalExcl({position()});"/>%&#160;
					<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="2"  class="tblcontent" checked="true" onclick="calcTotalExcl({position()});"/>R&#160;<br/>
					<input type="hidden" name="hidDealpercTwo{position()}" id="hidDealpercTwo{position()}" value="2" />
					<xsl:choose>
						<xsl:when test="deal2rand!='0' and deal2rand!='0.00' and deal2rand!=''">
							<input type="text" name="txtDealpercTwo{position()}" id="txtDealpercTwo{position()}" size="3" value="{format-number (deal2rand,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtDealpercTwo{position()}" id="txtDealpercTwo{position()}" size="3" value="0" class="tblcontent" onblur="calcTotalExcl({position()});"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="1" checked="true" class="tblcontent" onclick="calcTotalExcl({position()});"/>%&#160;
					<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="2" class="tblcontent"  onclick="calcTotalExcl({position()});"/>R&#160;<br/>
					<input type="text" name="txtDealpercTwo{position()}" id="txtDealpercTwo{position()}" size="3" value="{format-number (deal2perc,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercTwo{position()}" id="hidDealpercTwo{position()}" value="0" />
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidrdTradeTwo{position()}" id="hidrdTradeTwo{position()}" value="1" />
		</td>		
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="nettcost='0'">
					<input type="text" name="txtTotalExcl{position()}" id="txtTotalExcl{position()}" value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtTotalExcl{position()}" id="txtTotalExcl{position()}" value="{format-number (nettcost,'DDD.00', 'staff')}" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidTotalExcl{position()}" id="hidTotalExcl{position()}" value="0.00"/>
			<input type="hidden" name="hidOriginalTotalExcl{position()}" id="hidOriginalTotalExcl{position()}" value="{nettcost}"/>
		</td>
		<td class="pcontent" align="center">
			<select name="txtVatperc{position()}" id="txtVatperc{position()}" onchange="calcTotalExcl({position()});" class="tblcontent">
				<!-- Check if value match -->
				<xsl:if test="vat='0'">
					<option selected="true" value="0">0</option>
					<option value="10">10</option>
					<option value="14">14</option>					
					<option value="15">15</option>		
				</xsl:if>
				<xsl:if test="vat='10'">
					<option value="0">0</option>
					<option selected="true" value="10">10</option>
					<option value="14">14</option>
					<option value="15">15</option>						
				</xsl:if>
				<xsl:if test="vat='14'">
					<option value="0">0</option>
					<option value="10">10</option>
					<option selected="true" value="14">14</option>	
					<option value="15">15</option>							
				</xsl:if>	
				<xsl:if test="vat='15'">
					<option value="0">0</option>
					<option value="10">10</option>
					<option value="14">14</option>	
					<option selected="true" value="15">15</option>					
				</xsl:if>				
				<xsl:if test="vat!='0' and vat!='10' and vat!='14' and vat!='15'">
					<option value="0">0</option>
					<option value="10">10</option>
					<option value="14">14</option>	
					<option selected="true" value="15">15</option>					
				</xsl:if>								
			</select>
			<xsl:if test="vat='0'">
				<input type="hidden" name="hidVatCode{position()}" id="hidVatCode{position()}" value="Z"/>
			</xsl:if>
			<xsl:if test="vat='10' or vat='14' or vat='15'">
				<input type="hidden" name="hidVatCode{position()}" id="hidVatCode{position()}" value="S"/>
			</xsl:if>
		</td>
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="vatr='0.00'">
					<input type="text" name="txtVatr{position()}" id="txtVatr{position()}" value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtVatr{position()}" id="txtVatr{position()}" value="{format-number (vatr,'DDD.00', 'staff')}" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidVatr{position()}" id="hidVatr{position()}" value="0.00"/>
		</td>
		<td class="pcontent" align="center">
			<input type="text" name="txtOrderTotalInc{position()}" id="txtOrderTotalInc{position()}" value="{format-number (total,'DDD.00', 'staff')}" size="3" class="tblcontent" disabled="true"/>
		</td>
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="invnetval!='0.00'">
					<input type="text" name="txtTotalIncl{position()}" id="txtTotalIncl{position()}" value="{format-number (invnetval,'DDD.00', 'staff')}" size="3" class="tblcontent" disabled="true"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtTotalIncl{position()}" id="txtTotalIncl{position()}" value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>					
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidTotalIncl{position()}" id="hidTotalIncl{position()}" value="0.00"/>
		</td>
		<td class="pcontent" align="center"><input type="text" name="txtFreeQty{position()}" id="txtFreeQty{position()}" size="2" value="{taxqtyfreegoods}" class="tblcontent"/></td>
		<td class="pcontent" align="center">
			<textarea  name="txtFreeText{position()}" id="txtFreeText{position()}"  value="{taxfreetext}" class="tblcontent" ><xsl:value-of select="taxfreetext"/></textarea>
		</td>
	</tr>
 </xsl:template>
</xsl:stylesheet>

