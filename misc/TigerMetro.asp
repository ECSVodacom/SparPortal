<%@ Language=VBScript %>
<%
	'const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=TECHNICAL_03"
	'const const_app_TigerPath = "C:\FTP_CLIENTS\TigerBrands\Metro\"
	
	const const_db_ConnectionString = "Provider=SQLOLEDB.1;Persist Security Info=True;User Id=SparUser;Password=qalp;Initial Catalog=Spar;Data Source=SPAR"
	const const_app_TigerPath = "D:\FTP_CLIENTS\TigerBrands\Metro\"
	const const_app_NewMail = "CDONTS.NewMail"
	const const_app_MailCC = "ckennedy@gatewaycomms.co.za"
	
	Response.Write const_app_TigerPath
	
	' Creat the FileSystem Object
	Set oFile = CreateObject("Scripting.FileSystemObject")
	
	Set Folder = oFile.GetFolder(const_app_TigerPath)
	
	' Get a collection of the files in this folder
	Set Files_Collection = Folder.Files
	
	' Check if there are files in the folder
	FileCount = Files_Collection.Count
	
	' Check if there are any files in this folder
	if FileCount > 0 Then
		' loop through the files in the folder
		For each File in Files_Collection
			' Get the filename
			FileName = File.Name

			' Get the File
			Set objGetFile = oFile.GetFile(const_app_TigerPath & FileName)		

			' Create the Mail Object
			Set objMail = Server.CreateObject(const_app_NewMail)
		
			' Build the rest of the mail object properties
			objMail.From = "spar@gatewayec.co.za"
			objMail.To = const_app_MailCC
			objMail.Subject = "NEW METRO INVOICE"
			objMail.AttachFile const_app_TigerPath & FileName,FileName,1 									
			objMail.MailFormat = 0
			objMail.BodyFormat = 0
			objMail.Body = ""
			objMail.Send
		
			' Close the mail Object
			Set objMail = Nothing
			
			' Remove the file from the folder
			oFile.DeleteFile const_app_TigerPath & FileName, True
		Next
	end if
	
	' Close the objects
	Set Files_Collection = Nothing
	Set Folder = Nothing
	Set oFile = Nothing
%>