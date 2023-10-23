<%
	Function GenEDI (RefNumber, XMLString, strPath)
		
		' dim strAction
		' dim Status
		' dim strEDI
		' dim oFile
		' dim MQFile
		' dim strText
		' dim strBatch
		' dim CreateBatch
		' dim Executor
		' dim sResult
							
		' ' Create the file system object
		' Set oFile = Server.CreateObject("Scripting.FileSystemObject")
											
		' ' Create the unique mq file
		' Set MQFile = oFile.CreateTextFile(strPath & RefNumber & ".xml",true)
											
		' ' Write the edi test to the unique mq file
		' MQFile.WriteLine (XMLString)
											
		' Set MQFile = Nothing
											
		' strText = Trim(strPath & RefNumber & ".xml")
		' strBatch = Trim(strPath & RefNumber & ".bat")
											
		' ' Create the unique batch file
		' Set CreateBatch = oFile.CreateTextFile(strPath & RefNumber & ".bat",true)
											
		' ' Write the following lines to the batch file
		' CreateBatch.WriteLine ("SET MQSERVER=GATE.TST.SPARWEB/TCP/196.38.104.55(1416)")
		' CreateBatch.WriteLine ("SET MQCHLLIB=C:\MQCLIENT")
		' CreateBatch.WriteLine ("SET MQCHLTAB=AMQCLCHL.TAB")
		' CreateBatch.WriteLine ("c:mqclient\bin\winmqput GATE.TST.SPAR.DSXMLTAXINV GATE.TST < " & Trim(strPath & RefNumber & ".xml"))

		' Set CreateBatch = Nothing

		' Now we need to execute the batch file
		'Set Executor = Server.CreateObject("ASPExec.Execute")
		'Executor.Application = strBatch
		'Executor.Parameters = ""
		'Executor.ShowWindow = True
		'Executor.TimeOut = 5
		'sResult = Executor.ExecuteWinApp
										
		'Set Executor = Nothing

		' Close the file system object
		'Set oFile = Nothing
		
	End Function

%>
