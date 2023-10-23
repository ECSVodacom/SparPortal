<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/functions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#include file="../../../includes/genedi.asp"-->
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
										dim InvoiceID
										dim LineSQL
										
										' Determine if the user selected to generate new lines
										'if Request.Form("hidAction") = "1" then
											' The user requested to save/send the invoice
											
											' Build the String for the XML file
											strXMLHead = ""
											strXMLLine = ""
											
											' Set the StoreAddress to an array
											StoreAddr = split(Request.Form("hidStoreAddr"),",")
											
											' Loop through the array
											For ACount = 0 to UBound(StoreAddr)
												strSAddr = strSAddr & "<alin" & ACount+1 & ">" & StoreAddr(ACount) & "</alin" & ACount+1 & ">"
											Next
											
											if UBound(StoreAddr) < 3 then
												For ACount = UBound(StoreAddr)+1 to 3 
													strSAddr = strSAddr & "<alin" & ACount+1 & ">000</alin" & ACount+1 & ">"
												Next
											end if
											
											strXMLHead = strXMLHead & "<?xml version=" & chr(34) & "1.0" & chr(34) & " encoding=" & chr(34) & "UTF-8" & chr(34) & "?>" 
											strXMLHead = strXMLHead & "<UNB><UNH><SAP><SAPT>" & Request.Form("hidSupEAN") & "</SAPT>"
											strXMLHead = strXMLHead & "<SVAT>" & Request.Form("hidSupVat") & "</SVAT></SAP>"
											strXMLHead = strXMLHead & "<SDP><SUDP>" & Request.Form("hidSupEAN") & "</SUDP><SUDA><alin1>000</alin1><alin2></alin2><alin3></alin3><alin4>000</alin4></SUDA></SDP>"
											strXMLHead = strXMLHead & "<CLO>"
											strXMLHead = strXMLHead & "<CDPT>" & Request.Form("hidStoreEAN") & "</CDPT>"
											strXMLHead = strXMLHead & "<COPT>" & Request.Form("hidDCEAN") & "</COPT>"
											strXMLHead = strXMLHead & "<CDPN>" & Request.Form("hidStoreName") & "</CDPN>"
											strXMLHead = strXMLHead & "<CDPA>" & strSAddr & "</CDPA>"
											strXMLHead = strXMLHead & "<ALIP>" & Request.Form("hidDCEAN") & "</ALIP>"
											strXMLHead = strXMLHead & "</CLO>"
											strXMLHead = strXMLHead & "<IRE>"
											strXMLHead = strXMLHead & "<INVR>"
											strXMLHead = strXMLHead & "<REFN>" & Request.Form("txtInvoiceNo") & "</REFN>"
											strXMLHead = strXMLHead & "<DATE1>" & Replace(FormatDateTime(Request.Form("txtInvoiceDate"),2),"/","") & "</DATE1>"
											strXMLHead = strXMLHead & "<DATE2></DATE2><PDET><DTER></DTER><CURR></CURR><AGNT></AGNT><BANK></BANK><INDN></INDN><SHCN></SHCN></PDET>"
											strXMLHead = strXMLHead & "</INVR>"
											strXMLHead = strXMLHead & "</IRE>"
											strXMLHead = strXMLHead & "<NAR><LSNR></LSNR><NARR></NARR></NAR>"
											strXMLHead = strXMLHead & "<ODD><LSNR></LSNR><ORNO><ORNU1>" & Request.Form("hidOrdNo") & "</ORNU1>" 
											strXMLHead = strXMLHead & "<ORNU2></ORNU2><DATE></DATE></ORNO><CDNO><CNDN></CNDN><SDIR></SDIR><CNDN2></CNDN2><CNTP></CNTP><WHNG></WHNG><SREP></SREP><CREP></CREP></CDNO><DELR>"
											strXMLHead = strXMLHead & "<REFN>" & Request.Form("txtInvoiceNo") & "</REFN>" 
											strXMLHead = strXMLHead & "<DATE>" & Replace(FormatDateTime(Request.Form("txtInvoiceDate"),2),"/","") & "</DATE>"
											strXMLHead = strXMLHead & "</DELR><PODD><REFN></REFN><DATE></DATE></PODD><NCAR></NCAR></ODD><CNF><LSNR></LSNR><CNRF></CNRF></CNF>"
											
											' Set the VRSCount 
											VrsCount = 0
											
											' Set the VrsVal
											VrsVal = CInt(Request.Form("txtVatperc1"))
											
											ReDim Preserve VrsArray(0)
											
											VrsArray(0) = CInt(Request.Form("txtVatperc1"))
											
											' Set the counters for the different vat rates
											ZCount = 0
											TCount = 0
											FCount = 0
											ZExCount = 0
											TExCount = 0
											FExCount = 0
											ZVatCount = 0
											TVatCount = 0
											FVatCount = 0
											
											' Generate the line items
											' Loop through the line items
											For LCount = 1 to Request.Form("hidTotalCount")
												strCrad = ""		
												LineSQL = ""									
											
												if Request.Form("rdTradeOne" & LCount) = "1" then
													strCrad = strCrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealpercOne" & LCount) & "</PERC1><VALU1></VALU1>"
												else
													strCrad = strCrad & "<ADJI1></ADJI1></PERC1></PERC1><VALU1>" & Request.Form("txtDealpercOne" & LCount) & "</VALU1>"
												end if
												
												if Request.Form("rdTradeTwo" & LCount) = "1" then
													strCrad = strCrad & "<ADJI2></ADJI2><PERC2>" & Request.Form("txtDealpercTwo" & LCount) & "</PERC2><VALU2></VALU2>"
												else
													strCrad = strCrad & "<ADJI2></ADJI2><PERC2></PERC2><VALU2>" & Request.Form("txtDealpercTwo" & LCount) & "</VALU2>"
												end if
												
												if Request.Form("txtSupPack" & LCount) <> "" or Round(Request.Form("txtSupPack" & LCount)) <> "0" then
													NetConsum = CDbl(Request.Form("txtListCost" & LCount)) / CDbl(Request.Form("txtSupPack" & LCount))
												else
													NetConsum = 0
												end if
												
												ReDim Preserve VrsArray(LCount-1)
												VrsCount = 0

												for VCount = 0 to UBound(VrsArray)
													if CInt(VrsArray(VCount)) = CInt(Request.Form("txtVatperc" & LCount)) then
														VrsCount = VrsCount + 1
													end if
												next

												if VrsCount = 0 then
													VrsArray(LCount-1) = CInt(Request.Form("txtVatperc" & LCount))
												end if
												
												'Check the vat rates
												Select Case CInt(Request.Form("txtVatperc" & LCount))
												Case 0
													ZCount = ZCount + 1
													ZExCount = ZExCount + CDbl(Request.Form("hidTotalExcl" & LCount))
													ZVatCount = ZVatCount + CDbl(Request.Form("hidVatr" & LCount))
												Case 10
													TCount = TCount + 1
													TExCount = TExCount + CDbl(Request.Form("hidTotalExcl" & LCount))
													TVatCount = TVatCount + CDbl(Request.Form("hidVatr" & LCount))
												Case 14
													FCount = FCount + 1
													FExCount = FExCount + CDbl(Request.Form("hidTotalExcl" & LCount))
													FVatCount = FVatCount + CDbl(Request.Form("hidVatr" & LCount))
												End Select

												strXMLLine = strXMLLine & "<ILD>"
												strXMLLine = strXMLLine & "<LSNR>" & LCount & "</LSNR>" 
												strXMLLine = strXMLLine & "<OLSQ></OLSQ><PROC><EANC>" & Request.Form("txtBarCode" & LCount) & "</EANC>"
												strXMLLine = strXMLLine & "<EANC2>" & Request.Form("txtOrdCode" & LCount) & "</EANC2>"
												strXMLLine = strXMLLine & "<SUPC>" & Request.Form("txtProdCode" & LCount) & "</SUPC>" 
												strXMLLine = strXMLLine & "<PROD>" & Replace(Request.Form("txtDescr" & LCount),"/"," " ) & "</PROD>" 
												strXMLLine = strXMLLine & "</PROC>"
												strXMLLine = strXMLLine & "<QDEL>"
												strXMLLine = strXMLLine & "<NODU>" & Request.Form("txtQty" & LCount) & "</NODU>" 
												strXMLLine = strXMLLine & "<CUDU>" & Request.Form("txtSupPack" & LCount) & "</CUDU>" 
												strXMLLine = strXMLLine & "<TMEA></TMEA>"
												strXMLLine = strXMLLine & "<UNOM>" & Request.Form("txtMeasure" & LCount) & "</UNOM>" 
												strXMLLine = strXMLLine & "<BTCH></BTCH><SCNR></SCNR><DATE></DATE>"
												strXMLLine = strXMLLine & "</QDEL>"
												strXMLLine = strXMLLine & "<COST>"
												strXMLLine = strXMLLine & "<COSP>" & Request.Form("txtListCost" & LCount) & "</COSP>"
												strXMLLine = strXMLLine & "<CUCP></CUCP>"
												strXMLLine = strXMLLine & "<UNOM></UNOM>"
												strXMLLine = strXMLLine & "</COST>"
												strXMLLine = strXMLLine & "<CRAD>" & strCrad & "</CRAD>"
												strXMLLine = strXMLLine & "<NELC>" & Request.Form("hidTotalExcl" & LCount) & "</NELC>" 
												strXMLLine = strXMLLine & "<DCMD></DCMD>" 
												strXMLLine = strXMLLine & "<VATP>" & Request.Form("txtVatperc" & LCount) & "</VATP>" 
												strXMLLine = strXMLLine & "<VATC>" & Request.Form("hidVatCode" & LCount) & "</VATC>" 
												strXMLLine = strXMLLine & "<NCCP>" & Round(NetConsum,4) & "</NCCP>"
												strXMLLine = strXMLLine & "<CDNO><CNDN></CNDN><SDIR></SDIR><CNDN2></CNDN2><CNTP></CNTP><WHNG></WHNG><SREP></SREP><CREP></CREP></CDNO><CUSP></CUSP><CSDI></CSDI>"
												strXMLLine = strXMLLine & "<FRDL><NODU>" & Request.Form("txtFreeQty" & LCount) & "</NODU></FRDL><NARR></NARR>" 
												strXMLLine = strXMLLine & "</ILD>"
											
											Next
											
											strXMLHead = strXMLHead & strXMLLine 
											
											strXMLHead = strXMLHead & "<DLA><LSNR></LSNR><DRAD><ADJI1></ADJI1><PERC1></PERC1><VALU1></VALU1></DRAD><VATP></VATP><VATC></VATC><CSDI></CSDI></DLA>"
											
											' Loop through the VrsCount to generate the VRS segment
											For VCount = 0 to UBound(VrsArray)
												if VrsArray(VCount) <> "" then
													strCrad = ""
													strDrad = ""
													strSQL = ""
													strXMLVRS = strXMLVRS & "<VRS>"
													strXMLVRS = strXMLVRS & "<LSNR></LSNR>" 
													strXMLVRS = strXMLVRS & "<VATP>" & VrsArray(VCount) & "</VATP>" 
													if CStr(VrsArray(VCount)) = "10" or CStr(VrsArray(VCount)) = "14" then
														strXMLVRS = strXMLVRS & "<VATC>S</VATC>" 
													else
														strXMLVRS = strXMLVRS & "<VATC>Z</VATC>"
													end if
													
													Select Case CStr(VrsArray(VCount)) 
													Case "0"
														strXMLVRS = strXMLVRS & "<NRIL>" & ZCount & "</NRIL>"
														strXMLVRS = strXMLVRS & "<LSTA>" & ZExCount & "</LSTA>"
														strXMLVRS = strXMLVRS & "<VATA>" & ZVatCount & "</VATA>"
													Case "10"
														strXMLVRS = strXMLVRS & "<NRIL>" & TCount & "</NRIL>"
														strXMLVRS = strXMLVRS & "<LSTA>" & TExCount & "</LSTA>"
														strXMLVRS = strXMLVRS & "<VATA>" & TVatCount & "</VATA>"
													Case "14"
														strXMLVRS = strXMLVRS & "<NRIL>" & FCount & "</NRIL>"
														strXMLVRS = strXMLVRS & "<LSTA>" & FExCount & "</LSTA>"
														strXMLVRS = strXMLVRS & "<VATA>" & FVatCount & "</VATA>"
													End Select
													
													strXMLVRS = strXMLVRS & "<CRAD>"
													
													if Request.Form("rdDealOne") = "1" then
														strCrad = strCrad & "<ADJI1>T1</ADJI1><PERC1>" & Request.Form("txtDealOne") & "</PERC1><VALU1></VALU1>"
														strSQL = strSQL & ", @CDAdjIndicator1=" & MakeSQLText("T1")
														strSQL = strSQL & ", @CDPerc1=" & MakeSQLText(Request.Form("txtDealOne"))
														strSQL = strSQL & ", @CDValue1=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI1>T1</ADJI1><PERC1></PERC1><VALU1>" & Request.Form("txtCRAdjR1") & "</VALU1>"
														strSQL = strSQL & ", @CDAdjIndicator1=" & MakeSQLText("T1")
														strSQL = strSQL & ", @CDPerc1=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDValue1=" & MakeSQLText(Request.Form("txtCRAdjR1"))
													end if
													
													if Request.Form("rdDealTwo") = "1" then
														strCrad = strCrad & "<ADJI2>T2</ADJI2><PERC2>" & Request.Form("txtDealTwo") & "</PERC2><VALU2></VALU2>"
														strSQL = strSQL & ", @CDAdjIndicator2=" & MakeSQLText("T2")
														strSQL = strSQL & ", @CDPerc2=" & MakeSQLText(Request.Form("txtDealTwo"))
														strSQL = strSQL & ", @CDValue2=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI2>T2</ADJI2><PERC2></PERC2><VALU2>" & Request.Form("txtCRAdjR2") & "</VALU2>"
														strSQL = strSQL & ", @CDAdjIndicator2=" & MakeSQLText("T2")
														strSQL = strSQL & ", @CDPerc2=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDValue2=" & MakeSQLText(Request.Form("txtCRAdjR2"))
													end if
													
													if Request.Form("rdDealThree") = "1" then
														strCrad = strCrad & "<ADJI3>T3</ADJI3><PERC3>" & Request.Form("txtDealThree") & "</PERC3><VALU3></VALU3>"
														strSQL = strSQL & ", @CDAddDisInd=" & MakeSQLText("T3")
														strSQL = strSQL & ", @CDAddDiscPerc=" & MakeSQLText(Request.Form("txtDealThree"))
														strSQL = strSQL & ", @CDAddDiscValue=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI3>T3</ADJI3><PERC3></PERC3><VALU3>" & Request.Form("txtCRAdjR3") & "</VALU3>"
														strSQL = strSQL & ", @CDAddDisInd=" & MakeSQLText("T3")
														strSQL = strSQL & ", @CDAddDiscPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @CDAddDiscValue=" & MakeSQLText(Request.Form("txtCRAdjR3"))
													end if

													strXMLVRS = strXMLVRS & strCrad & "</CRAD>"
													strXMLVRS = strXMLVRS & "<DRAD>"
													
													if Request.Form("rdDealFour") = "1" then
														strDrad = strDrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealFour") & "</PERC1><VALU1></VALU1>"
														strSQL = strSQL & ", @TransportCstInc=" & MakeSQLText("")
														strSQL = strSQL & ", @TransportCstPerc=" & MakeSQLText(Request.Form("txtDealFour"))
														strSQL = strSQL & ", @TransportCstVal=" & MakeSQLText("0")
													else
														strDrad = strDrad & "<ADJI1></ADJI1><PERC1></PERC1><VALU1>" & Request.Form("txtDBAdjR1") & "</VALU1>"
														strSQL = strSQL & ", @TransportCstInc=" & MakeSQLText("")
														strSQL = strSQL & ", @TransportCstPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @TransportCstVal=" & MakeSQLText(Request.Form("txtDBAdjR1"))
													end if
													
													if Request.Form("rdDealFive") = "1" then
														strDrad = strDrad & "<ADJI2></ADJI2><PERC2>" & Request.Form("txtDealFive") & "</PERC2><VALU2></VALU2>"
														strSQL = strSQL & ", @DutLevIndc=" & MakeSQLText("")
														strSQL = strSQL & ", @DutLevPerc=" & MakeSQLText(Request.Form("txtDealFive"))
														strSQL = strSQL & ", @DutLevVal=" & MakeSQLText("0")
													else
														strDrad = strDrad & "<ADJI2></ADJI2><PERC2></PERC2><VALU2>" & Request.Form("txtDBAdjR2") & "</VALU2>"
														strSQL = strSQL & ", @DutLevIndc=" & MakeSQLText("")
														strSQL = strSQL & ", @DutLevPerc=" & MakeSQLText("0")
														strSQL = strSQL & ", @DutLevVal=" & MakeSQLText(Request.Form("txtDBAdjR2"))
													end if
													
													strXMLVRS = strXMLVRS & strDrad & "</DRAD><ESTA></ESTA><SEDA></SEDA>"
													
													strXMLVRS = strXMLVRS & "</VRS>"	
												end if
											Next

											strXMLHead = strXMLHead & strXMLVRS & "<IPD>"
											strXMLHead = strXMLHead & "<LNTA>" & Request.Form("hidTots1") & "</LNTA>" 
											strXMLHead = strXMLHead & "<TVAT>" & Request.Form("hidTots2") & "</TVAT>" 
											strXMLHead = strXMLHead & "<TPAY>" & Request.Form("hidTots3") & "</TPAY>"
											strXMLHead = strXMLHead & "<TMEA></TMEA><TNPC></TNPC>"
											strXMLHead = strXMLHead & "</IPD>"
											strXMLHead = strXMLHead & "<SDI>"
											strXMLHead = strXMLHead & "<LSNR></LSNR>"
											strXMLHead = strXMLHead & "<TSAM>" & Request.Form("txtSetTotExl") & "</TSAM>"
											strXMLHead = strXMLHead & "<SETT>"

											if Request.Form("rdSettle") = "1" then
												strSettle = strSettle & "<PERC>" & Request.Form("txtSettle") & "</PERC><VALU></VALU>"
												strSQLSettle = strSQLSettle & ", @SettleDisPerc=" & MakeSQLText(Request.Form("txtSettle"))
												strSQLSettle = strSQLSettle & ", @SettleDisVal=" & MakeSQLText("0")
											else
												strSettle = strSettle & "<PERC></PERC><VALU>" & Request.Form("txtSetTotExl") & "</VALU>"
												strSQLSettle = strSQLSettle & ", @SettleDisPerc=" & MakeSQLText("0")
												strSQLSettle = strSQLSettle & ", @SettleDisVal=" & MakeSQLText(Request.Form("txtSetTotExl"))
											end if

											strXMLHead = strXMLHead & strSettle & "<TERM></TERM>" 
											strXMLHead = strXMLHead & "</SETT>"
											strXMLHead = strXMLHead & "</SDI>"
											strXMLHead = strXMLHead & "</UNH></UNB>"
											
											' Sent the file on MQ to EDISwitch
											Call GenEDI (Request.Form("txtInvoiceNo"),replace(strXMLHead,"&","&amp;"),"C:\Inetpub\wwwroot\Spardev\dropship\downloads\")
											
											' Create a connection
											Set curConnection = Server.CreateObject ("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Now we have to add the data to the database
											' Build the SQL to add the 
											SQL = "exec addInvoice @InvoiceNumber=" & MakeSQLText(Request.Form("txtInvoiceNo")) & _
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
												", @ExtSubTotIncl=" & MakeSQLText(Request.Form("hidNettTotIncl")) & strSQLSettle

											'Response.Write SQL & "<br><br>"
											'Response.End
														
											' Execute the SQL
											Set ReturnSet = ExecuteSql(SQL, curConnection)
														
											' Check the returnvalue
											if ReturnSet("returnvalue") <> 0 then
												' An error occured - redirect the user back to the previous page
												Response.Redirect const_app_ApplicationRoot & "/track/dc/order/geninv.asp?item=" & Request.QueryString("item")
												Response.Flush
												'Response.Write const_app_ApplicationRoot & "/track/dc/order/geninv.asp?item=" & Request.QueryString("item")																								
											else
												' Set the new InvoiceId
												InvoiceID = ReturnSet("NewInvoiceID")
													
												' Close the Recordset
												Set ReturnSet = Nothing
													
												' Loop through the line items and add them to the database
												For LCount = 1 to Request.Form("hidTotalCount")

													LineSQL = ""														
														
													if Request.Form("rdTradeOne" & LCount) = "1" then
														strCrad = strCrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealpercOne" & LCount) & "</PERC1><VALU1></VALU1>"
														LineSQL = LineSQL & ", @AdjIndicator1=" & MakeSQLText("T1")
														LineSQL = LineSQL & ", @AdjPerc1=" & MakeSQLText(Request.Form("txtDealpercOne"))
														LineSQL = LineSQL & ", @AdjValue1=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI1></ADJI1></PERC1></PERC1><VALU1>" & Request.Form("txtDealpercOne" & LCount) & "</VALU1>"
														LineSQL = LineSQL & ", @AdjIndicator1=" & MakeSQLText("T1")
														LineSQL = LineSQL & ", @AdjPerc1=" & MakeSQLText("0")
														LineSQL = LineSQL & ", @AdjValue1=" & MakeSQLText(Request.Form("txtDealpercOne" & LCount))
													end if
														
													if Request.Form("rdTradeTwo" & LCount) = "1" then
														strCrad = strCrad & "<ADJI1></ADJI1><PERC1>" & Request.Form("txtDealpercTwo" & LCount) & "</PERC1><VALU1></VALU1>"
														LineSQL = LineSQL & ", @AdjIndicator2=" & MakeSQLText("T2")
														LineSQL = LineSQL & ", @AdjPerc2=" & MakeSQLText(Request.Form("txtDealpercTwo"))
														LineSQL = LineSQL & ", @AdjValue2=" & MakeSQLText("0")
													else
														strCrad = strCrad & "<ADJI1></ADJI1></PERC1></PERC1><VALU1>" & Request.Form("txtDealpercTwo" & LCount) & "</VALU1>"
														LineSQL = LineSQL & ", @AdjIndicator2=" & MakeSQLText("T2")
														LineSQL = LineSQL & ", @AdjPerc2=" & MakeSQLText("0")
														LineSQL = LineSQL & ", @AdjValue2=" & MakeSQLText(Request.Form("txtDealpercTwo" & LCount))
													end if
													
													' Build the SQL Statement
													SQL = "exec addInvoiceDetail	@InvoiceID=" & MakeSQLText(InvoiceID) & _
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
														", @FreeQty=" & MakeSQLText(Request.Form("txtFreeQty" & LCount))
															
													'Response.Write SQL & "<br>"
													' Execute the SQL
													Set ReturnSet = ExecuteSql(SQL, curConnection)
															
													' Close the recordset
													Set ReturnSet = Nothing
												Next
													
												' Close the Connection
												curConnection.Close
												Set curConnection = Nothing
												
												' Redirect the User to the Invoice display page
												Response.Redirect const_app_ApplicationRoot & "/track/dc/invoice/default.asp?item=" & InvoiceID & "&success=1"
												Response.Flush
												'Response.Write const_app_ApplicationRoot & "/track/dc/order/default.asp?item=" & Request.QueryString("item")
											end if
										'else
%>
<!--include file="../../../layout/start.asp"-->
<!--include file="../../../layout/title.asp"-->
<!--include file="../../../layout/headstart.asp"-->
<!--include file="../../../layout/globaljavascript.asp"-->
<!--<script type="text/javascript" language="JavaScript" src="../../../includes/calc.js"></script>
<script type="text/javascript" language="JavaScript" src="../../../includes/validation.js"></script>-->
<!--include file="../../../layout/headclose.asp"-->
<!--<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="<%=const_app_ApplicationRoot%>/layout/images/backgroud.gif" onload="calcTots();loadDefault();">
<p class="pcontent">An unexpected error occured.</p>-->
<!--include file="../../../layout/end.asp"-->
<%
	'									end if
%>