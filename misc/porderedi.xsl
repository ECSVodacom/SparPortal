<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
<xsl:template match="/">
  <HTML>

  <SCRIPT LANGUAGE="JavaScript" FOR="window" EVENT="onload">
    loadDoc();
  </SCRIPT>


  <SCRIPT LANGUAGE="JavaScript">
    var xmlDocOriginal = new ActiveXObject("Msxml2.DOMDocument");
    xmlDocOriginal.async = false;
    var xmlfile = new String(window.location);
    var filelen = xmlfile.length;
    var lastpos = xmlfile.indexOf("porder");
    xmlfile = xmlfile.substring(lastpos,filelen);
    xmlDocOriginal.load(xmlfile);

    var xslFilter = new ActiveXObject("Msxml2.DOMDocument");
    xslFilter.async = false;
    //xslFilter.load("http://InterLinx.destiny-ec.com/xmltemp/porderedifilter.xsl");
    xslFilter.load("porderedifilter.xsl");

    var xslOrderLinesConfirmed = new ActiveXObject("Msxml2.DOMDocument");
    xslOrderLinesConfirmed.async = false;
    //xslOrderLinesConfirmed.load("http://InterLinx.destiny-ec.com/xmltemp/porderedilinesconfirmed.xsl");
    xslOrderLinesConfirmed.load("porderedilinesconfirmed.xsl");

    var xslOrderLinesUnconfirmed = new ActiveXObject("Msxml2.DOMDocument");
    xslOrderLinesUnconfirmed.async = false;
    //xslOrderLinesConfirmed.load("http://InterLinx.destiny-ec.com/xmltemp/porderedilinesunconfirmed.xsl");
    xslOrderLinesUnconfirmed.load("porderedilinesunconfirmed.xsl");

    var xslOrderLinesNew = new ActiveXObject("Msxml2.DOMDocument");
    xslOrderLinesNew.async = false;
    //xslOrderLinesConfirmed.load("http://InterLinx.destiny-ec.com/xmltemp/porderedilinesnew.xsl");
    xslOrderLinesNew.load("porderedilinesnew.xsl");


    var xmlOrderLines = new ActiveXObject("Msxml2.DOMDocument");
    xmlOrderLines.async = false;
    xmlOrderLines.validateOnParse = true;


    function buildXMLOrderLinesNoFilter()
    {
      if (convertlst.value == 0)
      {
        matchField.value = 'ZZZZ[. = \'\']';  //Nothing would match this
        qtyTestField.value = '.[NROU $lt$ NROUCV or NROU $gt$ NROUCV]';
        qtySelectField.value = 'NROUCV';
        cstTestField.value = '.[COSP $lt$ COSPCV or COSP $gt$ COSPCV]';
        cstMatchField.value = 'COSPCV';
        cstSelectField.value = 'COSPCV'; 
      }
      if (convertlst.value == 1)
      {
        matchField.value = 'ZZZZ[. = \'\']';  //Nothing would match this
        qtyTestField.value = '.[NROU $lt$ NROUC or NROU $gt$ NROUC]';
        qtySelectField.value = 'NROUC';
        cstTestField.value = '.[COSP $lt$ COSPC or COSP $gt$ COSPC]';
        cstMatchField.value = 'COSPC';
        cstSelectField.value = 'COSPC'; 
      }
    }

    function loadDoc()
    {
      var state = xmlDocOriginal.readyState;
      if (state == "4")
      {
        matchField = xslFilter.selectNodes("//@match").item(0); // the first match attribute in the stylesheet
        qtyTestField = xslOrderLinesConfirmed.selectNodes("//@test").item(0);
	qtySelectField = xslOrderLinesConfirmed.selectNodes("//@select").item(15);
        cstTestField = xslOrderLinesConfirmed.selectNodes("//@test").item(2);
	cstMatchField = xslOrderLinesConfirmed.selectNodes("//@match").item(5);
        cstSelectField = xslOrderLinesConfirmed.selectNodes("//@select").item(19);

	//alert(cstTestField.value);
	//alert(cstSelectField.value);
        sortlst.value = 4;
        convertlst.value = 0;
        origlst.value = 0;
        change_sortlst();
      }
      else
      {
        window.setTimeout("loadDoc()",4000)
      }
    }

    function change_sortlst()
    {
      //alert("changed");
      window.alert (sortlist.value);
      return false;
      if (sortlst.value == 0)
      {
        //Select any items with exceptions
        if (convertlst.value == 0)
        {
          matchField.value = '//OLD[QNTO/NROU = QNTO/NROUCV and COST/COSP = COST/COSPCV and NARR = \'\']';
          qtyTestField.value = '.[NROU $lt$ NROUCV or NROU $gt$ NROUCV]';
          qtySelectField.value = 'NROUCV';
          cstTestField.value = '.[COSP $lt$ COSPCV or COSP $gt$ COSPCV]';
          cstMatchField.value = 'COSPCV';
          cstSelectField.value = 'COSPCV';

        }
        if (convertlst.value == 1)
        {
          matchField.value = '//OLD[QNTO/NROU = QNTO/NROUC and COST/COSP = COST/COSPC and NARR = \'\']';
          qtyTestField.value = '.[NROU $lt$ NROUC or NROU $gt$ NROUC]';
          qtySelectField.value = 'NROUC';
          cstTestField.value = '.[COSP $lt$ COSPC or COSP $gt$ COSPC]';
          cstMatchField.value = 'COSPC';
          cstSelectField.value = 'COSPC';
        }
      }

      if (sortlst.value == 1)
      {
        //Select items with quantity exceptions
        if (convertlst.value == 0)
        {
          matchField.value = '//OLD[QNTO/NROU = QNTO/NROUCV]';
          qtyTestField.value = '.[NROU $lt$ NROUCV or NROU $gt$ NROUCV]';
          qtySelectField.value = 'NROUCV';
        }
        if (convertlst.value == 1)
        {
          matchField.value = '//OLD[QNTO/NROU = QNTO/NROUC]';
          qtyTestField.value = '.[NROU $lt$ NROUC or NROU $gt$ NROUC]';
          qtySelectField.value = 'NROUC';
        }
      }
      if (sortlst.value == 2)
      {
        if (convertlst.value == 0)
        {
          matchField.value = '//OLD[COST/COSP = COST/COSPCV]';
          cstTestField.value = '.[COSP $lt$ COSPCV or COSP $gt$ COSPCV]';
          cstMatchField.value = 'COSPCV';
          cstSelectField.value = 'COSPCV';
        }
        if (convertlst.value == 1)
        {
          matchField.value = '//OLD[COST/COSP = COST/COSPC]';
          cstTestField.value = '.[COSP $lt$ COSPC or COSP $gt$ COSPC]';
          cstMatchField.value = 'COSPC';
          cstSelectField.value = 'COSPC';

        }
      }
      if (sortlst.value == 3)
      {
        //Select items with supplier comments

        matchField.value = '//OLD[NARR = \'\']';
      }

      if (sortlst.value == 4)
      {
        //Show All Items
        buildXMLOrderLinesNoFilter();
      }
      orderlinesconfirmed.style.display="none";
      orderlinesunconfirmed.style.display="none";
      orderlinesnew.style.display="none";
      xmlDocOriginal.transformNodeToObject(xslFilter, xmlOrderLines);
      if (origlst.value == 0)
      {
        orderlinesconfirmed.style.display="block";
        orderlinesunconfirmed.style.display="block";
        orderlinesnew.style.display="block";
        orderlinesconfirmed.innerHTML = xmlOrderLines.transformNode(xslOrderLinesConfirmed);
        buildXMLOrderLinesNoFilter();
        xmlDocOriginal.transformNodeToObject(xslFilter, xmlOrderLines);
        orderlinesunconfirmed.innerHTML = xmlOrderLines.transformNode(xslOrderLinesUnconfirmed);
        orderlinesnew.innerHTML = xmlOrderLines.transformNode(xslOrderLinesNew);
      }
      if (origlst.value == 1)
      {
        orderlinesconfirmed.style.display="block";
        orderlinesconfirmed.innerHTML = xmlOrderLines.transformNode(xslOrderLinesConfirmed);
      }
      if (origlst.value == 2)
      {
        xmlDocOriginal.transformNodeToObject(xslFilter, xmlOrderLines);
        buildXMLOrderLinesNoFilter();
        orderlinesunconfirmed.style.display="block";
        orderlinesunconfirmed.innerHTML = xmlOrderLines.transformNode(xslOrderLinesUnconfirmed);
      }
      if (origlst.value == 3)
      {
        xmlDocOriginal.transformNodeToObject(xslFilter, xmlOrderLines);
        buildXMLOrderLinesNoFilter();
        orderlinesnew.style.display="block";
        orderlinesnew.innerHTML = xmlOrderLines.transformNode(xslOrderLinesNew);
      }

      //xmldata.innerText = xmlDocOriginalNew.xml;
    }


  </SCRIPT>

  <STYLE>
       TD {font-size:8pt}
       PRE {font-size:8pt}
  </STYLE>
  <body STYLE="font:8pt Arial"  background="bg.jpe">
   <table border="1" borderColor="#ccccc2" cellPadding="10" cellSpacing="10" width="100%">
    <table border="0" cellPadding="2" cellSpacing="2" width="100%">
    <tr>
       <td width="50%" align="left"><img src="logo1.gif"></img></td>
       <td>
       <table width="100%" align="right" valign="middle">
       <tr>
       <xsl:value-of select="DOCUMENT/UNB/Sender/SenderReg"/>
       </tr>
       <tr>
       <xsl:value-of select="DOCUMENT/UNB/Sender/SenderAddress"/>
       </tr>
       <tr>
       <xsl:value-of select="DOCUMENT/UNB/Sender/SenderTel"/>
       </tr>
       <tr>
       VAT Reg.No. <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR2"/>
       </tr>
       </table>
       </td>
      </tr>
    </table>
    <table border="0" cellPadding="3" cellSpacing="0" width="100%">
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverID"/></td>
       <td width="33%" VALIGN = "TOP">Delivery Instructions:</td>
       <td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/NARR1"/></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/Receiver/ReceiverAddress"/></td>
       <td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
       <td width="33%" VALIGN = "TOP">PO NR: <xsl:value-of select="DOCUMENT/UNB/UNH/ORD/ORNO/ORNU"/></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP">DELIVERY DATE:<xsl:value-of select="DOCUMENT/UNB/UNH/DIN/EDAT"/></td>
       <td width="33%" VALIGN = "TOP"><xsl:apply-templates select="DOCUMENT/UNB/APRF"/><xsl:entity-ref name="nbsp" /><xsl:apply-templates select="DOCUMENT/UNB/SOURCEREFNUMBER"/></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP">RAIL TO SIDING <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
     </table>
     </table>

        <table border="1" align="center" cellPadding="4" cellSpacing="0" width="100%" bgColor="#ccccc2">
          <tr> 
            <td align="left">
              <select id="sortlst" name="sortlst" LANGUAGE="javascript" onchange="change_sortlst ()">
                          <option value="0">Show All Items with Exceptions</option>
                          <option value="1">Show Only Items with Quantity Exceptions</option>
                          <option value="2">Show Only Items with Price Exceptions</option>
                          <option value="3">Show Only Items with Supplier Comments</option>
                          <option value="4">Show All Items</option>
              </select>
              <select id="convertlst" name="convertlst" LANGUAGE="javascript" onchange="change_sortlst ()">
                          <option value="0">Supplier Confirms in Vendor Packs</option>
                          <option value="1">Supplier Confirms in Store Packs</option>
              </select>
              <select id="origlst" name="origlst" LANGUAGE="javascript" onchange="change_sortlst ()">
                          <option value="0">Show Confirmed, Unconfirmed and New Items</option>
                          <option value="1">Show Confirmed Items Only</option>
                          <option value="2">Show Unconfirmed Items Only</option>
                          <option value="3">Show New Items Only</option>
              </select>
            </td>
          </tr>
        </table>
     <div id="orderlinesconfirmed" STYLE="display:none"></div>
     <div id="orderlinesunconfirmed"  STYLE="display:none"></div>
     <div id="orderlinesnew"  STYLE="display:none"></div>

  </body>
  </HTML>

</xsl:template>
<xsl:template match="DOCUMENT/UNB/APRF">
  <xsl:choose>
    <xsl:when test=".[. = 'TAXINV']">SOURCE TAX INVOICE</xsl:when>
    <xsl:when test=".[. = 'TAXCPY']">SOURCE COPY TAX INVOICE</xsl:when>
    <xsl:when test=".[. = 'INVOIC']">SOURCE INVOICE</xsl:when>
    <xsl:when test=".[. = 'ORDERS']">SOURCE COPY ORDER</xsl:when>
    <xsl:otherwise>DOCUMENT SOURCE UNKNOWN</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="DOCUMENT/UNB/SOURCEREFNUMBER">
  <xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>

