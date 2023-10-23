
<%	
	Function PostToBiz(FileName, Content, DcEan, ScheduleId)
		'Response.Write "Sending off"
	'	On Error Resume NExt
		If Len(Content) = 0 Then
			PostToBiz = True
		
			Exit Function
		End If
	
		'On Error Resume Next
	
			Set httpRequest = Server.CreateObject("MSXML2.XMLHTTP")
		httpRequest.Open "POST", "http://192.168.200.200:9080/msgsrv/http?from=SPARSCHEDULES&to=" & DcEan & "&filename=" & FileName, False
		httpRequest.SetRequestHeader "Content-Type", "text/xml"
		httpRequest.Send Content

		postResponse = httpRequest.ResponseText

		Set httpRequest = Nothing
		'Response.Write postResponse
		If Err.Number <> 0 Then
			'If Err.Number = -2147467259 Then Response.Write "Unabled to relased schedule"
			
			PostToBiz = False
		Else
			Set ScheduleConnection = Server.CreateObject("ADODB.Connection")
			ScheduleConnection.Open const_db_ConnectionString
			ExecuteSql "editScheduleStatus @ScheduleId=" & ScheduleId & ",@StatusId=5", ScheduleConnection
			ScheduleConnection.Close
			Set ScheduleConnection = Nothing
			
			PostToBiz = True
			
		
		End If
		
		
		
		
		'Response.End
		On Error Goto 0
	End Function

	Function DoPost(ScheduleId, ScheduleFileName)
	
		'Dim ScheduleId
		'ScheduleId = Replace(Request.QueryString("Id"),"'","''")
		ScheduleFileName = Replace(ScheduleFileName," ","")
		ScheduleFileName = Server.URLEncode(ScheduleFileName)
		Interchange = Year(now()) & month(now()) & day(now()) & hour(now()) & minute(now()) & second(now()) & ScheduleFileName & ScheduleId
		'Response.Write "Interchange"
		CreditNote = ""
		Invoice = ""
		
		Set cnObj = Server.CreateObject("ADODB.Connection")
		cnObj.Open const_db_ConnectionString
		'Response.Write "Schedule to CSV"
		'Response.Write "ScheduleToCsv @Id=" & ScheduleId
		Set rsObj =  ExecuteSql("ScheduleToCsv @Id=" & ScheduleId, cnObj)  
		If Not (rsObj.BOF And rsObj.EOF) Then
			While Not rsObj.EOF
				DcEan = rsObj("DcEan")
				ScheduleType = rsObj("ScheduleType")
				LineItem = ""
				
				For Each Item In rsObj.Fields
					LineItem = LineItem & rsObj(Item.Name)  & ","
				Next 
				LineItem = Left(LineItem,Len(LineItem)-1)

			
				If (CDbl(rsObj("AmountInclusive")) < 0) Then
					CreditNote = CreditNote & LineItem & vbCrlf
				Else
					Invoice = Invoice & LineItem & vbCrlf
				End If
				
			
				rsObj.MoveNext
			Wend
		Else
			NoRecord = True
		End If
		cnObj.Close
		
		'Response.Write "Schedule to CSV Done"
		If Not NoRecord Then
			InvoiceFileName = "INV" & Interchange & ".csv.Z:SPARSCHEDULES.Z:" & DcEan
			If ScheduleType = "A" Then InvoiceFileName = "ADMIN" & InvoiceFileName
			InvoiceSuccess = PostToBiz(InvoiceFileName, Invoice, DcEan, ScheduleId)
			
			CreditNoteFileName = "CRED" & Interchange & ".csv.Z:SPARSCHEDULES.Z:" & DcEan
			If ScheduleType = "A" Then CreditNoteFileName = "ADMIN" & CreditNoteFileName
			CreditNoteSuccess = PostToBiz(CreditNoteFileName, CreditNote, DcEan, ScheduleId)

			If (InvoiceSuccess And CreditNoteSuccess) Then
				DoPost = "0"
				'Response.Write "{ ""delivered"": true }"
			Else
				DoPost = "-1" 
				'Response.Write "{ ""delivered"": false }"
				Response.Write "<table><tr><td class='pcontent color: red' align='left'><b><font color='red'>We were unable to release this schedule " 	 &  hour(now()) & ":" & minute(now()) & ":" & second(now())  & " </font></b></tr></table>" 
				
			End If
		Else 
			DoPost = "-1" 
			Response.Write "<table><tr><td class='color: red' align='left'><b><font color='red'>Could not release schedule , one or more stores are in a closed status</font></b></tr></table>"
			'Response.Write "{ ""delivered"": false }"
		End If
		
		Set cnObj = Nothing
	End Function
%>
