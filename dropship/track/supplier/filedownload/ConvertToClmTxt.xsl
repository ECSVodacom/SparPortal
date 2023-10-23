<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <xsl:template match="/">
STORE NAME&#09;SUPPLIER NAME&#09;CLAIMNO&#09;CLAIM DATE&#09;DISCPERC1&#09;DISCPERC2&#09;INV NO&#09;INV DATE&#09;MANUAL NO&#09;MANUAL DATE&#09;REASON CODE&#09;REASON DESCR
<xsl:value-of select="//rootnode/smmessage/storename"/>&#09;<xsl:value-of select="//rootnode/smmessage/suppliername"/>&#09;<xsl:value-of select="//rootnode/smmessage/claimnumber"/>&#09;<xsl:value-of select="//rootnode/smmessage/cliamdate"/>&#09;<xsl:value-of select="//rootnode/smmessage/discperc1"/>&#09;<xsl:value-of select="//rootnode/smmessage/discperc2"/>&#09;<xsl:value-of select="//rootnode/smmessage/invoicenum"/>&#09;<xsl:value-of select="//rootnode/smmessage/invoicedate"/>&#09;<xsl:value-of select="//rootnode/smmessage/manualnum"/>&#09;<xsl:value-of select="//rootnode/smmessage/manualdate"/>&#09;<xsl:value-of select="//rootnode/smmessage/reasoncode"/>&#09;<xsl:value-of select="//rootnode/smmessage/reasondescr"/>
  
PRODUCT DESCRIPTION&#09;PRODUCT CODE / ITEM CODE&#09;LOOSE QUANTITY&#09;WHOLE QUANTITY&#09;DEALPERC1&#09;DEALPERC2&#09;UNIT COST&#09;LINE COST&#09;REASON CODE&#09;REASON DESCR&#09;GOODS RETURN CODE&#09;GOODS RETURN DESCR
<xsl:for-each select="//rootnode/smmessage/claimline">
<xsl:value-of select="proddescr"/>&#09;<xsl:value-of select="prodcode"/>&#09;<xsl:value-of select="looseqty"/>&#09;<xsl:value-of select="wholeqty"/>&#09;<xsl:value-of select="deal1perc"/>&#09;<xsl:value-of select="deal2perc"/>&#09;<xsl:value-of select="unitprice"/>&#09;<xsl:value-of select="subtot"/>&#09;<xsl:value-of select="reasoncode"/>&#09;<xsl:value-of select="reasondescr"/>&#09;<xsl:value-of select="goodscode"/>&#09;<xsl:value-of select="goodsdescr"/>
   </xsl:for-each>       
  </xsl:template>
</xsl:stylesheet>