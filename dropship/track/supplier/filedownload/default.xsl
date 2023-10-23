<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="staff" digit="D" />
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<xsl:choose>
		<xsl:when test="//rootnode/smmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
					<td class="iheader" align="left">@@DownloadType DOWNLOADS&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
				</tr>
				<tr>
					<td class="pcontent" colspan="2"><b>ERROR:</b><br/>
						<xsl:value-of select="//rootnode/smmessage/errormessage"/><br/><br/>
					</td>
				</tr>
				<tr>
					<td class="pcontent" align="center" colspan="2"><b>[<a class="stextnav" href="javascript:window.close ();">Close this Window</a>]</b></td>
				</tr>
			</table>
		</xsl:when>
		<xsl:otherwise>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td><img src="@@ApplicationRoot/layout/images/sparlogo.gif"/></td>
					<td class="iheader" align="left">@@DownloadType DOWNLOADS&#160;&#160;&#160;&#160;&#160;&#160;&#160;</td>
				</tr>
			</table><br/>
			<form name="printform" id="printform">
				<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#333366">
					<tr>
							<td class="pcontent" colspan="2">Click on the <b>Download File</b> button to download the file to your personal computer <b>OR</b><br/>
								Click inside the text area below, copy the text and paste it into another document on your personal computer <b>OR</b><br/>
								Click on the <b>Print Text</b> button to print the selected text. 
							</td>
					</tr>
					<tr>
						<td colspan="2" align="right"><input type="button" name="btnDownload" id="btnDownload" value="Download File" class="button" onclick="window.location.href='@@FilePath'"/>&#160;
							<input type="button" name="btnPrint" id="btnPrint" value="Print Text" class="button" onclick="detail.focus(); detail.print();"/>&#160;
							<input type="button" name="btnBack" id="btnBack" value="   Back   " class="button" onclick="javascript:history.back();"/>
						
						</td>
					</tr>
					<tr>
						<td class="pcontent"><iframe name="detail" src="@@ApplicationRoot/track/supplier/filedownload/loadiframe.asp?id=@@loadfile" height="400" width="600"></iframe></td>
					</tr>
				</table>
			</form>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>