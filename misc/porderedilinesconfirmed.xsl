<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
   <xsl:template match="/">
     <p></p>
     <table style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
      <tr bgColor="#ccccc2">
        <td title="Items present in Original Order and Confirmation" style="font:12pt Arial" COLSPAN="14"><xsl:entity-ref name="nbsp" /><STRONG>Confirmed Items (Present in original order and confirmation)</STRONG></td>
      </tr>
      <tr bgColor="#ccccc2">
        <td align="center"><i>Seq<br>No</br></i></td>
        <td><i>Consumer Barcode<br>Order Barcode</br>Supp Prod Code</i></td>
        <td><i>Description</i></td>
        <td><i>Order<br>Qty</br></i></td>
        <td><i>Confirm<br>Qty</br></i></td>
        <td><i>Store<br>Pack</br></i></td>
        <td><i>Vendor<br>Pack</br></i></td>
        <td><i>List<br>Cost</br></i></td>
        <td><i>Confirm<br>Cost</br></i></td>
        <td><i>Dea1 1<br>Deal 3</br>Deal 5</i></td>
        <td><i>Deal 2<br>Deal 4</br>Deal 6</i></td>
        <td><i>Discount<br>Calculation</br>Method</i></td>
        <td><i>Order<br>Value</br></i></td>
        <td><i>Confirm<br>Value</br></i></td>
      </tr>


    <xsl:for-each select="//OLD[@status='Confirmed']">
      <tr>
      <td align="center" valign="middle" title="Sequence items was ordered in originally"><xsl:value-of select="@id"/></td>
        <xsl:apply-templates select="PROC"/>
        <xsl:apply-templates select="QNTO"/>
        <xsl:apply-templates select="COST"/>
        <xsl:apply-templates select="CRAD"/>
        <xsl:apply-templates select="DCMD"/>
        <xsl:apply-templates select="NELC"/>
        <xsl:apply-templates select="NELCC"/>
        <xsl:apply-templates select="NARR"/>
      </tr> 
    </xsl:for-each>
    </table>
    <p></p>
  </xsl:template>  
  
  <xsl:template match="PROC">
    <td align="left" valign="middle" title="Product Barcodes and Supplier Code">
       <xsl:value-of select="EANC"/>
    <br><xsl:value-of select="EANC2"/></br>
    <xsl:value-of select="SUPC"/></td>
    <td align="left" valign="middle" title="Description of Product"><xsl:value-of select="PROD"/></td>
  </xsl:template>

  <xsl:template match="QNTO">
    <td align="right" valign="middle" title="Number of Store Packs Ordered"><xsl:value-of select="NROU"/></td>
    <td align="right" valign="middle" title="Quantity confirmed by Supplier (Packs)">
       <xsl:attribute name="bgcolor">
       <xsl:choose>
         <xsl:when test=".[NROU $lt$ NROUC or NROU $gt$ NROUC]">red</xsl:when>
         <xsl:otherwise>#006633</xsl:otherwise>
       </xsl:choose>
       </xsl:attribute>
       <P style="COLOR: white"><xsl:value-of select="NROUC"/></P>
    </td>
    <td align="right" valign="middle" title="Number of Consumer Units in Store Pack"><xsl:value-of select="CONU"/></td>
    <td align="right" valign="middle" title="Number of Consumer Units in Vendor Pack">
      <xsl:choose>
        <xsl:when test="TMEA[. > ' ']"><xsl:value-of select="TMEA"/></xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>
        

  <xsl:template match="COST">
    <td align="right" valign="middle" title="List Cost per Store Pack before Discounts before VAT"><xsl:apply-templates select="COSP"/></td>
    <td align="right" valign="middle" title="List Cost per Pack as Confirmed by Supplier"><xsl:attribute name="bgcolor">
    <xsl:choose>
      <xsl:when test=".[COSP $lt$ COSPC or COSP $gt$ COSPC]">red</xsl:when>
      <xsl:otherwise>#006633</xsl:otherwise>
    </xsl:choose>
    </xsl:attribute>
    <P style="COLOR: white"><xsl:apply-templates select="COSPC"/></P>
    </td>
  </xsl:template>
  
  <xsl:template match="COSP">
    <xsl:eval>formatNumber(this.nodeTypedValue, "R0.0000")</xsl:eval>
  </xsl:template>
  
  <xsl:template match="COSPC">
    <xsl:if test=".[. > ' ']"><xsl:eval>formatNumber(this.nodeTypedValue, "R0.0000")</xsl:eval></xsl:if>
  </xsl:template>

  <xsl:template match="CRAD">
    <td align="left" valign="top" title="Discounts or Deals">
      <xsl:choose>
        <xsl:when test="ADJI1[. > ' ']"><xsl:choose>
            <xsl:when test="PERC1[. > '0']"><xsl:value-of select="ADJI1"/>=<xsl:value-of select="PERC1"/>% </xsl:when>
            <xsl:when test="VALU1[. > '0']"><xsl:value-of select="ADJI1"/>=R<xsl:value-of select="VALU1"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI1C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC1C[. > '0']">(<font color="red"><xsl:value-of select="ADJI1C"/>=<xsl:value-of select="PERC1C"/>%</font>)</xsl:when>
            <xsl:when test="VALU1C[. > '0']">(<font color="red"><xsl:value-of select="ADJI1C"/>=R<xsl:value-of select="VALU1C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    
      <br>   
      <xsl:choose>
        <xsl:when test="ADJI3[. > ' ']"><xsl:choose>
            <xsl:when test="PERC3[. > '0']"><xsl:value-of select="ADJI3"/>=<xsl:value-of select="PERC3"/>% </xsl:when>
            <xsl:when test="VALU3[. > '0']"><xsl:value-of select="ADJI3"/>=R<xsl:value-of select="VALU3"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI3C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC3C[. > '0']">(<font color="red"><xsl:value-of select="ADJI3C"/>=<xsl:value-of select="PERC3C"/>%</font>)</xsl:when>
            <xsl:when test="VALU3C[. > '0']">(<font color="red"><xsl:value-of select="ADJI3C"/>=R<xsl:value-of select="VALU3C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      </br>
      <xsl:choose>
        <xsl:when test="ADJI5[. > ' ']"><xsl:choose>
            <xsl:when test="PERC5[. > '0']"><xsl:value-of select="ADJI5"/>=<xsl:value-of select="PERC5"/>% </xsl:when>
            <xsl:when test="VALU5[. > '0']"><xsl:value-of select="ADJI5"/>=R<xsl:value-of select="VALU5"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI5C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC5C[. > '0']">(<font color="red"><xsl:value-of select="ADJI5C"/>=<xsl:value-of select="PERC5C"/>%</font>)</xsl:when>
            <xsl:when test="VALU5C[. > '0']">(<font color="red"><xsl:value-of select="ADJI5C"/>=R<xsl:value-of select="VALU5C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

    </td>
    
    <td align="left" valign="top" title="Discounts or Deals">
      <xsl:choose>
        <xsl:when test="ADJI2[. > ' ']"><xsl:choose>
            <xsl:when test="PERC2[. > '0']"><xsl:value-of select="ADJI2"/>=<xsl:value-of select="PERC2"/>% </xsl:when>
            <xsl:when test="VALU2[. > '0']"><xsl:value-of select="ADJI2"/>=R<xsl:value-of select="VALU2"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI2C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC2C[. > '0']">(<font color="red"><xsl:value-of select="ADJI2C"/>=<xsl:value-of select="PERC2C"/>%</font>)</xsl:when>
            <xsl:when test="VALU2C[. > '0']">(<font color="red"><xsl:value-of select="ADJI2C"/>=R<xsl:value-of select="VALU2C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

    
      <br>   
      <xsl:choose>
        <xsl:when test="ADJI4[. > ' ']"><xsl:choose>
            <xsl:when test="PERC4[. > '0']"><xsl:value-of select="ADJI4"/>=<xsl:value-of select="PERC4"/>% </xsl:when>
            <xsl:when test="VALU4[. > '0']"><xsl:value-of select="ADJI4"/>=R<xsl:value-of select="VALU4"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI4C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC4C[. > '0']">(<font color="red"><xsl:value-of select="ADJI4C"/>=<xsl:value-of select="PERC4C"/>%</font>)</xsl:when>
            <xsl:when test="VALU4C[. > '0']">(<font color="red"><xsl:value-of select="ADJI4C"/>=R<xsl:value-of select="VALU4C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      </br>
      <xsl:choose>
        <xsl:when test="ADJI6[. > ' ']"><xsl:choose>
            <xsl:when test="PERC6[. > '0']"><xsl:value-of select="ADJI6"/>=<xsl:value-of select="PERC6"/>% </xsl:when>
            <xsl:when test="VALU6[. > '0']"><xsl:value-of select="ADJI6"/>=R<xsl:value-of select="VALU6"/></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="ADJI6C[. > ' ']"><xsl:choose>
            <xsl:when test="PERC6C[. > '0']">(<font color="red"><xsl:value-of select="ADJI6C"/>=<xsl:value-of select="PERC6C"/>%</font>)</xsl:when>
            <xsl:when test="VALU6C[. > '0']">(<font color="red"><xsl:value-of select="ADJI6C"/>=R<xsl:value-of select="VALU6C"/></font>)</xsl:when>
	</xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

    </td>
    
  </xsl:template>
  
  <xsl:template match="DCMD">
    <td align="left" valign="middle" title="Either Simple or Compound">
      <xsl:choose>
        <xsl:when test=".[. = 'C']">Compound</xsl:when>
        <xsl:when test=".[. = 'S']">Simple</xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>  

  <xsl:template match="NARR">
    <xsl:if test=".[. > ' ']"><tr><td align="left"  colspan="14" bgcolor="red"><P style="COLOR: white"><em> Supplier Comments: </em><xsl:value-of select="." /></P></td></tr></xsl:if>
  </xsl:template>  

  <xsl:template match="NELC">
    <td align="right" title="Line Cost after discounts/deals before VAT"><xsl:eval>formatNumber(this.nodeTypedValue, "R0.0000")</xsl:eval></td>
  </xsl:template>  

  <xsl:template match="NELCC">
	<td align="right" title="Line Cost as confirmed by Supplier"><xsl:attribute name="bgcolor"  title="Line Cost as indicated by supplier after discounts/deals before VAT">
      <xsl:choose>
        <xsl:when test=".[../NELC = . ]">#006633</xsl:when>
        <xsl:otherwise>red</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test=".[. > ' ']"><P style="COLOR: white"><xsl:eval>formatNumber(this.nodeTypedValue, "R0.0000")</xsl:eval></P></xsl:if>
    </td>
  </xsl:template>  
 </xsl:stylesheet>
  
