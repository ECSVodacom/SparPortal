<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<Doc>
		<Orders>
			<Order>
				<Vendor ID="{//smmessage/supplierean}"><xsl:value-of select ="//smmessage/suppliername"/></Vendor>			
				<OrderNo><xsl:value-of select ="//smmessage/ordernumber"/></OrderNo>
				<Depot ID="0"><xsl:value-of select ="//smmessage/suppliername"/></Depot>
				<OrderDate><xsl:value-of select="//smmessage/receivedate"/></OrderDate>
				<DropDate><xsl:value-of select="//smmessage/delivdate"/></DropDate>
				<OrderCode>N</OrderCode>
				<Buyer/>
				<Dept/>
				<SubDept/>
				<OrderDetails>
					<Destins>
						<Destin>
							<DestID><xsl:value-of select ="//smmessage/storecode"/></DestID>
							<DestDesc><xsl:value-of select ="//smmessage/storename"/></DestDesc>
							<DestEAN><xsl:value-of select ="//smmessage/storerean"/></DestEAN>
							<Items>
								<xsl:for-each select="//smmessage/ordline">
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
												<Percentage1/>
												<Value1><xsl:value-of select="deal1"/></Value1>
												<Indicator2>T2</Indicator2>
												<Percentage2/>
												<Value2><xsl:value-of select="deal2"/></Value2>
											</Discount>
										</Discounts>
									</Item>
								</xsl:for-each>
							</Items>
						</Destin>
					</Destins>
				</OrderDetails>
			</Order>
		</Orders>
		<Products>
			<xsl:apply-templates select="//smmessage/ordline"/>	
		</Products>
		<PastOrders/>
	</Doc>
</xsl:template>

<xsl:template match="ordline">
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