<%@ Language=VBScript %>
<%
' Set the FolderName
FolderName = "c:\SparOut\tax\"

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
	'Set FileText = oFile.OpenTextFile(FolderName & FileName,1,false)
	
	' Create the Dom Document
	Set objXML = Server.CreateObject("Microsoft.XMLDom")
	
	' Load file into dom document
	objXML.async = false
	objXML.Load(FolderName & FileName)
	
	' Get the value of the ordernumber
	TestVal = objXML.selectSingleNode("//UNH/ODD/ORNO/ORNU").text
	
	Response.Write FileName & " - " & TestVal & "<br>"
	
'	if Len(TestVal) = 13 then
		' Save the new value to the xml doc
'		objXML.selectSingleNode("//UNH/ODD/ORNO/ORNU").text = right(TestVal,7)
'
'		Response.Write objXML.selectSingleNode("//UNH/ODD/ORNO/ORNU").text & "<br>"
'	Response.Write "Length = " & Len(Trim(TestVal)) & "(" & FileName & " - " & TestVal & ")" & "<br>"
'	'Response.Write FileName & " - " & TestVal & "<br>"
'	
'		objXML.save(FolderName & FileName)
'	'else
'	'	Response.Write objXML.selectSingleNode("//UNH/ODD/ORNO/ORNU").text & "<br>"
'	end if

	' Close the Document
	Set objXML = Nothing
		
Next

' Close the file system object
Set Files_Collection = Nothing
Set Folder = Nothing
Set oFile = Nothing
%>