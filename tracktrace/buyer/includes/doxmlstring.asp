<%
	Function MakeSuperXML (DBConnection, CheckDate)
		' Author & Date: Chris Kennedy, 12 August 2002
		' Purpose: This function will build the orders in XML format.
		
		dim SQL
		dim ReturnSet
		dim OrdSet
		dim MyString
		dim DCName
	
		Set ReturnSet = ExecuteSql("exec listCompany @ReceiveTime=" & MakeSQLText(CheckDate),DBConnection)     
				
		' Check the returnvalue
		if ReturnSet("returnvalue") <> 0 Then
			' Set the error message
			MyString = MyString & "<rootnode><pmmessage>"
			MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
			MyString = MyString & "<errormessage>" & ReturnSet("errormessage") & "</errormessage>"
		else
			' There are records returned
			MyString = MyString & "<rootnode><pmmessage>"
			MyString = MyString & "<returnvalue>" & ReturnSet("returnvalue") & "</returnvalue>"
	
			While not ReturnSet.EOF
					
				' Call the sp - listSupplierTrackOrder
				SQL = "exec listBuyerTrackOrder @ReceiveDate=" & MakeSQLText(CheckDate) & _
					", @DCID=" & ReturnSet("DCID")
		
				Set OrdSet = ExecuteSql(SQL,DBConnection)     
					
				' Check if there are records returned
				if OrdSet("returnvalue") = 0 Then

					MyString = MyString & "<dc>"
					MyString = MyString & "<name>" & ReturnSet("DCName") & "</name>"
					
					' Loop through the recordset and build the order XMl string
					While not OrdSet.EOF
						MyString = MyString & "<order>"
						MyString = MyString & "<number>" & OrdSet("OrderNumber") & "</number>"
						MyString = MyString & "<displaynumber>" & Mid(OrdSet("OrderNumber"),1,len(OrdSet("OrderNumber"))-4) & "</displaynumber>"
						MyString = MyString & "<receiveddate>" & OrdSet("ReceiveDate") & "</receiveddate>"
						MyString = MyString & "<receivedtime>" & OrdSet("ReceiveTime") & "</receivedtime>"
						MyString = MyString & "<transdate>" & OrdSet("TransDate") & "</transdate>"
						MyString = MyString & "<transtime>" & OrdSet("TransTime") & "</transtime>"
						MyString = MyString & "<mailboxdate>" & OrdSet("MailboxDate") & "</mailboxdate>"
						MyString = MyString & "<mailboxtime>" & OrdSet("MailboxTime") & "</mailboxtime>"
						MyString = MyString & "<extractdate>" & OrdSet("ExtractDate") & "</extractdate>"
						MyString = MyString & "<extracttime>" & OrdSet("ExtractTime") & "</extracttime>"
						MyString = MyString & "<firstconfirmdate>" & OrdSet("FirstDate") & "</firstconfirmdate>"
						MyString = MyString & "<firstconfirmtime>" & OrdSet("FirstTime") & "</firstconfirmtime>"
						MyString = MyString & "<secondconfirmdate>" & OrdSet("SecondDate") & "</secondconfirmdate>"
						MyString = MyString & "<secondconfirmtime>" & OrdSet("SecondTime") & "</secondconfirmtime>"
						MyString = MyString & "<receivername>" & Replace(OrdSet("SupplierName"),"&","&amp;") & "</receivername>"
						MyString = MyString & "<receivercode>" & OrdSet("SupplierCode") & "</receivercode>"
						MyString = MyString & "<sendername>" & OrdSet("BuyerName") & "</sendername>"
						MyString = MyString & "<sendersurname>" & OrdSet("BuyerSurname") & "</sendersurname>"
						MyString = MyString & "<sendercode>" & OrdSet("BuyerCode") & "</sendercode>"
						MyString = MyString & "<xmlref>" & OrdSet("XMLRef") & "</xmlref>"
						
						' Check if what type of order this is
						if IsNumeric(OrdSet("SupplierCode")) Then
							MyString = MyString & "<type>EDI</type>"
						else
							MyString = MyString & "<type>XML</type>"
						end if
						
						MyString = MyString & "</order>"

						OrdSet.MoveNext
					Wend
					
					MyString = MyString & "</dc>"
				end if
				
				' Close the Recordset
				Set OrdSet = Nothing
				
				ReturnSet.MoveNext
			Wend
		end if
		
		MyString = MyString & "</pmmessage></rootnode>"
			
		' Close the Recordset
		Set ReturnSet = Nothing
		
		'response.write MyString
		'response.end
		
		' Return the String
		MakeSuperXML = MyString
		
	End Function
%>
