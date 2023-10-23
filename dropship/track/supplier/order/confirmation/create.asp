<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../../includes/constants.asp"-->
<!--#include file="../../../../includes/logincheck.asp"-->
<!--#include file="../../../../includes/functions.asp"-->
<!--#include file="../../../../includes/xmlfunctions.asp"-->
<!--#include file="../../../../includes/genedi.asp"-->
<%
										dim SQL
										dim curConnection
										dim ReturnSet
										dim dFile
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
										dim strSQL
										dim strSQLSettle
										dim strXMLVRS
										dim LineSQL
										Dim DoSendOrderConfirmation
										Dim OnlySaveOrderConfirmation

										Dim FilterId
										FilterId = 1
										If UBound(Split(Request.Form("txtFilter"),",")) > 0 Then
											FilterId = Split(Request.Form("txtFilter"),",")(0)
										End If
										'Response.Write UBound(Split("6,This pie",",")) & "<br />"
										'Response.Write UBound(Split(Request.Form("txtFilter"),","))
										'Response.End
										
										If Request.Form("ButtonClick")  = "FilterChange" Then
											
											Response.Redirect const_app_ApplicationRoot & "/track/supplier/order/confirmation/new.asp?item=" & Request.QueryString("item") & "&f=" & filterId 
										End If
										
										
										DoSendOrderConfirmation = 0
										If IsNumeric(Request.Form("DoSendOrderConfirmation")) Then
											DoSendOrderConfirmation = CInt(Request.Form("DoSendOrderConfirmation"))
										End If
										
										OnlySaveOrderConfirmation = 0
										If Request.Form("ButtonClick")  = "Save" Then
											OnlySaveOrderConfirmation = 1
											DoSendOrderConfirmation = 0
										End If
										' Determine if the user selected to generate new lines
										'if Request.Form("hidAction") = "1" then
											' The user requested to save/send the invoice
											
											' Build the String for the XML file
											strXMLHead = ""
											strXMLLine = ""
											
											' Set the StoreAddress to an array
											StoreAddr = split(Request.Form("hidStoreAddr"),",")
											
										
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Now we have to add the data to the database
											' Build the SQL to add the 
											'Response.Write Request.Form("rdDealOne")
													if Request.Form("rdDealOne") = 1 then
														strCrad = strCrad & "<ADJI1>T1</ADJI1><PERC1>" & Request.Form("txtDealOne") & "</PERC1><VALU1></VALU1>"
														strSQL = strSQL & ", @CDAdjIndicator1=" & MakeSQLText("T1")
														strSQL = strSQL & ", @CDPerc1=" & MakeSQLText(Request.Form("txtDealOne"))
														strSQL = strSQL & ", @CDValue1=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI1>T1</ADJI1><PERC1></PERC1><VALU1>" & Request.Form("txtCRAdjR1") & "</VALU1>"
														strSQL = strSQL & ", @CDAdjIndicator1=" & MakeSQLText("T1")
														strSQL = strSQL & ", @CDPerc1=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDValue1=" & MakeSQLText(Request.Form("txtDealOne")) 'txtCRAdjR1 
													end if
													
													if Request.Form("rdDealTwo") = 1 then
														strCrad = strCrad & "<ADJI2>T2</ADJI2><PERC2>" & Request.Form("txtDealTwo") & "</PERC2><VALU2></VALU2>"
														strSQL = strSQL & ", @CDAdjIndicator2=" & MakeSQLText("T2")
														strSQL = strSQL & ", @CDPerc2=" & MakeSQLText(Request.Form("txtDealTwo"))
														strSQL = strSQL & ", @CDValue2=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI2>T2</ADJI2><PERC2></PERC2><VALU2>" & Request.Form("txtCRAdjR2") & "</VALU2>"
														strSQL = strSQL & ", @CDAdjIndicator2=" & MakeSQLText("T2")
														strSQL = strSQL & ", @CDPerc2=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDValue2=" & MakeSQLText(Request.Form("txtDealTwo")) 'txtCRAdjR2
													end if
													
													if Request.Form("rdDealThree") = 1 then
														strCrad = strCrad & "<ADJI3>T3</ADJI3><PERC3>" & Request.Form("txtDealThree") & "</PERC3><VALU3></VALU3>"
														strSQL = strSQL & ", @CDAddDisInd=" & MakeSQLText("T3")
														strSQL = strSQL & ", @CDAddDiscPerc=" & MakeSQLText(Request.Form("txtDealThree"))
														strSQL = strSQL & ", @CDAddDiscValue=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI3>T3</ADJI3><PERC3></PERC3><VALU3>" & Request.Form("txtCRAdjR3") & "</VALU3>"
														strSQL = strSQL & ", @CDAddDisInd=" & MakeSQLText("T3")
														strSQL = strSQL & ", @CDAddDiscPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDAddDiscValue=" & MakeSQLText(Request.Form("txtDealThree")) 'txtCRAdjR3
													end if

													
													if Request.Form("rdDealFour") = 1 then
														strDrad = strDrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealFour") & "</PERC1><VALU1></VALU1>"
														strSQL = strSQL & ", @TransportCstInc=" & MakeSQLText("")
														strSQL = strSQL & ", @TransportCstPerc=" & MakeSQLText(Request.Form("txtDealFour"))
														strSQL = strSQL & ", @TransportCstVal=" & MakeSQLText("0")
													else
														strDrad = strDrad & "<ADJI1></ADJI1><PERC1></PERC1><VALU1>" & Request.Form("txtDBAdjR1") & "</VALU1>"
														strSQL = strSQL & ", @TransportCstInc=" & MakeSQLText("")
														strSQL = strSQL & ", @TransportCstPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @TransportCstVal=" & MakeSQLText(Request.Form("txtDealFour")) 'txtDBAdjR1
													end if
													
													if Request.Form("rdDealFive") = 1 then
														strDrad = strDrad & "<ADJI2></ADJI2><PERC2>" & Request.Form("txtDealFive") & "</PERC2><VALU2></VALU2>"
														strSQL = strSQL & ", @DutLevIndc=" & MakeSQLText("")
														strSQL = strSQL & ", @DutLevPerc=" & MakeSQLText(Request.Form("txtDealFive"))
														strSQL = strSQL & ", @DutLevVal=" & MakeSQLText("0")
													else
														strDrad = strDrad & "<ADJI2></ADJI2><PERC2></PERC2><VALU2>" & Request.Form("txtDBAdjR2") & "</VALU2>"
														strSQL = strSQL & ", @DutLevIndc=" & MakeSQLText("")
														strSQL = strSQL & ", @DutLevPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @DutLevVal=" & MakeSQLText(Request.Form("txtDealFive")) ' txtDBAdjR2
													end if
													
													
													if Request.Form("rdSettle") = 1 then
														strSettle = strSettle & "<PERC>" & Request.Form("txtSettle") & "</PERC><VALU></VALU>"
														strSQL = strSQL & ", @SettleDisPerc=" & MakeSQLText(Request.Form("txtSettle"))
														strSQL = strSQL & ", @SettleDisVal=" & MakeSQLText("0")
													else
														strSettle = strSettle & "<PERC></PERC><VALU>" & Request.Form("txtSetTotExl") & "</VALU>"
														strSQL = strSQL & ", @SettleDisPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @SettleDisVal=" & MakeSQLText(Request.Form("txtSettle"))
													end if
											
											
											Dim InvoiceId 
											
											InvoiceId = 0
											If Request.Form("txtInvoiceId") <> "" Then
												InvoiceId = Request.Form("txtInvoiceId")
											Else	
												InvoiceId = 0
											End If
											
											
											
											SQL = "addInvoice @InvoiceNumber=" & MakeSQLText(Request.Form("txtInvoiceNo")) & _
												", @OrderNumber=" & MakeSQLText(Request.Form("hidOrdNo")) & _
												", @DCEAN=" & MakeSQLText(Request.Form("hidDCEAN")) & _
												", @SupplierEAN=" & MakeSQLText(Request.Form("hidSupEAN")) & _
												", @StoreEAN=" & MakeSQLText(Request.Form("hidStoreEAN")) & _
												", @ReceivedDate=" & MakeSQLText(Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())) & _
												", @TranslateDate=" & MakeSQLText(Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())) & _
												", @PostDate=" & MakeSQLText(Year(Now()) & "/" & Month(Now()) & "/" & Day(Now()) & " " & Hour(Now()) & ":" & Minute(Now()) & ":" & Second(Now())) & strSQL & _
												", @LnSubTotExl=" & MakeSQLText(Request.Form("hidTots1")) & _
												", @LnSubTotVat=" & MakeSQLText(Request.Form("hidTots2")) & _
												", @ExtSubTotExl=" & MakeSQLText(Request.Form("hidNettTotExcl")) & _
												", @TotVat=" & MakeSQLText(Request.Form("hidNettTotVat")) & _
												", @ExtSubTotIncl=" & MakeSQLText(Request.Form("hidNettTotIncl")) & strSQLSettle & _
												", @IsOrderConfirmation=1, @DoSendOrderConfirmation=" & DoSendOrderConfirmation & _
												", @OnlySaveOrderConfirmation=" & OnlySaveOrderConfirmation & _
												", @InvoiceId=" & InvoiceId & _
												", @FilterId=" & FilterId
												'Response.Write 		 SQL
												'Response.End												
									'	Response.End 
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)   
											'Response.Write SQL
											'Response.End
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - redirect the user back to the previous page
												
												Response.Redirect const_app_ApplicationRoot & "/track/supplier/order/confirmation/new.asp?item=" & Request.QueryString("item")
												Response.Flush
												'Response.Write const_app_ApplicationRoot & "/track/supplier/order/geninv.asp?item=" & Request.QueryString("item")																								
											else
												' Set the new InvoiceId
												Dim IsNewInvoiceId
												InvoiceID = ReturnSet("NewInvoiceID")
												IsNewInvoiceId = ReturnSet("IsNewInvoiceId")
												'	Response.Write "InvoiceId : " & InvoiceId
												'	Response.End
												' Close the Recordset
												Set ReturnSet = Nothing
													
												' Loop through the line items and add them to the database
												For LCount = 1 to Request.Form("hidTotalCount")
													'if Request.Form("hidChkDelete" & LCount) = "0" Then
														LineSQL = ""														
														
														Dim DealOne, DealTwo, ListCost
														DealOne = Request.Form("txtDealpercOne" & LCount)
														DealTwo = Request.Form("txtDealpercTwo" & LCount)
														ListCost = Request.Form("txtListCost" & LCount)
														
														If Not IsNumeric(DealOne) Then
															DealOne = 0
														End If
														
														If Not IsNumeric(DealTwo) Then
															DealTwo = 0
														End If
														
														Dim IsOne, IsTwo
														IsOne = Request.Form("rdTradeOne" & LCount)
														IsTwo = Request.Form("rdTradeTwo" & LCount)
														
														if IsOne = 1 then
															strCrad = strCrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealpercOne" & LCount) & "</PERC1><VALU1></VALU1>"
															LineSQL = LineSQL & ", @AdjIndicator1=" & MakeSQLText("T1")
															LineSQL = LineSQL & ", @AdjPerc1=" & DealOne
															LineSQL = LineSQL & ", @AdjValue1=" & MakeSQLText("0")
														else
															strCrad = strCrad & "<ADJI1></ADJI1></PERC1></PERC1><VALU1>" & Request.Form("txtDealpercOne" & LCount) & "</VALU1>"
															LineSQL = LineSQL & ", @AdjIndicator1=" & MakeSQLText("T1")
															LineSQL = LineSQL & ", @AdjPerc1=" & MakeSQLText("0")  'MakeSqlText(DealOne / ListCost * 100)
															LineSQL = LineSQL & ", @AdjValue1=" & DealOne
														end if
															
														if IsTwo = 1 then
															strCrad = strCrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealpercTwo" & LCount) & "</PERC1><VALU1></VALU1>"
															LineSQL = LineSQL & ", @AdjIndicator2=" & MakeSQLText("T2")
															LineSQL = LineSQL & ", @AdjPerc2=" & DealTwo
															LineSQL = LineSQL & ", @AdjValue2=" & MakeSQLText("0")
														else
															strCrad = strCrad & "<ADJI1></ADJI1></PERC1></PERC1><VALU1>" & Request.Form("txtDealpercTwo" & LCount) & "</VALU1>"
															LineSQL = LineSQL & ", @AdjIndicator2=" & MakeSQLText("T2")
															LineSQL = LineSQL & ", @AdjPerc2=" & MakeSQLText("0") 'MakeSqlText(DealTwo / ListCost * 100) 
															LineSQL = LineSQL & ", @AdjValue2=" & DealTwo
														end if
														
														
													
														Dim InvoiceLineId
														If Request.Form("txtInvoiceLineId" & LCount) <> "" Then
															InvoiceLineId = Request.Form("txtInvoiceLineId" & LCount)
														Else
															InvoiceLineId = 0
														End If
														
														SQL = "addInvoiceDetail	@InvoiceID=" & MakeSQLText(InvoiceID) & _
															", @ConsumerBarCode=" & MakeSQLText(Request.Form("txtBarCode" & LCount)) & _
															", @ConsumerOrdUnit=" & MakeSQLText(Request.Form("txtOrdCode" & LCount)) & _
															", @SupplProdCode=" & MakeSQLText(Request.Form("txtProdCode" & LCount)) & _
															", @ProdDescription=" & MakeSQLText(Request.Form("txtDescr" & LCount)) & _
															", @Qty=" & MakeSQLText(Request.Form("txtQty" & LCount)) & _
															", @SupplierPack=" & MakeSQLText(Request.Form("txtSupPack" & LCount)) & _
															", @UnitOfMeasure=" & MakeSQLText(Request.Form("txtMeasure" & LCount)) & _
															", @ListCost=" & MakeSQLText(Request.Form("txtListCost" & LCount)) & LineSQL & _
															", @NettValue=" & MakeSQLText(Request.Form("hidTotalExcl" & LCount)) & _
															", @VatPerc=" & MakeSQLText(Request.Form("txtVatperc" & LCount)) & _
															", @VatCode=" & MakeSQLText(Request.Form("hidVatCode" & LCount)) & _
															", @FreeQty=" & MakeSQLText(Request.Form("txtFreeQty" & LCount)) & _
															", @OrderLineId=" & MakeSQLText(Request.Form("txtOrderLineId" & LCount)) & _
															", @OriginalTotalExcl=" & MakeSQLText(Request.Form("hidOriginalTotalExcl" & LCount)) & _
															", @Comments='" & Replace(Request.Form("txtFreeText" & LCount),"'","''") & _
															"',@InvoiceLineId=" & InvoiceLineId & _
															", @IsNewInvoiceId=" & IsNewInvoiceId
														'Response.Write SQL 
														'Response.End
														Set ReturnSet = ExecuteSql(SQL, curConnection)  
																
														' Close the recordset
														Set ReturnSet = Nothing
													'end if
												Next
													'Response.End
												' Close the Connection
												curConnection.Close
												Set curConnection = Nothing
												' Redirect the User to the Invoice display page
												'Response.End
												If OnlySaveOrderConfirmation = 0 Then
													Response.Redirect const_app_ApplicationRoot & "/track/supplier/order/confirmation/default.asp?item=" & InvoiceID & "&success=1"
												Else
													Response.Redirect const_app_ApplicationRoot & "/track/supplier/order/confirmation/new.asp?item=" & Request.QueryString("item") & "&s=1"
												End If
												Response.Flush
												'Response.Write const_app_ApplicationRoot & "/track/supplier/order/default.asp?item=" & Request.QueryString("item")
											end if
										'else
%>
<!--include file="../../../../layout/start.asp"-->
<!--include file="../../../../layout/title.asp"-->
<!--include file="../../../../layout/headstart.asp"-->
<!--include file="../../../../layout/globaljavascript.asp"-->
<!--<script type="text/javascript" language="JavaScript" src="../../../../includes/calc.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../../includes/validation.js"></script>-->
<!--include file="../../../../layout/headclose.asp"-->
<!--<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif" onload="calcTots();loadDefault();">
<p class="pcontent">An unexpected error occured.</p>-->
<!--include file="../../../../layout/end.asp"-->
<%
	'									end if
%>