<%
Function MakeSQLText(DateToChange)

	dim TempDate
	
	If IsNull(DateToChange) OR DateToChange = "" then
		MakeSQLText = "null"
	else
		MakeSQLText = "'" & DateToChange & "'"
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

	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPARNEW1\SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailFrom = "spar@gatewayec.co.za"
	const const_app_MailTo = "sparmon@gatewaycomms.co.za"
	const const_app_MailCC = "chris.kennedy@gatewaycomms.com; hannes.kingsley@gatewaycomms.com; 0821951@vodacom.co.za"
	const const_app_Error = "atg@gatewaycomms.com"
	const const_app_XMLPath = "F:\SparOrders\"
	const const_app_Path = "F:\FTP_Clients\TigerBrands\In\"
	const const_app_Archive = "F:\FTP_Clients\TigerBrands\Archive\"
	const const_app_RootPath = "F:\"

	' Get the current server date
	ArchiveDate = Replace(FormatDateTime(Date,2),"/","")

	' Create the connection
	Set curConnection = CreateObject("ADODB.Connection")
	curConnection.Open const_db_ConnectionString

	' Create a FileSytem Object
	Set oFile = CreateObject ("Scripting.FileSystemObject")

	'Response.Write const_app_Path
	'Response.End
	
	Set FolderObject = oFile.GetFolder(const_app_Path)

	For Each ImportFileObject In FolderObject.Files
		
		FileName = ImportFileObject.Name
		
		'   Open the Current File For Read Input
		Set TextStreamObject = ImportFileObject.OpenAsTextStream(1, -2)

		'   Read the First Line in the Text Stream
		FileHead = TextStreamObject.ReadLine
		
		OrderNumber = Trim(CDbl(mid(FileHead,2,20)) & GetSuffix(mid(FileHead,35,13)))
		InvoiceNumber = mid(FileHead,63,20)
		SupplierEAN = mid(FileHead,22,13)

		' Build the SQL Statement to update TrackTrace table
		SQL = "exec editTigerInvoice @OrderNumber=" & MakeSQLText(Trim(CDbl(mid(FileHead,2,20))) & GetSuffix(mid(FileHead,35,13))) & _
		", @ExtractTime=" & MakeSQLText("") & _
		", @InvoiceNumber=" & MakeSQLText(mid(FileHead,63,20))

response.write SQL & "<br>"


		' Execute the SQL
		Set ReturnSet = ExecuteSql(SQL, curConnection)

response.write ReturnSet("returnvalue") & "<br>"
'response.end 

		
		' Check the returnvalue
		if ReturnSet("returnvalue") <> 0 then
			' An error occured
			' Check if the folder does not exist
			if Not oFile.FolderExists(const_app_RootPath & "SparErrors\TaxInvoice\" & ArchiveDate) Then
				' Create the folder
				oFile.CreateFolder (const_app_RootPath & "SparErrors\TaxInvoice\" & ArchiveDate)
			end if
			
			Set TextStreamObject = Nothing     
	
			' Save the File to this folder
			oFile.MoveFile const_app_Path & FileName , const_app_RootPath & "SparErrors\TaxInvoice\" & ArchiveDate & "\" & FileName

			strBody = strBody & "E-TIGINV  Tiger Tax Invoice Error" & " " & ReturnSet("errormessage") & " " & Returnset("SupplierName") & "<br><br>"
			strBody = strBody & ReturnSet("errormessage") & "<br><br>"
			strBody = strBody & "Additional information: " & "<br>"
			strBody = strBody & "Date Processed: " & Year(now()) & "/" & Month(now()) & "/" & Day(now()) & "  " & Hour(now()) & ":" & Minute(now()) & ":" & Second(now()) & "<br><br>"
			strBody = strBody & "Supplier EAN: " & SupplierEAN & "<br>"
			strBody = strBody & "Supplier Name: " & Returnset("SupplierName") & "<br>"
			strBody = strBody & "Invoice Number: " & InvoiceNumber & "<br>"
			strBody = strBody & "Referenced Order Number: " & OrderNumber & "<br><br>"
			strBody = strBody & "Solution" & "<br>"
			strBody = strBody & "Please inform Tiger Brands of error." & "<br><br>"
			strBody = strBody & "Technical reference: " & "<br>"
			strBody = strBody & "Invoice error file location: " & const_app_Archive & "error\" & ArchiveDate & "\" & FileName & "<br><br>"
			
			' Call the GenMail function
			Call GenMail(const_app_MailFrom,const_app_Error,const_app_MailCC,"","Spar Tyger Tax Invoice Error", strBody,1,0,0)

		else
			' No error occured - continue
			XMLRef = ReturnSet("XMLRef")
			SupplierName = ReturnSet("SupplierName")

response.write SupplierName & "<br>"
'response.end
			
			Delimiter = ""
			BuyerEmail = ""
					
			' Get the Buyer Email address - Loop through the recordset
			While not ReturnSet.EOF
				BuyerEmail = BuyerEmail & Delimiter & ReturnSet("BuyerEmail")
						
				' Set the delimeter
				Delimiter = "; "
						
				ReturnSet.MoveNext
			Wend

			' Get the Origional xml file to update 
			Set objXML = CreateObject("MSXML2.DomDocument")
			objXML.async = False
			objXML.load (const_app_XMLPath & XMLRef)
				
			' Update the Application ref and invoice number
			objXML.selectSingleNode("//DOCUMENT/UNB/APRF").text = "Source Tax Invoice"
			objXML.selectSingleNode("//DOCUMENT/UNB/SOURCEREFERNCENUMBER").text = mid(FileHead,63,20)
			
			' Get the BuyerCode
			BuyerCode = objXML.selectSingleNode("//DOCUMENT/UNB/UNH/ORD/ORIG/NAME").text
				
			' Close the recordset
			Set ReturnSet = Nothing
	
			' Now read the rest of the line items
			While Not TextStreamObject.AtEndOfStream
				FileLine = TextStreamObject.ReadLine
				
				' Build the SQL Statement to update OrderDetails table
				SQL = "exec editTigerInvoiceDetail @OrderNumber=" & MakeSQLText(Trim(CDbl(mid(FileHead,2,20))) & GetSuffix(mid(FileHead,35,13))) & _
				", @ProdCode=" & MakeSQLText(mid(FileLine,7,14)) & _
				", @Qty=" & MakeSQLText(CInt(mid(FileLine,22,11))) & _
				", @LinePrice=" & MakeSQLText(CDbl(Round(mid(FileLine,33,14),5))) 


response.write SQL
response.end
				

				' Execute the SQL
				Set ReturnSet = ExecuteSql(SQL, curConnection)
		
				' Check the returnvalue
				if ReturnSet("returnvalue") = 0 then
					' No error occured - continue

					' Set the list of lone items for the origional order
					Set LineItems = objXML.selectNodes("//DOCUMENT/UNB/UNH/OLD")
						
					' Loop through this line item collection
					For LineCount = 0 to LineItems.Length-1
					' Check if the EANCNum exists in this XML Doc
						if Trim(mid(FileLine,7,14)) = Trim(LineItems.item(LineCount).selectSingleNode("PROC/SUPC").text) Then
							' Update the origional XML doc with the status, quantity, costprice and netprice
							LineItems.item(LineCount).setAttribute "status", "Confirmed"
							LineItems.item(LineCount).selectSingleNode("QNTO/NROUC").text = CInt(mid(FileLine,22,11))
							LineItems.item(LineCount).selectSingleNode("COST/COSPC").text = CDbl(Round(mid(FileLine,33,14),5))
							LineItems.item(LineCount).selectSingleNode("NELCC").text = LineItems.item(LineCount).selectSingleNode("NELC").text
							LineItems.item(LineCount).selectSingleNode("NARR").text = Trim(LineItems.item(LineCount).selectSingleNode("NARR").text)
						end if
					Next

					' Save the XML Back to the directory
					objXML.save(const_app_XMLPath & XMLRef)
				end if
				
				' Close the recordset
				Set ReturnSet = Nothing
			Wend
			
			' Close the XMLObject
			Set objXML = Nothing

			' Close the textstream object
			Set TextStreamObject = Nothing
			
			' Delete the file from the in folder
			oFile.DeleteFile const_app_Path & FileName, True
			
			' Build the BodyText
			BodyText = "<html><body><p><font face='Arial' size='2'>This e-mail contains information on Purchase Orders sent via Gateway Communications.</font></p>"
			BodyText = BodyText & "<p><font face='Arial' size='2'>Please do not reply to this e-mail.</font></p>" 
			BodyText = BodyText & "<p><font face='Arial' size='2'>The following Purchase Order Confirmation(s) was/were received:</font></p>" 
			BodyText = BodyText & "<p><font face='Arial' size='2'><a href=" & chr(34) & const_app_ApplicationRoot & "/orders/buyer/default.asp?id=" & XMLRef & "&type=1" & chr(34) & ">" & const_app_ApplicationRoot & "/orders/buyer/default.asp</a></font></p>"
			BodyText = BodyText & "<p><font face='Arial' size='2'>Thank You</font></p></body></html>"

			' Create the Mail Object
			Set objMail = CreateObject(const_app_NewMail)

			' Build the rest of the mail object properties
			objMail.From = const_app_MailFrom
			objMail.To = BuyerEmail
			objMail.BCc = const_app_MailTo
			objMail.Subject = "Purchase Order Notification - Order " & OrderNumber & " - Supplier " & SupplierName & " - Buyer " & CStr(BuyerCode)
			objMail.Importance = 2
			objMail.Body = BodyText
			objMail.MailFormat = 0
			objMail.BodyFormat = 0
			objMail.Send

			'Close the mail Object
			
		end if
	Next

	' Close the FolderObject
	Set FolderObject = Nothing
							
	' Close the Object
	Set oFile = Nothing
	
	' Close the Connection
	curConnection.Close
	Set curConnection = Nothing
	
'	Main = DTSTaskExecResult_Success
'End Function
%>