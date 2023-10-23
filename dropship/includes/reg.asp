<%
	TestString = "sp_send_cdosysmail @From='petrus.daffue@vodacom.co.za', @To='0821951@vodacom.co.za',@Cc='petrus.daffue@vodacom.co.za; chris.kennedy@vodacom.co.za',@Subject='SPAR DROP SHIPMENT - REPORT A BUG',@From=9968,@Body='Hello Vodacom Call Centre Analyst " _
& "I''m Petrus Daffue" _
& "" _
& "I am a Store (NJARENKIE) and using the SPAR DropShipment ''Report a Bug'' facility, I have a Complaint about a Orders as below: " _
& "" _
& "Nja,r help" _
& "" _
& "My dsds=contact details are as follows: " _
& "Telephone Number: +27 (11) 1123456" _
& "Cellphone Number: +27 (082) 9980759" _
& "E-Mail Address: petrus.daffue@vodacom.co.za" _
& "" _
& "Thank You' "
		Command = Left(TestString,InStr(TestString," ")-Len(InStr(TestString," "))+1)
		Response.Write Command & "<br/>"
		
		Set RegEx = New RegExp
		
		RegEx.Pattern =  "(@\w+=)"
		RegEx.Global = True
		Set RegExResult = RegEx.Execute(TestString)
		
		ResultCount = RegExResult.Count
		
		StartIdx = InStr(1, TestString, RegExResult(0))
		For idx = 0 To ResultCount - 1
			Response.Write RegExResult(idx) & "<br/>"
		
			If idx = ResultCount - 1 Then
				EndIdx = Len(TestString)
			Else
				EndIdx = InStr(StartIdx, TestString, RegExResult(idx + 1))
			End If

			ExtractValue = Trim(Mid(TestString,StartIdx+Len(RegExResult(idx)),EndIdx-StartIdx-Len(RegExResult(idx)))) 
			Response.Write ExtractValue & "<br/>"
			
			If Left(ExtractValue,1) = "'" Then 
				ExtractValue = Mid(ExtractValue,2, Len(ExtractValue))
			End If
			
			If Right(ExtractValue,1) = "," Then 
				ExtractValue = Mid(ExtractValue, 1, Len(ExtractValue) - 1)
			End If
			
			If Right(ExtractValue,1) = "'" Then 
				ExtractValue = Mid(ExtractValue, 1, Len(ExtractValue) - 1)
			End If

			Response.Write ExtractValue & "<br/>"
			
			StartIdx = EndIdx
		Next
		
%>