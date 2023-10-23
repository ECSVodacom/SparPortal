<%@ Language=VBScript %>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/getsuffix.asp"-->
<!--#include file="includes/generatetabfile.asp"-->
<%

'response.write Session("IsLoggedIn") & "<br>"
'response.write Response.Cookies("WebLogon")
'response.end	

										Call CookieLoginCheck (const_app_ApplicationRoot & "/orders/supplier/default.asp?id=" & Request.QueryString("id"))
										
										ErrorFlag = False
										
										' Check if there is a querystring parameter
										if Request.QueryString("id") = "" Then
											ErrorFlag = True
										end if
										
										Set oFile = Server.CreateObject("Scripting.FileSystemObject")
										'rESPONSE.wRITE const_app_SparArcPath & Request.QueryString("id")
										' Check if the file exist
										if oFile.FileExists(const_app_SparArcPath & Request.QueryString("id")) Then
											ErrorFlag = False
											'Response.Write "No"
										else
											ErrorFlag = True
											'Response.Write "Yes"											
										end if

										' Close the file
										Set oFile = Nothing
										
										' Check if the user updated the order
										if Request.QueryString("check") = "1" Then
											' The user updated the order
											Message = "window.alert('Message saved and sent');"
										else
											Message = ""
										end if
																					
										' Set the body onload variable
										Preloader = Message
										
										PageTitle = "Supplier: Order"

%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
		if (window.confirm('Are you sure that you want to update this order?')) { return true;} else { return false; };
	
		var TotalCount = obj.hidTotalCount.value;
		
		// Loop through the form fields
		for (var i=1; i <= TotalCount; i++) {
			// Check if the quantity is filled in
			//if (obj.elements['txtQuantity' + i].value == '') {
			if ((!isFinite(obj.elements['txtQuantity' + i].value)) || (obj.elements['txtQuantity' + i].value=='')) {
				window.alert ('Please enter a number quantity for product ' + obj.elements['txtDesc' + i].value + '.');
				obj.elements['txtQuantity' + i].select();
				obj.elements['txtQuantity' + i].focus();
				return false;
			};
			
			// Check if the price is filled in
			//if (obj.elements['txtPrice' + i].value == '') {
			if ((!isFinite(obj.elements['txtPrice' + i].value)) || (obj.elements['txtPrice' + i].value=='')) {
				window.alert ('Please enter a list cost amount for product ' + obj.elements['txtDesc' + i].value + '.');
				obj.elements['txtPrice' + i].focus();
				obj.elements['txtPrice' + i].select();
				return false;
			};
			
		};
	};
//-->
</script>
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<%
										' Check if there is an error
										if ErrorFlag Then
											' Display an error message
%>
<p><img src="<%=const_app_ApplicationRoot%>/images/spar/sparlogo.gif"></p>
<p class="errortext">Error</p>
<p class="pcontent">The selected order is not available.<br> Please try again and if the problem occurs again, contact the <b>Gateway Communication's</b> helpdesk at <b>0821951</b> or send the helpdesk an <a class="textnav" href="mailto:spar@gatewaycomms.co.za">e-mail</a>.</p>
<%											
										else												
											' Load the XMl Document
											Set XMLDoc = Server.CreateObject(const_app_XMLObject)
											XMLDoc.async = false
											XMLDoc.Load(const_app_SparArcPath & Request.QueryString("id"))

											' Load the XSL Style Sheet
											Set XSLDoc = Server.CreateObject(const_app_XMLObject)
											XSLDoc.async = false
											
											' Update added by Petrus Daffue
											' Wednesday, September 3rd, 2008
											'response.write Server.MapPath("updateorderView.xsl")
											If Request.QueryString("doAction") = "view" Then
											    
											    ' If the argument doAction is passed with a value "view", 
											    ' the XSLDoc wil load the View, this will be used to view/print 
											    ' - no interactive fields available
											    XSLDoc.Load(Server.MapPath("updateorderView.xsl"))
											
											Else
											
											    XSLDoc.Load(Server.MapPath("updateorder.xsl"))
											    
											End IF

											' Transform the xml doc with the xsl doc
											DisplaySet = XMLDoc.TransformNode(XSLDoc)
											
											' Get the value of the OrderNumber
											OrderNum = XMLDoc.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text
											
											' Get a list of Nars
											Set ListNar = XMLDoc.selectNodes("//DOCUMENT/UNB/UNH/NAR")
											PromItem = "<b class='pcontent'>Comments:</b>&nbsp;" 
											' Loop through the ListNar Object
											For NarCount = 0 to ListNar.Length-1
												' Check if the line seq num is 2
												if CStr(ListNar.item(NarCount).selectSingleNode("LSNR").text) = "2" Or CStr(ListNar.item(NarCount).selectSingleNode("LSNR").text) = "1" then
													'PromItem = "<b class='pcontent'>Comments:</b>&nbsp;" & ListNar.item(NarCount).selectSingleNode("NARR").text & " "
												Else
													PromItem = PromItem & ListNar.item(NarCount).selectSingleNode("NARR").text & " "
												End If
												'if CStr(ListNar.item(NarCount).selectSingleNode("LSNR").text) = "2" then
												'	PromItem = "<b class='pcontent'>Comments:</b>&nbsp;" & ListNar.item(NarCount).selectSingleNode("NARR").text
													
												'else
												'	PromItem = ""
												'end if
												
												'Response.Write ListNar.item(NarCount).selectSingleNode("NARR").text
											Next

											' Replace the values in the XSL File
											DisplaySet = Replace(DisplaySet,"@@XMLFile",CStr(Request.QueryString("id")))
											DisplaySet = Replace(DisplaySet,"@@ApplicationRoot",const_app_ApplicationRoot)
											DisplaySet = Replace(DisplaySet,"@@TabFile",OrderNum & ".txt")
											DisplaySet = Replace(DisplaySet,"@@XMLDownFile",Replace(Request.QueryString("id"),"\",","))
											DisplaySet = Replace(DisplaySet,"@@PromItem",PromItem)
		
											' Write the Transformation
											response.write DisplaySet
											
											' Generate the tab file for downloading
											Call CreateTabFile (XMLDoc, OrderNum)
											
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Update the extracted Date And Time
											SQL = "exec procOrderExtract @OrderNumber=" & MakeSQLText(OrderNum & GetSuffix(XMLDoc.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text))
											
											'Response.Write SQL
											'response.end

											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
											
											' Close the Connection & RecordSet
											Set ReturnSet = Nothing
											curConnection.Close
											Set curConnection = Nothing
%>
<!--#include file="../../layout/end.asp"-->
<%
										end if
%>