<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
	<xsl:template match="/">
PRODUCT DESCRIPTION|STORENAME|PRODUCT CODE / SUPPLIER CODE|ORDERNO|DELIVERY DATE|QUANTITY|UNIT COST|LINE COST
		<xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
			<xsl:value-of select="PROC/PROD"/>|<xsl:value-of select="/DOCUMENT/UNB/UNH/CLO/CDPN"/>|<xsl:value-of select="PROC/EANC"/>/<xsl:value-of select="PROC/EANC2"/>|<xsl:value-of select="/DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/>|<xsl:value-of select="/DOCUMENT/UNB/UNH/DIN/EDAT"/>|<xsl:value-of select="QNTO/NROU"/>|<xsl:value-of select="COST/COSP"/>|<xsl:value-of select="NELC"/>
		</xsl:for-each>       
	</xsl:template>
</xsl:stylesheet>