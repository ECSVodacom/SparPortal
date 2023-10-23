<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#virtual include="../../../includes/adovbs.inc"-->
<%
										dim SQL
										dim curConnection
										dim XMLString
										dim XMLDoc
										dim XSLDoc
										dim OrderID
										dim DisplaySet
										dim strAddr
										dim dispAddr
										dim Count
										dim IsXML
										dim strXMLHead
										dim StoreAddr
										dim ACount
										dim strSAddr
										dim LCount
										dim strXMLLine
										dim strCrad
										dim strDrad
										dim NetConsum
										dim VrsCount
										dim VrsVal
										dim VCount
										dim VrsArray()
										dim CCount
										dim FCount
										dim TCount
										dim ZCount
										dim FExCount
										dim TExCount
										dim ZExCount
										dim FVatCount
										dim TVatCount
										dim ZVatCount
										dim strSettle

										if Request.QueryString("item") = "" then
											OrderID = 0
										else
											OrderID = Request.QueryString("item")
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Biuld the SQL Statement for orders
										SQL = "exec itemOrder @OrderID=" & OrderID & _
											", @IsXML=" & IsXML
										'Response.Write SQL 
										' Call the streaming function
										XMLString = XMLRequest(SQL, "", "" ,false)
										
										'Response.Write XMLString
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										XSLDoc.Load(Server.MapPath("geninv.xsl"))

										' Transform the xml doc with the xsl doc and return 
										DisplaySet = XMLDoc.TransformNode(XSLDoc)
										
										' Get the Supplier Address address
										strAddr = split(XMLDoc.selectSingleNode("//rootnode/smmessage/supplieraddress").text,",")
										
										' Loop through the address
										For Count = 0 to UBound(strAddr)
											dispAddr = dispAddr & strAddr(Count) & "<br>"
										Next
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@User",Session("FirstName"))
										DisplaySet = Replace(DisplaySet,"@@OrdDate",FormatDateTime(XMLDoc.selectSingleNode("//rootnode/smmessage/receivedate").text,1))
										DisplaySet = Replace(DisplaySet,"@@DelivDate",FormatDateTime(XMLDoc.selectSingleNode("//rootnode/smmessage/delivdate").text,1))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)
										DisplaySet = Replace(DisplaySet,"@@OrdID",OrderID)
										DisplaySet = Replace(DisplaySet,"@@InvDate",CStr(Day(Now()) & "/" & Month(Now()) & "/" & Year(Now())))
										if Session("UserName") = "SPARHEADOFFICE" then
											DisplaySet = Replace(DisplaySet,"@@SupAction",1)
										else
											DisplaySet = Replace(DisplaySet,"@@SupAction",2)
										end if
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../../includes/calc.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../includes/validation.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../includes/globalfunctions.js"></script>
<script language="javascript">
<!--
	function CheckNum(){
		// Call the open window function
		openWin ('<%=const_app_ApplicationRoot%>/search/numsearch.asp?item=' + document.forms['frmInvoice'].txtInvoiceNo.value, 'InvNumSearch', 'width=500,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');
	};
	
	function DisableButton (obj, UsrName) {
		if (UsrName=='GATEWAYCALLCEN') {
			obj.disabled=true;
		} else {
			obj.disabled=false;
		};
	};
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="calcTots();loadDefault();DisableButton (document.frmInvoice.btnSubmit, '<%=Session("UserName")%>');">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
