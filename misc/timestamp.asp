<%'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************
Function GetSuffix (OrdNum)

	' Check what suffix should be used
	Select Case CStr(OrdNum)
	Case "6001008999956"
		GetSuffix = "sNTH"
	Case "6001008999949"
		GetSuffix = "sERD"
	Case "6001008999963"
		GetSuffix = "sPLZ"
	Case "6001008999970"
		GetSuffix = "sCPT"
	Case "6001008999987"
		GetSuffix = "sNTL"
	Case Else
		GetSuffix = "sNTH"
	End Select
End Function

'Function Main()

	dim oFile
	dim FolderName
	dim Folder
	dim Files_Collection
	dim FileCount
	dim File
	dim FileName
	dim FileText
	dim TempString
	dim TextArray
	dim SQL
	dim ReturnSet
	dim ErrorCount
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	
	' Set the FolderName
	FolderName = "D:\SparTimeStamp\"
	
	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	Set Folder = oFile.GetFolder(FolderName)
	
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
	
	'Response.Write "test"
	'Response.End
	
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
	
		
	if Files_Collection.Count > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name
			
			Response.Write FileName & "<br>"

			' Open the text file
			 Set FileText = File.OpenAsTextStream(1, -2)
	         
	   		 ErrorCount = 0
	   		 MyCount = 0
	                            
			' Read the First Line in the Text Stream
			While Not FileText.AtEndOfStream
				TempString = FileText.ReadLine
				
				TextArray = Split(TempString,",")
				
				MyCount= MyCount + 1

				' Create a connection
				Set curConnection = CreateObject("ADODB.Connection")
				curConnection.Open const_db_ConnectionString
				
				' Biuld the SQL statement
				SQL = "exec editOrderTimeStamp @OrderNumber='" & TextArray(1) & GetSuffix(TextArray(0)) & "'" & _
				", @ExtractTime='" & TextArray(2) & "'"
				
				Response.Write SQL & "<br>"
				
				' Execute the SQL
				Set ReturnSet = ExecuteSql(SQL, curConnection)
				
				' Check the returnvalue
				if ReturnSet("returnvalue") <> 0 Then
					ErrorCount = ErrorCount + 1
					NumberText = NumberText & TextArray(1) &  " - Not Updated" & "<br>"
				else
					'NumberText = NumberText & TextArray(1) & VbCrLf
					NumberText = NumberText & TextArray(1)& " - Updated" & "<br>"
				end if
				
				' Close the recordset
				Set ReturnSet = Nothing
				
				' Close the recordset and connection
				curConnection.Close
				Set curConnection = Nothing

				
			
			Wend
		Response.Write MyCount & " Rows" & "<br>"
			' close the File text Object
			Set FileText = Nothing
		Next
	end if


Response.Write NumberText
	' Check if we can delete the file
	if ErrorCount = 0 Then
		' Check if the file exist
		if oFile.FileExists(FolderName & FileName) then
			' Remove the file from the SparIn Forlder
'			oFile.DeleteFile FolderName & FileName,true
		end if
	end if	

	if NumberText <> "" THen
		' Create the Mail Object
		Set objMail = CreateObject("CDONTS.NewMail")
		
		' Build the rest of the mail object properties
		objMail.From = "spar@gatewayec.co.za"
		objMail.To = "ckennedy@gatewaycomms.co.za"
		objMail.Subject = "Extracted Time stamps alert"
		objMail.Importance = 2
		objMail.Body = "Below is a list of orders, which there were extracted time stamps:" & VbCrLf & VbCrLf & NumberText
		objMail.MailFormat = 1
		objMail.BodyFormat = 1
'		objMail.Send
	
		' Close the mail Object
		Set objMail = Nothing
	end if
	
	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing

'	Main = DTSTaskExecResult_Success
'End Function
%>
