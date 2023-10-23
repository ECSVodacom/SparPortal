<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function MakeSQLDate(DateToChange)

	dim TempDate
	
	If IsNull(DateToChange) OR DateToChange = "" then
		MakeSQLDate = "null"
	else
		MakeSQLDate = "'" & DateToChange & "'"
	end if
	
End Function

Function GetSuffix (OrdNum)

	' Check what suffix should be used
	Select Case CStr(OrdNum)
	Case "6001008999956"
		GetSuffix = "sNTH"
	Case "6001008999949"
		GetSuffix = "sERD"
	Case "6001008999963"
		GetSuffix = "sPLZ"
	Case "6001008999970"
		GetSuffix = "sCPT"
	Case "6001008999987"
		GetSuffix = "sNTL"
	Case Else
		GetSuffix = "sNTH"
	End Select

End Function

Function GenMail (FromAddress, ToAddress, CCAddress, BCcAddress, Subject, BodyText, Importance, MailFormat, BodyFormat)
	' This is a generic e-mail function
	
	dim oMail
	const const_app_NewMail = "CDONTS.NewMail"
	
	' Create the Mail Object
	Set oMail = CreateObject(const_app_NewMail)

	' Build the rest of the mail object properties
	oMail.From = FromAddress 
	oMail.To = ToAddress
	oMail.Cc = CCAddress
	oMail.BCc = BCcAddress
	oMail.Subject = Subject
	oMail.Body = BodyText
	oMail.Importance = Importance
	oMail.BodyFormat = BodyFormat
	oMail.MailFormat = MailFormat
	oMail.Send

	' Close the mail Object
	Set oMail = Nothing

End Function

'Function Main()
	dim oFile
	dim FolderName
	dim Folder
	dim Files_Collection
	dim FileCount
	dim File
	dim FileName
	dim FileText
	dim StrText
	dim objXML
	dim ArchiveDate
	dim OrderNumber
	dim InvoiceNumber
	dim SQL
	dim curConnection
	dim ReturnSet
	dim ErrorFlag
	dim XMLRef
	dim TaxItems
	dim TaxCount
	dim EANCNum
	dim CQuantity
	dim CCostPrice
	dim CNetPrice
	dim CheckXML
	dim LineItems
	dim LineCount
	dim BuyerMail
	dim BuyerCode
	dim XMLFolder
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPARNEW1\SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za"
	const const_app_Path = "F:\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailFrom = "spar.gatewayec.co.za"
	const const_app_Error = ""
	const const_app_MailCC = "sparmon@gatewaycomms.co.za; chris.kennedy@gatewaycomms.com"
	
	' Set the FolderName
	FolderName = const_app_Path & "SparTaxInvoice\"
	
	' Get the current server date
	ArchiveDate = Replace(FormatDateTime(Date,2),"/","")
	
	' Create the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	
	Set Folder = oFile.GetFolder(FolderName)
	
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
	
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
	
	if Files_Collection.Count > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name

			strBody = ""
			
			' Open the text file
			Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
			
			' Read the first line of the file
			StrText = "<UNB>" & FileText.ReadLine & "</UNB>"
			
			' close the File
			FileText.Close
			
			' Load the string into a dom document
			Set objXML = CreateObject(const_app_ObjXML)
			objXML.async = false
			
			if objXML.LoadXML(Replace(StrText,"&","&amp;")) = False Then
				' Check if the folder does not exist
				if Not oFile.FolderExists(const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate) Then
					' Create the folder
					oFile.CreateFolder (const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate)
				end if

				'Move the file to the errors folder
				oFile.MoveFile const_app_Path & "SparTaxInvoice\" & FileName ,const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName
				
				strBody = strBody & "E-DCINV  SPAR DC Invoice Error" & "<br><br>"
				strBody = strBody & "An error occured while trying to validate the following XML DC Invoice." & "<br>"
				strBody = strBody & "Unfortunately, no data can be extracted programatically from this file." & "<br><br>"
				strBody = strBody & "Additional information: " & "<br>"
				strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br><br>"
				strBody = strBody & "Solution" & "<br>"
				strBody = strBody & "Please refer this call directly to second line support (Technical Team)." & "<br><br>"
				strBody = strBody & "Technical reference: " & "<br>"
				strBody = strBody & "Invoice error file location: " & const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName & "<br><br>"
				
				' Call the GenMail function
				Call GenMail(const_app_MailFrom,const_app_MailCC,"","","SPAR DC Invoice Failure", strBody,1,0,0)
				
				Set objXML = Nothing

			else
				' Get the Receive and Translate dates
				ExtractDate = objXML.selectSingleNode("//UNB/UNH/extractdate").text
				ConfirmDate = objXML.selectSingleNode("//UNB/UNH/confirmdate").text
				UNHError = 0
				
				' Get a list of UNH's
				Set UnhList = objXML.selectNodes("//UNB/UNH")
				
				' Loop through the unh tags
				For UnhCount = 0 to UnhList.Length-1
					' Get the ordernumber, Supplier and BuyerID's
					if UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text = "6001299000010" then
						OrderNumber = UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU1").text & GetSuffix(UnhList.item(UnhCount).selectSingleNode("CLO/ALIP").text)
						DisplayOrder = UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU1").text
					else
						OrderNumber = UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU").text & GetSuffix(UnhList.item(UnhCount).selectSingleNode("CLO/CDPT").text)
						DisplayOrder = UnhList.item(UnhCount).selectSingleNode("ODD/ORNO/ORNU").text
					end if

					InvoiceNumber = UnhList.item(UnhCount).selectSingleNode("IRE/INVR/REFN").text
					SupplierEAN = UnhList.item(UnhCount).selectSingleNode("SAP/SAPT").text
			
					' Build the SQL
					SQL = "exec editTaxInvoice @OrderNumber='" & OrderNumber & "'" & _
						", @TaxInvoice='" & InvoiceNumber & "'" & _
						", @ExtractDate=" & MakeSQLDate(ExtractDate) & _
						", @ConfirmDate=" & MakeSQLDate(ConfirmDate) & _
						", @SupplierEAN=" & MakeSQLDate(SupplierEAN) 
						
						Response.write SQL & "<br>"
						response.end

					' Create the connection
					Set curConnection = CreateObject("ADODB.Connection")
					curConnection.Open const_db_ConnectionString
			
					' Execute the SP - itemHeaderDetail to get the header detail
					Set ReturnSet = ExecuteSql(SQL, curConnection)
			
					' Check the returnvalue
					if ReturnSet("returnvalue") <> 0 Then
						' An error occured - Set the error flag
						ErrorFlag = True

						UNHError = UNHError + 1
						
						strBody = strBody & "E-DCINV  " & ReturnSet("errormessage") & " " & Returnset("SupplierName") & "<br><br>"
						strBody = strBody & "The follwing error(s) occured while trying to import the following SPAR DC invoice(s):" & "<br>"
						strBody = strBody & "Error message: " & ReturnSet("errormessage") & "<br><br>"
						strBody = strBody & "Additional information: " & "<br>"
						strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
						strBody = strBody & "Supplier Name: " & Returnset("SupplierName") & "<br>"
						strBody = strBody & "Supplier EAN: " & Returnset("SupplierEAN") & "<br>"
						strBody = strBody & "Invoice Number: " & InvoiceNumber & "<br>"
						strBody = strBody & "Referenced Order Number: " & DisplayOrder & "<br><br>"
						strBody = strBody & "Solution" & "<br>"
						strBody = strBody & "The Order Number referenced in this invoice does not exist on the SPAR DB or the order number is older than 21 days." & "<br>"
						strBody = strBody & "Check EDISWITCH to determine the date the order was place by SPAR to this Supplier." & "<br>"
						strBody = strBody & "Notify the supplier about this problem." & "<br><br>"						
						strBody = strBody & "Technical reference: " & "<br>"
						strBody = strBody & "Invoice error file location: " & const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName & "<br><br>"
						
						' Call the GenMail function
						Call GenMail(const_app_MailFrom,const_app_MailCC,"","","SPAR DC Invoice Failure", strBody,1,0,0)
	
						Set objXML = Nothing
						
						Set ReturnSet = Nothing

					else
						' No error occured - Build the string for the xml
						' Get the xml reference for the origional order
						XMLRef = ReturnSet("XMLRef")
						XMLFolder = left(XMLRef,6)
						BuyerMail = ReturnSet("BuyerEMail")
						BuyerCode = ReturnSet("BuyerCode")
						SupplierName = ReturnSet("SupplierName")
	
						' Close the recordset
						Set ReturnSet = Nothing

						' Load the origional XML file into a dom document
						Set CheckXML = CreateObject(const_app_ObjXML)
						CheckXML.async = false

						'response.write const_app_Path & "SparOrders\" & XMLRef & "<br>"

						if  CheckXML.Load(const_app_Path & "SparOrders\" & XMLRef) = false then
							' An error occured - Set the error flag
							ErrorFlag = True
								
							UNHError = UNHError + 1
		
							strBody = strBody & "E-DCINV  Invoice did not import because the order referenced is to old or does not exist." & " " & SupplierName & "<br><br>"
							strBody = strBody & "The follwing error(s) occured while trying to import the following SPAR DC invoice(s):" & "<br>"
							strBody = strBody & "Error message: The Tax Invoice did not import because the order referenced is to old or does not exist.<br><br>"
							strBody = strBody & "Additional information: " & "<br>"
							strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
							strBody = strBody & "Supplier Name: " & SupplierName & "<br>"
							strBody = strBody & "Supplier EAN: " & SupplierEAN & "<br>"
							strBody = strBody & "Invoice Number: " & InvoiceNumber & "<br>"
							strBody = strBody & "Referenced Order Number: " & DisplayOrder & "<br><br>"
							strBody = strBody & "Solution" & "<br>"
							strBody = strBody & "The Order Number referenced in this invoice does not exist on the SPAR DB or the order number is older than 21 days." & "<br>"
							strBody = strBody & "Check EDISWITCH to determine the date the order was place by SPAR to this Supplier." & "<br>"
							strBody = strBody & "Notify the supplier about this problem." & "<br><br>"						
							strBody = strBody & "Technical reference: " & "<br>"
							strBody = strBody & "Invoice error file location: " & const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName & "<br><br>"
						
							' Call the GenMail function
							Call GenMail(const_app_MailFrom,const_app_MailCC,"","","SPAR DC Invoice Failure", strBody,1,0,0)
		
							Set objXML = Nothing
						else

							' Set the list of lone items for the origional order
							Set LineItems = CheckXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
						
							'Update the XML Doc
							CheckXML.selectSingleNode("//DOCUMENT/UNB/APRF").text = "Source Tax Invoice"
							CheckXML.selectSingleNode("//DOCUMENT/UNB/SOURCEREFERNCENUMBER").text = InvoiceNumber
						
							' Get the list of line items
							'Set TaxItems = objXML.selectNodes("//UNH/ILD")
							Set TaxItems = UnhList.item(UnhCount).selectNodes("ILD")
		
							' Loop through the line items
							For TaxCount = 0 to TaxItems.Length-1
								EANCNum = TaxItems.item(TaxCount).selectSingleNode("PROC/EANC").text
								EANC2Num = TaxItems.item(TaxCount).selectSingleNode("PROC/EANC2").text
								ProdCode = TaxItems.item(TaxCount).selectSingleNode("PROC/SUPC").text
								CQuantity = TaxItems.item(TaxCount).selectSingleNode("QDEL/NODU").text	
								CCostPrice = TaxItems.item(TaxCount).selectSingleNode("COST/COSP").text
								CNetPrice = TaxItems.item(TaxCount).selectSingleNode("NELC").text
							
								' Set the SQL Statement
								SQL = "exec procTaxInvoice @OrderNumber='" & OrderNumber & "'" & _
									", @EANNumber='" & EANCNum & "'" & _
									", @EAN2Number='" & EANC2Num & "'" & _
									", @ProdCode='" & ProdCode & "'" & _
									", @Quantity='" & CQuantity & "'" & _
									", @CostPrice='" & CCostPrice & "'" & _
									", @NetCost='" & CNetPrice & "'"
								
								'response.write SQL & "<br>"
								'Response.End
								
								' Execute the SQL
								Set ReturnSet = ExecuteSql(SQL, curConnection)
										
								' Check the returnvalue
								if ReturnSet("returnvalue") = 0 Then
									' Loop through this line item collection
									For LineCount = 0 to LineItems.Length-1
									' Check if the EANCNum exists in this XML Doc
										if EANCNum = LineItems.item(LineCount).selectSingleNode("PROC/EANC").text OR EANC2Num = LineItems.item(LineCount).selectSingleNode("PROC/EANC2").text OR ProdCode = LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text Then
											' Update the origional XML doc with the status, quantity, costprice and netprice
											LineItems.item(LineCount).setAttribute "status", "Confirmed"
											LineItems.item(LineCount).selectSingleNode("QNTO/NROUC").text = CQuantity
											LineItems.item(LineCount).selectSingleNode("COST/COSPC").text = CCostPrice
											LineItems.item(LineCount).selectSingleNode("NELCC").text = CNetPrice
										end if
									Next
								end if	
								
								Set ReturnSet = Nothing

							Next
						
							' Save the XML Back to the directory
							CheckXML.save(const_app_Path & "SparOrders\" & XMLRef)

							' Close the XMLObject
							Set CheckXML = Nothing	
						end if	
						
						'Set ReturnSet = Nothing		

					end if
					
					if Not ErrorFlag Then
						' Write the Tax Invoice to an archive directory
						' Now we need to send the buyer a notification e-mail
						' Build the BodyText
						BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>"
						BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>" 
						BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation(s) was/were received:</font></p>" 
						BodyText = BodyText & "<p><font face='Arial' size='2'><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & XMLFolder & "\" & Trim(OrderNumber) & ".xml&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></font></p>"
						BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"

						'Response.Write BodyText & "<br>"

						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
	
						' Build the rest of the mail object properties
						objMail.From = const_app_MailFrom
						objMail.To = BuyerMail
						objMail.BCc = const_app_MailTo
						objMail.Subject = "Purchase Order Notification - Order " & DisplayOrder & " - Supplier " & SupplierName & " - Buyer " & CStr(BuyerCode)
						objMail.Importance = 2
						objMail.Body = BodyText
						objMail.MailFormat = 0
						objMail.BodyFormat = 0
						objMail.Send
	
						' Close the mail Object
						Set objMail = Nothing
					end if
				Next
			end if
			
			if UNHError > 0 Then
				' Check if the folder does not exist
				if Not oFile.FolderExists(const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate) Then
					' Create the folder
					oFile.CreateFolder (const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate)
				end if
												
				' Move the File to this folder
				oFile.MoveFile const_app_Path & "SparTaxInvoice\" & FileName ,const_app_Path & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName
			else
				if oFile.FileExists(const_app_Path & "SparTaxInvoice\" & FileName) then
					' Delete the file
					oFile.DeleteFile const_app_Path & "SparTaxInvoice\" & FileName
				end if
			end if
			
			'Response.Write strBody
			
		Next
	end if
	
	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing
	

'	Main = DTSTaskExecResult_Success
'End Function
%>