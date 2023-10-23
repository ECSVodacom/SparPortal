<!--#include file="adovbs.inc"-->
<%
Function XMLRequest(requestString, requestDropDown, XSLRef ,DoTransform)
	' modified to send multiple requests based on the parameters passed to the sp
	'
	' stream functionality written by CK
	
	
	dim curConnection		' ADODB Connection Object
	dim adoCmd				' ADODB Command Object
	dim adoStreamQuery		' ADODB Stream Object
	dim outStream			' "
	dim RecordSet			' Results String
	dim cmdStream			' ADODB Stream Object
	dim sQuery				' query
	dim sDropDown			' Drop down query
	dim Counter				' Generic Counter for parsing Array requestDropDown
	dim XMLDoc
	dim XSLDoc
	dim DisplaySet

	' set the connection object
	Set curConnection = Server.CreateObject("ADODB.Connection")
	curConnection.ConnectionString = const_db_ConnectionString
	curConnection.Open
	curConnection.CursorLocation = 3'adUseClient
	'curConnection.CursorLocation = 3
										
	' set the command object
	Set adoCmd = Server.CreateObject("ADODB.Command")
	Set adoCmd.ActiveConnection = curConnection
	
	sQuery = "<rootnode xmlns:sql='urn:schemas-microsoft-com:xml-sql'>" 
	sQuery = sQuery & "<sql:query>" & requestString & "</sql:query>"
	
	'	Check whether requestDropDown is an array object
	If IsArray(requestDropDown) then
		'	requestDropDown is an array - cycle through the array, creating the SQL string
		For Counter = 0 to Ubound(requestDropDown)
			sQuery = sQuery & "<dropdownlist><sql:query>" & requestDropDown(Counter) & "</sql:query></dropdownlist>"
		Next
	Else
		'	requestDropDown is not an array - add requestDropDown as required
		sQuery = sQuery & "<dropdownlist><sql:query>" & requestDropDown & "</sql:query></dropdownlist>"
	End If
		
	sQuery = sQuery & "</rootnode>"
		

	'Response.Write("query : " & sQuery)
	'Response.End
													
	' set the stream query
	Set adoStreamQuery = Server.CreateObject("ADODB.Stream")
	adoStreamQuery.Open												' open the command stream so that it can be written to
	adoStreamQuery.WriteText sQuery, 0					' Set the inpyt command streams text with the query string
	adoStreamQuery.Position = 0										' Reset the position in the stream, otherwise it will be at EOF
										
	Set adoCmd.CommandStream = adoStreamQuery						' Set the command object's command to the input stream set above
	adoCmd.Dialect = "{5D531CB2-E6Ed-11D2-B252-00C04F681B71}"		' Set the dialect for the command stream to be a SQL query.
	Set outStream = CreateObject("ADODB.Stream")					' Create the output stream
	outStream.Open
	adoCmd.Properties("Output Stream") = outStream					' Set command's output stream to the output stream just opened    
	adoCmd.Execute , , &H00000400								' Execute the command, thus filling up the output stream.
    
	dim sString 
	outStream.Position = 0
	outStream.Type = 2
	sString = outStream.ReadText(adReadAll)
	
	' Determine if the user requested that the xml should be transformed
	if DoTransform Then
		' Transform the XML
		' Load the String into an XML Dom
		Set XMLDoc = Server.CreateObject(const_app_XMLObject)
		XMLDoc.async = false
		XMLDoc.LoadXML(sString)

		' Load the XSL Style Sheet
		Set XSLDoc = Server.CreateObject(const_app_XMLObject)
		XSLDoc.async = false
		XSLDoc.Load(XSLRef)

		' Transform the xml doc with the xsl doc and return 
		XMLRequest = XMLDoc.TransformNode(XSLDoc)
	else
		' Return the xml string
		XMLRequest = sString
	end if
	
End Function


	function MakeXMLInvoice (DBConnection, SQL)
	
		' Author & Date: Chris Kennedy, 19 Feb 2003
		' Purpose: This function will build the invoices in XML format.
		
		dim ReturnSet
		dim MyString
		dim DCName
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim CheckDC
		
		'Response.Write SQL
		'Response.End
		
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<spmessage>"
		
		' Execute the SQL
		Set ReturnSet = ExecuteSql(SQL, DBConnection)
		
		' Check if there are any errors
		if ReturnSet("returnvalue") <> 0 then
			' An error occured - Build the error message
			MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
			' No errors
			MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
			
			DCName = ""
			SupplierName = ""
			StoreName = ""
			
			' Loop through the recordset and build the order XMl string
			While not ReturnSet.EOF
				if DCName <> ReturnSet("DCName") then
					DCName = ReturnSet("DCName")
					
					MyString = MyString & "<dc>"
					MyString = MyString & "<name>" & ReturnSet("DCName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("DCEAN") & "</eannumber>"
					
					if StoreName = ReturnSet("StoreName") then
						StoreName = ReturnSet("StoreName")
				
						MyString = MyString & "<store>"
						MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					
						if SupplierName = ReturnSet("RecieverName")then
							SupplierName = ReturnSet("RecieverName")
				
							MyString = MyString & "<supplier>"
							MyString = MyString & "<name>" & ReturnSet("RecieverName") & "</name>"
							MyString = MyString & "<eannumber>" & ReturnSet("ReciverEAN") & "</eannumber>"
						end if
					end if
				end if
			
				if StoreName <> ReturnSet("StoreName") then
					StoreName = ReturnSet("StoreName")
				
					MyString = MyString & "<store>"
					MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					
					if SupplierName = ReturnSet("RecieverName") then
						SupplierName = ReturnSet("RecieverName")
				
						MyString = MyString & "<supplier>"
						MyString = MyString & "<name>" & ReturnSet("RecieverName") & "</name>"
						MyString = MyString & "<eannumber>" & ReturnSet("ReciverEAN") & "</eannumber>"
					end if
				end if
				
				if SupplierName <> ReturnSet("RecieverName") then
					SupplierName = ReturnSet("RecieverName")
				
					MyString = MyString & "<supplier>"
					MyString = MyString & "<name>" & ReturnSet("RecieverName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("ReciverEAN") & "</eannumber>"
				end if
			
				MyString = MyString & "<invoice id=" & chr(34) & ReturnSet("InvoiceID") & chr(34) & ">"
				MyString = MyString & "<invoicenumber>" & ReturnSet("TraceNumber") & "</invoicenumber>"
				MyString = MyString & "<receivedtime>" & ReturnSet("RecieveTime") & "</receivedtime>"
				MyString = MyString & "<transdate>" & ReturnSet("TransTime") & "</transdate>"
				MyString = MyString & "<postdate>" & ReturnSet("PostDate") & "</postdate>"
				MyString = MyString & "<posttime>" & ReturnSet("PostTime") & "</posttime>"
				MyString = MyString & "<dcpostdate>" & ReturnSet("DCPostDate") & "</dcpostdate>"
				MyString = MyString & "<dcposttime>" & ReturnSet("DCPostTime") & "</dcposttime>"
				MyString = MyString & "<orderid>" & ReturnSet("OrderID") & "</orderid>"
				MyString = MyString & "<ordernumber>" & ReturnSet("OrderNumber") & "</ordernumber>"
				
				MyString = MyString & "<ClaimId>" & ReturnSet("ClaimId") & "</ClaimId>"
				MyString = MyString & "<ClaimNumber>" & ReturnSet("ClaimNumber") & "</ClaimNumber>"
				MyString = MyString & "<CreditNoteId>" & ReturnSet("CreditNoteId") & "</CreditNoteId>"
				MyString = MyString & "<CreditNoteNumber>" & ReturnSet("CreditNoteNumber") & "</CreditNoteNumber>"
				
				MyString = MyString & "</invoice>"
				
				ReturnSet.MoveNext
				
				if Not ReturnSet.EOF Then
					CheckName = ReturnSet("StoreName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckSup = ReturnSet("RecieverName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckDC = ReturnSet("DCName")
				end if
				
				if SupplierName <> CheckSup or StoreName <> CheckName or DCName <> CheckDC or ReturnSet.EOF then
					MyString = MyString & "</supplier>"
				end if
				
				if StoreName <> CheckName or DCName <> CheckDC or ReturnSet.EOF then
					MyString = MyString & "</store>"
				end if
				
				if DCName <> CheckDC or ReturnSet.EOF then
					MyString = MyString & "</dc>"
				end if
			Wend
		end if
		
		MyString = MyString & "</spmessage>"
		MyString = MyString & "</rootnode>"
		
		' Close the Recordset
		Set ReturnSet = Nothing
		
		' Return the String
		MakeXMLInvoice = Replace(MyString,"&","&amp;")
	
	end function
%>
