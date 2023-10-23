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
	Case "6001008090004"
		GetSuffix = "sLV"
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
	Case "6001008090004"
		GetDC = "Spar Lowveld"
	Case Else
		GetDC = "Spar North Rand"
	End Select
End Function

Function GetDCMail (DCID)

	' Check what suffix should be used
	Select Case CStr(DCID)
	Case "6001008999956"
		GetDCMail = "mitesh.bhana@spar.co.za; ravi.ramjathan@spar.co.za"
	Case "6001008999949"
		GetDCMail = "rick.dickson@spar.co.za; peter.langeveldt@spar.co.za"
	Case "6001008999963"
		GetDCMail = "fenlin.pitie@spar.co.za; fabian.denson@spar.co.za"
	Case "6001008999970"
		GetDCMail = "wayne.harding@spar.co.za; brenton.vanbreda@spar.co.za"
	Case "6001008999987"
		GetDCMail = "youges.govender@spar.co.za; ivan.gounder@spar.co.za"
	Case "6001008090004"
		GetDCMail = "Jaiban.Yerraya@spar.co.za"
	End Select
End Function

Function AddToLog (LogName, ArchDate)
	' This function will add the file that is ftp'ed to the spar server to a log file.
	
	dim aFile
	dim aFileText

	'if len(Year(ArchDate)) > 2 then
	'	ArchDate = Right(Year(ArchDate),2) & Month(ArchDate) & Day(ArchDate)
	'end if
	
	'ArchDate =Right(Year(ArchDate),2)  & LZ(Month(ArchDate)) & LZ(Day(ArchDate))

	' Create a file system object
	Set aFile = CreateObject ("Scripting.FileSystemObject")
	
	' Add the filename to the log file
	Set aFileText = aFile.OpenTextFile("F:\SparLog\NewOrder\" & ArchDate & ".log",8,True)
	
	' Write the LogName to the log file
	aFileText.WriteLine LogName
	
	' Close the File system object
	Set aFile = Nothing
	
End Function

Function LZ(NumberToFormat)
	'Converts a single char int into a double digit with leading zero

	If len(NumberToFormat) < 2 Then
		NumberToFormat = "0" & NumberToFormat
	End if
	LZ = NumberToFormat
End Function

Function GenTigerXML (XMLObject, XMLFile, FilePath, AppRoot)
	
	'Response.CharSet = "GB2312"
	CharSet = "GB2312"
	
	' Do the Calculation of the Nett Cost per line item
   	Set LineItem = XMLObject.selectNodes("//DOCUMENT/UNB/UNH/OLD")
										
	For ItemCount = 0 to LineItem.Length-1
		' Calc the list cost
		'ListCost = CDbl(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text) * CDbl(LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text)
		ListCost = CDbl(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text)
											
		FlatPercTot = 0
		FlatRandTot = 0
		ReducePercTot = 0
		ReduceRandTot = 0
											
		For PercCount = 1 to 10
			' Add all the discounts with "S3" and "S4" together
			if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "S3" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "S4" Then
				' Add the Flat Perc Total
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text = 0
					FlatPercTot = CDbl(FlatPercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				else
					FlatPercTot = CDbl(FlatPercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				end if
													
				' Add the Flat Rand Total
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text = 0
					FlatRandTot = CDbl(FlatRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				else
					FlatRandTot = CDbl(FlatRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				end if
			end if
												
			' Add all the discounts with "T1,T2,B,SA" together
			if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "T1" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "T2" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "B" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "SA" Then
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text = 0
					ReducePercTot = CDbl(ReducePercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				else
					ReducePercTot = CDbl(ReducePercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				end if
													
				' Add the ReduceRandValue
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text = 0
					ReduceRandTot = CDbl(ReduceRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				else
					ReduceRandTot = CDbl(ReduceRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				end if
			end if
		Next
											
		' Now deduct the FlatPercTot from the ListCost
		ListCost = Round(ListCost - (ListCost * FlatPercTot / 100),5)
										
		' Now deduct the FlatRandTot from the ListCost
		ListCost = Round(ListCost - FlatRandTot,5)

		' Now deduct the Reduce discount percentage from the ListCost
		NewListCost = Round(ListCost - (ListCost * ReducePercTot / 100),5)

		' Now deduct the Reduce discount rand value from the ListCost
		NewListCost = Round(NewListCost - ReduceRandTot,5)
											
		' Now calc the Netline Cost
		NetLineCost = Round(NewListCost * (LineItem.item(ItemCount).selectSingleNode("QNTO/NROU").text / LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text),5)
      
      		LineItem.item(ItemCount).selectSingleNode("COST/COSPC").text = Round(NewListCost * CDbl(LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text),5)                       
		LineItem.item(ItemCount).selectSingleNode("NELCC").text = Round(NetLineCost,5)
   	Next
										
		' Load the XSL Style Sheet
		Set XSLDoc = CreateObject("MSXML2.DomDocument")
		XSLDoc.async = false
		'XSLDoc.Load (AppRoot & "/misc/tyger.xsl")
		XSLDoc.Load ("E:\Inetpub\wwwroot\Spar\misc\tyger.xsl")

	   'Set up the resulting document.
	   Set result = CreateObject("MSXML2.DomDocument")
		result.async = False
		result.validateOnParse = True
	                              
	   ' Parse results into a result DOM Document.
	   Display = XMLObject.transformNodeToObject(XSLDoc, result)
	   
	   ' Create a FileSytem Object
	   Set objectFile = CreateObject ("Scripting.FileSystemObject")
											
		' Open the TextFile
		Set FileText = objectFile.OpenTextFile(FilePath & "LastNum.txt",1,True)            
											
		' Read the value in the file
		FileCount = FileText.ReadLine
											
		' Close the FileText
		Set FileText = Nothing
											
		' Check if the number is 999999
		if FileCount = "999999" Then
			' Set the FileCount back to 1
			NewCount = 1
		else
			' Increment the file counter
			NewCount = FileCount + 1
		end if
							            
		' Open the TextFile
		Set FileText = objectFile.OpenTextFile(FilePath & "LastNum.txt",2,True)   
							            
		' Write the new filecount to the file
		FileText.Write NewCount
							            
		' Close the FileText
		Set FileText = Nothing
							                
	   ' Close the Object
	   Set objectFile = Nothing
	                              
	   ' Now check the padding
	   TotChars = len(NewCount)
	                              
	   ' Subtract the TotChars from 6
	   TotPad = 6 - TotChars
	                              
	   ' Loop through the TotPad
	   For Counter = 1 to TotPad
		NewPad = NewPad & "0"
   Next
                           

	'result.save FilePath & "Out\SPAR" & NewPad & NewCount & ".xml"
	result.save FilePath & "Archive\SPAR" & NewPad & NewCount & ".xml"
	
	' Close the xmlObject
	'Set XMLObject = Nothing
	
	' load the file into a dom object
	Set LineObject = CreateObject("MSXML2.DomDocument")
	LineObject.async = false
	'LineObject.Load (Replace(FilePath & "Out\SPAR" & NewPad & NewCount & ".xml","@@FileName","SPAR" & NewPad & NewCount))
	LineObject.Load (Replace(FilePath & "Archive\SPAR" & NewPad & NewCount & ".xml","@@FileName","SPAR" & NewPad & NewCount))
	
	' get the line items
	Set ItemLines = LineObject.selectNodes("Doc/Orders/Order/OrderDetails/Destins/Destin/Items/Item")
	
	' Loop through the line items
	For LineCount = 0 to ItemLines.Length-1	
		' Replace the FileName
		ItemLines.item(LineCount).selectSingleNode("ContractNo").text =  "SPAR" & NewPad & NewCount
	Next

	' Save the copy of the XML file to an archive folder
	LineObject.save FilePath & "Archive\SPAR" & NewPad & NewCount & ".xml"

	' Save the XML file
	LineObject.save FilePath & "Delay\SPAR" & NewPad & NewCount & ".xml"
	'LineObject.save FilePath & "Out\SPAR" & NewPad & NewCount & ".xml"
	
	' Close the Object
	Set LineObject = Nothing

End Function

Function GenAdcockXML (XMLObject, XMLFile, FilePath, AppRoot)
	
	CharSet = "windows-1252"
	
	' Do the Calculation of the Nett Cost per line item
   	Set LineItem = XMLObject.selectNodes("//DOCUMENT/UNB/UNH/OLD")
										
	For ItemCount = 0 to LineItem.Length-1
		' Calc the list cost
		'ListCost = CDbl(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text) * CDbl(LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text)
		ListCost = CDbl(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text)
											
		FlatPercTot = 0
		FlatRandTot = 0
		ReducePercTot = 0
		ReduceRandTot = 0
											
		For PercCount = 1 to 10
			' Add all the discounts with "S3" and "S4" together
			if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "S3" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "S4" Then
				' Add the Flat Perc Total
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text = 0
					FlatPercTot = CDbl(FlatPercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				else
					FlatPercTot = CDbl(FlatPercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				end if
													
				' Add the Flat Rand Total
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text = 0
					FlatRandTot = CDbl(FlatRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				else
					FlatRandTot = CDbl(FlatRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				end if
			end if
												
			' Add all the discounts with "T1,T2,B,SA" together
			if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "T1" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "T2" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "B" or Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/ADJI" & PercCount).text) = "SA" Then
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text = 0
					ReducePercTot = CDbl(ReducePercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				else
					ReducePercTot = CDbl(ReducePercTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/PERC" & PercCount).text)
				end if
													
				' Add the ReduceRandValue
				if Trim(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text) = "" then
					LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text = 0
					ReduceRandTot = CDbl(ReduceRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				else
					ReduceRandTot = CDbl(ReduceRandTot) + CDbl(LineItem.item(ItemCount).selectSingleNode("CRAD/VALU" & PercCount).text)
				end if
			end if
		Next
											
		' Now deduct the FlatPercTot from the ListCost
		ListCost = Round(ListCost - (ListCost * FlatPercTot / 100),5)
										
		' Now deduct the FlatRandTot from the ListCost
		ListCost = Round(ListCost - FlatRandTot,5)

		' Now deduct the Reduce discount percentage from the ListCost
		NewListCost = Round(ListCost - (ListCost * ReducePercTot / 100),5)

		' Now deduct the Reduce discount rand value from the ListCost
		NewListCost = Round(NewListCost - ReduceRandTot,5)
											
		' Now calc the Netline Cost
		NetLineCost = Round(NewListCost * (LineItem.item(ItemCount).selectSingleNode("QNTO/NROU").text / LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text),5)
      
      		LineItem.item(ItemCount).selectSingleNode("COST/COSPC").text = Round(NewListCost * CDbl(LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text),5)                       
		LineItem.item(ItemCount).selectSingleNode("NELCC").text = Round(NetLineCost,5)
   	Next

	' Generate the "DestID"
	Select Case XMLObject.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text
	Case "6001008999949"
		vendorID = "2602740"
	Case "6001008999956"
		vendorID = "2602710"
	Case "6001008999963"
		vendorID = "2602620"
	Case "6001008999970"
		vendorID = "2602770"
	Case "6001008999987"
		vendorID = "2602650"
	End Select

	'DestID = "0000001319131030" & vendorID & "01"
	DestID = vendorID
										
	' Load the XSL Style Sheet
	Set XSLDoc = CreateObject("MSXML2.DomDocument")
	XSLDoc.async = false
	XSLDoc.Load (FilePath & "map/adcock.xsl")

	'Set up the resulting document.
	Set result = CreateObject("MSXML2.DomDocument")
	result.async = False
	result.validateOnParse = True
	                              
	' Parse results into a result DOM Document.
	Display = XMLObject.transformNodeToObject(XSLDoc, result)
	   
	' Create a FileSytem Object
	Set objectFile = CreateObject ("Scripting.FileSystemObject")
											
	' Open the TextFile
	Set FileText = objectFile.OpenTextFile(FilePath & "LastNum.txt",1,True)            
											
	' Read the value in the file
	FileCount = FileText.ReadLine
											
	' Close the FileText
	Set FileText = Nothing
											
	' Check if the number is 999999
	if FileCount = "999999" Then
		' Set the FileCount back to 1
		NewCount = 1
	else
		' Increment the file counter
		NewCount = FileCount + 1
	end if
							            
	' Open the TextFile
	Set FileText = objectFile.OpenTextFile(FilePath & "LastNum.txt",2,True)   
							            
	' Write the new filecount to the file
	FileText.Write NewCount
							            
	' Close the FileText
	Set FileText = Nothing
							                
	' Close the Object
	Set objectFile = Nothing
	                              
	' Now check the padding
	TotChars = len(NewCount)
	                              
	' Subtract the TotChars from 6
	TotPad = 6 - TotChars
	                              
	' Loop through the TotPad
	For Counter = 1 to TotPad
		NewPad = NewPad & "0"
	Next

	result.selectSingleNode("//Doc/Orders/Ord/OrderDetails/Destins/Destin/DestEAN").text = DestID
                           
	result.save FilePath & "Archive\SPARPH" & NewPad & NewCount & ".xml"
	
	' Close the xmlObject
	Set XMLObject = Nothing
	
	' load the file into a dom object
	Set LineObject = CreateObject("MSXML2.DomDocument")
	LineObject.async = false
	LineObject.Load (Replace(FilePath & "Archive\SPARPH" & NewPad & NewCount & ".xml","@@FileName","SPARPH" & NewPad & NewCount))
	
	' get the line items
	Set ItemLines = LineObject.selectNodes("Doc/Orders/Ord/OrderDetails/Destins/Destin/Items/Item")
	
	' Loop through the line items
	For LineCount = 0 to ItemLines.Length-1	
		' Replace the FileName
		ItemLines.item(LineCount).selectSingleNode("ContractNo").text =  "SPARPH" & NewPad & NewCount
	Next

	' Save the copy of the XML file to an archive folder
	LineObject.save FilePath & "Archive\SPARPH" & NewPad & NewCount & ".xml"

	' Save the XML file
	'LineObject.save FilePath & "Out\SPARPH" & NewPad & NewCount & ".xml"

	Set oOut = CreateObject("ADODB.Stream")
	oOut.CharSet = "Windows-1252"
	oOut.Open
	oOut.WriteText LineObject.xml
	oOut.SaveToFile FilePath & "Out\SPARPH" & NewPad & NewCount & ".xml"
	oOut.Close
	
	' Close the Object
	Set LineObject = Nothing
	
	' Close the Object
	Set LineObject = Nothing

End Function

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
		' Check if the received date was supplied
		if IsNull(CheckXML.selectSingleNode("//UNB/UNH/recievedate").text) or CheckXML.selectSingleNode("//UNB/UNH/recievedate").text = "" Then
			ReturnValue = -2
		end if
		
		' Check if the translated date was supplied
		if IsNull(CheckXML.selectSingleNode("//UNB/UNH/translatedate").text) or CheckXML.selectSingleNode("//UNB/UNH/translatedate").text = "" Then
			ReturnValue = -3
		end if
		
		' Check if the Buyer Code was supplied
		if IsNull(CheckXML.selectSingleNode("//UNB/UNH/ORD/ORIG/NAME").text) or CheckXML.selectSingleNode("//UNB/UNH/ORD/ORIG/NAME").text = "" Then
			ReturnValue = -4
		end if
		
		' Get a list of all the line items
		Set LineCheck = CheckXML.selectNodes("//UNB/UNH/OLD")
		
		' Loop through the Line items
		For LCount = 0 to LineCheck.Length-1
			' Check if the Product Description is supplied
			if IsNull(LineCheck.item(LCount).selectSingleNode("PROC/PROD").text) or LineCheck.item(LCount).selectSingleNode("PROC/PROD").text = "" Then
				DescCheck = DescCheck + 1
			end if
		Next
		
		' Check if DescCheck is greater than 0
		if DescCheck > 0 Then
			ReturnValue = -5
		end if
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
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPARNEW1\SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	const const_app_TigerPath = "F:\FTP_CLIENTS\TigerBrands\"
	const const_app_AdcockPath = "F:\FTP_CLIENTS\Adcock\Spar\"
	const const_app_Path = "F:\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailFrom = "spar@gatewayec.co.za"
	const const_app_MailTo = ""
	const const_app_MailCC = "chris.kennedy@gatewaycomms.com; petrus.daffue@vodacom.co.za; dennys.wessels@gatewaycomms.com"
	const const_app_Error = "0821951@vodacom.co.za;  petrus.daffue@vodacom.co.za"
	
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

			' Add the filename to the log file
			Call AddToLog (FileName, ArchiveDate)
			
			' Get the File
			Set objGetFile = oFile.GetFile(FolderName & FileName)		

			' Check if the file size is greater than 0
			if objGetFile.Size > 0 Then

				' Open the text file
				Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
				
				' Read the first line of the file
				StrText = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><DOCUMENT><UNB>" & FileText.ReadAll & "</UNB></DOCUMENT>"
				
				StrText = Replace(StrText,"&","&amp;")
				StrText = Replace(StrText,"/",chr(47))
				StrText = Replace(StrText,"<",chr(60))
				StrText = Replace(StrText,">",chr(62))
	
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
						ErrorMessage = "The Received Date was not supplied: Source File = " & FileName	
					Case -3
						ErrorMessage = "The Translate Date was not supplied: Source File = " & FileName	
					Case -4
						ErrorMessage = "The Buyer Code was not supplied: Source File = " & FileName	
					Case -5
						ErrorMessage = "There was no Product Description supplied per line item: Source File = " & FileName	
					End Select

					' Check if the folder does not exist
					if Not oFile.FolderExists(const_app_Path & "SparErrors\Orders\" & ArchiveDate) Then
						' Create the folder
						oFile.CreateFolder (const_app_Path & "SparErrors\Orders\" & ArchiveDate)
					end if
							
					' Save the File to this folder
					oFile.MoveFile const_app_Path & "SparIn\" & FileName ,const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName
					
					strBody = "E-DCORD: XML file format error. Error Message: " & ErrorMessage & "<br>"
					strBody = strBody & "SPAR DC Order Error" & "<br>"
					strBody = strBody & "An error occured while trying to validate the following XML DC Order." & "<br>"
					strBody = strBody & "Unfortunately, no data can be extracted programatically from this file." & "<br><br>"
					strBody = strBody & "Additional information: " & "<br>"
					strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br><br>"
					strBody = strBody & "Solution" & "<br>"
					strBody = strBody & "Please refer this call directly to second line support (Technical Team)." & "<br><br>"
					strBody = strBody & "Technical reference: " & "<br>"
					strBody = strBody & "Invoice error file location: " & const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & FileName & "<br><br>"

					' Call the GenMail function
					Call GenMail(const_app_MailFrom,const_app_MailCC,"","","SPAR DC Order Failure", strBody,1,0,0)
				else
					' Load the string into a dom document
					Set objXML = CreateObject(const_app_ObjXML)
					objXML.async = false
					objXML.LoadXML(StrText)

					' This is a valid XML file - Continue
					' Get the ordernumber, Supplier and BuyerID's
					OrderNumber = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & GetSuffix(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text)
					SupplierEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/SOP/SOPT").text
					BuyerEAN = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text
					BuyerCode = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
					OrderPoint = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPN").text
					BuyerEmail = ""
					PromItem = ""
						
					' Get the list of Narative fields
					Set Nar = objXML.selectNodes("//DOCUMENT/UNB/UNH/NAR")
						
					' Loop through the Nar
					For NarCount = 0 to Nar.Length-1
						' Check what the line sequence number is
						Select Case CStr(Nar.item(NarCount).selectSingleNode("LSNR").text)
						Case "1"
							' Set the BuyerEmail
							BuyerEmail = Nar.item(NarCount).selectSingleNode("NARR").text
						Case "2"
							PromItem = Nar.item(NarCount).selectSingleNode("NARR").text
						Case Else
							BuyerEmail = ""
							PromItem = ""
						End Select
					Next
			
					' Build the SQL
					SQL = "exec itemHeadDetail_New @SupplierEAN='" & SupplierEAN & "'" & _
						", @BuyerCode='" & BuyerCode & "'" & _
						", @OrderNumber='" & OrderNumber & "'" & _
						", @CompanyID='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/CLO/CDPT").text & "'" & _
						", @BuyerMail='" & BuyerEmail & "'"

response.write SQL & "<br>"

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
							
						ErrorMessage = "E-DCORD: " & ReturnSet("errormessage") & " - Order Num: " & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & " - DC: " & ReturnSet("DCName") & " - Supplier: " & ReturnSet("SupplierName") & "<br>"
						ErrorMessage = ErrorMessage & "SPAR DC Order Error" & "<br><br>"
						ErrorMessage = ErrorMessage & "The following error occured while trying to import the XML DC Order." & "<br>"
		
						Select Case ReturnSet("returnvalue")
						Case "-1003"
							ErrorMessage = ErrorMessage & "The Supplier " & SupplierEAN & " does not exist in the system.<br>"
							objMailTo = const_app_MailTo
							objMailCc = const_app_MailCC
							objSubject = "Spar Order Error: Supplier does not exist"
						Case "-1004"
							ErrorMessage = ErrorMessage & "The BuyerCode " & BuyerCode & "  for DC " & BuyerEAN & " does not exist in the system.<br>"
							objMailTo = const_app_Error
							objMailCc = const_app_MailCC
							objSubject = "Spar Order Error: Buyer does not exist"
						Case "-1015"
							ErrorMessage = ErrorMessage & "The DC " & BuyerEAN & "  does not exist in the system.<br>"
							objMail.To = const_app_Error
							objMail.Cc = const_app_MailCC
							objSubject = "Spar Order Error: Distribution Center does not exist"
						Case else
							ErrorMessage = ErrorMessage & "An unknown error occured while trying to import the XML order.<br>"
						End Select

						ErrorMessage = ErrorMessage & "<br>Additional information: " & "<br>"
						ErrorMessage = ErrorMessage & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br>"
						ErrorMessage = ErrorMessage & "Order Number: " & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/ORNU").text & "<br>"
						ErrorMessage = ErrorMessage & "DC EAN: " & BuyerEAN & "<br>"
						ErrorMessage = ErrorMessage & "DC Name: " & Returnset("DCName") & "<br>"
						ErrorMessage = ErrorMessage & "Supplier Name: " & Returnset("SupplierName") & "<br>"
						ErrorMessage = ErrorMessage & "Supplier EAN: " & SupplierEAN & "<br><br>"
						ErrorMessage = ErrorMessage & "Solution" & "<br>"
						ErrorMessage = ErrorMessage & "The DC and Supplier must be notified of this error. The following are suitable solutions:" & "<br><br>"
						ErrorMessage = ErrorMessage & "If the Supplier does not exist: The supplier ean could have been missed spelled on Track & Trace. If so enquire from the DC what the EAN number must be and correct either on our side or on the DC side." & "<br><br>"
						ErrorMessage = ErrorMessage & "If the BuyerCode does not exist: The Buyer Code does not exist on Track & Trace. Enquire from DC if this is a new buyer. If so, add the new buyer and allocate the buyercode via the Portal site." & "<br><br>"
						ErrorMessage = ErrorMessage & "If the DC does not exist: The DC EAN number does not exist on Track & Trace. Please refer this type of error directly to the Technical support." & "<br><br>"
						ErrorMessage = ErrorMessage & "If Unknown error occured: Please refer this type of error directly to the Technical support." & "<br><br>"
						ErrorMessage = ErrorMessage & "Technical reference: " & "<br>"
						ErrorMessage = ErrorMessage & "Order error file location: " & const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & OrderNumber & ".xml<br><br>"

						' Close the XML object
						Set objXML = Nothing
					
						' Call the GenMail function
						Call GenMail(const_app_MailFrom,const_app_Error,const_app_MailCC,"","SPAR DC Order Failure", ErrorMessage,1,0,0)	
		
						Set ReturnSet = Nothing
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
				
						' Close the XML object
						Set objXML = Nothing
							
						' Open the text file
						Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
					
						' Read the first line of the file
						StrText = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?><DOCUMENT><UNB>" 
						StrText = StrText & "<APRF></APRF>"
						StrText = StrText & "<SOURCEREFERNCENUMBER></SOURCEREFERNCENUMBER>"
						StrText = StrText & "<Sender>"
						StrText = StrText & "<SenderName>" & GetDC(BuyerEAN) & "</SenderName>"
						StrText = StrText & "<SenderID>" & BuyerEAN & "</SenderID>"
						StrText = StrText & "<SenderAddress>" & ReturnSet("BuyerAddress") & ", " & ReturnSet("BuyerPostAddr") & "</SenderAddress>"
						StrText = StrText & "<SenderTel>" & "Phone: " & ReturnSet("BuyerTelNum") & " Fax: " & ReturnSet("BuyerFaxNum") & "</SenderTel>"
						StrText = StrText & "<SenderReg>" & ReturnSet("DCName") &  "  " & ReturnSet("BuyerRegNum") & "</SenderReg>"
						StrText = StrText & "</Sender>"
						StrText = StrText & "<Receiver>"
						StrText = StrText & "<ReceiverName>" & ReturnSet("SupplierName") & "</ReceiverName>"
						StrText = StrText & "<ReceiverID>" & SupplierEAN & "</ReceiverID>"
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
	
	
						'*******************************************************
						'if SupplierEAN = "DISTILLERS001" And BuyerEAN = "6001008999987" Then
						if SupplierEAN = "DISTILLERS001" OR SupplierEAN = "DISTELLERSWC1" OR SupplierEAN = "DISTELLERSSR1"  OR SupplierEAN = "DISTELLERSNR1"  OR SupplierEAN = "DISTELLERSEC1" Then
							objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/DATE").text = left(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/DATE").text,2) & "/" & mid(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/DATE").text,3,2) & "/" & right(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORNO/DATE").text,2)
							objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/EDAT").text = left(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/EDAT").text,2) & "/" & mid(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/EDAT").text,3,2) & "/" & right(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/EDAT").text,2)
							objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/LDAT").text = left(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/LDAT").text,2) & "/" & mid(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/LDAT").text,3,2) & "/" & right(objXML.selectSingleNode("//DOCUMENT/UNB/UNH/DIN/LDAT").text,2)
						end if
						'*******************************************************
			
						if NumExist = 1 then
							' Update the confirmdate tag
							objXML.selectSingleNode("//DOCUMENT/UNB/UNH/confirmdate").text = Year(now) & "/" & month(now) & "/" & day(now) & " " & FormatDateTime(Now,3)
						end if
								
						' Save XML File to the new folder
						objXML.save(const_app_Path & "SparOrders\" & ArchiveDate & "\" & OrderNumber & ".xml")

						' Close the recordset
						Set ReturnSet = Nothing
							
						' Add or update the order to trackTrace table
						SQL = "exec editTrackTrace @OrderNumber='" & OrderNumber & "'" & _
							", @WarehouseID='" & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/CDNO/CNDN").text & "'" & _
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
							", @PromItem='" & PromItem & "'" & _
							", @Edit=" & NumExist

response.write SQL & "<br>"
			
						' Execute the SQL 
						Set ReturnSet = ExecuteSql(SQL, curConnection)
							
						' Check the returnvalue
						if ReturnSet("returnvalue") <> 0 Then
							' An error occured - Close the recordset
	
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
	
							ErrorMessage = "E-DCORD: " & ReturnSet("errormessage") & " - Order #:" & OrderNumber & " - DC: " & BuyerName & " - Supplier: " & SupplierName & "<br>"
							ErrorMessage = ErrorMessage & "SPAR DC Order Error<br><br>"
							ErrorMessage = ErrorMessage & "The following error occured while trying to import the XML DC Order." & "<br>"
							ErrorMessage = ErrorMessage & ReturnSet("errormessage") & "<br><br>"
							ErrorMessage = ErrorMessage & "Additional information: <br>"
							ErrorMessage = ErrorMessage & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br><br>"
							ErrorMessage = ErrorMessage & "Order Number: " & OrderNumber & "<br>"
							ErrorMessage = ErrorMessage & "DC EAN: " & BuyerEAN & "<br>"
							ErrorMessage = ErrorMessage & "DC Name: " & BuyerName & "<br>"
							ErrorMessage = ErrorMessage & "Supplier Name: " & SupplierName & "<br>"
							ErrorMessage = ErrorMessage & "Supplier EAN: " & SupplierEAN & "<br>"
							ErrorMessage = ErrorMessage & "Solution" & "<br>"
							ErrorMessage = ErrorMessage & "The DC and Supplier must be notified of this error. The following as suitable solutions:" & "<br><br>"
							ErrorMessage = ErrorMessage & "If Unknown error occured: Please refer this type of error directly to the Technical support." & "<br><br>"
							ErrorMessage = ErrorMessage & "Technical reference: " & "<br>"
							ErrorMessage = ErrorMessage & "Order error file location: " & const_app_Path & "SparErrors\Orders\" & ArchiveDate & "\" & OrderNumber & ".xml<br><br>"

							' Call the GenMail function
							Call GenMail(const_app_MailFrom,const_app_Error,"","","SPAR DC Order Failure", ErrorMessage,1,0,0)	

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
								' ******************************************************
								if SupplierEAN = "DISTILLERS001" OR SupplierEAN = "DISTELLERSWC1" OR SupplierEAN = "DISTELLERSSR1"  OR SupplierEAN = "DISTELLERSNR1"  OR SupplierEAN = "DISTELLERSEC1" Then
									' Check if there are any value in the NARR tag
									if IsNumeric(LineItem.item(LineCounter).selectSingleNode("NARR").text) then
										' Add the value in the NARR tag to the COSP tag
										LineItem.item(LineCounter).selectSingleNode("COST/COSP").text = CCur(LineItem.item(LineCounter).selectSingleNode("COST/COSP").text) + CCur(LineItem.item(LineCounter).selectSingleNode("NARR").text)
									end if
								end if
									
								' ******************************************************

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
									", @FreeProdDesc='" & Replace(LineItem.item(LineCounter).selectSingleNode("FREE/PROD").text,"'","") & "'" & _
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
	
	response.write SQL & "<br>"
	
									' Execute the SQL
									Set ReturnSet = ExecuteSql(SQL, curConnection)
										
									if ReturnSet("returnvalue") = 0 and NumExist = 1 then
										LineItem.item(LineCounter).setAttribute "status", "Confirmed"
									end if
	
										
									' Close the recordset
									Set ReturnSet = Nothing	
	
									' ****************************************************************************
	
									if SupplierEAN = "DISTILLERS001" OR SupplierEAN = "DISTELLERSWC1" OR SupplierEAN = "DISTELLERSSR1"  OR SupplierEAN = "DISTELLERSNR1"  OR SupplierEAN = "DISTELLERSEC1" Then
										' Replace the Blank values with 0's
	
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC1").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC1").text = ""  or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC1").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC1").text = "000.0000"
										end if
	
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU1").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU1").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU1").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU1").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC2").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU2").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC3").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC3").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC3").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC3").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU3").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU3").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU3").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU3").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC4").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC4").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC4").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC4").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU4").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU4").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU4").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU4").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC5").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC5").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC5").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC5").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU5").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU5").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU5").text = "0.0" Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU5").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC6").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC6").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC6").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC6").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU6").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU6").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU6").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU6").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC7").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC7").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC7").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC7").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU7").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU7").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU7").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU7").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC8").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC8").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC8").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC8").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU9").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU9").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU9").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU9").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC9").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC9").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC9").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC9").text = "000.0000"
										end if
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/VALU10").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU10").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/VALU10").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/VALU10").text = "00000000.0000"
										end if
											
										if IsNull(LineItem.item(LineCounter).selectSingleNode("CRAD/PERC10").text) or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC10").text = "" or LineItem.item(LineCounter).selectSingleNode("CRAD/PERC10").text = "0.0"  Then
											LineItem.item(LineCounter).selectSingleNode("CRAD/PERC10").text = "000.0000"
										end if
									end if
	
									' ****************************************************************************
						
								Next
									
								' Save XML File to the new folder
								objXML.save(const_app_Path & "SparOrders\" & ArchiveDate & "\" & OrderNumber & ".xml")
									
								if SupplierEAN = "DISTILLERS001" OR SupplierEAN = "DISTELLERSWC1" OR SupplierEAN = "DISTELLERSSR1"  OR SupplierEAN = "DISTELLERSNR1"  OR SupplierEAN = "DISTELLERSEC1" Then
									' Save XML File to the new folder
									objXML.save(const_app_Path & "FTP_Clients\Distell\DistellOut\" & OrderNumber & ".xml")

									' Save a copy to the test directory - remember to take this out after testing
									objXML.save(const_app_Path & "FTP_Clients\Distell\test\out\" & OrderNumber & ".xml")
								end if	
									
								' Check if this is a order for Tiger Brands
'								if SupplierEAN = "6004930003319" or SupplierEAN = "6004930006310" or SupplierEAN = "6001231000108" or SupplierEAN = "6004930005351" or SupplierEAN = "6001275000010" Then'								
'								if SupplierEAN = "6004930003319" or SupplierEAN = "6004930006310" or SupplierEAN = "6001231000108" or SupplierEAN = "6004930005351" or SupplierEAN = "6001275000010" or SupplierEAN = "6001206428890" or SupplierEAN = "6001319000013" Then
								if SupplierEAN = "6004930003319" or SupplierEAN = "6004930006310" or SupplierEAN = "6001231000108" or SupplierEAN = "6004930005351" or SupplierEAN = "6001275000010" or SupplierEAN = "6001206428890" or SupplierEAN = "6001319000013"  or SupplierEAN = "6001479000007" Then


									if SupplierEAN = "6001319000013" Then

										Call GenAdcockXML (objXML, FileName, const_app_AdcockPath, const_app_ApplicationRoot)
									else
										' Call the Tiger Function to recalculate this order and generate a new XML layout
										Call GenTigerXML(objXML, FileName, const_app_TigerPath, const_app_ApplicationRoot)
									end if
								end if
									
								' Remove the file from the SparIn Forlder
								oFile.DeleteFile const_app_Path & "SparIn\" & FileName,true
	
								' Now we need to send a notification e-mail
								' Determine if we should send a notification to the buyer or supplier
								if NumExist = 0 Then
									' Build the subject line and BodyText for the supplier
									StrSubject = "Purchase Order " & Mid(OrderNumber,1,len(OrderNumber)-4) & " from " & GetDC(BuyerEAN) & " for " & SupplierName
										
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
									objMail.BCc = const_app_MailTo
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
									'StrSubject = "Purchase Order Notification From Supplier " & SupplierName  & " ( For Buyer Code: " & objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text & " )"
									StrSubject  = "Purchase Order Notification - Order " & OrderNumber & " - Supplier " & SupplierName & " - Buyer " &  objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
									BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>"
									BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation was received:</font></p>"
									BodyText = BodyText & "<p><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & ArchiveDate & "\" & OrderNumber & ".xml&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></p>" 
									BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"
		

									if SupplierEMail = "" or ISNULL(SupplierEmail) then
										SupplierEMail = "0821951@vodacom.co.za"
									end if
									
									SupplierMailSplit = Split(SupplierEmail,";")
									
response.Write "SupplierEmail = " & SupplierMailSplit(0) & "<br>"

									' Create the Mail Object
									Set objMail = CreateObject(const_app_NewMail)
						
									' Build the rest of the mail object properties
									objMail.From = SupplierMailSplit(0)
									objMail.To = BuyerEMail 
									objMail.BCc = const_app_MailTo
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

'	Main = DTSTaskExecResult_Success
'End Function
%>