<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../../includes/constants.asp"-->
<!--#include file="../../../../includes/logincheck.asp"-->
<!--#include file="../../../../includes/formatfunctions.asp"-->
<!--#include file="../../../../includes/xmlfunctions.asp"-->
<!--#virtual include="../../../../includes/adovbs.inc"-->
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
										
										Dim f 
										f = Request.QueryString("f")
										'Response.Write f
										Dim FilterId, OneSelected, TwoSelected, FourSelected, FiveSelected, SixSelected, hidetotals
										If f <> "" Then
											Select Case f  
												Case 1:
													OneSelected = "selected='yes'"
												Case 2:
													TwoSelected = "selected='yes'"
												Case 4:
													FourSelected = "selected='yes'"
												Case 5:
													FiveSelected = "selected='yes'"
												Case 6:
													SixSelected = "selected='yes'"
											End Select
										Else
											f  = 1
											OneSelected = "selected='yes'"
											hidetotals = "0"
										End If
										
									
										
										Dim IsSaved
										IsSaved = Request.QueryString("s")
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Biuld the SQL Statement for orders
										SQL = "exec itemOrder @OrderID=" & OrderID & _
											", @IsXML=" & IsXML & ", @FilterId=" & f
										'Response.Write SQL 
										'Response.End
										' Call the streaming function
										XMLString = XMLRequest(SQL, "", "" ,false)
										
										XMLString =  Replace(XMLString,"<smmessage>","<smmessage>" _
											& "<filteroption value='1,Show All Items' name='Show All Items' " & OneSelected & "></filteroption>" _
											& "<filteroption value='2,Show All Items with Exceptions' name='Show All Items with Exceptions' " & TwoSelected & "></filteroption>" _
											& "<filteroption value='4,Show Only Items with Quantity Exceptions' name='Show Only Items with Quantity Exceptions' " & FourSelected & "></filteroption>" _
											& "<filteroption value='5,Show Only Items with Price Exceptions' name='Show Only Items with Price Exceptions' " & FiveSelected & "></filteroption>" _
											& "<filteroption value='6,Show Only Items with Supplier Comments' name='Show Only Items with Supplier Comments' " & SixSelected & "></filteroption>" _
										)
											
										'Response.Write XMLString
										
										' Load the String into an XML Dom
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.LoadXML(XMLString)
										
										' Load the XSL Style Sheet
										Set XSLDoc = Server.CreateObject(const_app_XMLObject)
										XSLDoc.async = false
										XSLDoc.Load(Server.MapPath("new.xsl"))

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
										DisplaySet = Replace(DisplaySet,"@@IsSaved",IsSaved)
										DisplaySet = Replace(DisplaySet,"@@InvNum",XMLDoc.selectSingleNode("//rootnode/smmessage/invoicenumber").text)
										If IsSaved Then
											DisplaySet = Replace(DisplaySet,"@@SaveMessage","Order confirmation saved")
										Else
											DisplaySet = Replace(DisplaySet,"@@SaveMessage","")
										End If
										if Session("UserName") = "SPARHEADOFFICE" then
											DisplaySet = Replace(DisplaySet,"@@SupAction",1)
										else
											DisplaySet = Replace(DisplaySet,"@@SupAction",2)
										end if
										
%>
<!--#include file="../../../../layout/start.asp"-->
<!--#include file="../../../../layout/title.asp"-->
<!--#include file="../../../../layout/headstart.asp"-->
<!--#include file="../../../../layout/globaljavascript.asp"-->
<script type="text/javascript" language="JavaScript" src="../../../../includes/calc.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../../includes/validation.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../../includes/globalfunctions.js"></script>
<script type="text/javascript" language="JavaScript">
	function onlySave()
	{
		document.getElementById("DoSendOrderConfirmation").value = 0;
		document.getElementById("ButtonClick").value = "Save";
		document.forms["frmInvoice"].submit();
	}

	
	function askConfirmationSend()
	{	
		var doSubmit = validate(document.forms["frmInvoice"]);
		
		if (doSubmit)
		{
			document.getElementById("ButtonClick").value = "";
			var doSendConfirmation = confirm("Do you wish to inform the store of the order confirmations?\n\rOK for Yes\n\rCancel for No");
			if (doSendConfirmation)
				document.getElementById("DoSendOrderConfirmation").value = 1;
			
			document.forms["frmInvoice"].submit();
		}
	}
	
	
	function reloadSearch(filter)
	{
		document.getElementById("ButtonClick").value = "FilterChange"
		document.forms["frmInvoice"].submit();
	}
	
</script>
<!--#include file="../../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="" onload="calcTots();loadDefault();">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../../layout/end.asp"-->
