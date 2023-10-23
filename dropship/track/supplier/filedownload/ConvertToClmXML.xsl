<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<Doc>
		<Claims>
			<Claim>
				<Vendor ID="{//rootnode/smmessage/supplierean}"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Vendor>			
				<ClaimNo><xsl:value-of select ="//rootnode/smmessage/claimnumber"/></ClaimNo>
				<ClaimType><xsl:value-of select ="//rootnode/smmessage/claimtype"/></ClaimType>
				<InvoiceNo><xsl:value-of select ="//rootnode/smmessage/invoicenum"/></InvoiceNo>
				<ManualNumber><xsl:value-of select ="//rootnode/smmessage/manualnum"/></ManualNumber>
				<ClaimAmt><xsl:value-of select ="//rootnode/smmessage/amt"/></ClaimAmt>				
				<ClaimVat><xsl:value-of select ="//rootnode/smmessage/vat"/></ClaimVat>								
				<Discounts>
					<Discount>
						<Indicator><xsl:value-of select="//rootnode/smmessage/discind1"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/discperc1"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/discamt1"/></Value>
					</Discount>
					<Discount>
						<Indicator><xsl:value-of select="//rootnode/smmessage/discind1"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/discperc2"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/discamt2"/></Value>
					</Discount>
				</Discounts>
				<ReasonCode><xsl:value-of select ="//rootnode/smmessage/reasoncode"/></ReasonCode>								
				<ReasonDescr><xsl:value-of select ="//rootnode/smmessage/reasondescr"/></ReasonDescr>												
				<Depot ID="0"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Depot>
				<ClaimDate><xsl:value-of select ="//rootnode/smmessage/cliamdate"/></ClaimDate>
				<InvoiceDate><xsl:value-of select="//rootnode/smmessage/invoicedate"/></InvoiceDate>
				<ManualDate><xsl:value-of select ="//rootnode/smmessage/manualdate"/></ManualDate>				
				<NumberLines><xsl:value-of select="//rootnode/smmessage/numlines"/></NumberLines>
				<Items>
					<xsl:for-each select="//smmessage/claimline">
						<Item>
							<ItemNum><xsl:value-of select="position()"/></ItemNum>
							<LooseQty><xsl:value-of select="looseqty"/></LooseQty>
							<WholeQty><xsl:value-of select="wholeqty"/></WholeQty>
							<CostPer><xsl:value-of select="unitprice"/></CostPer>
							<CostUnitMeasure><xsl:value-of select="totmeasure"/></CostUnitMeasure>
							<GrossCst><xsl:value-of select="subtot"/></GrossCst>
							<Vat><xsl:value-of select="vatperc"/></Vat>
							<ReasonCode><xsl:value-of select="reasoncode"/></ReasonCode>
							<ReasonDescr><xsl:value-of select="reasondescr"/></ReasonDescr>
							<GoodsReturnCode><xsl:value-of select="goodscode"/></GoodsReturnCode>
							<GoodsReturnDescr><xsl:value-of select="goodsdescr"/></GoodsReturnDescr>
							<Narratives>
								<Narrative>
									<Description><xsl:value-of select="narr1"/></Description>
								</Narrative>
								<Narrative>
									<Description><xsl:value-of select="narr2"/></Description>
								</Narrative>
								<Narrative>
									<Description><xsl:value-of select="narr3"/></Description>
								</Narrative>								
							</Narratives>							
							<Discounts>
								<Discount>
									<Indicator><xsl:value-of select="deal1indc"/></Indicator>
									<Percentage><xsl:value-of select="deal1perc"/></Percentage>
									<Value><xsl:value-of select="deal1amt"/></Value>
								</Discount>
								<Discount>
									<Indicator><xsl:value-of select="deal2indc"/></Indicator>
									<Percentage><xsl:value-of select="deal2perc"/></Percentage>
									<Value><xsl:value-of select="deal2amt"/></Value>
								</Discount>
							</Discounts>
						</Item>
					</xsl:for-each>
				</Items>
			</Claim>
		</Claims>
		<Products>
			<xsl:apply-templates select="//rootnode/smmessage/claimline"/>	
		</Products>
		<PastOrders/>
	</Doc>
</xsl:template>

<xsl:template match="claimline">
	<Prod>
		<ProdItemNo><xsl:value-of select="position()"/></ProdItemNo>
		<Barcode><xsl:value-of select="prodean"/></Barcode>
		<SuppItemNo><xsl:value-of select="prodcode"/></SuppItemNo>
		<ItemDesc><xsl:value-of select="proddescr"/></ItemDesc>
	</Prod>
</xsl:template>
</xsl:stylesheet>