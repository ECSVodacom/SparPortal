<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<xsl:choose>
			<xsl:when test="rootnode/smmessage/returnvalue!='0'">
				<br/>
				<br/>
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
						<td class="bheader" align="left" valign="top">Recon Report</td>
					</tr>
					<tr>
						<td class="errortext">
							<br/>
							<xsl:value-of select="rootnode/smmessage/errormessage"/>
							<br/>
						</td>
					</tr>
					<tr>
						<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="rootnode/smmessage/DC"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="DC">
		<!--<tr><td colspan="12"></td></tr>-->
		<tr>
			<td class="gheader" colspan="12" bgcolor="#333366" width="100%"><xsl:value-of select="name"/><!--&#160;DC&#160;(<xsl:value-of select="eannumber"/>)--></td>
			<xsl:apply-templates select="Supplier"/>
		</tr>
	</xsl:template>
	<xsl:template match="Supplier" >
		<br/>
		<br/>
		<table border="0" cellpadding="3" cellspacing="3" >
			<tr>
				<td class="bheader" align="left" valign="top"><xsl:value-of select="Name"/></td>
				<td class="bheader"><xsl:value-of select="SupplierNumber"/></td>
			</tr>
		</table>
		<xsl:apply-templates select="Store"/>
	</xsl:template>
	<xsl:template match="Store" >
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td class="sheader" align="left" valign="top"><xsl:value-of select="Name"/> : <xsl:value-of select="AccountNumber"/></td>
				<td class="sheader" align="left" valign="top">Store on DSH Auto Recon : <xsl:value-of select="AutoRecon"/></td>
			</tr>
		</table>
		<xsl:apply-templates select="Section"/>
		<br/>
		<xsl:apply-templates select="Tot"/>
		<xsl:call-template name="Static"/>
	</xsl:template>
	<xsl:template match="Section" >
		<xsl:choose>
			<xsl:when test="@Type='C Trans'">
				
				<!-- This gets executed when its a C Trans option -->
				<br/>
				<table border="0" cellpadding="2" cellspacing="2" width="100%">
					<tr>
						<td class="sheader" align="left" valign="top">TRANSACTIONS CLOSED THIS WEEK</td>
					</tr>
				</table>
				<xsl:call-template name="Display_Detail"/>
				<!-- End of C Trans -->
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@Type='O Claim'">
					
						<!-- This gets executed when its a O Claim option -->
						<br/>
						<table border="0" cellpadding="2" cellspacing="2" width="100%">
							<tr>
								<td class="sheader" align="left" valign="top">OPEN CLAIMS : OUTSTANDING AND PARTIALLY SETTLED</td>
							</tr>
						</table>
						<xsl:call-template name="Display_Detail"/>
						<!-- End of O Claim -->
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@Type='O Trans'">
								
								<!-- This gets executed when its a O Trans option -->
								<br/>
								<table border="0" cellpadding="2" cellspacing="2" width="100%">
									<tr>
										<td class="sheader" align="left" valign="top">OPEN TRANSACTIONS (GRV Outstanding / DFC Claims Outstanding / Dispute in progress)</td>
									</tr>
								</table>
								<xsl:call-template name="Display_Detail"/>
								<!-- End of O Trans -->
								
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="@Type='Rejected Claims'">
									
										<!-- This gets executed when its a Rejected Claims option -->
										<br/>
										<table border="0" cellpadding="2" cellspacing="2" width="100%">
											<tr>
												<td class="sheader" align="left" valign="top">Rejected Claims</td>
											</tr>
										</table>
										<xsl:call-template name="Display_Detail"/>
										<!-- End of Rejected -->
										
									</xsl:when>
									<xsl:otherwise>
										<!-- This gets executed for anything else like Unmatched option -->
										<br/>
										<table border="0" cellpadding="2" cellspacing="2" width="100%">
											<tr>
												<td class="sheader" align="left" valign="top">Missing Invoices - GRV received from store; no matching invoice from supplier</td>
											</tr>
										</table>
										<xsl:call-template name="Display_Detail"/>
																			
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Display_Detail">
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Doc Type</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Inv No</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Crn No</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>GRV no</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Clm No</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Ref doc no</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Doc Date</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Payment Date</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Amount Inc</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>DFC Claim Amt</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Net Amt</i></b></th>
				<th class="pcontent" align="center" bgcolor="#ccccc2"><b><i>Variance</i></b></th>
			</tr>
			<xsl:apply-templates select="Line"/>
			<xsl:call-template name="Totals"/>
		</table>
	</xsl:template>
	<xsl:template name="Totals">
		<tr></tr>
		<tr>
			<td class="sheader" align="left" valign="top">Totals</td>
			<td class="tdcontent" align="center" ><b><i>Inv No</i></b></td>
			<td class="tdcontent" align="center" ><b><i>Crn No</i></b></td>
			<td class="tdcontent" align="center" ><b><i>GRV no</i></b></td>
			<td class="tdcontent" align="center" ><b><i>Clm No</i></b></td>
			<td class="tdcontent" align="center" ><b><i>Ref doc no</i></b></td>
			<td class="tdcontent" align="center" ><b><i>Doc Date</i></b></td>
			<td class="tdcontent" align="center" ><b><i>Payment Date</i></b></td>
			<td class="sheader" align="center" ><b><i><xsl:value-of select="TotalAmt"/></i></b></td>
			<td class="sheader" align="center" ><b><i><xsl:value-of select="TotalDFC"/></i></b></td>
			<td class="sheader" align="center" ><b><i><xsl:value-of select="TotalNet"/></i></b></td>
			<td class="tdcontent" align="center" ><b><i>Variance</i></b></td>
		</tr>
	</xsl:template>
	<xsl:template match="Line" >
		<tr>
			<td class="pcontent" align="center"><xsl:value-of select="DocType"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="InvNo"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="CrnNo"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="GrvNo"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="ClmNo"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="RefDocNo"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="DocDate"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="PayDueDate"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="AmountINC"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="DFC"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="Nett"/></td>
			<td class="pcontent" align="center"><xsl:value-of select="VarianceKey"/></td>
		</tr>
	</xsl:template>
	<xsl:template match="Tot">
		<table border="1" cellpadding="2" cellspacing="2" width="25%">
			<tr>
				<td>Open</td>
				<td><xsl:value-of select="OT"/></td>
			</tr>
			<tr>
				<td>Closed</td>
				<td><xsl:value-of select="CT"/></td>
			</tr>
			<tr>
				<td>O/S Claims</td>
				<td><xsl:value-of select="OC"/></td>
			</tr>
			<tr>
				<td>Missing GRV's</td>
				<td><xsl:value-of select="MIS"/></td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Static">
		<br/><br/>
		<table border="1" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td class="pcontent" align="center">Variance Key:   1: DFC Claim Partially settled   2: DFC Claim Outstanding   3: Credit amount
				&lt; Claim amount; may raise RFC claim for difference   4:  GRV amount not equal to Invoice amount   5: No GRV received   6: No Claim received
				7: No Invoice received   8: DFC Claim converted to RFC   9 : RFC Credit Note outstanding   10: RFC Claim Outstanding</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>