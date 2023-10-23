<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="no" encoding="UTF-16" media-type="text/xml"/>
<xsl:decimal-format name="staff" digit="D" />
<!--<xsl:strip-space elements="*"/>-->
<xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
<xsl:template match="/">
	<creditnoteMessage>
	<supplierAccountingPoint>
		<EANLocationNumber><xsl:value-of select="rootnode/smmessage/supplierean"/></EANLocationNumber>
		<VATRegistrationNumber><xsl:value-of select="rootnode/smmessage/suppliervatno"/></VATRegistrationNumber>
	</supplierAccountingPoint>
	<supplierDispatchPoint>
		<EANLocationNumber>0000000000000</EANLocationNumber>
		<dispatchPointAddress>
			<addressLine1/>
			<addressLine2/>
			<addressLine3/>
			<addressLine4/>
		</dispatchPointAddress>
	</supplierDispatchPoint>
	<customerLocation>
		<deliveryOrInvoicePoint><xsl:value-of select="rootnode/smmessage/storeean"/></deliveryOrInvoicePoint>
		<deliveryPointName><xsl:value-of select="rootnode/smmessage/dcean"/></deliveryPointName>
		<orderPoint/>
		<deliveryPointAddress>
			<addressLine1/>
			<addressLine2/>
			<addressLine3/>
			<addressLine4/>
		</deliveryPointAddress>
		<alternativeInvoicePoint><xsl:value-of select="rootnode/smmessage/dcean"/></alternativeInvoicePoint>
	</customerLocation>
	<references>
		<reference>
			<number><xsl:value-of select="rootnode/smmessage/cnnum"/></number>
			<date>
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="rootnode/smmessage/cndate"/>
						<xsl:with-param name="replace" select="'/'"/>
						<xsl:with-param name="with" select="''"/>
					 </xsl:call-template>
			</date>
		</reference>
		<contractDeal>
			<customerDealNumber/>
			<specialDealIndicator/>
			<supplierDealNumber/>
			<contractType/>
			<whereNegotiated/>
			<supplierRepresentative/>
			<customerRepresentative/>
		</contractDeal>
	</references>
	<creditnoteReferences>
		<lineSequenceNumber>1</lineSequenceNumber>
		<documentReference>
			<number><xsl:value-of select="rootnode/smmessage/claimtype"/></number>
			<date>
				<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="rootnode/smmessage/claimdate"/>
						<xsl:with-param name="replace" select="'/'"/>
						<xsl:with-param name="with" select="''"/>
				 </xsl:call-template>
			</date>
			<type></type>
		</documentReference>
		<reason>
			<reasonCode/>
			<goodsReturnCode/>
		</reason>
	</creditnoteReferences>
	<creditnoteReferences>
		<lineSequenceNumber>1</lineSequenceNumber>
		<documentReference>
			<number><xsl:value-of select="rootnode/smmessage/claimnumber"/></number>
			<date>
				<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="rootnode/smmessage/claimdate"/>
						<xsl:with-param name="replace" select="'/'"/>
						<xsl:with-param name="with" select="''"/>
				 </xsl:call-template>
			</date>
			<type><xsl:value-of select="rootnode/smmessage/claimtype"/></type>
		</documentReference>
		<reason>
			<reasonCode/>
			<goodsReturnCode/>
		</reason>
	</creditnoteReferences>
	<creditnoteReferences>
		<lineSequenceNumber>1</lineSequenceNumber>
		<documentReference>
			<number><xsl:value-of select="rootnode/smmessage/invoicenum"/></number>
			<date>
				<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="rootnode/smmessage/invoicedate"/>
						<xsl:with-param name="replace" select="'/'"/>
						<xsl:with-param name="with" select="''"/>
				 </xsl:call-template>
			</date>
			<type/>
		</documentReference>
		<reason>
			<reasonCode/>
			<goodsReturnCode/>
		</reason>
	</creditnoteReferences>
	<creditnoteReferences>
		<lineSequenceNumber>1</lineSequenceNumber>
		<documentReference>
			<number><xsl:value-of select="rootnode/smmessage/manualnum"/></number>
			<date>
				<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="rootnode/smmessage/manualdate"/>
						<xsl:with-param name="replace" select="'/'"/>
						<xsl:with-param name="with" select="''"/>
				 </xsl:call-template>
			</date>
			<type/>
		</documentReference>
		<reason>
			<reasonCode/>
			<goodsReturnCode/>
		</reason>
	</creditnoteReferences>
	<xsl:apply-templates select="rootnode/smmessage/claimline"/>
	<summaryDetail>
		<totMeasure/>
		<totNumOfPackages/>
	</summaryDetail>
	<messageTrailer>
		<numberOfSegments/>
		<referenceNumber><xsl:value-of select="rootnode/smmessage/cnnum"/></referenceNumber>
	</messageTrailer>
</creditnoteMessage>
</xsl:template>

<xsl:template match="claimline">
	<creditnoteLines>
		<lineSequenceNumber><xsl:value-of select="position()"/></lineSequenceNumber>
		<reason>
			<reasonCode><xsl:value-of select="reasoncode"/></reasonCode>
			<goodsReturnCode><xsl:value-of select="goodscode"/></goodsReturnCode>
		</reason>
		<netExtendedLineCostExcl><xsl:value-of select="subtot"/></netExtendedLineCostExcl>
		<vatRatePercentage><xsl:value-of select="vatperc"/></vatRatePercentage>
		<vatRateCode>Z</vatRateCode>
		<discountMethod/>
		<claimLineSequence/>
		<invoiceLineSequence/>
		<productDetail>
			<consumerEANNumber></consumerEANNumber>
			<orderEANNumber><xsl:value-of select="prodean"/></orderEANNumber>
			<supplierProductCode><xsl:value-of select="prodcode"/></supplierProductCode>
			<description><xsl:value-of select="proddescr"/></description>
			<qualifiers>
				<style/>
				<colour/>
				<size/>
			</qualifiers>
		</productDetail>
		<quantityDetail>
			<numberOfUnits><xsl:value-of select="qty"/></numberOfUnits>
			<consumerUnit></consumerUnit>
			<looseConumerUnit/>
			<totalMeasure/>
			<unitOfMeasure><xsl:value-of select="totmeasure"/></unitOfMeasure>
		</quantityDetail>
		<priceDetail>
			<costPrice><xsl:value-of select="unitprice"/></costPrice>
			<consumerUnit/>
			<unitOfMeasure/>
		</priceDetail>
		<creditAdjustment1>
			<indicator1/>
			<percentageValue1><xsl:value-of select="deal1perc"/></percentageValue1>
			<randValue1><xsl:value-of select="deal1amt"/></randValue1>
		</creditAdjustment1>
		<costPriceDebit>
			<costPrice/>
			<consumerUnitsCostPrice/>
			<unitOfMeasure/>
		</costPriceDebit>
		<creditAdjustment2>
			<indicator2/>
			<percentageValue2><xsl:value-of select="deal2perc"/></percentageValue2>
			<randValue2><xsl:value-of select="deal2perc"/></randValue2>
		</creditAdjustment2>
		<contractDeal>
			<customerDealNumber/>
			<specialDealIndicator/>
			<supplierDealNumber/>
			<contractType/>
			<whereNegotiated/>
			<supplierRepresentative/>
			<customerRepresentative/>
		</contractDeal>
		<NarrativeDetail>
			<narrative/>
		</NarrativeDetail>
		<invoiceLineSequenceNumber/>
		<vateRateSubTrailer>
			<lineSequenceNumber/>
			<vatRatePercentage><xsl:value-of select="vatperc"/></vatRatePercentage>
			<vateRateCode>Z</vateRateCode>
			<numLineItems/>
			<lineSubTotAmountExlc><xsl:value-of select="subtot"/></lineSubTotAmountExlc>
			<vatAmount/>
			<creditAdjustment>
				<indicator/>
				<percentageValue/>
				<randValue/>
			</creditAdjustment>
			<debitAdjustment>
				<indicator/>
				<percentageValue/>
				<randValue/>
			</debitAdjustment>
			<extendedSubTotAmtExcl><xsl:value-of select="subtot"/></extendedSubTotAmtExcl>
			<subTotSettleDiscount/>
		</vateRateSubTrailer>
		<documentTrailer>
			<linesNetTotCostExcl><xsl:value-of select="subtot"/></linesNetTotCostExcl>
			<totVatAmount/>
			<totAmtPayableIncl/>
			<totMeasure/>
			<totNumOfPackages/>
		</documentTrailer>
	</creditnoteLines>
</xsl:template>
</xsl:stylesheet>