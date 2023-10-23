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
	'const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=SPAR"
	'const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/dropship/"
	'const const_app_Path = "D:\SparDS\"
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=TECHNICAL_03"
	const const_app_ApplicationRoot = "http://10.34.49.131/spar/dropship/"
	const const_app_Path = "C:\SparDS\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "0821951@vodacom.co.za;sparmon@gatewaycomms.co.za"
	
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
	
				' Create the Mail Object
				Set objMail = CreateObject(const_app_NewMail)
	
				' Build the rest of the mail object properties
				objMail.From = "spar@gatewayec.co.za" 
				objMail.To = const_app_MailCC
				objMail.Cc = "hannes.kingsley@gatewaycomms.com;chris.kennedy@gatewaycomms.com"
				objMail.Subject = "SparDrop Shipment Order Error"
				objMail.Importance = 2
				objMail.Body = "Invalid XML Order - Source File: " & const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName
				objMail.BodyFormat = 1
				objMail.MailFormat = 1
				objMail.Send
	
				' Close the mail Object
				Set objMail = Nothing
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
					
					Response.Write SQL &"<br>"
					
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
	
						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
	
						' Build the rest of the mail object properties
						objMail.From = "spar@gatewayec.co.za" 
						objMail.To = const_app_MailCC
						objMail.Cc = "hannes.kingsley@gatewaycomms.com;chris.kennedy@gatewaycomms.com"
						objMail.Subject = "SparDrop Shipment Order Error"
						objMail.Importance = 2
						objMail.Body = ReturnSet("errormessage") & " Source File: " & const_app_Path & "Errors\Orders\" & CurrDate & "\" & FileName
						objMail.BodyFormat = 1
						objMail.MailFormat = 1
						objMail.Send

						Set ReturnSet = Nothing
	
						' Close the mail Object
						Set objMail = Nothing
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
								
								Response.Write SQL &"<br>"

								' Execute the SQL
								Set ReturnSet = ExecuteSql(SQL, curConnection)
								
								' Close the recordset
								Set ReturnSet = Nothing
						Next
						
						' Check if this is a EDI or XML Supplier
						if IsNumeric(objXML.selectSingleNode("//UNB/UNH/SOP/SOPT").text) Then
							' This is an EDI Supplier - Generate their E-mail bodytext
							BodyText = "A new SPAR Drop Shipment Purchase Order arrived on Track and Trace. Order Details below: " & VbCrLf & VbCrLf
							BodyText = BodyText & "From Store: " & StoreName & VbCrLf 
							BodyText = BodyText & "Order Number: " & objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text & VbCrLf & VbCrLf  
							BodyText = BodyText & "***********************************************************************" & VbCrLf & VbCrLf  
							BodyText = BodyText & "This email, has an extention of @spar.co.za and is therefore considered a business record and is therefore property of The Spar Group Ltd." & VbCrLf & VbCrLf  
							BodyText = BodyText & "Thank You"															
						else
							' This is a XML supplier - Generate their bodytext
							BodyText = "A new SPAR Drop Shipment Purchase Order arrived on Track and Trace. Order Details below: " & VbCrLf & VbCrLf
							BodyText = BodyText & "From Store: " & StoreName & VbCrLf 
							BodyText = BodyText & "Order Number: " & objXML.selectSingleNode("//UNB/UNH/ORD/ORNO/ORNU").text & VbCrLf & VbCrLf  
							BodyText = BodyText & "Click on the link below to log onto the Track and Trace Facility to view the Order Details." & VbCrLf & VbCrLf  
							BodyText = BodyText & const_app_ApplicationRoot & "/dropship/" & VbCrLf & VbCrLf  
							BodyText = BodyText & "***********************************************************************" & VbCrLf & VbCrLf  
							BodyText = BodyText & "This email, has an extention of @spar.co.za and is therefore considered a business record and is therefore property of The Spar Group Ltd." & VbCrLf & VbCrLf  
							BodyText = BodyText & "Thank You"															
						end if
		
						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
		
						' Build the rest of the mail object properties
						objMail.From = "spar@gatewayec.co.za" 
						objMail.To = SupplierMail
						objMail.Cc = "ckennedy@gatewaycomms.co.za"
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
