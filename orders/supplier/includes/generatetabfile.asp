<%
	function CreateTabFile (objXML, ORNumber)
		' This function will generate a tab delimeted file for the supplier to download to his local drive.
		
		dim objXSL
		dim StrTab
		dim StrFileName
		dim oFile
		dim OpenFile

		' Load the XSL stylesheet
		Set objXSL = Server.CreateObject(const_app_XMLObject)
		objXSL.async = false
		objXSL.Load(Server.MapPath("tabdel.xsl"))
		
		' Set the delimeted file to a string
		StrTab = objXML.TransformNode(objXSL)

		StrFileName = ORNumber & ".txt"
		
		' Create the File System Object
		Set oFile = Server.CreateObject("Scripting.FileSystemObject")
		
		' Create the file
		
		oFile.CreateTextFile const_app_TabFile & StrFileName,true
		
		' Open the text file
		Set OpenFile = oFile.OpenTextFile(const_app_TabFile & StrFileName, 8,false)
		
		' Write to the file
		OpenFile.Write(StrTab)
		
		' Close the Objects
		Set OpenFile = Nothing
		Set oFile = Nothing
		Set objXSL = Nothing
	
	end function
%>