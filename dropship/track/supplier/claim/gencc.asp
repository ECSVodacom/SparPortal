<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<!--#include file="../../../includes/constants.asp"-->
<!--#include file="../../../includes/logincheck.asp"-->
<!--#include file="../../../includes/formatfunctions.asp"-->
<!--#include file="../../../includes/xmlfunctions.asp"-->
<!--#include file="../includes/MQToSwitch.asp"-->
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
										dim result
										dim ClaimID
										dim DisplaySet
										dim Display
										dim strAddr
										dim dispAddr
										dim Count
										dim IsXML
										dim errMes
										dim CCID
										dim CCClaimID
										dim ReturnSet
										dim i
										dim strGoods
										dim strReason
										dim sResult
										
										errMes = ""
										
										if Request.Form("hidAction") = "1" then
											' The user requested to submit the credit note
											
											' Create a connection
											Set curConnection = Server.CreateObject("ADODB.Connection")
											curConnection.Open const_db_ConnectionString
											
											' Add the credit note to the database
											SQL = "exec addCreditNote @StoreEAN=" & MakeSQLText(Request.Form("hidStoreEAN")) & _
												", @DCEAN=" & MakeSQLText(Request.Form("hidDCEAN")) & _
												", @SupplierEAN=" & MakeSQLText(Request.Form("hidSupplierEAN")) & _
												", @CNNumber=" & MakeSQLText(Request.Form("txtCCNum")) & _
												", @CNDate=" & MakeSQLText(Year(now()) & "/" & Month(now()) & "/" & Day(now())) & _
												", @ReceivedDate=" & MakeSQLText(Year(now()) & "/" & Month(now()) & "/" & Day(now()) & " " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now())) & _
												", @TransDate=" & MakeSQLText(Year(now()) & "/" & Month(now()) & "/" & Day(now()) & " " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now())) & _
												", @ClaimQty=1"
												
											'Response.Write SQL & "<br>"
											'Response.End
												
											Set ReturnSet = ExecuteSql(SQL, curConnection)
													
											if ReturnSet("returnvalue") <> 0 then
												errMes = ReturnSet("errormessage")
											else
												CCID = ReturnSet("UniqueCNID")	
													
												Set ReturnSet = nothing
												
												SQL = "exec editCreditNoteExtra @CreditNoteID=" & CCID & _
													", @TotCostExcl=" & Replace(Request.Form("txtAmtExcl"), ",","") & _
													", @TotVat=" & Replace(Request.Form("txtTotVat"),",","") & _
													", @TotCostIncl=" & Replace(Request.Form("txtTotIncl"), ",", "") & _
													", @TradeIndc1=" & MakeSQLText("") & _
													", @TradePerc1=" & Request.Form("txtDisc1") & _
													", @TradeAmt1=0" & _
													", @TradeIndc2=" & MakeSQLText("") & _
													", @TradePerc2=" & Request.Form("txtDisc2") & _
													", @TradeAmt2=0" & _
													", @TransportIndc=" & MakeSQLText("") & _
													", @TransportPerc=" & Request.Form("txtDisc3") & _
													", @TransportAmt=0" & _
													", @DutyIndc=" & MakeSQLText("") & _
													", @DutyPerc=0" & _
													", @DutyAmt=0"
													
												'Response.Write SQL &"<br>"
												'Response.End
													
												Set ReturnSet = ExecuteSql(SQL, curConnection)
												
												If ReturnSet("returnvalue") <> 0 then
													errMes = ReturnSet("errormessage")
												else
													SQL = "exec addCreditNoteClaim @CNID=" & CCID & _
													", @RefType=" & MakeSQLText(Request.Form("hidType")) & _
													", @ClaimNumber=" & MakeSQLText(Request.Form("hidClaimNum")) & _
													", @ClaimDate=" & MakeSQLText(Request.Form("hidClaimDate")) & _
													", @InvNumber=" & MakeSQLText(Request.Form("hidInvNum")) & _
													", @InvDate=" & MakeSQLText(Request.Form("hidInvDate")) & _
													", @ManClaimNum=" & MakeSQLText(Request.Form("hidManNum")) & _
													", @ManClaimDate=" & MakeSQLText(Request.Form("hidManDate")) & _
													", @NumLines=" & Request.Form("hidLines")
												
													'Response.Write SQL & "<br>"
												
													Set ReturnSet = ExecuteSql(SQL, curConnection)
															
													if ReturnSet("returnvalue") <> 0 then
														errMes = ReturnSet("errormessage")
													else
														CCClaimID = ReturnSet("UniqueCLaimID")
																
														Set ReturnSet = Nothing
														
														SQL = "exec editCreditNoteClaimExtra @CreditNoteClaimID=" & CCClaimID & _
															", @TotCostExcl=" & Replace(Request.Form("txtAmtExcl"),",","") & _
															", @TotVat=" & Replace(Request.Form("txtTotVat"),",","") & _
															", @TotCostIncl=" & Replace(Request.Form("txtTotIncl"),",","")
															
														Set ReturnSet = ExecuteSql(SQL, curConnection)
														
														if ReturnSet("returnvalue") <> 0 then
															errMes = ReturnSet("errormessage")
														else
															Set ReturnSet = Nothing
																
															for i = 1 to Request.Form("hidLines")
																SQL = "exec addCreditNoteClaimLine @CNClaimID=" & CCClaimID & _
																	", @LineSeq=" & i & _
																	", @ReasonCode=" & MakeSQLText(Request.Form("drpReason" & i)) & _
																	", @GoodsRetCode=" & MakeSQLText(Request.Form("drpGoods" & i)) & _
																	", @NetCost=" & Request.Form("txtSubTot" & i) & _
																	", @VatPerc=14" & _
																	", @VatCode=S" & _
																	", @DiscountMethod=" & MakeSQLText("") & _
																	", @ClaimLineSeq=" & i & _
																	", @InvLineSeq=0" & _
																	", @OrderUnit=" & MakeSQLText(Request.Form("txtProdEAN" & i)) & _
																	", @ProdCode=" & MakeSQLText(Request.Form("txtProdCode" & i)) & _
																	", @ProdDescr=" & MakeSQLText(Request.Form("txtProdDescr" & i)) & _
																	", @NumUnits=" & Request.Form("txtQty" & i) & _
																	", @ConsumUnit=0" & _
																	", @ConsumUnitRet=0" & _
																	", @TotMeasure=0" & _
																	", @UOM=" & MakeSQLText(Request.Form("txtUOM" & i)) & _
																	", @CostPrice=" & Request.Form("txtUnitPrice" & i) & _
																	", @ConsumUnitPerCost=0" & _
																	", @DiscIndc1=" & MakeSQLText("") & _
																	", @DiscPerc1=" & Request.Form("txtDeal1Perc" & i) & _
																	", @DiscAmt1=" & 0 & _
																	", @DiscIndc2=" & MakeSQLText("") & _
																	", @DiscPerc2=" & Request.Form("txtDeal2Perc" & i) & _
																	", @DiscAmt2=" & 0 & _
																	", @Nar=" & MakeSQLText(Request.Form("txtNarr" & i)) & _
																	", @TotalAmountExcl=" & CDbl(Request.Form("txtSubTot" & i)) - (CDbl(Request.Form("txtSubTot" & i)) * CDbl(Request.Form("txtVat" & i))) & _
																	", @TotVat=" & Request.Form("txtVat" & i)
																
																'Response.Write SQL & "<br>"
																'Response.End
																
																Set ReturnSet = ExecuteSql(SQL, curConnection)
																
																Set ReturnSet = Nothing
															next
															
															' Generate the XML file to be translated
															SQL = "exec itemCreditNoteClaim @CCID=" & CCID
															
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
															XSLDoc.Load(server.MapPath("../includes/gencreditxml.xsl"))
																
															'Set up the resulting document.
															Set result = Server.CreateObject(const_app_XMLObject)
															result.async = False
															result.validateOnParse = True
																                           
															' Parse results into a result DOM Document.
															Display = XMLDoc.transformNodeToObject(XSLDoc, result)
															
															result.save const_app_CreditNotePath & "cn_" & Request.Form("txtCCNum") & ".xml"

															'Call MqToSwitch (MQPath, File, Ref)
															sResult = MqToSwitch(const_app_CreditNotePath, "cn_" & Request.Form("txtCCNum") & ".xml", Request.Form("txtCCNum"))
															
															'Response.Write sResult
														
															Response.Redirect const_app_ApplicationRoot & "/track/supplier/creditnote/default.asp?item=" & CCID
															Response.Flush
														end if
													end if
												end if  
											end if
										end if
										
										if Request.QueryString("item") = "" then
											ClaimID = 0
										else
											ClaimID = Request.QueryString("item")
										end if
										
										' Check if this is an XML User
										if IsNumeric(Session("ProcEAN")) then
											IsXML = 0
										else
											IsXML = 1
										end if
										
										' Biuld the SQL Statement for orders
										SQL = "exec itemClaim @ClaimID=" & ClaimID & _
											", @IsXML=" & IsXML
											
										'Response.Write SQL
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
										XSLDoc.Load(Server.MapPath("gencc.xsl"))

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
										'DisplaySet = Replace(DisplaySet,"@@CCNum",Year(now()) & Month(now()) & Day(now()) & Hour(now()) & Minute(now()) & Second(now()))
										DisplaySet = Replace(DisplaySet,"@@CCNum","")
										DisplaySet = Replace(DisplaySet,"@@CCDate",Year(now()) & "/" & LZ(Month(now())) & "/" & LZ(Day(now())))
										DisplaySet = Replace(DisplaySet,"@@Address",dispAddr)
										DisplaySet = Replace(DisplaySet,"@@ClaimID",ClaimID)
										
										' Create a connection
										Set curConnection = Server.CreateObject("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										Set Returnset = ExecuteSql("listReason", curConnection)  
										
										While not Returnset.EOF
											strReason = strReason & "<option value=" & chr(34) & Returnset("ReasonCode") & chr(34) & ">" & Returnset("ReasonDescr") & "</option>"
											
											Returnset.MoveNext
										Wend
										
										Set Returnset = nothing
										
										Set Returnset = ExecuteSql("listGoodsReason", curConnection)  
										
										While not Returnset.EOF
											strGoods = strGoods & "<option value=" & chr(34) & Returnset("ReasonCode") & chr(34) & ">" & Returnset("ReasonDescr") & "</option>"
											
											Returnset.MoveNext
										Wend
										
										Set Returnset = nothing
										
										curConnection.close
										
										DisplaySet = Replace(DisplaySet,"@@ReasonOption",strReason)
										DisplaySet = Replace(DisplaySet,"@@GoodsOption",strGoods)
										
										if errMes <> "" then
											DisplaySet = Replace(DisplaySet,"@@Error","<p class=""error"">An error occured while trying to submit your request. Please try again.</p>")
										else
											DisplaySet = Replace(DisplaySet,"@@Error","")
										end if
%>
<!--#include file="../../../layout/start.asp"-->
<!--#include file="../../../layout/title.asp"-->
<!--#include file="../../../layout/headstart.asp"-->
<!--#include file="../../../layout/globaljavascript.asp"-->
<script language="javascript">
<!--
	function validate(obj) {
		if (obj.txtCCNum.value=='') {
			window.alert ('You have to supply your unique credit note reference number.');
			obj.txtCCNum.focus();
			return false;
		};
	};
//-->
</script>
<!--#include file="../../../layout/headclose.asp"-->
<body bgcolor="#FFFFFF" text="#000000" leftmargin="10" topmargin="10" marginwidth="10" marginheight="10" background="">
<%
										' Write the XMLString 
										Response.Write DisplaySet
%>
<!--#include file="../../../layout/end.asp"-->
