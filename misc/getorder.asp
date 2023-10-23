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

Function GetDC (DCID)

	' Check what suffix should be used
	Select Case CStr(DCID)
	Case "6001008999956"
		GetDC = "Spar North Rand"
	Case "6001008999949"
		GetDC = "Spar South Rand"
	Case "6001008999963"
		GetDC = "Spar Eastern Cape"
	Case "6001008999970"
		GetDC = "Spar Western Cape"
	Case "6001008999987"
		GetDC = "Spar Kwazulu Natal"
	Case Else
		GetDC = "Spar North Rand"
	End Select
End Function


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
	dim SQL
	dim curConnection
	dim ReturnSet
	dim SupplierEAN
	dim BuyerEAN
	dim BuyerCode
	dim ErrorFlag
	dim SPID
	dim BRID
	dim TrackID
	dim LineItem
	dim LineCounter
	dim SupplierEMail
	dim BuyerName
	dim BuyerEMail
	dim OrderPoint
	dim objMail
	dim BodyText
	dim NumExist
	dim StrSubject
	dim ErrorMessage
	dim objGetFile
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	const const_app_Path = "D:\"
	const const_app_ObjXML = "Microsoft.XMLDom"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "ckennedy@gatewaycomms.co.za;dviviers@gatewaycomms.co.za"
	
	' Set the FolderName
	FolderName = const_app_Path & "SparIn\"
	
	' Get the current server date
	ArchiveDate = Replace(FormatDateTime(Date,2),"/","")
	
	' Creat the FileSystem Object
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
			
			' Get the File
			Set objGetFile = oFile.GetFile(FolderName & FileName)		

			' Check if the file size is greater than 0
			if objGetFile.Size > 0 Then

				' Open the text file
				Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
				
				' Read the first line of the file
				StrText = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><DOCUMENT><UNB>" & FileText.ReadLine & "</UNB></DOCUMENT>"
				
				StrText = Replace(StrText,"&","&amp;")
				StrText = Replace(StrText,"/",chr(47))
	
				' close the File
				FileText.Close
				
				' Load the string into a dom document
				Set objXML = CreateObject(const_app_ObjXML)
				objXML.async = false
				
				' Determine if this is a valid XML file]
				if objXML.LoadXML(StrText) = False Then
					' Not valid XML file - Write the file to the SparErrors folder
					' Check if the folder does not exist
					if Not oFile.FolderExists(const_app_Path & "SparErrors\Orders\" & ArchiveDate) Then
						' Create the folder
						oFile.CreateFolder (const_app_Path & "SparErrors\Orders\" & ArchiveDate)
					end if
							
					' Save the File to this folder
					'objXML.save(const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName)
					oFile.MoveFile const_app_Path & "SparIn\" & FileName ,const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName
				
					' Remove the file from the SparIn Forlder
					'oFile.DeleteFile const_app_Path & "SparIn\" & FileName,true
		
					' Close the XML object
					Set objXML = Nothing
	
					' Create the Mail Object
					Set objMail = CreateObject(const_app_NewMail)
	
					' Build the rest of the mail object properties
					objMail.From = "spar@gatewayec.co.za" 
					objMail.To = "dviviers@firstnet.co.za"
					objMail.Cc = "ckennedy@firstnet.co.za"
					objMail.Subject = "Spar Order Error"
					objMail.Importance = 2
					objMail.Body = "Invalid XML Order. Source File: " & const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName
					objMail.BodyFormat = 1
					objMail.MailFormat = 1
					objMail.Send
	
					' Close the mail Object
					Set objMail = Nothing
	
				else
					' This is a valid XML file - Continue
					' Get the ordernumber, Supplier and BuyerID's
					OrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & GetSuffix(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text)
					SupplierEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/SOP/SOPT").text
					BuyerEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text
					BuyerCode = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
					OrderPoint = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPN").text
		
					' Build the SQL
					SQL = "exec itemHeadDetail_New @SupplierEAN='" & SupplierEAN & "'" & _
						", @BuyerCode='" & BuyerCode & "'" & _
						", @OrderNumber='" & OrderNumber & "'" & _
						", @CompanyID='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text & "'" & _
						", @BuyerMail='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/NAR/NARR").text & "'"
		Response.Write SQL & "<BR><br>"
					' Create the connection
					Set curConnection = CreateObject("ADODB.Connection")
					curConnection.Open const_db_ConnectionString
				
					' Execute the SP - itemHeaderDetail to get the header detail
					Set ReturnSet = ExecuteSql(SQL, curConnection)
				
					' Check the returnvalue
					if Returnset("returnvalue") <> 0 Then
						' An error occured - Set the error flag
						ErrorFlag = True
		
						' Remove the file from the folder and move it to the Error folder
						' Check if the folder does not exist
						if Not oFile.FolderExists(const_app_Path & "SparErrors\Orders\" & ArchiveDate) Then
							' Create the folder
							oFile.CreateFolder (const_app_Path & "SparErrors\Orders\" & ArchiveDate)
						end if
							
						' Save the File to this folder
						objXML.save(const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & OrderNumber & ".xml")
				
						' Remove the file from the SparIn Forlder
						oFile.DeleteFile const_app_Path & "SparIn\" & FileName,true
		
	
						Select Case ReturnSet("returnvalue")
						Case "-1003"
							ErrorMessage = "The Supplier " & SupplierEAN & " does not exist in the system."
						Case "-1004"
							ErrorMessage = "The BuyerCode " & BuyerCode & "  for DC " & BuyerEAN & " does not exist in the system."
	
						End Select
	
						' Close the XML object
						Set objXML = Nothing
	
						' Close the XML object
						Set objXML = Nothing
		
						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
		
						' Build the rest of the mail object properties
						objMail.From = "spar@gatewayec.co.za" 
						objMail.To = "dviviers@gatewaycomms.co.za"
						objMail.Cc = "ckennedy@gatewaycomms.co.za"
						objMail.Subject = "Spar Order Error"
						objMail.Importance = 2
						objMail.Body = ErrorMessage & " - Source File: " & const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & OrderNumber & ".xml"
						objMail.BodyFormat = 1
						objMail.MailFormat = 1
						objMail.Send
		
						' Close the mail Object
						Set objMail = Nothing
					else
						' No error occured - Build the string for the xml
						' Get the Buyer and supplier auto ID
						SPID = ReturnSet("SpID")
						BRID = ReturnSet("BrID")
						SupplierEMail = ReturnSet("SupplierMail")
						BuyerName = ReturnSet("DCName")
						BuyerEMail = ReturnSet("BuyerEMail")
						NumExist = ReturnSet("NumExist")
		
						' Close the XML object
						Set objXML = Nothing
						
						' Open the text file
						Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
				
						' Read the first line of the file
						StrText = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><DOCUMENT><UNB>" 
						StrText = StrText & "<APRF></APRF>"
						StrText = StrText & "<SOURCEREFERNCENUMBER></SOURCEREFERNCENUMBER>"
						StrText = StrText & "<Sender>"
						StrText = StrText & "<SenderID>" & BuyerID & "</SenderID>"
						StrText = StrText & "<SenderAddress>" & ReturnSet("BuyerAddress") & ", " & ReturnSet("BuyerPostAddr") & "</SenderAddress>"
						StrText = StrText & "<SenderTel>" & "Phone: " & ReturnSet("BuyerTelNum") & " Fax: " & ReturnSet("BuyerFaxNum") & "</SenderTel>"
						StrText = StrText & "<SenderReg>" & ReturnSet("DCName") &  "  " & ReturnSet("BuyerRegNum") & "</SenderReg>"
						StrText = StrText & "</Sender>"
						StrText = StrText & "<Receiver>"
						StrText = StrText & "<ReceiverID>" & SupplierID & "</ReceiverID>"
						StrText = StrText & "<ReceiverAddress>" & ReturnSet("SupplierName") & ", " & ReturnSet("SupplierAddress") & "</ReceiverAddress>"
						StrText = StrText & "</Receiver>"
						StrText = StrText & "<SNRF>" & OrderNumber & "</SNRF>"
						StrText = StrText & FileText.ReadLine & "</UNB></DOCUMENT>"
				
						' close the File
						FileText.Close	
						
						' Write the file to an archive directory
						' Check if the folder does not exist
						if Not oFile.FolderExists(const_app_Path & "SparOrders\" & ArchiveDate) Then
							' Create the folder
							oFile.CreateFolder (const_app_Path & "SparOrders\" & ArchiveDate)
						end if
						
						' Load the string into a dom document
						Set objXML = CreateObject(const_app_ObjXML)
						objXML.async = false
						objXML.LoadXML(Replace(StrText,"&","&amp;"))
		
						' Update the <DIN> tag detail
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/NARR1").text = "THE SPAR GROUP LTD. CO. " & ReturnSet("BuyerRegNum")
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/NARR2").text = ReturnSet("BuyerVatNum")
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/RDIN").text = ReturnSet("BuyerAddress")
		
						if NumExist = 1 then
							' Update the confirmdate tag
							objXML.selectSingleNode("//DOCUMENT/UNB/UNH/confirmdate").text = Year(Date) & Right(FormatDateTime(Date,0),6) & " " & FormatDateTime(Now,3)
						end if
	
						' Save XML File to the new folder
						objXML.save(const_app_Path & "SparOrders\" & ArchiveDate & "\" & OrderNumber & ".xml")
						
						' Remove the file from the SparIn Forlder
						oFile.DeleteFile const_app_Path & "SparIn\" & FileName,true
						
						' Close the recordset
						Set ReturnSet = Nothing
						
						' Add or update the order to trackTrace table
						SQL = "exec editTrackTrace @OrderNumber='" & OrderNumber & "'" & _
							", @SupplierID=" & SPID & _
							", @SupplierCode='" & SupplierEAN & "'" & _
							", @BuyerID=" & BRID & _
							", @BuyerCode='" & BuyerCode & "'" & _
							", @DeliveryDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/EDAT").text) & _
							", @TransCode='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/TRCE/TRCD").text & "'" & _
							", @ReceiveDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/recievedate").text) & _
							", @EDIDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/translatedate").text) & _
							", @MailBoxDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/translatedate").text) & _
							", @ExtractDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/extractdate").text) & _
							", @ConfirmDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/confirmdate").text) & _
							", @XMLRef='" & ArchiveDate & "\" & OrderNumber & ".xml" & "'" & _
							", @Edit=" & NumExist
							
							Response.Write SQL & "<br><br>"
		
						' Execute the SQL 
						Set ReturnSet = ExecuteSql(SQL, curConnection)
						
						' Check the returnvalue
						if ReturnSet("returnvalue") <> 0 Then
							' An error occured - Close the recordset
							Set ReturnSet = Nothing
						else
							' No error occured - Continue to add the line item details
							' Get the new TrackID
							TrackID = ReturnSet("TrackID")
							
							' Close the recordset
							Set ReturnSet = Nothing
							
							' Get a list of all the line item details
							Set LineItem = objXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
							
							' Loop through the line item details and insert into the database
							For LineCounter = 0 to LineItem.Length-1
								' Build the SQL Statement				
								SQL = "exec editOrderLineDetail @OrderNumber='" & OrderNumber & "'" & _
									", @TrackID=" & TrackID & _
									", @LineNumber=" & LineItem.item(LineCounter).getAttribute("id") & _
									", @ConsumerEanc='" & LineItem.item(LineCounter).selectSingleNode("PROC/EANC").text & "'" & _
									", @OrderEanc='" & LineItem.item(LineCounter).selectSingleNode("PROC/EANC2").text & "'" & _
									", @SupplProdCode='" & LineItem.item(LineCounter).selectSingleNode("PROC/SUPC").text & "'" & _
									", @SupplOrderPoint='" & OrderPoint & "'" & _
									", @Description='" & LineItem.item(LineCounter).selectSingleNode("PROC/PROD").text & "'" & _
									", @Quantity='" & LineItem.item(LineCounter).selectSingleNode("QNTO/NROU").text & "'" & _
									", @ConfirmQuantity='" & LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text & "'" & _
									", @ConsumerUnitPerOrd='" & LineItem.item(LineCounter).selectSingleNode("QNTO/CONU").text & "'" & _
									", @VendorPack='" & LineItem.item(LineCounter).selectSingleNode("QNTO/TMEA").text & "'" & _
									", @UnitOfMeasure='" & LineItem.item(LineCounter).selectSingleNode("QNTO/UNOM").text & "'" & _
									", @CostPrice='" & LineItem.item(LineCounter).selectSingleNode("COST/COSP").text & "'" & _
									", @ConfirmCostPrice='" & LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text & "'" & _
									", @UnitsPerCostPrice='" & LineItem.item(LineCounter).selectSingleNode("COST/CUCP").text & "'" & _
									", @DiscountIndicator1='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI1").text & "'" & _
									", @DiscountPerc1='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC1").text & "'" & _
									", @DiscountValue1='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU1").text & "'" & _
									", @DiscountIndicator2='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI2").text & "'" & _
									", @DiscountPerc2='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text & "'" & _
									", @DiscountValue2='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text & "'" & _
									", @DiscountIndicator3='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI3").text & "'" & _
									", @DiscountPerc3='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text & "'" & _
									", @DiscountValue3='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text & "'" & _
									", @DiscountIndicator4='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI4").text & "'" & _
									", @DiscountPerc4='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC4").text & "'" & _
									", @DiscountValue4='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU4").text & "'" & _
									", @DiscountIndicator5='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI5").text & "'" & _
									", @DiscountPerc5='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC5").text & "'" & _
									", @DiscountValue5='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU5").text & "'" & _
									", @DiscountIndicator6='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI6").text & "'" & _
									", @DiscountPerc6='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC6").text & "'" & _
									", @DiscountValue6='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU6").text & "'" & _
									", @DiscountIndicator7='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI7").text & "'" & _
									", @DiscountPerc7='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC7").text & "'" & _
									", @DiscountValue7='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU7").text & "'" & _
									", @DiscountIndicator8='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI8").text & "'" & _
									", @DiscountPerc8='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC8").text & "'" & _
									", @DiscountValue8='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU8").text & "'" & _
									", @DiscountIndicator9='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI9").text & "'" & _
									", @DiscountPerc9='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC9").text & "'" & _
									", @DiscountValue9='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU9").text & "'" & _
									", @DiscountIndicator10='" & LineItem.item(LineCounter).selectSingleNode("CRAD/ADJI10").text & "'" & _
									", @DiscountPerc10='" & LineItem.item(LineCounter).selectSingleNode("CRAD/PERC10").text & "'" & _
									", @DiscountValue10='" & LineItem.item(LineCounter).selectSingleNode("CRAD/VALU10").text & "'" & _
									", @NetCost='" & LineItem.item(LineCounter).selectSingleNode("NELC").text & "'" & _
									", @DiscountMethod='" & LineItem.item(LineCounter).selectSingleNode("DCMD").text & "'" & _
									", @SpecialDealIndicator='" & LineItem.item(LineCounter).selectSingleNode("CDNO/SDIR").text & "'" & _
									", @FreeNrou='" & LineItem.item(LineCounter).selectSingleNode("FREE/NROU").text & "'" & _
									", @ContractNumber='" & LineItem.item(LineCounter).selectSingleNode("CDNO/CNDN").text & "'" & _
									", @ContratType='" & LineItem.item(LineCounter).selectSingleNode("CDNO/CNTP").text & "'" & _
									", @WhereNigotiated='" & LineItem.item(LineCounter).selectSingleNode("CDNO/WHNG").text & "'" & _
									", @SupplRep='" & LineItem.item(LineCounter).selectSingleNode("CDNO/SREP").text & "'" & _
									", @CustRep='" & LineItem.item(LineCounter).selectSingleNode("CDNO/CREP").text & "'" & _
									", @ConsumerUnitPrice='" & LineItem.item(LineCounter).selectSingleNode("CUSP").text & "'" & _
									", @FreeConsumerEanc='" & LineItem.item(LineCounter).selectSingleNode("FREE/EANC").text & "'" & _
									", @FreeOrderEanc='" & LineItem.item(LineCounter).selectSingleNode("FREE/EANC").text & "'" & _
									", @FreeNumOrdUnits='" & LineItem.item(LineCounter).selectSingleNode("FREE/EANC").text & "'" & _
									", @FreeSupplProdCode='" & LineItem.item(LineCounter).selectSingleNode("FREE/SUPC").text & "'" & _
									", @FreeConsumerUnitPerOrder='" & LineItem.item(LineCounter).selectSingleNode("FREE/CONU").text & "'" & _
									", @FreeTotalMeasure='" & LineItem.item(LineCounter).selectSingleNode("FREE/TMEA").text & "'" & _
									", @FreeUnitMeasure='" & LineItem.item(LineCounter).selectSingleNode("FREE/UNOM").text & "'" & _
									", @FreeProdDesc='" & LineItem.item(LineCounter).selectSingleNode("FREE/PROD").text & "'" & _
									", @ToFollowIndicator='" & LineItem.item(LineCounter).selectSingleNode("TFIN").text & "'" & _
									", @Narrative='" & LineItem.item(LineCounter).selectSingleNode("NARR").text & "'" & _
									", @ProdStyle='" & LineItem.item(LineCounter).selectSingleNode("PROQ/STYE").text & "'" & _
									", @ProdColour='" & LineItem.item(LineCounter).selectSingleNode("PROQ/COLR").text & "'" & _  
									", @ProdSize='" & LineItem.item(LineCounter).selectSingleNode("PROQ/SIZE").text & "'" & _  
									", @VatRatePerc='" & LineItem.item(LineCounter).selectSingleNode("VATP").text & "'" & _ 
									", @VatRateCode='" & LineItem.item(LineCounter).selectSingleNode("VATC").text & "'" & _ 
									", @OrdConfirmCode='" & LineItem.item(LineCounter).selectSingleNode("OCCD").text & "'" & _ 
									", @PayLineSeqNum='" & LineItem.item(LineCounter).selectSingleNode("//DOCUMENT/UNB/UNH/PRA/LSNR").text & "'" & _ 
									", @CreditAdjustmentIndicator='" & LineItem.item(LineCounter).selectSingleNode("//DOCUMENT/UNB/UNH/PRA/CRAD/ADJI1").text & "'" & _ 
									", @CreditAdjustmentPerc='" & LineItem.item(LineCounter).selectSingleNode("//DOCUMENT/UNB/UNH/PRA/CRAD/PERC1").text & "'" & _ 
									", @CreditAdjustmentValue='" & LineItem.item(LineCounter).selectSingleNode("//DOCUMENT/UNB/UNH/PRA/CRAD/VALU1").text & "'" & _ 
									", @TermsPayment='" & LineItem.item(LineCounter).selectSingleNode("//DOCUMENT/UNB/UNH/PRA/TERM").text & "'" & _
									", @Comments='" & "" & "'" & _
									", @Edit=" & NumExist
		
									' Execute the SQL
									Set ReturnSet = ExecuteSql(SQL, curConnection)
									
									' Close the recordset
									Set ReturnSet = Nothing						
								Next
								
								' Now we need to send a notification e-mail
								' Determine if we should send a notification to the buyer or supplier
								if NumExist = 0 Then
									' Build the subject line and BodyText for the supplier
									StrSubject = "Purchase Order " & Mid(OrderNumber,1,len(OrderNumber)-4) & " from " & GetDC(BuyerEAN)
									
									if IsNumeric(SupplierEAN) Then
										BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>" 
										BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>Purchase Order " & Mid(OrderNumber,1,len(OrderNumber)-4) & " was sent from " & GetDC(BuyerEAN) & " and has been placed in your mailbox.</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"
									else
										BodyText = "<html><body><p><font face='Arial' size='2'>Please note that you will need a XML capable browser like Microsoft Internet Explorer 5 to view the Purchase Order.</font></p>" 
										BodyText = BodyText & "<p><ul><li><font face='Arial' size='2'>Click on the link below to view the Purchase Order.</font></li>"
										BodyText = BodyText & "<li><font face='Arial' size='2'>Make the necessary adjustments and click the 'Save/Send Message' button.</font></li></ul></p>"
										BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/supplier/default.asp?id=" & ArchiveDate & "\" & OrderNumber & ".xml&type=2" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/supplier/default.asp</a></p>" 
										BodyText = BodyText & "<p><font face='Arial' size='2'>***********************************************************************</font></p>" 
										BodyText = BodyText &  "<p><font face='Arial' size='2'>This email, has an extention of @spar.co.za and is therefore considered a business record and is therefore property of The Spar Group Ltd.</font></p>"
										BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"
									end if
	
									' Create the Mail Object
									Set objMail = CreateObject(const_app_NewMail)
					
									' Build the rest of the mail object properties
									objMail.From = BuyerEMail 
									objMail.To = SupplierEMail
									objMail.BCc = const_app_MailCC
									objMail.Subject = StrSubject
									objMail.Importance = 2
									objMail.Body = BodyText
									objMail.BodyFormat = 0
									objMail.MailFormat = 0
									objMail.Send
					
									' Close the mail Object
									Set objMail = Nothing
								else
									' Build the subject line and BodyText for the buyer
									StrSubject = "Purchase Order Notifications ( For Buyer Code: " & BuyerCode & " )"
									
									BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>"
									BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation was received:</font></p>"
									BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & ArchiveDate & "\" & OrderNumber & ".xml&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"
	
									' Create the Mail Object
									Set objMail = CreateObject(const_app_NewMail)
					
									' Build the rest of the mail object properties
									objMail.From = SupplierEMail
									objMail.To = BuyerEMail 
									objMail.BCc = const_app_MailCC
									objMail.Subject = StrSubject
									objMail.Importance = 2
									objMail.Body = BodyText
									objMail.BodyFormat = 0
									objMail.MailFormat = 0
									objMail.Send
					
									' Close the mail Object
									Set objMail = Nothing
								end if
						end if
					end if
				
					' Close the recordset and connection
					curConnection.Close
					Set curConnection = Nothing
				end if
			end if
		Next
	end if
	
	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing

%>
