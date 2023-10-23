<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="http://mycompany.com/mynamespace"
  xmlns:dt="urn:schemas-microsoft-com:datatypes">
<xsl:decimal-format name="staff" digit="D" />
	<xsl:output method="html" indent="yes"/>
	
	<msxsl:script language="VBScript" implements-prefix="user">
		<![CDATA[
			
			Dim DCName, SupplierName, StoreName, HeaderName
			DCName = ""
			SupplierName = ""
			StoreName = ""
			HeaderName = ""
			
			Function SetDCName(Name)
				DCName = Name 
				SetDCName = ""
			End Function
			
			Function OrderNumber(Number)
				Dim pos, tmp
				pos = instr(Number,".")
				if pos <> 0 then
					tmp = "0000000000000" & Mid(Number, 1, pos-1)
					OrderNumber = Right(tmp,13)
				else
					OrderNumber = Number
				end if
			End Function
			
			Function GetTotalAmountInclusive(Amount)
			
				GetTotalAmountInclusive = Amount
			End Function
			
			Function GetDCName()
				GetDCName = DCName
			End Function
			
			Function SetSupplierName(Name)
				SupplierName = Name 
				SetSupplierName = ""
			End Function
			
			Function GetSupplierName()
				GetSupplierName = SupplierName
			End Function
			
			Function SetStoreName(Name)
				StoreName = Name 
				SetStoreName = ""
			End Function
			
			Function GetStoreName()
				GetStoreName = StoreName
			End Function
			
			Function SetHeaderName(Name)
				Dim Return
				Return = "!!!@@@!!!"
				If HeaderName <> "" Then
					HeaderName = Name 
					SetHeaderName = "~~~" & Return
				else
					HeaderName = Name 
					SetHeaderName = "" & Return
				End IF
				
				
			End Function
			
			Function GetHeaderName()
				GetHeaderName = HeaderName
			End Function
			
			Function ReplaceDTM(DTM)
				ReplaceDTM = Replace(DTM,"T"," ")
			End Function
		]]>
	</msxsl:script>
	
	<xsl:template match="Rootnode" xml:space="preserve">
		<table border="0" cellpadding="2" cellspacing="2" width="100%">
			<tr>
				<td class="pcontent" align="left" valign="top"><b>@@ReportType</b></td>
			</tr>
		</table>
		
		<xsl:for-each select="rootnode/_x0023_TmpTable2">
			<xsl:choose>
				<xsl:when test="@Header = user:GetHeaderName()">
					<tr><xsl:call-template name="detail" /></tr>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="user:SetHeaderName(string(@Header))"/>
					<tr class="pcontent" align="center" bgcolor="#4c8ed7" >
						<td><font color="#ffffff"><b>DC Name</b></font></td>
						<td><font color="#ffffff"><b>Supplier Name</b></font></td>
						<td><font color="#ffffff"><b>Store Name</b></font></td>
						<td><font color="#ffffff"><b><xsl:value-of select="@Header"/> Number</b></font></td>
						<td><font color="#ffffff"><b>Total Amount Inclusive</b></font></td>
						<td><font color="#ffffff"><b>Received</b></font></td>
					</tr>
					<tr>
						<xsl:value-of select="user:SetDCName('')"/>
						<xsl:value-of select="user:SetSupplierName('')"/>
						<xsl:value-of select="user:SetStoreName('')"/>
						<xsl:call-template name="detail" />
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		~~~ <!-- This is to indicate end of table -->
	</xsl:template>
	<xsl:template name="detail" xml:space="preserve">
		<xsl:choose>
			<xsl:when test="DC/@DCcName = user:GetDCName()">
				<td class="pcontent" align="center" ><xsl:value-of select="DC/@DCcName"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center" bgcolor="#c0c0c0" ><b><xsl:value-of select="DC/@DCcName"/></b>
				<xsl:value-of select="user:SetDCName(string(DC/@DCcName))"/>
				<xsl:value-of select="user:SetSupplierName('')"/>
				<xsl:value-of select="user:SetStoreName('')"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
			
		<xsl:choose>
			<xsl:when test="DC/Store/Supplier/@SPcName = user:GetSupplierName()">
				<td class="pcontent" align="center" ><xsl:value-of select="DC/Store/Supplier/@SPcName"/> (<xsl:value-of select="DC/Store/Supplier/@VendorCode"/>)</td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center" bgcolor="#c0c0c0" ><b><xsl:value-of select="DC/Store/Supplier/@SPcName"/></b>
				<xsl:value-of select="user:SetSupplierName(string(DC/Store/Supplier/@SPcName))"/> <b>(<xsl:value-of select="DC/Store/Supplier/@VendorCode"/>)</b>
				<xsl:value-of select="user:SetStoreName('')"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
			
		<xsl:choose>
			<xsl:when test="DC/Store/@STcName = user:GetStoreName()">
				<td class="pcontent" align="center" ><xsl:value-of select="DC/Store/@STcName"/></td>
			</xsl:when>
			<xsl:otherwise>
				<td class="pcontent" align="center" bgcolor="#c0c0c0" ><b><xsl:value-of select="DC/Store/@STcName"/></b>
				<xsl:value-of select="user:SetStoreName(string(DC/Store/@STcName))"/>
				</td>
			</xsl:otherwise>
		</xsl:choose>
			
		<td class="pcontent" align="center" ><xsl:value-of select="user:OrderNumber(string(@Val))"/></td>
		<td class="pcontent" align="center" ><xsl:value-of select="user:GetTotalAmountInclusive(string(@TotalAmountInclusive))"/></td>
		<td class="pcontent" align="center" ><xsl:value-of select="user:ReplaceDTM(string(@DTM))"/></td>
	</xsl:template>
</xsl:stylesheet>
