<%@ Language=VBScript %>
<%
	' Set curConnection = Server.CreateObject ("ADODB.Connection")
	' curConnection.Open "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"

	' Set FileObject = Server.CreateObject("Scripting.FileSystemObject")
	' Set FolderObject = FileObject.GetFolder("D:\SparLog\ftp\")
	            
	' For Each ImportFileObject In FolderObject.Files

		' '   Open the Current File For Read Input
		' Set TextStreamObject = ImportFileObject.OpenAsTextStream(1, -2)
	                            
		' '   Read the First Line in the Text Stream
		' While Not TextStreamObject.AtEndOfStream
			' TempString = TextStreamObject.ReadLine
			' TempString2 = mid(TempString,5,7)
			
			' SQL = "SELECT COUNT(*) AS OrdCount FROM TrackTrace WHERE TRcOrderNumber LIKE '%" & TempString2 & "%'"

			
			' Set ReturnSet = ExecuteSql(SQL, curConnection)
			
			' if ReturnSet("OrdCount") = 0 Then
				' Response.Write TempString & " - Not added <br>"
			' else
				' Response.Write TempString & " - Added <br>"
			' end if
		' Wend
	' Next
	
	' ' Close the connection
	' curconnection.Close
	' Set curConnection = Nothing
%>