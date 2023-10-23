<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function MakeSQLText(TextToChange)

	dim TempDate
	
	If IsNull(TextToChange) OR TextToChange = "" then
		MakeSQLText = "null"
	else
		MakeSQLText = "'" & TextToChange & "'"
	end if
	
End Function

'Function Main ()

	ScriptTimeout = 2000000


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
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=SPARNEW1\SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/dropship/"
	const const_app_Path = "F:\SparDS\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailFrom = "spar.gatewayec.co.za/"
	const const_app_MailTo = "chris.kennedy@vodacom.co.za"
	const const_app_MailCC = "petrus.daffue@vodacom.co.za"
	
	' Set the File Path and Name
	FilePath = const_app_Path & "Invoices\"
	
	' Get the current server date
	CurrDate = Replace(FormatDateTime(Date,2),"/","")
											
	' Set the connection
	Set curConnection = CreateObject ("ADODB.Connection")
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

			' Get the File
			Set objGetFile = oFile.GetFile(FilePath & FileName)	

			if objGetFile.Size > 0 Then

				' Open the text file
				Set FileText = oFile.OpenTextFile(FilePath & FileName,1,false)

				' Read the first line of the file
				StrText = FileText.ReadLine

				StrText = Replace(StrText,"&","&amp;")
				StrText = Replace(StrText,"/",chr(47))

				' close the File
				FileText.Close

				' Set the XML object
				Set objXML = CreateObject ("MSXML2.DomDocument")
				objXML.async = false
				
				if objXML.loadXML (StrText) = False Then
					' This is not a valid XML file - generate an e-mail
					' Check if the folder does not exist
					if Not oFile.FolderExists(const_app_Path & "Errors\Invoices\" & CurrDate) Then
						' Create the folder
						oFile.CreateFolder (const_app_Path & "Errors\Invoices\" & CurrDate)
					end if
									
					' Move the File to this folder
					oFile.MoveFile const_app_Path & "Invoices\" & FileName ,const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
						
					' Create the Mail Object
					Set objMail = CreateObject(const_app_NewMail)

					' Build the rest of the mail object properties
					objMail.From = const_app_MailFrom 
					objMail.To = const_app_MailCc
					objMail.Subject = "SparDrop Shipment Invoice Error"
					objMail.Importance = 2
					objMail.Body = "Invalid XML Invoice - Source File: " & const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
					objMail.BodyFormat = 1
					objMail.MailFormat = 1
					objMail.Send

					' Close the mail Object
					Set objMail = Nothing
				else
					' Get the Receive and Translate dates
					ReceiveDate = objXML.selectSingleNode("//UNB/UNH/translatedate").text
					TranslateDate = objXML.selectSingleNode("//UNB/UNH/translatedate").text
					ConfirmDate = objXML.selectSingleNode("//UNB/UNH/confirmdate").text

					If ReceiveDate = "" Then
						ReceiveDate = now()
					End If

					If TranslateDate = "" Then
						TranslateDate = now()
					End If

					If ConfirmDate = "" Then
						ConfirmDate = now()
					End If
					
					' Get the list of UNH's
					Set UnhList = objXML.selectNodes("//UNB/UNH")
					
					' Loop through the UNH List
					For UnhCount = 0 to UnhList.Length-1
						
						Error = 0
						UNHError = 0
						
						' Determine if this is a live store - Build the SQL Statement
						Set ReturnSet = ExecuteSql("procCheckLiveStore @StoreEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text), curConnection)   
															
						' Check the returnvalue
						if ReturnSet("returnvalue") <> 0 Then
							' Close the recordset
							Set ReturnSet = Nothing
																
							'Response.Write UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text & " Not Live" & "<br>"
																
						else
							' Close the recordset
							Set ReturnSet = Nothing
																
							'Response.Write UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text & " Live" & "<br>"
						
							OrderNumber = Replace(UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU1").text,"'", " ")
							InvoiceNumber = UnhList.item(UnhCount).selectSingleNode("IRE/INVR/REFN").text
						
							'Response.Write "OrderNumber = " & OrderNumber & "<br>"
							'Response.Write "InvoiceNumber = " & InvoiceNumber & "<br>"
							
							'Response.End
							
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/ADJI").length = 0 then
								CDADJI = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI").text) then
									CDADJI = 0
								else
									CDADJI = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI").text
								end if
							end if
							
							if  UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/PERC").length = 0 then
								CDPerc1 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC").text) then
									CDPerc1 = 0
								else
									CDPerc1 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/VALU").length = 0 then
								CDValue1 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU").text) then
									CDValue1 = 0
								else
									CDValue1 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/ADJI2").length = 0 then
								CDADJI2 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI2").text) then
									CDADJI2 = 0
								else
									CDADJI2 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI2").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/PERC2").length = 0 then
								CDPerc2 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC2").text) then
									CDPerc2 = 0
								else
									CDPerc2 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC2").text
								end if
							end if
		
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/VALU2").length = 0 then
								CDValue2 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU2").text) then
									CDValue2 = 0
								else
									CDValue2 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU2").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/ADJI3").length = 0 then
								CDADJI3 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC3").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI3").text) then
									CDADJI3 = 0
								else
									CDADJI3 = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/ADJI3").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/PERC3").length = 0 then
								CDAddDiscPerc = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC3").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC3").text) then
									CDAddDiscPerc = 0
								else
									CDAddDiscPerc = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/PERC3").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/CRAD/VALU3").length = 0 then
								CDAddDiscValue = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU3").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU3").text) then
									CDAddDiscValue = 0
								else
									CDAddDiscValue = UnhList.item(UnhCount).selectSingleNode("VRS/CRAD/VALU3").text
								end if
							end if
							
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/ADJI").length = 0 then
								DTADJI = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI").text) then
									DTADJI = 0
								else
									DTADJI = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI").text
								end if
							end if
							
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/PERC").length = 0 then
								TransportCstPerc = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC").text) then
									TransportCstPerc = 0
								else
									TransportCstPerc = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/VALU").length = 0 then
								TransportCstVal = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU").text) then
									TransportCstVal = 0
								else
									TransportCstVal = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/ADJI2").length = 0 then
								DTADJI2 = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI2").text) then
									DTADJI2 = 0
								else
									DTADJI2 = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/ADJI2").text
								end if
							end if
		
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/PERC2").length = 0 then
								DutLevPerc = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC2").text) then
									DutLevPerc = 0
								else
									DutLevPerc = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/PERC2").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/DRAD/VALU2").length = 0 then
								DutLevVal = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU2").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU2").text) then
									DutLevVal = 0
								else
									DutLevVal = UnhList.item(UnhCount).selectSingleNode("VRS/DRAD/VALU2").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("SDI/SETT/PERC").length = 0 Then
								SettleDisPerc = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("SDI/SETT/PERC").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("SDI/SETT/PERC").text) Then
									SettleDisPerc = 0
								else
									SettleDisPerc = UnhList.item(UnhCount).selectSingleNode("SDI/SETT/PERC").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("SDI/SETT/VALU").length = 0 Then
								SettleDisVal = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("SDI/SETT/VALU").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("SDI/SETT/VALU").text) Then
									SettleDisVal = 0
								else
									SettleDisVal = UnhList.item(UnhCount).selectSingleNode("SDI/SETT/VALU").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/LSTA").length = 0 Then
								LnSubTotExl = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/LSTA").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/LSTA").text) Then
									LnSubTotExl = 0
								else
									LnSubTotExl = UnhList.item(UnhCount).selectSingleNode("VRS/LSTA").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("VRS/VATA").length = 0 Then
								LnSubTotVat = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("VRS/VATA").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("VRS/VATA").text) Then
									LnSubTotVat = 0
								else
									LnSubTotVat = UnhList.item(UnhCount).selectSingleNode("VRS/VATA").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("IPD/LNTA").length = 0 Then
								ExtSubTotExl = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("IPD/LNTA").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("IPD/LNTA").text)Then
									ExtSubTotExl = 0
								else
									ExtSubTotExl = UnhList.item(UnhCount).selectSingleNode("IPD/LNTA").text
								end if
							end if

							if UnhList.item(UnhCount).getElementsByTagName("IPD/TVAT").length = 0 Then
								TotVat = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("IPD/TVAT").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("IPD/TVAT").text) Then
									TotVat = 0
								else
									TotVat = UnhList.item(UnhCount).selectSingleNode("IPD/TVAT").text
								end if
							end if
						
							if UnhList.item(UnhCount).getElementsByTagName("IPD/TPAY").length = 0 Then
								ExtSubTotIncl = 0
							else
								if UnhList.item(UnhCount).selectSingleNode("IPD/TPAY").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("IPD/TPAY").text) Then
									ExtSubTotIncl = 0
								else
									ExtSubTotIncl = UnhList.item(UnhCount).selectSingleNode("IPD/TPAY").text
								end if
							end if

							if UnhList.item(UnhCount).selectSingleNode("ODD/DELR/DATE").text = "" then
								DelivDate = ""
							else
								DelivDate = UnhList.item(UnhCount).selectSingleNode("ODD/DELR/DATE").text
								DelivDate = "20" & mid(DelivDate, 1, 2) & "/" & mid(DelivDate, 3, 2) & "/" & mid(DelivDate, 5, 2)
							end if

							if UnhList.item(UnhCount).selectSingleNode("IRE/INVR/DATE1").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("IRE/INVR/DATE1").text) then
								InvDate = ""
							else
								InvDate = UnhList.item(UnhCount).selectSingleNode("IRE/INVR/DATE1").text
								InvDate = "20" & mid(InvDate, 1, 2) & "/" & mid(InvDate, 3, 2) & "/" & mid(InvDate, 5, 2)
							end if

							'if UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text = "" or isNull(UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text) then
							if TypeName(UnhList.item(UnhCount).selectSingleNode("SAP/SAPT")) = "IXMLDOMElement" then
								SupplierEAN = UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text
							else
								SupplierEAN = UnhList.item(UnhCount).selectSingleNode("SDP/SUDP").text
							end if

							response.write SupplierEAN
							response.end

							' Build the SQL to add the 
							SQL = "exec addInvoice @InvoiceNumber=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("IRE/INVR/REFN").text) & _
								", @InvoiceDate=" & MakeSQLText(InvDate) & _
								", @OrderNumber=" & MakeSQLText(OrderNumber) & _
								", @DCEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("CLO/ALIP").text) & _
								", @SupplierEAN=" & MakeSQLText(SupplierEAN) & _
								", @StoreEAN=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text) & _
								", @ReceivedDate=" & MakeSQLText(ReceiveDate) & _
								", @TranslateDate=" & MakeSQLText(TranslateDate) & _
								", @PostDate=" & MakeSQLText(ConfirmDate) & _
								", @CDAdjIndicator1=" & MakeSQLText(CDADJI) & _
								", @CDPerc1=" & MakeSQLText(CDPerc1) & _
								", @CDValue1=" & MakeSQLText(CDValue1) & _
								", @CDAdjIndicator2=" & MakeSQLText(CDADJI2) & _
								", @CDPerc2=" & MakeSQLText(CDPerc2) & _
								", @CDValue2=" & MakeSQLText(CDValue2) & _
								", @CDAddDisInd=" & MakeSQLText(CDADJI3) & _
								", @CDAddDiscPerc=" & MakeSQLText(CDAddDiscPerc) & _
								", @CDAddDiscValue=" & MakeSQLText(CDAddDiscValue) & _
								", @TransportCstInc=" & MakeSQLText(DTADJI) & _
								", @TransportCstPerc=" & MakeSQLText(TransportCstPerc) & _
								", @TransportCstVal=" & MakeSQLText(TransportCstVal) & _
								", @DutLevIndc=" & MakeSQLText(DTADJI2) & _
								", @DutLevPerc=" & MakeSQLText(DutLevPerc) & _
								", @DutLevVal=" & MakeSQLText(DutLevVal) & _
								", @LnSubTotExl=" & MakeSQLText(LnSubTotExl) & _
								", @LnSubTotVat=" & MakeSQLText(LnSubTotVat) & _
								", @ExtSubTotExl=" & MakeSQLText(ExtSubTotExl) & _
								", @TotVat=" & MakeSQLText(TotVat) & _
								", @ExtSubTotIncl=" & MakeSQLText(ExtSubTotIncl) & _
								", @SettleDisPerc=" & MakeSQLText(SettleDisPerc) & _
								", @SettleDisVal=" & MakeSQLText(SettleDisVal) & _
								", @DelivDate=" & MakeSQLText(DelivDate) & _
								", @AuthNo=" & MakeSQLText(UnhList.item(UnhCount).selectSingleNode("ODD/CDNO/CNDN").text) 
								
								Response.Write SQL & "<br><br>"
								'Response.End

								' Execute the SQL
								Set ReturnSet = ExecuteSql(SQL, curConnection)
							
								' Check the returnvalue
								if ReturnSet("returnvalue") <> 0 then
									' An error occured - Write the file to an error folder
									' Check if the folder does not exist
									'if Not oFile.FolderExists(const_app_Path & "Errors\Invoices\" & CurrDate) Then
										' Create the folder
									'	oFile.CreateFolder (const_app_Path & "Errors\Invoices\" & CurrDate)
									'end if
											
									' Move the File to this folder
									'oFile.MoveFile const_app_Path & "Invoices\" & FileName ,const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
									
									Error = Error + 1
									UNHError = UNHError + 1
									
									' Create the Mail Object
									Set objMail = CreateObject(const_app_NewMail)

									' Build the rest of the mail object properties
									objMail.From = const_app_MailFrom 
									objMail.To = const_app_MailCc
									objMail.Subject = "SparDrop Shipment Invoice Error"
									objMail.Importance = 2
									objMail.Body = ReturnSet("errormessage") & " - Invoice Number: " & CStr(InvoiceNumber) & " - Source File: " & const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
									objMail.BodyFormat = 1
									objMail.MailFormat = 1
									objMail.Send

									' Close the mail Object
									Set objMail = Nothing
									
									' Close the Recordset
									Set ReturnSet = Nothing
								else
									' No errors occured
									' Get the new InvoiceID
									NewID = ReturnSet("NewInvoiceID")
									SupplierName = ReturnSet("SupplierName")
									StoreMail = ReturnSet("StoreMail")
									
									'Response.Write "NewID = " & NewID & "<br>"
									'Response.Write "SupplierName = " & SupplierName & "<br>"
									'Response.Write "StoreMail = " & StoreMail & "<br><br>"
									
									' Close the recordset
									Set ReturnSet = Nothing

									' Get the list of line items
									Set LineItems = UnhList.item(UnhCount).selectNodes("ILD")
									
									' Loop throught he line items
									For LineCount = 0 to LineItems.Length-1
										if LineItems.item(LineCount).getElementsByTagName("FRDL").length = 0 then
											FreeQty = 0 
										else
											if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("FRDL").text)) or Trim(LineItems.item(LineCount).selectSingleNode("FRDL").text) = "" then 
												FreeQty = 0 
											else 
												FreeQty = LineItems.item(LineCount).selectSingleNode("FRDL").text 
											end if	
										end if
		
										if LineItems.item(LineCount).getElementsByTagName("QDEL/NODU").length = 0 then
											Qty = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("QDEL/NODU").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("QDEL/NODU").text)) then
												Qty = 0
											else
												Qty = LineItems.item(LineCount).selectSingleNode("QDEL/NODU").text
											end if
										end if

										if LineItems.item(LineCount).getElementsByTagName("COST/COSP").length = 0 then
											ListCost = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("COST/COSP").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("COST/COSP").text)) then
												ListCost = 0
											else
												ListCost = LineItems.item(LineCount).selectSingleNode("COST/COSP").text
											end if
										end if
										
										if LineItems.item(LineCount).getElementsByTagName("CRAD/ADJI").length = 0 then
											Adj1 = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI").text)) then
												Adj1 = 0
											else
												Adj1 = LineItems.item(LineCount).selectSingleNode("CRAD/ADJI").text
											end if
										end if
										
										if LineItems.item(LineCount).getElementsByTagName("CRAD/PERC").length = 0 then
											AdjPerc1 = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC").text)) then
												AdjPerc1 = 0
											else
												AdjPerc1 = LineItems.item(LineCount).selectSingleNode("CRAD/PERC").text
											end if
										end if
										
										if LineItems.item(LineCount).getElementsByTagName("CRAD/VALU").length = 0 then
											AdjValue1 = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/VALU").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/VALU").text)) then
												AdjValue1 = 0
											else
												AdjValue1 = LineItems.item(LineCount).selectSingleNode("CRAD/VALU").text
											end if
										end if
										
										if LineItems.item(LineCount).getElementsByTagName("CRAD/ADJI2").length = 0 then
											Adj2 = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI2").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/ADJI2").text)) then
												Adj2 = 0
											else
												Adj2 = LineItems.item(LineCount).selectSingleNode("CRAD/ADJI2").text
											end if
										end if
										
										if LineItems.item(LineCount).getElementsByTagName("CRAD/PERC2").length = 0 then
											AdjPerc2 = 0 
										else							
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text)) then
												AdjPerc2 = 0
											else
												AdjPerc2 = LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text
											end if
										end if

										if LineItems.item(LineCount).getElementsByTagName("CRAD/VALU2").length = 0 then
											AdjValue2 = 0 
										else
											if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/VALU2").text) = "" or IsNull(Trim(LineItems.item(LineCount).selectSingleNode("CRAD/VALU2").text)) then
												AdjValue2 = 0
											else
												AdjValue2 = LineItems.item(LineCount).selectSingleNode("CRAD/VALU2").text
											end if
										end if
			
										if LineItems.item(LineCount).getElementsByTagName("NELC").length = 0 then
											Nelc = 0 
										else
											if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("NELC").text)) or Trim(LineItems.item(LineCount).selectSingleNode("NELC").text)= "" then 
												Nelc = 0 
											else 
												Nelc = LineItems.item(LineCount).selectSingleNode("NELC").text 
											end if	
										end if

										if LineItems.item(LineCount).getElementsByTagName("VATP").length = 0 then
											Vatp = 0 
										else
											if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("VATP").text)) or Trim(LineItems.item(LineCount).selectSingleNode("VATP").text) = "" then 
												Vatp = 0 
											else 
												Vatp = LineItems.item(LineCount).selectSingleNode("VATP").text 
											end if	
										end if

										if LineItems.item(LineCount).getElementsByTagName("VATC").length = 0 then
											Vatc = 0 
										else
											if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("VATC").text)) or Trim(LineItems.item(LineCount).selectSingleNode("VATC").text) = "" then 
												Vatc = 0 
											else 
												Vatc = LineItems.item(LineCount).selectSingleNode("VATC").text 
											end if	
										end if
										
										'Response.Write "Qty = " & Qty & "<br>"
										'Response.Write "ListCost = " & ListCost & "<br>"
					
										' Build the SQL Statement
										SQL = "exec addInvoiceDetail	@InvoiceID=" & MakeSQLText(NewID) & _
											", @ConsumerBarCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC").text) & _
											", @ConsumerOrdUnit=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC2").text) & _
											", @SupplProdCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text) & _
											", @ProdDescription=" & MakeSQLText(Replace(LineItems.item(LineCount).selectSingleNode("PROC/PROD").text,"'", " " )) & _
											", @Qty=" & MakeSQLText(Qty) & _
											", @SupplierPack=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QDEL/CUDU").text) & _
											", @UnitOfMeasure=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QDEL/UNOM").text) & _
											", @ListCost=" & MakeSQLText(ListCost) & _
											", @AdjIndicator1=" & MakeSQLText(Adj1) & _
											", @AdjPerc1=" & MakeSQLText(AdjPerc1) & _
											", @AdjValue1=" & MakeSQLText(AdjValue1) & _
											", @AdjIndicator2=" & MakeSQLText(Adj2) & _
											", @AdjPerc2=" & MakeSQLText(AdjPerc2) & _
											", @AdjValue2=" & MakeSQLText(AdjValue2) & _
											", @NettValue=" & MakeSQLText(Nelc) & _
											", @VatPerc=" & MakeSQLText(Vatp) & _
											", @VatCode=" & MakeSQLText(Vatc) & _
											", @FreeQty=" & MakeSQLText(FreeQty)
											
											Response.Write SQL & "<br><br>"
											response.end
											
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
											
										' Close the recordset
										Set ReturnSet = Nothing
									Next
								end if
							
								' Check if there are any errors
								if UNHError = 0 Then
									' Generate their bodytext for the Store notification
									BodyText = "An SPAR Drop Shipment Electronic Invoice was generated and added to Track and Trace. Invoice Details below: " & VbCrLf & VbCrLf
									BodyText = BodyText & "From Supplier: " & SupplierName & VbCrLf
									BodyText = BodyText & "Invoice Number: " & InvoiceNumber & VbCrLf  
									BodyText = BodyText & "Order Number: " & OrderNumber & VbCrLf & VbCrLf  
									BodyText = BodyText & "Click on the link below to log onto the Track and Trace Facility to view the Invoice Details." & VbCrLf & VbCrLf  
									BodyText = BodyText & const_app_ApplicationRoot & VbCrLf & VbCrLf  
									BodyText = BodyText & "***********************************************************************" & VbCrLf & VbCrLf  
									BodyText = BodyText & "This email, has an extention of @spar.co.za and is therefore considered a business record and is therefore property of The Spar Group Ltd." & VbCrLf & VbCrLf  
									BodyText = BodyText & "Thank You"	
									
									'Response.Write BodyText & "<br>"														

									' Create the Mail Object
									'Set objMail = CreateObject(const_app_NewMail)

									' Build the rest of the mail object properties
									'objMail.From = const_app_MailFrom 
									'objMail.To = StoreMail
									'objMail.To = const_app_MailTo
									'objMail.BCc = const_app_MailCC
									'objMail.Subject = "SPAR Drop Shipment Invoice Notification: From Supplier - " & SupplierName
									'objMail.Importance = 2
									'objMail.Body = BodyText
									'objMail.BodyFormat = 1
									'objMail.MailFormat = 1
									'objMail.Send

									' Close the mail Object
									'Set objMail = Nothing
								end if
						end if
					Next

					if Error > 0 Then
						' Check if the folder does not exist
						if Not oFile.FolderExists(const_app_Path & "Errors\Invoices\" & CurrDate) Then
							' Create the folder
							oFile.CreateFolder (const_app_Path & "Errors\Invoices\" & CurrDate)
						end if
						
						if oFile.FileExists(const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName)  then
							oFile.DeleteFile const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
						end if
				
						' Move the File to this folder
						oFile.MoveFile const_app_Path & "Invoices\" & FileName ,const_app_Path & "Errors\Invoices\" & CurrDate & "\" & FileName
					else
						' Delete the file
						oFile.DeleteFile const_app_Path & "Invoices\" & FileName
					end if
				end if
				
				' Close the XML Object
				objXML.abort
				Set objXML = Nothing
			else
				' Delete the file
				oFile.DeleteFile const_app_Path & "Invoices\" & FileName
			end if
		Next
	end if
	
	' Close the file system object
	Set Files_Collection = Nothing
	Set oFile = Nothing
	
	' Close the Connection
	curConnection.Close
	Set curConnection = Nothing

'	Main = DTSTaskExecResult_Success
'End Function
%>