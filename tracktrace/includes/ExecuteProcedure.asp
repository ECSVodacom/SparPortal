<%

	Function ExecuteSql(QueryString, ActiveConnection)
		On Error Goto 0
		'On Error Resume Next
		Const adCmdUnknown = &H0008
		Const adCmdText = &H0001
		Const adCmdTable = &H0002
		Const adCmdStoredProc = &H0004
		Const adCmdFile = &H0100
		Const adCmdTableDirect = &H0200

		Dim cmdObj, CommandText, RegEx, RegExResult, ResultCount
		Dim StartIdx, EndIdx, idx, ExtractValue, ParamName, ParamValue
		Set cmdObj =  Server.CreateObject("ADODB.Command")
		Set cmdObj.ActiveConnection = ActiveConnection
		
		cmdObj.NamedParameters = True
		
		QueryString = Trim(QueryString)
		
		If UCase(Left(QueryString,4)) = "EXEC" Then QueryString = Trim(Mid(QueryString,5,Len(QueryString)))
			
		Response.Write QueryString
	
		
		CommandText = Left(QueryString,InStr(QueryString," ")-Len(InStr(QueryString," "))+1)
		
		cmdObj.CommandText = CommandText
		cmdObj.CommandType = &H0004
		

		
		Set RegEx = New RegExp
		
		RegEx.Pattern =  "(@\w+\s*=)"
		RegEx.Global = True
		Set RegExResult = RegEx.Execute(QueryString)
		
		ResultCount = RegExResult.Count
		
		If ResultCount = 0 Then
			cmdObj.CommandText = QueryString 
		
		Else
			StartIdx = InStr(1, QueryString, RegExResult(0))
			For idx = 0 To ResultCount - 1
				If idx = ResultCount - 1 Then
					EndIdx = Len(QueryString) + 1
				Else
					EndIdx = InStr(StartIdx, QueryString, RegExResult(idx + 1))
				End If
				
				ExtractValue = Trim(Mid(QueryString,StartIdx+Len(RegExResult(idx)),EndIdx-StartIdx-Len(RegExResult(idx))))

				
				If Left(ExtractValue,1) = "'" Then 
					ExtractValue = Mid(ExtractValue,2, Len(ExtractValue))
				End If

				
				If Right(ExtractValue,1) = "," Then 
					ExtractValue = Mid(ExtractValue, 1, Len(ExtractValue) - 1)
				End If
				
			
				If Right(ExtractValue,1) = "'" Then 
					ExtractValue = Mid(ExtractValue, 1, Len(ExtractValue) - 1)
				End If
				

				StartIdx = EndIdx
				
				ParamName = Trim(Left(RegExResult(idx),Len(RegExResult(idx))-1))
				ParamValue = Server.HtmlEncode(Trim(ExtractValue))
				
				
				
				If ParamValue <> "" Then cmdObj.Parameters(ParamName) = ParamValue
			Next
		End If
		
		
		Set ExecuteSql = cmdObj.Execute
		
		If Err.Number <> 0 Then
			Response.Clear
			%>
			<div style="color: #a94442;
    background-color: #f2dede;
    border-color: #ebccd1;
    padding: 10px;
    border: 1px solid;
    border-radius: 2px;
	text-align:center;
	font-family:verdana"><strong>An error occured</strong></div></td>
			<%

			On Error Goto 0
			ActiveConnection.Close
			Set ActiveConnection = Nothing
			
			Response.End
		End If
	End Function

%>