<%
	function DownloadFile (RootName, FilePath, FileName)
		' This function will download a provided file from the server to the user's local disk
		
		dim sFile
		dim sRoot
		dim sDir
		dim sExt
		dim objShell
		dim objFSO
		dim sMIME
		dim objStream
		
		'Response.Write(rootname & "<br>")
		'response.Write(filepath & "<br>")
		'response.Write(filename & "<br>")
		'response.End 
		
		' Make sure this is the same sRoot variable that is defined in browse.asp
		'sRoot = "c:\webfiles"
		sRoot = RootName

		' Get the directory relative to the root folder
		'sDir = Request("dir")
		sDir = FilePath

		' Get the file we're going to show
		'sFile = Request("file")
		sFile = FileName

		' We need to know the MIME type for the file we are about to view.  In
		' order to get this we need to know the file's extension.
		' We could use string functions to get the file extension but we've going
		' to be lazy and use FileSystemObject
		set objFSO = server.CreateObject("Scripting.FileSystemObject")
		sExt = objFSO.GetExtensionName (sFile)
		set objFSO = nothing

		' Now we have the extension, the file's MIME type is held in the registry at
		' HKEY_CLASSES_ROOT\.<ext>\Content Type
		' Create an instance of Wscript.Shell to let us read the registry
		Set objShell = Server.CreateObject("Wscript.Shell")
		On Error Resume Next
		' Get the MIME type
		sMIME = objShell.RegRead("HKEY_CLASSES_ROOT\." & sExt & "\Content Type")

		On Error GoTo 0
		if len(sMIME) = 0 then
			' If there is no registered type then return octetstream.  This will prompt
			' the user with the "Open or Save to disk" dialogue.
			sMIME = "application/octetstream"
		end if
		set objShell = nothing
		
		'response.Write(sMime)
		'response.End 

		Response.AddHeader "content-disposition","attachment; filename=" & filename 

		' Tell the browse the content type
		' Now we need to pipe the file to the browser, to do this we
		' will use the ADODB.Stream
		Set objStream = Server.CreateObject("ADODB.Stream")
		objStream.Open
		' Set the type as Binary
		objStream.Type = 1
		' Load our file
		objStream.LoadFromFile sRoot & sDir & sFile
		
		' Create a connection
		dim curConnection
		Set curConnection = Server.CreateObject("ADODB.Connection")
		curConnection.Open const_db_ConnectionString
		
		SQL = "Exec EditReconDownload @RRDate = " & MakeSQLText(Now()) & _
												", @EANNum = " & MakeSQLText(Session("ProcEAN")) & _
												", @RRFile = " & MakeSQLText(Replace(Request.QueryString("ref"),",","\"))
												
		ExecuteSql SQL, curConnection
		
		
		' And send it to the browser
		Response.BinaryWrite objStream.Read

		objStream.Close
		Set objStream = Nothing	
	end function
%>
