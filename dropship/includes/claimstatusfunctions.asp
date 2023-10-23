<%
Dim ClaimStatusDescriptionArray() 

Sub LoadClaimStatusDescriptions(SqlConnection)
	Dim rsStatusDescriptions, iRecordCount, TotalRecords

	iRecordCount = 0
	
	Set rsStatusDescriptions = CreateObject("ADODB.Recordset")
	rsStatusDescriptions.Open "GetClaimStatus", SqlConnection
	If Not (rsStatusDescriptions.EOF And rsStatusDescriptions.BOF) Then
		ReDim ClaimStatusDescriptionArray(rsStatusDescriptions("ClaimStatusCount"),1)		
		While Not rsStatusDescriptions.EOF
			
			ClaimStatusDescriptionArray(iRecordCount,0) = rsStatusDescriptions("Id")
			ClaimStatusDescriptionArray(iRecordCount,1) = rsStatusDescriptions("Value")
	
			iRecordCount = iRecordCount + 1

			rsStatusDescriptions.MoveNext
		Wend
	End If
	rsStatusDescriptions.Close
	Set rsStatusDescriptions  = Nothing
	
	
	
End Sub


Function GetClaimStatusDescription(Id) 
	For idx = 0 To UBound(ClaimStatusDescriptionArray)
	
		If ClaimStatusDescriptionArray(idx, 0) = Id Then
			GetClaimStatusDescription = Replace(ClaimStatusDescriptionArray(idx, 1), " ", "&nbsp;")
			
			Exit Function
		End If
	Next

	GetClaimStatusDescription = "Not found"
End Function

%>
	