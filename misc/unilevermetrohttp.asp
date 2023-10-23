<%@ Language=VBScript %>
<%
'**********************************************************************
'  Visual Basic ActiveX Script
'************************************************************************

'Function Main()

	const const_app_Path = "D:\FTP_CLIENTS\Metro\"
	const const_app_ObjXML = "MSXML2.DomDocument"
	const const_app_ObjHTTP = "MSXML2.XMLHTTP"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "lmakane@gatewaycomms.co.za;sparmon@gatewaycomms.co.za"
	
	server.ScriptTimeout = 100000
	
	dim objSrvHTTP
	dim objXMLSend
	dim objXMLReceive
	
	' Get the current server date
	ArchiveDate = Replace(FormatDateTime(Date,2),"/","")
	
	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
		
	Set Folder = oFile.GetFolder(const_app_Path)
		
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
		
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
		
	if Files_Collection.Count > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name
			
			Response.Write FileName & "<br>"
			'Response.End
			
			' Get the File
			'Set objGetFile = oFile.GetFile(const_app_Path & FileName)	
			
			' Open the text file
			Set FileText = oFile.OpenTextFile(const_app_Path & FileName,1,false)
			
			' Get the XML String from the file
			XMLString = FileText.ReadLine
			
			Set FileText = Nothing
			'Set objGetFile = Nothing
	
			' Check if this is a valid xml file
			Set objXMLSend = CreateObject(const_app_ObjXML)
			objXMLSend.async = false
			
			if objXMLSend.loadXML (XMLString) = false then
				' Not a valid XML file - Send a mail alert to spar monitor
				' Save the File to the error folder
				oFile.MoveFile const_app_Path & FileName ,const_app_Path & "Errors\" & ArchiveDate & "\" & FileName
				
				' Close the XML object
				Set objXML = Nothing
			
				' Create the Mail Object
				Set objMail = CreateObject(const_app_NewMail)
			
				' Build the rest of the mail object properties
				objMail.From = "spar@gatewayec.co.za" 
				objMail.To = const_app_MailCC
				objMail.Cc = "ckennedy@gatewaycomms.co.za"
				objMail.Subject = "Unilever to Metro - XML HTTP Error" 
				objMail.Importance = 2
				objMail.Body = "Invalid XML Order. Source File: " & const_app_Path & "Errors\" & ArchiveDate & "\" & FileName
				objMail.BodyFormat = 1
				objMail.MailFormat = 1
				objMail.Send
		
				' Close the mail Object
				Set objMail = Nothing
				
			else
				' This is a valid xml file - Send the file to Metro via HTTP
				Set HttpRequest = CreateObject(const_app_ObjHTTP)
				Call HttpRequest.open ("POST","http://pathfinder.metro.co.za:8080/cgi-bin/receive.cgi",false)
				HttpRequest.send (XMLString)
				
				Response.Write HttpRequest.Status & "<br>"
				
				' Check the Status of the response
				if HttpRequest.Status <> 200 then
					'HttpRequest.abort()
					' Close the HTTP object
					'Set HttpRequest = Nothing
					
					' Delete the File
					'oFile.MoveFile const_app_Path & FileName ,const_app_Path & "Archive\" & FileName
				'else
					HttpRequest.abort()
					' Close the HTTP object
					Set HttpRequest = Nothing
					
					' The request was not successful - alert the helpdesk
					' Save the File to the error folder
					'oFile.MoveFile const_app_Path & FileName ,const_app_Path & "Errors\" & ArchiveDate & "\" & FileName
				
					' Create the Mail Object
					Set objMail = CreateObject(const_app_NewMail)
			
					' Build the rest of the mail object properties
					objMail.From = "spar@gatewayec.co.za" 
					objMail.To = const_app_MailCC
					objMail.Cc = "ckennedy@gatewaycomms.co.za"
					objMail.Subject = "Unilever to Metro - XML HTTP Error" 
					objMail.Importance = 2
					objMail.Body = "The File was not successfully send through to Metro. Source File: " & const_app_Path & "Errors\" & ArchiveDate & "\" & FileName
					objMail.BodyFormat = 1
					objMail.MailFormat = 1
					objMail.Send
		
					' Close the mail Object
					Set objMail = Nothing
				end if
				
				' Close the HTTP object
				Set HttpRequest = Nothing
				
				 'Save the File to the error folder
				'oFile.MoveFile const_app_Path & FileName ,const_app_Path & "Archive\" & ArchiveDate & "\" & FileName
			end if
			
			
		Next
		
		Set oFile = Nothing
		
	end if

'	Main = DTSTaskExecResult_Success
'End Function
%>