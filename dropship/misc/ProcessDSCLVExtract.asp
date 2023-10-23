<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

Function MakeSQLDate(DateToChange)

	dim TempDate
	
	If IsNull(DateToChange) OR DateToChange = "" then
		MakeSQLDate = "null"
	else
		MakeSQLDate = "'" & DateToChange & "'"
	end if
	
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
			
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=SparDS;Data Source=SPARNEW1\SPAR"
	const const_app_ApplicationRoot = "https://spar.gatewayec.co.za/"
	const const_app_MailFrom = "spar.gatewayec.co.za/"
	const const_app_MailTo = "sparmon@gatewaycomms.co.za"
			
	' Set the FolderName	
	FolderName = "F:\SparDS\Extract\clv\"
			
	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	Set Folder = oFile.GetFolder(FolderName)
			
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
			
	' Check if there are files in the folder
	FileCount = Files_Collection.Count

	if Files_Collection.Count > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name
	
			' Open the text file
			 Set FileText = File.OpenAsTextStream(1, -2)
			         
	   		 ErrorCount = 0
			                            
			' Read the First Line in the Text Stream
			While Not FileText.AtEndOfStream
				TempString = FileText.ReadLine

response.write TempString & "<br>"
				
				TextArray = Split(TempString,",")
		
				' Create a connection
				Set curConnection = CreateObject("ADODB.Connection")
				curConnection.Open const_db_ConnectionString

				' Check if the array has more than 1 element
				if UBound(TextArray) > 0 then
					SQL = "exec editClvExtractTime @OrderNumber='" & TextArray(0) & "'" & _
					", @StoreEAN='" & TextArray(1) & "'" & _
					", @ExtractTime=" & MakeSQLDate(TextArray(2)) 

response.write SQL & "<br>"
'response.end		
					' Execute the SQL
					Set ReturnSet = ExecuteSql(SQL, curConnection)

response.write ReturnSet("returnvalue") & "<br>"
							
					' Check the returnvalue
					if ReturnSet("returnvalue") <> 0 Then
						ErrorCount = ErrorCount + 1
					end if
							
					' Close the recordset
					Set ReturnSet = Nothing
				end if
						
				' Close the recordset and connection
				curConnection.Close
				Set curConnection = Nothing
			Wend
				
			' close the File text Object
			Set FileText = Nothing

			' Check if we can delete the file
'			if ErrorCount = 0 Then
				' Check if the file exist
'				if oFile.FileExists(FolderName & FileName) then
'					' Remove the file from the SparIn Forlder
'					oFile.DeleteFile FolderName & FileName,true
'				end if
'			end if	
		Next
	end if

	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing

'	Main = DTSTaskExecResult_Success
'End Function

%>