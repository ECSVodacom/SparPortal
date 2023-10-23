<%@ Language=VBScript %>
<%
'response.write "hello"
'response.end

	'const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=TECHNICAL_03"
	'const const_app_TigerPath = "C:\FTP_CLIENTS\TigerBrands\Metro\"
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
	const const_app_AdcockPath = "F:\FTP_CLIENTS\Adcock\spar\"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "ckennedy@gatewaycomms.co.za"

	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	
	Set Folder = oFile.GetFolder("F:\Sparin\temp\")
	
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
	
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
	
	if Files_Collection.Count > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name

			Set objXML = server.CreateObject("MSXML2.DomDocument")
			objXML.async = false
			objXML.Load("F:\Sparin\temp\" & FileName)



			call GenAdcockXML (objXML, "", const_app_AdcockPath, "https://spar.gatewayec.co.za/")
		next
	end if
	
	
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
		vendorID = "02602740"
	Case "6001008999956"
		vendorID = "02602710"
	Case "6001008999963"
		vendorID = "20602620"
	Case "6001008999970"
		vendorID = "02602770"
	Case "6001008999987"
		vendorID = "02602650"
	End Select

	DestID = "0000001319131030" & vendorID & "01"

	response.write DestID & "<br>"
										
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
%>