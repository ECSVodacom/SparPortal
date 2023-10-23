<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <xsl:template match="/">
PRODUCT DESCRIPTION&#09;STORENAME&#09;PRODUCT CODE / ITEM CODE&#09;ORDERNO&#09;DELIVERY DATE&#09;QUANTITY&#09;UNIT COST&#09;LINE COST
<xsl:for-each select="//rootnode/smmessage/invline">
<xsl:value-of select="proddescr"/>&#09;<xsl:value-of select="//rootnode/smmessage/storename"/>&#09;<xsl:value-of select="barcode"/>/<xsl:value-of select="prodcode"/>&#09;<xsl:value-of select="//rootnode/smmessage/ordernumber"/>&#09;<xsl:value-of select="//rootnode/smmessage/delivdate"/>&#09;<xsl:value-of select="qty"/>&#09;<xsl:value-of select="linecost"/>&#09;<xsl:value-of select="nettcost"/>
   </xsl:for-each>       
  </xsl:template>
</xsl:stylesheet>