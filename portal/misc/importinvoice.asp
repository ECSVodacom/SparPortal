<%@ Language=VBScript %>
<%'OPTION EXPLICIT%>
<!--#include file="../includes/formatfunctions.asp"-->
<%
										dim curConnection
										dim FilePath
										dim CurrDate
										dim oFile
										dim Folder
										dim Files_Collection
										dim FileCount
										dim File
										dim FileName
										dim NewDate
										dim ReturnSet
										dim SQL
										dim objXML
										dim NewID
										dim LineItems
										dim LineCount
										dim FreeQty
										
										' Set the constants
										const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=TECHNICAL_03"
										const const_app_ApplicationRoot = "http://10.34.49.131/spar/dropship/"
										const const_app_Path = "C:\SparDS\"
										const const_app_ObjXML = "MSXML2.DomDocument"
										const const_app_NewMail = "CDONTS.NewMail"
										const const_app_MailCC = "hannes.kingsley@gatewaycomms.com;chris.kennedy@gatewaycomms.com"
										
										' Set the File Path and Name
										FilePath = const_app_Path & "Invoices\"
										
										' Get the current server date
										CurrDate = Replace(FormatDateTime(Date,2),"/","")
																				
										' Set the connection
										Set curConnection = Server.CreateObject ("ADODB.Connection")
										curConnection.Open const_db_ConnectionString
										
										' Creat the FileSystem Object
										Set oFile = CreateObject("Scripting.FileSystemObject")
	
										Set Folder = oFile.GetFolder(FilePath)
	
										' Get a collection of the files in this folder
										Set Files_Collection = Folder.Files
	
										' Check if there are files in the folder
										FileCount = Files_Collection.Count
	
										if Files_Collection.Count > 0 Then
											' loop through the files in the folder
											For each File in Files_Collection
												' Get the filename
												FileName = File.Name
												
												Response.Write "FileName = " & FileName & "<br>"
												
												' Replace all the asscci chars
												FileName = Replace(FileName,"&","&amp;")

												' Set the XML object
												'Set objXML = Server.CreateObject (const_app_XMLObject)
												Set objXML = Server.CreateObject ("MSXML2.DomDocument")
												objXML.async = false
												objXML.load (FilePath & FileName)

												' Get the list of UNH's
												Set UnhList = objXML.selectNodes("//UNB/UNH")
												
												Response.Write UnhList.Length & "<BR>"
												
												' Loop through the UNH List
												For UnhCount = 0 to UnhList.Length-1
												
													Response.Write "UNH " & UnhCount+1 & " = " & UnhCount+1 & "<br>"

													' Build the SQL to add the 
													SQL = "exec addInvoice @InvoiceNumber=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("IRE/INVR/REFN").text) & _
														", @OrderNumber=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU1").text) & _
														", @DCEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("CLO/COPT").text) & _
														", @SupplierEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text) & _
														", @StoreEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text) & _
														", @ReceivedDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/receivedate").text) & _
														", @TranslateDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/translatedate").text) & _
														", @PostDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/translatedate").text) & _
														", @CDAdjIndicator1=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI").text) & _
														", @CDPerc1=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC").text) & _
														", @CDValue1=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU").text) & _
														", @CDAdjIndicator2=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI2").text) & _
														", @CDPerc2=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC2").text) & _
														", @CDValue2=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU2").text) & _
														", @CDAddDisInd=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI3").text) & _
														", @CDAddDiscPerc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC3").text) & _
														", @CDAddDiscValue=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU3").text) & _
														", @TransportCstInc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI").text) & _
														", @TransportCstPerc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC").text) & _
														", @TransportCstVal=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU").text) & _
														", @DutLevIndc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI2").text) & _
														", @DutLevPerc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC2").text) & _
														", @DutLevVal=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU2").text) & _
														", @LnSubTotExl=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/LSTA").text) & _
														", @LnSubTotVat=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("VRS/VATA").text) & _
														", @ExtSubTotExl=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("IPD/LNTA").text) & _
														", @TotVat=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("IPD/TVAT").text) & _
														", @ExtSubTotIncl=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("IPD/TPAY").text) & _
														", @SettleDisPerc=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("SDI/SETT/PERC").text) & _
														", @SettleDisVal=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("SDI/SETT/VALU").text)

														Response.Write SQL & "<BR><br>"
														'Response.End
														
														' Execute the SQL
														Set ReturnSet = ExecuteSql(SQL, curConnection)
														
														' Check the returnvalue
														if ReturnSet("returnvalue") <> 0 then
															' An error occured - Write the file to an error folder
																														Response.Write ReturnSet("errormessage") & "<br><hr><br>"																														Set ReturnSet = Nothing
															' Check if the folder does not exist
'															if Not oFile.FolderExists(const_app_Path & "Errors\Orders\" & CurrDate) Then
																' Create the folder
'																oFile.CreateFolder (const_app_Path & "Errors\Orders\" & CurrDate)
'															end if
																	
															' Move the File to this folder
'															oFile.MoveFile const_app_Path & "Orders\" & FileName ,const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName
														else
															' No errors occured
															
															' Get the new InvoiceID
															NewID = ReturnSet("NewInvoiceID")
															
															' Close the recordset
															Set ReturnSet = Nothing
															
															' Get the list of line items
															Set LineItems = objXML.selectNodes("//UNB/UNH/ILD")
															
															' Loop throught he line items
															For LineCount = 0 to LineItems.Length-1
																if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("FRDL").text)) or Trim(LineItems.item(LineCount).selectSingleNode("FRDL").text) = "" then 
																	FreeQty = 0 
																else 
																	FreeQty = LineItems.item(LineCount).selectSingleNode("FRDL").text 
																end if
															
																' Build the SQL Statement
																SQL = "exec addInvoiceDetail	@InvoiceID=" & MakeSQLText(NewID) & _
																	", @ConsumerBarCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC").text) & _
																	", @ConsumerOrdUnit=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC2").text) & _
																	", @SupplProdCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text) & _
																	", @ProdDescription=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/PROD").text) & _
																	", @Qty=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QDEL/NODU").text) & _
																	", @SupplierPack=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QDEL/CUDU").text) & _
																	", @UnitOfMeasure=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QDEL/UNOM").text) & _
																	", @ListCost=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("COST/COSP").text) & _
																	", @AdjIndicator1=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI").text) & _
																	", @AdjPerc1=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/PERC").text) & _
																	", @AdjValue1=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/VALU").text) & _
																	", @AdjIndicator2=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI2").text) & _
																	", @AdjPerc2=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text) & _
																	", @AdjValue2=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("CRAD/VALU2").text) & _
																	", @NettValue=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("NELC").text) & _
																	", @VatPerc=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("VATP").text) & _
																	", @VatCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("VATC").text) & _
																	", @FreeQty=" & MakeSQLText(FreeQty)

																	Response.Write SQL & "<br><br>"
																	
																	' Execute the SQL
																	Set ReturnSet = ExecuteSql(SQL, curConnection)
																	
																	' Close the recordset
																	Set ReturnSet = Nothing
															Next
															
														end if
													Next 

												' Close the XML Object
												objXML.abort
												Set objXML = Nothing
											Next
										end if
										
										' Close the file system object
										Set Files_Collection = Nothing
										Set oFile = Nothing
										
										' Close the Connection
										curConnection.Close
										Set curConnection = Nothing
%>