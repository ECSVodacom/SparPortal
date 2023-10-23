<%@ Language=VBScript %>
<%
	' Function GetDCID (id)
		
		' Select Case CStr(id)
		' Case "EST"
			' GetDCID = 1
		' Case "NTH"
			' GetDCID = 2
		' Case "NTL"
			' GetDCID = 3
		' Case "PLZ"
			' GetDCID = 4
		' Case "CPT"
			' GetDCID = 5
		' Case Else
			' GetDCID = 0
		' End Select	
		
	' End Function
	
	' Set curConnection = Server.CreateObject ("ADODB.Connection")
	' curConnection.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
	
	' Set FileObject = Server.CreateObject("Scripting.FileSystemObject")
	' Set FolderObject = FileObject.GetFolder("D:\SparLog\ftp\")
	' Set FolderObject2 = FileObject.GetFolder("D:\SparLog\NewOrder\")
	            
	' For Each ImportFileObject In FolderObject.Files

		' '   Open the Current File For Read Input
		' Set TextStreamObject = ImportFileObject.OpenAsTextStream(1, -2)
	                            
		' '   Read the First Line in the Text Stream
		' While Not TextStreamObject.AtEndOfStream
			' TempString = TextStreamObject.ReadLine
			' LineCount = LineCount + 1
			
			' For Each ImportFileObject2 In FolderObject2.Files

				' '   Open the Current File For Read Input
				' Set TextStreamObject2 = ImportFileObject2.OpenAsTextStream(1, -2)
				
				' DoCheck = False
				                        
				' '   Read the First Line in the Text Stream
				' Do While Not TextStreamObject2.AtEndOfStream
					' TempString2 = TextStreamObject2.ReadLine	
					
					' ' Check if the TempString = TempString2
					' if Trim(TempString) = Trim(TempString2) Then
						' DoCheck = True
					' end if
				' Loop
			' Next
			
			' TempString3 = mid(TempString,5,7)
			
			' SQL = "SELECT COUNT(*) AS OrdCount FROM TrackTrace " & _
			' " INNER JOIN Buyer ON BRID = TRiBuyerID " & _
			' " WHERE TRcOrderNumber LIKE '%" & TempString3 & "%' AND BRiCompanyID=" & GetDCID(Right(TempString,3))
			
			' Response.Write SQL & "<br>"
						
			' Set ReturnSet = ExecuteSql(SQL, curConnection)

			' Response.Write ReturnSet("OrdCount") & "<br>"

			' if ReturnSet("OrdCount") = 0 Then
				' MyResult = " and Not Added to DB"
			' else
				' MyResult = " and Added to DB"
			' end if
			
			' Set ReturnSet = Nothing
			
			' ' Check if the DoCheck = True
			' if DoCheck = False Then
' '				CheckResult = CheckResult & TempString & " - Received" & MyResult & "<br>"
' '			else
				' CheckResult = CheckResult & TempString & " - Not Received" & MyResult & "<br>"
				' CheckCount = CheckCount + 1
			' end if
		' Wend
		
		' Response.Write CheckResult & "<br>"
	' Next

' response.write "Exeptions: " & CheckCount  & "<br>"
' response.write "Total Orders: " & LineCount
	
' ' Close the connection
' curconnection.Close
' Set curConnection = Nothing

%>