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
		
'		Response.Write SQL
'		Response.End
		
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

				if SupplierName <> CheckSup or StoreName <> CheckName or ReturnSet.EOF then
					MyString = MyString & "</supplier>"
				end if
				
				if StoreName <> CheckName or ReturnSet.EOF then
					MyString = MyString & "</store>"
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
				if StoreName <> ReturnSet("StoreName") then
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

				if SupplierName <> CheckSup or StoreName <> CheckName or ReturnSet.EOF then
					MyString = MyString & "</supplier>"
				end if
				
				if StoreName <> CheckName or ReturnSet.EOF then
					MyString = MyString & "</store>"
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
	
		Function MakeXMLClaims (DBConnection, SQL)
		' Author & Date: Chris Kennedy, 16 August 2004
		' Purpose: This function will build the claims in XML format.
		
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
			
			SupplierName = ""
			StoreName = ""
			
			' Loop through the recordset and build the claim XML string
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
					
						if SupplierName = ReturnSet("SupplierName")then
							SupplierName = ReturnSet("SupplierName")
				
							MyString = MyString & "<supplier>"
							MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
							MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
							MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
						end if
					end if
				end if
			
				if StoreName <> ReturnSet("StoreName") then
					StoreName = ReturnSet("StoreName")
				
					MyString = MyString & "<store>"
					MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					
					if SupplierName = ReturnSet("SupplierName") then
						SupplierName = ReturnSet("SupplierName")
				
						MyString = MyString & "<supplier>"
						MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
						MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
						MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
					end if
				end if
				
				if SupplierName <> ReturnSet("SupplierName") then
					SupplierName = ReturnSet("SupplierName")
				
					MyString = MyString & "<supplier>"
					MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
					MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
				end if
			
				MyString = MyString & "<claim id=" & chr(34) & ReturnSet("ClaimID") & chr(34) & ">"
				MyString = MyString & "<claimnumber>" & ReturnSet("ClaimNum") & "</claimnumber>"
				MyString = MyString & "<claimtype>" & ReturnSet("ClaimType") & "</claimtype>"
				MyString = MyString & "<claimcategory>" & ReturnSet("ClaimCategory") & "</claimcategory>"
				
				dim ReasonSet
				
				if ReturnSet("ReasonCode") = "" or IsNull(ReturnSet("ReasonCode")) then
				
							Set ReasonSet = ExecuteSql("exec itemClaimReason @ClaimID=" & ReturnSet("ClaimID"), curConnection) 
					
					MyString = MyString & "<reasoncode>" & ReasonSet("ReasonCode") & "</reasoncode>"
					
					Set ReasonSet = Nothing
				else				
					MyString = MyString & "<reasoncode>" & ReturnSet("ReasonCode") & "</reasoncode>"
				end if
				
				MyString = MyString & "<receiveddate>" & ReturnSet("ReceivedDate") & "</receiveddate>"
				MyString = MyString & "<receivedtime>" & ReturnSet("ReceivedTime") & "</receivedtime>"
				MyString = MyString & "<transtime>" & ReturnSet("TransTime") & "</transtime>"
				MyString = MyString & "<transdate>" & ReturnSet("TransDate") & "</transdate>"
				MyString = MyString & "<extracttime>" & ReturnSet("ExtractTime") & "</extracttime>"
				MyString = MyString & "<extractdate>" & ReturnSet("ExtractDate") & "</extractdate>"				
				MyString = MyString & "<invid>" & ReturnSet("InvID") & "</invid>"
				MyString = MyString & "<invnum>" & ReturnSet("InvNum") & "</invnum>"
				MyString = MyString & "<invdate>" & ReturnSet("InvDate") & "</invdate>"
				MyString = MyString & "<manualnum>" & ReturnSet("ManualNum") & "</manualnum>"
				MyString = MyString & "<manualdate>" & ReturnSet("ManualDate") & "</manualdate>"
				MyString = MyString & "<cncount>" & ReturnSet("CNCount") & "</cncount>"
				MyString = MyString & "</claim>"
				
				ReturnSet.MoveNext
				
				if Not ReturnSet.EOF Then
					CheckName = ReturnSet("StoreName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckSup = ReturnSet("SupplierName")
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
		MakeXMLClaims = Replace(MyString,"&","&amp;")
		
	End Function
	
	Function MakeXMLCreditNote (DBConnection, SQL)
		' Author & Date: Chris Kennedy, 19 August 2004
		' Purpose: This function will build the credit notes in XML format.
		
		dim ReturnSet
		dim MyString
		dim DCName
		dim SupplierName
		dim StoreName
		dim CheckName
		dim CheckSup
		dim CheckDC
		dim ReasonSet
		
		Response.Write SQL
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
			
			SupplierName = ""
			StoreName = ""
			
			' Loop through the recordset and build the claim XML string
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
					
						if SupplierName = ReturnSet("SupplierName")then
							SupplierName = ReturnSet("SupplierName")
				
							MyString = MyString & "<supplier>"
							MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
							MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
							MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
						end if
					end if
				end if
			
				if StoreName <> ReturnSet("StoreName") then
					StoreName = ReturnSet("StoreName")
				
					MyString = MyString & "<store>"
					MyString = MyString & "<name>" & ReturnSet("StoreName") & "</name>"
					
					if SupplierName = ReturnSet("SupplierName") then
						SupplierName = ReturnSet("SupplierName")
				
						MyString = MyString & "<supplier>"
						MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
						MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
						MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
					end if
				end if
				
				if SupplierName <> ReturnSet("SupplierName") then
					SupplierName = ReturnSet("SupplierName")
				
					MyString = MyString & "<supplier>"
					MyString = MyString & "<name>" & ReturnSet("SupplierName") & "</name>"
					MyString = MyString & "<eannumber>" & ReturnSet("SupplierEAN") & "</eannumber>"
					MyString = MyString & "<storename>" & ReturnSet("StoreName") & "</storename>"
				end if
			
				MyString = MyString & "<cnote id=" & chr(34) & ReturnSet("CreditNoteID") & chr(34) & ">"
				MyString = MyString & "<type>" & ReturnSet("Type") & "</type>"
				
				if ReturnSet("ReasonCode") = "" or IsNull(ReturnSet("ReasonCode")) then
					Set ReasonSet = ExecuteSql(" itemCreditReason @CreditID=" & ReturnSet("CreditNoteID"), curConnection)
					
					MyString = MyString & "<reasoncode>" & ReasonSet("ReasonCode") & "</reasoncode>"
					
					Set ReasonSet = Nothing
				else				
					MyString = MyString & "<reasoncode>" & ReturnSet("ReasonCode") & "</reasoncode>"
				end if
				
				MyString = MyString & "<cnnumber>" & ReturnSet("CreditNoteNum") & "</cnnumber>"
				MyString = MyString & "<receiveddate>" & ReturnSet("ReceivedDate") & "</receiveddate>"
				MyString = MyString & "<receivedtime>" & ReturnSet("ReceivedTime") & "</receivedtime>"
				MyString = MyString & "<transtime>" & ReturnSet("TransTime") & "</transtime>"
				MyString = MyString & "<transdate>" & ReturnSet("TransDate") & "</transdate>"
				MyString = MyString & "<posttime>" & ReturnSet("PostTime") & "</posttime>"
				MyString = MyString & "<postdate>" & ReturnSet("PostDate") & "</postdate>"	
				MyString = MyString & "<dcposttime>" & ReturnSet("DCPostTime") & "</dcposttime>"
				MyString = MyString & "<dcpostdate>" & ReturnSet("DCPostDate") & "</dcpostdate>"			
				MyString = MyString & "<invid>" & ReturnSet("InvID") & "</invid>"
				MyString = MyString & "<invnum>" & ReturnSet("InvNum") & "</invnum>"
				MyString = MyString & "<totclaim>" & ReturnSet("TotalClaims") & "</totclaim>"
				MyString = MyString & "<totcost>" & ReturnSet("CostIncl") & "</totcost>"
				MyString = MyString & "</cnote>"
				
				ReturnSet.MoveNext
				
				if Not ReturnSet.EOF Then
					CheckName = ReturnSet("StoreName")
				end if
				
				if Not ReturnSet.EOF Then
					CheckSup = ReturnSet("SupplierName")
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
		MakeXMLCreditNote = Replace(MyString,"&","&amp;")
		
	End Function
	
	Function MakeCreditNoteItemXML (DBConnection, SQL)
		' Author & Date: Chris Kennedy, 03 Nov 2004
		' Purpose: This function will build the credit note XML doc for the item page.
		
		dim ReturnSet
		dim MyString
		dim LineSet
		dim ReasonSet
		
		'response.Write(sql)
		'response.End 
		
		MyString = "<?xml version=" & chr(34) & "1.0" & chr(34) & "?>"
		MyString = MyString & "<rootnode>"
		MyString = MyString & "<smmessage>"
		
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
			MyString = MyString & "<cnid>" & ReturnSet("cnid") & "</cnid>"
			MyString = MyString & "<storeid>" & ReturnSet("storeid") & "</storeid>"
			MyString = MyString & "<storeean>" & ReturnSet("storeean") & "</storeean>"
			MyString = MyString & "<storename>" & ReturnSet("storename") & "</storename>"
			MyString = MyString & "<storevatno>" & ReturnSet("storevatno") & "</storevatno>"
			MyString = MyString & "<storetel>" & ReturnSet("storetel") & "</storetel>"
			MyString = MyString & "<storefax>" & ReturnSet("storefax") & "</storefax>"
			MyString = MyString & "<storeaddr>" & Replace(ReturnSet("storeaddr"),"&","&amp;") & "</storeaddr>"
			MyString = MyString & "<dcid>" & ReturnSet("dcid") & "</dcid>"
			MyString = MyString & "<dcean>" & ReturnSet("dcean") & "</dcean>"
			MyString = MyString & "<supplierid>" & ReturnSet("supplierid") & "</supplierid>"
			MyString = MyString & "<supplierean>" & ReturnSet("supplierean") & "</supplierean>"
			MyString = MyString & "<suppliername>" & ReturnSet("suppliername") & "</suppliername>"
			MyString = MyString & "<suppliervatno>" & ReturnSet("suppliervatno") & "</suppliervatno>"
			MyString = MyString & "<supplieraddr>" & Replace(ReturnSet("supplieraddr"),"&","&amp;") & "</supplieraddr>"
			MyString = MyString & "<cnnumber>" & ReturnSet("cnnumber") & "</cnnumber>"
			MyString = MyString & "<cndate>" & ReturnSet("cndate") & "</cndate>"
			MyString = MyString & "<numclaim>" & ReturnSet("numclaim") & "</numclaim>"
			MyString = MyString & "<totexcl>" & ReturnSet("totexcl") & "</totexcl>"
			MyString = MyString & "<vat>" & ReturnSet("vat") & "</vat>"
			MyString = MyString & "<totIncl>" & ReturnSet("totincl") & "</totIncl>"
			MyString = MyString & "<tradeindc1>" & ReturnSet("tradeindc1") & "</tradeindc1>"
			MyString = MyString & "<tradeperc1>" & ReturnSet("tradeperc1") & "</tradeperc1>"
			MyString = MyString & "<tradeamt1>" & ReturnSet("tradeamt1") & "</tradeamt1>"
			MyString = MyString & "<tradeindc2>" & ReturnSet("tradeindc2") & "</tradeindc2>"
			MyString = MyString & "<tradeperc2>" & ReturnSet("tradeperc2") & "</tradeperc2>"
			MyString = MyString & "<tradeamt2>" & ReturnSet("tradeamt2") & "</tradeamt2>"
			MyString = MyString & "<transportindc>" & ReturnSet("transportindc") & "</transportindc>"
			MyString = MyString & "<transportperc>" & ReturnSet("transportperc") & "</transportperc>"
			MyString = MyString & "<transportamt>" & ReturnSet("transportamt") & "</transportamt>"
			MyString = MyString & "<dutyindc>" & ReturnSet("dutyindc") & "</dutyindc>"
			MyString = MyString & "<dutyperc>" & ReturnSet("dutyperc") & "</dutyperc>"
			MyString = MyString & "<dutyamt>" & ReturnSet("dutyamt") & "</dutyamt>"
			MyString = MyString & "<isxml>" & ReturnSet("isxml") & "</isxml>"
			
			' Loop through the recordset
			While not ReturnSet.EOF
				' Build the string for the claim part in the xml doc
				MyString = MyString & "<claim>"
				MyString = MyString & "<creditnoteclaimid>" & ReturnSet("creditnoteclaimid") & "</creditnoteclaimid>"
				MyString = MyString & "<claimid>" & ReturnSet("claimid") & "</claimid>"
				MyString = MyString & "<claimnum>" & ReturnSet("claimnum") & "</claimnum>"
				MyString = MyString & "<claimdate>" & ReturnSet("claimdate") & "</claimdate>"
				MyString = MyString & "<invid>" & ReturnSet("invid") & "</invid>"
				MyString = MyString & "<invnum>" & ReturnSet("invnum") & "</invnum>"
				MyString = MyString & "<invdate>" & ReturnSet("invdate") & "</invdate>"
				MyString = MyString & "<claimtype>" & ReturnSet("claimtype") & "</claimtype>"
				
				if ReturnSet("ReasonCode") = "" or IsNull(ReturnSet("ReasonCode")) then
					Set ReasonSet = ExecuteSql("itemCreditReason @CreditID=" & ReturnSet("cnid"), curConnection)
					
					MyString = MyString & "<reasoncode>" & ReasonSet("ReasonCode") & "</reasoncode>"
					
					Set ReasonSet = Nothing
				else				
					MyString = MyString & "<reasoncode>" & ReturnSet("ReasonCode") & "</reasoncode>"
				end if
				
				Set LineSet = ExecuteSql("exec listCreditNoteClaimLine @CreditNoteClaimID = " & ReturnSet("creditnoteclaimid"), DBConnection) 
				
				'Response.Write ("exec listCreditNoteClaimLine @CreditNoteClaimID = " & ReturnSet("creditnoteclaimid"))
				'Response.End 
				
				if LineSet("returnvalue") = 0 then
					While Not LineSet.EOF
						' Build the string for the claim part in the xml doc
						MyString = MyString & "<claimline>"
						MyString = MyString & "<lineid>" & LineSet("lineid") & "</lineid>"
						MyString = MyString & "<prodcode>" & LineSet("prodcode") & "</prodcode>"
						'MyString = MyString & "<proddescr>" & Replace(LineSet("proddescr"),"&","&amp;") & "</proddescr>"
						if LineSet("proddescr") <> "" then
							MyString = MyString & "<proddescr>" & Replace(LineSet("proddescr"),"&","&amp;") & "</proddescr>"
						else
							MyString = MyString & "<proddescr>" & LineSet("proddescr") & "</proddescr>"
						end if
						MyString = MyString & "<uom>" & LineSet("uom") & "</uom>"
						MyString = MyString & "<qty>" & LineSet("qty") & "</qty>"
						MyString = MyString & "<unitprice>" & LineSet("unitprice") & "</unitprice>"
						MyString = MyString & "<grossprice>" & LineSet("grossprice") & "</grossprice>"
						MyString = MyString & "<totmeasure>" & LineSet("totmeasure") & "</totmeasure>"
						MyString = MyString & "<deal1indc>" & LineSet("deal1indc") & "</deal1indc>"
						MyString = MyString & "<deal1perc>" & LineSet("deal1perc") & "</deal1perc>"
						MyString = MyString & "<deal1amt>" & LineSet("deal1amt") & "</deal1amt>"
						MyString = MyString & "<deal2indc>" & LineSet("deal2indc") & "</deal2indc>"
						MyString = MyString & "<deal2perc>" & LineSet("deal2perc") & "</deal2perc>"
						MyString = MyString & "<deal2amt>" & LineSet("deal2amt") & "</deal2amt>"
						MyString = MyString & "<netprice>" & LineSet("netprice") & "</netprice>"
						MyString = MyString & "<vatperc>" & LineSet("vat") & "</vatperc>"
						MyString = MyString & "<vatamt>" & LineSet("vatamt") & "</vatamt>"						
						MyString = MyString & "<totincl>" & LineSet("totincl") & "</totincl>"
						If isNull(LineSet("reasondescr")) Then
							MyString = MyString & "<reasondescr></reasondescr>"
						Else
							MyString = MyString & "<reasondescr>" & Replace(LineSet("reasondescr"),"&","&amp;") & "</reasondescr>"
						End If
						If isNull(LineSet("goodsdescr")) Then
							MyString = MyString & "<goodsdescr></goodsdescr>"
						Else
							MyString = MyString & "<goodsdescr>" & Replace(LineSet("goodsdescr"),"&","&amp;") & "</goodsdescr>"
						End If
						
						If isNull(LineSet("narr")) Then
							MyString = MyString & "<narr></narr>"
						Else
							MyString = MyString & "<narr>" & Replace(LineSet("narr"),"&","&amp;") & "</narr>"
						End If
						
						MyString = MyString & "</claimline>"
						
						LineSet.MoveNext
					Wend
				end if
				
				Set LineSet = Nothing

				MyString = MyString & "</claim>"
				
				ReturnSet.MoveNext
			Wend
		end if
		
		' Close the connection and recordset
		Set ReturnSet = Nothing
		
		MyString = MyString & "</smmessage>"
		MyString = MyString & "</rootnode>"
		
		MakeCreditNoteItemXML = MyString
	End Function

%>
