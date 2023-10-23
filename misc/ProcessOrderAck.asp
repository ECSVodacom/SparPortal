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

'Function AddToLog (LogName, ArchDate)
	' This function will add the file that is ftp'ed to the spar server to a log file.
	
	'dim aFile
	'dim aFileText
	
	' Create a file system object
	'Set aFile = CreateObject ("Scripting.FileSystemObject")
	
	' Add the filename to the log file
	'Set aFileText = aFile.OpenTextFile("F:\SparLog\NewOrder\" & ArchDate & ".log",8,True)
	
	' Write the LogName to the log file
	'aFileText.WriteLine LogName
	
	' Close the File system object
	'Set aFile = Nothing
	
'End Function

Function ValidateFileds (XMLFile)
	' This function will do some validation on madatory fields before processing futher
	ReturnValue = 0
	
	' Load the XML file into a xml object
	Set CheckXML = CreateObject("MSXML2.DomDocument")
	CheckXML.async = false
				
	' Determine if this is a valid XML file]
	if CheckXML.LoadXML(XMLFile) = false then
		' Invalid xml = Return the invalid code
		ReturnValue = -1
	else
		' Valid XML - Continue to check the mandatory fields
		' Check if the confirmed date was supplied
		if IsNull(CheckXML.selectSingleNode("//UNB/UNH/confirmdate").text) or CheckXML.selectSingleNode("//UNB/UNH/confirmdate").text = "" Then
			ReturnValue = -2
		end if
		
		' Check if the Buyer Code was supplied
'		if IsNull(CheckXML.selectSingleNode("//UNB/UNH/ORD/ORIG/NAME").text) or CheckXML.selectSingleNode("//UNB/UNH/ORD/ORIG/NAME").text = "" Then
'			ReturnValue = -3
'		end if
		
		' Get a list of all the line items
'		Set LineCheck = CheckXML.selectNodes("//UNB/UNH/OLD")
		
		' Loop through the Line items
'		For LCount = 0 to LineCheck.Length-1
'			' Check if the Product Description is supplied
'			if IsNull(LineCheck.item(LCount).selectSingleNode("PROC/PROD").text) or LineCheck.item(LCount).selectSingleNode("PROC/PROD").text = "" Then
'				DescCheck = DescCheck + 1
'			end if
'		Next
'		
		' Check if DescCheck is greater than 0
'		if DescCheck > 0 Then
'			ReturnValue = -4
'		end if
	end if
	
	' Return the ReturnValue
	ValidateFileds = ReturnValue
	
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
	dim objMailTo
	dim objMailCc
	dim objSubject
	dim objGetFile
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPARNEW1\spar"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	const const_app_Path = "f:\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailFrom = "spar@gatewayec.co.za"
	const const_app_MailError = "atg@gatewaycomms.com"
	const const_app_MailCc = "sparmon@gatewaycomms.co.za; hannes.kingsley@gatewaycomms.com; chris.kennedy@gatewaycomms.com"
	
	' Set the FolderName
	FolderName = const_app_Path & "SparAck\"
	
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

			' Add the filename to the log file
			'Call AddToLog (FileName, ArchiveDate)
			
			' Get the File
			Set objGetFile = oFile.GetFile(FolderName & FileName)		

			' Check if the file size is greater than 0
			if objGetFile.Size > 0 Then

				' Open the text file
				Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
				
				' Read the first line of the file
				StrText = "<DOCUMENT><UNB>" & FileText.ReadLine & "</UNB></DOCUMENT>"
				
				StrText = Replace(StrText,"&","&amp;")
				StrText = Replace(StrText,"/",chr(47))
	
				' close the File
				FileText.Close

				Validate = ValidateFileds (StrText)
				
				' Check if the ReturnValue is 0
				If Validate <> 0 Then
					' Check what the return value is
					Select Case Validate
					Case -1
						ErrorMessage = "Invalid XML File: Source File = " & FileName
					Case -2
						ErrorMessage = "The Confirmation Date was not supplied: Source File = " & FileName	
					'Case -3
					'	ErrorMessage = "The Buyer Code was not supplied: Source File = " & FileName	
					'Case -4
					'	ErrorMessage = "There was no Product Description supplied per line item: Source File = " & FileName	
					End Select
					
					' Check if the folder does not exist
					if Not oFile.FolderExists(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate) Then
						' Create the folder
						oFile.CreateFolder (const_app_Path & "SparErrors\OrderAck\" & ArchiveDate)
					end if
							
					' Save the File to this folder
					 oFile.MoveFile const_app_Path & "SparAck\" & FileName ,const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & FileName
					
					strBody = strBody & "E-DCORDACK  " & errormessage & "<br><br>"
					strBody = strBody & "The follwing error(s) occured with the DC acknoledgement:" & "<br>"
					strBody = strBody & "Error message: " & errormessage & "<br><br>"
					strBody = strBody & "Additional information: " & "<br>"
					strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
					strBody = strBody & "Unfortunately, no data can be extracted programatically from this file." & "<br><br>"
					strBody = strBody & "Solution" & "<br>"
					strBody = strBody & "Please refer this call directly to second line support (Technical Team)." & "<br><br>"
					strBody = strBody & "Technical reference: " & "<br>"
					strBody = strBody & "Acknoledgement error file location: " & const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & FileName & "<br><br>"
					
					' Call the GenMail function
					Call GenMail(const_app_MailFrom, const_mailError, const_mailCC,"","Spar Order Acknowledgement Error", strBody,2,0,0)
					
				else
	
					' Load the string into a dom document
					Set objXML = CreateObject(const_app_ObjXML)
					objXML.async = false
					
					' Determine if this is a valid XML file
					if objXML.LoadXML(StrText) = False Then
						' Not valid XML file - Write the file to the SparErrors folder
						' Check if the folder does not exist
						if Not oFile.FolderExists(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate) Then
							' Create the folder
							oFile.CreateFolder (const_app_Path & "SparErrors\OrderAck\" & ArchiveDate)
						end if
								
						' Save the File to this folder
						oFile.MoveFile const_app_Path & "SparAck\" & FileName ,const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & FileName
				
						strBody = strBody & "E-DCORDACK  Invalid XML acknoledgement." & "<br><br>"
						strBody = strBody & "The follwing error(s) occured with the DC acknoledgement:" & "<br>"
						strBody = strBody & "Error message: Invalid XML acknoledgement." & "<br><br>"
						strBody = strBody & "Additional information: " & "<br>"
						strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
						strBody = strBody & "Unfortunately, no data can be extracted programatically from this file." & "<br><br>"
						strBody = strBody & "Solution" & "<br>"
						strBody = strBody & "Please refer this call directly to second line support (Technical Team)." & "<br><br>"
						strBody = strBody & "Technical reference: " & "<br>"
						strBody = strBody & "Acknoledgement error file location: " & const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & FileName & "<br><br>"
					
						' Call the GenMail function
						Call GenMail(const_app_MailFrom, const_mailError, const_mailCC,"","Spar Order Acknowledgement Error", strBody,2,0,0)
						
						' Close the XML object
						Set objXML = Nothing
		
					else
						' This is a valid XML file - Continue
						' Get the ordernumber, Supplier and BuyerID's
						OrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & GetSuffix(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text)
						DisplayOrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text
						SupplierEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/SOP/SOPT").text
						BuyerEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text
						BuyerCode = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
						OrderPoint = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPN").text
						BuyerEmail = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/NAR/NARR").text
			
						' Build the SQL
						SQL = "exec itemOrderAckHeadDetail_new @SupplierEAN='" & SupplierEAN & "'" & _
							", @OrderNumber='" & OrderNumber & "'" & _
							", @CompanyID='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text & "'" 
	
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
							if Not oFile.FolderExists(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate) Then
								' Create the folder
								oFile.CreateFolder (const_app_Path & "SparErrors\OrderAck\" & ArchiveDate)
							end if
								
							' Save the File to this folder
							objXML.save(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & OrderNumber & ".xml")
					
							' Remove the file from the SparIn Forlder
							oFile.DeleteFile const_app_Path & "SparAck\" & FileName,true
							
		
							Select Case ReturnSet("returnvalue")
							Case "-1002"
								ErrorMessage = "The Order " & OrderNumber & " does not exist in the system."
'								objMailTo = "sparmon@gatewaycomms.co.za; lmakane@gatewaycomms.co.za"
'								objMailCc = "jyzelle@gatewaycomms.co.za; jkingsley@gatewaycomms.co.za"
								objSubject = "Spar Order Acknowledgement Error: Order does not exist"
							Case "-1003"
								ErrorMessage = "The Supplier " & SupplierEAN & " does not exist in the system."
'								objMailTo = "sparmon@gatewaycomms.co.za; lmakane@gatewaycomms.co.za;mdolo@gatewaycomms.co.za; kwalker@gatewaycomms.co.za"
'								objMailCc = "jyzelle@gatewaycomms.co.za; jkingsley@gatewaycomms.co.za"
								objSubject = "Spar Order Acknowledgement Error: Supplier does not exist"
'							Case "-1004"
'								ErrorMessage = "The BuyerCode " & BuyerCode & "  for DC " & BuyerEAN & " does not exist in the system."
'								objMailTo = "sparmon@gatewaycomms.co.za; lmakane@gatewaycomms.co.za; mdolo@gatewaycomms.co.za; kwalker@gatewaycomms.co.za"
'								objMailCc = "jyzelle@gatewaycomms.co.za; jkingsley@gatewaycomms.co.za"
'								objSubject = "Spar Order Acknowledgement Error: Buyer does not exist"
							Case "-1015"
								ErrorMessage = "The DC " & BuyerEAN & "  does not exist in the system."
'								objMailTo = "sparmon@gatewaycomms.co.za; lmakane@gatewaycomms.co.za; mdolo@gatewaycomms.co.za; kwalker@gatewaycomms.co.za"
'								objMailCc = "jyzelle@gatewaycomms.co.za; jkingsley@gatewaycomms.co.za"
								objSubject = "Spar Order Acknowledgement Error: Distribution Center does not exist"
							End Select

							Response.Write ErrorMessage
							Response.End
							
						strBody = strBody & "E-DCINV  " & ReturnSet("errormessage") & " " & "<br><br>"
						strBody = strBody & "The follwing error(s) occured while trying to import the following order acknoledgement(s):" & "<br>"
						strBody = strBody & "Error message: " & ReturnSet("errormessage") & "<br><br>"
						strBody = strBody & "Additional information: " & "<br>"
						strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
						strBody = strBody & "Supplier Name: " & Returnset("SupplierName") & "<br>"
						strBody = strBody & "Supplier EAN: " & SupplierEAN & "<br>"
						strBody = strBody & "Buyer EAN: " & BuyerEAN & "<br>"
						strBody = strBody & "Buyer Code: " & BuyerCode & "<br>"
						strBody = strBody & "Acknoledgement Number: " & OrderNumber & "<br>"
						strBody = strBody & "Referenced Order Number: " & DisplayOrderNumber & "<br><br>"
						strBody = strBody & "Solution" & "<br>"
						strBody = strBody & "Check EDISWITCH to determine the date the order was placed by SPAR to this Supplier." & "<br>"
						strBody = strBody & "Notify the supplier about this problem." & "<br><br>"						
						strBody = strBody & "Technical reference: " & "<br>"
						strBody = strBody & "Acknoledgement error file location: " & const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & FileName &  "<br><br>"
						
						' Call the GenMail function
						Call GenMail(const_app_MailFrom,const_app_MailError,const_app_MailCC,"",objSubject, strBody,1,0,0)
							
						' Close the XML object
						Set objXML = Nothing
		
						else
							' No error occured
							OrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & GetSuffix(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text)
							DisplayOrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text
							XMLRef = ReturnSet("XMLRef")
							SupplierName = ReturnSet("SupplierName")
							SupplierEmail = Split(ReturnSet("SupplierEmail"),";")
							BuyerName = ReturnSet("BuyerName")
							BuyerSurname = ReturnSet("BuyerSurname")
							
							Set ReturnSet = Nothing

							' Add or update the order to trackTrace table
							SQL = "exec editOrderAck @OrderNumber='" & OrderNumber & "'" & _
								", @ConfirmDate=" & MakeSQLDate(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/confirmdate").text)
			
							' Execute the SQL 
							Set ReturnSet = ExecuteSql(SQL, curConnection)
							
							' Check the returnvalue
							if ReturnSet("returnvalue") <> 0 Then
								' An error occured - Close the recordset
								' Check if the folder does not exist
								if Not oFile.FolderExists(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate) Then
									' Create the folder
									oFile.CreateFolder (const_app_Path & "SparErrors\OrderAck\" & ArchiveDate)
								end if
									
								' Save the File to this folder
								objXML.save(const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & OrderNumber & ".xml")
						
								' Remove the file from the SparIn Forlder
								oFile.DeleteFile const_app_Path & "SparAck\" & FileName,true
								
								strBody = strBody & "E-DCINV  " & ReturnSet("errormessage") & " " & Returnset("SupplierName") & "<br><br>"
								strBody = strBody & "The follwing error(s) occured while trying to import the following order acknoledgement(s):" & "<br>"
								strBody = strBody & "Error message: " & ReturnSet("errormessage") & "<br><br>"
								strBody = strBody & "Additional information: " & "<br>"
								strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
								strBody = strBody & "Supplier Name: " & Returnset("SupplierName") & "<br>"
								strBody = strBody & "Buyer Name: " & BuyerName & " " & BuyerSurname & "<br>"
								strBody = strBody & "Acknoledgement Number: " & OrderNumber & "<br>"
								strBody = strBody & "Referenced Order Number: " & DisplayOrderNumber & "<br><br>"
								strBody = strBody & "Solution" & "<br>"
								strBody = strBody & "Check EDISWITCH to determine the date the order was placed by SPAR to this Supplier." & "<br>"
								strBody = strBody & "Notify the supplier about this problem." & "<br><br>"						
								strBody = strBody & "Technical reference: " & "<br>"
								strBody = strBody & "Acknoledgement error file location: " & const_app_Path & "SparErrors\OrderAck\" & ArchiveDate & "\" & OrderNumber &  "<br><br>"
						
								' Call the GenMail function
								Call GenMail(const_app_MailFrom,const_app_MailError,const_app_MailCC,"","SPAR - Order Acknowledgement ERROR", strBody,1,0,0)
								
								Set ReturnSet = Nothing
							else
								' No error occured - Continue to add the line item details
								' Close the recordset
								Set ReturnSet = Nothing

								' Get a list of all the line item details
								Set LineItem = objXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
								
								' Load the original xml order into a dom document
								Set checkXML = CreateObject(const_app_ObjXML)
								checkXML.async = false
								checkXML.Load(const_app_Path & "SparOrders/" & Replace(XMLRef,"\","/"))
								
								Set CheckLine = checkXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
								
								' Loop through the line item details and insert into the database
								For LineCounter = 0 to LineItem.Length-1
									' Build the SQL Statement				
									SQL = "exec editOrderAckLineDetail @OrderNumber='" & OrderNumber & "'" & _
										", @SupplProdCode='" & LineItem.item(LineCounter).selectSingleNode("PROC/SUPC").text & "'" & _
										", @Quantity='" & LineItem.item(LineCounter).selectSingleNode("QNTO/NROU").text & "'" & _
										", @CostPrice='" & LineItem.item(LineCounter).selectSingleNode("COST/COSP").text & "'" & _
										", @NetCost='" & LineItem.item(LineCounter).selectSingleNode("NELC").text & "'"
										
										' Execute the SQL
										Set ReturnSet = ExecuteSql(SQL, curConnection)
										
										if ReturnSet("returnvalue") = 0 then
											For CheckCount = 0 to CheckLine.Length-1
												' Check if the Prod Codes match
												if LineItem.item(LineCounter).selectSingleNode("PROC/SUPC").text = CheckLine.item(CheckCount).selectSingleNode("PROC/SUPC").text Then
													CheckLine.item(CheckCount).setAttribute "status", "Confirmed"
													
													if LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text <> "" then
														CheckLine.item(CheckCount).selectSingleNode("QNTO/NROUC").text = LineItem.item(LineCounter).selectSingleNode("QNTO/NROUC").text
													else
														CheckLine.item(CheckCount).selectSingleNode("QNTO/NROUC").text = LineItem.item(LineCounter).selectSingleNode("QNTO/NROU").text
													end if

													if LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text <> "" then
														CheckLine.item(CheckCount).selectSingleNode("COST/COSPC").text = LineItem.item(LineCounter).selectSingleNode("COST/COSPC").text
													else
														CheckLine.item(CheckCount).selectSingleNode("COST/COSP").text = LineItem.item(LineCounter).selectSingleNode("COST/COSP").text
													end if

													if LineItem.item(LineCounter).selectSingleNode("NELCC").text <> "" then
														CheckLine.item(CheckCount).selectSingleNode("NELCC").text = LineItem.item(LineCounter).selectSingleNode("NELCC").text
													else
														CheckLine.item(CheckCount).selectSingleNode("NELC").text = LineItem.item(LineCounter).selectSingleNode("NELC").text
													end if

												end if
											Next
										end if
									
										' Close the recordset
										Set ReturnSet = Nothing	
									Next
									
									' Save XML File to the new folder
									checkXML.save(const_app_Path & "SparOrders\" & Replace(XMLRef,"\","/"))
									
									' Remove the file from the SparAck Forlder
									oFile.DeleteFile const_app_Path & "SparAck\" & FileName,true
							
									' Now we need to send a notification e-mail
									' Build the subject line and BodyText for the buyer
									StrSubject = "Order Acknowledgement Notification - Order " & DisplayOrderNumber & " -  Supplier " & SupplierName  & " -  Buyer " & BuyerName & " " & BuyerSurname
										
									BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>"
									BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation was received:</font></p>"
									BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & XMLRef & "&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"

									' Create the Mail Object
									Set objMail = CreateObject(const_app_NewMail)
						
									' Build the rest of the mail object properties
									objMail.From = SupplierEmail(0)
									objMail.To = BuyerEMail 
									objMail.BCc = const_app_MailTo
									objMail.Subject = StrSubject
									objMail.Importance = 2
									objMail.Body = BodyText
									objMail.BodyFormat = 0
									objMail.MailFormat = 0
									objMail.Send
					
'									' Close the mail Object
									Set objMail = Nothing
							end if
					
							' Close the recordset and connection
							curConnection.Close
							Set curConnection = Nothing
						end if
					end if
				end if
			end if
		Next
	end if
	
	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing

	'Main = DTSTaskExecResult_Success
'End Function
%>