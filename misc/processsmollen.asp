<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

	
	CharSet = "GB2312"
	
	const const_app_PollPath = "F:\FTP_CLIENTS\Smollen\"
	const const_app_OutPath = "F:\FTP_CLIENTS\TigerBrands\delay\"
	const const_app_ErrPath = "F:\FTP_CLIENTS\Smollen\err\"
	const const_app_Path = "F:\FTP_Clients\Smollen\map\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"

	' Set the FolderName
	FolderName = const_app_PollPath & "In\"
	
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

			Set XMLObject = createObject(const_app_ObjXML)
			XMLObject.async = false
	
			if XMLObject.Load(FolderName & FileName) <> True then
				' Check if the folder does not exist
				if Not oFile.FolderExists(const_app_ErrPath & ArchiveDate) Then
					' Create the folder
					oFile.CreateFolder (const_app_ErrPath & ArchiveDate)
				end if
								
				' Move the File to this folder
				oFile.MoveFile FolderName & FileName ,const_app_ErrPath & ArchiveDate & "\" & FileName
			else
				' Get a list of UNB's
				Set UnhList = XMLObject.selectNodes("//UNB/UNH")
				
				for UnhCnt = 0 to UnhList.Length-1

					' Do the Calculation of the Nett Cost per line item
					Set LineItem = UnhList.item(UnhCnt).selectNodes("OLD")
														
					For ItemCount = 0 to LineItem.Length-1
						' Calc the list cost
						if LineItem.item(ItemCount).selectSingleNode("COST/COSP").text = "" or IsNull(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text) then
							ListCost  = 0
						else
							ListCost = CDbl(LineItem.item(ItemCount).selectSingleNode("COST/COSP").text)
						end if
															
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
		   
						if ListCost = 0 then
							LineItem.item(ItemCount).selectSingleNode("COST/COSP").text = 0
						end if
		   
		   				LineItem.item(ItemCount).selectSingleNode("COST/COSPC").text = Round(NewListCost * CDbl(LineItem.item(ItemCount).selectSingleNode("QNTO/TMEA").text),5)                       
						LineItem.item(ItemCount).selectSingleNode("NELCC").text = Round(NetLineCost,5)
					Next

					' Load the XML
					Set XMLDoc = CreateObject("MSXML2.DomDocument")
					XMLDoc.async = false
					XMLDoc.LoadXML (UnhList.item(UnhCnt).xml)
											
					' Load the XSL Style Sheet
					Set XSLDoc = CreateObject("MSXML2.DomDocument")
					XSLDoc.async = false
					XSLDoc.Load (const_app_Path & "smollen_tiger.xsl")
					
					'Set up the resulting document.
					Set result = CreateObject("MSXML2.DomDocument")
					result.async = False
					result.validateOnParse = True
						                              
					' Parse results into a result DOM Document.
					Display = XMLDoc.transformNodeToObject(XSLDoc, result)
					   
					' Create a FileSytem Object
					Set objectFile = CreateObject ("Scripting.FileSystemObject")
															
					' Open the TextFile
					Set FileText = objectFile.OpenTextFile(const_app_PollPath & "LastNum.txt",1,True)            
															
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
					Set FileText = objectFile.OpenTextFile(const_app_PollPath & "LastNum.txt",2,True)   
											            
					' Write the new filecount to the file
					FileText.Write NewCount
											            
					' Close the FileText
					Set FileText = Nothing
											                
					' Close the Object
					Set objectFile = Nothing
					                              
					' Now check the padding
					TotChars = len(NewCount)
					       
					TotPad = 0
					NewPad = ""
                       
					' Subtract the TotChars from 6
					TotPad = 6 - TotChars
					                              
					' Loop through the TotPad
					For Counter = 1 to TotPad
						NewPad = NewPad & "0"
					Next

					result.save const_app_PollPath & "archive\SMOL" & NewPad & NewCount & ".xml"

					' load the file into a dom object
					Set LineObject = CreateObject("MSXML2.DomDocument")
					LineObject.async = false
					LineObject.Load (Replace(const_app_PollPath & "archive\SMOL" & NewPad & NewCount & ".xml","@@FileName","SMOL" & NewPad & NewCount))
	
					' get the line items
					Set ItemLines = LineObject.selectNodes("Doc/Orders/Order/OrderDetails/Destins/Destin/Items/Item")
	
					' Loop through the line items
					For LineCount = 0 to ItemLines.Length-1	
						' Replace the FileName
						ItemLines.item(LineCount).selectSingleNode("ContractNo").text =  "SMOL" & NewPad & NewCount
					Next

					' Save the copy of the XML file to an archive folder
					LineObject.save const_app_PollPath & "archive\SMOL" & NewPad & NewCount & ".xml"
				
					' Save the copy of the XML file to out folder
					'LineObject.save const_app_OutPath & "SMOL" & NewPad & NewCount & ".xml"

					' Close the Object
					Set LineObject = Nothing
				Next
			end if
			
			' Delete the file
			oFile.DeleteFile FolderName & FileName
		Next
	end if
	
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing
	
	' Close the xmlObject
	Set XMLObject = Nothing

%>

