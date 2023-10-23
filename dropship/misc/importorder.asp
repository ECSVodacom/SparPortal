<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function MakeSQLText(TextToChange)

	dim TempDate
	
	If IsNull(TextToChange) OR TextToChange = "" then
		MakeSQLText = "''"
	else
		MakeSQLText = "'" & TextToChange & "'"
	end if
	
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
	const const_appMailFrom = "spar.gatewayec.co.za/"
	const const_app_MailCC = "hannes.kingsley@gatewaycomms.com; chris.kennedy@gatewaycomms.com; sparmon@gatewaycomms.co.za"
	const const_app_Error = "atg@gatewaycomms.com"
	
	' Set the File Path and Name
	FilePath = const_app_Path & "Orders\"
		
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
	
			' Open the text file
			Set FileText = oFile.OpenTextFile(Folder & "\" & FileName,1,false)
				
			' Read the first line of the file
			StrText = FileText.ReadLine
				
			StrText = Replace(StrText,"&","&amp;")
			StrText = Replace(StrText,"/",chr(47))
			
			' Close the File
			Set FileText = Nothing
	
			' Set the XML object
			Set objXML = CreateObject("MSXML2.DomDocument")
			objXML.async = false

			if objXML.LoadXML(StrText) = False Then				
				' This is not a valid XML file - generate an e-mail
				' Check if the folder does not exist
				if Not oFile.FolderExists(const_app_Path & "Errors\Orders\" & CurrDate) Then
					' Create the folder
					oFile.CreateFolder (const_app_Path & "Errors\Orders\" & CurrDate)
				end if
								
				' Move the File to this folder
				oFile.MoveFile const_app_Path & "Orders\" & FileName ,const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName
	
				strBody = strBody & "E-DSORD Invalid DS XML Order - " & FileName & "<br><br>"
				strBody = strBody & "Additional information: " & "<br>"
				strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
				strBody = strBody & "Unfortunately, no data can be extracted programatically from this file." & "<br>"
				strBody = strBody & "Solution" & "<br>"
				strBody = strBody & "Please inform second line support." & "<br><br>"
				strBody = strBody & "Technical reference: " & "<br>"
				strBody = strBody & "Invalid XML file location: " & const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName & "<br><br>"
								
				' Call the GenMail function
				'Call GenMail(const_appMailFrom,const_app_Error,const_app_MailCC,"","SparDrop Shipment Order Error", strBody,2,0,0)
				Call GenMail(const_appMailFrom,const_app_MailCC,"","","SparDrop Shipment Order Error", strBody,2,0,0)
				
			else
				' Valid XML file - Continue
				' Format the delivery date
				NewDate = "20" & left(objXML.selectSingleNode("//UNB/UNH/DIN/LDAT").text,2) & "/" & mid(objXML.selectSingleNode("//UNB/UNH/DIN/LDAT").text,3,2) & "/" & right(objXML.selectSingleNode("//UNB/UNH/DIN/LDAT").text,2)											
				
				' Get a list of the PRA's
				Set LstPra = objXML.selectNodes("//UNB/UNH/PRA")
				
				SQLPra = ""
				
				' Loop through the PRA's
				For Counter = 0 to LstPra.Length-1
					if Trim(LstPra.item(Counter).selectSingleNode("CRAD/PERC1").text) = "" then
						TradeVal = 0
					else
						TradeVal = LstPra.item(Counter).selectSingleNode("CRAD/PERC1").text
					end if
				
					SQLPra = SQLPra & ", @Trade" & Counter+1 & "Ind=" & MakeSQLText(LstPra.item(Counter).selectSingleNode("CRAD/ADJI1").text) & ", @Trade" & Counter+1 & "Val=" & TradeVal
				Next
		
				' Build the SQL to add the 
				SQL = "exec AddOrder @OrderNumber=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text) & _
					", @DCEAN=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/CLO/ALIP").text) & _
					", @SupplierEAN=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/SOP/SOPT").text) & _
					", @StoreEAN=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/CLO/CDPT").text) & _
					", @DeliveryDate=" & MakeSQLText(NewDate) & _
					", @TransCode=" & MakeSQLText("N") & _
					", @RecieveDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/recievedate").text) & _
					", @TransDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/translatedate").text) & _
					", @MailboxDate=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/translatedate").text) & _
					 SQLPra & _
					", @SetDiscount=0"

response.write SQL
response.end
					
					' Execute the SQL
					Set ReturnSet = ExecuteSql(SQL, curConnection)
					
					
					
					' Check the returnvalue
					if ReturnSet("returnvalue") <> 0 then
						' An error occured - Write the file to an error folder
							' Check if the folder does not exist
						if Not oFile.FolderExists(const_app_Path & "Errors\Orders\" & CurrDate) Then
							' Create the folder
							oFile.CreateFolder (const_app_Path & "Errors\Orders\" & CurrDate)
						end if
								
						' Move the File to this folder
						oFile.MoveFile const_app_Path & "Orders\" & FileName ,const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName
	
						strBody = strBody & "E-DSORD: " & ReturnSet("errormessage")  & " " &  Returnset("StoreName") & " " & Returnset("SupplierName") & "<br><br>"
						strBody = strBody & "The following occured while trying to import the order: " & ReturnSet("errormessage") & "<br><br>"
						strBody = strBody & "Additional information: " & "<br>"
						strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
						strBody = strBody & "Order number: " & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text)	& "<br>"
						strBody = strBody & "Supplier Name: " & Returnset("SupplierName") & "<br>"
						strBody = strBody & "Supplier EAN: " & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/SOP/SOPT").text) & "<br><br>"
						strBody = strBody & "Store Name: " & Returnset("StoreName") & "<br>"
						strBody = strBody & "Store EAN: " & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/CLO/CDPT").text) & "<br>"
						strBody = strBody & "Store Code: " & Returnset("StoreCode") & "<br><br>"
						strBody = strBody & "DC: " & Returnset("DCName") & "<br>"
						strBody = strBody & "DC EAN: " & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/CLO/ALIP").text) & "<br><br>"
						strBody = strBody & "Solution" & "<br>"
						strBody = strBody & "Notify the store that this order was rejected because of this problem:" & "<br><br>"						
						strBody = strBody & Returnset("errormessage") & "<br><br>"
						strBody = strBody & "Technical reference: " & "<br>"
						strBody = strBody & "Order error file location: " & const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName & "<br><br>"
											
						' Call the GenMail function
						Call GenMail(const_appMailFrom,const_app_Error,const_app_MailCC,"","SPAR Drop Shipment Order Error", strBody,2,0,0)
	
						Set ReturnSet = Nothing
	
					else
						' No errors occured
						
						' Get the new Order TrackID
						NewID = ReturnSet("NewOrdID")
						StoreName = ReturnSet("StoreName")
						SupplierMail = ReturnSet("SupplierMail")

						' Delete the file from this folder
						oFile.DeleteFile const_app_Path & "Orders\" & FileName

						' Close the recordset
						Set ReturnSet = Nothing
						
						' Get the list of line items
						Set LineItems = objXML.selectNodes("//UNB/UNH/OLD")
						
						' Loop throught he line items
						For LineCount = 0 to LineItems.Length-1
							if IsNull(Trim(LineItems.item(LineCount).selectSingleNode("FREE/NROU").text)) or Trim(LineItems.item(LineCount).selectSingleNode("FREE/NROU").text) = "" then 
								FreeQty = 0 
							else 
								FreeQty = LineItems.item(LineCount).selectSingleNode("FREE/NROU").text 
							end if
							
							if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC1").text) = "" then
								Val1 = 0
							else
								Val1 = LineItems.item(LineCount).selectSingleNode("CRAD/PERC1").text
							end if
							
							if Trim(LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text) = "" then
								Val2 = 0
							else
								Val2 = LineItems.item(LineCount).selectSingleNode("CRAD/PERC2").text
							end if

							if Trim(LineItems.item(LineCount).selectSingleNode("QNTO/NROU").text) = "" or IsNull(LineItems.item(LineCount).selectSingleNode("QNTO/NROU").text) then
								Qty = 0
							else
								Qty = LineItems.item(LineCount).selectSingleNode("QNTO/NROU").text
							end if
							
							if Trim(LineItems.item(LineCount).selectSingleNode("COST/COSP").text) = "" or IsNull(LineItems.item(LineCount).selectSingleNode("COST/COSP").text) then
								Cost = 0
							else
								Cost = LineItems.item(LineCount).selectSingleNode("COST/COSP").text
							end if
							
							if Trim(LineItems.item(LineCount).selectSingleNode("NELC").text) = "" or IsNull(LineItems.item(LineCount).selectSingleNode("NELC").text) then
								NetCost = 0
							else
								NetCost = LineItems.item(LineCount).selectSingleNode("NELC").text
							end if
							
							if Trim(LineItems.item(LineCount).selectSingleNode("VATP").text) = "" or IsNull(LineItems.item(LineCount).selectSingleNode("VATP").text) then
								VatPerc = 0
							else
								VatPerc = LineItems.item(LineCount).selectSingleNode("VATP").text
							end if
							
							' Build the SQL Statement
							SQL = "exec addOrderDetail	@OrderNumber=" & MakeSQLText(objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text) & _
								", @TrackID=" & NewID & _
								", @LineNumber=" & LineCount + 1 & _
								", @ConsumerBarCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC").text) & _
								", @OrderBarCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/EANC2").text) & _
								", @SuppProdCode=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text) & _
								", @ProdDescr=" & MakeSQLText(Replace(LineItems.item(LineCount).selectSingleNode("PROC/PROD").text,"'"," ")) & _
								", @Quantity=" & Qty & _
								", @ConfirmQuantity=0" & _
								", @UnitMeasure=" & MakeSQLText(LineItems.item(LineCount).selectSingleNode("QNTO/UNOM").text) & _
								", @SupplierPack=" & LineItems.item(LineCount).selectSingleNode("QNTO/CONU").text & _
								", @ListCost=" & Cost & _
								", @ConfirmListCost=0" & _
								", @Deal1=" & Val1 & _
								", @ConfirmDeal1=0" & _
								", @Deal2=" & Val2 & _
								", @ConfirmDeal2=0" & _
								", @NetCost=" & NetCost & _
								", @ConfirmNetCost=0" & _
								", @Vat=" & VatPerc & _
								", @ConfirmVat=0" & _
								", @FreeQty=" & FreeQty & _
								", @ConfirmFreeQty=0"

								' Execute the SQL
								Set ReturnSet = ExecuteSql(SQL, curConnection)
								
								' Close the recordset
								Set ReturnSet = Nothing
						Next
						
						' Check if this is a EDI or XML Supplier
						if IsNumeric(objXML.selectSingleNode("//UNB/UNH/SOP/SOPT").text) Then
							' This is an EDI Supplier - Generate their E-mail bodytext
							BodyText = "A SPAR Drop Shipment Purchase Order has been placed in your mailbox. Order Details below: " & VbCrLf & VbCrLf
							BodyText = BodyText & "From Store: " & StoreName & VbCrLf 
							BodyText = BodyText & "Order Number: " & objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text & VbCrLf & VbCrLf  
							BodyText = BodyText & "***********************************************************************" & VbCrLf & VbCrLf  
							BodyText = BodyText & "This email has an extention of @spar.co.za and is therefore considered a business record and property of The SPAR Group Ltd." & VbCrLf & VbCrLf  
							BodyText = BodyText & "Thank You"															
						else
							' This is a XML supplier - Generate their bodytext
							BodyText = "A SPAR Drop Shipment Purchase Order has been placed on Drop Shipment Track and Trace. Order Details below: " & VbCrLf & VbCrLf
							BodyText = BodyText & "From Store: " & StoreName & VbCrLf 
							BodyText = BodyText & "Order Number: " & objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text & VbCrLf & VbCrLf  
							BodyText = BodyText & "Click on the link below to log onto the DS Track and Trace Facility to view the Order Details." & VbCrLf & VbCrLf  
							BodyText = BodyText & const_app_ApplicationRoot  & VbCrLf & VbCrLf  
							BodyText = BodyText & "***********************************************************************" & VbCrLf & VbCrLf  
							BodyText = BodyText & "This email has an extention of @spar.co.za and is therefore considered a business record and property of The SPAR Group Ltd." & VbCrLf & VbCrLf  
							BodyText = BodyText & "Thank You"															
						end if
		
						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
		
						' Build the rest of the mail object properties
						objMail.From = const_appMailFrom 
						objMail.To = SupplierMail
						objMail.Cc = const_app_MailTo
						objMail.Subject = "New SPAR Drop Shipment Order Notification: From Store - " & StoreName
						objMail.Importance = 2
						objMail.Body = BodyText
						objMail.BodyFormat = 1
						objMail.MailFormat = 1
						objMail.Send
		
						' Close the mail Object
						Set objMail = Nothing
					end if
				end if
		
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

'	Main = DTSTaskExecResult_Success
'End Function
%>