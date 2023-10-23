<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <xsl:template match="/">
STORE NAME&#09;SUPPLIER NAME&#09;CREDITNOTENO&#09;CCREDITNOTE DATE&#09;DISCPERC1&#09;DISCPERC2&#09;TRANSFERPERC&#09;DUTYPERC&#09;TOTAL COST
<xsl:value-of select="//rootnode/smmessage/storename"/>&#09;<xsl:value-of select="//rootnode/smmessage/suppliername"/>&#09;<xsl:value-of select="//rootnode/smmessage/cnnumber"/>&#09;<xsl:value-of select="//rootnode/smmessage/cndate"/>&#09;<xsl:value-of select="//rootnode/smmessage/tradeperc1"/>&#09;<xsl:value-of select="//rootnode/smmessage/tradeperc2"/>&#09;<xsl:value-of select="//rootnode/smmessage/transportperc"/>&#09;<xsl:value-of select="//rootnode/smmessage/dutyperc"/>&#09;<xsl:value-of select="//rootnode/smmessage/totIncl"/>&#09;

CLAIM NO&#09;CLAIM DATE&#09;CLAIM TYPE&#09;INVOICE NO&#09;INVOICE DATE
<xsl:value-of select="//rootnode/smmessage/claim/claimnum"/>&#09;<xsl:value-of select="//rootnode/smmessage/claim/cliamdate"/>&#09;<xsl:value-of select="//rootnode/smmessage/claim/claimtype"/>&#09;<xsl:value-of select="//rootnode/smmessage/claim/invnum"/>&#09;<xsl:value-of select="//rootnode/smmessage/claim/invdate"/>&#09;
  
PRODUCT DESCRIPTION&#09;PRODUCT CODE / ITEM CODE&#09;QUANTITY&#09;DEALPERC1&#09;DEALPERC2&#09;UNIT COST&#09;LINE COST&#09;REASON DESCR&#09;GOODS RETURN DESCR
<xsl:for-each select="//rootnode/smmessage/claim/claimline">
<xsl:value-of select="proddescr"/>&#09;<xsl:value-of select="prodcode"/>&#09;<xsl:value-of select="qty"/>&#09;<xsl:value-of select="deal1perc"/>&#09;<xsl:value-of select="deal2perc"/>&#09;<xsl:value-of select="unitprice"/>&#09;<xsl:value-of select="subtot"/>&#09;<xsl:value-of select="reasondescr"/>&#09;<xsl:value-of select="goodsdescr"/>
   </xsl:for-each>       
  </xsl:template>
</xsl:stylesheet>