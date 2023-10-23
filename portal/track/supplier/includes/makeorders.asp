<%
	Function MakeXMLOrders (DBConnection, SQL)
		' Author & Date: Chris Kennedy, 12 August 2002
		' Purpose: This function will build the orders in XML format.
		
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		
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
			'MyString = MyString & "<suppliername>" & ReturnSet("RecieverName") & "</suppliername>"
			'MyString = MyString & "<supplierean>" & ReturnSet("ReciverEAN") & "</supplierean>"
			
			SupplierName = ""
			StoreName = ""
			
			' Loop through the recordset and build the order XMl string
			While not ReturnSet.EOF
				if SupplierName <> ReturnSet("RecieverName") then
					SupplierName = ReturnSet("RecieverName")
				
					MyString = MyString & "<supplier>"
					MyString = MyString & "<name>" & ReturnSet("RecieverName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("ReciverEAN") & "</eannumber>"
					
					if StoreName = ReturnSet("StoreName") then
						StoreName = ReturnSet("StoreName")
				
						MyString = MyString & "<store>"
						MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					end if
				end if
			
				if StoreName <> ReturnSet("StoreName") then
					StoreName = ReturnSet("StoreName")
				
					MyString = MyString & "<store>"
					MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
				end if
			
				MyString = MyString & "<order id=" & chr(34) & ReturnSet("TraceID") & chr(34) & ">"
				MyString = MyString & "<tracenumber>" & ReturnSet("TraceNumber") & "</tracenumber>"
				MyString = MyString & "<receivedtime>" & ReturnSet("RecieveTime") & "</receivedtime>"
				MyString = MyString & "<transdate>" & ReturnSet("TransTime") & "</transdate>"
				MyString = MyString & "<mailboxtime>" & ReturnSet("MailboxTime") & "</mailboxtime>"
				MyString = MyString & "<extractdate>" & ReturnSet("ExtractDate") & "</extractdate>"
				MyString = MyString & "<extracttime>" & ReturnSet("ExtractTime") & "</extracttime>"
				MyString = MyString & "<confirmdate>" & ReturnSet("ConfirmDate") & "</confirmdate>"
				MyString = MyString & "<confirmtime>" & ReturnSet("ConfirmTime") & "</confirmtime>"
				MyString = MyString & "<invoicecount>" & ReturnSet("IsInvoice") & "</invoicecount>"
				MyString = MyString & "</order>"
				
				ReturnSet.MoveNext
				
				if Not ReturnSet.EOF Then
					CheckName = ReturnSet("StoreName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckSup = ReturnSet("RecieverName")
				end if
				
				if StoreName <> CheckName or SupplierName <> CheckSup or ReturnSet.EOF then
					MyString = MyString & "</store>"
				end if
				
				if SupplierName <> CheckSup or ReturnSet.EOF then
					MyString = MyString & "</supplier>"
				end if
			Wend
		end if
		
		MyString = MyString & "</spmessage>"
		MyString = MyString & "</rootnode>"
		
		'Response.Write Replace(MyString,"&","&amp;")
		'Response.End

		' Close the Recordset
		Set ReturnSet = Nothing
		
		' Return the String
		MakeXMLOrders = Replace(MyString,"&","&amp;")
		
	End Function
	
	function MakeXMLInvoice (DBConnection, SQL)
	
		' Author & Date: Chris Kennedy, 19 Feb 2003
		' Purpose: This function will build the invoices in XML format.
		
		dim ReturnSet
		dim MyString
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim CheckDC
	
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
			
			SupplierName = ""
			StoreName = ""
			
			' Loop through the recordset and build the order XMl string
			While not ReturnSet.EOF
				if SupplierName <> ReturnSet("RecieverName") then
					SupplierName = ReturnSet("RecieverName")
				
					MyString = MyString & "<supplier>"
					MyString = MyString & "<name>" & ReturnSet("RecieverName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("ReciverEAN") & "</eannumber>"
					
					if StoreName = ReturnSet("StoreName") then
						StoreName = ReturnSet("StoreName")
				
						MyString = MyString & "<store>"
						MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					end if
				end if
			
				if StoreName <> ReturnSet("StoreName") then
					StoreName = ReturnSet("StoreName")
				
					MyString = MyString & "<store>"
					MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
				end if
			
				MyString = MyString & "<invoice id=" & chr(34) & ReturnSet("InvoiceID") & chr(34) & ">"
				MyString = MyString & "<invoicenumber>" & ReturnSet("TraceNumber") & "</invoicenumber>"
				MyString = MyString & "<receivedtime>" & ReturnSet("RecieveTime") & "</receivedtime>"
				MyString = MyString & "<transdate>" & ReturnSet("TransTime") & "</transdate>"
				MyString = MyString & "<postdate>" & ReturnSet("PostDate") & "</postdate>"
				MyString = MyString & "<posttime>" & ReturnSet("PostTime") & "</posttime>"
				MyString = MyString & "<orderid>" & ReturnSet("OrderID") & "</orderid>"
				MyString = MyString & "<ordernumber>" & ReturnSet("OrderNumber") & "</ordernumber>"
				MyString = MyString & "</invoice>"
				
				ReturnSet.MoveNext
				
				if Not ReturnSet.EOF Then
					CheckName = ReturnSet("StoreName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckSup = ReturnSet("RecieverName")
				end if
				
				if StoreName <> CheckName or SupplierName <> CheckSup or ReturnSet.EOF then
					MyString = MyString & "</store>"
				end if
				
				if SupplierName <> CheckSup or ReturnSet.EOF then
					MyString = MyString & "</supplier>"
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
