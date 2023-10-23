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
	<form action="gencc.asp?item=@@ClaimID" method="post" name="addcc" id="addcc" onsubmit="return validate(this);">
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="left">CREDIT NOTE ADVICE&#160;
				<xsl:choose>
					<xsl:when test="//rootnode/smmessage/claimtype='RFC'">-&#160;REQUEST FOR CREDIT</xsl:when>				
					<xsl:when test="//rootnode/smmessage/claimtype='DFC'">-&#160;DEMAND FOR CREDIT</xsl:when>									
				</xsl:choose>
				</td>
			</tr>
		</table><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Create the Buttons -->
			<tr>
				<td class="pcontent" align="center">
					<!--<xsl:if test="//rootnode/smmessage/isxml='1'">
						<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@ClaimID&amp;type=xml&amp;action=clm'"/>&#160;
						<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@ClaimID&amp;type=txt&amp;action=clm'"/>&#160;
					</xsl:if>
					<input type="button" name="btnPrint" id="btnPrint" value="Print Claim" class="button"  onclick="javascript:window.print();"/>&#160;//-->
					<input type="submit" name="btnSubmit" id="btnSubmit" value="Send Credit Note" class="button"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
					<input type="hidden" name="hidAction" id="hidAction" value="1"/>
					<input type="hidden" name="hidStoreEAN" id="hidStoreEAN" value="{//rootnode/smmessage/storeean}"/>
					<input type="hidden" name="hidDCEAN" id="hidDCEAN" value="{//rootnode/smmessage/dcean}"/>
					<input type="hidden" name="hidSupplierEAN" id="hidSupplierEAN" value="{//rootnode/smmessage/supplierean}"/>
					<input type="hidden" name="hidType" id="hidType" value="{//rootnode/smmessage/claimtype}"/>
					<input type="hidden" name="hidClaimNum" id="hidClaimNum" value="{//rootnode/smmessage/claimnumber}"/>
					<input type="hidden" name="hidClaimDate" id="hidClaimDate" value="{//rootnode/smmessage/cliamdate}"/>
					<input type="hidden" name="hidInvNum" id="hidInvNum" value="{//rootnode/smmessage/invoicenum}"/>
					<input type="hidden" name="hidInvDate" id="hidInvDate" value="{//rootnode/smmessage/invoicedate}"/>
					<input type="hidden" name="hidManNum" id="hidManNum" value="{//rootnode/smmessage/manualnum}"/>
					<input type="hidden" name="hidManDate" id="hidManDate" value="{//rootnode/smmessage/manualdate}"/>
					<input type="hidden" name="hidLines" id="hidLines" value="{count(//rootnode/smmessage/claimline)}"/>
					
				</td>
			</tr>
			<!-- End Create the Buttons -->		
		</table><br/>
		<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#4C8ED7">
			<tr>
				<td valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">TO:&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</b></td>
					</table>
				</td>
				<td class="pcontent">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">&#160; </b></td>
						<td class="pcontent" bgcolor="#4C8ED7"><b class="tdcontent">FROM:&#160;&#160;&#160;&#160;</b></td>
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
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/storename"/></b><br/><br/>
								<b>PHONE: </b><xsl:value-of select="//rootnode/smmessage/storetel"/><br/>
								<b>FAX: </b><xsl:value-of select="//rootnode/smmessage/storeFax"/><br/><br/>
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
							<td class="pcontent"><b class="tdhead"><xsl:value-of select="//rootnode/smmessage/suppliername"/></b><br/><br/>
								@@Address
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent"><b>&#160; </b></td>
							<td class="pcontent">
									<b>CREDIT NOTE NR:</b>&#160;
										<input type="text" name="txtCCNum" id="txtCCNum" size="20" value="@@CCNum" class="pcontent"/><br/>
									<b>CREDIT NOTE DATE: </b>
										@@CCDate	<br/><br/>						
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
										<xsl:when test="//rootnode/smmessage/cliamdate!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/cliamdate"/><br/><br/>
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
									<xsl:if test="//rootnode/smmessage/manualnum!=''">
										<b>MANUAL CLAIM NR: </b>&#160;<xsl:value-of select="//rootnode/smmessage/manualnum"/><br/>
										<b>MANUAL CLAIM DATE: </b>&#160;<xsl:value-of select="//rootnode/smmessage/manualdate"/><br/>
									</xsl:if>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bordercolor="#4C8ED7">
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top">
					<b>TRADE DISCOUNT 1 %</b>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc1!=''">
							<input type="text" name="txtDisc1" id="txtDisc1" size="5" value="{format-number (//rootnode/smmessage/discperc1,'DDD,DDD.00', 'staff')}" class="pcontent"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtDisc1" id="txtDisc1" size="5" value="0.00" class="pcontent"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top">
					<b>TRADE DISCOUNT 2 %</b>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc2!=''">
							<input type="text" name="txtDisc2" id="txtDisc2" size="5" value="{format-number (//rootnode/smmessage/discperc2,'DDD,DDD.00', 'staff')}" class="pcontent"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtDisc2" id="txtDisc2" size="5" value="0.00" class="pcontent"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top">
					<b>TRADE DISCOUNT 3 %</b>
					<xsl:choose>
						<xsl:when test="//rootnode/smmessage/discperc3!=''">
							<input type="text" name="txtDisc3" id="txtDisc3" size="5" value="{format-number (//rootnode/smmessage/discperc3,'DDD,DDD.00', 'staff')}" class="pcontent"/>
						</xsl:when>
						<xsl:otherwise>
							<input type="text" name="txtDisc3" id="txtDisc3" size="5" value="0.00" class="pcontent"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" bordercolor="#4C8ED7">
			<tr>
				
				<td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%" bordercolor="#4C8ED7">
						<tr>
							<td class="pcontent" colspan="2" align="right" valign="top">
								<b>CLAIM AMOUNT</b>
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2!=''">			
										<input type="text" name="txtAmtExcl" id="txtAmtExcl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2=''">			
										<input type="text" name="txtAmtExcl" id="txtAmtExcl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2!=''">			
										<input type="text" name="txtAmtExcl" id="txtAmtExcl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2=''">		
										<input type="text" name="txtAmtExcl" id="txtAmtExcl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:when>		
									<xsl:otherwise>
										<input type="text" name="txtAmtExcl" id="txtAmtExcl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td class="pcontent" colspan="2" align="right" valign="top">
								<b>VAT AMOUNT</b>
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/vat!='' or //rootnode/smmessage/vat!='0'">
										<input type="text" name="txtTotVat" id="txtTotVat" size="5" value="{format-number (//rootnode/smmessage/vat,'DDD,DDD.00', 'staff')}" class="pcontent"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="text" name="txtTotVat" id="txtTotVat" size="5" value="0.00" class="pcontent"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
						<tr>
							<td class="pcontent" colspan="2" align="right" valign="top">
								<b>TOTAL</b>
								<xsl:choose>
									<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2!=''">		
										<input type="text" name="txtTotIncl" id="txtTotIncl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100) + //rootnode/smmessage/vat,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2=''">			
										<input type="text" name="txtTotIncl" id="txtTotIncl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100) + //rootnode/smmessage/vat,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2!=''">			
										<input type="text" name="txtTotIncl" id="txtTotIncl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100) + //rootnode/smmessage/vat,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:when>
									<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2=''">			
										<input type="text" name="txtTotIncl" id="txtTotIncl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) + //rootnode/smmessage/vat,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:when>		
									<xsl:otherwise>
										<input type="text" name="txtTotIncl" id="txtTotIncl" size="5" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>	
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>	
					</table>
				</td>
			</tr>		
		</table>
		@@Error
		<br/>
		<xsl:if test="//rootnode/smmessage/numlines!=0">	
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="left"><b>Product Code<br/>Product Barcode</b></td>
					<td class="tdcontent" align="left"><b>Product<br/>Description</b></td>
					<td class="tdcontent" align="left"><b>UOM</b></td>
					<td class="tdcontent" align="left"><b>Whole<br/>Qty</b></td>
					<td class="tdcontent" align="left"><b>Line<br/>Cost</b></td>
					<td class="tdcontent" align="left"><b>Deal1 %</b></td>
					<td class="tdcontent" align="left"><b>Deal2 %</b></td>
					<td class="tdcontent" align="left"><b>VAT %</b></td>
					<td class="tdcontent" align="left" width="10%"><b>Total</b></td>
				</tr>
				<xsl:apply-templates select="//rootnode/smmessage/claimline"/>
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" colspan="8" align="right"><b>Sub Total</b></td>
					<td class="tdcontent" align="right">
						<input type="text" name="txtSubTot" id="txtSubTot" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>	
					</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="8" align="right"><b>Trade Discount 1: </b></td>
					<td class="pcontent" align="right">
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discind1!=''">
								<input type="text" name="txtTrade1" id="txtTrade1" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
							</xsl:when>
							<xsl:otherwise>
								<input type="text" name="txtTrade1" id="txtTrade1" size="10" value="0.00" class="pcontent"/>	
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="8" align="right"><b>Trade Discount 2: </b></td>
					<td class="pcontent" align="right">
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discind2!=''">
								<input type="text" name="txtTrade2" id="txtTrade2" size="10" value="{format-number ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100,'DDD,DDD.00', 'staff')}" class="pcontent"/>	
							</xsl:when>
							<xsl:otherwise>
								<input type="text" name="txtTrade2" id="txtTrade2" size="10" value="0.00" class="pcontent"/>	
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" colspan="8" align="right"><b>Total</b></td>
					<td class="tdcontent" align="right">
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2!=''">	
								<input type="text" name="txtTotal" id="txtTotal" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>		
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2=''">			
								<input type="text" name="txtTotal" id="txtTotal" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2!=''">			
								<input type="text" name="txtTotal" id="txtTotal" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')}" class="pcontent"/>
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2=''">			
								<input type="text" name="txtTotal" id="txtTotal" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>
							</xsl:when>		
							<xsl:otherwise>
								<input type="text" name="txtTotal" id="txtTotal" size="10" value="{format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')}" class="pcontent"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
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
 					<input type="text" name="txtProdCode{position()}" id="txtProdCode{position()}" size="20" value="{prodcode}" class="pcontent"/>
 				</xsl:when>
 				<xsl:otherwise>
 					<input type="text" name="txtProdCode{position()}" id="txtProdCode{position()}" size="20" value="-" class="pcontent"/>
 				</xsl:otherwise>
 			</xsl:choose>
			<br/>
			<xsl:choose>
 				<xsl:when test="prodean!=''">
 					<input type="text" name="txtProdEAN{position()}" id="txtProdEAN{position()}" size="20" value="{prodean}" class="pcontent"/>
 				</xsl:when>
 				<xsl:otherwise>
 					<input type="text" name="txtProdEAN{position()}" id="txtProdEAN{position()}" size="20" value="-" class="pcontent"/>
 				</xsl:otherwise>
 			</xsl:choose>
 		</td>
 		<td class="pcontent" align="left">
			<xsl:choose>
				<xsl:when test="proddescr!=''">
					<input type="text" name="txtProdDescr{position()}" id="txtProdDescr{position()}" size="40" value="{proddescr}" class="pcontent"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtProdDescr{position()}" id="txtProdDescr{position()}" size="40" value="-" class="pcontent"/>
				</xsl:otherwise>	
			</xsl:choose>	
		</td>
 		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="uom!=''	or uom!='0' or uom!='NULL'">
					<input type="text" name="txtUOM{position()}" id="txtUOM{position()}" size="1" value="{uom}" class="pcontent"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" name="txtUOM{position()}" id="txtUOM{position()}" size="1" value="-" class="pcontent"/>
				</xsl:otherwise>	
			</xsl:choose> 		
 		</td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="wholeqty!=''">
 					<input type="text" name="txtQty{position()}" id="txtQty{position()}" size="1" value="{wholeqty}" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					<input type="text" name="txtQty{position()}" id="txtQty{position()}" size="1" value="-" class="pcontent"/>
			 	</xsl:otherwise>
			 </xsl:choose>
		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="unitprice='0'">
 					<input type="text" name="txtUnitPrice{position()}" id="txtUnitPrice{position()}" size="5" value="0.00" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<input type="text" name="txtUnitPrice{position()}" id="txtUnitPrice{position()}" size="5" value="{format-number (unitprice,'DDD,DDD.00', 'staff')}" class="pcontent"/>
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="deal1perc!='0' or deal1perc!=''">
 					<input type="text" name="txtDeal1Perc{position()}" id="txtDeal1Perc{position()}" size="5" value="{format-number (deal1perc,'DDD,DDD.00', 'staff')}" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<input type="text" name="txtDeal1Perc{position()}" id="txtDeal1Perc{position()}" size="5" value="0.00" class="pcontent"/>
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="deal2perc!=''">
 					<input type="text" name="txtDeal2Perc{position()}" id="txtDeal2Perc{position()}" size="5" value="{deal2perc}" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<input type="text" name="txtDeal2Perc{position()}" id="txtDeal2Perc{position()}" size="5" value="0.00" class="pcontent"/>
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="vatperc='0'">
			 		<input type="text" name="txtVat{position()}" id="txtVat{position()}" size="5" value="{vatperc}" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
			 		<input type="text" name="txtVat{position()}" id="txtVat{position()}" size="5" value="0.00" class="pcontent"/>
				</xsl:otherwise>
			 </xsl:choose> 		
 		</td>
 		<td class="pcontent" align="right">
 			 <xsl:choose>
 				<xsl:when test="subtot=''">
 					<input type="text" name="txtSubTot{position()}" id="txtSubTot{position()}" size="5" value="0.00" class="pcontent"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					<input type="text" name="txtSubTot{position()}" id="txtSubTot{position()}" size="5" value="{format-number (subtot,'DDD,DDD.00', 'staff')}" class="pcontent"/>
			 	</xsl:otherwise>
			 </xsl:choose> 		 		
 		</td>
 	</tr>
 	<tr>
 		<td class="pcontent">&#160;</td>
 		<td colspan="8">
 			<table>
 				<tr>
			 		<td class="pcontent"><b>Line Narrative:&#160;</b></td>
			 		<td class="pcontent"><input type="text" name="txtNarr{position()}" id="txtNarr{position()}" size="70" value="" class="pcontent"/></td>
			 	</tr>
			 	<tr>
 					<td class="pcontent"><b>Reason:</b></td>
 					<td class="pcontent">
 						<select name="drpReason{position()}" id="drpReason{position()}" class="pcontent">
							@@ReasonOption
						</select>
					</td>
				</tr>
				<tr>
					<td class="pcontent"><b>Goods Return Reason:</b></td>
					<td class="pcontent">
						<select name="drpGoods{position()}" id="drpGoods{position()}" class="pcontent">
							@@GoodsOption
						</select>
					</td>
				</tr>
			</table>
		</td>
 	</tr>
 </xsl:template>
</xsl:stylesheet>

