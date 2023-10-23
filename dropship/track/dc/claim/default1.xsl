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
				<td class="iheader" align="left">CLAIM&#160;
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
					<xsl:if test="//rootnode/smmessage/isxml='1'">
						<!--<input type="button" name="btnCreditNote" id="btnCreditNote" value="Generate Credit Note" onclick="javascript: location.href='@@ApplicationRoot/track/supplier/claim/gencc.asp?item=@@ClaimID'" class="button"/>&#160;-->
						<input type="button" name="btnDownXML" id="btnDownXML" value="Download XML File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@ClaimID&amp;type=xml&amp;action=clm'"/>&#160;
						<input type="button" name="btnDownTxt" id="btnDownTxt" value="Download Text File" class="button" onClick="javascript:location.href='@@ApplicationRoot/track/supplier/filedownload/default.asp?id=@@ClaimID&amp;type=txt&amp;action=clm'"/>&#160;
					</xsl:if>
					<input type="button" name="btnPrint" id="btnPrint" value="Print Claim" class="button"  onclick="javascript:window.print();"/>&#160;
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
			<tr>
				<td class="pcontent" colspan="2" align="right" valign="top"><b>TRADE DISCOUNT 1 %</b><br/>
					<b>TRADE DISCOUNT 2 %</b>
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
				<td class="pcontent" colspan="3" align="left" valign="top"><b>HEADER NARRATIVE: </b><xsl:value-of select="//rootnode/smmessage/reasondescr"/></td>
			</tr>
		</table>
		<br/>
		<xsl:if test="//rootnode/smmessage/numlines!=0">	
			<table border="1" cellpadding="0" cellspacing="0" width="100%">
				<tr bgcolor="#333366">
					<td class="tdcontent" align="left"><b>Product Code<br/>Product Barcode</b></td>
					<td class="tdcontent" align="left"><b>Product<br/>Description</b></td>
					<td class="tdcontent" align="left"><b>UOM</b></td>
					<td class="tdcontent" align="left"><b>Loose<br/>Qty</b></td>
					<td class="tdcontent" align="left"><b>Whole<br/>Qty</b></td>
					<td class="tdcontent" align="left"><b>Line<br/>Cost</b></td>
					<td class="tdcontent" align="left"><b>Deal1 %</b></td>
					<td class="tdcontent" align="left"><b>Deal2 %</b></td>
					<td class="tdcontent" align="left"><b>VAT %</b></td>
					<td class="tdcontent" align="left" width="10%"><b>Total</b></td>
				</tr>
				<xsl:apply-templates select="//rootnode/smmessage/claimline"/>
				<tr bgcolor="#333366">
					<td class="tdcontent" colspan="9" align="right"><b>Sub Total</b></td>
					<td class="tdcontent" align="right"><b>R&#160;<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')"/></b>&#160;&#160;</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="9" align="right"><b>Trade Discount 1: </b></td>
					<td class="pcontent" align="right"><b>R&#160;
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discind1!=''">
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100,'DDD,DDD.00', 'staff')"/>
							</xsl:when>
							<xsl:otherwise>
								0.00
							</xsl:otherwise>
						</xsl:choose>
						</b>&#160;
					</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="9" align="right"><b>Trade Discount 2: </b></td>
					<td class="pcontent" align="right"><b>R&#160;
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discind2!=''">
								<xsl:value-of select="format-number ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100,'DDD,DDD.00', 'staff')"/>
							</xsl:when>
							<xsl:otherwise>
								0.00
							</xsl:otherwise>
						</xsl:choose>
						</b>&#160;
					</td>
				</tr>
				<tr bgcolor="#333366">
					<td class="tdcontent" colspan="9" align="right"><b>Total</b></td>
					<td class="tdcontent" align="right"><b>R&#160;
						<xsl:choose>
							<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2!=''">			
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')"/>
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1!='' and //rootnode/smmessage/discperc2=''">			
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100),'DDD,DDD.00', 'staff')"/>
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2!=''">			
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot) - ((sum(//rootnode/smmessage/claimline/subtot) - (sum(//rootnode/smmessage/claimline/subtot) * (//rootnode/smmessage/discperc1) div 100)) *//rootnode/smmessage/discperc2  div 100),'DDD,DDD.00', 'staff')"/>
							</xsl:when>
							<xsl:when test="//rootnode/smmessage/discperc1='' and //rootnode/smmessage/discperc2=''">			
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')"/>
							</xsl:when>		
							<xsl:otherwise>
								<xsl:value-of select="format-number (sum(//rootnode/smmessage/claimline/subtot),'DDD,DDD.00', 'staff')"/>						
							</xsl:otherwise>
						</xsl:choose>
						</b>&#160;
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
 				<xsl:when test="looseqty!=''">
			 		<xsl:value-of select="looseqty"/>
			 	</xsl:when>
			 	<xsl:otherwise>
					-	 	
			 	</xsl:otherwise>
			 </xsl:choose>
		  </td>
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="wholeqty!=''">
			 		<xsl:value-of select="wholeqty"/>
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
 		<td class="pcontent" align="center">
 			<xsl:choose>
 				<xsl:when test="deal1perc!='0' or deal1perc!=''">
					<xsl:value-of select="deal1perc"/>&#160;&#160; 				
			 	</xsl:when>
			 	<xsl:otherwise>
			 		0&#160;&#160;
			 	</xsl:otherwise>
			 </xsl:choose>
 		</td>
 		<td class="pcontent" align="center">
 			 <xsl:choose>
 				<xsl:when test="deal2perc!=''">
 					<xsl:value-of select="deal2perc"/>&#160;&#160;
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
 		<td class="pcontent" colspan="9"><b>Line Narrative:&#160;</b><xsl:value-of select="narr1"/>&#160;<xsl:value-of select="narr2"/>&#160;<xsl:value-of select="narr3"/></td> 		
 	</tr>
 </xsl:template>
</xsl:stylesheet>

