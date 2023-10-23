<%
	Function MQFile (MessType, FileName)
		
		' dim strAction
		' dim Status
		' dim strEDI
		' dim oFile
		' dim strText
		' dim strBatch
		' dim CreateBatch
		' dim Executor
		' dim sResult
		' dim queueName
	
		' Select Case MessType
			' Case "ORDER"
				' queueName = "SPARDS.ORD.RESUB"
			' Case "CLAIM"
				' queueName = "SPARDS.CLM.RESUB"
			' Case "INVOICE"
				' queueName = "SPARDS.INV.RESUB"
			' Case "CREDIT"
				' queueName = "SPARDS.CRN.RESUB"
		' End Select
		
		' ' Create the file system object
		' Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
		' strBatch = Trim(const_app_MQPath & FileName & ".bat")
													
		' ' Create the unique batch file
		' Set CreateBatch = oFile.CreateTextFile(strBatch,true)
											
		' ' Write the following lines to the batch file
		' CreateBatch.WriteLine ("SET MQSERVER=GATE.PRD.CHANNEL1/TCP/196.38.104.55(1414)")
		' CreateBatch.WriteLine ("SET PATH=%PATH%;C:\PROGRA~1\MQSeri~1;C:\PROGRA~1\MQSeri~1\bin")
		' CreateBatch.WriteLine ("SET MQCHLLIB=C:\PROGRA~1\MQSeri~1")
		' CreateBatch.WriteLine ("SET MQCHLTAB=AMQCLCHL.TAB")
		' CreateBatch.WriteLine ("c:\tools\winmqput " & queueName & " GATE.PRD< " & const_app_MQPath & FileName & ".in")

		' Set CreateBatch = Nothing

		' ' Now we need to execute the batch file
		' Set Executor = Server.CreateObject("ASPExec.Execute")
		' Executor.Application = strBatch
		' Executor.Parameters = ""
		' Executor.ShowWindow	= False
		' Executor.TimeOut = 5
		' 'sResult = Executor.ExecuteDosApp
		' sResult = Executor.ExecuteWinApp
											
		' Set Executor = Nothing

		' ' Close the file system object
		' Set oFile = Nothing
		
		' ' return the result string
		' MQFile = sResult
		
	End Function

%>
