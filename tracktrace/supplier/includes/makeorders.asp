<%
	Function MakeXMLOrders (DBConnection, StrXML, SPID, BRID, CheckDate)
		' Author & Date: Chris Kennedy, 12 August 2002
		' Purpose: This function will build the orders in XML format.
		
		dim SQL
		dim OrdSet
		dim MyString
		
		'MyString = StrXML
		
		' Call the sp - listSupplierTrackOrder
		SQL = "listSupplierTrackOrder @SupplierID=" & SPID & _
			", @BuyerID=" & BRID & _
			", @ReceiveDate=" & MakeSQLText(CheckDate)
				
				'Response.Write SQL
		' Execute the SQL
		Set OrdSet = ExecuteSql(SQL, DBConnection) 
		
		' Petrus Update Order Number
		Dim OrderNumberArray
		
		
		' Loop through the recordset and build the order XMl string
		While not OrdSet.EOF
			OrderNumberArray = Split(LCase(OrdSet("OrderNumber")),"s")
			MyString = MyString & "<order>"
			MyString = MyString & "<number>" & OrdSet("OrderNumber") & "</number>"
			MyString = MyString & "<displaynumber>" & OrderNumberArray(0) & "</displaynumber>"
			'MyString = MyString & "<displaynumber>" & Mid(OrdSet("OrderNumber"),1,len(OrdSet("OrderNumber"))-4) & "</displaynumber>"
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
			MyString = MyString & "<xmlref>" & OrdSet("XMLRef") & "</xmlref>"
			MyString = MyString & "</order>"
			
			OrdSet.MoveNext
		Wend
		
		' Close the Recordset
		Set OrdSet = Nothing
		
		' Return the String
		MakeXMLOrders = MyString
		
	End Function
%>
