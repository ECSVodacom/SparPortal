<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->

<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
			
										dim SQL
										dim curConnection
										dim XMLString
										dim XMLDoc
										dim XSLDoc
										dim InvoiceID
										dim DisplaySet
										dim Trade1TotExcl
										dim Trade1TotVat
										dim Trade1TotIncl
										dim Trade2TotExcl
										dim Trade2TotVat
										dim Trade2TotIncl
										dim AddTotExcl
										dim AddTotVat
										dim AddTotIncl
										dim LineItems
										dim LineCount
										dim SubTotExcl
										dim SubTotVat
										dim SubTotIncl
										dim TransTotExl
										dim TransTotVat
										dim TransTotIncl
										dim DutTotExl
										dim DutTotVat
										dim DutTotIncl
										dim SetTotExl
										dim SetTotVat
										dim SetTotIncl
										dim NettTotExcl
										dim NettTotVat
										dim NettTotIncl
										dim strAddr
										dim dispAddr
										dim Count
										dim Success
										dim TotNetCost
										
										if Request.QueryString("success") <> "1" or IsNull(Request.QueryString("success"))then
											Success = "0"
										else
											Success = Request.QueryString("success")
										end if
										
										if Request.QueryString("item") = "" then
											InvoiceID = 0
										else
											InvoiceID = Request.QueryString("item")
										end if

										' Biuld the SQL Statement for orders
										SQL = "exec itemInvoice_New @InvoiceID=" & InvoiceID
										'Response.write(SQL)
										
										' Call the streaming function
										XMLString = XMLRequest(SQL, "", "" ,false)

										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										XSLDoc.Load(Server.MapPath("list.xsl"))

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Calc the Trade 1 total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/trade1perc").text) <> "" Then
										   Trade1TotExcl = Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotexcl").text)) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/trade1perc").text / 100)
											Trade1TotVat = Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotvat").text)) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/trade1perc").text) / 100
											Trade1TotIncl = CDbl(Trade1TotExcl) + CDbl(Trade1TotVat)
										else
											Trade1TotExcl = "0.00"
											Trade1TotVat = "0.00"
											Trade1TotIncl = "0.00"
										end if

										' Calc the Trade 2 total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/trade2perc").text) <> "" Then
										   Trade2TotExcl = (Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotexcl").text)) - Trade1TotExcl) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/trade2perc").text / 100)
											Trade2TotVat = (Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotvat").text)) - Trade1TotVat) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/trade2perc").text) / 100
											Trade2TotIncl = CDbl(Trade2TotExcl) + CDbl(Trade2TotVat)
										else
											Trade1TotExcl = "0.00"
											Trade1TotVat = "0.00"
											Trade1TotIncl = "0.00"
										end if
										
										' Calc the Additional Discount total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/additionalperc").text) <> "" Then
										   AddTotExcl = (Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotexcl").text)) - Trade1TotExcl - Trade2TotExcl) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/additionalperc").text / 100)
											AddTotVat = (Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotvat").text)) - Trade1TotVat - Trade2TotVat) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/additionalperc").text) / 100
											AddTotIncl = CDbl(AddTotExcl) + CDbl(AddTotVat)
										else
											AddTotExcl = "0.00"
											AddTotVat = "0.00"
											AddTotIncl = "0.00"
										end if
										
										' Get the list of lines
										Set LineItems = XMLDoc.selectNodes("//rootnode/smmessage/invline")
										
										' Loop through the Line Items
										For LineCount = 0 to LineItems.Length-1
											TotNetCost = TotNetCost + CDbl(LineItems.item(LineCount).selectSingleNode("nettcost").text)
											SubTotIncl = SubTotIncl + CDbl(LineItems.item(LineCount).selectSingleNode("total").text)
										Next

										' Calc the Sub Totals
										SubTotExcl = Trim(CDbl(TotNetCost)) - Trade1TotExcl - Trade2TotExcl - AddTotExcl
										SubTotVat =  Trim(CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/subtotvat").text)) - Trade1TotVat - Trade2TotVat - AddTotVat

										' Now add the Sub Total Exl
										SubTotIncl = SubTotIncl - Trade1TotIncl - Trade2TotIncl - AddTotIncl

										' Calc the Transport cost total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/transperc").text) <> "" Then
											TransTotExl = SubTotExcl * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/transperc").text / 100)
											TransTotVat = SubTotVat * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/transperc").text) / 100
											TransTotIncl = CDbl(TransTotExl) + CDbl(TransTotVat)
										else
											TransTotExl = "0.00"
											TransTotVat = "0.00"
											TransTotIncl = "0.00"
										end if
										
										' Calc the Duties & Levies total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/dutlevperc").text) <> "" Then
											DutTotExl = (SubTotExcl + TransTotExl) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/dutlevperc").text) / 100
											DutTotVat = (SubTotVat + TransTotVat) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/dutlevperc").text) / 100
											DutTotIncl = CDbl(DutTotExl) + CDbl(DutTotIncl)
										else
											DutTotExl = "0.00"
											DutTotVat = "0.00"
											DutTotIncl = "0.00"
										end if
										
										' Calc the Settlement discount total vats
										if Trim(XMLDoc.selectSingleNode("//rootnode/smmessage/setdiscperc").text) <> "" Then
											SetTotExl = CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/grandtotexcl").text) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/setdiscperc").text) / 100
											SetTotVat = CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/grandtotvat").text) * CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/setdiscperc").text) / 100
											SetTotIncl = CDbl(SetTotExl) + CDbl(SetTotVat)
										else
											SetTotExl = "0.00"
											SetTotVat = "0.00"
											SetTotIncl = "0.00"
										end if
										
										NettTotExcl = CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/grandtotexcl").text) - SetTotExl
										NettTotVat = CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/grandtotvat").text) - SetTotVat
										NettTotIncl = CDbl(XMLDoc.selectSingleNode("//rootnode/smmessage/grandtotincl").text) - SetTotIncl
										
										' Get the Supplier Address address
										strAddr = split(XMLDoc.selectSingleNode("//rootnode/smmessage/supplieraddress").text,",")
										
										' Loop through the address
										For Count = 0 to UBound(strAddr)
											dispAddr = dispAddr & strAddr(Count) & "<br>"
										Next
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@User",Session("FirstName"))
										'DisplaySet = Replace(DisplaySet,"@@InvDate",FormatDateTime(XMLDoc.selectSingleNode("//rootnode/smmessage/invoicedate").text,1))
										DisplaySet = Replace(DisplaySet,"@@TotNettCost",FormatNumber(Round(TotNetCost,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade1TotExcl",FormatNumber(Round(Trade1TotExcl,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade1TotVat",FormatNumber(Round(Trade1TotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade1TotIncl",FormatNumber(Round(Trade1TotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade2TotExcl",FormatNumber(Round(Trade2TotExcl,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade2TotVat",FormatNumber(Round(Trade2TotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@Trade2TotIncl",FormatNumber(Round(Trade2TotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@AddTotExcl",FormatNumber(Round(AddTotExcl,2),2))
										DisplaySet = Replace(DisplaySet,"@@AddTotVat",FormatNumber(Round(AddTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@AddTotIncl",FormatNumber(Round(AddTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@SubTotExl",FormatNumber(Round(SubTotExcl,2),2))
										DisplaySet = Replace(DisplaySet,"@@SubTotVat",FormatNumber(Round(SubTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@SubTotIncl",FormatNumber(Round(SubTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@TransTotExl",FormatNumber(Round(TransTotExl,2),2))
										DisplaySet = Replace(DisplaySet,"@@TransTotVat",FormatNumber(Round(TransTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@TransTotIncl",FormatNumber(Round(TransTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@DutTotExl",FormatNumber(Round(DutTotExl,2),2))
										DisplaySet = Replace(DisplaySet,"@@DutTotVat",FormatNumber(Round(DutTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@DutTotIncl",FormatNumber(Round(DutTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@SetTotExl",FormatNumber(Round(SetTotExl,2),2))
										DisplaySet = Replace(DisplaySet,"@@SetTotVat",FormatNumber(Round(SetTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@SetTotIncl",FormatNumber(Round(SetTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@NettTotExcl",FormatNumber(Round(NettTotExcl,2),2))
										DisplaySet = Replace(DisplaySet,"@@NettTotVat",FormatNumber(Round(NettTotVat,2),2))
										DisplaySet = Replace(DisplaySet,"@@NettTotIncl",FormatNumber(Round(NettTotIncl,2),2))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)
										DisplaySet = Replace(DisplaySet,"@@InvID",InvoiceID)
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<!--#include file="../../../layout/headclose.asp"-->
<script language="javascript">
<!--
	function check (Success, Login) {
		if (Login != 1) {
			top.location.href = "<%=const_app_ApplicationRoot%>";
		};
	
		if (Success == '1') {
			window.alert ('The Invoice was successfully saved and sent through to the selected store.');
		};
	};
//-->
</script>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="check (<%=Success%>,<%=Session("IsLoggedIn")%>);">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
