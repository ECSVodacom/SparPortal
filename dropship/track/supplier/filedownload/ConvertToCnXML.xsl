<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<Doc>
		<CreditNotes>
			<CreditNote>
				<Vendor ID="{//rootnode/smmessage/supplierean}"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Vendor>			
				<CreditNoteNumber><xsl:value-of select ="//rootnode/smmessage/cnnumber"/></CreditNoteNumber>
				<CreditNoteDate><xsl:value-of select ="//rootnode/smmessage/cndate"/></CreditNoteDate>
				<TotalCostExcl><xsl:value-of select ="//rootnode/smmessage/totexcl"/></TotalCostExcl>
				<TotalVat><xsl:value-of select ="//rootnode/smmessage/vat"/></TotalVat>
				<TotalCostIncl><xsl:value-of select ="//rootnode/smmessage/totIncl"/></TotalCostIncl>				
				<Depot ID="0"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Depot>
				<Credits>
					<Credit>
						<Indicator><xsl:value-of select="//rootnode/smmessage/tradeindc1"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/tradeperc1"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/tradeamt1"/></Value>
					</Credit>
					<Credit>
						<Indicator><xsl:value-of select="//rootnode/smmessage/tradeindc2"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/tradeperc2"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/tradeamt2"/></Value>
					</Credit>
				</Credits>
				<Debits>
					<Debit>
						<Indicator><xsl:value-of select="//rootnode/smmessage/transportindc"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/transportperc"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/transportamt"/></Value>
					</Debit>
					<Debit>
						<Indicator><xsl:value-of select="//rootnode/smmessage/dutyindc"/></Indicator>
						<Percentage><xsl:value-of select="//rootnode/smmessage/dutyperc"/></Percentage>
						<Value><xsl:value-of select="//rootnode/smmessage/dutyamt"/></Value>
					</Debit>
				</Debits>
				<References>
					<ClaimNo><xsl:value-of select ="//rootnode/smmessage/claim/claimnum"/></ClaimNo>
					<ClaimDate><xsl:value-of select ="//rootnode/smmessage/claim/cliamdate"/></ClaimDate>					
					<ClaimType><xsl:value-of select ="//rootnode/smmessage/claim/claimtype"/></ClaimType>
					<InvoiceNo><xsl:value-of select ="//rootnode/smmessage/claim/invnum"/></InvoiceNo>
					<InvoiceDate><xsl:value-of select="//rootnode/smmessage/claim/invdate"/></InvoiceDate>
						<Items>
						<xsl:for-each select="//smmessage/claim/claimline">
							<Item>
								<ItemNum><xsl:value-of select="position()"/></ItemNum>
								<Qty><xsl:value-of select="qty"/></Qty>
								<CostPer><xsl:value-of select="unitprice"/></CostPer>
								<CostUnitMeasure><xsl:value-of select="totmeasure"/></CostUnitMeasure>
								<GrossCst><xsl:value-of select="grossprice"/></GrossCst>
								<Vat><xsl:value-of select="vatperc"/></Vat>
								<VatAmt><xsl:value-of select="vatamt"/></VatAmt>
								<NetPrice><xsl:value-of select="netprice"/></NetPrice>
								<ReasonDescr><xsl:value-of select="reasondescr"/></ReasonDescr>
								<GoodsReturnDescr><xsl:value-of select="goodsdescr"/></GoodsReturnDescr>
								<Narratives>
									<Narrative>
										<Description><xsl:value-of select="narr"/></Description>
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
				</References>
			</CreditNote>
		</CreditNotes>
		<Products>
			<xsl:apply-templates select="//rootnode/smmessage/claim/claimline"/>	
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