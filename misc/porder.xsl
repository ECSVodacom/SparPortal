<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
<xsl:template match="/">
  <html>

  <SCRIPT LANGUAGE="JavaScript" FOR="window" EVENT="onload">
    loadDoc();
  </SCRIPT>


  <SCRIPT LANGUAGE="JavaScript">
    var xmlDoc = new ActiveXObject("Msxml2.DOMDocument");
    //xmlDoc.load("porder.xml");

    var xmlfile = new String(window.location);
    var filelen = xmlfile.length;
    var lastpos = xmlfile.indexOf("porder");
    xmlfile = xmlfile.substring(lastpos,filelen);
    xmlDoc.load(xmlfile);

    //load for saving as "Msxml2.DOMDocument"
    var xslSaveAs = new ActiveXObject("Msxml2.DOMDocument");
    xslSaveAs.async = false;           
    xslSaveAs.load("http://InterLinx.destiny-ec.com/xmltemp/tabdel.xsl");

    //load for saving as with heading
    var xslSaveAsHeading = new ActiveXObject("Msxml2.DOMDocument");
    xslSaveAsHeading.async = false;           
    xslSaveAsHeading.load("http://InterLinx.destiny-ec.com/xmltemp/tabdelhead.xsl");

    function loadDoc()
    {
      if(xmlDoc.readyState == "4")
       start()
      else
       window.setTimeout("loadDoc()",4000)
    }


    function start()
    {
     var rootElem = xmlDoc.documentElement;
    }


    function changeIT()
    {
     objList = xmlDoc.selectNodes("DOCUMENT/UNB/UNH/OLD/"+event.srcElement.fieldname);           
     objList.item(event.srcElement.id-1).text = event.srcElement.value;
     //alert(objList.item(event.srcElement.id-1).text);
    }

    function send_onclick()
    {
     var rootElem = xmlDoc.documentElement.previousSibling;
     objNewPI = xmlDoc.createProcessingInstruction('xml-stylesheet','type="text/xsl" href="porder.xsl"');
     xmlDoc.replaceChild(objNewPI,rootElem);
     //alert(xmlDoc.xml);
    
     var fso = new ActiveXObject("Scripting.FileSystemObject");
     var snrf = xmlDoc.getElementsByTagName("SNRF");
     var name = snrf.item(0).text + ".xml" ;
     var path = "C:\\Saved Files\\" + name;
     var count = 1;

     while (count != 0)
     {
       if (fso.FileExists(path))
       {
          path = "C:\\Saved Files\\" + snrf.item(0).text +  "_" + count + ".xml";
          count = count + 1;
       }
       else
       {
          count = 0;
       }
     }  


     var wf = fso.CreateTextFile(path, true);
     wf.WriteLine(xmlDoc.xml);
     wf.Close();
     
     var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
     //xmlhttp.Open("POST", "http://laetitia/Xml/receive.asp", false);
     xmlhttp.Open("POST", "http://Interlinx.destiny-ec.com/xmltemp/receive.asp", false);
     xmlhttp.Send(xmlDoc);
     alert("Message saved and send");
     //return xmlhttp.responseXML;
     //update.submit();
          
    }
   
    function saveas_onclick()
    {
     var rootElem = xmlDoc.documentElement.previousSibling;
     objNewPI = xmlDoc.createProcessingInstruction('xml-stylesheet','type="text/xsl" href="porder.xsl"');
     xmlDoc.replaceChild(objNewPI,rootElem);
    
     //To write or append file
     var fso = new ActiveXObject("Scripting.FileSystemObject");
     var d,s ;
     d = new Date();
     s = "";
     s += d.getYear() + "_";
     s += (d.getMonth()+1) + "_";
     s += d.getDate();
  
     var filename = "C:\\Saved Files\\" + s + ".ord";
     //alert (filename);
     //To prompt for filename
     var path = window.prompt("FileName and Path for Tab Delimited file:",filename);
     
     if (fso.FileExists(path))
     {
       // 8 ForAppending
       wf = fso.OpenTextFile(path, 8,false);
       strTransform = xmlDoc.transformNode(xslSaveAs);
       //alert(strTransform);
       wf.WriteLine(strTransform);
       wf.Close();
     }
     else
     {
       var wf = fso.CreateTextFile(path, true);
       //To format txt to look as stylesheet
       strTransform = xmlDoc.transformNode(xslSaveAsHeading);
       //alert (strTransform);
       wf.WriteLine(strTransform);
       wf.Close();
     }

   
    }
     
  </SCRIPT>
  <STYLE>
       TD {font-size:8pt}
  </STYLE>
  <body STYLE="font:8pt Arial" background="http://InterLinx.destiny-ec.com/bg.jpe">
   <!--<form action="http://Interlinx.destiny-ec.com/xmltemp/test.asp" method="post" name="update" -->
   <form action="http://laetitia/Xml/result.asp" method="post" name="update" id="update">
   <table border="1" cellPadding="4" cellSpacing="2" width="100%">
    <table border="0" cellPadding="4" cellSpacing="0" width="100%">
    <tr>
       <td width="50%" align="left"><img src="http://InterLinx.destiny-ec.com/sparlogo.gif"></img></td>
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
    <table border="0" cellPadding="2" cellSpacing="0" width="100%">
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
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP">RAIL TO SIDING <xsl:value-of select="DOCUMENT/UNB/UNH/DIN/RDIN"/></td>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP"><xsl:value-of select="DOCUMENT/UNB/UNH/CLO/CDPN"/></td>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
      <tr>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
       <td width="33%" VALIGN = "TOP"><xsl:entity-ref name="nbsp" /></td>
      </tr>
     </table>
     </table>

     <table  style="font:8pt Arial" border="1" cellPadding="2" cellSpacing="0" width="100%">
      <tr bgColor="#ccccc2">
        <td><i>Consumer Barcode<br>Order Barcode</br>Supp Prod Code</i></td>
        <td><i>Description</i></td>
        <td><i>Order<br>Quantity</br></i></td>
        <td><i>Store<br>Pack</br></i></td>
        <td><i>Vendor<br>Pack</br></i></td>
        <td><i>List<br>Cost</br></i></td>
        <td><i>Dea1 1<br>Deal 3</br>Deal 5</i></td>
        <td><i>Deal 2<br>Deal 4</br>Deal 6</i></td>
        <td><i>Discount<br>Calculation</br>Method</i></td>
        <td><i>Order<br>Value</br></i></td>
      </tr>
      <xsl:for-each select="DOCUMENT/UNB/UNH/OLD">
      <tr>
        <td align="left" valign="top">
             <xsl:value-of select="PROC/EANC"/>
             <br><xsl:value-of select="PROC/EANC2"/></br>
                  <xsl:value-of select="PROC/SUPC"/>
        </td>
        <td align="left" valign="middle"><xsl:value-of select="PROC/PROD"/></td>
        <td><input type="text">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                                                        <xsl:attribute name="size">5</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="QNTO/NROU"/></xsl:attribute>
							<xsl:attribute name="onchange">changeIT()</xsl:attribute>
							<xsl:attribute name="fieldname">QNTO/NROUC</xsl:attribute>
		</input></td>

         <td align="right" valign="middle">
         <xsl:choose>
            <xsl:when test="QNTO/CONU[. > ' ']"> <xsl:value-of select="QNTO/CONU"/></xsl:when>
            <xsl:otherwise><xsl:entity-ref name="nbsp" /></xsl:otherwise>
         </xsl:choose>
         </td>
         <td align="right" valign="middle">
         <xsl:choose>
            <xsl:when test="QNTO/TMEA[. > ' ']"><xsl:value-of select="QNTO/TMEA"/></xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
         </xsl:choose>
        </td>
        <td>
<input type="text">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
                                                        <xsl:attribute name="size">5</xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="COST/COSP"/></xsl:attribute>
							<xsl:attribute name="onchange">changeIT()</xsl:attribute>
							<xsl:attribute name="fieldname">COST/COSPC</xsl:attribute>
						</input></td>
           <td align="left" valign="top">
      <xsl:choose>
        <xsl:when test="CRAD/ADJI1[. > ' ']"><xsl:value-of select="CRAD/ADJI1"/><xsl:choose>
            <xsl:when test="CRAD/PERC1[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC1"/>% </xsl:when>
            <xsl:when test="CRAD/VALU1[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU1"/></xsl:when>
         </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    
      <br>   
      <xsl:choose>
        <xsl:when test="CRAD/ADJI3[. > ' ']"><xsl:value-of select="CRAD/ADJI3"/><xsl:choose>
            <xsl:when test="CRAD/PERC3[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC3"/>% </xsl:when>
            <xsl:when test="CRAD/VALU3[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU3"/> </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      </br>
      <xsl:choose>
        <xsl:when test="CRAD/ADJI5[. > ' ']"><xsl:value-of select="CRAD/ADJI5"/><xsl:choose>
            <xsl:when test="CRAD/PERC5[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC5"/>% </xsl:when>
            <xsl:when test="CRAD/VALU5[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU5"/> </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </td>
    
    <td align="left" valign="top">
      <xsl:choose>
        <xsl:when test="CRAD/ADJI2[. > ' ']"><xsl:value-of select="CRAD/ADJI2"/><xsl:choose>
            <xsl:when test="CRAD/PERC2[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC2"/>% </xsl:when>
            <xsl:when test="CRAD/VALU2[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU2"/> </xsl:when>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    
      <br>   
      <xsl:choose>
        <xsl:when test="CRAD/ADJI4[. > ' ']"><xsl:value-of select="CRAD/ADJI4"/><xsl:choose>
            <xsl:when test="CRAD/PERC4[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC4"/>% </xsl:when>
            <xsl:when test="CRAD/VALU4[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU4"/> </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
      </br>
      <xsl:choose>
        <xsl:when test="CRAD/ADJI6[. > ' ']"><xsl:value-of select="CRAD/ADJI6"/><xsl:choose>
            <xsl:when test="CRAD/PERC6[. != '0000000' $and$ . != '000.0000']">=<xsl:value-of select="CRAD/PERC6"/>% </xsl:when>
            <xsl:when test="CRAD/VALU6[. != '000000000000' $and$ . != '00000000.0000']">=R<xsl:value-of select="CRAD/VALU6"/> </xsl:when>
           </xsl:choose>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </td>
    <td align="left" valign="middle">
      <xsl:choose>
        <xsl:when test="DCMD[. = 'C']">Compound</xsl:when>
        <xsl:when test="DCMD[. = 'S']">Simple</xsl:when>
        <xsl:otherwise>Unknown</xsl:otherwise>
      </xsl:choose>
    </td>
        <td align="right" valign="middle"><xsl:value-of select="NELC"/></td>
      </tr>
      <tr>
        <td><i>Comments: </i></td>
        <td colspan = "13"><input type="text">
							<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
							<xsl:attribute name="value"></xsl:attribute>
                                                        <xsl:attribute name="size">100</xsl:attribute>
							<xsl:attribute name="onchange">changeIT()</xsl:attribute>
							<xsl:attribute name="fieldname">NARR</xsl:attribute>
						</input></td>
     
      </tr>
      <xsl:choose>
        <xsl:when test="FREE/NROU[. > ' ']">
          <tr><td colspan="14" bgcolor="#ffd700"><i>---<xsl:entity-ref name="nbsp" />Free Goods: <xsl:value-of select="FREE/PROD"/>  Qty: <xsl:value-of select="FREE/NROU"/><xsl:entity-ref name="nbsp" />---</i></td></tr>
        </xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>

      </xsl:for-each>
      <tr>
      <td colspan="5"><input type="button" value="Save/Send Message" name="button" LANGUAGE="javascript" onclick="return send_onclick()"></input></td>
      <td colspan="6"><i>This will save an xml file in C:\Saved Files with the changes that will be emailed to buyer</i></td>
      </tr>
      <tr>
      <td colspan="5"><input type="button" value="Save As Message" name="button2" LANGUAGE="javascript" onclick="return saveas_onclick()"></input></td>
      <td colspan="6"><i>This will save a Tab Delimited File</i></td>
      </tr>

    </table>
  </form>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>

