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
	<form action="create.asp?item=@@OrdID" method="post" name="frmInvoice" id="frmInvoice" onsubmit="return validate(this);">
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
										<td class="pcontent"><input type="text" name="txtInvoiceNo" id="txtInvoiceNo" value="" size="10" class="pcontent"/></td>
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
					<input type="submit" name="btnSubmit" id="btnSubmit" value="Save" class="button"/>&#160;
					<select name="txtFilter" id="txtFilter" onchange="javascript:alert('Not yet implemented');" class="tblcontent">
						<option value="1,View all items">View all items</option>
						<option value="2,View all discrepancies">View all discrepancies</option>
						<option value="3,View only order value discrepancies">View only order value discrepancies</option>
						<option value="4,View only qty discrepancies">View only qty discrepancies</option>
						<option value="5,View only price discrepancies">View only price discrepancies</option>
					</select>
					<!--<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button"/>&#160;
					<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" />&#160;-->
					<input type="button" name="btnPrint" id="btnPrint" value="Print Order Confirmation" class="button"  onclick="javascript:window.print();"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="window.opener.location.reload();window.close();"/>&#160;
				</td>
			</tr>
			<!-- End Create the Buttons -->		
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
				<td class="tdcontent" align="center"><b>Deal1<br/>%/R</b></td>
				<td class="tdcontent" align="center"><b>Deal2<br/> %/R</b></td>
				<td class="tdcontent" align="center"><b>Total<br/>(excl VAT)</b></td>
				<td class="tdcontent" align="center"><b>VAT %</b></td>
				<td class="tdcontent" align="center"><b>VAT R</b></td>
				<td class="tdcontent" align="center"><b>Order Total<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center"><b>Inv Total<br/>(incl VAT)</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Qty of<br/>Free Goods</b></td>
				<td class="tdcontent" align="center" width="1%"><b>Comments</b></td>
			</tr>
			<xsl:apply-templates select="//rootnode/smmessage/ordline"/>
			<tr>
				<td colspan="" class="pcontent"><br /></td>
			</tr>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots1" id="txtTots1" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots1" id="hidTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots2" id="txtTots2" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots2" id="hidTots2" value="0.00"/>&#160;&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtTots3" id="txtTots3" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidTots3" id="hidTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- Start Trade 1 Discount -->			
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Trade 1: &#160;</td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/trade1='0'">
										<input type="radio" name="rdDealOne" id="rdDealOne" value="1" checked="true" onclick="document.frmInvoice.txtDealOne.value=document.frmInvoice.hidDealOne.value; calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;%&#160;
										<input type="radio" name="rdDealOne" id="rdDealOne" value="2" onclick="document.frmInvoice.txtDealOne.value=document.frmInvoice.hidDealOne.value; calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealOne" id="txtDealOne" size="5" value="0.00" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>
										<input type="hidden" name="hidDealOne" id="hidDealOne" value="0.00" />
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealOne" id="rdDealOne" value="1" checked="true" onclick="document.frmInvoice.txtDealOne.value=document.frmInvoice.hidDealOne.value; calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;%&#160;
										<input type="radio" name="rdDealOne" id="rdDealOne" value="2" onclick="document.frmInvoice.txtDealOne.value=document.frmInvoice.hidDealOne.value; calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>&#160;R<br/>
										<input type="text" name="txtDealOne" id="txtDealOne" size="5" value="{format-number (//rootnode/smmessage/trade1,'DDD.00', 'staff')}" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealOne, document.frmInvoice.rdDealOne, 1)"/>
										<input type="hidden" name="hidDealOne" id="hidDealOne" value="{format-number (//rootnode/smmessage/trade1,'DDD.00', 'staff')}" />
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/trade1='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR1" id="txtCRAdjR1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR1" id="hidCRAdjR1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat1" id="txtCRAdjRVat1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat1" id="hidCRAdjRVat1" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl1" id="txtCRAdjTotIncl1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl1" id="hidCRAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR1" id="txtCRAdjR1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR1" id="hidCRAdjR1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat1" id="txtCRAdjRVat1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat1" id="hidCRAdjRVat1" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl1" id="txtCRAdjTotIncl1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl1" id="hidCRAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<!-- End Trade 1 Discount -->
			
			<!-- Start Trade 2 Discount -->
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Trade 2: &#160;</td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/trade2='0'">
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="1" checked="true" onclick="document.frmInvoice.txtDealTwo.value=document.frmInvoice.hidDealTwo.value; calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>&#160;%&#160;
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="2" onclick="document.frmInvoice.txtDealTwo.value=document.frmInvoice.hidDealTwo.value; calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>&#160;R<br/>
										<input type="text" name="txtDealTwo" id="txtDealTwo" size="5" value="0.00" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>
										<input type="hidden" name="hidDealTwo" id="hidDealTwo" value="0.00" />
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="1" checked="true"/>&#160;%&#160;
										<input type="radio" name="rdDealTwo" id="rdDealTwo" value="2"/>&#160;R<br/>
										<input type="text" name="txtDealTwo" id="txtDealTwo" size="3" value="{format-number (//rootnode/smmessage/trade2,'DDD.00', 'staff')}" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealTwo, document.frmInvoice.rdDealTwo, 2)"/>
										<input type="hidden" name="hidDealTwo" id="hidDealTwo" value="{format-number (//rootnode/smmessage/trade2,'DDD.00', 'staff')}" />
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/trade2='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR2" id="txtCRAdjR2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR2" id="hidCRAdjR2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat2" id="txtCRAdjRVat2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat2" id="hidCRAdjRVat2" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl2" id="txtCRAdjTotIncl2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl2" id="hidCRAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR2" id="txtCRAdjR2" value="{//rootnode/smmessage/trade2}	" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR2" id="hidCRAdjR2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat2" id="txtCRAdjRVat2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat2" id="hidCRAdjRVat2" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl2" id="txtCRAdjTotIncl2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl2" id="hidCRAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<!-- End Trade 2 Discount -->
			
			<!-- Start Additional Discount -->
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Additional <br/>Discount: </td>
							<td class="pcontent" align="center">							
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/TRmDiscount='0'">
										<input type="radio" name="rdDealThree" id="rdDealThree" value="1" checked="true" onclick="document.frmInvoice.txtDealThree.value=document.frmInvoice.hidDealThree.value; calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>&#160;%&#160;
										<input type="radio" name="rdDealThree" id="rdDealThree" value="2" onclick="document.frmInvoice.txtDealThree.value=document.frmInvoice.hidDealThree.value; calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>&#160;R<br/>
										<input type="text" name="txtDealThree" id="txtDealThree" size="3" value="0.00" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>
										<input type="hidden" name="hidDealThree" id="hidDealThree" value="0.00" />
									</xsl:when>
									<xsl:otherwise>
										<input type="radio" name="rdDealThree" id="rdDealThree" value="1" checked="true"/>&#160;%&#160;
										<input type="radio" name="rdDealThree" id="rdDealThree" value="2"/>&#160;R<br/>
										<input type="text" name="txtDealThree" id="txtDealThree" size="3" value="{format-number (//rootnode/smmessage/TRmDiscount,'DDD.00', 'staff')}" class="tblcontent" onchange="calcDealDisc (document.frmInvoice.txtDealThree, document.frmInvoice.rdDealThree, 3)"/>
										<input type="hidden" name="hidDealThree" id="hidDealThree" value="{format-number (//rootnode/smmessage/TRmDiscount,'DDD.00', 'staff')}" />
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</table>
				</td>
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/TRmDiscount='0'">
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR3" id="txtCRAdjR3" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR3" id="hidCRAdjR3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat3" id="txtCRAdjRVat3" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat3" id="hidCRAdjRVat3" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl3" id="txtCRAdjTotIncl3" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl3" id="hidCRAdjTotIncl3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjR3" id="txtCRAdjR3" value="{//rootnode/smmessage/trade2}	" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjR3" id="hidCRAdjR3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjRVat3" id="txtCRAdjRVat3" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjRVat3" id="hidCRAdjRVat3" value="0.00"/>&#160;&#160;</td>
						<td class="pcontent" align="right">-&#160;<input type="text" name="txtCRAdjTotIncl3" id="txtCRAdjTotIncl3" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidCRAdjTotIncl3" id="hidCRAdjTotIncl3" value="0.00"/>&#160;&#160;</td>
						<td>&#160;</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			<!-- End Additional Discount -->
			<!-- Start Sub Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Sub Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots1" id="txtSubTots1" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots1" id="hidSubTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots2" id="txtSubTots2" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots2" id="hidSubTots2" value="0.00"/>&#160;&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtSubTots3" id="txtSubTots3" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidSubTots3" id="hidSubTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Sub Totals -->
			<!-- Start Transport Discounts -->
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Transport: </td>
							<td class="pcontent" align="center">							
								<input type="radio" name="rdDealFour" id="rdDealFour" value="1" checked="true" onclick="document.frmInvoice.txtDealFour.value=document.frmInvoice.hidDealFour.value; calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;%&#160;
								<input type="radio" name="rdDealFour" id="rdDealFour" value="2" onclick="document.frmInvoice.txtDealFour.value=document.frmInvoice.hidDealFour.value; calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>&#160;R<br/>
								<input type="text" name="txtDealFour" id="txtDealFour" size="3" value="0.00" class="tblcontent" onchange="calcTransLev (document.frmInvoice.txtDealFour, document.frmInvoice.rdDealFour, 1)"/>
								<input type="hidden" name="hidDealFour" id="hidDealFour" value="0.00" />
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjR1" id="txtDBAdjR1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjR1" id="hidDBAdjR1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjRVat1" id="txtDBAdjRVat1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjRVat1" id="hidDBAdjRVat1" value="0.00"/>&#160;&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjTotIncl1" id="txtDBAdjTotIncl1" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjTotIncl1" id="hidDBAdjTotIncl1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Transport Discounts -->
			
			<!-- Start Duty/Levy Discounts -->
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Duty/Levy: </td>
							<td class="pcontent" align="center">							
								<input type="radio" name="rdDealFive" id="rdDealFive" value="1" checked="true" onclick="document.frmInvoice.txtDealFive.value=document.frmInvoice.hidDealFive.value; calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;%&#160;
								<input type="radio" name="rdDealFive" id="rdDealFive" value="2" onclick="document.frmInvoice.txtDealFive.value=document.frmInvoice.hidDealFive.value; calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>&#160;R<br/>
								<input type="text" name="txtDealFive" id="txtDealFive" size="3" value="0.00" class="tblcontent" onchange="calcTransLev (document.frmInvoice.txtDealFive, document.frmInvoice.rdDealFive, 2)"/>
								<input type="hidden" name="hidDealFive" id="hidDealFive" value="0.00" />
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjR2" id="txtDBAdjR2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjR2" id="hidDBAdjR2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjRVat2" id="txtDBAdjRVat2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjRVat2" id="hidDBAdjRVat2" value="0.00"/>&#160;&#160;</td>
				<td class="pcontent" align="right">+&#160;<input type="text" name="txtDBAdjTotIncl2" id="txtDBAdjTotIncl2" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidDBAdjTotIncl2" id="hidDBAdjTotIncl2" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Duty/Levy Discounts -->

			<!-- Start Invoice Totals -->
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Invoice Total:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots1" id="txtInvTots1" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots1" id="hidInvTots1" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots2" id="txtInvTots2" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots2" id="hidInvTots2" value="0.00"/>&#160;&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtInvTots3" id="txtInvTots3" size="3" value="" class="tblcontent" disabled="true"/><input type="hidden" name="hidInvTots3" id="hidInvTots3" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<!-- End Invoice Totals -->
			
			<!-- Start Settlement Discount -->
			<tr>
				<td class="pcontent" colspan="9">
					<table>
						<tr>
							<td class="pcontent">Settlement<br/>Discount: </td>
							<td class="pcontent" align="center">							
								<input type="radio" name="rdSettle" id="rdSettle" value="1" checked="true" onclick="document.frmInvoice.txtSettle.value=document.frmInvoice.hidSettle.value; calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;%&#160;
								<input type="radio" name="rdSettle" id="rdSettle" value="2" onclick="document.frmInvoice.txtSettle.value=document.frmInvoice.hidSettle.value; calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>&#160;R<br/>
								<input type="text" name="txtSettle" id="txtSettle" size="3" value="0.00" class="tblcontent" onchange="calcSettle (document.frmInvoice.txtSettle, document.frmInvoice.rdSettle, 1)"/>
								<input type="hidden" name="hidSettle" id="hidSettle" value="0.00" />
							</td>
						</tr>
					</table>
				</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotExl" id="txtSetTotExl" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotExl" id="hidSetTotExl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotVat" id="txtSetTotVat" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotVat" id="hidSetTotVat" value="0.00"/>&#160;&#160;</td>
				<td class="pcontent" align="right">-&#160;<input type="text" name="txtSetTotIncl" id="txtSetTotIncl" value="0.00" size="3" class="tblcontent" disabled="true"/><input type="hidden" name="hidSetTotIncl" id="hidSetTotIncl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
			</tr>
			<tr bgcolor="#4C8ED7">
				<td class="tdcontent" colspan="9"><b>Nett Due to DC:</b></td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotExcl" id="txtNettTotExcl" size="5" value="0.00" class="tblcontent" disabled="true"/><input type="hidden" name="hidNettTotExcl" id="hidNettTotExcl" value="0.00"/>&#160;&#160;</td>
				<td>&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotVat" id="txtNettTotVat" size="3" value="0.00" class="tblcontent" disabled="true"/><input type="hidden" name="hidNettTotVat" id="hidNettTotVat" value="0.00"/>&#160;&#160;</td>
				<td class="tdcontent" align="right"><b>R&#160;</b><input type="text" name="txtNettTotIncl" id="txtNettTotIncl" size="3" value="0.00" class="tblcontent" disabled="true"/><input type="hidden" name="hidNettTotIncl" id="hidNettTotIncl" value="0.00"/>&#160;&#160;
					<input><xsl:attribute name="type">hidden</xsl:attribute><xsl:attribute name="name">hidTotalCount</xsl:attribute><xsl:attribute name="id">hidTotalCount</xsl:attribute><xsl:attribute name="value"><xsl:value-of select="count(rootnode/smmessage/ordline)"/></xsl:attribute></input>
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
				</td>
				<td>&#160;</td>
			</tr>
			<!-- End Settlement Discount -->
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
 		<td class="pcontent" align="center"><xsl:value-of select="position()"/><input type="hidden" name="hidChkDelete{position()}" id="hidChkDelete{position()}" value="0"/></td>
		<td class="pcontent" align="left">
			<input type="text" name="txtBarCode{position()}" id="txtBarCode{position()}" size="15" value="{barcode}" class="tblcontent"/><br/>
			<input type="text" name="txtProdCode{position()}" id="txtProdCode{position()}" size="10" value="{prodcode}" class="tblcontent"/>
		</td>
		<td class="pcontent" align="center"><input type="text" name="txtDescr{position()}" id="txtDescr{position()}" value="{proddescr}" size="25" class="tblcontent"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtOrderQty{position()}" id="txtOrderQty{position()}" value="{qty}" size="3" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtQty{position()}" id="txtQty{position()}" value="{qty}" size="2" class="tblcontent" onblur="calcTotalExcl({position()});"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtMeasure{position()}" id="txtMeasure{position()}" size="2" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center"><input type="text" name="txtSupPack{position()}" id="txtSupPack{position()}" value="{supplpack}" size="2" class="tblcontent"/></td>
			<td class="pcontent" align="center"><input type="text" name="txtOrderListCost{position()}" id="txtOrderListCost{position()}" value="{format-number (linecost,'DDD.00', 'staff')}" size="3" class="tblcontent" disabled="true"/></td>
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="linecost='0'">
					<input type="text" name="txtListCost{position()}" id="txtListCost{position()}"  value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtListCost{position()}" id="txtListCost{position()}"  value="{format-number (linecost,'DDD.00', 'staff')}" size="3" class="tblcontent" onchange="calcTotalExcl({position()});"/>
				</xsl:otherwise>
			</xsl:choose>			
		</td>
		<td class="pcontent" align="center" valign="top">
			<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne" value="1" checked="true" class="tblcontent" onclick="document.frmInvoice.elements['txtDealpercOne'+{position()}].value=document.frmInvoice.elements['hidDealpercOne'+{position()}].value; calcTotalExcl({position()});"/>%&#160;
			<input type="radio" name="rdTradeOne{position()}" id="rdTradeOne" value="2" class="tblcontent" onclick="document.frmInvoice.elements['txtDealpercOne'+{position()}].value=document.frmInvoice.elements['hidDealpercOne'+{position()}].value; calcTotalExcl({position()});"/>&#160;R<br/>
			<xsl:choose>
				<xsl:when test="deal1='0' or deal1='0.00' or deal1=''">
					<input type="text" name="txtDealpercOne{position()}" id="txtDealpercOne{position()}" size="3" value="0.00" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercOne{position()}" id="hidDealpercOne{position()}" value="0.00" />
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtDealpercOne{position()}" id="txtDealpercOne{position()}" size="3" value="{format-number (deal1,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercOne{position()}" id="hidDealpercOne{position()}" value="{format-number (deal1,'DDD.00', 'staff')}" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td class="pcontent" align="center" valign="top">
			<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="1" class="tblcontent" checked="true" onclick="document.frmInvoice.elements['txtDealpercTwo'+{position()}].value=document.frmInvoice.elements['hidDealpercTwo'+{position()}].value; calcTotalExcl({position()});"/>%&#160;
			<input type="radio" name="rdTradeTwo{position()}" id="rdTradeTwo{position()}" value="2" class="tblcontent" onclick="document.frmInvoice.elements['txtDealpercTwo'+{position()}].value=document.frmInvoice.elements['hidDealpercTwo'+{position()}].value; calcTotalExcl({position()});"/>R&#160;<br/>
			<xsl:choose>
				<xsl:when test="deal2='0' or deal2='0.00' or deal2=''">
					<input type="text" name="txtDealpercTwo{position()}" id="txtDealpercTwo{position()}" size="3" value="0.00" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercTwo{position()}" id="hidDealpercTwo{position()}" value="0.00" />
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtDealpercTwo{position()}" id="txtDealpercTwo{position()}" size="3" value="{format-number (deal2,'DDD.00', 'staff')}" class="tblcontent" onblur="calcTotalExcl({position()});"/>
					<input type="hidden" name="hidDealpercTwo{position()}" id="hidDealpercTwo{position()}" value="{format-number (deal2,'DDD.00', 'staff')}" />
				</xsl:otherwise>
			</xsl:choose>
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
		</td>
		<td class="pcontent" align="center">
			<select name="txtVatperc{position()}" id="txtVatperc{position()}" onchange="calcTotalExcl({position()});" class="tblcontent">
				<!-- Check if value match -->
				<xsl:if test="vat='0'">
					<option selected="true" value="0">0</option>
					<option value="10">10</option>
					<option value="14">14</option>					
				</xsl:if>
				<xsl:if test="vat='10'">
					<option value="0">0</option>
					<option selected="true" value="10">10</option>
					<option value="14">14</option>					
				</xsl:if>
				<xsl:if test="vat='14'">
					<option value="0">0</option>
					<option value="10">10</option>
					<option selected="true" value="14">14</option>					
				</xsl:if>				
				<xsl:if test="vat!='0' and vat!='10' and vat!='14'">
					<option value="0">0</option>
					<option value="10">10</option>
					<option selected="true" value="14">14</option>					
				</xsl:if>								
			</select>
			<xsl:if test="vat='0'">
				<input type="hidden" name="hidVatCode{position()}" id="hidVatCode{position()}" value="Z"/>
			</xsl:if>
			<xsl:if test="vat='10' or vat='14'">
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
				<xsl:when test="total!='0.00'">
					<input type="text" name="txtTotalIncl{position()}" id="txtTotalIncl{position()}" value="{format-number (total,'DDD.00', 'staff')}" size="3" class="tblcontent" disabled="true"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtTotalIncl{position()}" id="txtTotalIncl{position()}" value="0.00" size="3" class="tblcontent" onchange="calcTotalExcl({position()});" disabled="true"/>					
				</xsl:otherwise>
			</xsl:choose>
			<input type="hidden" name="hidTotalIncl{position()}" id="hidTotalIncl{position()}" value="0.00"/>
		</td>
		<td class="pcontent" align="center"><input type="text" name="txtFreeQty{position()}" id="txtFreeQty{position()}" size="2" value="{free}" class="tblcontent"/></td>
		<td class="pcontent" align="center">
			<textarea  name="txtFreeText{position()}" id="txtFreeText{position()}"  value="" class="tblcontent"/>
		</td>
	</tr>
 </xsl:template>
</xsl:stylesheet>

