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
	<form action="doorder.asp?id=@@XMLFile" method="post" name="updateclaim" id="updateclaim" onsubmit="return validate(this);">
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
				<td class="iheader" align="left">CREDIT NOTE</td>
			</tr>
		</table><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<!-- Create the Buttons -->
			<tr>
				<td class="pcontent" align="center">
					<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id={rootnode/smmessage/cnid}&amp;type=xml&amp;action=cn'"/>&#160;
						<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id={rootnode/smmessage/cnid}&amp;type=txt&amp;action=cn'"/>&#160;
					<input type="button" name="btnPrint" id="btnPrint" value="Print Credit Note" class="button"  onclick="javascript:window.print();"/>&#160;
					<input type="button" name="btnClose" id="btnClose" value="Close Window" class="button" onclick="javascript:window.close();"/>&#160;
				</td>
			</tr>
			<!-- End Create the Buttons -->		
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
							<td class="pcontent">
									<b>CREDIT NOTE NR:</b>&#160;
									<xsl:choose>
										<xsl:when test="//rootnode/smmessage/cnnumber!=''">
											&#160;<xsl:value-of select="//rootnode/smmessage/cnnumber"/><br/>
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
				<td class="pcontent" colspan="2" align="right" valign="top"><b>CREDIT NOTE VALUE&#160;&#160;</b><br/>
					<b>VAT&#160;&#160;</b><br/>
					<b>TOTAL CREDIT NOTE&#160;&#160;</b>
				</td>
				<td class="pcontent" valign="top">&#160;&#160;&#160;<b>R</b>&#160;@@NetExtendExcl
					<br/>
						&#160;&#160;&#160;<b>R</b>&#160;@@NetExtendVat
					<br/>
						&#160;&#160;&#160;<b>R</b>&#160;@@NetExtendIncl
				</td>
			</tr>			
			<!--<tr>
				<td class="pcontent" colspan="3" align="left" valign="top"><b>HEADER NARRATIVE: </b><xsl:value-of select="//rootnode/smmessage/reasondescr"/></td>
			</tr>-->
		</table>
		<br/>
		<xsl:if test="//rootnode/smmessage/numclaim!=0">	
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="pcontent" colspan="13"><b>Reference To:</b></td>
				</tr>
				<tr bgcolor="#333366">
					<td class="tdcontent" align="center" colspan="2"><b>Electronic Claim No.</b></td>
					<td class="tdcontent" align="center"><b>Claim Date</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Invoice Number</b></td>
					<td class="tdcontent" align="center"><b>Invoice Date</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Manual Claim Number</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Manual Claim Date</b></td>
					<td class="tdcontent" align="center" colspan="3"><b>Claim Type</b></td>
				</tr>
			<xsl:apply-templates select="//rootnode/smmessage/claim"/>
					<!-- Start Total-->
					<tr>
						<td class="pcontent" colspan="13">&#160;</td>
					</tr>
					<tr>
						<td class="pcontent" colspan="13" bgcolor="#ccccc2">&#160;</td>
					</tr>
					<tr>
						<td class="pcontent" colspan="13">&#160;</td>
					</tr>
					<tr bgcolor="#333366">
						<td class="tdcontent" colspan="5" align="right"><b>Total&#160;&#160;</b></td>
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/grossprice),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
						<td class="tdcontent" align="center">&#160;</td>
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/deal1amt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>
						<td class="tdcontent" align="center">&#160;</td>
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/deal2amt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/netprice),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/vatamt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
						<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(//rootnode/smmessage/claim/claimline/totincl),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
					</tr>
					<!-- End Total-->

					<!-- Start Credit Adjustments-->
					<tr>
						<td class="pcontent" align="center" rowspan="2"><b>Less:</b></td>
						<td class="pcontent" colspan="4" align="center">
							<table width="100%" border="0">
								<tr>
									<td class="pcontent" align="center" width="60%"><b>Trade Discount 1: </b></td>
									<td class="pcontent" align="center" width="20%"><b>@@Trade1Perc %</b></td>
									<td class="pcontent" align="center" width="20%"><b>R @@Trade1Amt</b></td>
								</tr>
							</table>	
						</td>
						<td class="pcontent" colspan="5">&#160;</td>
						<td class="pcontent" align="right">@@Trade1Amt&#160;&#160;</td>
						<td class="pcontent" align="right">@@Trade1Vat&#160;&#160;</td>
						<td class="pcontent" align="right">@@Trade1Incl&#160;&#160;</td>
					</tr>
					<tr>
						<td class="pcontent" colspan="4" align="center">
							<table width="100%">
								<tr>
									<td class="pcontent" align="center" width="60%"><b>Trade Discount 2: </b></td>
									<td class="pcontent" align="center" width="20%"><b>@@Trade2Perc %</b></td>
									<td class="pcontent" align="center" width="20%"><b>R @@Trade2Amt</b></td>
								</tr>
							</table>	
						</td>
						<td class="pcontent" colspan="5">&#160;</td>
						<td class="pcontent" align="right">@@Trade2Amt&#160;&#160;</td>
						<td class="pcontent" align="right">@@Trade2Vat&#160;&#160;</td>
						<td class="pcontent" align="right">@@Trade2Incl&#160;&#160;</td>
					</tr>
					<!-- End Credit Adjustments-->
					
					<!-- Start Extended Total-->
					<tr bgcolor="#333366">
						<td class="tdcontent" colspan="5" align="right"><b>Extended Total&#160;&#160;</b></td>
						<td class="tdcontent" colspan="5"  align="center">&#160;</td>
						<td class="tdcontent" align="right"><b>@@ExtendExcl&#160;&#160;</b> </td>					
						<td class="tdcontent" align="right"><b>@@ExtendVat&#160;&#160;</b> </td>					
						<td class="tdcontent" align="right"><b>@@ExtendIncl&#160;&#160;</b> </td>					
					</tr>
					<!-- End Extended Total-->
					
					<!-- Start Debit Adjustments-->
					<tr>
						<td class="pcontent" align="center" rowspan="2"><b>Add:</b></td>
						<td class="pcontent" colspan="4" align="center">
							<table width="100%">
								<tr>
									<td class="pcontent" align="center" width="60%"><b>Transport: </b></td>
									<td class="pcontent" align="center" width="20%">&#160;</td>
									<td class="pcontent" align="center" width="20%">&#160;</td>
								</tr>
							</table>	
						</td>
						<td class="pcontent" colspan="5">&#160;</td>
						<td class="pcontent" align="right">@@TransExcl&#160;&#160;</td>
						<td class="pcontent" align="right">@@TransVat&#160;&#160;</td>
						<td class="pcontent" align="right">@@TransIncl&#160;&#160;</td>
					</tr>
					<tr>
						<td class="pcontent" colspan="4" align="center">
							<table width="100%">
								<tr>
									<td class="pcontent" align="center" width="60%"><b>Duties: </b></td>
									<td class="pcontent" align="center" width="20%">&#160;</td>
									<td class="pcontent" align="center" width="20%">&#160;</td>
								</tr>
							</table>	
						</td>
						<td class="pcontent" colspan="5">&#160;</td>
						<td class="pcontent" align="right">@@DutyExcl&#160;&#160;</td>
						<td class="pcontent" align="right">@@DutyVat&#160;&#160;</td>
						<td class="pcontent" align="right">@@DutyIncl&#160;&#160;</td>
					</tr>
					<!-- End Debit Adjustments-->
					
					<!-- Start Net Extended Total-->
					<tr bgcolor="#333366">
						<td class="tdcontent" colspan="5" align="right"><b>Net Extended Total&#160;&#160;</b></td>
						<td class="tdcontent" colspan="5"  align="center">&#160;</td>
						<td class="tdcontent" align="right"><b>@@NetExtendExcl&#160;&#160;</b></td>
						<td class="tdcontent" align="right"><b>@@NetExtendVat&#160;&#160;</b></td>
						<td class="tdcontent" align="right"><b>@@NetExtendIncl&#160;&#160;</b></td>			
					</tr>
					<!-- End Net Extended Total-->
			</table>
		</xsl:if>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="claim">
	<!--<table border="1" cellpadding="0" cellspacing="0" width="100%">-->
		<xsl:if test="position()>=2">
				<tr>
					<td class="pcontent" colspan="13">&#160;</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="13" bgcolor="#ccccc2">&#160;</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="13">&#160;</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="13"><b>Reference To:</b></td>
				</tr>
				<tr bgcolor="#333366">
					<td class="tdcontent" align="center" colspan="2"><b>Electronic Claim No.</b></td>
					<td class="tdcontent" align="center"><b>Claim Date</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Invoice Number</b></td>
					<td class="tdcontent" align="center"><b>Invoice Date</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Manual Claim Number</b></td>
					<td class="tdcontent" align="center" colspan="2"><b>Manual Claim Date</b></td>
					<td class="tdcontent" align="center" colspan="3"><b>Claim Type</b></td>
				</tr>
		</xsl:if>	
				<tr>
					<xsl:choose>
						<xsl:when test="claimid=0"><td class="pcontent" align="center" colspan="2"> - </td><td class="pcontent" align="center">-</td></xsl:when>
						<xsl:otherwise><td class="pcontent" align="center" colspan="2"><xsl:value-of select="claimnum"/></td><td class="pcontent" align="center"><xsl:value-of select="claimdate"/></td></xsl:otherwise>	
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="invid=0"><td class="pcontent" align="center" colspan="2"> - </td><td class="pcontent" align="center">-</td></xsl:when>
						<xsl:otherwise><td class="pcontent" align="center" colspan="2"><xsl:value-of select="invnum"/></td><td class="pcontent" align="center"><xsl:value-of select="invdate"/></td></xsl:otherwise>	
					</xsl:choose>	
					<td class="pcontent" align="center" colspan="2">
						<xsl:choose>
							<xsl:when test="manualnum!=''"><xsl:value-of select="manualnum"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>	
						</xsl:choose>	
					</td>
					<td class="pcontent" align="center" colspan="2">
						<xsl:choose>
							<xsl:when test="manualdate!=''"><xsl:value-of select="manualdate"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>	
						</xsl:choose>	
					</td>
					<td class="pcontent" align="center" colspan="3"><xsl:value-of select="claimtype"/></td>
				</tr>
				<tr bgcolor="#333366">
					<td class="tdcontent" align="left"><b>Product<br/>Code</b></td>
					<td class="tdcontent" align="left"><b>Product<br/>Description</b></td>
					<td class="tdcontent" align="left"><b>UOM</b></td>
					<td class="tdcontent" align="left"><b>Qty</b></td>
					<td class="tdcontent" align="left"><b>Unit<br/>Price</b></td>
					<td class="tdcontent" align="left"><b>Gross<br/>Price</b></td>
					<td class="tdcontent" align="left"><b>Deal1 (%)</b></td>
					<td class="tdcontent" align="left"><b>Deal1 (R)</b></td>
					<td class="tdcontent" align="left"><b>Deal2 (%)</b></td>
					<td class="tdcontent" align="left"><b>Deal2 (R)</b></td>
					<td class="tdcontent" align="left"><b>Net</b></td>
					<td class="tdcontent" align="left"><b>VAT</b></td>
					<td class="tdcontent" align="left"><b>Amount</b></td>
				</tr>
				<xsl:apply-templates select="claimline"/>
				
				<!-- Start Sub Total-->
				<tr bgcolor="#333366">
					<td class="tdcontent" colspan="5" align="right"><b>Sub Total&#160;&#160;</b></td>
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/grossprice),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b></td>
					<td class="tdcontent" align="center">&#160;</td>
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/deal1amt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>
					<td class="tdcontent" align="center">&#160;</td>
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/deal2amt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/netprice),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/vatamt),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
					<td class="tdcontent" align="right"><b><xsl:value-of select="format-number (sum(claimline/totincl),'DDD,DDD.00', 'staff')"/>&#160;&#160;</b> </td>					
				</tr>
					<!-- End Sub Total-->
			<!--</table>-->
 </xsl:template>	
 
 <xsl:template match="claimline">
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
			</td>
			<td class="pcontent" align="left"><xsl:value-of select="proddescr"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="uom"/></td>
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
					<xsl:when test="unitprice='0'">
						0.00&#160;&#160;
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number (unitprice,'DDD,DDD.00', 'staff')"/>&#160;&#160;
					</xsl:otherwise>
				 </xsl:choose>
			</td>
			<td class="pcontent" align="center"><xsl:value-of select="format-number (unitprice  * qty,'DDD,DDD.00', 'staff')"/>&#160;&#160; 	</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="deal1perc!='0'">
						<xsl:value-of select="format-number (deal1perc,'DDD,DDD.00', 'staff')"/>&#160;&#160; 				
					</xsl:when>
					<xsl:otherwise>
						0.00&#160;&#160;
					</xsl:otherwise>
				 </xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="deal1amt!='0'">
						<xsl:value-of select="format-number (deal1amt,'DDD,DDD.00', 'staff')"/>&#160;&#160; 				
					</xsl:when>
					<xsl:otherwise>
						0.00&#160;&#160;
					</xsl:otherwise>
				 </xsl:choose>
			</td>
			<td class="pcontent" align="center">
				 <xsl:choose>
					<xsl:when test="deal2perc!='0'">
						<xsl:value-of select="format-number (deal2perc,'DDD,DDD.00', 'staff')"/>&#160;&#160;
					</xsl:when>
					<xsl:otherwise>
						0.00&#160;&#160;					
					</xsl:otherwise>
				 </xsl:choose>
			</td>
			<td class="pcontent" align="center">
				<xsl:choose>
					<xsl:when test="deal2amt!='0'">
						<xsl:value-of select="format-number (deal2amt,'DDD,DDD.00', 'staff')"/>&#160;&#160; 				
					</xsl:when>
					<xsl:otherwise>
						0.00&#160;&#160;
					</xsl:otherwise>
				 </xsl:choose>
			</td>
			<td class="pcontent" align="center"><xsl:value-of select="format-number (netprice,'DDD,DDD.00', 'staff')"/>&#160;&#160;</td>
			<td class="pcontent" align="center"><xsl:value-of select="format-number (vatamt,'DDD,DDD.00', 'staff')"/>&#160;&#160;</td>
			<td class="pcontent" align="right"><xsl:value-of select="format-number (totincl,'DDD,DDD.00', 'staff')"/>&#160;&#160;</td>
		</tr>
		<xsl:if test="reasondescr!=''"><tr><td class="pcontent" colspan="13"><b>Credit Reason:&#160;</b><xsl:value-of select="reasondescr"/></td></tr></xsl:if>
		<xsl:if test="goodsdescr!=''"><tr><td class="pcontent" colspan="13"><b>Goods Returned Reason:&#160;</b><xsl:value-of select="goodsdescr"/></td></tr></xsl:if>
		<xsl:if test="narr!=''"><tr><td class="pcontent" colspan="13"><b>Narrative:&#160;</b><xsl:value-of select="narr"/></td></tr></xsl:if>
	 </xsl:template>
</xsl:stylesheet>

