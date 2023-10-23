<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-16"/>
<xsl:decimal-format name="staff" digit="D" />
<xsl:template match="/" xml:space="preserve">
	<Doc>
		<Orders>
			<Order>
				<xsl:apply-templates select="//DOCUMENT/UNB/UNH"/>
			</Order>
		</Orders>
		<Products>
			<xsl:apply-templates select="//DOCUMENT/UNB/UNH/OLD"/>	
		</Products>
		<PastOrders/>
	</Doc>
</xsl:template>

<xsl:template match="UNH">
			<Vendor ID="{concat(substring(//DOCUMENT/UNB/UNH/SOP/SOPT,4,4),substring(//DOCUMENT/UNB/UNH/SOP/SOPT,12,2))}"><xsl:value-of select ="//DOCUMENT/UNB/Receiver/ReceiverName"/></Vendor>			
			<OrderNo><xsl:value-of select ="ORD/ORNO/ORNU"/></OrderNo>
			<Depot ID="0"><xsl:value-of select ="//DOCUMENT/UNB/Receiver/ReceiverName"/></Depot>
			<OrderDate><xsl:value-of select="concat(substring(ORD/ORNO/DATE, 5, 2),  '/', substring(ORD/ORNO/DATE, 3, 2), '/20', substring(ORD/ORNO/DATE, 1, 2))"/></OrderDate>
			<DropDate/>
			<OrderCode>N</OrderCode>
			<Buyer/>
			<Dept/>
			<SubDept/>
			<OrderDetails>
				<Destins>
					<Destin>
						<DestID></DestID>
						<DestDesc><xsl:value-of select ="//DOCUMENT/UNB/Sender/SenderName"/></DestDesc>
						<DestEAN><xsl:value-of select ="CLO/CDPT"/></DestEAN>
						<Items>
							<xsl:for-each select="OLD">
								<Item>
									<ItemNum><xsl:value-of select="@id"/></ItemNum>
									<Qty>
										<xsl:choose>
											<xsl:when test="//DOCUMENT/UNB/UNH/SOP/SOPT='6001206428890'">
												<xsl:value-of select="QNTO/NROU"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="(QNTO/NROU) div (QNTO/TMEA)"/>
											</xsl:otherwise>
										</xsl:choose>
									</Qty>
									<ContractNo>@@FileName</ContractNo>
									<CostPer/>
									<CostUnitMeasure/>
									<GrossCst><xsl:value-of select="COST/COSP"/></GrossCst>
									<ExtendCst/>
									<FreeStock><xsl:value-of select="FREE/NROU"/></FreeStock>
									<FreeOrdBase><xsl:value-of select="FREE/CONU"/></FreeOrdBase>
									<FreeOrdQty><xsl:value-of select="FREE/NROU"/></FreeOrdQty>
									<DelInstr1/>
									<DelInstr2/>
									<ExpDelDate/>
									<Discounts/>
								</Item>
							</xsl:for-each>
						</Items>
					</Destin>
				</Destins>
			</OrderDetails>
</xsl:template>

<xsl:template match="CRAD">
			<Discount>
				<Indicator1><xsl:value-of select="ADJI1"/></Indicator1>
				<Percentage1><xsl:value-of select="PERC1"/></Percentage1>
				<Value1><xsl:value-of select="VALU1"/></Value1>
				<Indicator2><xsl:value-of select="ADJI2"/></Indicator2>
				<Percentage2><xsl:value-of select="PERC2"/></Percentage2>
				<Value2><xsl:value-of select="VALU2"/></Value2>
			</Discount>
</xsl:template>

<xsl:template match="OLD">
	<Prod>
		<ProdItemNo><xsl:value-of select="@id"/></ProdItemNo>
		<Barcode><xsl:value-of select="PROC/EANC"/></Barcode>
		<SuppItemNo><xsl:value-of select="PROC/SUPC"/></SuppItemNo>
		<ItemDesc><xsl:value-of select="PROC/PROD"/></ItemDesc>
		<ItemPackSize>
			<xsl:choose>
				<xsl:when test="//DOCUMENT/UNB/UNH/SOP/SOPT='6001206428890'">
					<xsl:value-of select="(QNTO/CONU)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(QNTO/CONU) * (QNTO/TMEA)"/>
				</xsl:otherwise>
			</xsl:choose>
		</ItemPackSize>
		<WHOrderInd/>
	</Prod>
</xsl:template>

</xsl:stylesheet>