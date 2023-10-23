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
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "sbouwer@gatewaycomms.co.za"
	
	' Set the FolderName
	FolderName = const_app_Path & "DistellIn\"
	
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
				' Load the string into a dom document
				Set objXML = CreateObject(const_app_ObjXML)
				objXML.async = false
				
				' Determine if this is a valid XML file]
				if objXML.Load(FolderName & FileName) = False Then
					' Not valid XML file - Write the file to the SparErrors folder
					' Check if the folder does not exist
					if Not oFile.FolderExists(const_app_Path & "SparErrors\Orders\" & ArchiveDate) Then
						' Create the folder
						oFile.CreateFolder (const_app_Path & "SparErrors\Orders\" & ArchiveDate)
					end if
							
					' Save the File to this folder
					'objXML.save(const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName)

					' Move the file
					oFile.MoveFile const_app_Path & "DistellIn\" & FileName, const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName
				
					' Remove the file from the SparIn Forlder
					'oFile.DeleteFile const_app_Path & "DistellIn\" & FileName,true
		
					' Close the XML object
					Set objXML = Nothing
	
					' Create the Mail Object
					Set objMail = CreateObject(const_app_NewMail)
	
					' Build the rest of the mail object properties
					objMail.From = "spar@gatewayec.co.za" 
					objMail.To = "sbouwer@gatewaycomms.co.za"
					'objMail.Cc = "ckennedy@gatewaycomms.co.za"
					objMail.Subject = "Spar Distell Order Notification Error"
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
					DisplayOrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text 					
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
		
		Response.Write SQL & "<br>"
		
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
						oFile.DeleteFile const_app_Path & "DistellIn\" & FileName,true
		
	
						Select Case ReturnSet("returnvalue")
						Case "-1003"
							ErrorMessage = "The Supplier " & SupplierEAN & " does not exist in the system."
						Case "-1004"
							ErrorMessage = "The BuyerCode " & BuyerCode & "  for DC " & BuyerEAN & " does not exist in the system."
                                                                                 Case "-1015"
							ErrorMessage = "The DC " & BuyerEAN & " does not exist in the system."
	
						End Select
	
						' Close the XML object
						Set objXML = Nothing
	
						' Create the Mail Object
						Set objMail = CreateObject(const_app_NewMail)
		
						' Build the rest of the mail object properties
						objMail.From = "spar@gatewayec.co.za" 
						objMail.To = "sbouwer@gatewaycomms.co.za"
						'objMail.Cc = "ckennedy@gatewaycomms.co.za"
						objMail.Subject = "Spar Distell Order Notification Error"
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
						SupplierName = ReturnSet("SupplierName")
						
						' Update the Sender tags
						objXML.selectSingleNode("//DOCUMENT/UNB/Sender/SenderAddress").text = ReturnSet("BuyerAddress") & ", " & ReturnSet("BuyerPostAddr") 
						objXML.selectSingleNode("//DOCUMENT/UNB/Sender/SenderTel").text = "Phone: " & ReturnSet("BuyerTelNum") & " Fax: " & ReturnSet("BuyerFaxNum")
						objXML.selectSingleNode("//DOCUMENT/UNB/Sender/SenderReg").text = ReturnSet("DCName") &  "  " & ReturnSet("BuyerRegNum")

						' Update the <DIN> tag detail
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/NARR1").text = "THE SPAR GROUP LTD. CO. " & ReturnSet("BuyerRegNum")
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/NARR2").text = ReturnSet("BuyerVatNum")
						objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/RDIN").text = ReturnSet("BuyerAddress")

						' Save XML File to the new folder
						objXML.save(const_app_Path & "SparOrders\" & ArchiveDate & "\" & OrderNumber & ".xml")

						' Remove the file from the SparIn Forlder
						oFile.DeleteFile const_app_Path & "DistellIn\" & FileName,true
						
						' Close the recordset
						Set ReturnSet = Nothing
						
						' Add or update the order to trackTrace table
						SQL = "exec editDistellTrackTrace @OrderNumber='" & OrderNumber & "'" & _
							", @Invoice='" & objXML.selectSingleNode("//DOCUMENT/UNB/SOURCEREFERENCENUMBER").text & "'" & _
							", @Extract=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/extracttime").text)
							
							Response.Write SQL & "<BR>"
							
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
								SQL = "exec editDistellOrderLineDetail @OrderNumber='" & OrderNumber & "'" & _
									", @SupplOrderPoint='" & LineItem.item(LineCounter).selectSingleNode("PROC/SUPC").text & "'" & _
									", @ConfirmQuantity='" & LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text & "'" & _
									", @ConfirmCostPrice='" & LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text & "'" & _
									", @ConfirmNetCost='" & LineItem.item(LineCounter).selectSingleNode("NELCC").text & "'" & _
									", @Comments='" & LineItem.item(LineCounter).selectSingleNode("NARR").text & "'" 

Response.Write	 SQL & "<BR>"

								' Execute the SQL
								Set ReturnSet = ExecuteSql(SQL, curConnection)

								if ReturnSet("returnvalue") = 0 then
									LineItem.item(LineCounter).selectSingleNode("QNTO/NROU").text = Trim(LineItem.item(LineCounter).selectSingleNode("QNTO/NROU").text)
									LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text = Trim(LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text)
									LineItem.item(LineCounter).selectSingleNode("COST/COSP").text = Trim(LineItem.item(LineCounter).selectSingleNode("COST/COSP").text)
									LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text = Trim(LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text)
									LineItem.item(LineCounter).selectSingleNode("NELC").text = Trim(LineItem.item(LineCounter).selectSingleNode("NELC").text)
									LineItem.item(LineCounter).selectSingleNode("NELCC").text = Trim(LineItem.item(LineCounter).selectSingleNode("NELCC").text)
								end if
									
								' Close the recordset
								Set ReturnSet = Nothing						
							Next
								
							' Save XML File to the new folder
							objXML.save(const_app_Path & "SparOrders\" & ArchiveDate & "\" & OrderNumber & ".xml")

							' Now we need to send a notification e-mail
							' Build the subject line and BodyText for the buyer
							StrSubject = "Purchase Order Notification - Order " & DisplayOrderNumber & " - Supplier " & SupplierName & " - Buyer " & BuyerCode
									
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
							'objMail.To = "ckennedy@gatewaycomms.co.za"
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

'	Main = DTSTaskExecResult_Success
'End Function
%>