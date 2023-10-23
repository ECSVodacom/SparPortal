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
										dim ReturnSet
										dim XMLString
										dim XMLDoc
										dim XSLDoc
										dim DisplaySet
										dim strAddr
										dim strOption
										dim Count
										dim dispAddr
										dim strSup

										XMLString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><UNB><UNH></UNH></UNB>"
																				
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
										strAddr = split(Session("PhysAddress"),",")
										
										' Loop through the address
										For Count = 0 to UBound(strAddr)
											dispAddr = dispAddr & strAddr(Count) & "<br>"
										Next
										
										' Get a list of all stores
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Check if this is a supplier or SPAR Headoffice that is logged in
										if Session("UserName") = "SPARHEADOFFICE" OR Session("UserName") = "GATEWAYCALLCEN" then
											' Get a list of suppliers
											
											Set ReturnSet = ExecuteSql("listSupplier", curConnection)
											
											strSup = strSup & "<b class=" & chr(34) & "pcontent" & chr(34) & "><select name=" & chr(34) & "drpSupplier" & chr(34) & " class=" & chr(34) & "pcontent" & chr(34) & " onchange=" & chr(34) & "GetSupVals(document.frmInvoice.drpSupplier[document.frmInvoice.drpSupplier.selectedIndex].value);" & chr(34) & ">"
											strSup = strSup & "<option value=" & chr(34) & "-1" & chr(34) & ">-- Select a Supplier --</option>"
											
											' Loop through the Recordset
											While Not ReturnSet.EOF
												' Build the Option tags
												strSup = strSup & "<option value=" & chr(34) & ReturnSet("SupplierID") & "*" & ReturnSet("SupplierEAN") & "*" & ReturnSet("SupplierVat") & "*" & ReturnSet("SupplierAddress") & chr(34) & ">" & ReturnSet("SupplierName") & "</option>"
												
												ReturnSet.MoveNext
											Wend
											
											strSup = strSup & "</select></b><br><br>"
											strSup = strSup & "<span id=" & chr(34) & "sSupplier" & chr(34) & "></span>"

											' Close the recordSet
											Set ReturnSet = Nothing
										else
											strSup = "<b class=" & chr(34) & "tdhead" & chr(34) & ">" & Session("FirstName") & "</b><br/><br/>" & dispAddr
										end if
										
										' execute the SQL
										Set ReturnSet = ExecuteSql("listStores", curConnection)  
										
										' Loop through the recordset
										While not ReturnSet.EOF
											strOption = strOption & "<option value=" & chr(34) & ReturnSet("StoreID") & "*" & ReturnSet("StorePhone") & "*" & ReturnSet("StoreFax") & "*" & ReturnSet("StoreAddress") & "*" & ReturnSet("DCEANNumber") & "*" & ReturnSet("StoreEAN") & chr(34) & " class='pcontent'>" & ReturnSet("StoreName") & "</option>"
											
											ReturnSet.MoveNext
										Wend
										
										' Close the recordset
										Set ReturnSet = Nothing

										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										' Replace the variables in the XSL doc
										DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
										DisplaySet = Replace(DisplaySet,"@@User",Session("FirstName"))
										'DisplaySet = Replace(DisplaySet,"@@Supplier",Session("FirstName"))
										'DisplaySet = Replace(DisplaySet,"@@Supplier",Session("FirstName"))
										DisplaySet = Replace(DisplaySet,"@@InvDate",CStr(Day(Now()) & "/" & Month(Now()) & "/" & Year(Now())))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)
										DisplaySet = Replace(DisplaySet,"@@Options",strOption)
										DisplaySet = Replace(DisplaySet,"@@Supplier",strSup)
										DisplaySet = Replace(DisplaySet,"@@SupEAN",Session("ProcEAN"))
										if Session("UserName") = "SPARHEADOFFICE" OR Session("UserName") = "GATEWAYCALLCEN" then
											DisplaySet = Replace(DisplaySet,"@@SupAction",1)
											DisplaySet = Replace(DisplaySet,"@@Disable","False")
										else
											DisplaySet = Replace(DisplaySet,"@@SupAction",2)
											DisplaySet = Replace(DisplaySet,"@@Disable","True")
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
	function GetVals (OptionVal) {
		if (OptionVal=='-1') {
			sPhone.innerHTML = 'Not Selected';
			sPhone.style.display = 'inline';
		
			sFax.innerHTML = 'Not Selected';
			sFax.style.display = 'inline';
		
			sAddr.innerHTML = 'Not Selected';
			sAddr.style.display = 'block';
			
			document.frmInvoice.hidDCEAN.value='';
		} else {
			var ListArray = OptionVal.split('*');

			sPhone.innerHTML = ListArray[1];
			sPhone.style.display = 'inline';
		
			sFax.innerHTML = ListArray[2];
			sFax.style.display = 'inline';
		
			sAddr.innerHTML = ListArray[3];
			sAddr.style.display = 'block';
			
			document.frmInvoice.hidDCEAN.value=ListArray[4];
			document.frmInvoice.hidStoreName.value=document.frmInvoice.drpStore[document.frmInvoice.drpStore.selectedIndex].innerHTML;
			document.frmInvoice.hidStoreAddr.value=ListArray[3];
			document.frmInvoice.hidStoreEAN.value=ListArray[5];
		};
	};
	
	function GetSupVals (OptionVal) {
		var ListArray = OptionVal.split('*');
		
		// Split the address value into an array
		var AddrArray = ListArray[3].split(',');
		var strAddr='';
		
		// Loop through the array
		for (var i=0;i<=AddrArray.length-1;i++) {
			strAddr = strAddr + AddrArray[i] + "<br>";
		};
		
		sSupplier.innerHTML = strAddr;
		sSupplier.style.display = 'inline';
		
		//document.frmInvoice.hidSupVat.value=ListArray[2];
		document.frmInvoice.hidSupEAN.value=ListArray[1];
	};
	
	function CheckNum(){
		// Call the open window function
		openWin ('<%=const_app_ApplicationRoot%>/search/numsearch.asp?item=' + document.forms['frmInvoice'].txtInvoiceNo.value, 'InvNumSearch', 'width=500,height=200,toolbar=0,location=0,directories=0,status=1,menuBar=0,scrollBars=1,resizable=1');
	};
	
	function DisableButton (obj,UsrName) {
		if (UsrName=='GATEWAYCALLCEN') {
			obj.disabled=true;
		} else {
			obj.disabled=false;
		};
	};
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif" onload="calcTots();loadDefault();GetVals ('-1');DisableButton(document.frmInvoice.btnSubmit,'<%=Session("UserName")%>');">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
