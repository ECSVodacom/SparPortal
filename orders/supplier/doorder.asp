<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../includes/constants.asp"-->
<!--#include file="../../includes/formatfunctions.asp"-->
<!--#include file="../../includes/logincheck.asp"-->
<!--#include file="../../includes/sendmail.asp"-->
<!--#include file="../../includes/getsuffix.asp"-->
<%
										' Check if the user is logged in
										'Call LoginCheck (const_app_ApplicationRoot & "/orders/supplier/default.asp?id=" & Request.QueryString("id"))

										' Declare the variables
										dim SQL
										dim curConnection										
										dim ReturnSet
										dim Counter
										dim ErrorCount
										dim OrderNumber
										dim DisplayOrder
										dim XMLDoc
										dim LineItem
										dim BodyText
										dim oFile
										dim BuyerCode
										dim txtBuyerEmail
										dim Delimiter
										dim SupplierName
										dim requestIDSplit
										dim requestID 

										' create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")										
										curConnection.Open const_db_ConnectionString
										
										' Create the XML Document
										Set XMLDoc = Server.CreateObject(const_app_XMLObject)
										XMLDoc.async = false
										XMLDoc.Load(const_app_SparArcPath & Request.QueryString("id"))

										' Get the OrderNumber
										OrderNumber = Request.Form("txtOrderNumber") & GetSuffix(XMLDoc.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text)
										DisplayOrder = Request.Form("txtOrderNumber")
										BuyerCode = XMLDoc.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
										SupplierName = XMLDoc.selectSingleNode("//DOCUMENT/UNB/Receiver/ReceiverName").text

										' Get the line item details
										Set LineItem = XMLDoc.selectNodes("//DOCUMENT/UNB/UNH/OLD")

										' Set the default values
										ErrorCount = 0

										' Loop through the form fields 
										For Counter = 1 to Request.Form("hidTotalCount") 								
											' Build the SQL Statement
											SQL = "exec EditOrder @OrderNumber=" & MakeSQLText(OrderNumber) & _
												", @Quantity=" & Request.Form("txtQuantity" & Counter) & _
												", @LineCost=" & MakeSQLText(Request.Form("txtPrice" & Counter)) & _
												", @LineComment=" & MakeSQLText(Request.Form("txtComment" & Counter)) & _
												", @LineNumber=" & Request.Form("hidLineNumber" & Counter) & _
												", @XMLRef=" & MakeSQLText(Request.QueryString("id")) & _
												", @Increment=" & Counter
'response.write SQL
'response.end
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
												
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 Then
												' An error occured
												ErrorCount = ErrorCount + 1
											else											
												' Update the XML Doxument with the Quantity and LineCost
												' Set the Session("BuyerID")
												Session("BuyerID") = ReturnSet("BuyerID")
												LineItem.item(Counter-1).selectSingleNode("QNTO/NROUC").text = Request.Form("txtQuantity" & Counter)
												LineItem.item(Counter-1).selectSingleNode("COST/COSP").text = CStr(Round(Request.Form("hidPrice" & Counter),2))
												LineItem.item(Counter-1).selectSingleNode("COST/COSPC").text = CStr(Round(Request.Form("txtPrice" & Counter),2))
												LineItem.item(Counter-1).selectSingleNode("NELC").text = CStr(Round(Request.Form("hidTotalPrice" & Counter),2))
												LineItem.item(Counter-1).selectSingleNode("NELCC").text = CStr(Round(Request.Form("hidTotalPrice" & Counter),2))
												LineItem.item(Counter-1).selectSingleNode("NARR").text = Trim(Request.Form("txtComment" & Counter))
												LineItem.item(Counter-1).setAttribute "status", "Confirmed"
											end if
	
											' close the recordset
											Set ReturnSet = Nothing
										Next
										
										' Now we need to get the email addresses of the buyer
										SQL = "exec listBuyerMail @BuyerID=" & Session("BuyerID")
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										' Check the Returnvalue
										if ReturnSet("returnvalue") <> 0 then
											' An error occured
											txtBuyerEMail = ""
										else
											' Set the BuyerEMail address
											Delimiter = ""
											While not ReturnSet.EOF
												txtBuyerEMail = txtBuyerEMail & Delimiter & ReturnSet("BuyerEMail")
												Delimiter = ";"
												
												ReturnSet.MoveNext
											Wend
										end if

										' Close the recordset
										Set ReturnSet = Nothing
										
										' Close the connection
										curConnection.Close
										Set curConnection = Nothing
										
										'Response.Write "SupplierEMail = " & Session("SupplierEMail")
										
										' Check if the errorCount is equal to 0
										if ErrorCount = 0 Then
											' All the line items were updated successfully
											' Save the XML Document
											XMLDoc.save(const_app_SparArcPath & Request.QueryString("id"))

											'requestIDSplit = split(request.querystring("id"),"\")
											'requestID = requestIDSplit(0)


											' Now we have to send a mail to the buyer
											' Build the BodyText
											BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>"
											BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font><p>"
											BodyText = BodyText & "<p><font face='Arial' size='2'>Click on the image below to view this Purchase Order Confirmation:</p>"
											'BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & Left(Request.QueryString("id"),7) & OrderNumber & ".xml&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></p>"
											BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & Request.QueryString("id") & "&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></p>"
											BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</p></body></html>"
											
											' Now call the function - SendCDOMail
											Call SendCDOMail (txtBuyerEMail, Session("SupplierEMail"), "Purchase Order Notification - Order " & DisplayOrder & " - Supplier " & SupplierName & " - Buyer " & CStr(BuyerCode), BodyText, 0)																						
											
											' Redirect to the previous page
											Response.Redirect const_app_ApplicationRoot & "/orders/supplier/default.asp?id=" & Request.QueryString("id") & "&check=1"
										else
											' Errors occured - Display an error message
%>
<!--#include file="../../layout/start.asp"-->
<!--#include file="../../layout/title.asp"-->
<!--#include file="../../layout/headstart.asp"-->
<!--#include file="../../layout/globaljavascript.asp"-->
<!--#include file="../../layout/headclose.asp"-->
<!--#include file="../../layout/bodystart.asp"-->
<p align="left"><img src="<%=const_app_ApplicationRoot%>/images/spar/sparlogo.gif"></p>
<p class="errortext">An Unexpected error occured while trying to save the order.</p>
<p class="pcontent">Please <a class="textnav" href="javascript:history.back(1);">return</a> to the previous page and try again.</p>
<!--#include file="../../layout/end.asp"-->
<%
										end if
%>