<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>
<xsl:template match="/" xml:space="preserve">
	<br/><br/>
	<xsl:choose>
		<xsl:when test="rootnode/spmessage/returnvalue!='0'">
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left" valign="top">Claims Tracking Report</td>
				</tr>
				<tr>
					<td class="errortext"><br/><xsl:value-of select="rootnode/spmessage/errormessage"/><br/></td>
				</tr>
				<tr>
					<td class="pcontent">Select another date from the tree menu on the left hand side of this page.</td>
				</tr>
			</table>
		</xsl:when>
		<xsl:otherwise>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td class="bheader" align="left">Claims Tracking Report</td>
				</tr>
				<tr>
					<td class="pcontent"><br/>Claims received per Distribution Centre per Store per Supplier for <b>@@Date</b>.</td>
				</tr>
				<tr>
					<td class="pcontent">
						<ul>
							<li>Click on the <b>Claim Number</b> link to view the Claim.</li>
							<li>Click on the <b>Invoice Number</b> link to view the linked Invoice.</li>							
							<li>Click on the <b>List Credit Notes</b> link to view the linked Credit Notes.</li>							
						</ul>
					</td>
				</tr>
			</table>
			<table border="0" cellpadding="2" cellspacing="2" width="100%">
				 <xsl:apply-templates select="rootnode/spmessage/dc/store/supplier"/>
			</table>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--<xsl:template match="dc">
	<tr>
		<td class="gheader" colspan="12" bgcolor="#333366" width="100%"><xsl:value-of select="name"/>&#160;DC&#160;(<xsl:value-of select="eannumber"/>)</td>
		 <xsl:apply-templates select="store"/>
	</tr>
</xsl:template>

<xsl:template match="store">
	<tr>
		<td class="mheader" colspan="12" bgcolor="#ccccc2">SPAR Store: <xsl:value-of select="name"/></td>
	</tr>
	 <xsl:apply-templates select="supplier"/>
</xsl:template>-->

<xsl:template match="supplier">
	<tr>
		<td class="nheader" colspan="10" bgcolor="#333366">Supplier: <xsl:value-of select="name"/> (<xsl:value-of select="eannumber"/>)</td>
	</tr>
	<tr>
		<td>
      <table border="1" cellpadding="0" cellspacing="0" width="100%">
        <tr>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Claim Number</i>
            </b>
            <br/>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Claim Type</i>
            </b>
            <br/>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Claim Category</i>
            </b>
            <br/>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>File</i>
            </b>
            <br/>
            <b>
              <i>Received</i>
            </b>
            <br/>
            <b>
              <i>by Gateway</i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Translation</i>
            </b>
            <br/>
            <b>
              <i>To</i>
            </b>
            <br/>
            <b>
              <i>EDI or XML</i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Delivery to</i>
            </b>
            <br/>
            <b>
              <i>Mailbox</i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>Extracted by</i>
            </b>
            <br/>
            <b>
              <i>Supplier</i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Manual<br/>Claim Number
              </i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Manual<br/>Claim Date
              </i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Invoice<br/>Number
              </i>
            </b>
          </th>
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Invoice<br/>Date
              </i>
            </b>
          </th>

          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Credit Note<br/>Number
              </i>
            </b>
          </th>
<!--
          <th class="pcontent" align="center" bgcolor="#ccccc2">
            <b>
              <i>
                Credit Note<br/>Date
              </i>
            </b>
          </th>
-->
        </tr>
        <xsl:apply-templates select="claim"/>
      </table>
		</td>
	</tr>
</xsl:template>

  <xsl:template match="claim">
    <tr>
		<td class="pcontent" align="center">
		<a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/claim/default.asp?item={@id}', 'ClaimDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
		<xsl:value-of select="claimnumber"/>
		</a>
		</td>
		<td class="pcontent" align="center">
			<xsl:value-of select="claimtype"/>
		</td>
		<td class="pcontent" align="center">
			<xsl:choose>
				<xsl:when test="claimcategory!=''">
					<xsl:value-of select="claimcategory"/>		
				</xsl:when>
				<xsl:otherwise>
					-
				</xsl:otherwise>
			</xsl:choose>
		</td>
	  
	  <!--<td class="pcontent" align="center">
        <xsl:choose>
		<xsl:when test="reasoncode[.='SD']">Quantity</xsl:when>
          <xsl:when test="claimtype[.='DFC'] and reasoncode[.='GR']">Quantity</xsl:when>
          <xsl:when test="claimtype[.='RFC'] and reasoncode[.='GR']">Returns</xsl:when>
          <xsl:when test="reasoncode[.='PD' or .='DD' or .='DR' or .='RB' or .='DU']">Pricing</xsl:when>
          <xsl:when test="reasoncode[.='RC']">Returns (Crates)</xsl:when>
		  <xsl:when test="reasoncode[.='UN']">Unknown</xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
      </td>-->
      <td class="pcontent" align="center">
        <xsl:value-of select="receiveddate"/><br/>[<xsl:value-of select="receivedtime"/>]
      </td>
      <td class="pcontent" align="center">
        <xsl:value-of select="transdate"/><br/>[<xsl:value-of select="transtime"/>]
      </td>
      <td class="pcontent" align="center">
        <xsl:value-of select="transdate"/><br/>[<xsl:value-of select="transtime"/>]
      </td>
      <xsl:choose>
        <xsl:when test="extractdate!=''">
          <td class="pcontent" align="center">
            <xsl:value-of select="extractdate"/><br/>[<xsl:value-of select="extracttime"/>]
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="pcontent" align="center">-</td>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="manualnum!=''">
          <td class="pcontent" align="center">
            <xsl:value-of select="manualnum"/>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="pcontent" align="center">-</td>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="manualdate!=''">
          <td class="pcontent" align="center">
            <xsl:value-of select="manualdate"/>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="pcontent" align="center">-</td>
        </xsl:otherwise>
      </xsl:choose>
      <td class="pcontent" align="center">
        <xsl:choose>
          <xsl:when test="invnum!=''">
            <xsl:choose>
              <xsl:when test="invid!=''">
                <a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/invoice/default.asp?item={invid}', 'InvoiceDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
                  <xsl:value-of select="invnum"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="invnum"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            -
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="pcontent" align="center">
        <xsl:choose>
          <xsl:when test="invdate!=''">
            <xsl:value-of select="invdate"/>
          </xsl:when>
          <xsl:otherwise>
            -
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="pcontent" align="center">
        <xsl:choose>
          <xsl:when test="cnnum!=''">
            <xsl:choose>
              <xsl:when test="cnid!=''">
                <a class="links" href="JavaScript: newWindow = openWin('@@ApplicationRoot/track/dc/creditnote/default.asp?item={cnid}', 'CNDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');">
                  <xsl:value-of select="cnnum"/>
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="cnnum"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            -
          </xsl:otherwise>
        </xsl:choose>
      </td>
	 <!--
      <td class="pcontent" align="center">
        <xsl:choose>
          <xsl:when test="cndate!=''">
            <xsl:value-of select="cndate"/>
          </xsl:when>
          <xsl:otherwise>
            -
          </xsl:otherwise>
        </xsl:choose>
      </td>
-->
    </tr>
  </xsl:template>
</xsl:stylesheet>