<%
	
	' Set the FolderName
	FolderName = "F:\SparDS\Errors\Invoices\050812"
	SaveFolder = "F:\SparDS\Invoices"
	
	RecDate = "2005/08/12 08:28:13"
	TransDate = "2005/08/12 08:28:13"
	ConfDate = "2005/08/12 08:28:14"

	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	
	Set Folder = oFile.GetFolder(FolderName)
	
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
	
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
	
	' loop through the files in the folder
	For each File in Files_Collection
		' Get the filename
		FileName = File.Name

		' Open the text file
		Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)

		' Read the first line of the file
		StrText = FileText.ReadAll
		
		Set FileText = Nothing
		
		StrText = Replace(StrText,"<recievedate></recievedate>","<recievedate>2005/08/12 08:28:13</recievedate>")
		StrText = Replace(StrText,"<translatedate></translatedate>","<translatedate>2005/08/12 08:28:13</translatedate>")
		StrText = Replace(StrText,"<confirmdate></confirmdate>","<confirmdate>2005/08/12 08:28:14</confirmdate>")
		
		Set OpenFile = oFile.OpenTextFile(SaveFolder & FileName & ".txt", 8,true) 
		
		OpenFile.WriteLine StrText
		
		Set OpenFile = Nothing

	next
	
	set oFile = Nothing
	
	Response.Write "DONE !!!"
	

%>