<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	<xsl:template match="/" xml:space="preserve">
		<br/><br/>
		<table border="0" cellpadding="2" cellspacing="2" width="150%">
			<tr>
				<td class="bheader" align="left" valign="top">Claim Status Management</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
