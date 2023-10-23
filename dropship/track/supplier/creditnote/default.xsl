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
				<td class="iheader" align="left">CREDIT NOTE (LIST REFERENCED CLAIMS)</td>
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
		<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#b9b9b9">
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
								<b>FAX: </b><xsl:value-of select="//rootnode/smmessage/storefax"/><br/>
								<b>VAT NO: </b><xsl:value-of select="//rootnode/smmessage/storevatno"/><br/><br/>
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
								<b class="pcontent">VAT NO: <xsl:value-of select="//rootnode/smmessage/suppliervatno"/></b><br/><br/>
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
				<td class="pcontent" valign="top">&#160;&#160;&#160;<b>R</b>&#160;<xsl:value-of select="//rootnode/smmessage/totexcl"/>
					<br/>
						&#160;&#160;&#160;<b>R</b>&#160;<xsl:value-of select="//rootnode/smmessage/vat"/>
					<br/>
						&#160;&#160;&#160;<b>R</b>&#160;<xsl:value-of select="//rootnode/smmessage/totIncl"/>
				</td>
			</tr>			
			<!--<tr>
				<td class="pcontent" colspan="3" align="left" valign="top"><b>HEADER NARRATIVE: </b><xsl:value-of select="//rootnode/smmessage/reasondescr"/></td>
			</tr>-->
		</table>
		<br/>
		<xsl:if test="//rootnode/smmessage/numclaim!=0">	
			<p class="pcontent">
				Below is a list of referenced claims linked for this Credit Note.
				<ul>
					<li class="pcontent">Click on the <b>View</b> button to view the referenced claim detail.</li>
				</ul>	
			</p>
			<table border="1" cellpadding="2" cellspacing="0" width="100%">
				<tr bgcolor="#4C8ED7">
					<td class="tdcontent" align="center"><b>To View</b></td>
					<td class="tdcontent" align="center"><b>Electronic Claim No.</b></td>
					<td class="tdcontent" align="center"><b>Claim Type</b></td>
					<td class="tdcontent" align="center"><b>Claim Reason</b></td>
					<td class="tdcontent" align="center"><b>Claim Date</b></td>
					<td class="tdcontent" align="center"><b>Invoice Number</b></td>
					<td class="tdcontent" align="center"><b>Invoice Date</b></td>
					<td class="tdcontent" align="center"><b>Manual Claim Number</b></td>
					<td class="tdcontent" align="center"><b>Manual Claim Date</b></td>
					<td class="tdcontent" align="center"><b>Credit Value Incl</b></td>
				</tr>
				<xsl:apply-templates select="//rootnode/smmessage/claim"/>
			</table>
		</xsl:if>
	</form>
	</xsl:otherwise>
</xsl:choose>
 </xsl:template>
 
 <xsl:template match="claim">
		<!--<xsl:if test="position()>=2">-->
				<tr>
					<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/item.asp?item={creditnoteclaimid}', 'CreditNoteClaimLines', 'width=1200,height=900,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">View</a></td>
					<td class="pcontent" align="center"><a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/item.asp?item={creditnoteclaimid}', 'CreditNoteClaimLines', 'width=1200,height=900,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');"><xsl:value-of select="claimnum"/></a></td>
					<td class="pcontent" align="center"><xsl:value-of select="claimtype"/></td>
					<td class="pcontent" align="center">
            <xsl:choose>
              <xsl:when test="reasoncode[.='SD']">Quantity</xsl:when>
              <xsl:when test="claimtype[.='DFC'] and reasoncode[.='GR']">Quantity</xsl:when>
              <xsl:when test="claimtype[.='RFC'] and reasoncode[.='GR']">Returns</xsl:when>
              <xsl:when test="reasoncode[.='PD' or .='DD' or .='DR' or .='RB' or .='DU']">Pricing</xsl:when>
              <xsl:when test="reasoncode[.='RC']">Returns (Crates)</xsl:when>
              <xsl:otherwise>-</xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="pcontent" align="center">
            <xsl:choose>
              <xsl:when test="claimdate!=''">
                <xsl:value-of select="claimdate"/>
              </xsl:when>
              <xsl:otherwise>	- </xsl:otherwise>
            </xsl:choose>
          </td>
          <td class="pcontent" align="center">
            <xsl:choose>
              <xsl:when test="invnum!=''"><xsl:value-of select="invnum"/></xsl:when>
							<xsl:otherwise> - </xsl:otherwise>
						</xsl:choose>			
					</td>
					<td class="pcontent" align="center">
						<xsl:choose>
							<xsl:when test="invdate!=''"><xsl:value-of select="invdate"/></xsl:when>
							<xsl:otherwise> - </xsl:otherwise>
						</xsl:choose>			
					</td>
					<td class="pcontent" align="center">
						<xsl:choose>
							<xsl:when test="manualnum!=''"><xsl:value-of select="manualnum"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>	
						</xsl:choose>	
					</td>
					<td class="pcontent" align="center">
						<xsl:choose>
							<xsl:when test="manualdate!=''"><xsl:value-of select="manualdate"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>	
						</xsl:choose>	
					</td>
					<td class="pcontent" align="center">
						<xsl:choose>
							<xsl:when test="costincl!=''">R&#160;<xsl:value-of select="format-number(costincl,'DDD,DDD.00', 'staff')"/></xsl:when>
							<xsl:otherwise>-</xsl:otherwise>	
						</xsl:choose>	
					</td>
				</tr>
			<!--</xsl:if>-->
	 </xsl:template>
</xsl:stylesheet>

