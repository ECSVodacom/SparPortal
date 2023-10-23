<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<Doc>
		<Invoices>
			<Invoice>
				<Vendor ID="{//rootnode/smmessage/supplierean}"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Vendor>			
				<InvoiceNo><xsl:value-of select ="//rootnode/smmessage/invoicenumber"/></InvoiceNo>
				<OrderNo><xsl:value-of select ="//rootnode/smmessage/ordernumber"/></OrderNo>
				<Depot ID="0"><xsl:value-of select ="//rootnode/smmessage/suppliername"/></Depot>
				<InvoiceDate><xsl:value-of select="//rootnode/smmessage/receivedate"/></InvoiceDate>
				<OrderDate><xsl:value-of select="//rootnode/smmessage/receivedate"/></OrderDate>
				<DropDate><xsl:value-of select="//rootnode/smmessage/delivdate"/></DropDate>
				<OrderCode>N</OrderCode>
				<Buyer/>
				<Dept/>
				<SubDept/>
				<InvoiceDetails>
					<Destins>
						<Destin>
							<DestID><xsl:value-of select ="//rootnode/smmessage/storecode"/></DestID>
							<DestDesc><xsl:value-of select ="//rootnode/smmessage/storename"/></DestDesc>
							<DestEAN><xsl:value-of select ="//rootnode/smmessage/storerean"/></DestEAN>
							<Items>
								<xsl:for-each select="//smmessage/invline">
									<Item>
										<ItemNum><xsl:value-of select="position()"/></ItemNum>
										<Qty><xsl:value-of select="qty"/></Qty>
										<ContractNo/>
										<CostPer><xsl:value-of select="linecost"/></CostPer>
										<CostUnitMeasure/>
										<GrossCst><xsl:value-of select="nettcost"/></GrossCst>
										<Vat><xsl:value-of select="vat"/></Vat>
										<ExtendCst/>
										<FreeStock></FreeStock>
										<FreeOrdBase></FreeOrdBase>
										<FreeOrdQty><xsl:value-of select="free"/></FreeOrdQty>
										<DelInstr1/>
										<DelInstr2/>
										<ExpDelDate/>
										<Discounts>
											<Discount>
												<Indicator1>T1</Indicator1>
												<Percentage1><xsl:value-of select="deal1perc"/></Percentage1>
												<Value1><xsl:value-of select="deal1rand"/></Value1>
												<Indicator2>T2</Indicator2>
												<Percentage2><xsl:value-of select="deal2perc"/></Percentage2>
												<Value2><xsl:value-of select="deal2rand"/></Value2>
											</Discount>
										</Discounts>
									</Item>
								</xsl:for-each>
							</Items>
						</Destin>
					</Destins>
				</InvoiceDetails>
			</Invoice>
		</Invoices>
		<Products>
			<xsl:apply-templates select="//rootnode/smmessage/invline"/>	
		</Products>
		<PastOrders/>
	</Doc>
</xsl:template>

<xsl:template match="invline">
	<Prod>
		<ProdItemNo><xsl:value-of select="position()"/></ProdItemNo>
		<Barcode><xsl:value-of select="barcode"/></Barcode>
		<SuppItemNo><xsl:value-of select="prodcode"/></SuppItemNo>
		<ItemDesc><xsl:value-of select="proddescr"/></ItemDesc>
		<ItemPackSize><xsl:value-of select="supplpack"/></ItemPackSize>
		<WHOrderInd/>
	</Prod>
</xsl:template>
</xsl:stylesheet>