<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#include file="../includes/makeorders.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->

<%
										if Session("IsLoggedIn") <> 1 Then
											Session("IsLoggedIn") = 0
										end if
%>
<script language="javascript">
<!--
	if (<%=Session("IsLoggedIn")%> != 1) {
		top.location.href = "<%=const_app_ApplicationRoot%>";
	};
//-->
</script>
<%						
										dim SQL
										dim curConnection
										dim XMLString
										dim XMLDoc
										dim XSLDoc
										dim CNID
										dim DisplaySet
										dim strAddr
										dim dispAddr
										dim Count
										dim IsXML
										dim ClaimLine
										dim CmLineCount
										dim GrossPrice
										dim NetTot
										dim GrossTot
										dim Deal1
										dim Deal2
										dim Vat
										dim GrossTotPrice
										dim GrossTotDealAmt1
										dim GrossTotDealAmt2
										dim SubNetTot
										dim SubTotVat
										dim SubTotAmt
										dim ListLine
										dim LineCount
										dim TotExcl
										dim TotVat
										dim TotIncl
										dim Trade1Perc
										dim Trade1Amt
										dim AvgVat
										dim Trade1Vat
										dim Trade1Incl
										dim Trade2Perc
										dim Trade2Amt
										dim Trade2Vat
										dim Trade2Incl
										dim ExtendTotExcl
										dim ExtendTotVat
										dim ExtendTotIncl
										dim TransExcl
										dim TransVat
										dim TransIncl
										dim DutyExcl
										dim DutyVat
										dim DutyIncl
										dim NetExtendTotExcl
										dim NetExtendTotVat
										dim NetExtendTotIncl
										
										
										if Request.QueryString("item") = "" then
											CNID = 0
										else
											CNID = Request.QueryString("item")
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Biuld the SQL Statement for orders
										SQL = "exec itemCreditNoteClaim @CCID=" & CNID
											
										'Response.Write SQL & "<br>"
										'response.end
										
										' Call the streaming function
										XMLString = XMLRequest(SQL, "", "" ,false)
										
										'Response.Write XMLString
										'Response.End
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										
										if Request.QueryString("type") = "copy"  Or Request.QueryString("amp;type") = "copy" then
											XSLDoc.Load(Server.MapPath("printcopy.xsl"))
										else
											XSLDoc.Load(Server.MapPath("item.xsl"))
										end if
										
										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Get the Supplier Address address
										strAddr = split(XMLDoc.selectSingleNode("//rootnode/smmessage/supplieraddr").text,",")
										
										' Loop through the address
										For Count = 0 to UBound(strAddr)
											dispAddr = dispAddr & strAddr(Count) & "<br>"
										Next

										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@User",Session("FirstName"))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)

%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validatePrint(obj) {
		if ((obj.hidSupplierVatNo.value=='') || (obj.hidStoreVatNo=='')) {
			window.alert('We are unable to process the request to allow you to print the Tax Copy as one of the vat numbers are not supplied.');
			//obj.hidSupplierVatNo.focus()
		} else {
			window.open('<%=const_app_ApplicationRoot%>/track/store/creditnote/item.asp?item=<%=CNID%>&amp;type=copy','PrintCopyDetail', 'width=800,height=500,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');
		}
	}
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="if ('<%=Request.QueryString("amp;type")%>'=='copy') { window.print(); };">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
